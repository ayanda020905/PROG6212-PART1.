CREATE TABLE [User] (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    Role VARCHAR(20) NOT NULL,
    CreatedAt DATETIME NOT NULL DEFAULT GETDATE()
);

CREATE TABLE Organiser (
    OrganiserID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    Organisation VARCHAR(100) NOT NULL,
    ContactNumber VARCHAR(20) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

CREATE TABLE Participant (
    ParticipantID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL UNIQUE,
    DateOfBirth DATE NOT NULL,
    Gender VARCHAR(20) NOT NULL,
    EmergencyContact VARCHAR(100) NOT NULL,
    FOREIGN KEY (UserID) REFERENCES [User](UserID)
);

CREATE TABLE Route (
    RouteID INT IDENTITY(1,1) PRIMARY KEY,
    RouteName VARCHAR(100) NOT NULL,
    DistanceKm DECIMAL(5,2) NOT NULL,
    StartPoint VARCHAR(100) NOT NULL,
    FinishPoint VARCHAR(100) NOT NULL,
    RouteDescription VARCHAR(255) NOT NULL
);

CREATE TABLE Event (
    EventID INT IDENTITY(1,1) PRIMARY KEY,
    OrganiserID INT NOT NULL,
    RouteID INT NOT NULL UNIQUE,
    EventName VARCHAR(100) NOT NULL,
    EventDate DATE NOT NULL,
    Location VARCHAR(100) NOT NULL,
    Description VARCHAR(255) NOT NULL,
    Status VARCHAR(20) NOT NULL,
    FOREIGN KEY (OrganiserID) REFERENCES Organiser(OrganiserID),
    FOREIGN KEY (RouteID) REFERENCES Route(RouteID)
);

CREATE TABLE Category (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    EventID INT NOT NULL,
    CategoryName VARCHAR(100) NOT NULL,
    DistanceKm DECIMAL(5,2) NOT NULL,
    EntryFee DECIMAL(10,2) NOT NULL,
    MaximumParticipants INT NOT NULL,
    FOREIGN KEY (EventID) REFERENCES Event(EventID)
);

CREATE TABLE Enrolment (
    EnrolmentID INT IDENTITY(1,1) PRIMARY KEY,
    ParticipantID INT NOT NULL,
    CategoryID INT NOT NULL,
    EnrolmentDate DATE NOT NULL DEFAULT GETDATE(),
    EnrolmentStatus VARCHAR(20) NOT NULL,
    RaceNumber INT NOT NULL,
    FOREIGN KEY (ParticipantID) REFERENCES Participant(ParticipantID),
    FOREIGN KEY (CategoryID) REFERENCES Category(CategoryID)
);

CREATE TABLE Result (
    ResultID INT IDENTITY(1,1) PRIMARY KEY,
    EnrolmentID INT NOT NULL UNIQUE,
    FinishTime TIME NOT NULL,
    Position INT NOT NULL,
    AveragePace DECIMAL(5,2) NOT NULL,
    FOREIGN KEY (EnrolmentID) REFERENCES Enrolment(EnrolmentID)
);
INSERT INTO [User] (FirstName, LastName, Email, PasswordHash, Role)
VALUES
('John', 'Mokoena', 'john@raceday.com', 'password123', 'Organiser'),
('Sarah', 'Naidoo', 'sarah@raceday.com', 'password123', 'Organiser'),
('Thabo', 'Dlamini', 'thabo@email.com', 'password123', 'Participant'),
('Lerato', 'Molefe', 'lerato@email.com', 'password123', 'Participant');

INSERT INTO Organiser (UserID, Organisation, ContactNumber)
VALUES
(1, 'RaceDay Events', '0712345678'),
(2, 'City Running Club', '0723456789');

INSERT INTO Participant (UserID, DateOfBirth, Gender, EmergencyContact)
VALUES
(3, '2000-05-15', 'Male', '0734567890'),
(4, '1999-08-20', 'Female', '0745678901');

INSERT INTO Route (RouteName, DistanceKm, StartPoint, FinishPoint, RouteDescription)
VALUES
('Johannesburg City Route', 10.00, 'City Park', 'City Stadium', 'A city road running route'),
('Pretoria Marathon Route', 21.10, 'Pretoria Park', 'Union Buildings', 'A half marathon route'),
('Soweto Fun Run Route', 5.00, 'Soweto Stadium', 'Soweto Stadium', 'A short community running route');

INSERT INTO Event (OrganiserID, RouteID, EventName, EventDate, Location, Description, Status)
VALUES
(1, 1, 'Johannesburg City Run', '2026-10-10', 'Johannesburg', 'Annual city running event', 'Open'),
(2, 2, 'Pretoria Half Marathon', '2026-11-15', 'Pretoria', 'Half marathon running event', 'Open'),
(1, 3, 'Soweto Fun Run', '2026-12-05', 'Soweto', 'Community fun running event', 'Open');

INSERT INTO Category (EventID, CategoryName, DistanceKm, EntryFee, MaximumParticipants)
VALUES
(1, '10KM Open', 10.00, 150.00, 500),
(1, '10KM Junior', 10.00, 100.00, 200),
(2, '21KM Open', 21.10, 250.00, 1000),
(2, '10KM Run', 10.00, 150.00, 500),
(3, '5KM Open', 5.00, 80.00, 300),
(3, '5KM Junior', 5.00, 50.00, 200);

INSERT INTO Enrolment (ParticipantID, CategoryID, EnrolmentStatus, RaceNumber)
VALUES
(1, 1, 'Confirmed', 101),
(2, 1, 'Confirmed', 102),
(1, 3, 'Confirmed', 201),
(2, 5, 'Confirmed', 301);

INSERT INTO Result (EnrolmentID, FinishTime, Position, AveragePace)
VALUES
(1, '00:52:30', 1, 5.25),
(2, '00:58:45', 2, 5.88);