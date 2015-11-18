# ----------------------------------------------------------
# Datathon SNCF Simplon - Sujet 4 : "Où est Charlie?"
# ----------------------------------------------------------

setwd("~/Dropbox/Datascience/Datathon Simplon.co x SNCF/charlie")
getwd() # Get working directory 

# Les fichiers de données sont supposés être dans le répertoire ../data

? read.csv

# ------------------------------------------------------------------------------
# Lecture des fichier et changement en mémoire
# ------------------------------------------------------------------------------

## Objets de patrimoine : 
## Passages à niveau 
Liste_PN <- read.csv("../data/Liste_PN.csv",fileEncoding = "UTF-16LE",sep = "\t")
## Apareils de voie
Liste_AVP <- read.csv("../data/Liste_AVP.csv",fileEncoding = "UTF-16LE",sep = "\t")
## Circuits de voie
Liste_Zones_Cdv <- read.csv("../data/Liste_Zones_Cdv.csv",fileEncoding = "UTF-16LE",sep = "\t")

## Fichiers d'incidents :
## Maintenance 
REX_Incidents <- read.csv("../data/REX_Incidents.csv", sep = ";",check.names = FALSE)
REX_SIG <- read.csv("../data/REX SIG.csv", sep = ";",check.names = FALSE)
## Suivi des composants
PI_TAG_DCT <- read.csv("../data/PI_TAG DCT.csv", sep = ";",check.names = FALSE)
## Installation signal
Fonctions_AS_IdF <- read.csv("../data/Fonctions_AS_Idf.csv", fileEncoding = "UTF-16LE",sep = "\t")

## Référentiel geolocalisation
Referentiel_geolocalisation <- read.csv("../data/Referentiel geolocalisation.csv", sep = ";", dec = ",",
                                        colClasses = c("integer","integer","numeric","numeric"))




#Liste_CTV <- read.csv("../data/Liste_CTV.csv",fileEncoding = "UTF-16LE",sep = "\t")
#Liste_EALE <- read.csv("../data/Liste_EALE.csv",fileEncoding = "UTF-16LE",sep = "\t")
#Liste_Postes <- read.csv("../data/Liste_Postes.csv",fileEncoding = "UTF-16LE",sep = "\t")
#Liste_SAF_ADM <- read.csv("../data/Liste_SAF_ADM.csv",fileEncoding = "UTF-16LE",sep = "\t")
#Liste_Sous_Stations_SE <- read.csv("../data/Liste_Sous_Stations_SE.csv",fileEncoding = "UTF-16LE",sep = "\t")
#Temperatures_PI <- read.csv("../data/Temperatures_PI.csv", sep = "\t",dec = ",")

# ------------------------------------------------------------------------------
# Fonction donnant les coordonnées Lambert 
# X Y à partir d'une voie et d'un PK
# ------------------------------------------------------------------------------

## Exploration table geolocalisation
head(Referentiel_geolocalisation)
tail(Referentiel_geolocalisation)
summary(Referentiel_geolocalisation)
str(Referentiel_geolocalisation)
names(Referentiel_geolocalisation)
## Liste des lignes
unique(Referentiel_geolocalisation$LIGNE)

lambert <- function(ligne, pk) {
  Ref <- subset(Referentiel_geolocalisation, (LIGNE == ligne))
  Ref$distance <- abs(Ref$PK-pk)
  Ref[which.min(Ref$distance), ]
}

## Tests
a <- lambert(1000,1000)
b <- lambert(1000,100)

lambert(963506,130233)
lambert(242910,130233)
lambert(963506,130233)
lambert(963506,130233)

a$X
b$Y
a

# ------------------------------------------------------------------------------
# Ajout des coordonnés Lambert approchés X et Y aux objets de patrimoine
# ------------------------------------------------------------------------------

## Passages à niveau

Liste_PN$X <- 0
Liste_PN$Y <- 0
Liste_PN$ApproxLambert <- -1

for (i in seq_len(nrow(Liste_PN))) {
        lamb <- lambert(Liste_PN[i,]$LIGNE,Liste_PN[i,]$PK)
        if (nrow(lamb) == 1) {
                Liste_PN[i,]$X <- lamb$X 
                Liste_PN[i,]$Y <- lamb$Y 
                Liste_PN[i,]$ApproxLambert <- lamb$distance 
        } else { # cas ou l'on n'a pas trouvé de coordonné lambert ....
                Liste_PN[i,]$X <- 0
                Liste_PN[i,]$Y <- 0
                Liste_PN[i,]$ApproxLambert <- -1
        }
}

