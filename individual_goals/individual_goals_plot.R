library(tidyverse)
library(jtools)

# 1. Pointing to the trace data 
trace_data <- readRDS("individual_goals/results/individual_goals.Rds")

# 2. Prepare the data for plotting
plot_trace <- trace_data %>%
    select(time, id, x, y, goal_id, goal_x, goal_y) %>%
    mutate(
        id = as.character(id),

        # Use case_when to categorize the three distinct phases into 'objective'
        objective = case_when(
            goal_id == "goal exit" ~ "Exit",
            goal_id == "goal milei" ~ "Shared Goal",
            TRUE ~ "Individual Goal" # Captures all the random stall IDs
        )
    )

# 3. Extract the unique goal locations for plotting
goals_df <- plot_trace %>%
    select(goal_id, goal_x, goal_y, objective) %>%
    distinct() %>%
    drop_na(goal_x, goal_y) # Ensures missing coordinates (if any) don't break the plot

# 4. Create the plot
ggplot() +
    # Draw the Room Boundaries (20m x 20m)
    geom_rect(aes(xmin = -10, xmax = 10, ymin = -10, ymax = 10),
              fill = "white", color = "black", linewidth = 1) +

    # Draw the 4 objects (2x2 boxes centered at +/-6, +/-6)
    geom_rect(aes(xmin = 5, xmax = 7, ymin = 5, ymax = 7),
              fill = "gray70", color = "black") +     # Top-Right
    geom_rect(aes(xmin = 5, xmax = 7, ymin = -7, ymax = -5),
              fill = "gray70", color = "black") +     # Bottom-Right
    geom_rect(aes(xmin = -7, xmax = -5, ymin = 5, ymax = 7),
              fill = "gray70", color = "black") +     # Top-Left
    geom_rect(aes(xmin = -7, xmax = -5, ymin = -7, ymax = -5),
              fill = "gray70", color = "black") +     # Bottom-Left

    # Draw the continuous paths mapped to our 'objective' variable
    geom_path(data = plot_trace,
              aes(x = x, y = y,
                  color = id,
                  linetype = objective,
                  group = interaction(id, objective)),
              alpha = 0.7, linewidth = 0.5) +

    # Plot the specific goal locations
    geom_point(data = goals_df,
               aes(x = goal_x, y = goal_y, shape = objective),
               size = 2.0, color = "black", fill = "indianred") +

    # Lock the coordinates to the room size
    coord_fixed(ratio = 1, xlim = c(-10, 10), ylim = c(-10, 10), expand = TRUE) +

    # Agent coloring
    scale_color_viridis_d(
        name = "Agent",
        end = 0.8
    ) +

    # Map the three distinct phases to different linetypes
    scale_linetype_manual(
        values = c(
            "Shared Goal" = "solid",
            "Individual Goal" = "dashed",
            "Exit" = "dotted"
        )
    ) +

    # Map the goals to specific filled shapes
    scale_shape_manual(
        values = c(
            "Shared Goal" = 23,
            "Individual Goal" = 21,
            "Exit" = 22
        )
    ) +

    labs(
        x = "x (m)",
        y = "y (m)",
        linetype = "Path Objective",
        shape = "Goal Location"
    ) +

    theme_minimal() +
    theme(legend.position = "right",
          plot.margin = margin(0, 0, 0, 0))

