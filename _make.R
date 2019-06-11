## Run all files to prepare "Introduction to R Markdown" workshop

# Setup
library(here)
here()

# Render the presentation, Base R exercises and data.table exercises & solutions
rmarkdown::render(here("Presentation", "Rmarkdown-Intro-Workshop.Rmd"),
                  clean = TRUE, output_dir = here("Presentation"))

# Create a PDF version of the slides to share
library(webshot)
htmlSlides <- paste0("file://",
                    normalizePath(here("Presentation",
                                       "Rmarkdown-Intro-Workshop.html")))
webshot(htmlSlides, here("Presentation", "Rmarkdown-Intro-Workshop.pdf"),
        vwidth = 960, vheight = 540, zoom = 1.5, cliprect = "viewport")

# Create image of first slide to include as part of README.md
webshot(htmlSlides, here("Presentation", "images", "Rmarkdown-Intro-Workshop-Title-Slide.png"),
        delay = 5, vwidth = 640, vheight = 360, zoom = 1.5, cliprect = "viewport")