## Estimation et exploration des trous 
missing <- subset(Liste_PN, ApproxLambert == -1)
nrow(missing)
rate <- 1-nrow(missing)/(nrow(Liste_PN))
rate
## 95,5%
unique(missing$LIGNE)
## les lignes 963506 570316 687000 242910 233000 ne figurents pas dans la base 
## de géolocalisation
eval <- subset(Liste_PN, ApproxLambert != -1)
mean(eval$ApproxLambert)
## 93 m
sd(eval$ApproxLambert)
max(eval$ApproxLambert)
## > 5000 m !
hist(eval$ApproxLambert, col = "green", breaks = 100, 
     main = "PN Histogram of geolocalisation approx", xlab = "Approx in m")
hist(eval$ApproxLambert, col = "green", breaks = 100, 
     main = "PN Histogram of geolocalisation approx", xlab = "Approx in m",
     xlim = c(0,500))
abline(v=median(eval$ApproxLambert), col = "red" ,lwd =2)

## Etude de l'approximation de géolocalisation
far <- subset(Liste_PN, ApproxLambert > 1000)
nrow(far)
rate <- 1 - nrow(far)/nrow(eval)
rate
## 99,3% approximés à moin de 1000 m
## Visualisation localisation et approximations ...
eval <- subset(Liste_PN, ApproxLambert != -1)
eval$far <- "Close"
eval[eval$ApproxLambert > 1000,]$far <- "Far"
with(subset(eval, far == "Close"), plot(X,Y, col = "black", main = "Passages à niveau"))
with(subset(eval, far == "Far"), points(X,Y, col = "red", pch = 4))
legend("topright", pch = c(1,4), col = c("black","red"), legend = c("OK",">1000m"))


## Appareils de voie

Liste_AVP$X <- 0
Liste_AVP$Y <- 0
Liste_AVP$ApproxLambert <- -1

for (i in seq_len(nrow(Liste_AVP))) {
        lamb <- lambert(Liste_AVP[i,]$LIGNE,Liste_AVP[i,]$PK)
        if (nrow(lamb) == 1) {
                Liste_AVP[i,]$X <- lamb$X # Ajout des coordonnées de lambert approchés
                Liste_AVP[i,]$Y <- lamb$Y # Ajout des coordonnées de lambert approchés
                Liste_AVP[i,]$ApproxLambert <- lamb$distance # Ajout des coordonnées de lambert approchés
        } else { # cas ou l'on n'a pas trouvé de coord lambert ....
                Liste_AVP[i,]$X <- 0
                Liste_AVP[i,]$Y <- 0
                Liste_AVP[i,]$ApproxLambert <- -1
        }
}

## Estimation et exploration des trous 
missing <- subset(Liste_AVP, ApproxLambert == -1)
nrow(missing)
rate <- 1-nrow(missing)/(nrow(Liste_AVP))
rate
## 99,7%
unique(missing$LIGNE)
## les lignes 72311  70606 242910 272316 752321 570316 762000 956306 957306 
## 963506 980106 ne figurents pas dans la base de géolocalisation
## Distribution de l'approximation
eval <- subset(Liste_AVP, ApproxLambert != -1)
mean(eval$ApproxLambert)
## 82 m
sd(eval$ApproxLambert)
max(eval$ApproxLambert)
## > 5000 m !
hist(eval$ApproxLambert, col = "green", breaks = 100, 
     main = "PN Histogram of geolocalisation approx", xlab = "Approx in m")
hist(eval$ApproxLambert, col = "green", breaks = 100, 
     main = "PN Histogram of geolocalisation approx", xlab = "Approx in m",
     xlim = c(0,500))
abline(v=median(eval$ApproxLambert), col = "red" ,lwd =2)
## Etude de l'approximation de géolocalisation
far <- subset(Liste_AVP, ApproxLambert > 1000)
nrow(far)
rate <- 1 - nrow(far)/nrow(eval)
rate
## 99,6% approximés à moin de 1000 m
## Visualisation localisation et approximations ...
eval <- subset(Liste_AVP, ApproxLambert != -1)
eval$far <- "Close"
eval[eval$ApproxLambert > 1000,]$far <- "Far"
with(subset(eval, far == "Close"), plot(X,Y, col = "black", main = "Appareils de voie"))
with(subset(eval, far == "Far"), points(X,Y, col = "red", pch = 4))
legend("topright", pch = c(1,4), col = c("black","red"), legend = c("OK",">1000m"))



## Circuits de voie

Liste_Zones_Cdv$X <- 0
Liste_Zones_Cdv$Y <- 0
Liste_Zones_Cdv$ApproxLambert <- -1

