library(textclean)

neighs.norm <- replace_non_ascii(neighs)
neighs.norm <- sub("´", "", neighs.norm, fixed = TRUE)
neighs.norm <- gsub(" ", "_", neighs.norm, fixed = TRUE)
neighs.norm <- sapply(neighs.norm, tolower)

neighs.norm <- sub("_do_", "_", neighs.norm)
neighs.norm <- sub("_das_", "_", neighs.norm)
neighs.norm <- sub("_da_", "_", neighs.norm)
neighs.norm <- sub("_de_", "_", neighs.norm)

barris$Barrio <- sub("_do_", "_", barris$Barrio)
barris$Barrio <- sub("_das_", "_", barris$Barrio)
barris$Barrio <- sub("_da_", "_", barris$Barrio)
barris$Barrio <- sub("_de_", "_", barris$Barrio)
