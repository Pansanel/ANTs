% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/RcppExports.R
\name{gbi_createEmpty}
\alias{gbi_createEmpty}
\title{Empty group by individual matrix}
\usage{
gbi_createEmpty(d, col_scan, col_id)
}
\arguments{
\item{d}{a data frame}

\item{col_scan}{an integer indicating the number of the column holding the different scans.}

\item{col_id}{an integer indicating the number of the column holding the different scans.}
}
\value{
An empty group by individual matrix.
}
\description{
Create an embty group by individual matrix according to the number of scans and individuals.
}
\details{
A group by individual matrix is a way to represent several data collection protocols such as group fellows or scans data collections. They also allow to compute easely several associations indexes.
}
\references{
Whitehead, H. A. L. (1997). Analysing animal social structure. Animal behaviour, 53(5), 1053-1067.
}
\author{
Sebastian Sosa, Ivan Puga-Gonzales.
}
\keyword{internal}
