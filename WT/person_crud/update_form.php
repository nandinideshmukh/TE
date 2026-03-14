<?php
include 'db.php';

$id = $_GET['id'];

$result = $conn->query("SELECT * FROM person WHERE id='$id'");
$row = $result->fetch_assoc();
?>

<h2>Update Record</h2>

<form action="update.php" method="post">

ID:
<input type="text" name="id" value="<?php echo $row['id']; ?>" readonly><br><br>

Age:
<input type="number" name="age" value="<?php echo $row['age']; ?>"><br><br>

DOB:
<input type="date" name="dob" value="<?php echo $row['dob']; ?>"><br><br>

City:
<input type="text" name="city" value="<?php echo $row['city']; ?>"><br><br>

<input type="submit" value="Update">

</form>