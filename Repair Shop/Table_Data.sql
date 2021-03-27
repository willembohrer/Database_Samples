--TABLE DATA INSTANTIATION
/*
WITH
RANDOM_RATE AS (
  SELECT
    (ROUND(((RANDOM() + 1) * 10) + 10)) AS "HOURLYRATE"
),
RANDOM_PHONE AS (
  SELECT
    (ROUND(((RANDOM() + 1) * 234) + 2188343674)) AS "PHONENUMBER"
)
DECLARE
  HOURLYRATE DECIMAL := (SELECT HOURLYRATE FROM RANDOM_RATE),
  PHONENUMBER BIGINT := (SELECT PHONENUMBER FROM RANDOM_PHONE)
BEGIN
INSERT INTO EMPLOYEE (FIRSTNAME, LASTNAME, HOURLYRATE, PHONENUMBER, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
	VALUES ('David', 'Keranen', (SELECT HOURLYRATE FROM RANDOM_RATE), (SELECT PHONENUMBER FROM RANDOM_PHONE), CURRENT_TIMESTAMP, 'Willem Bohrer', CURRENT_TIMESTAMP, 'Willem Bohrer');
*/

INSERT INTO EMPLOYEE (FIRSTNAME, LASTNAME, HOURLYRATE, PHONENUMBER, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES ('Willem', 'Bohrer', (ROUND(((RANDOM() + 1) * 10) + 10)), (ROUND(((RANDOM() + 1) * 234) + 2188343674)), CURRENT_TIMESTAMP, 'Willem Bohrer', CURRENT_TIMESTAMP, 'Willem Bohrer');
INSERT INTO EMPLOYEE (FIRSTNAME, LASTNAME, HOURLYRATE, PHONENUMBER, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES ('Michael', 'Leeseberg', (ROUND(((RANDOM() + 1) * 10) + 10)), (ROUND(((RANDOM() + 1) * 234) + 2188343674)), CURRENT_TIMESTAMP, 'Willem Bohrer', CURRENT_TIMESTAMP, 'Willem Bohrer');
INSERT INTO EMPLOYEE (FIRSTNAME, LASTNAME, HOURLYRATE, PHONENUMBER, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES ('Ansley', 'Schug', (ROUND(((RANDOM() + 1) * 10) + 10)), (ROUND(((RANDOM() + 1) * 234) + 2188343674)), CURRENT_TIMESTAMP, 'Willem Bohrer', CURRENT_TIMESTAMP, 'Willem Bohrer');

INSERT INTO VEHICLE (LICENSEPLATE, YEAR, MAKE, MODEL, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES ('1234 LYJ', 1998, 'Chevrolet', 'S10',  CURRENT_TIMESTAMP, 'Michael Leeseberg', CURRENT_TIMESTAMP, 'Willem Bohrer');
INSERT INTO VEHICLE (LICENSEPLATE, YEAR, MAKE, MODEL, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES ('T3sla R0x', 2019, 'Tesla', 'Model X',  CURRENT_TIMESTAMP, 'Willem Bohrer', CURRENT_TIMESTAMP, 'Michael Leeseberg');
INSERT INTO VEHICLE (LICENSEPLATE, YEAR, MAKE, MODEL, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES ('Cyber PWR', 2021, 'Tesla', 'Cybertruck',  CURRENT_TIMESTAMP, 'Ansley Schug', CURRENT_TIMESTAMP, 'Willem Bohrer');
INSERT INTO VEHICLE (LICENSEPLATE, YEAR, MAKE, MODEL, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES ('TYLR 439', 1998, 'Honda', 'CRX',  CURRENT_TIMESTAMP, 'Willem Bohrer', CURRENT_TIMESTAMP, 'Ansley Schug');
INSERT INTO VEHICLE (LICENSEPLATE, YEAR, MAKE, MODEL, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES ('1075 LDJ', 2008, 'Volvo', 'S40',  CURRENT_TIMESTAMP, 'Willem Bohrer', CURRENT_TIMESTAMP, 'Willem Bohrer');

INSERT INTO ORDERS (PARTNAME, QUANTITY, ORDERDATE, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES ('Tire', 4, CURRENT_DATE, CURRENT_TIMESTAMP, 'Willem Bohrer', CURRENT_TIMESTAMP, 'Willem Bohrer');
INSERT INTO ORDERS (PARTNAME, QUANTITY, ORDERDATE, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES ('Brake Caliper', 4, CURRENT_DATE, CURRENT_TIMESTAMP, 'Willem Bohrer', CURRENT_TIMESTAMP, 'Willem Bohrer');
INSERT INTO ORDERS (PARTNAME, QUANTITY, ORDERDATE, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES ('Sway Bar', 2, CURRENT_DATE, CURRENT_TIMESTAMP, 'Willem Bohrer', CURRENT_TIMESTAMP, 'Willem Bohrer');
INSERT INTO ORDERS (PARTNAME, QUANTITY, ORDERDATE, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES ('Engine Block', 1, CURRENT_DATE, CURRENT_TIMESTAMP, 'Willem Bohrer', CURRENT_TIMESTAMP, 'Willem Bohrer');
INSERT INTO ORDERS (PARTNAME, QUANTITY, ORDERDATE, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES ('Spark Plug', 2, CURRENT_DATE, CURRENT_TIMESTAMP, 'Willem Bohrer', CURRENT_TIMESTAMP, 'Willem Bohrer');

INSERT INTO LOCATION (NAME, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES ('Bison Auto Repair', CURRENT_TIMESTAMP + INTERVAL '11 DAY', 'Willem Bohrer', CURRENT_TIMESTAMP, 'Ansley Schug');
INSERT INTO LOCATION (NAME, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES ('The Herd Auto Repair', CURRENT_TIMESTAMP - INTERVAL '10 DAY', 'Ansley Schug', CURRENT_TIMESTAMP, 'Michael Leeseberg');
INSERT INTO LOCATION (NAME, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES ('Stampede Auto Repair', CURRENT_TIMESTAMP - INTERVAL '3 DAY', 'Michael Leeseberg', CURRENT_TIMESTAMP, 'Willem Bohrer');

INSERT INTO REPAIR (LOCATIONID, EMPLOYEEID, VEHICLEID, ORDERID, REPAIRDATE, LABOR, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES (1, 1, 1, 4, CURRENT_DATE , 8, CURRENT_TIMESTAMP - INTERVAL '2 DAY', 'Willem Bohrer', CURRENT_TIMESTAMP, 'Michael Leeseberg');
INSERT INTO REPAIR (LOCATIONID, EMPLOYEEID, VEHICLEID, ORDERID, REPAIRDATE, LABOR, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES (2, 2, 2, 1, CURRENT_DATE, 8, CURRENT_TIMESTAMP - INTERVAL '4 DAY', 'Michael Leeseberg', CURRENT_TIMESTAMP, 'Ansley Schug');
INSERT INTO REPAIR (LOCATIONID, EMPLOYEEID, VEHICLEID, ORDERID, REPAIRDATE, LABOR, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES (3, 3, 3, 2, CURRENT_DATE, 8, CURRENT_TIMESTAMP - INTERVAL '3 DAY', 'Ansley Schug', CURRENT_TIMESTAMP, 'Willem Bohrer');
INSERT INTO REPAIR (LOCATIONID, EMPLOYEEID, VEHICLEID, ORDERID, REPAIRDATE, LABOR, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES (2, 1, 4, 3, CURRENT_DATE, 8, CURRENT_TIMESTAMP - INTERVAL '5 DAY', 'Michael Leeseberg', CURRENT_TIMESTAMP, 'Ansley Schug');
INSERT INTO REPAIR (LOCATIONID, EMPLOYEEID, VEHICLEID, ORDERID, REPAIRDATE, LABOR, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
  VALUES (3, 2, 5, 5, CURRENT_DATE, 8, CURRENT_TIMESTAMP - INTERVAL '1 DAY', 'Ansley Schug', CURRENT_TIMESTAMP, 'Willem Bohrer');

INSERT INTO CUSTOMER (VEHICLEID, FIRSTNAME, LASTNAME, PHONENUMBER, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
    VALUES (1, 'David', 'Keranen', (ROUND(((RANDOM() + 1) * 234) + 2188343674)), CURRENT_TIMESTAMP, 'Willem Bohrer', CURRENT_TIMESTAMP, 'Michael Leeseberg');
INSERT INTO CUSTOMER (VEHICLEID, FIRSTNAME, LASTNAME, PHONENUMBER, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
    VALUES (2, 'Tyler', 'Housey', (ROUND(((RANDOM() + 1) * 234) + 2188343674)), CURRENT_TIMESTAMP, 'Michael Leeseberg', CURRENT_TIMESTAMP, 'Willem Bohrer');
INSERT INTO CUSTOMER (VEHICLEID, FIRSTNAME, LASTNAME, PHONENUMBER, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
    VALUES (3, 'Kayla', 'Hanson', (ROUND(((RANDOM() + 1) * 234) + 2188343674)), CURRENT_TIMESTAMP, 'Ansley Schug', CURRENT_TIMESTAMP, 'Ansley Schug');
INSERT INTO CUSTOMER (VEHICLEID, FIRSTNAME, LASTNAME, PHONENUMBER, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
    VALUES (4, 'Brad', 'Knight', (ROUND(((RANDOM() + 1) * 234) + 2188343674)), CURRENT_TIMESTAMP, 'Willem Bohrer', CURRENT_TIMESTAMP, 'Ansley Schug');
INSERT INTO CUSTOMER (VEHICLEID, FIRSTNAME, LASTNAME, PHONENUMBER, CREATEDON, CREATEDBY, LASTUPDATEON, LASTUPDATEDBY)
    VALUES (5, 'Jessie', 'Jueneman', (ROUND(((RANDOM() + 1) * 234) + 2188343674)), CURRENT_TIMESTAMP, 'Ansley Schug', CURRENT_TIMESTAMP, 'Michael Leeseberg');
