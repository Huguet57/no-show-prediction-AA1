barris <- read.csv("./feats/neighs/barris_info/barris_info.csv",
                   fileEncoding = "UTF-8")
neighs <- dd$Neighbourhood

source('./feats/neighs/neighsnorm.r')

dd$Neighbourhood <- neighs.norm
dd <- dd[-(dd$Neighbourhood == "ilhas_oceanicas_trindade"),]

source('./feats/neighs/mergeinfo.r')
