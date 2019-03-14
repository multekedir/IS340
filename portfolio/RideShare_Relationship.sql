/*  Schema types (schemaTypes):
      RELATIONSHIP
    ID/Reference constraint suffixes (idSuffix, refSuffix):
      _PK, _FK
*/
USE Rideshare;

/*************************************************************************************
    Note for foreign key constraints below:
    - Consider applying these constraints AFTER adding initial data, to avoid nuisance
      errors and to more directly identify issues with design or initial data
**************************************************************************************/

ALTER TABLE Address
  ADD CONSTRAINT  Address_Person_FK FOREIGN KEY (Person) REFERENCES Person (id)
;

ALTER TABLE User
  ADD CONSTRAINT  User_Person_FK FOREIGN KEY (Person) REFERENCES Person (id)
;

ALTER TABLE Driver
  ADD CONSTRAINT  Driver_Person_FK FOREIGN KEY (Person) REFERENCES Person (id)
;
/*
Removed this two because the relationship has been created alredy in User and Driver

ALTER TABLE Person
  ADD CONSTRAINT  Person_User_FK FOREIGN KEY (User) REFERENCES User (username)
;

ALTER TABLE Person
  ADD CONSTRAINT  Person_Driver_FK FOREIGN KEY (Driver) REFERENCES Driver (licence_number)
;
*/
ALTER TABLE Ride
  ADD CONSTRAINT  Ride_Status_FK FOREIGN KEY (Status) REFERENCES Status (id)
;

ALTER TABLE Ride
  ADD CONSTRAINT  Ride_Van_FK FOREIGN KEY (Van) REFERENCES Van (plate_number)
;

ALTER TABLE Ride
  ADD CONSTRAINT  Ride_Driver_FK FOREIGN KEY (Driver) REFERENCES Driver (licence_number)
;

ALTER TABLE Request
  ADD CONSTRAINT  Request_from_Address_FK FOREIGN KEY (from_Address) REFERENCES Address (id)
;

ALTER TABLE Request
  ADD CONSTRAINT  Request_to_Address_FK FOREIGN KEY (to_Address) REFERENCES Address (id)
;

ALTER TABLE Request
  ADD CONSTRAINT  Request_Status_FK FOREIGN KEY (Status) REFERENCES Status (id)
;

ALTER TABLE Request
  ADD CONSTRAINT  Request_User_FK FOREIGN KEY (User) REFERENCES User (username)
;

ALTER TABLE Request
  ADD CONSTRAINT  Request_Ride_FK FOREIGN KEY (Ride) REFERENCES Ride (id)
;

ALTER TABLE VanNotes
  ADD CONSTRAINT  VanNotes_Van_FK FOREIGN KEY (Van) REFERENCES Van (plate_number)
;

ALTER TABLE VanNotes
  ADD CONSTRAINT  VanNotes_Person_FK FOREIGN KEY (Person) REFERENCES Person (id)
;

ALTER TABLE Location
  ADD CONSTRAINT  Location_Van_FK FOREIGN KEY (Van) REFERENCES Van (plate_number)
;

USE Rideshare;

/*Insert new data check FK*/

INSERT INTO Person VALUES ( 3, 'Gabi', 'Wilson', 5412455868, 'WilbGabi@wou.edu');
INSERT INTO Person VALUES ( 4, 'Jess', 'Cagle', 44165818833 , 'CagJess@wou.edu');
INSERT INTO Person VALUES ( 5, 'Laura', 'Jeanne', 55165818833 , 'JeanneLau@wou.edu');
INSERT INTO Person VALUES ( 6, 'Alfred', 'Bernie', 55189818833 , 'BernieAl@wou.edu');

INSERT INTO Driver VALUES (1075891, 6, '2020-12-20' );

INSERT INTO User VALUES ('CagJes', 4, '913e450e34aiopl11d974f30b' );
INSERT INTO User VALUES ('WilbGabi', 3, '913e450e34aiopl11d974f30b' );
INSERT INTO User VALUES ('JeanneLau', 5, '913e489e34aiopl11d974f30b' );


INSERT INTO Address VALUES (4, '333 Broad St S', NULL, 'Monmouth', 'OR', 97361, 2, 'besties' );
INSERT INTO Address VALUES (5, '689 Main St E', NULL, 'Monmouth', 'OR', 97361, NULL, NULL );
INSERT INTO Address VALUES (6, '39189 Military Rd', NULL, 'Monmouth', 'OR', 97361, 4, 'crib' );
INSERT INTO Address VALUES (7, '689 Main St E', NULL, 'Monmouth', 'OR', 97361, NULL, NULL );
INSERT INTO Address VALUES (8, '689 Main St E', NULL, 'Monmouth', 'OR', 97361, 3, NULL );

INSERT INTO Status VALUES (4, 'Droped Off' );

INSERT INTO Ride VALUES (2, 4, '942FLQ', 1078591, NOW());

INSERT INTO Request VALUES ( 2, 7, 5, 3, 13, 'WilbGabi', NULL, NOW());
INSERT INTO Request VALUES ( 3, 1, 6, 1, 1, 'CagJes', 2, NOW() );
INSERT INTO Request VALUES ( 4, 4, 8, 2, 6, 'JeanneLau', NULL, NOW());



/*create views*/

CREATE VIEW Rider AS
 SELECT U.username, P.first_name, P.last_name, P.phone, P.email
 FROM User U, Person P
 WHERE U.Person = P.id;
 

CREATE VIEW Rider_Address AS
 SELECT 
	U.username,
	 CONCAT(P.first_name, ' ',P.last_name) AS 'Full Name', P.email,
     IF(A.apt IS NULL, CONCAT(A.line, ' ', A.city, ' ', A.state, ' ', A.postalCode), CONCAT(A.line, ' ', A.apt, ' ', A.city, ' ', A.state, ' ', A.postalCode)) AS 'Full_Address',
     A.name AS 'Address Name'
 FROM User U, Person P, Address A
 WHERE (U.Person = P.id AND (P.id = A.Person AND (A.Person IS NOT NULL)));
 
SELECT * FROM Rider_Address; 


CREATE VIEW Full_Address AS
 SELECT F.id,
	IF(F.apt IS NULL, CONCAT(F.line, ' ', F.city, ' ', F.state, ' ', F.postalCode), CONCAT(F.line, ' ', F.apt, ' ', F.city, ' ', F.state, ' ', F.postalCode)) AS 'Contact_Address'
 FROM  Address F; 
 
SELECT * FROM Full_Address; 
 

CREATE VIEW InProgress_Rides AS
SELECT R.id,
	Req.User, 
	R.Driver,
	R.Van,
	FA.Contact_Address AS 'From',
	FA_.Contact_Address AS 'To'
	
FROM Request Req, Ride R, Full_Address FA, Full_Address FA_
WHERE (R.Status = 2 AND Req.Ride = R.id AND Req.from_Address= FA.id AND  Req.to_Address= FA_.id);

SELECT * FROM InProgress_Rides; 

/*improve db*/
ALTER TABLE Person ADD UNIQUE (phone);

ALTER TABLE Van ADD UNIQUE (plate_number);

ALTER TABLE User ADD UNIQUE (username);

ALTER TABLE Driver ADD UNIQUE (licence_number);

ALTER TABLE Person ADD UNIQUE (id); 

ALTER TABLE Person ADD UNIQUE (email);