<?php
include 'db.php';

$result=$conn->query("SELECT * FROM person");

echo "<h2>Person Records</h2>";
echo "<table border='1'>
<tr>
<th>ID</th>
<th>Age</th>
<th>DOB</th>
<th>City</th>
<th>Update</th>
<th>Delete</th>
</tr>";

while($row=$result->fetch_assoc()){
echo "<tr>";
echo "<td>".$row['id']."</td>";
echo "<td>".$row['age']."</td>";
echo "<td>".$row['dob']."</td>";
echo "<td>".$row['city']."</td>";

echo "<td><a href='update_form.php?id=".$row['id']."'>Update</a></td>";
echo "<td><a href='delete.php?id=".$row['id']."'>Delete</a></td>";

echo "</tr>";
}

echo "</table>";
echo "<br>";
echo "<a href='insert.php' style='color:green'>Insert Records</a>";
?>