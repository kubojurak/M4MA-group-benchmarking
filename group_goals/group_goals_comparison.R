# This script demonstrates how group goals were handled in
# the old version and new version of predped. It depends on the
# current version of the package downloaded.

# 1. Load the predped package
library(predped) # Old or New version


# 2. Set the seed for reproducibility
set.seed(2026) # Set the seed for reproducibility

# 3. Define a basic environment for testing
basic_environment <- background(

  # 20*20 room
  shape = rectangle(center = c(0, 0), size = c(20, 20)),
  
  # The four interactable boxes
  objects = list(
    rectangle(center = c(6, 6), size = c(2, 2)),
    rectangle(center = c(6, -6), size = c(2, 2)),
    rectangle(center = c(-6, 6), size = c(2, 2)),
    rectangle(center = c(-6, -6), size = c(2, 2))
  ),
  
  # Entrance and Exit
  entrance = c(0, -10),
  exit = c(0, 10)
)


# 3. Set up the predped 
my_predped <- predped(
  setting = basic_environment,
  archetypes = c("SocialBaselineEuropean"), # If its the old version use old archetypes
  weights = c(1.0)
)

# 4. Simulate the Model
trace <- simulate(
  my_predped,
  max_agents = 4, # Feel free to use any group size
  iterations = 500,
  initial_agents = list(),
  add_agent_after = 500000,
  group_size = matrix(c(4, 1), nrow = 1), # Feel free to use any group size
  goal_number = 5, # Number of group goals
  cpp = FALSE
)

# 5. Unpack the trace and save it as an RDS file

output_dir <- file.path("group_goals", "results")

trace_data <- unpack_trace(trace)

saveRDS(trace_data, file.path(output_dir, 'old_M4MA.Rds'))

# 6. Create the plot and save it as a gif

plt <- plot(trace)

gifski::save_gif(
  lapply(plt, print),
  file.path(output_dir, "old_M4MA.gif"),
  delay = 1/10
)

# 7. Final confirmation message
print("Done!")