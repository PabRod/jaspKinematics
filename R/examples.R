ProcessTable <- function(jaspResults, dataset, options) {
  # Extends the input with kinematical information
  stats <- createJaspTable(gettext("Extended kinematics table"))
  stats$dependOn(c("t", "x", "y", "sf"))

  # Show the input as a table
  stats$addColumnInfo(name = "t")
  stats$addColumnInfo(name = "x")
  stats$addColumnInfo(name = "y")

  stats[["t"]] <- dataset[, options$t]
  stats[["x"]] <- dataset[, options$x]
  stats[["y"]] <- dataset[, options$y]

  ## All functions in kinematics have the very same arguments.
  ## Let's collect them on a list:
  args <- list(
    dataset[, options$t],
    dataset[, options$x],
    dataset[, options$y]
  )
  ## So we can pass them to the functions using the one-liner
  ## do.call(<function>, args)

  ## The user can input the number of significant figures to show
  ## this only has aesthetic effects and doesn't affect the calculations
  if (options$sf == 1) {
    fmt <- "pc" # TODO: remove this, it is only here for debug purposes
  } else {
    fmt <- paste("sf:", options$sf, sep = "")
  }

  # Speeds
  if (options$doSpeeds) {
    ## Use kinematics to calculate speeds
    speeds <- do.call(kinematics::speed, args)

    ## Append the output to the table in the desired format
    if (options$speedsAsVectors) {
          stats$addColumnInfo(name = "vx", format = fmt)
          stats$addColumnInfo(name = "vy", format = fmt)

          stats[["vx"]] <- speeds$vx
          stats[["vy"]] <- speeds$vy
    }

    if(options$speedsAsScalars) {
      stats$addColumnInfo(name = "v", format = fmt)
      stats[["v"]] <- sqrt(speeds$vx^2 + speeds$vy^2)
    }

  }

  # Accelerations
  if (options$doAccels) {
    ## Use kinematics to calculate accelerations
    accels <- do.call(kinematics::accel, args)
    
    ## Append the output to the table in the desired format
    if(options$accelsAsVectors) {
      stats$addColumnInfo(name = "ax", format = fmt)
      stats$addColumnInfo(name = "ay", format = fmt)

      stats[["ax"]] <- accels$ax
      stats[["ay"]] <- accels$ay
    }
    if(options$accelsAsScalars) {
      stats$addColumnInfo(name = "a", format = fmt)
      stats[["a"]] <- sqrt(accels$ax^2 + accels$ay^2)
    }
  }

  # Curvature
  if (options$doCurvatures) {
    ## Use kinematics to calculate curvatures
    curvs <- do.call(kinematics::curvature, args)

    ## Append accelerations to the table
    if (options$asCurvature) {
      stats$addColumnInfo(name = "curvature", format = fmt)
      stats[["curvature"]] <- curvs
    }
    if (options$asRadius) {
      stats$addColumnInfo(name = "curvature_radius", format = fmt)
      stats[["curvature_radius"]] <- 1 / curvs
    }
  }

  jaspResults[["stats"]] <- stats

  jaspResults$addCitation("Results table created using kinematics. (https://github.com/PabRod/kinematics)")

  return()
}
