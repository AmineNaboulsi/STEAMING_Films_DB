<?php
require 'vendor/autoload.php';

use Faker\Factory;
use Dotenv\Dotenv;

// Load environment variables
$dotenv = Dotenv::createImmutable(__DIR__);
$dotenv->load();

// Database connection using env variables
$conn = new mysqli(
    $_ENV['DB_HOST'], 
    $_ENV['DB_USERNAME'], 
    $_ENV['DB_PASSWORD'], 
    $_ENV['DB_NAME']
);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Create Faker instance
$faker = Factory::create();

// Generate fake users
function insertUsers($conn, $faker, $count = 50) {
    $stmt = $conn->prepare("INSERT INTO 
    user (FirstName, LastName, Email, RegistrationDate, Subscription) 
    VALUES (?, ?, ?, ?, ?)");
    
    for ($i = 0; $i < $count; $i++) {
        $FirstName = $faker->firstName;
        $LastName = $faker->lastName;
        $Email = $faker->unique()->email;
        $RegistrationDate = $faker->dateTimeBetween('-1 year', 'now')->format('Y-m-d H:i:s');
        $Subscription = $faker->randomElement([1, 2]);
        
        $stmt->bind_param("ssssi", $FirstName, $LastName, $Email, $RegistrationDate, $Subscription);
        $stmt->execute();
    }
    $stmt->close();
}
function insertMovies($conn, $faker, $count = 100) {
    $stmt = $conn->prepare("INSERT INTO
    movie (title, Genre, ReleaseYear, Duration, Rating)
    VALUES (?, ?, ?, ?, ?)");

    for ($i = 0; $i < $count; $i++) {
        $title = $faker->sentence(3); // Use sentence or movieTitle
        $Genre = $faker->randomElement(
            ['Action', 'Drama', 'Comedy', 'Sci-Fi', 'Horror', 'Romance', 'Thriller', 'Documentary']
        );
        $Rating = $faker->randomElement(
            ['G', 'PG', 'PG-13', 'R', 'NC-17']
        );

        $ReleaseYear = $faker->numberBetween(1990, 2024);
        $Duration = $faker->numberBetween(60, 240); // Duration in minutes
        
        $stmt->bind_param("ssssi", $title, $Genre, $ReleaseYear, $Duration, $Rating);
        $stmt->execute();
    }
    $stmt->close();
}

function getAllUsers($conn){
    $sql = "SELECT UserID FROM user";

    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $data = array();
        while ($row = $result->fetch_assoc()) {
            $data[] = (int)$row['UserID'];
        }
        return $data;
    } else {
        return [];
    }
}

function getAllMovies($conn){
    $sql = "SELECT MovieID FROM movie";

    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $data = array();
        while ($row = $result->fetch_assoc()) {
            $data[] = (int)$row['MovieID'];
        }
        return $data;
    } else {
        return [];
    }
}

function insertwatchhistory($conn, $faker, $count = 50) {
    $stmt = $conn->prepare("INSERT INTO 
    watchhistory (UserID, MovieID, WatchDate, CompletionPercentage)
    VALUES (?, ?, ?, ?)");
	
    $users = getAllUsers($conn);
    $movies = getAllMovies($conn);

    for ($i = 0; $i < $count; $i++) {
        $UserID = $faker->randomElement($users);
        $MovieID = $faker->randomElement($movies);
        $WatchDate = $faker->dateTimeBetween('-1 year', 'now')->format('Y-m-d H:i:s');
        $CompletionPercentage = $faker->numberBetween(0, 100);
        
        $stmt->bind_param("iiss", $UserID, $MovieID, $WatchDate, $CompletionPercentage);
        $stmt->execute();
    }
    $stmt->close();
}
//insertUsers($conn, $faker);
//insertMovies($conn, $faker);
// getAllUsers($conn);
insertwatchhistory($conn, $faker);
echo "Fake data generated successfully!";

$conn->close();
?>