for (i in seq_len(nrow(Liste_Zones_Cdv))) {
        lamb <- lambert(Liste_Zones_Cdv[i,]$LIGNE,(Liste_Zones_Cdv[i,]$PKD+Liste_Zones_Cdv[i,]$PKF)/2)
        # on prend le milieu PKD+PKF comme reference
        if (nrow(lamb) == 1) {
                Liste_Zones_Cdv[i,]$X <- lamb$X # Ajout des coordonnées de lambert approchés
                Liste_Zones_Cdv[i,]$Y <- lamb$Y # Ajout des coordonnées de lambert approchés
                Liste_Zones_Cdv[i,]$ApproxLambert <- lamb$distance 
        } else { # cas ou l'on n'a pas trouvé de coord lambert ....
                Liste_Zones_Cdv[i,]$X <- 0
                Liste_Zones_Cdv[i,]$Y <- 0 
                Liste_Zones_Cdv[i,]$ApproxLambert <- -1
        }
}



## Estimation et exploration des trous 
missing <- subset(Liste_Zones_Cdv, ApproxLambert == -1)
nrow(missing)
rate <- 1-nrow(missing)/(nrow(Liste_Zones_Cdv))
rate
## 99,9%
unique(missing$LIGNE)
## les lignes 272316 963506 752321 570316  72311 956306 
## ne figurents pas dans la base de géolocalisation
## Distribution de l'approximation
eval <- subset(Liste_Zones_Cdv, ApproxLambert != -1)
mean(eval$ApproxLambert)
## 89 m
sd(eval$ApproxLambert)
max(eval$ApproxLambert)
## > 5000 m !
hist(eval$ApproxLambert, col = "green", breaks = 100, 
     main = "CDV Histogram of geolocalisation approx", xlab = "Approx in m")
hist(eval$ApproxLambert, col = "green", breaks = 100, 
     main = "CDV Histogram of geolocalisation approx", xlab = "Approx in m",
     xlim = c(0,500))
abline(v=median(eval$ApproxLambert), col = "red" ,lwd =2)
## Etude de l'approximation de géolocalisation
far <- subset(Liste_Zones_Cdv, ApproxLambert > 1000)
nrow(far)
rate <- 1 - nrow(far)/nrow(eval)
rate
## 99,6% approximés à moin de 1000 m
## Visualisation localisation et approximations ...
eval <- subset(Liste_Zones_Cdv, ApproxLambert != -1)
eval$far <- "Close"
eval[eval$ApproxLambert > 1000,]$far <- "Far"
with(subset(eval, far == "Close"), plot(X,Y, col = "black", main = "Circuits de voie"))
with(subset(eval, far == "Far"), points(X,Y, col = "red", pch = 4))
legend("topright", pch = c(1,4), col = c("black","red"), legend = c("OK",">1000m"))

# ------------------------------------------------------------------------------
# Construction d'une base de patrimoine
# ------------------------------------------------------------------------------

# a developper....

# ------------------------------------------------------------------------------
# Fonction retournant les actifs PN dans un rayon de p (500 m par défaut)
# ------------------------------------------------------------------------------

Liste_PN_voisins <- function(X, Y, rayon = 500) {
  Liste_PN_voisins <- Liste_PN
  # Calcul et ajout de la distance euclidienne 
  Liste_PN_voisins$distance <- sqrt((Liste_PN_voisins$X-X)^2+(Liste_PN_voisins$Y-Y)^2)
  
  Liste_PN_voisins <- subset(Liste_PN_voisins, distance < rayon)
  Liste_PN_voisins
}

Liste_PN_voisins(586796.1,6816543,2000)
Liste_PN_voisins(586796.1,6816543,200)

# ----------------------------------------------------------
# Fonction retournant les actifs AVP dans un rayon de p (500 m par défaut)
# ----------------------------------------------------------

Liste_AVP_voisins <- function(X, Y, rayon = 500) {
  Liste_AVP_voisins <- Liste_AVP
  # Calcul et ajout de la distance euclidienne 
  Liste_AVP_voisins$distance <- sqrt((Liste_AVP_voisins$X-X)^2+(Liste_AVP_voisins$Y-Y)^2)
  
  Liste_AVP_voisins <- subset(Liste_AVP_voisins, distance < rayon)
  Liste_AVP_voisins
}

Liste_AVP_voisins(586796.1,6816543,200)

# ------------------------------------------------------------------------------
# Fonction retournant les actifs Circuit de Voie dans un rayon de p (500 m par défaut)
# ------------------------------------------------------------------------------

Liste_Zones_Cdv_voisins <- function(X, Y, rayon = 500) {
  Liste_Zones_Cdv_voisins <- Liste_Zones_Cdv
  # Calcul et ajout de la distance euclidienne 
  Liste_Zones_Cdv_voisins$distance <- sqrt((Liste_Zones_Cdv_voisins$X-X)^2+(Liste_Zones_Cdv_voisins$Y-Y)^2)
  
  Liste_Zones_Cdv_voisins <- subset(Liste_Zones_Cdv_voisins, distance < rayon)
  Liste_Zones_Cdv_voisins
}

