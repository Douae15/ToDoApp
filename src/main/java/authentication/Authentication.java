package authentication;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import BD.MySQLDatabase;

@WebServlet("/auth/*")
public class Authentication extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public Authentication() {
        super();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String requestURI = request.getRequestURI();
	    
		if (requestURI.endsWith("/signup")) {
	        request.getRequestDispatcher("/toDoJsp/register.jsp").forward(request, response);
	    }
		
	     else {
	        request.getRequestDispatcher("/toDoJsp/login.jsp").forward(request, response);
	    }
	   
	}
    
	
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		String action = request.getParameter("action");
		if ("login".equals(action)) {
			String email = request.getParameter("email");
	        String password = request.getParameter("pwd");
        	HttpSession session=request.getSession();

	        
	        if (isValidUser(email, password,session)) {
	        	request.getSession().setAttribute("userIdentifier", email);
	        	
	        	response.sendRedirect("/ToDoApp/AddItem");
	        	

	        } else {
	            response.sendRedirect("login?error=1");
	        }
	        
		} else if ("signup".equals(action)) {
			String firstName = request.getParameter("firstName");
			String lastName = request.getParameter("lastName");
			String email = request.getParameter("email");
			String pwd = request.getParameter("pwd");

			Connection connection;

			try {
		        connection = MySQLDatabase.getConnection();

		       
		        String insertQuery = "INSERT INTO user (firstName, lastName, email, pwd) VALUES (?, ?, ?, ?)";
		        PreparedStatement preparedStatement = connection.prepareStatement(insertQuery);
		        preparedStatement.setString(1, firstName);
		        preparedStatement.setString(2, lastName);
		        preparedStatement.setString(3, email);
		        preparedStatement.setString(4, pwd);
		        int rowsInserted = preparedStatement.executeUpdate();
		        
		        if (rowsInserted > 0) {
		            response.sendRedirect("login");
		        } else {
		            response.sendRedirect("register");
		        }

		    } catch (SQLException e) {
		        e.printStackTrace();		    
		    }
		}
	}
	
	private boolean isValidUser(String email, String password,HttpSession session) {
	    Connection connection;
	    PreparedStatement preparedStatement;
	    ResultSet resultSet;

	    try {
	        connection = MySQLDatabase.getConnection();

	        String query = "SELECT * FROM user WHERE email = ? AND pwd = ?";
	        preparedStatement = connection.prepareStatement(query);
	        preparedStatement.setString(1, email);
	        preparedStatement.setString(2, password);

	        resultSet = preparedStatement.executeQuery();
	        if(resultSet.next())
	        {
	        	session.setAttribute("userId", resultSet.getInt("id"));
	        	 return true;
	        }
	        
	        
	        return false;
	    } catch (SQLException e) {
	        e.printStackTrace();
	        return false;
	    } 
	       
	        
	    
	}
}