package home;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;

import BD.MySQLDatabase;


@WebServlet("/addItem")
public class AddItem extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
       

    public AddItem() {
        super();
    }


	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.getRequestDispatcher("/toDoJsp/home.jsp").forward(request, response);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    String description = request.getParameter("description");
	    String status = "incompleted"; 
	    String date = request.getParameter("date");
	    boolean reminder = false;
	    
	    
	    HttpSession session = request.getSession();
	    int userId = (int) session.getAttribute("userId");

      //  System.out.println(userId);
      //  System.out.println("Descp "+description+" status "+status+" idUser "+userId);


	        Connection connection ;
	        PreparedStatement preparedStatement;

	        try {
	            connection = MySQLDatabase.getConnection();
	            String query = "INSERT INTO items (description, status, date, reminder, id_user) VALUES (?, ?, ?, ?, ?)";
	            preparedStatement = connection.prepareStatement(query);
	            preparedStatement.setString(1, description);
	            preparedStatement.setString(2, status); 
	            preparedStatement.setString(3, date);
	            preparedStatement.setBoolean(4, reminder);
	            preparedStatement.setInt(5, userId);

	            int rowsInserted = preparedStatement.executeUpdate();

	            if (rowsInserted > 0) {
	            	response.sendRedirect("/ToDoApp/AddItem");
	                System.out.println("Item inserted successfully.");
	            } else {
	            	response.sendRedirect("login");
	            }
	        } catch (SQLException e) {
	            e.printStackTrace();
	           } 
	 
	        
	}

	

}