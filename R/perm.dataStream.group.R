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

#' @title Data stream permutation for association data
#' @description Pre-network permutation on association data

#' @param df A data frame.The data frame must have a column named 'ID'.
#' @param scan  an integer indicating the column of scans of individuals association.
#' @param control_factor A confounding factor by which to control group associations.
#' @param perm number of permutations to perform.
#' @param progress a boolean indicating if the permutation process has to be visible.
#' @param method Which type of index to calculate:
#' \itemize{
#' \item 'sri' for Simple ratio index: \eqn{x \div x+yAB+yA+yB}
#' \item 'hw' for Half-weight index: \eqn{x/x+yAB+1/2(yA+yB)}
#' \item 'tw' for Twice-weigh index:\eqn{x/x+2yAB+yA+yB}
#' \item 'sr' for Square root index:\eqn{x/sqr((x+yAB+yA)(x+yAB+yB))}
#' }
#' @return list of square association index matrices. The first element of the list is the non-permuted association index matrix.

#' @details Data stream permutation is a pre-network permutation approach. It is used on association data based on the gambit of the group.
#' @author Sebastian Sosa, Ivan Puga-Gonzalez.

#' @references Whitehead, H. A. L. (1997). Analysing animal social structure. Animal behaviour, 53(5), 1053-1067.
#' @references Farine, D. R. (2017). A guide to null models for animal social network analysis. Methods in Ecology and Evolution.
#' @references Sosa, S. (2018). Social Network Analysis, \emph{in}: Encyclopedia of Animal Cognition and Behavior. Springer.
#' @keywords internal


# factor= according to which factors creat the gbi. enter the name of the column.
perm.dataStream.group <- function(df, scan, control_factor = NULL, perm, progress = TRUE, method = "sri") {
  ## !!!! FOR DEBUGGING SEND ALL LINES EACH TIME YOU RUN THE CODE!!!!
  # perm WITHIN SCANS NO CONTROL FACTORS  -----------------------------------------------
  if (is.null(control_factor)) {
     ### Get index of column with the scan
    col_scan <- df.col.findId(df, scan)
    if (length(col_scan) > 1) {
      df$scan <- apply(df[, col_scan ], 1, paste, collapse = "_")
    } else {
      df$scan <- df[, col_scan]
    }
    ### convert the scan columns to factors, necessary for GBI
    df$scan <- as.factor(df$scan)
    #### set ids to levels; necessary for cpp function
    ids <- levels(df$ID)
    ### ### Get index of column with the scan
    col_scan <- df.col.findId(df, "scan")
    ### Get the index column belonging to ID
    col_ID <- grep("^ID$", colnames(df))
    ### Create gbi matrix (GBI) groups = Scan
    GBI <- df.to.gbi(df, col_scan, col_ID)
    ### Permute data and obtain list of recalculated associations index according to each permutation
    list_gbi <- perm_dataStream1(GBI, perm, progress = progress, method = method)
    ### Add individuals' names to association matrices
    list_gbi <- lapply(seq_along(list_gbi), function(x, ids, i) {
      colnames(x[[i]]) <- ids
      rownames(x[[i]]) <- ids
      attr(x[[i]], "permutation") <- i
      return(x[[i]])
    }, x = list_gbi, ids = ids)
  }

  # perm WITHIN CONTROL FACTORS ---------------------------------------------------------
  else {
    ## !!!!FOR DEBUGGING SEND ALL LINES EACH TIME YOU RUN THE CODE!!!!
     ### Get index of column with the scan
    col_scan <- df.col.findId(df, scan)
    if (length(col_scan) > 1) {
      df$scan <- apply(df[, col_scan ], 1, paste, collapse = "_")
    } else {
      df$scan <- df[, col_scan]
    }
    ### convert the scan columns to factors, necessary for GBI
    df$scan <- as.factor(df$scan)
    #### set ids to levels; necessary for cpp function
    ids <- levels(df$ID)
    ### Get index of column with the scan
    col_scan <- df.col.findId(df, "scan")
    ### Get the index column belonging to ID
    col_ID <- grep("^ID$", colnames(df))
    ### CREATE A LIST OF DIFFERENT DFs DEPENDING ON FACTORS TO CONTROL
    col_id <- df.col.findId(df, control_factor)
    if (length(col_id) > 1) {
      df$control <- apply(df[, col_id ], 1, paste, collapse = "_")
    } else {
      df$control <- df[, col_id]
    }
    df$control <- as.factor(df$control)
    dfControls <- split(df, df$control)
    ############################
    GBIcontrols <- list() ## list to hold the list of gbis
    GroupOrder <- c() ### holds the names of the groups in the order put in the different gbi
    ### CREATE A GBI PER DF to CONTROL
    GBIcontrols <- lapply(dfControls, df.to.gbi, col_scan, col_ID)
    ##################################
    GBI <- do.call(rbind, GBIcontrols)
    CumGbiSizes <- c(0, cumsum(sapply(GBIcontrols, nrow))) ### starts on 0 cause of C++ indexes
    ## Perform permutations
    list_gbi <- perm_dataStream_ControlFactor(GBIcontrols, GBI, perm, CumGbiSizes, progress = progress, method = method)
    ## rename columns and rows of the association matrices
    list_gbi <- lapply(seq_along(list_gbi), function(x, ids, i) {
      colnames(x[[i]]) <- ids
      rownames(x[[i]]) <- ids
      attr(x[[i]], "permutation") <- i
      return(x[[i]])
    }, x = list_gbi, ids = ids)
  }
  return(list_gbi)
}
