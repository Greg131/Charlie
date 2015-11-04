data PI_TAG ;
infile "C:\Documents and Settings\Administrateur\Bureau\Datathon\dtsncf-iso\DCT\PI_TAG DCT.csv" dsd missover lrecl = 32000 dlm = ";" firstobs = 2;
length 
Site
Version_Site
Specialite
Num_CFR
Num_FR
Num_lsi
Num_RA
Type
Noeud_nature_1
Noeud_nature_2
Noeud_nature_3
Noeud_nature_4
Noeud_nature_5
Noeud_nature_6
Etat_1
Etat_2
Libelle
Id_info
Num_Info
Filtre
Logique
Nb_dOccurence
Retard_Alarme
Retard
Gamme
Classe
Piece_Jointe
Type_Alarme
Libelle_Composant
Libelle_Exploitation
Num_Alarme
poste_Signalo
Zone_Geo
Niveau_dExploi
Renvoi_Condi
Noeud_Geo_1
Noeud_Geo_2
Noeud_Geo_3
Noeud_Geo_4
Noeud_Geo_5
Noeud_Geo_6
Noeud_Exploi_1
Noeud_Exploi_2
Noeud_Exploi_3
Noeud_Exploi_4
Noeud_Exploi_5
Noeud_Exploi_6
PK
Inhibable
Existence
Gestion_Local
Archiver
Synthese
Synt_Alarme_CFR
Lib_Discret
Type_Acqui
Num_Element
Seuil_1
Seuil_2
Seuil_3
Seuil_4
Hysteresis
Libelle_Composant_Mat1
Libelle_Composant_Mat2 $50 ;

input 
Site	$
Version_Site	$
Specialite	$
Num_CFR	$
Num_FR	$
Num_lsi	$
Num_RA	$
Type	$
Noeud_nature_1	$
Noeud_nature_2	$
Noeud_nature_3	$
Noeud_nature_4	$
Noeud_nature_5	$
Noeud_nature_6	$
Etat_1	$
Etat_2	$
Libelle	$
Id_info	$
Num_Info	$
Filtre	$
Logique	$
Nb_dOccurence	$
Retard_Alarme	$
Retard	$
Gamme	$
Classe	$
Piece_Jointe	$
Type_Alarme	$
Libelle_Composant	$
Libelle_Exploitation	$
Num_Alarme	$
poste_Signalo	$
Zone_Geo	$
Niveau_dExploi	$
Renvoi_Condi	$
Noeud_Geo_1	$
Noeud_Geo_2	$
Noeud_Geo_3	$
Noeud_Geo_4	$
Noeud_Geo_5	$
Noeud_Geo_6	$
Noeud_Exploi_1	$
Noeud_Exploi_2	$
Noeud_Exploi_3	$
Noeud_Exploi_4	$
Noeud_Exploi_5	$
Noeud_Exploi_6	$
PK	$
Inhibable	$
Existence	$
Gestion_Local	$
Archiver	$
Synthese	$
Synt_Alarme_CFR	$
Lib_Discret	$
Type_Acqui	$
Num_Element	$
Seuil_1	$
Seuil_2	$
Seuil_3	$
Seuil_4	$
Hysteresis	$
Libelle_Composant_Mat1	$
Libelle_Composant_Mat2	$
;
run ;
*23 838 ;

data Liste_PN ;
infile "C:\Documents and Settings\Administrateur\Bureau\Datathon\dtsncf-iso\Donn-ées patrimoniales\Liste_PN.csv" dsd missover lrecl = 32000 dlm = "09"x firstobs = 2;
length
ID_PANDA	
ID_Armen	
ID_Reseau	
Nom_PN	
Num_PN	
Code_Commune3	
Commune3	
Code_Departement	
Nom_Departement	
Nom_Region	
LIGNE $50	
PK 8 ;

input
ID_PANDA	$
ID_Armen	$
ID_Reseau	$
Nom_PN	$
Num_PN	$
Code_Commune3 $	
Commune3	$
Code_Departement $	
Nom_Departement	$
Nom_Region	$
LIGNE $	
PK  ;
run ;
*1513;
 

data Liste_CTV ;
infile "C:\Documents and Settings\Administrateur\Bureau\Datathon\dtsncf-iso\Donn-ées patrimoniales\Liste_CTV.csv" dsd missover lrecl = 32000 dlm = "09"x firstobs = 2;
length
ID_PANDA	
ID_Armen	
LIGNE	$50
PK	8
Designation	
Type_CTV	
Nom_SAF	
Decompte $50 ;
input
ID_PANDA	$
ID_Armen	$
LIGNE	$
PK	
Designation	$
Type_CTV	$
Nom_SAF	$
Decompte $ ;
;
run ;
*3425 ;

