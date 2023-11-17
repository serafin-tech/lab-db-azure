
DROP TABLE IF EXISTS `stanowiska`;
CREATE TABLE `stanowiska` (
  `idstanow` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa` varchar(45) NOT NULL,
  `placa_min` decimal(8,2) DEFAULT NULL,
  `placa_max` decimal(8,2) DEFAULT NULL,
  PRIMARY KEY (`idstanow`)
) AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `stanowiska` WRITE;
/*!40000 ALTER TABLE `stanowiska` DISABLE KEYS */;
INSERT INTO `stanowiska` VALUES
(1,'PREZES',15000.00,NULL),
(2,'DYREKTOR',10000.00,20000.00),
(3,'INZYNIER',8000.00,NULL),
(4,'SPECJALISTA',3000.00,6000.00),
(5,'STARSZY SPECJALISTA',4500.00,9000.00),
(6,'KIEROWNIK',6000.00,12000.00),
(7,'ASYSTENT',3000.00,6000.00);
/*!40000 ALTER TABLE `stanowiska` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `zespoly`;
CREATE TABLE `zespoly` (
  `idzespol` int(11) NOT NULL AUTO_INCREMENT,
  `nazwa` varchar(45) NOT NULL,
  `dzial` varchar(45) NOT NULL,
  PRIMARY KEY (`idzespol`)
) AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `zespoly` WRITE;
/*!40000 ALTER TABLE `zespoly` DISABLE KEYS */;
INSERT INTO `zespoly` VALUES
(1,'LOGISTYKA','PRODUKCJA'),
(2,'JAKOSC','PRODUKCJA'),
(3,'UTRZYMANIE RUCHU','PRODUKCJA'),
(4,'WYTWARZANIE','PRODUKCJA'),
(5,'BADANIA','BADANIA I ROZWOJ'),
(6,'PRZYGOTOWANIE PRODUKCJI','BADANIA I ROZWOJ'),
(7,'ZARZAD','ADMINISTRACJA'),
(8,'KADRY I PLACE','ADMINISTRACJA');
/*!40000 ALTER TABLE `zespoly` ENABLE KEYS */;
UNLOCK TABLES;

DROP TABLE IF EXISTS `pracownicy`;
CREATE TABLE `pracownicy` (
  `idprac` int(11) NOT NULL AUTO_INCREMENT,
  `imie` varchar(45) DEFAULT NULL,
  `nazwisko` varchar(45) DEFAULT NULL,
  `stanowisko` int(11) NOT NULL DEFAULT 0,
  `przelozony` int(11) NOT NULL DEFAULT 0,
  `data_zatrudn` date DEFAULT NULL,
  `zespol` int(11) NOT NULL DEFAULT 0,
  `wynagrodzenie` decimal(8,2) DEFAULT NULL,
  PRIMARY KEY (`idprac`),
  KEY `fk_pracownicy_2` (`zespol`),
  KEY `fk_pracownicy_3` (`stanowisko`),
  CONSTRAINT `fk_pracownicy_2` FOREIGN KEY (`zespol`) REFERENCES `zespoly` (`idzespol`) ON DELETE NO ACTION,
  CONSTRAINT `fk_pracownicy_3` FOREIGN KEY (`stanowisko`) REFERENCES `stanowiska` (`idstanow`) ON UPDATE CASCADE
) AUTO_INCREMENT=110 DEFAULT CHARSET=utf8mb4;

LOCK TABLES `pracownicy` WRITE;
/*!40000 ALTER TABLE `pracownicy` DISABLE KEYS */;
INSERT INTO `pracownicy` VALUES
(100,'Jan','Kowalski',1,100,'2000-01-01',7,20000.00),
(101,'Marek','Nowak',2,100,'2000-01-01',4,17000.00),
(102,'Marek','Marecki',2,100,'2000-01-01',5,19000.00),
(103,'Aleksandra','Olska',7,100,'2010-01-01',7,3500.00),
(104,'Anna','Nowak',6,100,'2001-01-01',8,10000.00),
(105,'Jan','Jabłoński',3,101,'2001-01-01',3,9000.00),
(106,'Zdzisław','Testowy',3,101,'2001-01-01',4,12000.00),
(107,'Michał','Michalski',3,102,'2008-01-01',5,15000.00),
(108,'Karol','Karolewski',3,102,'2010-01-01',6,13000.00),
(109,'Krzysztof','Kowalski',6,101,'2012-01-01',4,6000.00);
/*!40000 ALTER TABLE `pracownicy` ENABLE KEYS */;
UNLOCK TABLES;

