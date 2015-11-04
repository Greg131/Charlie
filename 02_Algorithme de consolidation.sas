
/************************************/
/* Traitement des données incidents */
/************************************/

/* Ajout des x,y aux incidents */

%macro ajout_xy (table_in = , table_out = ) ;

proc sql ;
	create table ligne_pk as
	select distinct ligne, pk
	from &table_in. ;
	quit ;

proc sql ;
	create table ligne_pk_xy as
	select a.*, b.x, b.y, min(abs(a.pk-b.pk)) as min
	from ligne_pk as a
	left join ref_geolocalisation as b
	on a.ligne = b.ligne
	group by a.ligne, a.pk
	having abs(a.pk-b.pk)=min;
quit ; 


proc sql ;
	create table doublon as
	select *, count(*) as nb
	from  ligne_pk_xy
	group by ligne, pk
	having nb > 1 ;
quit ;


proc sort data =  ligne_pk_xy out = ligne_pk_xy_nodup nodupkey;
	by ligne pk ;
run ;


proc sql ;
	create table &table_out.  as
	select a.* , b.x, b.y
	from &table_in. as a
	left join ligne_pk_xy_nodup as b
	on a.ligne =b.ligne
	and a.pk = b.pk ;
quit ;
%mend ;

%ajout_xy (table_in = rex_incidents, table_out = rex_incidents_xy) ;
 
/* Ajout des x,y au référentiel PN */

%ajout_xy (table_in = liste_pn, table_out = liste_pn_xy) ;

/* Rapprochement des données d'incidents aux données PN */

proc sql ;
	create table verif as 
	select *, count(*) as nb
	from liste_pn
	group by nom_pn
	having nb > 1 ;
quit ;
*2 ;

proc sql ;
	create table test1 as
	select a.* , b.nom_pn as nom_pn1, min(abs(a.pk-b.pk)) as min
	from rex_incidents_xy as a
	left join liste_pn_xy as b
	on a.ligne = b.ligne
	group by a.ligne, a.pk
	having abs(a.pk-b.pk)=min;
quit ; 
*55870 ;

proc univariate data = test1 ;
var min ;
run ;

proc sql ;
	create table test1B as
	select a.* , b.nom_pn as nom_pn1, (abs(a.pk-b.pk)) as ecart
	from rex_incidents_xy as a
	left join liste_pn_xy as b
	on a.ligne = b.ligne
	having ecart <=5000;
quit ; 

data temp ;
set test1B;
where IO__Identifiant_de_lincident = "13401785" ;
run ;

	proc sql ;
		create table verif as
		select *, count(*) as nb
		from rex_incidents
		group by IO__Identifiant_de_lincident
		having nb > 1;
	quit ;
	*0 ;

/************************************************************************/


proc sql ;
	create table test2 as
	select a.* , b.nom_pn as nom_pn2, min(sqrt(((b.x-a.x)*(b.x-a.x))+((b.y-a.y)*(b.y-a.y)))) as min
	from rex_incidents_xy as a, liste_pn_xy as b
	group by IO__Identifiant_de_lincident
	having sqrt(((b.x-a.x)*(b.x-a.x))+((b.y-a.y)*(b.y-a.y)))=min;
quit ; 
*55870 ;

proc univariate data = test1 ;
var min ;
run ;

proc sql ;
	create table test2B as
	select a.* , b.nom_pn as nom_pn2, sqrt(((b.x-a.x)*(b.x-a.x))+((b.y-a.y)*(b.y-a.y))) as ecart
	from rex_incidents_xy as a, liste_pn_xy as b
	group by IO__Identifiant_de_lincident
	having ecart <= 500;
quit ; 

data temp ;
set test1B;
where IO__Identifiant_de_lincident = "13401785" ;
run ;

/****************************************************************/
/****************************************************************/

/* Définition des types d'équipement */


%let liste_champs =
annonce annonces anonce anonces 
barrière barriere barière bariere barrières barrieres barières barieres barr bar
commutateur comutateur 
route routier 
mécanisme mecanisme
niveau	PN
relais 
raté rate ouverture fermeture ;


%macro generation_type_equipement (table_in = , table_out =);
	data &table_out. ;
	set &table_in. ;

	%do i =1 %to 27 ;
		if index(IO__Libelle_de_la_ressource,"%scan(&liste_champs., &i.)") > 0 then top_&i. = 1 ;
	%end ;
	if sum(of top_1-top_27)> 0 then flag_pn2 = 1; else flag_pn2 = 0;
	%do i =1 %to 27 ;
		if index(IO__Commentaires_1,"%scan(&liste_champs., &i.)") > 0 then top_&i. = 1 ;
	%end ;
	if sum(of top_1-top_27)> 0 then flag_pn3 = 1; else flag_pn3 = 0;

	run ;
%mend ;

options mprint symbolgen ;
%generation_type_equipement (table_in = );



