import java.io.*;
import javax.servlet.*;
import java.sql.*;
import javax.servlet.http.*;

public class HelloServlet extends HttpServlet {

    public void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        try {

            Connection con = DriverManager.getConnection(
                    "jdbc:mysql://localhost:3306/wt",
                    "root",
                    "spotify@123");

            Statement stmt = con.createStatement();
            ResultSet rs = stmt.executeQuery("select * from ebookshop");

            out.println("<html><body>");
            out.println("<h1>EbookShop Details</h1>");
            out.println("</body></html>");

            out.println("<table border='1'>");
            out.println("<tr>");
            out.println("<th>ID</th>");
            out.println("<th>Title</th>");
            out.println("<th>Author</th>");
            out.println("<th>Price</th>");
            out.println("<th>Quantity</th>");
            out.println("</tr>");

            while (rs.next()) {
                out.println("<tr>");
                out.println("<td>" + rs.getInt("id") + "</td>");
                out.println("<td>" + rs.getString("title") + "</td>");
                out.println("<td>" + rs.getString("author") + "</td>");
                out.println("<td>" + rs.getFloat("price") + "</td>");
                out.println("<td>" + rs.getFloat("quantity") + "</td>");
                out.println("</tr>");

            }
            out.println("</table>");
            out.println("</body></html>");

            con.close();

        } catch (Exception e) {
            out.println("<h3>Error Details:</h3>");
            out.println("Message: " + e.getMessage() + "<br>");
            out.println("Type: " + e.getClass().getName() + "<br>");
            e.printStackTrace(out); 
        }
    }
}
