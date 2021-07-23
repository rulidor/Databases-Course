/*
Students: Dor Peretz, 204446025
Lidor Rubi, 203269972
*/


CREATE TABLE IF NOT EXISTS  "employee" (
"EID"	INTEGER,
"firstName"	VARCHAR(50) NOT NULL,
"lastName"	VARCHAR(50) NOT NULL,
"birthDate"	DATETIME NOT NULL,
"city"	VARCHAR(50),
"streetName"	VARCHAR(50),
"number"	INTEGER, --house number
"door" INTEGER,
PRIMARY KEY("EID")

);


CREATE TABLE IF NOT EXISTS  "ConstructorEmployee" (
	"EID"	INTEGER,
	"companyName" VARCHAR,
	"salaryPerDay"	NUMERIC DEFAULT 0 CHECK(salaryPerDay>=0),
	FOREIGN KEY("EID") REFERENCES "employee"("EID") ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE IF NOT EXISTS "OfficialEmployee" (
	"EID"	INTEGER,
	"startWorkingDate"	DATETIME NOT NULL,

	"degree" INTEGER,
	"Department"	INTEGER,
	FOREIGN KEY("EID") REFERENCES "employee"("EID") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("Department") REFERENCES "department"("DID") ON UPDATE CASCADE ON DELETE CASCADE --works at
);

CREATE TABLE IF NOT EXISTS "cellphone" (
	"cellPhoneNumber"	INTEGER(12),
	"EID"	INTEGER,
	PRIMARY KEY("cellPhoneNumber"),
	FOREIGN KEY("EID") REFERENCES "employee"("EID") ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "project" (
	"PID"	INTEGER,
	"name"	VARCHAR(50),
	"description"	VARCHAR(150),
	"budget"	NUMERIC DEFAULT 0 CHECK(budget>=0),
	"Neighborhood"	INTEGER,
	PRIMARY KEY("PID"),
	FOREIGN KEY("Neighborhood") REFERENCES "neighborhood"("NID") ON UPDATE RESTRICT ON DELETE RESTRICT --done at
);

CREATE TABLE IF NOT EXISTS "ProjectConstructorEmployee" (
	"startWorkingDate"	DATETIME,
	"endWorkingDate"	DATETIME,
	"JobDescription"	VARCHAR(200),
	"EID"	INTEGER,
	"PID"	INTEGER,
	FOREIGN KEY("EID") REFERENCES "employee"("EID") ON UPDATE CASCADE ON DELETE RESTRICT,
	FOREIGN KEY("PID") REFERENCES "project"("PID") ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS "department" (
	"DID"	INTEGER,
	"name"	VARCHAR(25),
	"description"	VARCHAR(150),
	"ManagerID"	INTEGER,
	PRIMARY KEY("DID"),
	FOREIGN KEY("ManagerID") REFERENCES "employee"("EID") ON UPDATE CASCADE ON DELETE RESTRICT --manage
);

CREATE TABLE IF NOT EXISTS "neighborhood" (
	"NID"	INTEGER,
	"name"	VARCHAR(25),
	PRIMARY KEY("NID")
);

CREATE TABLE IF NOT EXISTS "apartment" (
	"sizeSquareMeter"	NUMERIC DEFAULT 0 CHECK(sizeSquareMeter>=0),
	"type"	VARCHAR(25),
	"streetName"	VARCHAR(25),
	"number"	INTEGER,
	"door"	INTEGER,
	"NID"	INTEGER,
	CONSTRAINT "address_pk" PRIMARY KEY("streetName","number","door"),
	FOREIGN KEY("NID") REFERENCES "neighborhood"("NID") ON UPDATE RESTRICT ON DELETE RESTRICT --located
);

CREATE TABLE IF NOT EXISTS "resident" (
	"RID"	INTEGER,
	"firstName"	VARCHAR(25),
	"lastName"	VARCHAR(25),
	"birthDate"	DATETIME NOT NULL,
	"streetName"	VARCHAR(25),
	"number"	INTEGER,
	"door"	INTEGER,
	PRIMARY KEY("RID"),
	CONSTRAINT "address_pk" FOREIGN KEY("streetName","number","door") REFERENCES "apartment"("streetName","number","door") ON UPDATE CASCADE ON DELETE RESTRICT --live at
);

CREATE TABLE IF NOT EXISTS "trashcan" (
	"TCID"	INTEGER(30),
	"CreationDate"	DATETIME NOT NULL,
	"ExpirationDate"	DATETIME NOT NULL,
	"RID"	INTEGER,
	PRIMARY KEY("TCID"),
	CONSTRAINT "ch_ex" CHECK(ExpirationDate>CreationDate),
	FOREIGN KEY("RID") REFERENCES "resident"("RID") ON UPDATE CASCADE ON DELETE SET NULL --holds
);

CREATE TABLE IF NOT EXISTS "ParkingArea" (
	"AID"	INTEGER,
	"pricePerHour"	NUMERIC DEFAULT 0 CHECK(pricePerHour>=0),
	"maxPricePerDay"	NUMERIC DEFAULT 0,
	"name"	VARCHAR(25),
	"NID"	INTEGER,
	PRIMARY KEY("AID"),
	CONSTRAINT "ch_p" CHECK(maxPricePerDay>=pricePerHour),
	FOREIGN KEY("NID") REFERENCES "neighborhood"("NID") ON UPDATE CASCADE ON DELETE CASCADE --belongs to
);

CREATE TABLE IF NOT EXISTS "car" (
	"CID"	INTEGER,
	"CellPhoneNumber"	INTEGER(12),
	"creditCard"	INTEGER(50),
	"ExpirationDate"	DATETIME NOT NULL,
	"threeDigits"	INTEGER(3) NOT NULL,
	"ID"	INTEGER(20),
	PRIMARY KEY("CID")
);

CREATE TABLE IF NOT EXISTS "CarParking" (
	"startTime"	DATETIME,
	"endTime"	DATETIME,
	"AID"	INTEGER,
	"CID"	INTEGER,
	"cost"	NUMERIC,
	CONSTRAINT "ch_t" CHECK(endTime>=startTime),
	PRIMARY KEY("startTime"),
	FOREIGN KEY("AID") REFERENCES "ParkingArea"("AID") ON UPDATE CASCADE ON DELETE SET NULL, --park at
	FOREIGN KEY("CID") REFERENCES "car"("CID") ON UPDATE CASCADE ON DELETE CASCADE --car parking
);