Liste_Zones_Cdv_voisins(586796.1,6816543,200)
Liste_Zones_Cdv_voisins(586796.1,6816543,2000)

# ------------------------------------------------------------------------------
# Fonctions donnant pour une voie donnée et un pk donné
# le AVP le plus proche sur la ligne
# le PN le plus proche sur la ligne
# le Cdv le plus proche sur la ligne
# ------------------------------------------------------------------------------

PN_proche <- function(ligne, pk) {
  PN <- subset(Liste_PN, (LIGNE == ligne))
  PN$distance <- abs(PN$PK - pk)
  PN <- PN[which.min(PN$distance), ]
  PN
}

PN_proche(1000,32000)

PNxxx_proche <- function(ligne, pk, num) {
  PNxxx <- subset(Liste_PN, (LIGNE == ligne) & (Num_PN == num))
  PNxxx$distance <- abs(PNxxx$PK - pk)
  PNxxx <- PNxxx[which.min(PNxxx$distance), ]
  PNxxx
}

PNxxx_proche(1000,32000,12)
PNxxx_proche(10001,32000,12)



AVP_proche <- function(ligne, pk) {
  AVP <- subset(Liste_AVP, (LIGNE == ligne))
  AVP$distance <- abs(AVP$PK - pk)
  AVP <- AVP[which.min(AVP$distance), ]
  AVP
}

AVP_proche(1000,2004)

Cdv_proche <- function(ligne, pk) {
  Cdv <- subset(Liste_Zones_Cdv, (LIGNE == ligne))
  Cdv$distance <- abs((Cdv$PKD + Cdv$PKF)/2 - pk)
  Cdv <- Cdv[which.min(Cdv$distance), ]
  Cdv
}

Cdv_proche(1000,2100)



# ------------------------------------------------------------------------------
# Analyse du fichier REX_Incidents
# ------------------------------------------------------------------------------

str(REX_Incidents)
summary(REX_Incidents)

## Fichiers d'incidents :
## Maintenance 
REX_Incidents <- read.csv("../data/REX_Incidents.csv", sep = ";",
                          check.names = FALSE, fileEncoding = "WINDOWS-1252")

REX_Incidents <- read.csv("../data/REX_Incidents.csv", sep = ";",
                          check.names = FALSE,nrows = 200, fileEncoding = "WINDOWS-1252")

REX_Incidents$Type <- "Inconnu"

names(REX_Incidents)
## Analyse du champ `IO - Libellé de la ressource`
## Champ Commencant par PN suivit d'un espace ou d'un chiffre (eliminer VPN, PNO, ...)
liste <- grep("^PN ", REX_Incidents$`IO - Libellé de la ressource`, ignore.case = TRUE)
length(liste)
REX_Incidents[liste,]$`IO - Libellé de la ressource`
REX_Incidents[liste,]$Type <- "PN"

liste <- grep("^PN[0-9]", REX_Incidents$`IO - Libellé de la ressource`, ignore.case = TRUE)
length(liste)
REX_Incidents[liste,]$`IO - Libellé de la ressource`
REX_Incidents[liste,]$Type <- "PN"

## PN précédé par autre chose qu'une lettre et suivit d'un espace ou d'un chiffre
liste <- grep("[^A-Z]PN ", REX_Incidents$`IO - Libellé de la ressource`, ignore.case = TRUE)
length(liste)
REX_Incidents[liste,]$`IO - Libellé de la ressource`
REX_Incidents[liste,]$Type <- "PN"

liste <- grep("[^A-Z]PN[0-9]", REX_Incidents$`IO - Libellé de la ressource`, ignore.case = TRUE)
length(liste)
REX_Incidents[liste,]$`IO - Libellé de la ressource`
REX_Incidents[liste,]$Type <- "PN"


nrow(subset(REX_Incidents, Type == "PN"))
nrow(subset(REX_Incidents, Type == "PN"))/nrow(REX_Incidents)

## Idem avec champ `IO - Commentaires 1`

## Champ Commencant par PN ....
liste <- grep("^PN", REX_Incidents$`IO - Commentaires 1`, ignore.case = TRUE)
length(liste)
## Aucun

## PN précédé par autre chose qu'une lettre et suivit d'un espace ou d'un chiffre
liste <- grep("[^A-Z]PN ", REX_Incidents$`IO - Commentaires 1`, ignore.case = TRUE)
length(liste)
REX_Incidents[liste,]$`IO - Libellé de la ressource`
REX_Incidents[liste,]$`IO - Commentaires 1`
REX_Incidents[liste,]$Type <- "PN"

liste <- grep("[^A-Z]PN[0-9]", REX_Incidents$`IO - Commentaires 1`, ignore.case = TRUE)
length(liste)
REX_Incidents[liste,]$`IO - Libellé de la ressource`
REX_Incidents[liste,]$`IO - Commentaires 1`
REX_Incidents[liste,]$Type <- "PN"


