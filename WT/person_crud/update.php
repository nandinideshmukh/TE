<?php
include 'db.php';

$id = $_POST['id'];
$age = $_POST['age'];
$dob = $_POST['dob'];
$city = $_POST['city'];

$sql = "UPDATE person 
        SET age='$age', dob='$dob', city='$city' 
        WHERE id='$id'";

if($conn->query($sql) === TRUE){
    echo "Record updated successfully";
}else{
    echo "Error: " . $conn->error;
}

echo "<br><br>";
echo "<a href='view.php'>Back to Records</a>";
?>