package home;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import BD.MySQLDatabase;


@WebServlet("/editItem")
public class EditItem extends HttpServlet {
	private static final long serialVersionUID = 1L;

    public EditItem() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/todoapp", "root", "");

            String idParam = request.getParameter("id");
            if (idParam != null && !idParam.isEmpty()) {
                try {
                    int id = Integer.parseInt(idParam);

                    String sql = "SELECT * FROM items WHERE id=?";
                    try (PreparedStatement pst = con.prepareStatement(sql)) {
                        pst.setInt(1, id);
                        ResultSet rs = pst.executeQuery();

                        if (rs.next()) {
                        	String idItem = rs.getString("id");
                            String description = rs.getString("description");
                            String status = rs.getString("status");
                            

                        
                            request.setAttribute("id", idItem);
                            request.setAttribute("description", description);
                            request.setAttribute("status", status);
                           

                            
                            request.getRequestDispatcher("/toDoJsp/home.jsp").forward(request, response);
                        } 
                    }
                } catch (NumberFormatException e) {
                    e.printStackTrace(); 
                }
            } else {
            	request.getRequestDispatcher("/toDoJsp/home.jsp").forward(request, response);
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
	    String itemIdParam = request.getParameter("itemId");
	    String description = request.getParameter("description");

	    int itemId = Integer.parseInt(itemIdParam);

	    try {
	        Connection conn = MySQLDatabase.getConnection();
	        String updateQuery = "UPDATE items SET description=? WHERE id=?";
	        PreparedStatement preparedStatement = conn.prepareStatement(updateQuery);
	        preparedStatement.setString(1, description);
	        preparedStatement.setInt(2, itemId);

	        int rowsUpdated = preparedStatement.executeUpdate();

	        if (rowsUpdated > 0) {
	            response.getWriter().write("success");
	        } else {
	            response.getWriter().write("error");
	        }
	    } catch (SQLException e) {
	        e.printStackTrace();
	        response.getWriter().write("error");
	    }
	    
	   

	}


}
    