nrow(subset(REX_Incidents, Type == "PN"))
nrow(subset(REX_Incidents, Type == "PN"))/nrow(REX_Incidents)
## 2429 occurences 4,6%

## Extraction d'un numéro de PN .....

REX_Incidents$Num_PN <- -1
REX_Incidents$Cas <- "NA"

## On commence par une recherche dans `IO - Commentaires 1` puis on écrasera 
## éventuellement un numéro de PN trouvé dans `IO - Libellé de la ressource`

## `IO - Commentaires 1`

index <- grep("PN[0-9]{1}", REX_Incidents$`IO - Commentaires 1`, ignore.case = TRUE)
length(index)
pos <- regexpr("PN[0-9]{1}",REX_Incidents$`IO - Commentaires 1`, ignore.case = TRUE)
val <- as.numeric(substr(REX_Incidents$`IO - Commentaires 1`[index], pos[index]+2, pos[index]+2))
REX_Incidents[index,]$Num_PN <- val
REX_Incidents[index,]$Cas <- "Premier PN cité dans commentaire taille >= 1 digit"


index <- grep("PN[0-9]{2}", REX_Incidents$`IO - Commentaires 1`, ignore.case = TRUE)
length(index)
pos <- regexpr("PN[0-9]{2}",REX_Incidents$`IO - Commentaires 1`, ignore.case = TRUE)
val <- as.numeric(substr(REX_Incidents$`IO - Commentaires 1`[index], pos[index]+2, pos[index]+3))
REX_Incidents[index,]$Num_PN <- val
REX_Incidents[index,]$Cas <- "Premier PN cité dans commentaire taille >= 2 digit"


index <- grep("PN[0-9]{3}", REX_Incidents$`IO - Commentaires 1`, ignore.case = TRUE)
length(index)
pos <- regexpr("PN[0-9]{3}",REX_Incidents$`IO - Commentaires 1`, ignore.case = TRUE)
val <- as.numeric(substr(REX_Incidents$`IO - Commentaires 1`[index], pos[index]+2, pos[index]+4))
REX_Incidents[index,]$Num_PN <- val
REX_Incidents[index,]$Cas <- "Premier PN cité dans commentaire taille >= 3 digit"

## `IO - Libellé de la ressource`

index <- grep("PN[0-9]{1}", REX_Incidents$`IO - Libellé de la ressource`, ignore.case = TRUE)
length(index)
pos <- regexpr("PN[0-9]{1}",REX_Incidents$`IO - Libellé de la ressource`, ignore.case = TRUE)
val <- as.numeric(substr(REX_Incidents$`IO - Libellé de la ressource`[index], pos[index]+2, pos[index]+2))
REX_Incidents[index,]$Num_PN <- val
REX_Incidents[index,]$Cas <- "Premier PN cité dans lib taille >= 3 digit"


index <- grep("PN[0-9]{2}", REX_Incidents$`IO - Libellé de la ressource`, ignore.case = TRUE)
length(index)
pos <- regexpr("PN[0-9]{2}",REX_Incidents$`IO - Libellé de la ressource`, ignore.case = TRUE)
val <- as.numeric(substr(REX_Incidents$`IO - Libellé de la ressource`[index], pos[index]+2, pos[index]+3))
REX_Incidents[index,]$Num_PN <- val
REX_Incidents[index,]$Cas <- "Premier PN cité dans lib taille >= 3 digit"


index <- grep("PN[0-9]{3}", REX_Incidents$`IO - Libellé de la ressource`, ignore.case = TRUE)
length(index)
pos <- regexpr("PN[0-9]{3}",REX_Incidents$`IO - Libellé de la ressource`, ignore.case = TRUE)
val <- as.numeric(substr(REX_Incidents$`IO - Libellé de la ressource`[index], pos[index]+2, pos[index]+4))
REX_Incidents[index,]$Num_PN <- val
REX_Incidents[index,]$Cas <- "Premier PN cité dans lib taille >= 3 digit"

## Nombre de numéro de PN trouvés
nrow(subset(REX_Incidents, (Num_PN != -1)))
nrow(subset(REX_Incidents, (Num_PN != -1) & (Type == "PN")))

df <- subset(REX_Incidents, (Num_PN != -1) & (Type != "PN"))
df$`IO - Libellé de la ressource`
# RPN...
res <- subset(REX_Incidents, (Num_PN != -1))
res$Num_PN
res$`IO - Libellé de la ressource`
head(res)

index <- grep("PN[0-9]{3}", REX_Incidents$`IO - Libellé de la ressource`, ignore.case = TRUE)
index <- grep("PN [0-9]{3}", REX_Incidents$`IO - Libellé de la ressource`, ignore.case = TRUE)

