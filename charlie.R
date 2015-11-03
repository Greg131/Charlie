# ----------------------------------------------------------
# Datathon SNCF Simplon - Sujet 4 : "Où est Charlie?"
# ----------------------------------------------------------

setwd("~/Dropbox/Datascience/Datathon Simplon.co x SNCF/charlie")
getwd() # Get working directory 

# Les fichiers de données sont supposés être dans ../data

? read.csv

# Lecture des fichiers

Fonctions_AS_IdF <- read.csv("../data/Fonctions_AS_Idf.csv", fileEncoding = "UTF-16LE",sep = "\t")

Liste_AVP <- read.csv("../data/Liste_AVP.csv",fileEncoding = "UTF-16LE",sep = "\t")

Liste_CTV <- read.csv("../data/Liste_CTV.csv",fileEncoding = "UTF-16LE",sep = "\t")

Liste_EALE <- read.csv("../data/Liste_EALE.csv",fileEncoding = "UTF-16LE",sep = "\t")

Liste_PN <- read.csv("../data/Liste_PN.csv",fileEncoding = "UTF-16LE",sep = "\t")

Liste_Postes <- read.csv("../data/Liste_Postes.csv",fileEncoding = "UTF-16LE",sep = "\t")

Liste_SAF_ADM <- read.csv("../data/Liste_SAF_ADM.csv",fileEncoding = "UTF-16LE",sep = "\t")

Liste_Sous_Stations_SE <- read.csv("../data/Liste_Sous_Stations_SE.csv",fileEncoding = "UTF-16LE",sep = "\t")

Liste_Zones_Cdv <- read.csv("../data/Liste_Zones_Cdv.csv",fileEncoding = "UTF-16LE",sep = "\t")

PI_TAG <- read.csv("../data/PI_TAG DCT.csv", sep = ";",check.names = FALSE)
#PI_TAG2 <- read.csv("../data/PI_TAG DCT.csv", sep = ";",header = FALSE, skip = 1)
# pb dans les noms de variables à régler

Referentiel_geolocalisation <- read.csv("../data/Referentiel geolocalisation.csv", sep = ";")

REX_SIG <- read.csv("../data/REX SIG.csv", sep = ";",check.names = FALSE)

REX_Incidents <- read.csv("../data/REX_Incidents.csv", sep = ";",check.names = FALSE)

Temperatures_PI <- read.csv("../data/Temperatures_PI.csv", sep = "\t",dec = ",")

# ----------------------------------------------------------
# Fonction donnant les coordonnées Lambert 
# X Y à partir d'une voie et d'un PK
# ----------------------------------------------------------

Referentiel_geolocalisation <- read.csv("../data/Referentiel geolocalisation.csv", sep = ";", dec = ",",
                                        colClasses = c("integer","integer","numeric","numeric"))

head(Referentiel_geolocalisation)
tail(Referentiel_geolocalisation)
summary(Referentiel_geolocalisation)
str(Referentiel_geolocalisation)


lambert <- function(ligne, pk) {
  Ref <- subset(Referentiel_geolocalisation, (LIGNE == ligne))
  Ref$distance <- abs(Ref$PK-pk)
  Ref[which.min(Ref$distance), ]
}


a <- lambert(1000,1000)
b <- lambert(1000,100)

a$X
b$Y
a

# ----------------------------------------------------------
# Fonction retournant les actifs PN dans un rayon de p (500 m par défaut)
# ----------------------------------------------------------

Liste_PN <- read.csv("../data/Liste_PN.csv",fileEncoding = "UTF-16LE",sep = "\t")

str(Liste_PN)

Liste_PN$X <- 0
Liste_PN$Y <- 0

for (i in 1:100) {
  test <- lambert(Liste_PN[i,]$LIGNE,Liste_PN[i,]$PK)$distance
  print(i) ; print(test)
}

lambert(963506,3671)
nrow(lambert(963506,3671))

nrow(Liste_PN)


# Ajout des coordonnées de lambert approchés au data frame
for (i in seq_len(nrow(Liste_PN))) {
  lamb <- lambert(Liste_PN[i,]$LIGNE,Liste_PN[i,]$PK)
  if (nrow(lamb) == 1) {
    Liste_PN[i,]$X <- lamb$X 
    Liste_PN[i,]$Y <- lamb$Y 
  } else { # cas ou l'on n'a pas trouvé de coord lambert ....
    Liste_PN[i,]$X <- 0
    Liste_PN[i,]$Y <- 0
  }
}

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
Liste_AVP <- read.csv("../data/Liste_AVP.csv",fileEncoding = "UTF-16LE",sep = "\t")

str(Liste_AVP)

Liste_AVP$X <- 0
Liste_AVP$Y <- 0


nrow(Liste_AVP)



for (i in seq_len(nrow(Liste_AVP))) {
  lamb <- lambert(Liste_AVP[i,]$LIGNE,Liste_AVP[i,]$PK)
  if (nrow(lamb) == 1) {
    Liste_AVP[i,]$X <- lamb$X # Ajout des coordonnées de lambert approchés
    Liste_AVP[i,]$Y <- lamb$Y # Ajout des coordonnées de lambert approchés
  } else { # cas ou l'on n'a pas trouvé de coord lambert ....
    Liste_AVP[i,]$X <- 0
    Liste_AVP[i,]$Y <- 0
  }
}



Liste_AVP_voisins <- function(X, Y, rayon = 500) {
  Liste_AVP_voisins <- Liste_AVP
  # Calcul et ajout de la distance euclidienne 
  Liste_AVP_voisins$distance <- sqrt((Liste_AVP_voisins$X-X)^2+(Liste_AVP_voisins$Y-Y)^2)
  
  Liste_AVP_voisins <- subset(Liste_AVP_voisins, distance < rayon)
  Liste_AVP_voisins
}

Liste_AVP_voisins(586796.1,6816543,200)


# ----------------------------------------------------------
# Tentative d'association d'un actif AVP PN à un incident 

REX_Incidents <- read.csv("../data/REX_Incidents.csv", sep = ";",check.names = FALSE)
str(REX_Incidents)

# Quelques test pour qiuelques exemples ...

lamb <- lambert(REX_Incidents[1,]$LIGNE,REX_Incidents[1,]$PK)
AVP <- Liste_AVP_voisins(lamb$X,lamb$Y,200)
PN <- Liste_PN_voisins(lamb$X,lamb$Y,200)
nrow(AVP)
nrow(PN)
print(paste("Incident : ", 1))
print(paste("Nombre d'apareils de voie voisins: ", nrow(AVP)))
print(paste ("Nombre de passages à niveau voisins: ", nrow(PN)))


for (i in 1:10) {
  lamb <- lambert(REX_Incidents[i,]$LIGNE,REX_Incidents[i,]$PK)
  AVP <- Liste_AVP_voisins(lamb$X,lamb$Y,200)
  PN <- Liste_PN_voisins(lamb$X,lamb$Y,200)
  nrow(AVP)
  nrow(PN)
  print(paste("Incident : ", i))
  print(paste("Nombre d'apareils de voie voisins: ", nrow(AVP)))
  print(paste ("Nombre de passages à niveau voisins: ", nrow(PN)))

  # calcul de la distance entre le plus proche et ...
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



