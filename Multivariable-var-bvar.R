library(vars)
library(BMR)
library(devtools)
library(readr)
require(reshape2)

# Set the working directory
setwd("/home/...")
tab0 =read_csv("datah2c.csv")


print(tab0)
#choose elements for analysis
tab=tab0[c(1:36), ];
trueC=tab0[,2];

truemax=tab0[37:60,1]
trueconsumption=tab0[37:60,2]


time=tab0[,1];

for(i in 1:60) {
  time[i,1]=i
  print(time[i,1])
}



x2<-data.frame(time, trueC) 
plot(x2,lty="F7",type="l",lwd=2)


#VAR model
myvar = VAR(tab, p=2, type="const",ic="AIC", season=12)
print(myvar)
summary(myvar)
prd <- predict(myvar, n.ahead = 24, ci = 0.95, dumvar = NULL)

x3<-data.frame(time,trueC) 
#x4<-data.frame(time,prd[,5])
prod(dim(time))

plot(x3,lty="F7",type="l",lwd=2)
plot(prd, "single")
plot(x2,lty="F7",type="l",lwd=2)

#BVAR model
#library(MTS)

bvar_data <- data.matrix(tab)
#coef_prior <- c(1,1)

coef_prior <- rbind(c(  1,  1),
                   c(1,  1),
                   c(  0,0),
                   c(  0,  0),
                   c(  0,0),
                   c(  0,  0),
                   c(  0,0),
                   c(  0,  0),
                   c(  0,0),
                   c(  0,  0),
                   c(  0,  0))
bvar_obj <- new(bvarm)
bvar_obj$build(bvar_data,TRUE,5)



#bvar_obj$prior(coef_prior,1,1,0.5,0.5,100.0,1.0)
bvar_obj$prior(coef_prior,1,1,0.5,0.5,100.0,1.0)
#(varianza,   ,n-1 noeq 0,)
#bvar_obj$prior(coef_prior,c(0,1))

bvar_obj$gibbs(10000)

IRF(bvar_obj,20,var_names="temperature,consumption",save=FALSE)
plot(bvar_obj,var_names=colnames(tab),save=FALSE)

#forecasting bvar
predb =forecast(bvar_obj,shocks=TRUE,periods=24, plot=TRUE,var_names=colnames(tab),back_data=30,save=FALSE)


# These are the results of the analysis:

#var values
varforecastmax<-prd[[1]][[1]][1:24]
#bvar values
bvarresults=predb[[1]]
bvarforecastmax=bvarresults[,1]# option 1 for temperature and 2 for consumption
print(bvarforecastmax)
# error results
rmse<- sqrt(mean((truemax-varforecastmax)^2))
print(rmse)
rmse<- sqrt(mean((truemax-bvarforecastmax)^2))
print(rmse)

#graphs
time <- 37:60
max <- truemax
var <- varforecastmax
bvar <- bvarforecastmax
df <- data.frame(time, max, var, bvar)


mdf <- melt(df,id.vars="time")


ggplot(mdf, aes( x=time, y=value, colour=variable, group=variable )) + 
  geom_line() +
  scale_color_manual(values=c("max"="black","var"="red","bvar"="orange")) +
  scale_linetype_manual(values=c("max"="solid","var"="solid","bvar"="dashed"))