data Ref_geolocalisation ;
infile "C:\Documents and Settings\Administrateur\Bureau\Datathon\dtsncf-iso\R-éf-érentiel G-éolocalisation\Referentiel geolocalisation.csv" dsd missover lrecl = 32000 dlm = ";" firstobs = 2;
length
LIGNE	$50
PK	
X	
Y 8 ;
informat 
x y numx. ;
input
LIGNE	$
PK	
X	
Y  ;
run ;
* 17719 ;
 
 



data REX_SIG;
infile "C:\Documents and Settings\Administrateur\Bureau\Datathon\dtsncf-iso\REX\REX SIG.csv" dsd missover lrecl = 32000 dlm = ";" firstobs = 2;
length
FNOFICH
LIBEL
FDTFICH
FHFICH
FDESGEO
FCDGEO
FLIG
FCLIG
FCRIT
FTYELEC
FANELEC
FDESLOCA
FCDLOCAGEO
FKM
FVOIE
FSENS
FINCID
FCDSYS
FDESCOND
FDESNAT
FDTINCID
FHINCID
FDTAPPEL
FHAPPEL
DAPPEL
FDTARR
FHARR
DACH
FDTDBT
FHDBT
DATT
FDTRMS
FHRMS
DREM
FDTRSN
FHRSN
DREP
FDTREPG
FHREPG
FDJSNDJS
FDIFF
FEXPL
FMOYENINTV
FNATINST
FDESINST
FCDSURV
FSYMB
FDESSY
FCDMAT
FDESMAT
FDESMAT1
FCONST
FLTSERIE
FNO
FDTFAB
FDTREV
FDTMS
FNBRMAT
FCAUSERP
FDESCAUSE
FDESCAUS1
FDCIRC
FCDCAUSE
FFACTHUM
FRAPCOMP
FTEMP
FMETEO
FREPCIRC
FNBRRAP
FNBRAUT
FNBRMES
FNBRBL
FNBRTER
FNBRTIR
FPDTRAP
FPDTAUT
FPDTMES
FPDTBL
FPDTTER
FPDTTIR
FIMPGL
FIMPAUT
FIMPFR
FIMPBL
FIMPTER
FIMPTIR
FSUPGL
FSUPAUT
FSUPFR
FSUPBL
FSUPTER
FSUPTIR
FNATINTV
FDTINTV
FDESREPA
FOBS
FNOTA
FKART
FDTVALETB
FDTVALREG
FNTRAIN
FNENGIN
FNUENREG
accord_brehat
accord_brehat_obs
Code_Region
Code_Region_3_car
Code_UP
code_brehat
contact_nom
contact_telephone
Fiche_modifiee_Direction
Fiche_proposee_UP
Fiche_supprimee
Fiche_Validee_UP
periodicite
fh_procedure
fh_environnement
fh_homme
fh_organisation
LGV
Trafic_Transilien
Signal
Fiche_modifiee_IG
Confirmee_SQ3
Secteur_DPX_Code
Secteur_DPX_Libellee
Vue_IG_le
INDISPO
ETAB_Code
ETAB_Libelle
TP
Ligne
Voie  $50
PK 	8
Modele_CRT
Modele_long
Designation	$50 ;
informat pk numx. ;

