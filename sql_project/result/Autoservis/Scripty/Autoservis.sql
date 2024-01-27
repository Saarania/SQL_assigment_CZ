create database Autoservis;
use Autoservis;

-- Vytvareni tabulek

create table Zamestnanec(
zamestnanec_id int not null auto_increment,
jmeno varchar(20) not null,
prijmeni varchar(20) not null,
PRIMARY KEY (zamestnanec_id));

create table Klient(
klient_id int not null auto_increment,
jmeno varchar(20) not null,
prijmeni varchar(20) not null,
PRIMARY KEY (klient_id));

create table Auto(
auto_id int not null auto_increment,
klient_id int not null,
nazev varchar(20) not null,
PRIMARY KEY (auto_id),
FOREIGN KEY (klient_id) REFERENCES Klient(klient_id));

create table Oprava(
oprava_id int not null auto_increment,
zamestnanec_id int not null,
auto_id int not null,
typ_opravy varchar(20) not null,
CONSTRAINT chk_typ_opravy CHECK (typ_opravy IN ('oprava laku', 'vymena tlumice', 'serizeni brzd', 'dalsi')),
Datum date not null,
PRIMARY KEY (oprava_id),
FOREIGN KEY (zamestnanec_id) REFERENCES Zamestnanec(zamestnanec_id),
FOREIGN KEY (auto_id) REFERENCES Auto(auto_id));

-- Pridani zaznamu do tabulek
Insert into Zamestnanec(zamestnanec_id, jmeno, prijmeni) VALUES(1,"Martin","Zeman"), (2,"Jimmy", "Hendrix");
Insert into Klient(klient_id, jmeno, prijmeni) VALUES(1,"Barack","Obama"), (2,"George", "FLoyd");
Insert into Auto(auto_id, klient_id, nazev) VALUES(1,2,"Skoda XI Ferii"), (2,1,"Volkswagen Capiere");
Insert into Oprava(oprava_id, zamestnanec_id, auto_id, typ_opravy) VALUES(1,2,2,"oprava laku", "2021-05-07"), (2,2,1,"serizeni brzd","2021-07-12");

-- Vytvoreni pohledu
create view AutaKlientu as 
select Auto.nazev as Nazev, Klient.prijmeni as Prijmeni, Klient.jmeno as Jmeno FROM Auto inner join Klient on Auto.klient_id = Klient.klient_id order by Auto.nazev;

select * from AutaKlientu;

-- Vytvoreni procedury
-- Vrati nazvy aut ktere opravuje konkretni zamesntanec
DELIMITER $$
CREATE PROCEDURE AutaAJejichOpravar(prijmeni_opravare varchar(20))
BEGIN
select Auto.nazev as "Nazev Auta" from Oprava 
inner join Zamestnanec as z on z.zamestnanec_id = Oprava.zamestnanec_id 
inner join Auto on Auto.auto_id = Oprava.auto_id where z.prijmeni = prijmeni_opravare; 
END $$

DELIMITER ;

call AutaAJejichOpravar("Hendrix");

-- Vytvoreni selectu s moznosti seskupeni, serazeni a podminkou where
SELECT Auto.nazev as Nazev, count(Auto.nazev) as Pocet FROM Auto WHERE Auto.nazev = "Skoda XI Ferii" GROUP BY Auto.nazev;
-- vrati pocet aut jejichz nazev je Skoda XI Ferii

