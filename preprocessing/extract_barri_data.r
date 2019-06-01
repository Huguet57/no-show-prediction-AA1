## Dades extretes de: http://legado.vitoria.es.gov.br/regionais/geral/bairros.asp

setwd("C:\\Users\\andreu.huguet\\Downloads\\no-show-prediction-AA1-master")
dd <- read.csv("hospital.csv", encoding = "UTF-8")

unique(dd$Neighbourhood)

head(dd)

library(pdftables)
library(base)

# Obtenim els noms dels PDF per canviar-los a CSV

barris.names <- list.files("../barris_pdf")

for (i in c(1:80)) {
  name.length <- nchar(barris.names[i])
  barris.names[i] <- substr(barris.names[i], 0, name.length - 4)
}

barris.names

for (i in c(50:80)) {
  csv.name <- paste("../barris_csv/", paste(barris.names[i], ".csv", sep = ""), sep = "")
  pdf.name <- paste("../barris_pdf/", paste(barris.names[i], ".pdf", sep = ""), sep = "")
  # convert_pdf(pdf.name, csv.name, api_key = "31r4vr79w4vb")
}

# Ara mirem els .csv per trobar la taula de dades socio-econòmiques

barris.csv <- list.files("../barris_csv")

for (i in c(1:2)) {
  name.length <- nchar(barris.csv[i])
  barris.csv[i] <- substr(barris.csv[i], 0, name.length - 4)
}

barri.frame <- data.frame(Barrio = rep(NA, 80),
                          Area = rep(NA, 80),
                          Population = rep(NA, 80),
                          Men = rep(NA, 80),
                          Women = rep(NA, 80),
                          Renda = rep(NA, 80))

for (i in c(1:80)) {
  
  if (i == 51) {
    
    barri.frame[i, 1] <- "parque_industrial"
    barri.frame[i, 2] <- 17.517
    barri.frame[i, 3] <- 0
    barri.frame[i, 4] <- 0
    barri.frame[i, 5] <- 0
    barri.frame[i, 6] <- 0
    
  } else {
    
    csv.name <- paste("../barris_csv/", paste(barris.names[i], ".csv", sep = ""), sep = "")
    whole.map <- read.csv(csv.name, stringsAsFactors = FALSE, dec=",")
    colnames(whole.map) <- paste("X", 1:ncol(whole.map), sep = ".")
    # print(nrow(whole.map)) # de 89 està entre 75 i 81
    
    row.with.data <- 0
    col.with.data <- 0
    
    # Buscarem la row on hi ha la paraula "DADOS"
    
    for (j in c(1:ncol(whole.map))) {
      if (grep("^DADOS", whole.map[,j]) != 0) {
        row.with.data <- grep("^DADOS", whole.map[,j])
        col.with.data <- j
        break
      }
    }
    
    row.with.final.data <- 0
    
    # Buscarem la row on hi ha la paraula "1.661,99"
    
    for (j in c(1:ncol(whole.map))) {
      if (sum(grep("^1.661,99", whole.map[,j])) != 0) {
        row.with.final.data <- grep("^1.661,99", whole.map[,j])
        break
      }
    }
    
    col.with.final.data <- 0
    
    row.with.data
    row.with.final.data
    
    table.with.data <- whole.map[(row.with.data + 2):(row.with.final.data),]
    table.with.data <- table.with.data[,colSums(table.with.data != "", na.rm = TRUE) != 0]
    
    perc.found <- 5
    
    for (k in 1:ncol(table.with.data)) {
      perc.found <- max(perc.found,
                        sum(grep("%$", t(table.with.data[perc.k,]))))
    }
    
    col.interval <- (col.with.data):(perc.found - 1)
    table.with.data <- table.with.data[, col.interval]
  
    table.with.data <- table.with.data[rowSums(table.with.data != "", na.rm = TRUE) != 0,]
    
    for (kk in 1:3) {
      for (ii in 1:nrow(table.with.data)) {
        for (jj in 1:(ncol(table.with.data) - 1)) {
          if (table.with.data[ii,jj] == "") {
            table.with.data[ii,jj] <- table.with.data[ii,jj + 1]
            table.with.data[ii,jj + 1] <- ""
          }
        }
      }
    }
    
    table.with.data <- table.with.data[,colSums(table.with.data != "", na.rm = TRUE) != 0,]
    barri.info <- table.with.data[,3]
    
    barri.frame[i, 1] <- barris.names[i]
    barri.frame[i, 2] <- barri.info[1]
    barri.frame[i, 3] <- barri.info[2]
    barri.frame[i, 4] <- barri.info[3]
    barri.frame[i, 5] <- barri.info[4]
    barri.frame[i, 6] <- barri.info[5]
  }
}

# Hi faltava un valor i s'havia mogut tot
barri.frame[40, 6] <- barri.frame[40, 5]
barri.frame[40, 5] <- barri.frame[40, 4]
barri.frame[40, 4] <- barri.frame[40, 3]
barri.frame[40, 3] <- barri.frame[40, 2]
barri.frame[40, 2] <- "0,20"

# Data missing, hi posem la mitjana perquè no molesti
barri.frame[62, 6] <- "1.661,99"

barri.frame[,2] <- as.numeric(sub(",", ".", barri.frame[,2], fixed = TRUE))
barri.frame[,3] <- as.numeric(sub(".", "", barri.frame[,3], fixed = TRUE))
barri.frame[,4] <- as.numeric(sub(".", "", barri.frame[,4], fixed = TRUE))
barri.frame[,5] <- as.numeric(sub(".", "", barri.frame[,5], fixed = TRUE))
barri.frame[,6] <- as.numeric(sub(",", ".", sub(".", "", barri.frame[,6], fixed = TRUE), fixed = TRUE))


summary(barri.frame)

hist(barri.frame[,3]/barri.frame[,2])
hist(barri.frame[,6])

barri.frame <- data.frame(barri.frame, Density = barri.frame[,3]/barri.frame[,2])

write.csv(barri.frame,
          file = paste("../barris_info.csv"),
          fileEncoding = "UTF-8")
