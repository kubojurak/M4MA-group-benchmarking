library(tidyverse)
library(jtools)

# 1. Load the trace data
trace_data <- readRDS("data/trace_data.rds")
# The actual trace files are not included in thi repository due to their size. 
# Please contact the author if you would like to obtain the trace data for this project.

# 2. Extract the necessary columns
plot_trace <- trace_data %>%
    filter(status == "move") %>%
    select(x, y)

# 3. Store Outline (Polygon)
# Adding the starting point at the end to ensure the line closes perfectly
store_outline <- data.frame(
  x = c(0, 0, 10, 10, 20, 20, 0),
  y = c(0, 10, 10, 20, 20, 0, 0)
)

# 4. Checkout Bottleneck Funnel (Polygon)
funnel_poly <- data.frame(
  x = c(2, 4.5, 4.5, 5, 5, 2, 2),
  y = c(7.5, 7.5, 8.5, 8.5, 7, 7, 7.5)
)

# 5. Shelves, Mixing Box, and Checkout Box (Rectangles)
layout_rects <- data.frame(
  xmin = c(14.3, 11.3, 17.3, 2, 2, 13, 6.75),
  xmax = c(15.7, 12.7, 18.7, 10, 10, 17, 7.25),
  ymin = c(10, 10, 10, 4.3, 1.3, 3, 7),
  ymax = c(18, 18, 18, 5.7, 2.7, 7, 10)
)



# 6. Create the density plot
ggplot(plot_trace, aes(x = x, y = y)) +

  # We use alpha to make the heat map slightly transparent
  geom_density_2d_filled(alpha = 0.75, show.legend = FALSE) +
  scale_fill_viridis_d(option = "magma") +

  # A thick white border with no fill to frame the store
  geom_polygon(data = store_outline, aes(x = x, y = y),
               fill = NA, color = "white", linewidth = 1.2, inherit.aes = FALSE) +

  # We map the rectangles directly using geom_rect
  geom_rect(data = layout_rects,
            aes(xmin = xmin, xmax = xmax, ymin = ymin, ymax = ymax),
            fill = "gray20", color = "white", alpha = 0.9, inherit.aes = FALSE) +

  # The checkout funnel polygon
  geom_polygon(data = funnel_poly, aes(x = x, y = y),
               fill = "gray20", color = "white", alpha = 0.9, inherit.aes = FALSE) +

    # Small vertical arrow pointing through the bottleneck area
    annotate("segment", x = 5.8, y = 7, xend = 5.8, yend = 8,
             color = "white", linewidth = 0.8,
             arrow = arrow(length = unit(0.15, "cm"), type = "closed")) +

    # Small vertical arrow pointing through the bottleneck area
    annotate("segment", x = 1.2, y = 8, xend = 1.2, yend = 7,
             color = "white", linewidth = 0.8,
             arrow = arrow(length = unit(0.15, "cm"), type = "closed")) +

  # coord_fixed forces an exact 1:1 aspect ratio so the store doesn't look stretched
  coord_fixed(ratio = 1) +

  theme_void() + # Removes all background gridlines for a clean blueprint look
  theme(plot.background = element_rect(fill = "black")) # Dark background to make magma pop
