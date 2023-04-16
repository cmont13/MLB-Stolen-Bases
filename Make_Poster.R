# Load packages####
library(extrafont)
library(tidyverse)  # Loads the `tidyverse` collection
library(readxl)     # Reads CSV and Excel files
library(png)        # Reads and Writes PNG files
library(jpeg) 
library(svDialogs)  # Generates pop-up dialogue
library(magick)

#Read Data####
urls <- read.csv("https://github.com/cmont13/MLB-Stolen-Bases/blob/main/Data/urls2.csv")


#Take input from user####
input <- dlgInput("Enter a name", Sys.info()["user"])$res |>
  toString()
sheriff <- dlgInput("Enter a team name", Sys.info()["user"])$res |>
  toString()|>
  toupper()
sheriff <- paste("THE", sheriff)
count <- dlgInput("Enter a number", Sys.info()["user"])$res
offenses <-image_read("https://github.com/cmont13/MLB-Stolen-Bases/blob/main/Images/First_Offense_Tag.png")|>
  image_scale('25%')
if(count > 1) {
  offenses <-image_read("https://github.com/cmont13/MLB-Stolen-Bases/blob/main/Images/Repeat_Offender_Tag.png")|>
    image_scale('25%')
}
  
offenses
#Checking if the name exists
test <- any(urls == input) |>
  is.na()
if(test == TRUE) {
  dlg_message("ERROR")
  exit()
}
#Finding the photo####
temp_url <- urls[urls$PLAYERNAME == input,]

player_url <- temp_url |>
  select(url) |>
  toString()

#Generating Image####
destfile <- "https://github.com/cmont13/MLB-Stolen-Bases/blob/main/Images/output.png"
temp <- tempfile()
download.file(player_url, temp, mode = "wb")
headshot <- readPNG(temp)
writePNG(headshot, destfile)

#file.remove(temp)

#Draw Poster####
photo <- image_read("https://github.com/cmont13/MLB-Stolen-Bases/blob/main/Images/output.png") |>
  image_scale("480x349") |>
  image_quantize(colorspace = 'gray')|>
  image_enhance() |>
  image_colorize(40, "#C7791A")
poster <- image_read("https://github.com/cmont13/MLB-Stolen-Bases/blob/main/Images/Blank_Wanted_template.jpg")
poster <- image_scale(poster, '25%')
poster <- poster |>
  image_annotate(sheriff, font = 'Georgia', size = 35, location = "+140+192", color = "#403A3A", weight = 550) |>
  image_composite(composite_image = photo, offset = "+50+293")|>
  image_composite(composite_image = offenses)
poster
image_write(poster, path = "https://github.com/cmont13/MLB-Stolen-Bases/blob/main/Images/final_poster.jpeg", format = "jpeg")
