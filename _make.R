## Run all files to prepare "Introduction to R Markdown" workshop

# Setup
library(here)
here()

# Render the presentation and exercises.
rmarkdown::render(here("Presentation", "Rmarkdown-Intro-Workshop.Rmd"),
                  clean = TRUE, output_dir = here("Presentation"))

rmarkdown::render(here("Exercises", "CW-Report-Target.Rmd"),
                  clean = TRUE, output_dir = here("Exercises"))

rmarkdown::render(here("Exercises", "CW-Slides-Target.Rmd"),
                  clean = TRUE, output_dir = here("Exercises"))

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

# Create zip files to share with participants
# First empty the share folder and recreate the directory structure.
unlink(here("Share/"), recursive = TRUE)
dir.create(here("Share"))
dir.create(here("Share", "Exercise"))
dir.create(here("Share", "Slides-Notes"))

# Populate the Share directories
file.copy(here("Presentation", "Rmarkdown-Intro-Workshop.html"),
          here("Share", "Slides-Notes"), overwrite = TRUE)

file.copy(here("Presentation", "Rmarkdown-Intro-Workshop.pdf"),
          here("Share", "Slides-Notes"), overwrite = TRUE)

download.file("https://github.com/rstudio/cheatsheets/raw/master/rmarkdown-2.0.pdf",
              here("Share", "Slides-Notes", "RStudio-rmarkdown-2.0.pdf"))

file.copy(here("Exercises", "CW-Report-Target.html"),
          here("Share", "Exercise"), overwrite = TRUE)

file.copy(here("Exercises", "CW-Slides-Target.html"),
          here("Share", "Exercise"), overwrite = TRUE)

file.copy(here("Exercises", "ChickWeight.csv"),
          here("Share", "Exercise"), overwrite = TRUE)

# Creating (initialising) an RStudio project
rstudioapi::initializeProject(path = here("Share", "Exercise"))
file.rename(here("Share", "Exercise", "Exercise.Rproj"),
            here("Share", "Exercise", "CW-Summary.Rproj"))

# Using here() function with zip results in full paths in the zip files :(
# Not beautiful: Using setwd to overcome the full paths issue above.
setwd(here())
zip(here("Share", "RmarkdownWS.zip"), "./Share/", extras = "-FS")

setwd(here())
