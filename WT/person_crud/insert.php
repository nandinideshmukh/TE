<?php
include 'db.php';

if($_SERVER["REQUEST_METHOD"] == "POST"){

$id = $_POST['id'];
$age = $_POST['age'];
$dob = $_POST['dob'];
$city = $_POST['city'];

$sql = "INSERT INTO person VALUES ('$id','$age','$dob','$city')";

if(mysqli_query($conn,$sql)){
    echo "Record inserted successfully";
}else{
    echo "Error: " . mysqli_error($conn);
}

}
?>

<h2>Insert Person Record</h2>

<form method="post">

ID:<br>
<input type="number" name="id"><br><br>

Age:<br>
<input type="number" name="age"><br><br>

DOB:<br>
<input type="date" name="dob"><br><br>

City:<br>
<input type="text" name="city"><br><br>

<input type="submit" value="Insert">

</form>

<br><br>
<a href="view.php">View Records</a>