# Copyright (C) 2018  Sebastian Sosa, Ivan Puga-Gonzalez, Hu Feng He,Peng Zhang, Xiaohua Xie, Cédric Sueur
#
# This file is part of Animal Network Toolkit Software (ANTs).
#
# ANT is free software: you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# ANT is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

#' @title Binary symetric Laplacian centrality
#' @description Calculate the binary symetric Laplacian centrality for each verteces.

#' @param M a square adjacency matrix.
#' @details Laplacian centrality is the drop in the Laplacian energy of the graph when the vertex is removed
#' This version uses the degrees to calculate laplacian centrality
#' @author Sebastian Sosa, Ivan Puga-Gonzalez.

#' @references REF laplacian !!!!!!!!!!!!!!!!
#' @references Sosa, S. (2018). Social Network Analysis, \emph{in}: Encyclopedia of Animal Cognition and Behavior. Springer.
#' @keywords internal


met.lpcB <- function(M) {
  error_matrix(M)
  diag(M) <- 0
  mat.symetrize(M)

  met.degree <- mat_col_sumsBinary(M)
  lc <- NULL
  for (a in 1:length(M[1, ])) {
    alters_degrees <- met.alterDegree(M, a)
    lc[a] <- met.degree[a]^2 + met.degree[a] + 2 * sum(alters_degrees)
  }
  return(lc)
}
