<?php
include 'db.php';

$id=$_GET['id'];

$conn->query("DELETE FROM person WHERE id=$id");

header("Location:view.php");
?>