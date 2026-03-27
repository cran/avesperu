## ----include = FALSE----------------------------------------------------------
knitr::opts_chunk$set(
  collapse = TRUE,
  comment = "#>",
  fig.width = 8,
  fig.height = 4.8,
  fig.align = "center"
)

## ----setup, echo=FALSE--------------------------------------------------------
library(avesperu)
library(ggplot2)

old <- aves_peru_2025_v5
new <- aves_peru_2026_v1

old_date <- attr(old, "version_date", exact = TRUE)
new_date <- attr(new, "version_date", exact = TRUE)

added <- new[!(new$scientific_name %in% old$scientific_name), ]
removed <- old[!(old$scientific_name %in% new$scientific_name), ]
shared_species <- intersect(old$scientific_name, new$scientific_name)

status_order <- c(
  "Residente",
  "Endémico",
  "Migratorio",
  "Divagante",
  "Introducido",
  "No confirmado",
  "Extirpado"
)

count_status <- function(x, levels) {
  out <- table(factor(x, levels = levels))
  as.integer(out)
}

status_tbl <- data.frame(
  status = status_order,
  n_2025 = count_status(old$status, status_order),
  n_2026 = count_status(new$status, status_order),
  stringsAsFactors = FALSE
)
status_tbl$change <- status_tbl$n_2026 - status_tbl$n_2025

summary_tbl <- data.frame(
  dataset = c("aves_peru_2025_v5", "aves_peru_2026_v1"),
  version_date = c(old_date, new_date),
  species = c(nrow(old), nrow(new)),
  orders = c(length(unique(old$order_name)), length(unique(new$order_name))),
  families = c(length(unique(old$family_name)), length(unique(new$family_name))),
  stringsAsFactors = FALSE
)

order_levels <- sort(unique(c(added$order_name, removed$order_name)))
turnover_by_order <- data.frame(
  order_name = order_levels,
  added = as.integer(table(factor(added$order_name, levels = order_levels))),
  removed = as.integer(table(factor(removed$order_name, levels = order_levels))),
  stringsAsFactors = FALSE
)
turnover_by_order$net_change <- turnover_by_order$added - turnover_by_order$removed
turnover_by_order <- turnover_by_order[
  turnover_by_order$added > 0 | turnover_by_order$removed > 0,
]

fam_old <- table(old$family_name)
fam_new <- table(new$family_name)
family_levels <- sort(unique(c(names(fam_old), names(fam_new))))

family_delta <- data.frame(
  family_name = family_levels,
  n_2025 = as.integer(fam_old[family_levels]),
  n_2026 = as.integer(fam_new[family_levels]),
  stringsAsFactors = FALSE
)
family_delta[is.na(family_delta)] <- 0L
family_delta$change <- family_delta$n_2026 - family_delta$n_2025
family_delta <- family_delta[family_delta$change != 0, ]
family_delta <- family_delta[order(family_delta$change, family_delta$family_name), ]

plot_theme <- theme_minimal(base_size = 12) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    plot.subtitle = element_text(color = "#51606F"),
    panel.grid.minor = element_blank(),
    panel.grid.major.y = element_blank(),
    legend.title = element_blank(),
    legend.position = "top"
  )

## ----summary-table------------------------------------------------------------
knitr::kable(summary_tbl, caption = "High-level comparison of the two checklist versions")

## ----total-species-plot-------------------------------------------------------
summary_plot_tbl <- summary_tbl
summary_plot_tbl$release <- c("2025 v5", "2026 v1")

ggplot(summary_plot_tbl, aes(x = release, y = species, fill = release)) +
  geom_col(width = 0.62, color = NA) +
  geom_text(aes(label = species), vjust = -0.5, fontface = "bold", size = 4.2) +
  scale_fill_manual(values = c("2025 v5" = "#4C67B0", "2026 v1" = "#69B3E7")) +
  scale_y_continuous(
    expand = expansion(mult = c(0, 0.08)),
    labels = scales::comma
  ) +
  labs(
    title = "Net checklist growth between releases",
    subtitle = "The 2026 update adds 6 species relative to the 2025 release",
    x = NULL,
    y = "Number of species"
  ) +
  plot_theme +
  theme(legend.position = "none")

## ----status-table-------------------------------------------------------------
knitr::kable(status_tbl, caption = "Species counts by status in each dataset version")

