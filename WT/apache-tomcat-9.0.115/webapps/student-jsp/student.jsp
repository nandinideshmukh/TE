<%@ page import="java.sql.*" %>
<html>
<head>
<title>Student Table</title>
</head>

<body>
<h2>Student Records</h2>

<table border="1">
<tr>
<th>ID</th>
<th>Name</th>
<th>Class</th>
<th>Division</th>
<th>City</th>
</tr>

<%
try{

    Class.forName("com.mysql.cj.jdbc.Driver");

    Connection con = DriverManager.getConnection(
        "jdbc:mysql://localhost:3306/wt",
        "root",
        "spotify@123"
    );

    Statement stmt = con.createStatement();
    ResultSet rs = stmt.executeQuery("SELECT * FROM stud");

    while(rs.next()){
%>

<tr>
<td><%= rs.getInt("id") %></td>
<td><%= rs.getString("name") %></td>
<td><%= rs.getString("class") %></td>
<td><%= rs.getString("divi") %></td>
<td><%= rs.getString("city") %></td>
</tr>

<%
    }

    con.close();

}catch(Exception e){
    out.println(e);
}
%>

</table>

</body>
</html>