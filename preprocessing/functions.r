encodeNeighbourhood <- function(name) {
  name <- replace(name, " ", "")
  s <- nchar(name)
  
  A <- substr(name, 1, 2)
  B <- substr(name, s-3, s)
  
  paste(A, B, sep = "")
}

getDYM <- function(date) {
  year <- substr(date, 0,4)
  month <- substr(date, 6,7)
  day <- substr(date, 9,10)
  
  data.frame(day=day, month=month, year=year, stringsAsFactors = FALSE)
}

getHM <- function(date) {
  hour <- substr(date, 12,13)
  minute <- substr(date, 15,16)
  data.frame(hour=hour,minute=minute, stringsAsFactors = FALSE)
}

dateDiff <- function(dd) {
  days <- (dd$AppointDay - dd$SchedDay)
  month <- (dd$AppointMonth - dd$SchedMonth)*30
  year <- (dd$AppointYear - dd$SchedYear)*365

  days + month + year
}