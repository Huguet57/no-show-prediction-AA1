Days <- unique(dd$AppointDay)
Months <- unique(dd$AppointMonth)
Locations <- unique(dd$Neighbourhood)

dd$People.same.day <- rep(NA, nrow(dd))

for (i.days in 1:length(Days)) {
  for (i.months in 1:length(Months)) {
    for (i.locations in 1:length(Locations)) {
      
      people.same.day <- which(dd$AppointDay == Days[i.days] &
                                 dd$AppointMonth == Months[i.months] &
                                 dd$Neighbourhood == Locations[i.locations])
      
      if (length(people.same.day) > 0) dd[people.same.day,]$People.same.day <- length(people.same.day)
      # TODO: Can we do something with AppointmentID? It is ordered by time (?)
      
    }
  }
}