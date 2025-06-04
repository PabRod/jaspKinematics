ProcessTable <- function(jaspResults, dataset, options) {

  # Create and show an empty input table. It will be filled soon
  stats <- createJaspTable(gettext("Extended kinematics table"))
  jaspResults$addCitation("Results table created using kinematics. (https://github.com/PabRod/kinematics)")
  stats$addColumnInfo(name = "t")
  stats$addColumnInfo(name = "x")
  stats$addColumnInfo(name = "y")
  jaspResults[["stats"]] <- stats

  # Basic input logic
  # Used for appending the t, x and y vectors to the stats object.
  #
  # Returns TRUE at success, FALSE otherwise
  .ready <- function(id) {
    tryCatch(
      {
        # We need at least 3 data points to compute accelerations
        ready <- length(dataset[, options[[id]]]) >= 3
        stats[[id]] <- dataset[, options[[id]]] # This allows to fill the table
        # column by column. Only intended for improving user experience

        return(TRUE)
      },
      error = function(e) {
        return(FALSE)

        # This error is typically triggered by:
        #
        # 1. Undefined vectors (i.e: inexistent dataset[, options[[id]])
        # 2. Too short vectors
        #
        # Scenario 1 will ALWAYS happen during data input until all data has
        # been added. We want to return a FALSE control parameter without
        # crashing the whole program.
      }
    )
  }

  # Is all the required data available?
  ready_all <- .ready("t") & .ready("x") & .ready("y")
  # If the answer is no, stop right here, keep waiting, and avoid ugly error messages
  if (!ready_all) return()
  # If the answer is yes, keep going

  ## All functions in kinematics have the very same arguments, namely t, x, y.
  ## Let's collect them on a list:
  args <- list(
    dataset[, options$t],
    dataset[, options$x],
    dataset[, options$y]
  )
  ## So we can pass them to the functions using the one-liner
  ## do.call(<function>, args)

  # Append the desired kinematic information to the stats table
  ## Speeds
  if (options$doSpeeds)     stats <- .speeds(stats, args, options)
  ## Accelerations
  if (options$doAccels)     stats <- .accels(stats, args, options)
  ## Curvatures
  if (options$doCurvatures) stats <- .curvs(stats, args, options)

  # Refresh results table
  jaspResults[["stats"]] <- stats

  return()
}

## Auxiliary function to append speeds to stats
.speeds <- function(stats, args, options) {
    ## Use kinematics to calculate speeds
    speeds <- do.call(kinematics::speed, args)

    ## Append the output to the table in the desired format(s)
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

    return(stats)
}

## Auxiliary function to append accelerations to stats
.accels <- function(stats, args, options) {
      ## Use kinematics to calculate accelerations
    accels <- do.call(kinematics::accel, args)

    ## Append the output to the table in the desired format(s)
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

    return(stats)
}

## Auxiliary function to append curvatures to stats
.curvs <- function(stats, args, options) {
    ## Use kinematics to calculate curvatures
    curvs <- do.call(kinematics::curvature, args)

    ## Append the output to the table in the desired format(s)
    if (options$asCurvature) {
      stats$addColumnInfo(name = "curvature")
      stats[["curvature"]] <- curvs
    }
    if (options$asRadius) {
      stats$addColumnInfo(name = "curvature_radius")
      stats[["curvature_radius"]] <- 1 / curvs
    }

    return(stats)
}