input 
FNOFICH	$
LIBEL	$
FDTFICH	$
FHFICH	$
FDESGEO	$
FCDGEO	$
FLIG	$
FCLIG	$
FCRIT	$
FTYELEC	$
FANELEC	$
FDESLOCA	$
FCDLOCAGEO	$
FKM	$
FVOIE	$
FSENS	$
FINCID	$
FCDSYS	$
FDESCOND	$
FDESNAT	$
FDTINCID	$
FHINCID	$
FDTAPPEL	$
FHAPPEL	$
DAPPEL	$
FDTARR	$
FHARR	$
DACH	$
FDTDBT	$
FHDBT	$
DATT	$
FDTRMS	$
FHRMS	$
DREM	$
FDTRSN	$
FHRSN	$
DREP	$
FDTREPG	$
FHREPG	$
FDJSNDJS	$
FDIFF	$
FEXPL	$
FMOYENINTV	$
FNATINST	$
FDESINST	$
FCDSURV	$
FSYMB	$
FDESSY	$
FCDMAT	$
FDESMAT	$
FDESMAT1	$
FCONST	$
FLTSERIE	$
FNO	$
FDTFAB	$
FDTREV	$
FDTMS	$
FNBRMAT	$
FCAUSERP	$
FDESCAUSE	$
FDESCAUS1	$
FDCIRC	$
FCDCAUSE	$
FFACTHUM	$
FRAPCOMP	$
FTEMP	$
FMETEO	$
FREPCIRC	$
FNBRRAP	$
FNBRAUT	$
FNBRMES	$
FNBRBL	$
FNBRTER	$
FNBRTIR	$
FPDTRAP	$
FPDTAUT	$
FPDTMES	$
FPDTBL	$
FPDTTER	$
FPDTTIR	$
FIMPGL	$
FIMPAUT	$
FIMPFR	$
FIMPBL	$
FIMPTER	$
FIMPTIR	$
FSUPGL	$
FSUPAUT	$
FSUPFR	$
FSUPBL	$
FSUPTER	$
FSUPTIR	$
FNATINTV	$
FDTINTV	$
FDESREPA	$
FOBS	$
FNOTA	$
FKART	$
FDTVALETB	$
FDTVALREG	$
FNTRAIN	$
FNENGIN	$
FNUENREG	$
accord_brehat	$
accord_brehat_obs	$
Code_Region	$
Code_Region_3_car	$
Code_UP	$
code_brehat	$
contact_nom	$
contact_telephone	$
Fiche_modifiee_Direction	$
Fiche_proposee_UP	$
Fiche_supprimee	$
Fiche_Validee_UP	$
periodicite	$
fh_procedure	$
fh_environnement	$
fh_homme	$
fh_organisation	$
LGV	$
Trafic_Transilien	$
Signal	$
Fiche_modifiee_IG	$
Confirmee_SQ3	$
Secteur_DPX_Code	$
Secteur_DPX_Libellee	$
Vue_IG_le	$
INDISPO	$
ETAB_Code	$
ETAB_Libelle	$
TP	$
Ligne	$
Voie	$
PK	
Modele_CRT	$
Modele_long	$
Designation	$ ;
run ;
	
*101 233 ;
	

data REX_Incidents;
infile "C:\Documents and Settings\Administrateur\Bureau\Datathon\dtsncf-iso\REX\REX_Incidents.csv" dsd missover lrecl = 32000 dlm = ";" firstobs = 2;
length
IO__Identifiant_de_lincident
IO__Numero_dincident
IO__Date__heure_de_debut
IO__Date__heure_de_fin
Annee
filtre_VF
Mois
Semaine
Jour
IO__Type_dincident
IO__Type_de_defaillance
IO__Type_ressource_defaillante
IO__Libelle_de_la_ressource
IO__Structure_responsable $50
IO__Commentaires_1 $500
IO__Commentaires_2 $500
IO__Lieu
IO__Libelle_PR_PR_debut
IO__Region_PR_debut
IO__EVEN_PR_debut
IO__Libelle_PR_PR_fin
IO__Secteur_PR_debut
IO__Secteur_PR_fin
Troncon
secteur_troncon
Densite
Trains_touches
Minutes_perdues
Trains_supprimes
Transilien_touches
Minutes_perdues_Transilien
Transilien_supprimes
Voyageurs_Transilien_retardes
Future_macrocategorie
Future_famille
Code_Vendome
Specialite_Infra_V
Specialite_detaillee_Infra_V
Cause_Infra_V
Etablissement_responsable
Ventilation
Ventilation_detaillee
Indicateur_GIU
CI_associe
LIGNE $50 
PK 8 ;

informat PK numx. ;

input
IO__Identifiant_de_lincident	$
IO__Numero_dincident	$
IO__Date__heure_de_debut	$
IO__Date__heure_de_fin	$
Annee	$
filtre_VF	$
Mois	$
Semaine	$
Jour	$
IO__Type_dincident	$
IO__Type_de_defaillance	$
IO__Type_ressource_defaillante	$
IO__Libelle_de_la_ressource	$
IO__Structure_responsable	$
IO__Commentaires_1	$
IO__Commentaires_2	$
IO__Lieu	$
IO__Libelle_PR_PR_debut	$
IO__Region_PR_debut	$
IO__EVEN_PR_debut	$
IO__Libelle_PR_PR_fin	$
IO__Secteur_PR_debut	$
IO__Secteur_PR_fin	$
Troncon	$
secteur_troncon	$
Densite	$
Trains_touches	$
Minutes_perdues	$
Trains_supprimes	$
Transilien_touches	$
Minutes_perdues_Transilien	$
Transilien_supprimes	$
Voyageurs_Transilien_retardes	$
Future_macrocategorie	$
Future_famille	$
Code_Vendome	$
Specialite_Infra_V	$
Specialite_detaillee_Infra_V	$
Cause_Infra_V	$
Etablissement_responsable	$
Ventilation	$
Ventilation_detaillee	$
Indicateur_GIU	$
CI_associe	$
LIGNE	$
PK	$
;
run ;
*52436 ;





















































































































































































































	
	
	
































































































































































































































































































































































































































































































