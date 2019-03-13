/*  UNCOMMENT to start over:
DROP DATABASE IF EXISTS Rideshare;
*/
/*  Schema types (schemaTypes):
      ENTITY
    Design data types mapped to SQL data types (dataTypes):
      ID=CHAR(10);REF=CHAR(10);VARCHAR=VARCHAR(32);TIMESTAMP=TIMESTAMP;INT=INT;STR=TEXT;DATE=DATE;NAME=CHAR(20);PHONE=VARCHAR(12);BIT=BIT;CITY=CHAR(22);STATE=CHAR(2)
    ID/Reference constraint suffixes (idSuffix, refSuffix):
      _PK, _FK
*/
CREATE DATABASE IF NOT EXISTS Rideshare;
USE Rideshare;

CREATE TABLE User (
  username        CHAR(10)   NOT NULL  /* PK */,
  Person          CHAR(10)   NOT NULL,
  password        VARCHAR(32)  NOT NULL,
      CONSTRAINT  User_PK  PRIMARY KEY (username)
);

CREATE TABLE Driver (
  licence_number  CHAR(10)   NOT NULL  /* PK */,
  Person          CHAR(10)   NOT NULL,
  expiration_date  DATE       NOT NULL,
      CONSTRAINT  Driver_PK  PRIMARY KEY (licence_number)
);

CREATE TABLE Person (
  id              CHAR(10)   NOT NULL  /* PK */,
  first_name      TEXT       NOT NULL,
  last_name       TEXT       NOT NULL,
  phone           VARCHAR(32)  NOT NULL,
  email           TEXT       NOT NULL,
      CONSTRAINT  Person_PK  PRIMARY KEY (id)
);

CREATE TABLE Ride (
  id              CHAR(10)   NOT NULL  /* PK */,
  Status          CHAR(10)   NOT NULL,
  Van             CHAR(10)   NOT NULL,
  Driver          CHAR(10)   NOT NULL,
  created         TIMESTAMP  NOT NULL,
      CONSTRAINT  Ride_PK  PRIMARY KEY (id)
);

CREATE TABLE Request (
  id              CHAR(10)   NOT NULL  /* PK */,
  Address         CHAR(10)   NOT NULL,
  Address         CHAR(10)   NOT NULL,
  Status          CHAR(10)   NOT NULL,
  num_of_people   INT        NOT NULL,
  User            CHAR(10)   NOT NULL,
  Ride            CHAR(10)       NULL,
  created         TIMESTAMP  NOT NULL,
      CONSTRAINT  Request_PK  PRIMARY KEY (id)
);

CREATE TABLE Van (
  plate_number    CHAR(10)   NOT NULL  /* PK */,
  fuel            INT        NOT NULL,
  num_of_seat     INT        NOT NULL,
      CONSTRAINT  Van_PK  PRIMARY KEY (plate_number)
);

CREATE TABLE VanNotes (
  id              CHAR(10)   NOT NULL  /* PK */,
  Van             CHAR(10)   NOT NULL,
  Person          CHAR(10)   NOT NULL,
  notes           TEXT       NOT NULL,
      CONSTRAINT  VanNotes_PK  PRIMARY KEY (id)
);

CREATE TABLE Address (
  id              CHAR(10)   NOT NULL  /* PK */,
  line            TEXT       NOT NULL,
  apt             TEXT           NULL,
  city            CHAR(22)   NOT NULL,
  state           CHAR(2)    NOT NULL,
  postalCode      INT        NOT NULL,
  name            TEXT           NULL,
      CONSTRAINT  Address_PK  PRIMARY KEY (id)
);

CREATE TABLE Location (
  id              CHAR(10)   NOT NULL  /* PK */,
  longitude       INT        NOT NULL,
  latitude        INT        NOT NULL,
  Van             CHAR(10)   NOT NULL,
  created         TIMESTAMP  NOT NULL,
      CONSTRAINT  Location_PK  PRIMARY KEY (id)
);

CREATE TABLE Status (
  id              CHAR(10)   NOT NULL  /* PK */,
  description     TEXT       NOT NULL,
      CONSTRAINT  Status_PK  PRIMARY KEY (id)
);
