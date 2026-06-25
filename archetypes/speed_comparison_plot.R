library(tidyverse)
library(jtools)

# 1. Define the directory and get all RDS file paths
output_dir_traces <- file.path("archetypes", "results")

trace_files <- list.files(
  path = output_dir_traces, 
  pattern = "\\.Rds$",       
  full.names = TRUE
)

# 2. Define a function to process a single file
process_single_trace <- function(file_path) {
  
  # Load the data
  data <- readRDS(file_path) # Use read.csv() if you saved as CSV
  
  # Calculate summary statistics
  mean_spd <- mean(data$speed, na.rm = TRUE)
  sd_spd <- sd(data$speed, na.rm = TRUE)
  
  # Extract the filename to identify the run (e.g., "trace_SocialBaselineEuropean_1.Rds")
  # We remove the path and the extension to keep it clean
  run_name <- basename(file_path) %>% str_remove("\\.Rds$")

  # Split the filename string by the underscore "_"
  # This creates a vector: c("trace", "SocialBaselineEuropean", "1")
  name_parts <- str_split(run_name, "_")[[1]]
  
  # Extract the specific pieces into their own variables
  archetype_val <- name_parts[2]
  group_size_val <- as.numeric(name_parts[3]) # Converted to numeric for plotting
  
  # Return a single-row data frame
  data.frame(
    archetype = archetype_val,
    group_size = group_size_val,
    mean_speed = mean_spd,
    sd_speed = sd_spd
  )
}

# 3. Process all trace files and combine into a single data frame
summary_df <- map_dfr(trace_files, process_single_trace)

# 4. Create the plot
ggplot(summary_df, aes(x = group_size, y = mean_speed, 
                       color = archetype, group = archetype)) +
  geom_point(size = 1.5) +
  geom_line(linewidth = 0.7) + 
  scale_x_continuous(breaks = 1:6) + 
  scale_y_continuous(limits = c(0, 1.5)) +  
  
  # Combined the color mapping and the 'drop = FALSE' rule into one scale
  scale_color_manual(
    values = c(
      "SocialBaselineEuropean" = "#6baed6", 
      "Colleagues" = "#fc8d59", 
      "Families" = "#d4a520", 
      "Friends" = "#3a5e1f"
    ),
    drop = FALSE 
  ) +
  
  labs(
    # title = "Mean Speed by Group Size and Archetype",
    x = "Group Size",
    y = "Mean Speed (m/s)",
    color = "Archetype"
  ) +
theme_minimal() +
theme(
    axis.line.x = element_line(color = "black", linewidth = 0.5),
    axis.ticks.x = element_line(color = "black", linewidth = 0.5),
    legend.position = "right"
  )