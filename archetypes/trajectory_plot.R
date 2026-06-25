library(tidyverse)
library(jtools)

# 1. Select the trace you want to plot
trace_data <- readRDS("path/to/your/trace.Rds")


# 2. Extract the necessary columns, including goal_id to determine direction
plot_trace <- trace_data %>%
  select(time, id, x, y, goal_id) %>%
  mutate(
    id = as.character(id),
    # Create the direction label based on the goal_id column
    direction = ifelse(goal_id == "goal exit", "Exit", "Goal")
  )



# 3. Create snapshots every 5 time steps based on your preference
snapshot_interval <- 5 # Your Preferred Interval
snapshots_df <- plot_trace %>% filter(time %% snapshot_interval == 0)

# 4. Create the plot
ggplot() +
  # Draw the Corridor Walls
  geom_rect(aes(xmin = -4, xmax = 4, ymin = -10, ymax = 10),
            fill = "white", color = "black", linewidth = 1) +

  # Draw the Obstacle
  geom_rect(aes(xmin = -0.5, xmax = 0.5, ymin = 8.5, ymax = 9.5),
            fill = "gray70", color = "black") +

  # Draw the continuous paths with DIRECTIONAL linetypes
  geom_path(data = plot_trace,
            aes(x = x, y = y,
                color = id,
                linetype = direction,
                group = interaction(id, direction)),
            alpha = 0.5, linewidth = 0.5) +

  # Draw the snapshot points
  geom_point(data = snapshots_df, aes(x = x, y = y, color = id, shape = direction),
             size = 2.5) +

  coord_fixed(ratio = 1, xlim = c(-4, 4), ylim = c(-10, 10), expand = TRUE) +
    scale_color_viridis_d(
        name = "Color",
        end = 0.8,
        labels = c("Agent 1", "Agent 2") # This renames the items in the legend
    ) +

    # Map "Going" to a solid line, and "Returning" to a dashed line
    scale_linetype_manual(values = c("Goal" = "solid", "Exit" = "dashed")) +

    # NEW: Map specific shapes to the directions (16 = Circle, 17 = Triangle)
    scale_shape_manual(values = c("Goal" = 15, "Exit" = 16)) +

  labs(
    x = "x (m)",
    y = "y (m)",
    linetype = "Objective",
    shape = "Objective"

  ) +
  theme_minimal() +
    theme(legend.position = "none",
          plot.margin = margin(0, 0, 0, 0))

# Save the plot as a PDF
ggsave("c.pdf", width = 3, height = 7.5, units = "in")
