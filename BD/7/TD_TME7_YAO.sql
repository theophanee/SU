---TD---

--A
--1
"La Lune est la premiere satelit qui tourne autour la Terre"

--2
"C'est une cle primare"

--3
"Non, il y a un attribut independant de TourneAutour"

--4
"Oui, cf 90 91"

--B
--5
SELECT COUNT(*) as nb
FROM categorie;

--6
SELECT COUNT(*) 
FROM categorie c
WHERE c.idC IN (SELECT idC FROM astre);

SELECT COUNT(DISTINCT idc)
FROM astre;

--7
SELECT MIN(rayon), MAX(rayon) 
FROM astre;

--8
SELECT ROUND(AVG(rayon)/1000,2)||'milliers km' FROM astre;

--9
--a 
SELECT MAX(rayon) 
FROM astre;
--b
SELECT nom,rayon 
FROM astre
WHERE rayon = (SELECT MAX(rayon) FROM astre);

--C
--10
SELECT c.idC, COUNT(a.idC) 
FROM categorie c, astre a
WHERE c.idC = a.idC
GROUP BY c.idC
ORDER BY COUNT(a.idC) DESC;

--11
--1)
SELECT a.idA, COUNT(t.idA2) 
FROM astre a, tourneautour t
WHERE a.idA = t.idA2
GROUP BY a.idA;
--2)
SELECT a.nom, COUNT(t.idA2) 
FROM astre a, tourneautour t
WHERE a.idA = t.idA2
GROUP BY a.idA;

--12
SELECT nom, dateobs, AVG(valobs)
FROM astre a, observation o
WHERE a.idA = o.idA
GROUP BY nom, dateobs;

--13
--a
SELECT c.idC, MAX(rayon)
FROM categorie c, astre a 
WHERE c.idC = a.idC
GROUP BY c.idC
ORDER BY MAX(rayon) ASC;
--b
SELECT c.nom, MAX(rayon)
FROM categorie c, astre a 
WHERE c.idC = a.idC
GROUP BY c.nom
ORDER BY COUNT(a.idA) DESC;
--c
SELECT c.idC, a.nom, a.rayon
FROM categorie c, astre a 
WHERE c.idC = a.idC 
AND a.rayon = (SELECT MAX(a1.rayon) 
    FROM astre a1
    WHERE a1.idC = a.idC)
GROUP BY c.nom
ORDER BY COUNT(a.idA) DESC;

--D
--14
SELECT idC FROM astre
GROUP BY idC
HAVING COUNT(idC) > 1;

--15
SELECT dateobs, COUNT(dateobs), MAX(valobs)
FROM observation
WHERE valobs > 8000
GROUP BY dateobs;

--16
SELECT nom FROM astre a, observation o
WHERE a.idA = o.idA
GROUP BY o.idA
HAVING COUNT(idO) = 2;

--17
SELECT nom  FROM astre, tourneautour
WHERE idA2 = idA
GROUP BY idA2 
HAVING COUNT(idA1) > 1;

--E
--18
SELECT dateobs FROM observation
WHERE idA = ALL (SELECT idA FROM astre);

--19
--a
SELECT c.idC FROM categorie c
WHERE NOT EXISTS(
    SELECT * FROM astre a 
    WHERE c.idC = a.idC 
    AND a.idA NOT IN (
        SELECT idA FROM observation
    )
);
--b
SELECT c.nom FROM categorie c
WHERE NOT EXISTS(
    SELECT * FROM astre a 
    WHERE c.idC = a.idC 
    AND a.idA NOT IN (
        SELECT idA FROM observation
    )
);


---TME---

--1
SELECT COUNT(*) FROM athlete;

--2
SELECT COUNT(*) FROM athlete 
WHERE aid IN (
    SELECT aid FROM RangIndividuel
);

--3
SELECT round(AVG(to_date('2014-02-06','yyyy-mm-dd')-dateNaissance)/365,1) 
FROM athlete WHERE codePays = 'FRA';

--4
SELECT 
'Durée moyenne = '||ROUND(AVG(dateFin-dateDebut+1),2)
||' min = '||MIN(dateFin-dateDebut+1)
||' max = '||MAX(dateFin-dateDebut+1)
FROM Epreuve;

--5
SELECT COUNT(distinct a.aid) / COUNT(distinct p.codePays) FROM athlete a, pays p 
WHERE p.codePays IN (
    SELECT codePays FROM athlete
);

--6
SELECT codePays, COUNT(aid) FROM athlete
GROUP BY codePays
ORDER BY COUNT(aid);

--7
SELECT AVG(COUNT(aid)) FROM athlete
GROUP BY codePays;

