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

#' @title Histogram of posterior distribution
#' @description plot multiple histograms of posterior distribution
#' @param v_perm a data frame of permuted values (each column represents a factor). First row represents the observed values and the next ones represent the permuted values.
#' @param Obs an integer vector indicating the observed value to compare to permuted values if in argument v_perm the first row does not represent the observed values.
#' @param ncols Number of graph per row 
#' @param nrows Number of graph per column
#' @keywords internal
post.dist <- function(v_perm, Obs = NULL, ncols = NULL, nrows = NULL) {
  par(bg = "gray63")
  if (ncol(v_perm) == 1 & ncol(v_perm) != 0) {
    if (is.null(Obs)) {
      # Extract first values (observed one)
      Obs <- v_perm[1, 1]
      # Extract permuted values
      v_perm <- v_perm[-1, 2]
    }
    if (Obs > m) {
      # Plot histogram of permuted values
      h <- hist(v_perm, breaks = length(v_perm), xaxt = "n")
      cuts <- cut(h$breaks, c(Obs, Inf))
      cuts <- ifelse(is.na(cuts), "gray10", "gray25")
      plot(h, col = cuts, border = cuts, main = paste(attributes(v_perm)$comment), xaxt = "n")
      axis(1)
      mtext(1, text = round(Obs, digits = 2), at = Obs, col = "white")
      # Plot observed value
      abline(v = Obs, col = "white")
      legend("topright", legend = "observed value", text.col = "white", box.lty = 0)
    }
    else {
      # Plot histogram of permuted values
      h <- hist(v_perm, breaks = length(v_perm), xaxt = "n")
      cuts <- cut(h$breaks, c(Obs, Inf))
      cuts <- ifelse(is.na(cuts), "gray25", "gray10")
      plot(h, col = cuts, border = cuts, xlab = paste(attributes(v_perm)$comment), xaxt = "n")
      axis(1)
      mtext(1, text = round(Obs, digits = 2), at = Obs, col = "white")
      # Plot observed value
      abline(v = Obs, col = "white")
      legend("topright", legend = "observed value", text.col = "white", box.lty = 0)
    }
  }
  else {
    # Plot output configuration
    if (is.null(ncols) | is.null(nrows)) {
      if (ncol(v_perm) <= 4) {
        (
          par(mfrow = c(1, ncol(v_perm)))
        )
      }
      if (ncol(v_perm) > 4 & ncol(v_perm) < 7) {
        par(mfrow = c(2, 3))
      }
      if (ncol(v_perm) > 6 & ncol(v_perm) < 9) {
        par(mfrow = c(2, 4))
      }
      # MARINE!!!!!!!!! C'EST A CORRIGER
      if(ncol(v_perm) > 9){return(warning("Number of permuted factors are higher than 9. Use ANTs function post.dist to plot them one by one."))}
    }
    else {
      par(mfrow = c(nrows, ncols))
    }
    for (a in 1:ncol(v_perm)) {
      if (is.null(Obs)) {
        # Extract first values (observed one)
        obs <- v_perm[1, a]
        # Extract permuted values
        v_perm <- v_perm[-1, a]
      }
      else{obs=Obs[a]}
      m <- mean(v_perm[, a])
      if (obs > m) {
        # Plot histogram of permuted values
        h <- hist(v_perm[, a], breaks = length(v_perm[, a]), plot = FALSE)
        cuts <- cut(h$breaks, c(obs, Inf))
        cuts <- ifelse(is.na(cuts), "gray10", "gray25")

        # Plot observed value
        if (obs < min(v_perm[, a])) {
          xlim <- c(floor(obs / 0.1) * 0.1, ceiling(max(v_perm[, a]) / 0.1) * 0.1)
          names(xlim) <- NULL
          plot(h, col = cuts, border = cuts, xlim = xlim, main = paste(colnames(v_perm)[a]), xlab = NULL, xaxt = "n")
        }
        else {
          plot(h, col = cuts, border = cuts, main = paste(colnames(v_perm)[a]), xlab = NULL, xaxt = "n")
        }
        axis(1, pos = 0)
        # mtext(1, text = round(obs,digits=3), at = obs, col = "white")
        abline(v = obs, col = "white")
        legend("topleft", legend = paste("observed value", "\n", round(obs, digits = 3)), text.col = "white", box.lty = 0)
      }
      else {
        # Plot histogram of permuted values
        h <- hist(v_perm[, a], breaks = length(v_perm[, a]), plot = FALSE)
        cuts <- cut(h$breaks, c(obs, Inf))
        cuts <- ifelse(is.na(cuts), "gray25", "gray10")
        # Plot observed value
        if (obs > max(v_perm[, a])) {
          plot(h, col = cuts, border = cuts, main = paste(colnames(v_perm)[a]), xlab = NULL, xlim = c(floor(v_perm[, a] / 0.1) * 0.1, ceiling(max(obs) / 0.1) * 0.1), xaxt = "n")
        }
        else {
          plot(h, col = cuts, border = cuts, main = paste(colnames(v_perm)[a]), xlab = NULL, xaxt = "n")
        }
        axis(1, pos = 0)
        # mtext(1, text = round(obs,digits=3), at = obs, col = "white")
        abline(v = obs, col = "white")
        legend("topright", legend = paste("observed value", "\n", round(obs, digits = 3)), text.col = "white", box.lty = 0)
      }
    }
  }
  # Save plot
  p <- recordPlot()
  return(p)
}
