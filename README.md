# C-Squared RStudio Themes

Two custom RStudio IDE themes with a watercolor-inspired visual direction:

- **C-Squared Night Bloom**: a dark theme with deep navy/black editor surfaces, cyan and teal washes, rose/coral accents, muted gold, and leaf-green highlights.
- **C-Squared Paper Wash**: a light theme with pale cool-paper backgrounds, slate ink text, softened wash selections, and rose, teal, orange, violet, and leaf-green syntax accents.

Both themes use RStudio's supported `.rstheme` CSS format.

## Install

Run one of these commands in the RStudio console.

### C-Squared Night Bloom

```r
rstudioapi::addTheme(
  "https://raw.githubusercontent.com/cphills33/C-Squared-RStudio-Themes/main/themes/csquared-night-bloom.rstheme",
  apply = TRUE
)
```

### C-Squared Paper Wash

```r
rstudioapi::addTheme(
  "https://raw.githubusercontent.com/cphills33/C-Squared-RStudio-Themes/main/themes/csquared-paper-wash.rstheme",
  apply = TRUE
)
```

You can also download a `.rstheme` file and add it manually from `Tools > Global Options > Appearance > Add`.

## Files

```text
themes/
  csquared-night-bloom.rstheme
  csquared-paper-wash.rstheme
```

## Notes

If you edit a theme after installing it, restart RStudio if the changes do not appear immediately.

## License

A license has not been added yet. Add one before inviting broad reuse or redistribution.