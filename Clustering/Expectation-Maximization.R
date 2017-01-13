# http://varianceexplained.org/r/mixture-models-baseball/

library(dplyr)
library(tidyr)
library(Lahman)
library(ggplot2)
theme_set(theme_bw())

# Identify those who have pitched at least three games
pitchers <- Pitching %>%
  group_by(playerID) %>%
  summarize(gamesPitched = sum(G)) %>%
  filter(gamesPitched > 3)

# in this setup, we're keeping some extra information for later in the post:
# a "bats" column and a "year" column
career <- Batting %>%
  filter(AB > 0, lgID == "NL", yearID >= 1980) %>%
  group_by(playerID) %>%
  summarize(H = sum(H), AB = sum(AB), year = mean(yearID)) %>%
  mutate(average = H / AB,
         isPitcher = playerID %in% pitchers$playerID)

# Add player names
career <- Master %>%
  tbl_df() %>%
  dplyr::select(playerID, nameFirst, nameLast, bats) %>%
  unite(name, nameFirst, nameLast, sep = " ") %>%
  inner_join(career, by = "playerID")

# plot

set.seed(2016)

# We'll fit the clusters only with players that have had at least 20 at-bats
starting_data <- career %>%
  filter(AB >= 20) %>%
  select(-year, -bats, -isPitcher) %>%
  mutate(cluster = factor(sample(c("A", "B"), n(), replace = TRUE)))

starting_data %>%
  ggplot(aes(average, color = cluster)) +
  geom_density()


library(VGAM)

fit_bb_mle <- function(x, n) {
  # dbetabinom.ab is the likelihood function for a beta-binomial
  # using n, alpha and beta as parameters
  ll <- function(alpha, beta) {
    -sum(dbetabinom.ab(x, n, alpha, beta, log = TRUE))
  }
  m <- stats4::mle(ll, start = list(alpha = 3, beta = 10), method = "L-BFGS-B",
                   lower = c(0.001, .001))
  ab <- stats4::coef(m)
  data_frame(alpha = ab[1], beta = ab[2], number = length(x))
}


fit_bb_mle(starting_data$H, starting_data$AB)

fits <- starting_data %>%
  group_by(cluster) %>%
  do(fit_bb_mle(.$H, .$AB)) %>%
  ungroup()

fits


fits <- fits %>%
  mutate(prior = number / sum(number))

fits



crosses <- starting_data %>%
  select(-cluster) %>%
  crossing(fits) %>%
  mutate(likelihood = prior * VGAM::dbetabinom.ab(H, AB, alpha, beta))

crosses



assignments <- starting_data %>%
  select(-cluster) %>%
  crossing(fits) %>%
  mutate(likelihood = prior * VGAM::dbetabinom.ab(H, AB, alpha, beta)) %>%
  group_by(playerID) %>%
  top_n(1, likelihood) %>%
  ungroup()

assignments

ggplot(assignments, aes(average, fill = cluster)) +
  geom_histogram()



set.seed(1337)

iterate_em <- function(state, ...) {
  fits <- state$assignments %>%
    group_by(cluster) %>%
    do(mutate(fit_bb_mle(.$H, .$AB), number = nrow(.))) %>%
    ungroup() %>%
    mutate(prior = number / sum(number))
  
  assignments <- assignments %>%
    select(playerID:average) %>%
    crossing(fits) %>%
    mutate(likelihood = prior * VGAM::dbetabinom.ab(H, AB, alpha, beta)) %>%
    group_by(playerID) %>%
    top_n(1, likelihood) %>%
    ungroup()
  
  list(assignments = assignments,
       fits = fits)
}

library(purrr)

iterations <- accumulate(1:5, iterate_em, .init = list(assignments = starting_data))


fit_iterations <- iterations %>%
  map_df("fits", .id = "iteration")

fit_iterations %>%
  crossing(x = seq(.001, .4, .001)) %>%
  mutate(density = prior * dbeta(x, alpha, beta)) %>%
  ggplot(aes(x, density, color = iteration, group = iteration)) +
  geom_line() +
  facet_wrap(~ cluster)


batter_100 <- career %>%
  filter(AB == 100) %>%
  arrange(average)

batter_100



career_likelihoods <- career %>%
  filter(AB > 20) %>%
  crossing(final_parameters) %>%
  mutate(likelihood = prior * VGAM::dbetabinom.ab(H, AB, alpha, beta)) %>%
  group_by(playerID) %>%
  mutate(posterior = likelihood / sum(likelihood))

career_assignments <- career_likelihoods %>%
  top_n(1, posterior) %>%
  ungroup()


career_assignments %>%
  filter(posterior > .8) %>%
  count(isPitcher, cluster) %>%
  spread(cluster, n)


batting_data <- career_likelihoods %>%
  ungroup() %>%
  filter(AB == 100) %>%
  mutate(name = paste0(name, " (", H, "/", AB, ")"),
         name = reorder(name, H),
         alpha1 = H + alpha,
         beta1 = AB - H + beta)

batting_data %>%
  crossing(x = seq(0, .4, .001)) %>%
  mutate(posterior_density = posterior * dbeta(x, alpha1, beta1)) %>%
  group_by(name, x) %>%
  summarize(posterior_density = sum(posterior_density)) %>%
  ggplot(aes(x, posterior_density, color = name)) +
  geom_line(show.legend = FALSE) +
  geom_vline(aes(xintercept = average), data = batting_data, lty = 2) +
  facet_wrap(~ name) +
  labs(x = "Batting average (actual average shown as dashed line)",
       y = "Posterior density after updating")


eb_shrinkage <- career_likelihoods %>%
  mutate(shrunken_average = (H + alpha) / (AB + alpha + beta)) %>%
  group_by(playerID) %>%
  summarize(shrunken_average = sum(posterior * shrunken_average))

