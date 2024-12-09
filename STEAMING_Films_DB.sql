-- name : NABOULSI AMINE
-- email : naboulsiiamine@gmail.com

-- Database creation
CREATE DATABASE STEAMING_Films_DB ;


-- Use Database created
USE STEAMING_Films_DB ;

-- Create subscription table
CREATE TABLE subscription
(
	SubscriptionID INT PRIMARY KEY AUTO_INCREMENT ,
	SubscriptionType varchar(50) NOT NULL,
	MonthlyFee decimal(10,2) NOT NULL
);
-- trying to add contraint after definition
ALTER TABLE subscription ADD CONSTRAINT CHECK (
    LOWER(SubscriptionType) = 'basic' or 
    LOWER(SubscriptionType) = 'premium'
)

-- Create user table
CREATE TABLE user
(
	UserID INT PRIMARY KEY AUTO_INCREMENT ,
	FirstName varchar(100) NOT NULL,
	LastName varchar(100) NOT NULL,
	Email varchar(100) NOT NULL Unique ,
    RegistrationDate Date NOT NULL,
    Subscription INT NOT NULL ,
    FOREIGN KEY (Subscription) REFERENCES subscription(SubscriptionID)
);
-- Create movie table 
CREATE TABLE movie
(
	MovieID INT PRIMARY KEY AUTO_INCREMENT ,
	title varchar(255) NOT NULL,
	Genre varchar(100) NOT NULL,
	ReleaseYear INT NOT NULL,
    Duration INT NOT NULL ,
    Rating varchar(10) NOT NULL,
    check(ReleaseYear>1000 and ReleaseYear<9999)
);
-- Create watchhistory table 
CREATE TABLE watchhistory
(
	WatchHistoryID INT PRIMARY KEY AUTO_INCREMENT ,
	UserID varchar(255) NOT NULL,
	MovieID INT NOT NULL,
	WatchDate Date NOT NULL ,
    CompletionPercentage INT NOT NULL DEFAULT  0,
    check(ReleaseYear>1000 and ReleaseYear<9999),
    FOREIGN KEY (WatchDate) REFERENCES movie(MovieID)
);
-- Create review table 
CREATE TABLE review
(
	ReviewID INT PRIMARY KEY AUTO_INCREMENT ,
	UserID INT NOT NULL,
	MovieID INT NOT NULL,
	RATING INT  NOT NULL,
    ReviewText TEXT NULL,
    ReviewDate DATE NOT NULL,
    FOREIGN KEY (UserID) REFERENCES user(UserID),
    FOREIGN KEY (MovieID) REFERENCES movie(MovieID)
);

