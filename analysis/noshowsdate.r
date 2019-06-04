# 1. Carreguem les dades
DIR <- '~/no-show-prediction-AA1/'
setwd(paste(DIR, "analysis/", sep = ""))
dd <- read.csv(paste(DIR, "data.csv", sep = ""),
               fileEncoding = 'UTF-8')

# 2. Fem una taula amb els dies, mesos i noshows/shows d'aquella data
N.d <- length(unique(dd$AppointDay))
N.m <- length(unique(dd$AppointMonth))
hist.noshows <- data.frame(day = integer(),
                           month = integer(),
                           noshows = integer(),
                           shows = integer())

# 2.1. Per cada dia i mes, mirem quants noshows/shows hi ha
for (i.m in 1:N.m) {
  for (i.d in 1:N.d) {
    d <- sort(unique(dd$AppointDay))[i.d]
    m <- sort(unique(dd$AppointMonth))[i.m]
    appoints.dm <- which(dd$AppointDay == d
                         & dd$AppointMonth == m)
    
    if (length(appoints.dm) > 0) {
      new.dm <- list(day = d,
                     month = m,
                     noshows = sum(dd[appoints.dm,]$No.show == "NoShow"),
                     shows = sum(dd[appoints.dm,]$No.show == "Show"))
      
      hist.noshows <- rbind(hist.noshows, new.dm)
    }
  }
}

# 3. Anomalies
# 3.1. Treiem el dissabte (cas excepcional de 39 appointments)
hist.noshows <- hist.noshows[-which(hist.noshows$shows < 600),]

# 4. Mirem els resultats i la relació entre NoShows i les dates
barplot(hist.noshows$noshows)
barplot(hist.noshows$shows)
barplot(hist.noshows$noshows/(hist.noshows$noshows + hist.noshows$shows))
hist.noshows