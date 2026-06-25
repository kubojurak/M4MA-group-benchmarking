# This is the script used to compare the speeds of the old 
# and new archetypes as a function of group size

# 1. Load the predped package
library(predped) # Needs to be the new version of predped with the new archetypes

# 2. Set the seed for reproducibility
set.seed(2026)

# 3. Define a long corridor environment for testing
test_setting <- background(
  shape = rectangle(center = c(0, 0), size = c(8, 20)),
  objects = list(
    rectangle(center = c(0, 9), size = c(1, 1), forbidden = 1:3)
  ),
  entrance = c(0, -10)
)

# 4. Loop for group sizes from 1 to 6, saving the unpacked trace and plot gif
types = c("SocialBaselineEuropean", "Colleagues", "Families", "Friends")

# Loop
for (type in types) {
    my_predped <- predped(
        setting = test_setting,
        archetypes = c(type),
        weights = c(1.0)
    )

    for (i in 1:6) {
        trace <- simulate(
            my_predped,
            max_agents = i,
            iterations = 300,
            add_agent_after = 500000, # So only one group enters
            initial_agents = list(),
            group_size = matrix(c(i, 1), nrow = 1),
            goal_number = 1,
            cpp = FALSE
        )
        
        # Define output directory for trace data
        output_dir <- file.path("archetypes", "speed_results")
        trace_data <- unpack_trace(trace)
        saveRDS(trace_data, file.path(output_dir, paste0("trace_", type, "_", i, ".Rds")))

        # Create the plot
        plt <- plot(trace)

        # Save the plot as a gif
        name <- paste0("plot_", type, "_", i, ".gif")

        gifski::save_gif(
            lapply(plt, print),
            file.path(output_dir, name),
            delay = 1/10
        )

        print(paste("Done with group size", i, "for type", type))
    }
}

# 5. Print completion message
print("Done with all simulations!")