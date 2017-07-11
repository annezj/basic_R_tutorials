# Animate pre-prepared crime data
# over a Googlemaps background
rm(list=ls())

library(animation)
library(ggplot2) 
library(ggmap)

# Read the data: Crimes in the Liverpool area during 2016 
# (Contains public sector information licensed under the Open Government Licence v3.0)
# Data for Merseyside Police, January to December 2016 obtained from https://data.police.uk/
# Grab my edit for Liverpool area and with extraneous columns removed:
df=read.csv("/Users/annejones/Documents/blog/blog_r_scripts/basic_R_tutorials/data/Liverpool-01-2016-12-2016.csv")

# Get googlemaps background for the dataset location
latmin=min(df$Latitude)
latmax=max(df$Latitude)
lonmin=min(df$Longitude)
lonmax=max(df$Longitude)
mymap<-get_map(location=c(lonmin,latmin,lonmax,latmax)) 

# Process the date string
df$monthnum=as.integer(substr(df$Month, 6, 7))
monthstrings=c("January", "February", "March", "April", "May", "June", "July", "August", "September",
               "October", "November", "December")
df$monthname=factor(df$monthnum, levels=1:12,labels=monthstrings)
# Quick plot to check
ggplot(df)+geom_bar(aes(x=monthnum, fill=Crime.type), position="stack")+theme_bw()+scale_x_continuous(breaks=1:12)

# Create an animation with one frame per month
nframes=12

# Define plotting function which must must create one plot per frame
create.plots <-function()
{
  # Set an frame rate of 1 per second
  ani.options(interval=1, verbose=FALSE)
  # animvec is used to loop over frames
  animvec=1:nframes

  # loop over months/frames
  for(iframe in animvec)
  {
    # Pick up crimes occurring this month
    dfi=df[which(df$monthnum==iframe),]
    
    # Print the base map and title
    titlestr=paste(monthstrings[iframe],'\n',2016,sep='')
    p=ggmap(mymap)+ggtitle(titlestr)+theme(plot.title = element_text(hjust = 0.5))
    
    # Plot all crimes for this frame
    # fix the color scale across all frames so no categories are dropped
    p=p+geom_point(data=dfi,aes(x=Longitude,y=Latitude,color=Crime.type), alpha=0.2)+
      scale_color_discrete("", drop=F)+xlab("")+ylab("")
    print(p)  
  }
}

# Animate by calling the function to create an html animation from the plotting function
# The html file will appear in the current working directory
# and open automatically in the default web brower
testdir="/Users/annejones/Documents/blog/blog_r_scripts/basic_R_tutorials/output/crime_animation/"
setwd(testdir)
saveHTML(create.plots(),
         img.name="crime_animation",
         autoplay=T,
         outdir=getwd(),
         htmlfile=paste("crime_animation.html", sep=""),
         ani.height=600,ani.width=600,
         title="Crime Animation",
         description=c("none")
)