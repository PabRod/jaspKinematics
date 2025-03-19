ProcessTable <- function(jaspResults, dataset, options) {
  # Extends the input with kinematical information
  stats <- createJaspTable(gettext("Extended kinematics table"))

  # Show the input as a table
  stats$addColumnInfo(name = "t")
  stats$addColumnInfo(name = "x")
  stats$addColumnInfo(name = "y")

  stats[["t"]] <- dataset[, options$t]
  stats[["x"]] <- dataset[, options$x]
  stats[["y"]] <- dataset[, options$y]

  # Speeds
  if (options$doSpeeds) {
    if (options$speedsAsVectors) {
          stats$addColumnInfo(name = "vx") # TODO: too many output decimals
          stats$addColumnInfo(name = "vy")

          ## Use kinematics to calculate speeds
          speeds <- kinematics::speed(
            dataset[, options$t],
            dataset[, options$x],
            dataset[, options$y]
          )

          ## Append speeds to the table
          stats[["vx"]] <- speeds$vx
          stats[["vy"]] <- speeds$vy
    }
    if(options$speedsAsScalars) {
      stats$addColumnInfo(name = "v")
      speeds <- kinematics::speed(dataset[, options$t],
                                  dataset[, options$x],
                                  dataset[, options$y]
      )
      stats[["v"]] <- sqrt(speeds$vx^2 + speeds$vy^2)
    }
  }

  # Accelerations
  if (options$doAccels) {
    if(options$accelsAsVectors) {
      stats$addColumnInfo(name = "ax")
      stats$addColumnInfo(name = "ay")

      ## Use kinematics to calculate accelerations
      accels <- kinematics::accel(dataset[, options$t],
                                  dataset[, options$x],
                                  dataset[, options$y])

      ## Append accelerations to the table
      stats[["ax"]] <- accels$ax
      stats[["ay"]] <- accels$ay
    }
    if(options$accelsAsScalars) {
      stats$addColumnInfo(name = "a")
      accels <- kinematics::accel(dataset[, options$t],
                                  dataset[, options$x],
                                  dataset[, options$y])
      stats[["a"]] <- sqrt(accels$ax^2 + accels$ay^2)
    }
  }

  # Curvature
  if (options$doCurvatures) {
    if (options$asCurvature) {
      stats$addColumnInfo(name = "curvature")
      stats[["curvature"]] <- kinematics::curvature(dataset[, options$t],
                                                    dataset[, options$x],
                                                    dataset[, options$y])
    }
    if (options$asRadius) {
      stats$addColumnInfo(name = "curvature_radius")
      stats[["curvature_radius"]] <- kinematics::curvature_radius(dataset[, options$t],
                                                                  dataset[, options$x],
                                                                  dataset[, options$y])
    }
  }

  jaspResults[["stats"]] <- stats

  return()
}
