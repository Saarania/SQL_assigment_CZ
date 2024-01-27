Create database obchod;
use obchod;

create table Druh(
druh_id int not null auto_increment,
nazev varchar(20) not null,
PRIMARY KEY (druh_id));

create table Sklad(
sklad_id int not null auto_increment,
nazev varchar(20) not null,
PRIMARY KEY (sklad_id));

create table Dodavatel(
dodavatel_id int not null auto_increment,
jmeno varchar(20) not null,
prijmeni varchar(20) not null,
PRIMARY KEY (dodavatel_id));

create table Potravina(
potravina_id int not null auto_increment,
druh_id int not null,
sklad_id int not null,
nazev varchar(20) not null,
PRIMARY KEY (potravina_id),
FOREIGN KEY (druh_id) REFERENCES Druh(druh_id),
FOREIGN KEY (sklad_id) REFERENCES Sklad(sklad_id));

create table Dodava(
dodava_id int not null auto_increment,
potravina_id int null,
dodavatel_id int not null,
typ varchar(20) not null,
CONSTRAINT chk_typ CHECK (typ IN ('expresni', 'bezne')),
datum date not null,
PRIMARY KEY (dodava_id),
FOREIGN KEY (potravina_id) REFERENCES Potravina(potravina_id),
FOREIGN KEY (dodavatel_id) REFERENCES Dodavatel(dodavatel_id));

-- Pridani zaznamu do tabulek
Insert into Druh(druh_id, nazev) VALUES(1,"Mlecne vyrobky"), (2,"Napoje");
Insert into Sklad(sklad_id, nazev) VALUES(1,"Sklad Podebrady"), (2,"Sklad Freezy");
Insert into Dodavatel(dodavatel_id, jmeno, prijmeni) VALUES(1,"Vaclav", "Havel"), (2,"Franz", "Kafka");
Insert into Potravina(potravina_id, druh_id, sklad_id, nazev) VALUES(1,1,1, "Syr Havana"), (2,2,1,"Pivo Pilzner Urquell");
Insert into Dodava(dodava_id, potravina_id, dodavatel_id, typ, datum) VALUES(1,1,2, "expresni","2021-11-07"), (2,2,1,"expresni","2021-12-09");

-- Vytvoreni pohledu
-- Vrati vsechny mlecne vyrobky a sklady kde jsou ulozene
create view MlecneProdukty as 
select Potravina.nazev as Nazev, Sklad.nazev as "Location" FROM Potravina inner join Sklad on Potravina.sklad_id = Sklad.sklad_id inner join Druh on Potravina.druh_id = Druh.druh_id WHERE Druh.nazev = "Mlecne vyrobky";

select * from MlecneProdukty;

-- Vytvoreni procedury
-- Vrati pocet ruznych potravin z konkretniho skladu
DELIMITER $$
CREATE PROCEDURE SkladAPotraviny(nazev_Skladu varchar(20))
BEGIN
SELECT p.nazev as Nazev, count(p.nazev) as "Pocet" from Potravina as p inner join Sklad on Sklad.sklad_id = p.sklad_id WHERE Sklad.nazev = nazev_Skladu group by p.nazev;
END $$

DELIMITER ;

call SkladAPotraviny("Sklad Podebrady");

-- Vytvoreni selectu s moznosti seskupeni, serazeni a podminkou where
SELECT p.nazev as Nazev, Sklad.nazev from Dodava as d inner join 
Potravina as p on d.potravina_id = p.potravina_id inner join 
Sklad on Sklad.sklad_id = p.sklad_id inner join 
Dodavatel on Dodavatel.dodavatel_id = d.dodavatel_id where dodavatel.prijmeni = "Kafka" order by Sklad.nazev;
-- vrati nazvy produktu, ktere dodava Kafka serazene podle skladu kde jsou ulozeny