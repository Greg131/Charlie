# ----------------------------------------------------------
# Datathon SNCF Simplon - Where is Charlie
# ----------------------------------------------------------

setwd("~/Dropbox/Datascience/Datathon Simplon.co x SNCF/Scripts")
getwd() # Get working directory 

if (!file.exists("../data"))       {
  dir.create("../data")
}

? read.csv

# Lecture des fichiers
PI_TAG <- read.csv("../data/PI_TAG DCT.csv", sep = ";",check.names = FALSE)
PI_TAG2 <- read.csv("../data/PI_TAG DCT.csv", sep = ";",header = FALSE, skip = 1)
# pb dans les noms de variables à régler
                   
Fonctions_AS <- read.csv("../data/Fonctions_AS.csv", fileEncoding = "UTF-16LE",sep = "\t")

Liste_AVP <- read.csv("../data/Liste_AVP.csv",fileEncoding = "UTF-16LE",sep = "\t")

Liste_CTV <- read.csv("../data/Liste_CTV.csv",fileEncoding = "UTF-16LE",sep = "\t")

Liste_EALE <- read.csv("../data/Liste_EALE.csv",fileEncoding = "UTF-16LE",sep = "\t")

Liste_PN <- read.csv("../data/Liste_PN.csv",fileEncoding = "UTF-16LE",sep = "\t")

Liste_Postes <- read.csv("../data/Liste_Postes.csv",fileEncoding = "UTF-16LE",sep = "\t")

Liste_SAF_ADM <- read.csv("../data/Liste_SAF_ADM.csv",fileEncoding = "UTF-16LE",sep = "\t")

Liste_Sous_Stations_SE <- read.csv("../data/Liste_Sous_Stations_SE.csv",fileEncoding = "UTF-16LE",sep = "\t")

Liste_Zones_Cdv <- read.csv("../data/Liste_Zones_Cdv.csv",fileEncoding = "UTF-16LE",sep = "\t")

Referentiel_geomocalisation <- read.csv("../data/Referentiel geolocalisation.csv", sep = ";")

Temperatures_PI <- read.csv("../data/Temperatures_PI.csv", sep = "\t",dec = ",")

            )
str(Temperatures_PI)
summary(Temperatures_PI)
Temperatures_PI
