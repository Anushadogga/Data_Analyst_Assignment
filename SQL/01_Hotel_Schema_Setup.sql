-- USERS
CREATE TABLE users (
    user_id VARCHAR(50),
    name VARCHAR(100)
);

INSERT INTO users VALUES
('U1','John'),
('U2','Jane'),
('U3','Mike');

-- BOOKINGS
CREATE TABLE bookings (
    booking_id VARCHAR(50),
    booking_date DATE,
    room_no VARCHAR(50),
    user_id VARCHAR(50)
);

INSERT INTO bookings VALUES
('B1','2021-11-10','R1','U1'),
('B2','2021-11-15','R2','U2'),
('B3','2021-10-05','R3','U1'),
('B4','2021-10-20','R4','U3');

-- ITEMS
CREATE TABLE items (
    item_id VARCHAR(50),
    item_name VARCHAR(100),
    item_rate INT
);

INSERT INTO items VALUES
('I1','Paratha',20),
('I2','Veg Curry',100),
('I3','Paneer',200);

-- BOOKING COMMERCIALS
CREATE TABLE booking_commercials (
    booking_id VARCHAR(50),
    bill_id VARCHAR(50),
    bill_date DATE,
    item_id VARCHAR(50),
    item_quantity INT
);

INSERT INTO booking_commercials VALUES
('B1','BL1','2021-11-10','I1',5),
('B1','BL1','2021-11-10','I2',3),
('B2','BL2','2021-11-15','I3',2),
('B3','BL3','2021-10-05','I2',6),
('B4','BL4','2021-10-20','I1',10);
