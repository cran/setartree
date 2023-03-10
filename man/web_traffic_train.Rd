% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/docData.R
\docType{data}
\name{web_traffic_train}
\alias{web_traffic_train}
\title{A dataframe of training instances}
\format{
A dataframe containing 120 training instances.
}
\description{
A dataframe containing 120 instances that can be used to train the SETAR-Tree and SETAR-Forest models.
The data are related to the number of hits or web traffic of a set of Wikipedia pages.
Each instance in the dataframe consists of 10 time series lags (Lag1 to Lag10), a categorical covariate (Project) and the corresponding true outputs (y).
The data were downloaded from the Wikimedia REST API (Wikimedia, 2022).
}
\examples{
web_traffic_train
}
\references{
Wikimedia Analytics Team (2022). Wikistats: Pageview complete dumps.\cr
URL https://dumps.wikimedia.org/other/pageview_complete
}
\keyword{datasets}
