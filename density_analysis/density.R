# 1. Load the predped package
library(predped) # Must be new predped for new archetypes

# 2. Set the seed for reproducibility
set.seed(2026)

# 3. Doubled version of the original supermarket environment
supermarket_doubled <- background(
  # 1. The original L-Shape scaled 2x to a 20x20 footprint
  shape = polygon(
    points = cbind(
      c(0, 0, 10, 10, 20, 20), 
      c(0, 10, 10, 20, 20, 0)
    )
  ), 

  objects = list(
    # --- 2. TOP RIGHT ZONE (Vertical Shelves) ---
    # Scaled from 0.7x4 to 1.4x8. 
    # Centers multiplied by 2 (X: 12, 15, 18). Leaves 1.6m of clearance between shelves.
    rectangle(center = c(15, 14), size = c(1.4, 8)),
    rectangle(center = c(12, 14), size = c(1.4, 8)),
    rectangle(center = c(18, 14), size = c(1.4, 8)),

    # --- 3. BOTTOM LEFT ZONE (Horizontal Shelves) ---
    # Scaled from 4x0.7 to 8x1.4.
    # Centers multiplied by 2 (Y: 2, 5). Leaves 1.6m of clearance between shelves.
    rectangle(center = c(6, 5), size = c(8, 1.4)),
    rectangle(center = c(6, 2), size = c(8, 1.4)),

    # --- 4. CENTRAL MIXING BOX ---
    # Scaled from 2x2 to 4x4.
    rectangle(center = c(15, 5), size = c(4, 4)),

    # --- 5. THE CHECKOUT BOTTLENECK ---
    # Scaled 2x to maintain exact funnel proportions relative to the store.
    polygon(
      points = cbind(
        c(2, 4.5, 4.5, 5, 5, 2), 
        c(7.5, 7.5, 8.5, 8.5, 7, 7)
      ), 
      interactable = FALSE
    ),
    rectangle(
      center = c(7, 8.5), 
      size = c(0.5, 3), 
      interactable = FALSE
    )
  ),

  # Spawn node doubled from (1, 5) to (2, 10)
  entrance = c(2, 10),

  # --- ONE-DIRECTIONAL FLOW CONTROL ---
  # Segments doubled to block the exact scaled funnel boundaries
  limited_access = list(
    segment(from = c(2, 7), to = c(0, 7)),
    segment(from = c(5, 8.5), to = c(6.75, 8.5))
  )
)

# Plot to verify the doubled aisles and 20x20 footprint
plot(supermarket_doubled, segment.hjust = 1)


# 4. Set up the predped model with the doubled supermarket environment
my_predped <- predped(
    setting = supermarket_doubled,
    archetypes = c("Friends"), # Change archetypes to desired one
    weights = c(1.0)
)

# 5. Simulate the model with the doubled supermarket environment
trace <- simulate(
    my_predped,
    max_agents = 20,
    iterations = 7200, # 1 hour of time
    initial_agents = list(),
    #group_size = matrix(c(1,1), nrow = 1), # only use for individuals
    group_size = matrix(c(1, 0.6491, 2, 0.2629, 3, 0.0710, 4, 0.0144, 5, 0.0023, 6, 0.0003), nrow = 6, byrow = TRUE), # only use for groups
    cpp = FALSE
)

# 6. Define output directory for trace data and save it
output_dir <- file.path("density_analysis", "results")
trace_data <- unpack_trace(trace)
saveRDS(trace_data, file.path(output_dir, "trace_supermarket_Friends.Rds"))


# 7. Create the plot and save it as a gif
plt <- plot(trace)

gifski::save_gif(
    lapply(plt, print),
    file.path(output_dir, "Friends.gif"),
    delay = 1/10
)