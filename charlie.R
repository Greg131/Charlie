# ----------------------------------------------------------
# Datathon SNCF Simplon - Sujet 4 : "Où est Charlie?"
# ----------------------------------------------------------

setwd("~/Dropbox/Datascience/Datathon Simplon.co x SNCF/Scripts")
getwd() # Get working directory 

if (!file.exists("../data"))       {
  dir.create("../data")
}
# Les fichiers de données sont supposés être dans ../data



? read.csv

# Lecture des fichiers

Fonctions_AS <- read.csv("../data/Fonctions_AS.csv", fileEncoding = "UTF-16LE",sep = "\t")
str(Fonctions_AS)

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

Referentiel_geomocalisation <- read.csv("../data/Referentiel geolocalisation.csv", sep = ";")

REX_SIG <- read.csv("../data/REX SIG.csv", sep = ";",check.names = FALSE)

REX_Incidents <- read.csv("../data/REX_Incidents.csv", sep = ";",check.names = FALSE)

Temperatures_PI <- read.csv("../data/Temperatures_PI.csv", sep = "\t",dec = ",")
str(Temperatures_PI)
summary(Temperatures_PI)
Temperatures_PI

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
