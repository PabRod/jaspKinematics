ProcessTable <- function(jaspResults, dataset, options) {

  # Show an empty input table, to be filled soon
  stats <- createJaspTable(gettext("Extended kinematics table"))
  stats$addColumnInfo(name = "t")
  stats$addColumnInfo(name = "x")
  stats$addColumnInfo(name = "y")
  jaspResults[["stats"]] <- stats

  # Basic ready logic
  .ready <- function(id) {
    tryCatch(
      {
        # We need at least 3 data points to compute accelerations
        ready <- length(dataset[, options[[id]]]) >= 3
        stats[[id]] <- dataset[, options[[id]]] # This allows to fill the table
        # column by column. Only intended for improving UX

        return(TRUE)
      },
      error = function(e) {
        return(FALSE)
      }
    )
  }

  # Only proceed when we have all the information we need
  # This avoids showing an ugly error message
  ready_all <- .ready("t") & .ready("x") & .ready("y")
  if (!ready_all) return()

  ## All functions in kinematics have the very same arguments.
  ## Let's collect them on a list:
  args <- list(
    dataset[, options$t],
    dataset[, options$x],
    dataset[, options$y]
  )
  ## So we can pass them to the functions using the one-liner
  ## do.call(<function>, args)

  # Speeds
  if (options$doSpeeds) {
    ## Use kinematics to calculate speeds
    speeds <- do.call(kinematics::speed, args)

    ## Append the output to the table in the desired format
    if (options$speedsAsVectors) {
          stats$addColumnInfo(name = "vx")
          stats$addColumnInfo(name = "vy")

          stats[["vx"]] <- speeds$vx
          stats[["vy"]] <- speeds$vy
    }

    if (options$speedsAsScalars) {
      stats$addColumnInfo(name = "v")
      stats[["v"]] <- sqrt(speeds$vx^2 + speeds$vy^2)
    }

  }

  # Accelerations
  if (options$doAccels) {
    ## Use kinematics to calculate accelerations
    accels <- do.call(kinematics::accel, args)

    ## Append the output to the table in the desired format
    if (options$accelsAsVectors) {
      stats$addColumnInfo(name = "ax")
      stats$addColumnInfo(name = "ay")

      stats[["ax"]] <- accels$ax
      stats[["ay"]] <- accels$ay
    }
    if (options$accelsAsScalars) {
      stats$addColumnInfo(name = "a")
      stats[["a"]] <- sqrt(accels$ax^2 + accels$ay^2)
    }
  }

  # Curvature
  if (options$doCurvatures) {
    ## Use kinematics to calculate curvatures
    curvs <- do.call(kinematics::curvature, args)

    ## Append accelerations to the table
    if (options$asCurvature) {
      stats$addColumnInfo(name = "curvature")
      stats[["curvature"]] <- curvs
    }
    if (options$asRadius) {
      stats$addColumnInfo(name = "curvature_radius")
      stats[["curvature_radius"]] <- 1 / curvs
    }
  }

  jaspResults[["stats"]] <- stats

  jaspResults$addCitation("Results table created using kinematics. (https://github.com/PabRod/kinematics)")

  return()

}
