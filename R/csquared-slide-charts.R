# Chart styling used by the C-Squared Night Bloom RevealJS slides.
# Source csquared-ggplot-theme.R before this file.

theme_csquared_slide <- function(base_size = 20, base_family = "Avenir Next") {
  if (!exists("theme_csquared", mode = "function")) {
    stop("Source R/csquared-ggplot-theme.R first.", call. = FALSE)
  }

  palette <- csquared_palette("night_bloom")
  theme_csquared("night_bloom", base_size = base_size,
                 base_family = base_family, transparent = FALSE,
                 grid = "xy") +
    ggplot2::theme(
      panel.grid.major.y = ggplot2::element_blank(),
      axis.line = ggplot2::element_blank(),
      axis.ticks = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank(),
      legend.position = "none",
      plot.margin = ggplot2::margin(8, 85, 8, 8),
      plot.background = ggplot2::element_rect(
        fill = unname(palette["bg"]), color = NA),
      panel.background = ggplot2::element_rect(
        fill = unname(palette["bg"]), color = NA)
    )
}

csquared_highlight_bars <- function(data, label, value, highlight,
                                     digits = 0, x_title = NULL) {
  required <- c(label, value)
  if (!all(required %in% names(data))) {
    stop("`label` and `value` must name columns in `data`.", call. = FALSE)
  }
  if (!is.numeric(data[[value]]) || anyNA(data[[value]]) ||
      !all(is.finite(data[[value]]))) {
    stop("The value column must contain finite numbers.", call. = FALSE)
  }
  if (length(digits) != 1L || is.na(digits) ||
      digits < 0 || digits != as.integer(digits)) {
    stop("`digits` must be a non-negative whole number.", call. = FALSE)
  }

  d <- data.frame(label = as.character(data[[label]]),
                  value = data[[value]])
  if (anyNA(d$label) || anyDuplicated(d$label)) {
    stop("The label column must contain unique, nonmissing labels.",
         call. = FALSE)
  }
  if (length(highlight) != 1L || !highlight %in% d$label) {
    stop("`highlight` must match one label.", call. = FALSE)
  }

  d$label <- factor(d$label,
                    levels = rev(d$label[order(d$value, decreasing = TRUE)]))
  d$highlight <- as.character(d$label) == highlight
  d$shown <- if (digits == 0) {
    format(round(d$value), big.mark = ",", scientific = FALSE, trim = TRUE)
  } else {
    sprintf(paste0("%.", digits, "f"), d$value)
  }
  palette <- csquared_palette("night_bloom")

  ggplot2::ggplot(d, ggplot2::aes(x = value, y = label, fill = highlight)) +
    ggplot2::geom_col(width = 0.68) +
    ggplot2::geom_text(ggplot2::aes(label = shown), hjust = -0.12,
                       size = 5, color = unname(palette["text"])) +
    ggplot2::scale_fill_manual(values = c(
      `FALSE` = "#42566A", `TRUE` = unname(palette["cyan"]))) +
    ggplot2::scale_x_continuous(
      labels = if (digits == 0) scales::label_comma() else
        scales::label_number(accuracy = 10^(-digits)),
      expand = ggplot2::expansion(mult = c(0, 0.24))) +
    ggplot2::labs(x = x_title) +
    theme_csquared_slide()
}
