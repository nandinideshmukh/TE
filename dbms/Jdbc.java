package TE.dbms;

import java.sql.*;
import java.io.*;

public class Jdbc {

    public static void main(String[] args) {

        try {

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/db",
                    "root",
                    "spotify@123");

            System.out.println("Database Connected Successfully!");

            BufferedReader br = new BufferedReader(new InputStreamReader(System.in));

            while (true) {

                try {

                    System.out.println("\n1. Add Student");
                    System.out.println("2. Delete Student");
                    System.out.println("3. Update CGPA");
                    System.out.println("4. Display Students");
                    System.out.println("5. Exit");

                    System.out.print("Enter choice: ");
                    int ch = Integer.parseInt(br.readLine());

                    switch (ch) {

                        case 1:

                            System.out.print("Enter SID: ");
                            int sid = Integer.parseInt(br.readLine());

                            System.out.print("Enter DID: ");
                            int did = Integer.parseInt(br.readLine());

                            System.out.print("Enter TRID: ");
                            int trid = Integer.parseInt(br.readLine());

                            System.out.print("Enter CGPA: ");
                            float cgpa = Float.parseFloat(br.readLine());

                            System.out.print("Enter Branch: ");
                            String branch = br.readLine();

                            System.out.print("Enter DOB (yyyy-mm-dd): ");
                            String dob = br.readLine();

                            System.out.print("Enter Name: ");
                            String name = br.readLine();

                            PreparedStatement ps = con.prepareStatement(
                                    "insert into stud values(?,?,?,?,?,?,?)");

                            ps.setInt(1, sid);
                            ps.setInt(2, did);
                            ps.setInt(3, trid);
                            ps.setFloat(4, cgpa);
                            ps.setString(5, branch);
                            ps.setString(6, dob);
                            ps.setString(7, name);

                            ps.executeUpdate();
                            System.out.println("Student Added!");
                            break;

                        case 2:

                            System.out.print("Enter SID to delete: ");
                            int dsid = Integer.parseInt(br.readLine());

                            PreparedStatement ps2 = con.prepareStatement(
                                    "delete from stud where sid=?");

                            ps2.setInt(1, dsid);

                            ps2.executeUpdate();
                            System.out.println("Student Deleted!");
                            break;

                        case 3:

                            System.out.print("Enter SID to update: ");
                            int usid = Integer.parseInt(br.readLine());

                            System.out.print("Enter new CGPA: ");
                            float newcgpa = Float.parseFloat(br.readLine());

                            PreparedStatement ps3 = con.prepareStatement(
                                    "update stud set cgpa=? where sid=?");

                            ps3.setFloat(1, newcgpa);
                            ps3.setInt(2, usid);

                            ps3.executeUpdate();
                            System.out.println("CGPA Updated!");
                            break;

                        case 4:

                            Statement st = con.createStatement();
                            ResultSet rs = st.executeQuery("select * from stud");

                            while (rs.next()) {

                                System.out.println(
                                        rs.getInt(1) + " " +
                                        rs.getInt(2) + " " +
                                        rs.getInt(3) + " " +
                                        rs.getFloat(4) + " " +
                                        rs.getString(5) + " " +
                                        rs.getDate(6) + " " +
                                        rs.getString(7));
                            }

                            break;

                        case 5:
                            System.exit(0);

                        default:
                            System.out.println("Invalid choice! Try again.");
                    }

                } catch (Exception e) {
                    System.out.println("Database error: "+ e);
                }
            }

        } catch (Exception e) {
            System.out.println("Database connection error: " + e);
        }
    }
}