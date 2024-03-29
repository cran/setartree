% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/forest.R
\name{setarforest}
\alias{setarforest}
\title{Fitting SETAR-Forest models}
\usage{
setarforest(
  data,
  label = NULL,
  lag = 10,
  bagging_fraction = 0.8,
  bagging_freq = 10,
  random_tree_significance = TRUE,
  random_tree_significance_divider = TRUE,
  random_tree_error_threshold = TRUE,
  depth = 1000,
  significance = 0.05,
  significance_divider = 2,
  error_threshold = 0.03,
  stopping_criteria = "both",
  mean_normalisation = FALSE,
  window_normalisation = FALSE,
  verbose = 2,
  num_cores = NULL,
  categorical_covariates = NULL
)
}
\arguments{
\item{data}{A list of time series (each list element is a separate time series) or a dataframe/matrix containing model inputs (the columns can contain past time series lags and/or external numerical/categorical covariates).}

\item{label}{A vector of true outputs. This parameter is only required when \code{data} is a dataframe/matrix containing the model inputs.}

\item{lag}{The number of past time series lags that should be used when fitting each SETAR-Tree in the forest. This parameter is only required when \code{data} is a list of time series. Default value is 10.}

\item{bagging_fraction}{The percentage of instances that should be used to train each SETAR-Tree in the forest.  Default value is 0.8.}

\item{bagging_freq}{The number of SETAR-Trees in the forest.  Default value is 10.}

\item{random_tree_significance}{Whether a random significance should be considered for splitting per each tree. Each node split within the tree considers the same significance level. When this parameter is set to TRUE, the "significance" parameter will be ignored. Default value is TRUE.}

\item{random_tree_significance_divider}{Whether a random significance divider should be considered for splitting per each tree. When this parameter is set to TRUE, the "significance_divider" parameter will be ignored. Default value is TRUE.}

\item{random_tree_error_threshold}{Whether a random error threshold should be considered for splitting per each tree. Each node split within the tree considers the same error threshold. When this parameter is set to TRUE, the "error_threshold" parameter will be ignored. Default value is TRUE.}

\item{depth}{Maximum depth of each SETAR-Tree in the forest. Default value is 1000. Thus, unless specify a lower value, the depth of a SETAR-Tree is actually controlled by the stopping criterion.}

\item{significance}{In each SETAR-Tree in the forest, the initial significance used by the linearity test (alpha_0). Default value is 0.05.}

\item{significance_divider}{In each SETAR-Tree in the forest, the corresponding significance in a tree level is divided by this value. Default value is 2.}

\item{error_threshold}{In each SETAR-Tree in the forest, the minimum error reduction percentage between parent and child nodes to make a split. Default value is 0.03.}

\item{stopping_criteria}{The required stopping criteria for each SETAR-Tree in the forest: linearity test (lin_test), error reduction percentage (error_imp) or linearity test and error reduction percentage (both). Default value is \code{"both"}.}

\item{mean_normalisation}{Whether each series should be normalised by deducting its mean value before building the forest. This parameter is only required when \code{data} is a list of time series. Default value is FALSE.}

\item{window_normalisation}{Whether the window-wise normalisation should be applied before building the forest. This parameter is only required when \code{data} is a list of time series. When this is TRUE, each row of the training embedded matrix is normalised by deducting its mean value before building the forest. Default value is FALSE.}

\item{verbose}{Controls the level of the verbosity of SETAR-Forest: 0 (errors/warnings), 1 (limited amount of information including the depth of the currently processing tree), 2 (full training information including the depth of the currently processing tree and stopping criterion related details in each tree). Default value is 2.}

\item{num_cores}{The number of cores to be used. \code{num_cores > 1} means parallel processing. When not provided, it will find the available number of cores and use those to run the SETAR-Trees in the forest in parallel.}

\item{categorical_covariates}{Names of the categorical covariates in the input data. This parameter is only required when \code{data} is a dataframe/matrix and it contains categorical variables.}
}
\value{
An object of class \code{\link{setarforest}} which contains the following properties.
\item{trees}{A list of objects of class \code{\link{setartree}} which represents the trained SETAR-Tree models in the forest.}
\item{lag}{The number of features used to train each SEATR-Tree in the forest.}
\item{feature_names}{Names of the input features.}
\item{coefficients}{Names of the coefficients of leaf node regresion models in each SETAR-Tree in the forest.}
\item{categorical_covariate_values}{Information about the categorical covarites used during training (only if applicable).}
\item{mean_normalisation}{Whether mean normalisation was applied for the training data.}
\item{window_normalisation}{Whether window normalisation was applied for the training data.}
\item{input_type}{Type of input data used to train the SETAR-Forest. This is \code{list} if \code{data} is a list of time series, and \code{df} if \code{data} is a dataframe/matrix containing model inputs.}
\item{execution_time}{Execution time of SETAR-Forest.}
}
\description{
Fits a SETAR-Forest model either using a list of time series or an embedded input matrix and labels.
}
\examples{
\donttest{
# Training SETAR-Forest with a list of time series
setarforest(chaotic_logistic_series, bagging_freq = 2, num_cores = 1)

# Training SETAR-Forest with a dataframe containing model inputs where the model inputs may contain
# past time series lags and numerical/categorical covariates
setarforest(data = web_traffic_train[,-1],
            label = web_traffic_train[,1],
            bagging_freq = 2,
            num_cores = 1,
            categorical_covariates = "Project")
}

}
