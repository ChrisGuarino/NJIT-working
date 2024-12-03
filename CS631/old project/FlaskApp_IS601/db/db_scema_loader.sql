-- Drop the database if it exists and create a new one
DROP DATABASE IF EXISTS CarDealership;
CREATE DATABASE CarDealership;
USE CarDealership;

-- Drop tables if they exist to ensure clean creation
DROP TABLE IF EXISTS Failure_Requires;
DROP TABLE IF EXISTS Test;
DROP TABLE IF EXISTS Recommends;
DROP TABLE IF EXISTS Time_Slot;
DROP TABLE IF EXISTS Used_In;
DROP TABLE IF EXISTS Tire_Type;
DROP TABLE IF EXISTS Part_Replacement;
DROP TABLE IF EXISTS Part;
DROP TABLE IF EXISTS Customer_Cars;
DROP TABLE IF EXISTS Car;
DROP TABLE IF EXISTS Package_Scheduled;
DROP TABLE IF EXISTS Package;
DROP TABLE IF EXISTS Appointment;
DROP TABLE IF EXISTS Purchase;
DROP TABLE IF EXISTS Customer;

-- Customer Table
CREATE TABLE Customer (
    CustomerID INT PRIMARY KEY AUTO_INCREMENT,
    F_Name VARCHAR(255),
    M_Name VARCHAR(255),
    L_Name VARCHAR(255),
    Phone VARCHAR(255),
    Email VARCHAR(255) UNIQUE NOT NULL,
    Address VARCHAR(255)
);

