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

ALTER TABLE Person
  ADD CONSTRAINT  Person_User_FK FOREIGN KEY (User) REFERENCES User (username)
;

ALTER TABLE Person
  ADD CONSTRAINT  Person_Driver_FK FOREIGN KEY (Driver) REFERENCES Driver (licence_number)
;

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
  ADD CONSTRAINT  Request_Address_FK FOREIGN KEY (Address) REFERENCES Address (id)
;

ALTER TABLE Request
  ADD CONSTRAINT  Request_Address_FK FOREIGN KEY (Address) REFERENCES Address (id)
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