data rex_incidents_pn ;
	set rex_incidents (keep = 
	IO__Identifiant_de_lincident
	IO__Numero_dincident
	IO__Date__heure_de_debut
	IO__Date__heure_de_fin
	IO__Libelle_de_la_ressource IO__Commentaires_1
	ligne pk
	);
	/* Identification des signaux */
	position_c1 = index(upcase(IO__Libelle_de_la_ressource),"C") ;
	position_c2 = index(upcase(IO__Commentaires_1),"C") ;
	if position_c1 > 0 then t1 = anydigit(substr(IO__Libelle_de_la_ressource,position_c1,length(IO__Libelle_de_la_ressource)-position_c1))+position_c1-1;	else t1 = 0 ;
	if position_c2 > 0 then t2 = anydigit(substr(IO__Commentaires_1,position_c2,length(IO__Commentaires_1)-position_c2)) + position_c2-1;	else t2 = 0 ;

	if (position_c1 > 0 and t1 = position_c1+1) or (position_c2 > 0 and t2 = position_c2+1) then flag_signal = 1 ; else flag_signal = 0 ;


	/* identification des aiguilles   */
	position_c1 = index(upcase(IO__Libelle_de_la_ressource),"AIG ") ;
	position_c2 = index(upcase(IO__Commentaires_1),"AIG ") ;
	if position_c1 > 0 then t1 = anydigit(substr(IO__Libelle_de_la_ressource,position_c1,length(IO__Libelle_de_la_ressource)-position_c1))+position_c1-1;	else t1 = 0 ;
	if position_c2 > 0 then t2 = anydigit(substr(IO__Commentaires_1,position_c2,length(IO__Commentaires_1)-position_c2)) + position_c2-1;	else t2 = 0 ;

	if (position_c1 > 0 and t1 = position_c1+4) or (position_c2 > 0 and t2 = position_c2+4) then flag_aiguille = 1 ; else flag_aiguille = 0 ;


	/* PN suivis de chiffre  */

	position_c1 = index(upcase(IO__Libelle_de_la_ressource),"PN") ;
	position_c2 = index(upcase(IO__Commentaires_1),"PN") ;
	if position_c1 > 0 then t1 = anydigit(substr(IO__Libelle_de_la_ressource,position_c1,length(IO__Libelle_de_la_ressource)-position_c1))+position_c1-1;	else t1 = 0 ;
	if position_c2 > 0 then t2 = anydigit(substr(IO__Commentaires_1,position_c2,length(IO__Commentaires_1)-position_c2)) + position_c2-1;	else t2 = 0 ;

	/*
	s1 = index(substr(IO__Libelle_de_la_ressource,position_c1,length(IO__Libelle_de_la_ressource))," ,")+position_c1 ;
	s2 = index(substr(IO__Commentaires_1,position_c2+1,length(IO__Commentaires_1))," ,")+position_c2	;
	*/
	if (position_c1 > 0 and t1 = position_c1+2) or (position_c2 > 0 and t2 = position_c2+2) then flag_pn = 1 ; else flag_pn = 0 ;
	if flag_pn = 1 then do ;
		if (position_c1 > 0 and t1 = position_c1+2) then nom_pn = substr(IO__Libelle_de_la_ressource,position_c1,4)	;
		else if  (position_c2 > 0 and t2 = position_c2+2) then nom_pn = substr(IO__Commentaires_1,position_c2,4)	;
		else nom_pn = "" ;
	end ;
	

run ;


%generation_type_equipement (table_in = rex_incidents_pn, table_out = rex_incidents_pn2);


data rex_incidents_pn_vf (drop = top_: position_c1 position_c2 t1 t2 flag_:);
	set rex_incidents_pn2;
	length 	type_equipement_final $50 ;
	if flag_signal = 1 then type_equipement_final = "Signal";
	else if flag_aiguille = 1  then type_equipement_final = "Aiguille";
	else if flag_pn = 1 then  type_equipement_final = "PN enrichi";
	else if flag_pn2 = 1 or flag_pn3 = 1 then  type_equipement_final = "PN à enrichir";
	else  type_equipement_final = "" ;

run ;

data  rex_incidents_pn_vf ;
	set rex_incidents_pn_vf (drop = num_ligne);
	num_pn = substr(nom_pn,3,3);
run ;

proc freq data = rex_incidents_pn_vf ;
tables 	type_equipement_final / missing;
run ;


proc sql ;
	create table verif as select flag_pn, flag_pn2, flag_pn3, count(*) as nb
	from temp2
	group by  flag_pn, flag_pn2, flag_pn3;
quit ;

data temp3;
	set temp2 ;
	where flag_pn3 = 1 ;
run ;

proc freq data = temp ;
	tables type_equipement ;
run ;


/************************************/

proc sql ;
	create table test1 as
	select a.* , b.nom_pn as nom_pn2, min(abs(a.pk-b.pk)) as min
	from rex_incidents_pn_vf as a
	left join liste_pn_xy as b
	on a.ligne = b.ligne
	group by a.ligne, a.pk
	having abs(a.pk-b.pk)=min;
quit ; 

data temp ;
	set test1 ;
	where type_equipement_final in ("PN à enrichir","PN enrichi");
run ;
