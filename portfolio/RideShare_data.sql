/*  Not-applicable (n/a) data pattern (naValue):
      n/a
    No-data (null) data value (nullValue):
      NULL
*/
USE Rideshare;

/*  Address( id, line, apt, city, state, postalCode, Person, name, [n/a:Request], [n/a:Request] )
*/
INSERT INTO Address VALUES (
  1, '175 Stadium Dr N', 'A', 'Monmouth', 'OR', 97361, NULL, NULL );
INSERT INTO Address VALUES (
  2, '400 Southgate Dr S', NULL, 'Monmouth', 'OR', 97361, 1, 'home' );

/*  User( username, Person, password, [n/a:Request] )
*/
INSERT INTO User VALUES (
  'multikedir', 1, '913e450e34a785f11d974f30b' );
INSERT INTO User VALUES (
  'bobman23', 2, '0168cd7fd3186086769a9883d' );

/*  Driver( licence_number, Person, expiration_date, [n/a:Ride] )
*/
INSERT INTO Driver VALUES (
  1078591, 2, '2040-02-20' );

/*  Person( id, first_name, last_name, phone, email, [n/a:Address], [n/a:User], [n/a:Driver], [n/a:VanNotes] )
*/
INSERT INTO Person VALUES (
  1, 'Multezem', 'Kedir', 5416366899, 'mkedir@wou.edu' );
INSERT INTO Person VALUES (
  2, 'Bob', 'Man', 5412025868, 'manbo@wou.edu' );

/*  Ride( id, Status, Van, Driver, [n/a:Request], created )
*/
INSERT INTO Ride VALUES (
  1, 2, '942FLQ', 1078591, NOW() );

/*  Request( id, Address, Address, Status, num_of_people, User, Ride, created )
*/
INSERT INTO Request VALUES (
  1, 1, 2, 1, 6, 'multikedir', 1, NOW() );

/*  Van( plate_number, fuel, num_of_seat, [n/a:Ride], [n/a:Location], [n/a:VanNotes] )
*/
INSERT INTO Van VALUES (
  '942FLQ', 80, 12 );

/*  VanNotes( id, Van, Person, notes )
*/
INSERT INTO VanNotes VALUES (
  1, '942FLQ', 2, 'was driving down campus way I' );
INSERT INTO VanNotes VALUES (
  2, '942FLQ', 1, 'driver was rude and she hit a' );

/*  Location( id, latitude_longitude, Van, created )
*/
INSERT INTO Location VALUES (
  1, '44.853206 123.237461', '942FLQ', NOW() );
INSERT INTO Location VALUES (
  2, '44.851929 123.237365', '942FLQ', NOW() );

/*  Status( id, description, [n/a:Request], [n/a:Ride] )
*/
INSERT INTO Status VALUES (
  1, 'acepted' );
INSERT INTO Status VALUES (
  2, 'in progress' );
INSERT INTO Status VALUES (
  3, 'canceled' );
