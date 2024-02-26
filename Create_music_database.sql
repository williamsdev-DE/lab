-- Users Table
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(255) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    Email VARCHAR(255) NOT NULL UNIQUE,
    UserRole ENUM('read only', 'read write', 'write only', 'admin') NOT NULL,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Roles Table
CREATE TABLE Roles (
    RoleID INT AUTO_INCREMENT PRIMARY KEY,
    RoleName ENUM('read only', 'read write', 'write only', 'admin') NOT NULL
);

-- UserRoles Junction Table
CREATE TABLE UserRoles (
    UserID INT,
    RoleID INT,
    PRIMARY KEY (UserID, RoleID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

-- Artists Table
CREATE TABLE Artists (
    ArtistID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL UNIQUE,
    Bio TEXT,
    Country VARCHAR(100),
    Genre VARCHAR(100),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- ArtistAchievements Table
CREATE TABLE ArtistAchievements (
    AchievementID INT AUTO_INCREMENT PRIMARY KEY,
    ArtistID INT NOT NULL UNIQUE,
    Achievement VARCHAR(255) NOT NULL,
    DateAchieved DATE,
    FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID) ON DELETE CASCADE,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP
);

-- Albums Table
CREATE TABLE Albums (
    AlbumID INT AUTO_INCREMENT PRIMARY KEY,
    ArtistID INT NOT NULL,
    Title VARCHAR(255) NOT NULL,
    ReleaseDate DATE,
    Genre VARCHAR(100),
    CoverImageURL VARCHAR(255),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (ArtistID) REFERENCES Artists(ArtistID) ON DELETE CASCADE
);

-- Tracks Table
CREATE TABLE Tracks (
    TrackID INT AUTO_INCREMENT PRIMARY KEY,
    AlbumID INT NOT NULL,
    Title VARCHAR(255) NOT NULL,
    Duration INT NOT NULL, -- Duration in seconds
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AlbumID) REFERENCES Albums(AlbumID) ON DELETE CASCADE
);

-- Compilations Table
CREATE TABLE Compilations (
    CompilationID INT AUTO_INCREMENT PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    ReleaseDate DATE,
    Genre VARCHAR(100),
    CoverImageURL VARCHAR(255),
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- CompilationTracks Junction Table
CREATE TABLE CompilationTracks (
    CompilationID INT,
    TrackID INT,
    PRIMARY KEY (CompilationID, TrackID),
    FOREIGN KEY (CompilationID) REFERENCES Compilations(CompilationID) ON DELETE CASCADE,
    FOREIGN KEY (TrackID) REFERENCES Tracks(TrackID) ON DELETE CASCADE
);

-- Sales Table
CREATE TABLE Sales (
    SaleID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,
    AlbumID INT,
    TrackID INT,
    Quantity INT NOT NULL,
    SalePrice DECIMAL(10, 2) NOT NULL,
    SaleDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID) ON DELETE CASCADE,
    FOREIGN KEY (AlbumID) REFERENCES Albums(AlbumID) ON DELETE SET NULL,
    FOREIGN KEY (TrackID) REFERENCES Tracks(TrackID) ON DELETE SET NULL
);



ALTER TABLE Albums ADD UNIQUE INDEX idx_artist_title (ArtistID, Title);
ALTER TABLE Tracks ADD UNIQUE INDEX idx_album_title (AlbumID, Title);


ALTER TABLE Sales
ADD COLUMN AlbumTitle VARCHAR(255),
ADD COLUMN TrackTitle VARCHAR(255);


UPDATE Sales s
INNER JOIN Albums a ON s.AlbumID = a.AlbumID
SET s.AlbumTitle = a.Title
WHERE s.AlbumID IS NOT NULL;


UPDATE Sales s
INNER JOIN Tracks t ON s.TrackID = t.TrackID
SET s.TrackTitle = t.Title
WHERE s.TrackID IS NOT NULL;

SELECT * from Sales s;

ALTER TABLE Sales
ADD COLUMN Username VARCHAR(255);


UPDATE Sales s
JOIN Users u ON s.UserID = u.UserID
SET s.Username = u.Username;




-- Insert Users
INSERT INTO Users (Username, PasswordHash, Email, UserRole) VALUES
('johnDoe', 'hashed_pass123', 'johnDoe@mail.com', 'admin'),
('janeDoe', 'hashed_pass124', 'janeDoe@mail.com', 'read only'),
('mikeSmith', 'hashed_pass125', 'mikeSmith@mail.com', 'read write'),
('sarahJones', 'hashed_pass126', 'sarahJones@mail.com', 'write only'),
('alexBrown', 'hashed_pass127', 'alexBrown@mail.com', 'admin');

-- Insert Artists
INSERT INTO Artists (Name, Bio, Country, Genre) VALUES
('Notorious B.I.G.', 'A legendary rapper from Brooklyn.', 'USA', 'Hip Hop'),
('2PAC', 'Influential rapper and actor.', 'USA', 'Hip Hop'),
('Adele', 'English singer-songwriter.', 'UK', 'Pop'),
('Drake', 'Canadian rapper and singer.', 'Canada', 'Hip Hop'),
('Dolly Parton', 'Country music icon.', 'USA', 'Country');


-- Assuming ArtistIDs from 1 to 5
INSERT INTO ArtistAchievements (ArtistID, Achievement, DateAchieved) VALUES
(1, 'Rock & Roll Hall of Fame Induction', '2020-11-07'),
(2, 'Rock & Roll Hall of Fame Induction', '2017-04-07'),
(3, '15 Grammy Awards', '2017-02-12'),
(4, '4 Grammy Awards', '2019-02-10'),
(5, '10 Country Music Association Awards', '2021-11-10');


-- Insert Albums
INSERT INTO Albums (ArtistID, Title, ReleaseDate, Genre) VALUES
(1, 'Ready to Die', '1994-09-13', 'Hip Hop'),
(2, 'All Eyez on Me', '1996-02-13', 'Hip Hop'),
(3, '21', '2011-01-24', 'Pop'),
(4, 'Scorpion', '2018-06-29', 'Hip Hop'),
(5, 'Jolene', '1974-02-04', 'Country');

-- Insert Tracks for AlbumID 1
INSERT INTO Tracks (AlbumID, Title, Duration) VALUES
(1, 'Juicy', 300),
(1, 'Big Poppa', 250);

-- Insert Compilations
INSERT INTO Compilations (Title, ReleaseDate, Genre) VALUES
('Greatest Hits', '2021-01-01', 'Mixed');

-- CompilationTracks - linking CompilationID 1 with TrackIDs 1 and 2
INSERT INTO CompilationTracks (CompilationID, TrackID) VALUES
(1, 1),
(1, 2);

-- Insert Sales, assuming UserID 1 buys AlbumID 1 and TrackID 1
INSERT INTO Sales (UserID, AlbumID, TrackID, Quantity, SalePrice) VALUES
(1, 1, NULL, 1, 15.99), -- Album sale
(1, NULL, 1, 1, 1.29); -- Track sale


SELECT * from Sales s

SELECT * from music.Compilations;