CREATE TABLE Customer ( 
CustomerID INT PRIMARY KEY, 
Name VARCHAR(255),
Email VARCHAR(255),
Address VARCHAR(255)
);

CREATE TABLE Cars_in_Inventory ( 
CarID INT PRIMARY KEY,
Model VARCHAR(255),
Year INT,
Make VARCHAR(255),
Color VARCHAR(50) 
);

CREATE TABLE Vehicle_Type ( 
TypeID INT PRIMARY KEY, 
TypeName VARCHAR(255)
);

CREATE TABLE Customer_Cars (
LicensePlate VARCHAR(50) PRIMARY KEY,
CustomerID INT,
CarID INT,
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID), 
FOREIGN KEY (CarID) REFERENCES Cars_in_Inventory(CarID)
);

CREATE TABLE Appointment ( 
AppointmentID INT PRIMARY KEY, 
Start_Time TIME,
Date DATE,
Time_Slot VARCHAR(50),
CustomerID INT,
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Purchase ( 
PurchaseID INT PRIMARY KEY, 
CustomerID INT,
CarID INT,
Cost DECIMAL(10, 2),
Date DATE,
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID), 
FOREIGN KEY (CarID) REFERENCES Cars_in_Inventory(CarID)

);

CREATE TABLE Package ( 
PackageID INT PRIMARY KEY, 
PackageName VARCHAR(255), 
Cost DECIMAL(10, 2)
);

CREATE TABLE Part (
PartID INT PRIMARY KEY, 
PartName VARCHAR(255), 
Cost_Of_Part DECIMAL(10, 2)
);

CREATE TABLE Recommends (
RecommenderID INT,
RecommendedID INT,
PRIMARY KEY (RecommenderID, RecommendedID),
FOREIGN KEY (RecommenderID) REFERENCES Customer(CustomerID), 
FOREIGN KEY (RecommendedID) REFERENCES Customer(CustomerID)
);

CREATE TABLE Made_Purchase (
CustomerID INT,
PurchaseID INT,
PRIMARY KEY (CustomerID, PurchaseID),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID), 
FOREIGN KEY (PurchaseID) REFERENCES Purchase(PurchaseID)
);

CREATE TABLE Owns (
CustomerID INT,
LicensePlate VARCHAR(50),
PRIMARY KEY (CustomerID, LicensePlate),
FOREIGN KEY (CustomerID) REFERENCES Customer(CustomerID), 
FOREIGN KEY (LicensePlate) REFERENCES Customer_Cars(LicensePlate)
);

CREATE TABLE Requires (
CarID INT,
PartID INT,
PRIMARY KEY (CarID, PartID),
FOREIGN KEY (CarID) REFERENCES Cars_in_Inventory(CarID), 
FOREIGN KEY (PartID) REFERENCES Part(PartID)
);

CREATE TABLE Was_Performed (
AppointmentID INT,
PackageID INT,
PRIMARY KEY (AppointmentID, PackageID),
FOREIGN KEY (AppointmentID) REFERENCES Appointment(AppointmentID), 
FOREIGN KEY (PackageID) REFERENCES Package(PackageID)
);

CREATE TABLE Was_Replaced (
PartID INT,
CarID INT,
PRIMARY KEY (PartID, CarID),
FOREIGN KEY (PartID) REFERENCES Part(PartID),
FOREIGN KEY (CarID) REFERENCES Cars_in_Inventory(CarID)
);

CREATE TABLE Is_Type ( CarID INT,
TypeID INT,
PRIMARY KEY (CarID, TypeID),
FOREIGN KEY (CarID) REFERENCES Cars_in_Inventory(CarID), 
FOREIGN KEY (TypeID) REFERENCES Vehicle_Type(TypeID)
);