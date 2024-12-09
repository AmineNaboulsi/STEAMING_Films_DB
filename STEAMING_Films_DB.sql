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
    FOREIGN KEY (MovieID) REFERENCES movie(MovieID)
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
-- Insérer un film
INSERT INTO movie 
(title , Genre )
 VALUE ('Data Science Adventures' , 'Documentary')
--Rechercher des films 
SELECT * FROM movie 
WHERE LOWER(movie.Genre) = 'comedy' and movie.ReleaseYear > 2020
-- Mise à jour des abonnements 
UPDATE user 
SET 
user.subscription = (select SubscriptionID from subscription where LOWER(SubscriptionType) = 'premium' LIMIT 1)
where user.Subscription =  (select SubscriptionID from subscription where LOWER(SubscriptionType) = 'basic' LIMIT 1)
-- Filtrer les visionnages
SELECT user.UserID , CONCAT(user.FirstName , user.LastName) as 'KHONA FLGHRONA' FROM watchhistory 
JOIN user on user.UserID = watchhistory.UserID 
WHERE watchhistory.CompletionPercentage = 100;
-- Trier et limiter 
select * from movie ORDER BY movie.Duration LIMIT 5;
-- Agrégation 
SELECT watchhistory.MovieID , movie.title , CONCAT(AVG(CompletionPercentage),'%') as 'Complétion ' FROM watchhistory 
join movie on movie.MovieID = watchhistory.MovieID
GROUP BY watchhistory.MovieID , CompletionPercentage 