## ----status-delta-plot--------------------------------------------------------
status_plot_tbl <- status_tbl
status_plot_tbl$direction <- ifelse(status_plot_tbl$change >= 0, "Increase", "Decrease")
status_plot_tbl$label <- ifelse(
  status_plot_tbl$change > 0,
  paste0("+", status_plot_tbl$change),
  as.character(status_plot_tbl$change)
)
status_plot_tbl$status <- factor(status_plot_tbl$status, levels = rev(status_plot_tbl$status))

ggplot(status_plot_tbl, aes(x = status, y = change, fill = direction)) +
  geom_col(width = 0.72) +
  geom_hline(yintercept = 0, linetype = 2, color = "#7A8793") +
  geom_text(
    aes(
      label = label,
      hjust = ifelse(change >= 0, -0.15, 1.15)
    ),
    size = 4
  ) +
  coord_flip() +
  scale_fill_manual(values = c("Increase" = "#4B8A5F", "Decrease" = "#B34A3C")) +
  scale_y_continuous(expand = expansion(mult = c(0.08, 0.12))) +
  labs(
    title = "Net change by status category",
    subtitle = "Vagrants and residents explain most of the checklist growth",
    x = NULL,
    y = "Change in number of species"
  ) +
  plot_theme

## ----added-table--------------------------------------------------------------
knitr::kable(
  added[, c("scientific_name", "english_name", "status", "family_name", "order_name")],
  caption = "Species added in aves_peru_2026_v1"
)

## ----removed-table------------------------------------------------------------
knitr::kable(
  removed[, c("scientific_name", "english_name", "status", "family_name", "order_name")],
  caption = "Species removed from the previous checklist version"
)

## ----turnover-order-plot------------------------------------------------------
turnover_plot_tbl <- rbind(
  data.frame(order_name = turnover_by_order$order_name, movement = "Added", n = turnover_by_order$added),
  data.frame(order_name = turnover_by_order$order_name, movement = "Removed", n = turnover_by_order$removed)
)
turnover_plot_tbl <- turnover_plot_tbl[turnover_plot_tbl$n > 0, ]
turnover_plot_tbl$order_name <- factor(
  turnover_plot_tbl$order_name,
  levels = turnover_by_order$order_name[order(turnover_by_order$net_change, decreasing = TRUE)]
)

ggplot(turnover_plot_tbl, aes(x = order_name, y = n, fill = movement)) +
  geom_col(position = position_dodge(width = 0.72), width = 0.62) +
  geom_text(
    aes(label = n),
    position = position_dodge(width = 0.72),
    vjust = -0.45,
    size = 3.8
  ) +
  scale_fill_manual(values = c("Added" = "#69B3E7", "Removed" = "#D98C6A")) +
  scale_y_continuous(expand = expansion(mult = c(0, 0.1))) +
  labs(
    title = "Species turnover by order",
    subtitle = "Most additions and all removals occur in Passeriformes",
    x = NULL,
    y = "Number of species"
  ) +
  plot_theme +
  theme(axis.text.x = element_text(angle = 20, hjust = 1))

## ----family-table-------------------------------------------------------------
knitr::kable(
  family_delta,
  caption = "Families with non-zero net change between versions"
)

## ----family-delta-plot--------------------------------------------------------
family_plot_tbl <- family_delta
family_plot_tbl$direction <- ifelse(family_plot_tbl$change > 0, "Increase", "Decrease")
family_plot_tbl$label <- ifelse(
  family_plot_tbl$change > 0,
  paste0("+", family_plot_tbl$change),
  as.character(family_plot_tbl$change)
)
family_plot_tbl$family_name <- factor(
  family_plot_tbl$family_name,
  levels = family_plot_tbl$family_name
)

ggplot(family_plot_tbl, aes(x = family_name, y = change, fill = direction)) +
  geom_col(width = 0.7) +
  geom_hline(yintercept = 0, linetype = 2, color = "#7A8793") +
  geom_text(
    aes(
      label = label,
      hjust = ifelse(change > 0, -0.12, 1.12)
    ),
    size = 3.8
  ) +
  coord_flip() +
  scale_fill_manual(values = c("Increase" = "#F3C94D", "Decrease" = "#C96B5C")) +
  scale_y_continuous(expand = expansion(mult = c(0.08, 0.12))) +
  labs(
    title = "Family-level concentration of checklist updates",
    subtitle = "Only a small subset of family labels changes between releases",
    x = NULL,
    y = "Net change in species count"
  ) +
  plot_theme

