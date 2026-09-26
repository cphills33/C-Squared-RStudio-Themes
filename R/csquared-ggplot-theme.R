# Helper functions for using the C-Squared Quarto palettes in ggplot2.
# Source this file, then add `theme_csquared()` and a matching scale to a plot.

.csquared_modes <- c("paper_wash", "night_bloom", "blossom_ledger")

.csquared_match_mode <- function(mode = .csquared_modes) {
  mode <- as.character(mode[[1]])
  mode_key <- tolower(trimws(mode))
  mode_key <- gsub("[[:space:]-]+", "_", mode_key)

  aliases <- c(
    paper = "paper_wash",
    light = "paper_wash",
    paper_wash = "paper_wash",
    night = "night_bloom",
    dark = "night_bloom",
    night_bloom = "night_bloom",
    blossom = "blossom_ledger",
    ledger = "blossom_ledger",
    blossom_ledger = "blossom_ledger"
  )

  matched <- unname(aliases[mode_key])

  if (is.na(matched)) {
    stop(
      "`mode` must be one of: paper_wash, night_bloom, blossom_ledger.",
      call. = FALSE
    )
  }

  matched
}

csquared_palette <- function(mode = .csquared_modes) {
  mode <- .csquared_match_mode(mode)

  switch(
    mode,
    paper_wash = c(
      bg = "#f7fbfa",
      surface = "#eef7f6",
      surface_strong = "#eaf4f3",
      text = "#263540",
      heading = "#21313b",
      muted = "#6e7e88",
      border = "#d8e6e3",
      cyan = "#1f7185",
      teal = "#2c8d83",
      rose = "#b93e63",
      coral = "#d96d58",
      gold = "#a86b1e"
    ),
    night_bloom = c(
      bg = "#0a111d",
      surface = "#101b2a",
      surface_strong = "#111c2b",
      text = "#eaf4f3",
      heading = "#f6fbfa",
      muted = "#94afc2",
      border = "#24364a",
      cyan = "#58d7e8",
      teal = "#42c7b7",
      rose = "#f06a92",
      coral = "#ff5c7a",
      gold = "#e2b84b"
    ),
    blossom_ledger = c(
      bg = "#fffaf7",
      paper = "#fbf7f2",
      surface = "#f5efea",
      surface_strong = "#eef5f4",
      text = "#243a58",
      heading = "#223652",
      muted = "#667a90",
      border = "#dde7e5",
      sea = "#4a8b8c",
      sea_soft = "#8ab7bd",
      rose = "#b85c79",
      blush = "#d48c92",
      bark = "#a56a53",
      gold = "#a77942",
      sage = "#5a7e73",
      lavender = "#8a6f9c"
    )
  )
}

.csquared_accent_names <- function(mode = .csquared_modes) {
  mode <- .csquared_match_mode(mode)

  switch(
    mode,
    paper_wash = c("cyan", "teal", "rose", "coral", "gold"),
    night_bloom = c("cyan", "teal", "rose", "coral", "gold"),
    blossom_ledger = c(
      "sea",
      "rose",
      "gold",
      "sage",
      "blush",
      "bark",
      "sea_soft",
      "lavender"
    )
  )
}

csquared_accent_colors <- function(mode = .csquared_modes, n = NULL) {
  mode <- .csquared_match_mode(mode)
  palette <- csquared_palette(mode)
  colors <- palette[.csquared_accent_names(mode)]

  if (is.null(n)) {
    return(colors)
  }

  n <- as.integer(n[[1]])

  if (is.na(n) || n < 0) {
    stop("`n` must be a non-negative integer.", call. = FALSE)
  }

  if (n == 0) {
    return(character())
  }

  colors <- unname(colors)

  if (n <= length(colors)) {
    return(colors[seq_len(n)])
  }

  grDevices::colorRampPalette(colors)(n)
}

csquared_alpha <- function(color, alpha = 1) {
  grDevices::adjustcolor(color, alpha.f = alpha)
}

