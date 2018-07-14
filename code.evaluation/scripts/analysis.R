setwd("C:/Users/Amanda Beth Chron/Desktop/Research/EC3/code.evaluation/python_scripts")
data <- read.csv("igh.csv", header = TRUE)

library(ggplot2)
library(gridExtra)

tool_colors = c("red", "blue", "green", "black", "gray", "orange", "pink", "#00ccff", "yellow", "#cc9900")
summarySE <- function(data=NULL, measurevar, groupvars=NULL, na.rm=FALSE,
                      conf.interval=.95, .drop=TRUE) {
  library(plyr)
  
  # New version of length which can handle NA's: if na.rm==T, don't count them
  length2 <- function (x, na.rm=FALSE) {
    if (na.rm) sum(!is.na(x))
    else       length(x)
  }
  
  # This does the summary. For each group's data frame, return a vector with
  # N, mean, and sd
  datac <- ddply(data, groupvars, .drop=.drop,
                 .fun = function(xx, col) {
                   c(N    = length2(xx[[col]], na.rm=na.rm),
                     mean = mean   (xx[[col]], na.rm=na.rm),
                     sd   = sd     (xx[[col]], na.rm=na.rm)
                   )
                 },
                 measurevar
  )
  
  # Rename the "mean" column    
  datac <- rename(datac, c("mean" = measurevar))
  
  datac$se <- datac$sd / sqrt(datac$N)  # Calculate standard error of the mean
  
  # Confidence interval multiplier for standard error
  # Calculate t-statistic for confidence interval: 
  # e.g., if conf.interval is .95, use .975 (above/below), and use df=N-1
  ciMult <- qt(conf.interval/2 + .5, datac$N-1)
  datac$ci <- datac$se * ciMult
  
  return(datac)
}


datalc <- summarySE(data, measurevar="Base.Accuracy", groupvars=c("Tool","Length"))
datacc <- summarySE(data, measurevar="Base.Accuracy", groupvars=c("Tool","Coverage"))
datakc <- summarySE(data, measurevar="Base.Accuracy", groupvars=c("Tool","Kmer.Size"))
datatec <- summarySE(data, measurevar="Trim.Effeciency", groupvars=c("Tool","Length"))
datatpc <- summarySE(data, measurevar="Trim.Percent", groupvars=c("Tool","Length"))



datapc <- summarySE(data, measurevar="Base.Precision", groupvars=c("Tool","Kmer.Size"))
datagc <- summarySE(data, measurevar="Base.Gain", groupvars=c("Tool","Kmer.Size"))
datasc <- summarySE(data, measurevar="Base.Sensitiviy", groupvars=c("Tool","Kmer.Size"))


# ggplot(datac, aes(x=Kmer.Size, y=Base.Accuracy, colour=Tool)) + 
#   geom_errorbar(aes(ymin=Base.Accuracy-se, ymax=Base.Accuracy+se), width=.1) +
#   geom_line() +
#   geom_point() +
#   geom_point() + scale_colour_manual(values=tool_colors)
# 
# ggplot(datasc, aes(x=Kmer.Size, y=Base.Sensitiviy, colour=Tool)) + 
#   geom_errorbar(aes(ymin=Base.Sensitiviy-se, ymax=Base.Sensitiviy+se), width=.1) +
#   geom_line() +
#   geom_point() +
#   geom_point() + 
#   scale_colour_manual(values=tool_colors)
# 
# ggplot(datagc, aes(x=Kmer.Size, y=Base.Gain, colour=Tool)) + 
#   geom_errorbar(aes(ymin=Base.Gain-se, ymax=Base.Gain+se), width=.1) +
#   geom_line() +
#   geom_point() +
#   geom_point() + 
#   scale_colour_manual(values=tool_colors)
# 
# ggplot(datapc, aes(x=Kmer.Size, y=Base.Precision, colour=Tool)) + 
#   geom_errorbar(aes(ymin=Base.Precision-se, ymax=Base.Precision+se), width=.1) +
#   geom_line() +
#   geom_point() +
#   geom_point() + 
#   scale_colour_manual(values=tool_colors)

#### GENERATE PLOTS ####
# ggplot(data, aes(x=Kmer.Size, y=Base.Accuracy, col=Tool)) + geom_line()
# ggplot(data, aes(Base.Precision, Length, col = Tool)) + geom_point()
# ggplot(data, aes(x=Tool, y=Trim.Percent,fill=Tool)) + geom_boxplot()
# ggplot(data, aes(x=Tool, y=Base.Precision,fill=Tool)) + geom_boxplot()
# ggplot(data, aes(Base.Accuracy, Coverage, col = Tool)) + geom_point()
# ggplot(data, aes(Base.Precision, Coverage, col = Tool)) + geom_point()
# ggplot(data, aes(x=Tool, y=Base.TP.TRIM..,fill=Tool)) + geom_boxplot()
# ggplot(data, aes(x=Tool, y=Base.FP.TRIM..,fill=Tool)) + geom_boxplot()
# ggplot(data, aes(Base.Accuracy, Base.Sensitiviy, col = Tool)) + geom_point()
# ggplot(data, aes(Base.Accuracy, Base.Sensitivity, col = Tool)) + geom_point()
# ggplot(data, aes(x=Tool, y=Base.Accuracy,fill=Tool)) + geom_boxplot()
# ggplot(data, aes(x=Length, y=Base.Accuracy, col=Kmer.Size)) + geom_point() + facet_grid(Tool ~ .)
# ggplot(data, aes(x=Coverage, y=Base.Accuracy, col=Tool)) + geom_point() + facet_grid(Tool ~ .)



