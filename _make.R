## Run all files to prepare "Introduction to R Markdown" workshop

# Setup
library(webshot)
library(pdftools)
library(magick)
library(here)
here()

# Render the presentation and exercises.
rmarkdown::render(here("Exercises", "CW-Report-Target-PDF.Rmd"),
                  clean = TRUE, envir = new.env(),
                  output_dir = here("Exercises"))

rmarkdown::render(here("Presentation", "Rmarkdown-Intro-Workshop.Rmd"),
                  clean = TRUE, envir = new.env(),
                  output_dir = here("Presentation"))

rmarkdown::render(here("Exercises", "CW-Report-Target-HTML.Rmd"),
                  clean = TRUE, envir = new.env(),
                  output_dir = here("Exercises"))

rmarkdown::render(here("Exercises", "CW-Report-Target-prettydoc.Rmd"),
                  clean = TRUE, envir = new.env(),
                  output_dir = here("Exercises"))

rmarkdown::render(here("Exercises", "CW-Slides-Target.Rmd"),
                  clean = TRUE, envir = new.env(),
                  output_dir = here("Exercises"))

# Create PNGs to be used in the Exercise sheet to share with participants.
wsWidth <- 1280
wsHeight <- 800

webshot(url = here("Exercises", "CW-Report-Target-HTML.html"),
        here("Exercises", "images", "CW-Report-Target-HTML.png"),
        vwidth = wsWidth,
        vheight = wsHeight,
        delay = 0.8,
        cliprect = c(0, 0, wsWidth, wsHeight))

webshot(url = here("Exercises", "CW-Report-Target-prettydoc.html"),
        here("Exercises", "CW-Report-Target-prettydoc.png"),
        vwidth = wsWidth,
        vheight = wsHeight,
        delay = 0.8,
        cliprect = c(0, 0, wsWidth, wsHeight))

webshot(url = here("Exercises", "CW-Slides-Target.html"),
        here("Exercises", "images", "CW-Slides-Target.png"),
        vwidth = wsWidth,
        vheight = wsHeight,
        delay = 0.8,
        cliprect = c(0, 0, wsWidth, wsHeight))

pdfTemp <- tempfile()
pdf_convert(here("Exercises", "CW-Report-Target-PDF.pdf"),
            "png", pages = 1, dpi = 155, filenames = pdfTemp) %>%
  image_read() %>%
  image_crop(geometry_area(900, 1200, 200, 200), repage = FALSE) %>%
  image_write(., path=here("Exercises", "images", "CW-Report-Target-PDF.png"), format="png")

# Remove LaTeX log files
unlink(here("Exercises", "*.log"))
unlink(here("Exercises", "*.tex"))
unlink(here("Exercises", "*_files"), recursive = TRUE)

# Create a PDF version of the slides to share
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
dir.create(here("Share", "Exercises"))
#dir.create(here("Share", "Solutions"))
dir.create(here("Share", "Slides-Notes"))
unlink(here("Exercises", "*.Rproj"))

# Populate the Share directories
file.copy(here("Presentation", "Rmarkdown-Intro-Workshop.html"),
          here("Share", "Slides-Notes"), overwrite = TRUE)

file.copy(here("Presentation", "Rmarkdown-Intro-Workshop.pdf"),
          here("Share", "Slides-Notes"), overwrite = TRUE)

download.file("https://github.com/rstudio/cheatsheets/raw/master/rmarkdown-2.0.pdf",
              here("Share", "Slides-Notes", "RStudio-rmarkdown-2.0.pdf"))

# Creating (initialising) an RStudio project in the Exercises directory
rstudioapi::initializeProject(path = here("Exercises"))
file.rename(here("Exercises", "Exercises.Rproj"),
            here("Exercises", "CW-Summary.Rproj"))

## Create "Exercises"
file.copy(here("Exercises", "CW-Report-Target-HTML.html"),
          here("Share", "Exercises"), overwrite = TRUE)

file.copy(here("Exercises", "CW-Report-Target-PDF.pdf"),
          here("Share", "Exercises"), overwrite = TRUE)

file.copy(here("Exercises", "CW-Report-Target-prettydoc.html"),
          here("Share", "Exercises"), overwrite = TRUE)

file.copy(here("Exercises", "CW-Slides-Target.html"),
          here("Share", "Exercises"), overwrite = TRUE)

file.copy(here("Exercises", "ChickWeight.csv"),
          here("Share", "Exercises"), overwrite = TRUE)

file.copy(here("Exercises", "CW-Summary.Rproj"),
          here("Share", "Exercises"), overwrite = TRUE)


# Using here() function with zip results in full paths in the zip files :(
# Not beautiful: Using setwd to overcome the full paths issue above.
setwd(here())
zip(here("Share", "RmarkdownWS.zip"), "./Share/", extras = "-FS")

# Create Solutions zip file
dir.create(here("RmdWS-Solutions"))
file.copy(here("Exercises", "."), here("RmdWS-Solutions"), recursive = TRUE)
zip(here("Share", "RmdWS-Solutions.zip"), "./RmdWS-Solutions/", extras = "-FS")
unlink(here("RmdWS-Solutions/"), recursive = TRUE)

# Clean the Share directory
unlink(here("Share/*/"), recursive = TRUE)

setwd(here())