--8
SELECT e.eqid, COUNT(aid) FROM Equipe e, AthletesEquipe ae 
WHERE e.eqid = ae.eqid
GROUP BY e.eqid 
ORDER BY COUNT(aid) DESC;

--9
SELECT categorie, COUNT(sid) FROM Epreuve
GROUP BY categorie;

--10
SELECT nomsp, COUNT(epid) FROM sport s, Epreuve e
WHERE s.sid = e.sid
GROUP BY nomsp
ORDER BY COUNT(epid) DESC;

--11
SELECT codePays, COUNT(rang), COUNT(distinct a.aid) 
FROM RangIndividuel r, athlete a 
WHERE rang < 4 AND a.aid = r.aid
GROUP BY codePays
ORDER BY COUNT(rang) DESC;

--12
SELECT codePays, sid, COUNT(rang), COUNT(distinct a.aid)
FROM RangIndividuel r, athlete a, Epreuve e
WHERE rang < 4 AND a.aid = r.aid AND e.epid = r.epid
GROUP BY codePays, sid
ORDER BY codepays, COUNT(rang) DESC;

--13
--1
SELECT eqid FROM AthletesEquipe
GROUP BY eqid 
HAVING COUNT(aid) = 10;
du plus d’athlètes pour ces JO. Résultat attendu (3 lignes) : 164 ; 165 ; 166
--2 ???? Je n'ai pas compris
SELECT COUNT(aid) FROM AthletesEquipe
GROUP BY eqid
HAVING COUNT(aid) >160;

--14
SELECT COUNT(COUNT(epid)) FROM RangIndividuel
GROUP BY epid
HAVING COUNT(aid) > 99;

--15
SELECT nomp FROM pays p, RangIndividuel r, athlete a 
WHERE p.codePays = a.codePays AND a.aid = r.aid AND r.rang < 4
GROUP BY nomp
HAVING COUNT(r.rang) > 19;

--16
SELECT distinct s.sid FROM sport s, Epreuve e 
WHERE e.sid = s.sid 
GROUP BY s.sid
HAVING COUNT(distinct e.categorie) = (
    SELECT COUNT(distinct categorie) FROM Epreuve
);

--17
SELECT nomp, COUNT(distinct e.sid) 
FROM pays p, athlete a, RangIndividuel r, Epreuve e 
WHERE r.aid = a.aid AND a.codePays = p.codePays AND e.epid = r.epid 
GROUP BY nomp
HAVING COUNT(distinct e.sid) = (
    SELECT COUNT(distinct sid) FROM Epreuve 
    WHERE epid IN (
        SELECT epid FROM RangIndividuel
    )
);

--EX2
--18
SELECT NSp, COUNT(NJo), SUM(Somme) FROM Sponsorise
GROUP BY NSp
ORDER BY SUM(Somme) DESC;

--19
SELECT NEq FROM EquipeF, Match
WHERE NEq = Eq1 OR NEq = Eq2
GROUP BY NEq
HAVING COUNT(distinct St)>=3;

--20
SELECT distinct s.NSp FROM Sponsorise s
WHERE NOT EXISTS(
    SELECT * FROM Sponsorise s1, Sponsorise s2, joueur j1, joueur j2
    WHERE j2.njo<>j1.njo AND j1.eq=j2.eq AND s1.njo=j1.njo
    AND s2.njo=j2.njo AND s1.nsp=s2.nsp AND s.nsp=s1.nsp
);

--21. Quel est le nombre total de kilomètres 
parcourus par chaque équipe. 
On suppose qu’après chaque match, 
chaque équipe se rend directement au stade 
où aura lieu son prochain match (d’après la date du match). 
Aide : il existe 2 matchs ordonnés 
par leur date pour la même équipe, 
mais il n’existe pas un 3ième match 
entre les dates des 2 matchs pour cette équipe.
Résultat attendu (4 lignes) : (Fortiches,516) ; (Direkt,671) ; 
(Piepla,124) ; (Sabar,360)
SELECT Neq, SUM(NbKm) FROM EquipeF, Match m1, Match m2, Dist
WHERE (NEq=Eq1 OR NEq=Eq2) AND (St=St1 OR St=St2)
GROUP BY NEq;

SELECT Neq, SUM(NbKm) FROM EquipeF, Match m1, Match m2, Dist
WHERE m1.dateM=m2.dateM
AND ((m1.St=St1 AND m2.St=St2) OR (m2.St=St1 AND m1.St=St2))
AND (NEq=m1.Eq1 OR NEq=m1.Eq2) AND (NEq=m2.Eq1 OR NEq=m2.Eq2)
GROUP BY NEq;

EquipeF(NEq, Ville, Couleur, StP)

Match(Eq1, Eq2, DateM, St)

Dist(St1, St2, NbKm)