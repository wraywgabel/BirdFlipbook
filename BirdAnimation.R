##Create an animation from a series of still illustrated images
library(magick)

####COMPLEX BASIC####
#Load images
image_files<-list.files("Images/ComplexBasic_All4/", pattern="png", full.names=TRUE)
images<-image_read(image_files)

##Annotations##
#Import annotation file
annotations<-read.csv("ImageText5.csv")

#Create a list of the image names
images_list<-as.list(images)
images_list<-setNames(images_list, basename(image_files))

#Add text to images based on excel 
for (i in 1:nrow(annotations)) {
  filename<-annotations$Filename[i]
  wrp_text<-annotations$WRPText[i]
  month_text <- annotations$MonthText[i]
  cycle_text <- annotations$CycleText[i]
  location_text <- annotations$LocationText[i]
  
  if (filename %in% names(images_list)) {
    #Add WRP text
    images_list[[filename]]<-image_annotate(
      images_list[[filename]], 
      text=wrp_text, 
      size=200, 
      color="black", 
      gravity="southeast"
    )
    #Add month text
    images_list[[filename]]<-image_annotate(
      images_list[[filename]], 
      text=month_text, 
      size=200, 
      color="black", 
      gravity = "southwest"
    )
    #Add cycle text
    images_list[[filename]]<-image_annotate(
      images_list[[filename]], 
      text=cycle_text, 
      size=100, 
      color="black", 
      gravity = "northwest"
    )
    # #Add location text
    # images_list[[filename]]<-image_annotate(
    #   images_list[[filename]], 
    #   text=location_text, 
    #   size=100, 
    #   color="black", 
    #   gravity = "northeast"
    # )
  }
}

#Convert the named list back to an image list
annotated_images<-image_join(images_list)

#Make the background white
white_images<-image_background(annotated_images, color = "white", flatten = TRUE)

#Animate the images
animation<-image_animate(white_images, fps=5)

#Save 
animation_file<-"Export/ComplexBasic_All4.gif"
image_write(animation, animation_file)