'a[^bct]'

liste <- grep("^PN[0-9][0-9][0-9]", REX_Incidents$`IO - Libellé de la ressource`, ignore.case = TRUE)
length(liste)
REX_Incidents[liste,]$`IO - Libellé de la ressource`
REX_Incidents[liste,]$`IO - Commentaires 1`

liste <- grep("^PN[0-9]{3}", REX_Incidents$`IO - Libellé de la ressource`, ignore.case = TRUE)
length(liste)
REX_Incidents[liste,]$`IO - Libellé de la ressource`
REX_Incidents[liste,]$`IO - Commentaires 1`

vecteur <- c("456  PN444","pn5555xxx","pn5","test","PNO","PN289")
grep("PN[0-9]{3}",vecteur, ignore.case = TRUE,value = TRUE)
index <- grep("PN[0-9]{3}",vecteur, ignore.case = TRUE)
pos <- regexpr("PN[0-9]{3}",vecteur, ignore.case = TRUE)
pos
pos[1]

substr(vecteur[1], pos[1]+2, pos[1]+4)
as.numeric(substr(vecteur[1], pos[1]+2, pos[1]+4))


substr(vecteur[index], pos[index]+2, pos[index]+4)
as.numeric(substr(vecteur[index], pos[index]+2, pos[index]+4))

index

index <- grep("PN[0-9]{3}", REX_Incidents$`IO - Libellé de la ressource`, ignore.case = TRUE)
pos <- regexpr("PN[0-9]{3}",REX_Incidents$`IO - Libellé de la ressource`, ignore.case = TRUE)
val <- as.numeric(substr(REX_Incidents$`IO - Libellé de la ressource`[index], pos[index]+2, pos[index]+4))
REX_Incidents[index,]$Num_PN <- val


regexpr("PN[0-9]{3}^5",c("==PN444","-----pn5555","pn5"), ignore.case = TRUE)
regexpr("PN[0-9]{2}[^X]",c("==PN44xxx","-----pn5555","pn5"), ignore.case = TRUE)
regexpr("PN[0-9]{2}[^0123456789]",c("==PN44xxx","-----pn5555","pn5"), ignore.case = TRUE)
regexpr("PN[0-9]{4}[^0123456789]",c("==PN44xxx","-----pn5555ww","pn5","PN28 9","PN27"), ignore.case = TRUE)
regexpr("PN[0-9]{4}[^0-9]",c("==PN44xxx","-----pn5555ww","pn5","PN28 9","PN27"), ignore.case = TRUE)
gregexpr("PN[0-9]{3}",c("==PN444","-----pn5555","pn5"), ignore.case = TRUE)
regexec("PN[0-9]{3}",c("==PN444","-----pn5555","pn5"), ignore.case = TRUE)

?grep
substr("abcdef", 2, 4)

?grep
regexpr("PN", REX_Incidents[liste,]$`IO - Libellé de la ressource`,ignore.case = TRUE)

grep("a","b")

substr("abcdef", 2, 4)

regexpr("PN", c("AAAPNAAA","XP2XXXNX","PN","XX28XXX","PN","XXXXX","PN","XXXXX","PN"))

regexpr("[1234567890]", c("AAAPNAAA","XPX28XXNX","PN","XXXXX","PN","XXXXX","PN","XXXXX","PN"))
regexpr("[1234567890]", c("AAAPNAAA","XPX28XXNX","PN","XXXXX","PN","XXXXX","PN","XXXXX","PN"))
regexpr("[0-9]", c("AAAPNAAA","XPX28XXNX","PN","XX2XXX","PN","XXXXX","PN","XXXXX","PN"))
regexpr("[0-9][0-9]", c("AAAPNAAA","XPX28XXNX","P2N","XXXXX","PN","XXXXX","PN","XXXXX","PN"))

Recherche



REX_Incidents[liste,]$`IO - Libellé de la ressource`

strsplit(c("a,b", "c,d", "e,f,g"), ",")


REX_Incidents[,13]
str(REX_Incidents[,13])
nchar(REX_Incidents[7,13])


?read.csv
#REX_Incidents <- read.csv("../data/REX_Incidents.csv", sep = ";",nrows = 200,
#                          fileEncoding = "UTF-8")



liste_champs <- c("annonce","annonces","anonce","barrière","barriere","barières"
                  ,"barieres","barr","bar","commutateur","comutateur","route"
                  ,"routier","mécanisme","mecanisme","niveau","PN","relais","raté"
                  ,"rate","ouverture","fermeture")
  



# ------------------------------------------------------------------------------

# Tentative d'association d'un actif AVP PN à un incident 

str(REX_Incidents)

# Quelques test pour qiuelques exemples ...