theme_csquared <- function(
  mode = .csquared_modes,
  base_size = 12,
  base_family = "Avenir Next",
  transparent = TRUE,
  grid = c("y", "xy", "none")
) {
  mode <- .csquared_match_mode(mode)
  grid <- match.arg(grid)
  palette <- csquared_palette(mode)

  plot_fill <- if (transparent) "transparent" else unname(palette["bg"])
  panel_fill <- if (transparent) "transparent" else unname(palette["surface"])
  grid_line <- ggplot2::element_line(
    color = csquared_alpha(unname(palette["border"]), if (mode == "paper_wash") 0.85 else 1),
    linewidth = 0.35
  )

  x_grid <- if (grid == "xy") grid_line else ggplot2::element_blank()
  y_grid <- if (grid %in% c("y", "xy")) grid_line else ggplot2::element_blank()

  ggplot2::theme_minimal(base_size = base_size, base_family = base_family) +
    ggplot2::theme(
      line = ggplot2::element_line(color = unname(palette["text"])),
      rect = ggplot2::element_rect(fill = "transparent", color = NA),
      text = ggplot2::element_text(color = unname(palette["text"])),
      plot.background = ggplot2::element_rect(fill = plot_fill, color = NA),
      panel.background = ggplot2::element_rect(fill = panel_fill, color = NA),
      panel.border = ggplot2::element_blank(),
      panel.grid.major.x = x_grid,
      panel.grid.major.y = y_grid,
      panel.grid.minor = ggplot2::element_blank(),
      axis.line = ggplot2::element_line(
        color = unname(palette["text"]),
        linewidth = 0.45,
        lineend = "square"
      ),
      axis.ticks = ggplot2::element_line(
        color = unname(palette["text"]),
        linewidth = 0.35,
        lineend = "square"
      ),
      axis.ticks.length = grid::unit(2.4, "pt"),
      axis.text = ggplot2::element_text(color = unname(palette["text"])),
      axis.title = ggplot2::element_text(color = unname(palette["heading"])),
      plot.title = ggplot2::element_text(
        color = unname(palette["heading"]),
        face = "bold",
        size = ggplot2::rel(1.18)
      ),
      plot.subtitle = ggplot2::element_text(color = unname(palette["muted"])),
      plot.caption = ggplot2::element_text(color = unname(palette["muted"])),
      plot.title.position = "plot",
      plot.caption.position = "plot",
      legend.background = ggplot2::element_rect(fill = plot_fill, color = NA),
      legend.box.background = ggplot2::element_rect(fill = plot_fill, color = NA),
      legend.key = ggplot2::element_rect(fill = plot_fill, color = NA),
      legend.title = ggplot2::element_text(color = unname(palette["heading"])),
      legend.text = ggplot2::element_text(color = unname(palette["text"])),
      strip.background = ggplot2::element_rect(
        fill = plot_fill,
        color = csquared_alpha(unname(palette["border"]), 0.95),
        linewidth = 0.45
      ),
      strip.text = ggplot2::element_text(
        color = unname(palette["heading"]),
        face = "bold"
      )
    )
}

scale_color_csquared <- function(mode = .csquared_modes, ...) {
  mode <- .csquared_match_mode(mode)

  ggplot2::discrete_scale(
    aesthetics = "colour",
    palette = function(n) csquared_accent_colors(mode, n = n),
    ...
  )
}

scale_colour_csquared <- scale_color_csquared

scale_fill_csquared <- function(mode = .csquared_modes, ...) {
  mode <- .csquared_match_mode(mode)

  ggplot2::discrete_scale(
    aesthetics = "fill",
    palette = function(n) csquared_accent_colors(mode, n = n),
    ...
  )
}

scale_color_csquared_c <- function(
  mode = .csquared_modes,
  ...,
  direction = 1
) {
  colors <- csquared_accent_colors(mode)

  if (direction < 0) {
    colors <- rev(colors)
  }

  ggplot2::scale_color_gradientn(colors = unname(colors), ...)
}

scale_colour_csquared_c <- scale_color_csquared_c

scale_fill_csquared_c <- function(
  mode = .csquared_modes,
  ...,
  direction = 1
) {
  colors <- csquared_accent_colors(mode)

  if (direction < 0) {
    colors <- rev(colors)
  }

  ggplot2::scale_fill_gradientn(colors = unname(colors), ...)
}
