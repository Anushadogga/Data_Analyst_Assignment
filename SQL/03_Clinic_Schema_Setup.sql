CREATE TABLE clinics (
    cid VARCHAR(20) PRIMARY KEY,
    clinic_name VARCHAR(100),
    city VARCHAR(50),
    state VARCHAR(50),
    country VARCHAR(50)
);

-- Sample data
INSERT INTO clinics VALUES
('cnc-0100001', 'XYZ Clinic', 'Los Angeles', 'California', 'USA'),
('cnc-0100002', 'ABC Clinic', 'San Francisco', 'California', 'USA'),
('cnc-0100003', 'Health Plus', 'New York', 'New York', 'USA');

-- Customers Table
CREATE TABLE customer (
    uid VARCHAR(20) PRIMARY KEY,
    name VARCHAR(100),
    mobile VARCHAR(15)
);

-- Sample data
INSERT INTO customer VALUES
('bk-09f3e-95hj', 'Jon Doe', '9712345678'),
('bk-09f3e-95hk', 'Alice Johnson', '9723456789'),
('bk-09f3e-95hl', 'Gary Hughes', '9734567890');

-- Clinic Sales Table
CREATE TABLE clinic_sales (
    oid VARCHAR(25) PRIMARY KEY,
    uid VARCHAR(20),
    cid VARCHAR(20),
    amount DECIMAL(10,2),
    datetime DATETIME,
    sales_channel VARCHAR(50),
    FOREIGN KEY (uid) REFERENCES customer(uid),
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- Sample data
INSERT INTO clinic_sales VALUES
('ord-00100-00100', 'bk-09f3e-95hj', 'cnc-0100001', 24999, '2021-09-23 12:03:22', 'sodat'),
('ord-00100-00101', 'bk-09f3e-95hk', 'cnc-0100002', 12000, '2021-08-15 10:15:10', 'online'),
('ord-00100-00102', 'bk-09f3e-95hl', 'cnc-0100003', 18000, '2021-07-11 14:25:00', 'offline');

-- Expenses Table
CREATE TABLE expenses (
    eid VARCHAR(25) PRIMARY KEY,
    cid VARCHAR(20),
    description VARCHAR(100),
    amount DECIMAL(10,2),
    datetime DATETIME,
    FOREIGN KEY (cid) REFERENCES clinics(cid)
);

-- Sample data
INSERT INTO expenses VALUES
('exp-0100-00100', 'cnc-0100001', 'First-aid supplies', 557, '2021-09-23 07:36:48'),
('exp-0100-00101', 'cnc-0100002', 'Cleaning materials', 1200, '2021-08-15 09:00:00'),
('exp-0100-00102', 'cnc-0100003', 'Lab equipment', 1800, '2021-07-11 13:30:00');