lamb <- lambert(REX_Incidents[1,]$LIGNE,REX_Incidents[1,]$PK)
AVP_voisins <- Liste_AVP_voisins(lamb$X,lamb$Y,200)
PN_voisins <- Liste_PN_voisins(lamb$X,lamb$Y,200)
Cdv_voisins <- Liste_Zones_Cdv_voisins(lamb$X,lamb$Y,200)
REX_Incidents[1,]$LIGNE


AVP_pr <- AVP_proche(REX_Incidents[1,]$LIGNE,REX_Incidents[1,]$PK)
PN_pr <- PN_proche(REX_Incidents[1,]$LIGNE,REX_Incidents[1,]$PK)
Cdv_pr <- Cdv_proche(REX_Incidents[1,]$LIGNE,REX_Incidents[1,]$PK)


nrow(AVP_voisins)
nrow(PN_voisins)
nrow(Cdv_voisins)
print(paste("Incident : ", 1))
print(paste("Nombre d'apareils de voie voisins: ", nrow(AVP_voisins)))
print(paste ("Nombre de passages à niveau voisins: ", nrow(PN_voisins)))
print(paste ("Nombre de circuit de voie voisins: ", nrow(Cdv_voisins)))

print(paste ("AVP le plus proche sur la voie:", AVP_pr$distance))
print(paste ("PN le plus proche sur la voie:", PN_pr$distance))
print(paste ("AVP le plus proche sur la voie:", Cdv_pr$distance))



for (i in c(14,22,75)) {
  lamb <- lambert(REX_Incidents[i,]$LIGNE,REX_Incidents[i,]$PK)
  AVP_voisins <- Liste_AVP_voisins(lamb$X,lamb$Y,200)
  PN_voisins <- Liste_PN_voisins(lamb$X,lamb$Y,200)
  Cdv_voisins <- Liste_Zones_Cdv_voisins(lamb$X,lamb$Y,200)
  
  AVP_pr <- AVP_proche(REX_Incidents[i,]$LIGNE,REX_Incidents[i,]$PK)
  PN_pr <- PN_proche(REX_Incidents[i,]$LIGNE,REX_Incidents[i,]$PK)
  Cdv_pr <- Cdv_proche(REX_Incidents[i,]$LIGNE,REX_Incidents[i,]$PK)

  
    
  
  nrow(AVP_voisins)
  nrow(PN_voisins)
  nrow(Cdv_voisins)
  
  print(paste("Incident : ", i))
  print(paste("Ligne: ", REX_Incidents[i,]$LIGNE))
  print(paste("PK: ", REX_Incidents[i,]$PK))
  
  print(paste("Nombre d'apareils de voie voisins: ", nrow(AVP_voisins)))
  print(paste ("Nombre de passages à niveau voisins: ", nrow(PN_voisins)))
  print(paste ("Nombre de circuit de voie voisins: ", nrow(Cdv_voisins)))
  print(paste ("AVP le plus proche sur la voie:", AVP_pr$distance))
  print(paste ("PN le plus proche sur la voie:", PN_pr$distance))
  print(paste ("Cdv le plus proche sur la voie:", Cdv_pr$distance))
                    
  # calcul de la distance entre le plus proche et ...
}

lamb <- lambert(420000,13880)
AVP_voisins <- Liste_AVP_voisins(lamb$X,lamb$Y,1000)
PN_voisins <- Liste_PN_voisins(lamb$X,lamb$Y,6000)
Cdv_voisins <- Liste_Zones_Cdv_voisins(lamb$X,lamb$Y,1000)

AVP_pr <- AVP_proche(420000,13880)
PN_pr <- PN_proche(420000,13880)
Cdv_pr <- Cdv_proche(420000,13880)



lamb <- lambert(334000,1210)
AVP_voisins <- Liste_AVP_voisins(lamb$X,lamb$Y,200)
PN_voisins <- Liste_PN_voisins(lamb$X,lamb$Y,600)
Cdv_voisins <- Liste_Zones_Cdv_voisins(lamb$X,lamb$Y,200)


AVP_pr <- AVP_proche(334000,1210)
PN_pr <- PN_proche(334000,1210)
Cdv_pr <- Cdv_proche(334000,1210)


# ----------------------------------------------------------
# Fonction cherchant les PN voisins du même nom

str(Liste_PN)

Liste_PNxxx_voisins <- function(X, Y, Num, rayon = 500) {
  Liste_PNxxx_voisins <- subset(Liste_PN, (Num_PN == Num))

  # Calcul et ajout de la distance euclidienne 
  Liste_PNxxx_voisins$distance <- sqrt((Liste_PNxxx_voisins$X-X)^2+(Liste_PNxxx_voisins$Y-Y)^2)
  
  Liste_PNxxx_voisins <- subset(Liste_PNxxx_voisins, distance < rayon)
  Liste_PNxxx_voisins
}

