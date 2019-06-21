Days <- unique(dd$AppointDay)
Months <- unique(dd$AppointMonth)
Locations <- unique(dd$Neighbourhood)

DML <- expand.grid(Days = Days,
                  Months = Months,
                  Locations = Locations)

DML <- as.data.frame(DML)

dd$People.same.day <- rep(NA, nrow(dd))
N <- nrow(DML)

library(parallel)
numCores <- detectCores()
cl <- makeCluster(numCores)

library(foreach)
library(doParallel)
registerDoParallel(cl)

system.time({
  foreach (i=1:N) %dopar% {
    people.same.day <- which(dd$AppointDay == DML[i,]$Days &
                             dd$AppointMonth == DML[i,]$Months &
                             dd$Neighbourhood == DML[i,]$Locations)
    
    if (length(people.same.day) > 0) dd[people.same.day,]$People.same.day <- length(people.same.day)
    # TODO: Can we do something with AppointmentID? It is ordered by time (?)
  }
})

stopCluster(cl)