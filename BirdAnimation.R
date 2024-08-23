##Create an animation from a series of still illustrated images
library(magick)

#Load images
image_files<-list.files("Images/All/", pattern="png", full.names=TRUE)
images<-image_read(image_files)

##Annotations##
#Import annotation file
annotations<-read.csv("ImageText.csv")

#Create a list of the image names
images_list<-as.list(images)
images_list<-setNames(images_list, basename(image_files))

#Add text to images based on excel 
for (i in 1:nrow(annotations)) {
  filename<-annotations$Filename[i]
  wrp_text<-annotations$WRPText[i]
  month_text <- annotations$MonthText[i]
  
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
  }
}

#Convert the named list back to an image list
annotated_images<-image_join(images_list)

#Make the background white
white_images<-image_background(annotated_images, color = "white", flatten = TRUE)

#Animate the images
animation<-image_animate(white_images, fps=5)

#Save 
animation_file<-"Export/ComplexBasic1.gif"
image_write(animation, animation_file)
