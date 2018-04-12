# Mutlivariable-forecast
In this repository we forecast a two-vaiable (electricity price and temperture) time series using Vector and Bayes autoregression model 



![multivariable-var-bvar](https://user-images.githubusercontent.com/13289981/38684745-383130d2-3e25-11e8-91d3-388848c18bb4.png)


## requirements
The code is writen in R and requires the following packages

library(vars)

library(BMR)

library(devtools)

library(readr)

require(reshape2)

## the data
The input data is the file

datah2c.csv

that contains two columns of information, the first one represents the price of electricity consumption and the second is temperatures in the area for a period of 60 months

## The model

We used 36 input points to train the models and forecast 24 ahead.  
The previous plot was obtained with the code of this repository where we consider a vector autoregression models (VAR) with two lagged values. In the same plot we have the predictions using a Bayes approach with Minnesota prior (BVAR) and 5 lagged values 

The code also computes the root mean squared errors and other plots where you can observe the mean and variance.
