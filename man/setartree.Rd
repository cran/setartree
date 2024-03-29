% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/tree.R
\name{setartree}
\alias{setartree}
\title{Fitting SETAR-Tree models}
\usage{
setartree(
  data,
  label = NULL,
  lag = 10,
  depth = 1000,
  significance = 0.05,
  significance_divider = 2,
  error_threshold = 0.03,
  stopping_criteria = "both",
  mean_normalisation = FALSE,
  window_normalisation = FALSE,
  verbose = 2,
  categorical_covariates = NULL
)
}
\arguments{
\item{data}{A list of time series (each list element is a separate time series) or a dataframe/matrix containing model inputs (the columns can contain past time series lags and/or external numerical/categorical covariates).}

\item{label}{A vector of true outputs. This parameter is only required when \code{data} is a dataframe/matrix containing the model inputs.}

\item{lag}{The number of past time series lags that should be used when fitting the SETAR-Tree. This parameter is only required when \code{data} is a list of time series. Default value is 10.}

\item{depth}{Maximum tree depth. Default value is 1000. Thus, unless specify a lower value, the depth is actually controlled by the stopping criterion.}

\item{significance}{Initial significance used by the linearity test (alpha_0). Default value is 0.05.}

\item{significance_divider}{The corresponding significance in each tree level is divided by this value. Default value is 2.}

\item{error_threshold}{The minimum error reduction percentage between parent and child nodes to make a split. Default value is 0.03.}

\item{stopping_criteria}{The required stopping criteria: linearity test (lin_test), error reduction percentage (error_imp) or linearity test and error reduction percentage (both). Default value is \code{"both"}.}

\item{mean_normalisation}{Whether each series should be normalised by deducting its mean value before building the tree. This parameter is only required when \code{data} is a list of time series. Default value is FALSE.}

\item{window_normalisation}{Whether the window-wise normalisation should be applied before building the tree. This parameter is only required when \code{data} is a list of time series. When this is TRUE, each row of the training embedded matrix is normalised by deducting its mean value before building the tree. Default value is FALSE.}

\item{verbose}{Controls the level of the verbosity of SETAR-Tree: 0 (errors/warnings), 1 (limited amount of information including the current tree depth), 2 (full training information including the current tree depth and stopping criterion results in each tree node). Default value is 2.}

\item{categorical_covariates}{Names of the categorical covariates in the input data. This parameter is only required when \code{data} is a dataframe/matrix and it contains categorical variables.}
}
\value{
An object of class \code{\link{setartree}} which contains the following properties.
\item{leaf_models}{Trained global pooled regression models in each leaf node.}
\item{opt_lags}{Optimal features used to split each node.}
\item{opt_thresholds}{Optimal threshold values used to split each node.}
\item{lag}{The number of features used to train the SETAR-Tree.}
\item{feature_names}{Names of the input features.}
\item{coefficients}{Names of the coefficients of leaf node regresion models.}
\item{num_leaves}{Number of leaf nodes in the SETAR-Tree.}
\item{depth}{Depth of the SETAR-Tree which was determined based on the specified stopping criterion.}
\item{leaf_instance_dis}{Number of instances used to train the regression models at each leaf node.}
\item{stds}{The standard deviations of the residuals of each leaf node.}
\item{categorical_covariate_values}{Information about the categorical covarites used during training (only if applicable).}
\item{mean_normalisation}{Whether mean normalisation was applied for the training data.}
\item{window_normalisation}{Whether window normalisation was applied for the training data.}
\item{input_type}{Type of input data used to train the SETAR-Tree. This is \code{list} if \code{data} is a list of time series, and \code{df} if \code{data} is a dataframe/matrix containing model inputs.}
\item{execution_time}{Execution time of SETAR-Tree.}
}
\description{
Fits a SETAR-Tree model either using a list of time series or an embedded input matrix and labels.
}
\examples{
\donttest{
# Training SETAR-Tree with a list of time series
setartree(chaotic_logistic_series)

# Training SETAR-Tree with a dataframe containing model inputs where the model inputs may contain
# past time series lags and numerical/categorical covariates
setartree(data = web_traffic_train[,-1],
          label = web_traffic_train[,1],
          stopping_criteria = "both",
          categorical_covariates = "Project")
}

}
