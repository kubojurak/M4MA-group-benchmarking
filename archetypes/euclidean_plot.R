library(tidyverse)
library(jtools)

# 1. Define the folder path containing the RDS files
input_dir <- file.path("archetypes", "euclidean_results")

# 2. STRICT PATTERN: Only grab files formatted as 'trace_[Name]_[Number].Rds'
rds_files <- list.files(path = input_dir, pattern = "^trace_[A-Za-z]+_\\d+\\.Rds$", full.names = TRUE)

# 3. Read all files, calculate distances, and combine into one dataframe
all_distances <- map_dfr(rds_files, function(file_path) {

    file_name <- basename(file_path)

    # Extract archetype and iteration
    parts <- str_match(file_name, "trace_([A-Za-z]+)_(\\d+)\\.Rds")

    # Failsafe: If the filename somehow doesn't match, skip it
    if (is.na(parts[1, 1])) return(NULL)

    arch <- str_to_title(parts[1, 2])
    iter <- as.numeric(parts[1, 3])

    trace_data <- readRDS(file_path)

    distance_df <- trace_data %>%
        select(time, id, x, y, goal_id) %>%
        mutate(id = as.character(id)) %>%
        group_by(time) %>%
        filter(n() == 2) %>%
        summarize(
            distance = sqrt(diff(x)^2 + diff(y)^2),
            .groups = "drop"
        ) %>%
        mutate(
            archetype = arch,
            iteration = iter,
            run_id = paste(arch, iter, sep = "_")
        )

    return(distance_df)
})

# 4. Final failsafe to strip out any accidental NA archetypes
all_distances <- all_distances %>% filter(!is.na(archetype))


# 5. Group by time and archetype, then calculate the mean distance across all 100 runs
avg_distances <- all_distances %>%
    group_by(archetype, time) %>%
    summarize(
        mean_distance = mean(distance, na.rm = TRUE),
        .groups = "drop"
    )

# 6. Calculate your max Y dynamically based on the newly averaged data
max_y <- max(avg_distances$mean_distance, na.rm = TRUE) * 1.2


# 7. Create a new column with the APA letters attached
avg_distances <- avg_distances %>%
    mutate(
        apa_label = case_when(
            archetype == "Colleagues" ~ "(a) Colleagues",
            archetype == "Couples"    ~ "(b) Couples",
            archetype == "Families"   ~ "(c) Families",
            archetype == "Friends"    ~ "(d) Friends"
        )
    )

# 8. Define the custom thresholds matching the new APA labels
threshold_df <- data.frame(
    apa_label = c("(a) Colleagues", "(b) Couples", "(c) Families", "(d) Friends"),
    threshold = c(0.851, 0.714, 0.863, 0.792)
)

# 9. Plotting with ggplot2, using the new APA labels
ggplot(avg_distances, aes(x = time, y = mean_distance)) +
    # Plot a single, solid line representing the average for each archetype
    geom_line(aes(color = apa_label), linewidth = 1) +
    geom_hline(data = threshold_df, aes(yintercept = threshold), color = "red", linetype = "dashed", linewidth = 0.8) +
    # Facet by the new APA labels
    facet_wrap(~ apa_label, scales = "free_x") +
    scale_color_manual(
        values = c(
            "(a) Colleagues" = "#fc8d59",
            "(c) Families" = "#d4a520",
            "(d) Friends" = "#3a5e1f",
            "(b) Couples" = "#6baed6"
        ),
        drop = FALSE
    ) +
    labs(
        x = "Simulation Time (s)",
        y = "Average Euclidean Distance (m)"
    ) +
    theme_minimal() +
    theme(
        legend.position = "none",
        strip.text = element_text(size = 12, hjust = 0),
        panel.spacing = unit(1, "lines")
    ) +
    # Zoom the plot safely
    coord_cartesian(xlim = c(0, 50), ylim = c(0, max_y))
