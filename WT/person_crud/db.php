<?php
$conn = mysqli_connect('localhost', 'root', 'spotify@123',"wt");
if (!$conn) {
    die('Could not connect: ' . mysqli_connect_error());
}
echo 'Database Connected successfully';
?>