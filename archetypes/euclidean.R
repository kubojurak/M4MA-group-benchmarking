# This is the script used to create a 100 simulations
# for each of the new archetypes. Used for creating the 
# euclidean distance comparison plots.

# 1. Load the predped package
library(predped) # Needs to be the new version of predped with the new archetypes

# 2. Set the seed for reproducibility
set.seed(2026)

# 3. Define a long corridor environment for testing
test_environment <- background(
  shape = rectangle(center = c(0, 0), size = c(8, 20)),
  objects = list(
    # Top-Left (Adjusted y to 1.5 to stay inside the 4m width)
    rectangle(center = c(0, 9), size = c(1, 1), forbidden = 1:3)
  ),
  entrance = c(0, -10)
)

# 4. Define the nested folder path and ensure it exists
output_dir <- file.path("archetypes", "euclidean_results")

# 5. Define target archetypes and number of iterations
archetype_list <- c("Colleagues", "Couples", "Families", "Friends")
num_iterations <- 100

# Loop 
for (arch in archetype_list) {
  
  # Run the simulation 100 times for the current archetype
  for (i in 1:num_iterations) {
    
    # Link Agent Characteristics to the Environment
    my_predped <- predped(
      setting = test_environment,
      archetypes = c(arch),
      weights = c(1.0)
    )
    
    # Simulate the Model
    trace <- simulate(
      my_predped,
      max_agents = 2,
      iterations = 200,
      add_agent_after = 500000,
      initial_agents = list(),
      group_size = matrix(c(2, 1), nrow = 1),
      goal_number = 1, 
      #individual_goal_number = 0,
      cpp = FALSE
    )
    
    # Unpack and Save the Results (GIF generation removed)
    trace_data <- unpack_trace(trace)
    
    # Generate an informative file name (e.g., trace_colleagues_1.Rds)
    file_name <- paste0("trace_", tolower(arch), "_", i, ".Rds")
    
    saveRDS(trace_data, file.path(output_dir, file_name))
    
    # Optional: Print progress to the console
    cat(sprintf("Successfully saved: %s\n", file_name))
  }
}

# 6. Final confirmation message
print("Done!")