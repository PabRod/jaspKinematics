ProcessTable <- function(jaspResults, dataset, options) {
  # Extends the input with kinematical information
  stats <- createJaspTable(gettext("Some descriptives"))

  ## Show the input as a table
  stats$addColumnInfo(name = "t")
  stats$addColumnInfo(name = "x")
  stats$addColumnInfo(name = "y")

  stats[["t"]] <- dataset[, options$t]
  stats[["x"]] <- dataset[, options$x]
  stats[["y"]] <- dataset[, options$y]

  stats$addColumnInfo(name = "vx") # TODO: too many output decimals
  stats$addColumnInfo(name = "vy")

  ## Use kinematics to calculate speeds
  speeds <- kinematics::speed(dataset[, options$t],
                              dataset[, options$x],
                              dataset[, options$y])

  ## Append speeds to the table
  stats[["vx"]] <- speeds$vx
  stats[["vy"]] <- speeds$vy

  jaspResults[["stats"]] <- stats

  return()
}