Liste_PNxxx_voisins(586796.1,6816543,12,20000)



# ----------------------------------------------------------
# Remplissage du fichier....
# ----------------------------------------------------------

str(Liste_PN)
REX_Incidents_PN <- read.csv("../data/REX_Incidents_PN2.csv", sep = ";",check.names = FALSE)
str(REX_Incidents_PN)


#REX_Incidents_PN <- read.csv("../data/REX_Incidents_PN2.csv", sep = ";",check.names = FALSE,
#                             colClasses = c("integer","integer","character","character","integer","numeric","numeric"))
str(REX_Incidents_PN)
head(REX_Incidents_PN)

REX_Incidents_PN$Id_Armen <- 0
REX_Incidents_PN$Confiance <- 0



type <- REX_Incidents_PN$type_equipement_final[4]
type
ligne <- REX_Incidents_PN$LIGNE[4]
pk <- REX_Incidents_PN$PK[4]
num <- REX_Incidents_PN$num_pn[4]
num <- as.integer(num)
num
PN_Candidat <- PNxxx_proche(550000,34718,26)

i <- 4

if (type == "PN enrichi") {
  # PN et numéro identifié
  PN_Candidat <- PNxxx_proche(ligne,pk,num)
  distance <- PN_Candidat$distance
  # verifier que le plus proche du même nom est à moins de 200 m
  print(paste("Distance : ", distance))
  
  if (distance < 200) {
    print("moins de 200 m : confirmation candidat 90% ")
    REX_Incidents_PN$Id_Armen[i] <- PN_Candidat$Id_Armen
    REX_Incidents_PN$Confiance[i] <- 0.9
  } else if (distance < 1000) {
    print("entre 200 m et 1 km: confirmation candidat 50% ")
    REX_Incidents_PN$Id_Armen[i] <- PN_Candidat$Id_Armen
    REX_Incidents_PN$Confiance[i] <- 0.5
  } else {
    print("plus de 1km : confirmation candidat < 10% ")
  }
} 
else {
  print('autre cas')
}   


# ----------------------------------------------------------
# Principe "macro" d'un moteur de recherche:
# Une chaine de caractère en entrée
# Retourne une liste de résultats classés par pertinence
# .... donc une liste de lignes des fichiers à disposition...
# .... la clé est de savoir classer les résultats avec une ...
# ... distance "sémantique"
# ----------------------------------------------------------


# ----------------------------------------------------------
# Notions de distances sémantique ou de similitude entre mots?
# ...cas à traiter ....
# la faute de frappe ou d'orthographe....
# l'abréviation
# les synonymes ... 
# le même mot dans un contexte différent...


# La distance de Levenshtein est une distance mathématique 
# donnant une mesure de la similarité entre deux chaînes de caractères. 
# Elle est égale au nombre minimal de caractères qu'il faut supprimer, 
# insérer ou remplacer pour passer d’une chaîne à l’autre
#
# Elle est définie pour deux chaînes A et B comme le nombre minimal 
# d'opération d'ajout/suppression/remplacement de caractères pour 
# transformer la chaîne A en la chaîne B.
# Exemples:
# Levenshtein('BONJOUR','BONSOIR')=2 (il est nécessaire et suffisant de remplacer 'J' par 'S' et 'U' par 'I').
# Levenshtein('DEBUT','FIN')=5
# Levenshtein('DUNKERQUE','PERPIGNAN')=93. Le résultat n'est pas proportionnel à la distance géographique.
#
# Rappel notion de distance en math
# Symétrie, Séparation et Innégalité triangulaire...
#


# compute Levenshtein distance
strs <- c("Charly","Sharly","Charlie","charlie","sharlie","scharli","ssarlly")
# using R default adist()
adist(strs,"Charly")
adist(strs,strs)
?adist

# using stringdist() from package "stringdist"
library(stringdist)
?stringdist()
# voir http://www.joyofdata.de/blog/comparison-of-string-distance-algorithms/
# pour comprendre dans le détail les différentes distances et leur variantes
stringdist("Charly",strs,method="lv")
stringdist(strs,"Charly",method="lv")
stringdist(strs,"Charly",method="osa")
stringdist(strs,"Charly",method="dl")
stringdist(strs,"Charly",method="hamming") # pas adapté les chaines doivent avoir la même longueur
stringdist(strs,"Charly",method="lcs") # ?
stringdist(strs,"Charly",method="qgram",q=2) # ?
stringdist(strs,"Charly",method="qgram",q=3) # ?
stringdist(strs,"Charly",method="qgram",q=1) # ?

# distance / indice de jaccard
# ratio entre intersection et union
stringdist(strs,"Charly",method="jaccard",q=2) # ?
stringdist(strs,"Charly",method="jw",p=0.1) # ?
stringdist(strs,"Charly",method="soundex") # ?



