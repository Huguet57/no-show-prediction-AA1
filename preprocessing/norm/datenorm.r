DYM <- getDYM(dd$ScheduledDay)
dd$SchedDay <- as.numeric(DYM$day)
dd$SchedMonth <- as.numeric(DYM$month)

HM <- getHM(dd$ScheduledDay)
dd$SchedHour <- as.numeric(HM$hour)
dd$SchedMinute <- as.numeric(HM$minute)

DYM <- getDYM(dd$AppointmentDay)
dd$AppointDay <- as.numeric(DYM$day)
dd$AppointMonth <- as.numeric(DYM$month)

dd$ScheduledDay <- NULL
dd$AppointmentDay <- NULL
dd$DateDiff <- dateDiff(dd)