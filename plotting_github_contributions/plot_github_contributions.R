library(tidyverse)
library(tidyjson)

# process and plot github contribution data
# Mark Stenglein 4/30/2025

# this function process one year's worth of github contribution data.
# It assumes there is a file named <year>.json
# that contains data exported from the github GraphQL API as described above
process_one_year <- function(year) {
  
  filename = paste0(year, ".json")
  contributions <- read_json(filename)
  
  # dig down through the json data structure to get at the data we want
  weeks <- contributions %>% 
    enter_object(data) %>% 
    enter_object(user) %>% 
    enter_object(contributionsCollection) %>%
    enter_object(contributionCalendar) %>%
    enter_object(weeks) 
  
  # continue to dig into json data structure
  days <- weeks %>%
    gather_array %>%
    enter_object(contributionDays) %>%
    gather_array("index.2")
  
  # turn into a tidy data frame (tibble)
  contribution_counts <- days %>% spread_all %>% select(contributionCount, date, -..JSON)
  contribution_counts <- as_tibble(contribution_counts)
  
  # return it
  contribution_counts

}


# process all the years
years <- seq(2014, 2026)

# this line of code does 2 things: it calls the above function on the vector of years using lapply
# lapply returns a list of tibbles, which we want to concatenate into a single tibble
# use bind_rows to concatenate all the individual tibbles in the list
all_year_data <- bind_rows(lapply(years, process_one_year))

# tabulate cumulative sum of contributions
all_year_data <- all_year_data %>% mutate(cumulative_contributions = cumsum(contributionCount))

# make sure data column is in a data format, using lubridate as_date
all_year_data$date <- as_date(all_year_data$date)

# plot cumulative contributions
ggplot (filter(all_year_data, date < today())) +
  geom_point(aes(x=date, y=cumulative_contributions), 
             shape=21, size=3, fill="coral3", color="black", stroke=0.05) +
  theme_bw(base_size = 14) +
  xlab("") +
  ylab("Cumulative contributions") +
  ylim(c(0,1150)) +
  ggtitle("Cumulative contributions to stenglein-lab github repositories since arrival at CSU")

# save as a PDF
ggsave("cumulative_github_contributions.pdf", units="in", width=10, height=7.5)
# save as PNG
ggsave("cumulative_github_contributions.png", units="in", width=10, height=7.5)