###### FIGURE S2 ######
plot1 <- ggplot(datalc, aes(x=Length, y=Base.Accuracy, colour=Tool)) + 
  geom_errorbar(aes(ymin=Base.Accuracy-se, ymax=Base.Accuracy+se), width=.1) +
  geom_line() +
  geom_point() +
  geom_point() + 
  scale_colour_manual(values=tool_colors) +
  facet_grid(Tool ~ .) + 
  ggtitle("Read Length has Non-Significant Effect\n on Tool Accuracy for Immunoglobulin Heavy\n Locus of T-Cells")

plot2 <- ggplot(datalc, aes(x=Length, y=Base.Accuracy, colour=Tool)) + 
  geom_errorbar(aes(ymin=Base.Accuracy-se, ymax=Base.Accuracy+se), width=.1) +
  geom_line() +
  geom_point() +
  geom_point() + 
  scale_colour_manual(values=tool_colors) +
  ggtitle("Read Length has Non-Significant Effect on Tool Accuracy for Immunoglobulin Heavy Locus of T-Cells")

###### FIGURE S3 ######
plot3 <- ggplot(datacc, aes(x=Coverage, y=Base.Accuracy, colour=Tool)) + 
  geom_errorbar(aes(ymin=Base.Accuracy-se, ymax=Base.Accuracy+se), width=.1) +
  geom_line() +
  geom_point() +
  geom_point() + 
  scale_colour_manual(values=tool_colors) +
  facet_grid(Tool ~ .) + 
  ggtitle("Coverage has Non-Significant Effect on Tool Accuracy for Immunoglobulin Heavy Locus of T-Cells")

plot4 <- ggplot(datacc, aes(x=Coverage, y=Base.Accuracy, colour=Tool)) + 
  geom_errorbar(aes(ymin=Base.Accuracy-se, ymax=Base.Accuracy+se), width=.1) +
  geom_line() +
  geom_point() +
  geom_point() + 
  scale_colour_manual(values=tool_colors) +
  ggtitle("Coverage has Non-Significant Effect on Tool Accuracy for Immunoglobulin Heavy Locus of T-Cells")

###### FIGURE S4 ######
plot5 <- ggplot(datakc, aes(x=Kmer.Size, y=Base.Accuracy, colour=Tool)) + 
  geom_errorbar(aes(ymin=Base.Accuracy-se, ymax=Base.Accuracy+se), width=.1) +
  geom_line() +
  geom_point() +
  geom_point() + 
  scale_colour_manual(values=tool_colors) +
  ggtitle("Optimal Kmer for Tool Accuracy in Immunoglobulin Heavy Locus of T-Cells")



###### FIGURE S7 ######
plot6 <- ggplot(data, aes(x=Tool, y=Trim.Effeciency,colour=Tool)) + 
  geom_boxplot() + 
  scale_colour_manual(values=tool_colors)

plot7 <- ggplot(data, aes(x=Tool, y=Trim.Percent,colour=Tool)) + 
  geom_boxplot() + 
  scale_colour_manual(values=tool_colors)

plot8 <- ggplot(datatpc, aes(x=Length, y=Trim.Percent, colour=Tool)) + 
  geom_errorbar(aes(ymin=Trim.Percent-se, ymax=Trim.Percent+se), width=.1) +
  geom_line() +
  geom_point() +
  geom_point() + 
  scale_colour_manual(values=tool_colors) +
  facet_grid(Tool ~ .) + 
  ggtitle("Error Correction Trim Percentage Increase \n Across Read Length Associates with Reduced Accuracy\n for Immunoglobulin Heavy Locus of T-Cells")

plot9 <-ggplot(datatec, aes(x=Length, y=Trim.Effeciency, colour=Tool)) + 
  geom_errorbar(aes(ymin=Trim.Effeciency-se, ymax=Trim.Effeciency+se), width=.1) +
  geom_line() +
  geom_point() +
  geom_point() + 
  scale_colour_manual(values=tool_colors) +
  facet_grid(Tool ~ .) + 
  ggtitle("Error Correction Trim Effeciency Decrease \n Across Read Length Associates with Reduced Accuracy\n for Immunoglobulin Heavy Locus of T-Cells")


plot10 <- grid.arrange(plot1, plot8, ncol=2)
plot11 <- grid.arrange(plot1, plot9, ncol=2)



###### Generate PNG Images ######
png('figures/s1.png')
plot(plot1)
dev.off()

png('figures/s2.png')
plot(plot2)
dev.off()

png('figures/s3.png')
plot(plot3)
dev.off()

png('figures/s4.png')
plot(plot4)
dev.off()

png('figures/s5.png')
plot(plot5)
dev.off()

png('figures/s6.png')
plot(plot6)
dev.off()

png('figures/s7.png')
plot(plot7)
dev.off()

png('figures/s8.png')
plot(plot8)
dev.off()

png('figures/s9.png')
plot(plot9)
dev.off()

png('figures/s10.png')
plot(plot10)
dev.off()

png('figures/s11.png')
plot(plot11)
dev.off()