-- Purchase Table
CREATE TABLE Purchase (
    PurchaseID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    Date DATE,
    Cost DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Appointment Table
CREATE TABLE Appointment (
    AppointmentID INT PRIMARY KEY AUTO_INCREMENT,
    CustomerID INT,
    Start_Time TIME,
    Date DATE,
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

-- Package Table
CREATE TABLE Package (
    PackageID INT PRIMARY KEY AUTO_INCREMENT,
    PackageName VARCHAR(255) NOT NULL
);

-- Package_Scheduled Table (for Many-to-Many relationship between Appointment and Package)
CREATE TABLE Package_Scheduled (
    AppointmentID INT,
    PackageID INT,
    PRIMARY KEY (AppointmentID, PackageID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID),
    FOREIGN KEY (PackageID) REFERENCES Package(PackageID)
);

-- Car Table
CREATE TABLE Car (
    License_Plate VARCHAR(50) PRIMARY KEY,
    Make VARCHAR(255),
    Model VARCHAR(255),
    Year INT,
    Color VARCHAR(50),
    Vehicle_Type VARCHAR(50)
);

-- Customer_Cars Table (for Many-to-Many relationship between Customer and Car)
CREATE TABLE Customer_Cars (
    CustomerID INT,
    License_Plate VARCHAR(50),
    PRIMARY KEY (CustomerID, License_Plate),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (License_Plate) REFERENCES Car(License_Plate)
);

-- -- Cars_In_Inventory
-- CREATE TABLE Customer_Cars (
--     CustomerID INT,
--     License_Plate VARCHAR(50),
--     PRIMARY KEY (CustomerID, License_Plate),
--     FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
--     FOREIGN KEY (License_Plate) REFERENCES Car(License_Plate)
-- );

-- Part Table
CREATE TABLE Part (
    PartID INT PRIMARY KEY AUTO_INCREMENT,
    PartName VARCHAR(255) NOT NULL,
    Cost_of_Part DECIMAL(10, 2) NOT NULL
);

-- Part_Replacement Table (for Many-to-Many relationship between Car and Part)
CREATE TABLE Part_Replacement (
    License_Plate VARCHAR(50),
    PartID INT,
    ReplacementDate DATE,
    PRIMARY KEY (License_Plate, PartID, ReplacementDate),
    FOREIGN KEY (License_Plate) REFERENCES Car(License_Plate),
    FOREIGN KEY (PartID) REFERENCES Part(PartID)
);

-- Tire_Type Table
CREATE TABLE Tire_Type (
    TireTypeID INT PRIMARY KEY AUTO_INCREMENT,
    TireType VARCHAR(255) NOT NULL
);

-- Used_In Table (for Many-to-Many relationship between Car and Tire_Type)
CREATE TABLE Used_In (
    License_Plate VARCHAR(50),
    TireTypeID INT,
    PRIMARY KEY (License_Plate, TireTypeID),
    FOREIGN KEY (License_Plate) REFERENCES Car(License_Plate),
    FOREIGN KEY (TireTypeID) REFERENCES Tire_Type(TireTypeID)
);

-- Time_Slot Table
CREATE TABLE Time_Slot (
    TimeSlotID INT PRIMARY KEY AUTO_INCREMENT,
    Time TIME
);

-- Recommends Table (for Many-to-Many relationship between Customer and Car)
CREATE TABLE Recommends (
    CustomerID INT,
    License_Plate VARCHAR(50),
    PRIMARY KEY (CustomerID, License_Plate),
    FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID),
    FOREIGN KEY (License_Plate) REFERENCES Car(License_Plate)
);

-- Test Table
CREATE TABLE Test (
    TestID INT PRIMARY KEY AUTO_INCREMENT,
    TestName VARCHAR(255) NOT NULL
);

-- Failure_Requires Table (for Many-to-Many relationship between Part and Test)
CREATE TABLE Failure_Requires (
    PartID INT,
    TestID INT,
    PRIMARY KEY (PartID, TestID),
    FOREIGN KEY (PartID) REFERENCES Part(PartID),
    FOREIGN KEY (TestID) REFERENCES Test(TestID)
);

-- Populate the database with sample data
USE CarDealership;

-- Populate Customer Table
INSERT INTO Customer (F_Name,M_Name,L_Name,Email, Address) VALUES 
    ('John','Robert','Doe','john.doe@example.com', '123 Elm Street'),
    ('Jane','R','Smith','jane.smith@example.com', '456 Oak Avenue'),
    ('Bob','M','Jones','bob.jones@example.com', '789 Maple Drive');

-- Populate Purchase Table
INSERT INTO Purchase (CustomerID, Date, Cost) VALUES 
    (1, '2023-01-15', 20000.00),
    (2, '2023-02-20', 15000.00),
    (3, '2023-03-25', 22000.00);

-- Populate Appointment Table
INSERT INTO Appointment (CustomerID, Start_Time, Date) VALUES 
    (1, '09:00:00', '2023-04-01'),
    (2, '10:30:00', '2023-04-02'),
    (3, '11:15:00', '2023-04-03');

-- Populate Package Table
INSERT INTO Package (PackageName) VALUES 
    ('Oil Change'),
    ('Brake Inspection'),
    ('Tire Rotation');

-- Populate Package_Scheduled Table
INSERT INTO Package_Scheduled (AppointmentID, PackageID) VALUES 
    (1, 1),
    (1, 2),
    (2, 1),
    (3, 3);

-- Populate Car Table
INSERT INTO Car (License_Plate, Make, Model, Year, Color, Vehicle_Type) VALUES 
    ('ABC123', 'Tesla', 'Model S', 2020, 'Red', 'Sedan'),
    ('XYZ789', 'Tesla', 'Model X', 2021, 'Blue', 'SUV'),
    ('LMN456', 'Tesla', 'Model 3', 2019, 'Black', 'Sedan');

-- Populate Customer_Cars Table
INSERT INTO Customer_Cars (CustomerID, License_Plate) VALUES 
    (1, 'ABC123'),
    (2, 'XYZ789'),
    (3, 'LMN456');

-- Populate Part Table
INSERT INTO Part (PartName, Cost_of_Part) VALUES 
    ('Brake Pad', 50.00),
    ('Oil Filter', 15.00),
    ('Tire', 100.00);

-- Populate Part_Replacement Table
INSERT INTO Part_Replacement (License_Plate, PartID, ReplacementDate) VALUES 
    ('ABC123', 1, '2023-05-01'),
    ('XYZ789', 2, '2023-05-02'),
    ('LMN456', 3, '2023-05-03');

-- Populate Tire_Type Table
INSERT INTO Tire_Type (TireType) VALUES 
    ('All-Season'),
    ('Winter'),
    ('Performance');

-- Populate Used_In Table
INSERT INTO Used_In (License_Plate, TireTypeID) VALUES 
    ('ABC123', 1),
    ('XYZ789', 2),
    ('LMN456', 3);

-- Populate Time_Slot Table
INSERT INTO Time_Slot (Time) VALUES 
    ('08:00:00'),
    ('09:30:00'),
    ('11:00:00');

-- Populate Recommends Table
INSERT INTO Recommends (CustomerID, License_Plate) VALUES 
    (1, 'XYZ789'),
    (2, 'LMN456'),
    (3, 'ABC123');

-- Populate Test Table
INSERT INTO Test (TestName) VALUES 
    ('Safety Test'),
    ('Emission Test'),
    ('Performance Test');

-- Populate Failure_Requires Table
INSERT INTO Failure_Requires (PartID, TestID) VALUES 
    (1, 1),
    (2, 2),
    (3, 3);

-- Print all data from each table

-- Customer Table
SELECT * FROM Customer;

-- Purchase Table
SELECT * FROM Purchase;

-- Appointment Table
SELECT * FROM Appointment;

-- Package Table
SELECT * FROM Package;

-- Package_Scheduled Table
SELECT * FROM Package_Scheduled;

-- Car Table
SELECT * FROM Car;

-- Customer_Cars Table
SELECT * FROM Customer_Cars;

-- Part Table
SELECT * FROM Part;

-- Part_Replacement Table
SELECT * FROM Part_Replacement;

-- Tire_Type Table
SELECT * FROM Tire_Type;

-- Used_In Table
SELECT * FROM Used_In;

-- Time_Slot Table
SELECT * FROM Time_Slot;

-- Recommends Table
SELECT * FROM Recommends;

-- Test Table
SELECT * FROM Test;

-- Failure_Requires Table
SELECT * FROM Failure_Requires;