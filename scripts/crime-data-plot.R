# Animate pre-prepared crime data
# over a Googlemaps background
rm(list=ls())

library(animation)
library(ggplot2) 
library(ggmap)

# change this to the location in which your data files are stored
# leave the end slash in 
datadir='/Users/annejones/Work/teaching/R/data/earthquakes/'

# read the data: Earthquakes in central Italy in August and September 2016 
# data were obtained from https://www.kaggle.com/blackecho/italy-earthquakes
df=read.csv(paste(datadir,'earthquakes.csv',sep=''))

# get googlemaps backgroud for the dataset location
latmin=min(df$Latitude)
latmax=max(df$Latitude)
lonmin=min(df$Longitude)
lonmax=max(df$Longitude)
mymap<-get_map(location=c(lonmin,latmin,lonmax,latmax+0.5)) 

#create an animation with one frame per day
df$frame_number=df$yearday-min(df$yearday)+1
nframes=max(df$yearday)-min(df$yearday)+1
yeardays=min(df$yearday):max(df$yearday)

# find min and max magnitude so we can fix the color scale
minmag=min(df$Magnitude)
maxmag=max(df$Magnitude)

# the animation function must create one plot per frame
do.animate <-function()
{
  # Set an frame rate of 1 per second
  ani.options(interval=1, verbose=FALSE)
  # animvec is used to loop over frames
  animvec=1:nframes
  # for each frame, pick up earthquakes that appear in it
  for(iframe in animvec)
  {
    dfi=df[df$frame_number==iframe,]
    # print the base map and title
    yday=yeardays[iframe]
    titlestr=paste('Day = ',yday,sep='')
    p=ggmap(mymap)+ggtitle(titlestr)
    
    # plot all earthquakes for this frame
    # fix the color scale across all frames
    p=p+geom_point(data=dfi,aes(x=Longitude,y=Latitude,color=Magnitude,size=Magnitude))+
      scale_color_distiller(palette="YlOrRd",direction=1,limits=c(minmag,maxmag))+
      scale_size_continuous(limits=c(minmag,maxmag))
    print(p)  
  }
}

# call the function to create an html animation from our plotting function
# the html file will appear in the data directory
# and open automatically in the default web brower
setwd(datadir)
saveHTML(do.animate(),
         img.name="earthquake_animation",
         autoplay=T,
         outdir=getwd(),
         htmlfile=paste("earthquake_animation.html", sep=""),
         ani.height=600,ani.width=600,
         title="Earthquake Animation",
         description=c("none")
)