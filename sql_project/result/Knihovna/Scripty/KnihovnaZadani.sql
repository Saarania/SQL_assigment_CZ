create database Knihovna;
use Knihovna;

-- Vytvorime strukturu databaze podle navrhu

create table Ctenar(
ctenar_id int not null AUTO_INCREMENT, 
jmeno varchar(20)  not null,
prijmeni varchar(20) not null,
PRIMARY KEY (ctenar_id)
);

create table Zanr(
zanr_id int not null auto_increment,
nazev varchar (20) not null,
PRIMARY KEY (zanr_id));

create table Autor(
autor_id int not null auto_increment,
jmeno varchar(20) not null,
prijmeni varchar(20) not null,
PRIMARY KEY (autor_id));

create table Kniha(
kniha_id int not null auto_increment,
autor_id int not null,
zanr_id int not null,
nazev varchar(20) not null,
PRIMARY KEY (kniha_id),
FOREIGN KEY(autor_id) REFERENCES Autor(autor_id),
FOREIGN KEY(zanr_id) REFERENCES Zanr(zanr_id)
);

create table Sluzba(
sluzba_id int not null auto_increment,
ctenar_id int not null,
kniha_id int not null,
typ varchar(10) not null,
Frequency varchar(200),
CONSTRAINT chk_Frequency CHECK (Frequency IN ('vypujceni', 'vraceni')),
datum date not null,
PRIMARY KEY (sluzba_id),
FOREIGN KEY (ctenar_id) REFERENCES Ctenar(ctenar_id),
FOREIGN KEY (kniha_id) REFERENCES Kniha(kniha_id)
);

-- Naplnime tabulky hodnotami
Insert into Ctenar(ctenar_id, jmeno, prijmeni) VALUES(0,"Martin","Zeman");
Insert into Ctenar(ctenar_id, jmeno, prijmeni) VALUES(2,"Dusan","Muller");
Insert into Ctenar(ctenar_id, jmeno, prijmeni) VALUES(3,"Adam","Muller");

Insert into Zanr(zanr_id, nazev) VALUES(1,"Beletrie"), (2,"Fantasy");


select* from Kniha;
Insert into Autor(autor_id, jmeno, prijmeni) VALUES(1,"Dusan","Zeman"), (2,"Joanne","Rowling");
Insert into Kniha(kniha_id, autor_id, zanr_id, nazev) VALUES(1,1,1,"Pet pravidel zivota");
Insert into Kniha(kniha_id, autor_id, zanr_id, nazev) VALUES(2, 2,2,"Harry Potter");


-- Vytvoreni pohledu
create view seznamKnih as 
select Kniha.nazev as Nazev, Autor.Prijmeni as Prijmeni, Autor.jmeno as Jmeno FROM Kniha inner join Autor on Kniha.autor_id = Autor.autor_id order by Autor.Prijmeni;

SELECT * from seznamKnih;


-- Vytvoreni procedury, vrati vsechny knihy podle zadaneho autora
DELIMITER $$
CREATE PROCEDURE AutorovyKnihy(autorovoPrijmeni varchar(20))
BEGIN
SELECT Kniha.nazev as Nazev from Kniha inner join Autor on Autor.autor_id = Kniha.autor_id where Autor.prijmeni = autorovoPrijmeni;
END $$

DELIMITER ;

call AutorovyKnihy("Tomsu");	


-- Vytvoreni selectu s moznosti seskupeni, serazeni a podminkou where
SELECT * FROM Kniha WHERE Kniha.zanr_id = 1 GROUP BY Kniha.nazev;
-- vrati vsechny knihy, jejichz zanr je beletrie serazene podle nazvu
