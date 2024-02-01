<%@ page language="java" %>
<%@ page import="java.sql.*"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
   
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Poppins&display=swap" rel="stylesheet">

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.3/css/all.min.css" integrity="sha512-iBBXm8fW90+nuLcSKlbmrPcLa0OT92xO1BIsZ+ywDWZCvqsWgccV3gFoRBv0z+8dLJgyAHIhR35VZc2oM/gI1w==" crossorigin="anonymous" referrerpolicy="no-referrer" />
    
    <title>To Do List</title>
    
    <style type="text/css">
   * {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    background-color: mediumslateblue;
    color: white;
    font-family: "Poppins", sans-serif;
    
}

header {
    font-size: 1.5rem;
}

header, 
form {
    min-height: 20vh;
    display: flex;
    justify-content: center;
    align-items: center;
}

form input, 
form button {
    padding: 0.5rem;
    padding-left: 1rem;
    font-size: 1.8rem;
    border: none;
    background: white;
    border-radius: 2rem;
}

form button {
    color: rgb(255, 200, 0);
    background: white;
    cursor: pointer;
    transition: all 0.3 ease;
    margin-left: 0.5rem;
}

form button:hover {
    color: white;
    background: rgb(255, 200, 0);
}

.fa-plus-circle {
    margin-top: 0.3rem;
    margin-left: -8px;
}

.todo-container {
    display: flex;
    justify-content: center;
    align-items: center;
}

.todo-list {
    min-width: 50%;
    list-style: none;
}

.todo {
    margin: 0.5rem;
    padding-left: 0.5rem;
    background: white;
    color: black;
    font-size: 1.5rem;
    display: flex;
    
    align-items: center;
    transition: 0.5s;
    border-radius: 1rem;
}

.todo li {
    flex: 1;
}
.todo a {
    color: black;
    border: none;
    padding: 1rem;
    cursor: pointer;
    font-size: 1.5rem;
}
.trash-btn, 
.complete-btn {
    color: white;
    border: none;
    padding: 1rem;
    cursor: pointer;
    font-size: 1.5rem;
}

.complete-btn {
    background: rgb(255, 200, 0);
}

.trash-btn {
    border-top-right-radius: 1.75rem;
    border-bottom-right-radius: 1.75rem;
    background: rgb(171, 171, 171);
}

.todo-item {
    padding: 0rem 0.5rem;
}

.fa-trash, 
.fa-check-circle {
    pointer-events: none;
}

.completed {
    text-decoration: line-through;
    opacity: 0.5;
}

.slide {
    transform: translateX(10rem);
    opacity: 0;
}

select {
    -webkit-appearance: none;
    -moz-appearance: none;
    appearance: none;
    outline: none;
    border: none;
}

.select {
    margin: 1rem;
    position: relative;
    overflow: hidden;
    border-radius: 50px;
}

select {
    color:rgb(255, 200, 0);
    width: 10rem;
    height: 3.2rem;
    cursor: pointer;
    padding: 1rem;
}

.select::after {
    content: "\25BC";
    position: absolute;
    background:rgb(255, 200, 0);
    top: 0;
    right: 0;
    padding: 1rem;
    pointer-events: none;
    transition: all 0.3s ease;
}

.select::hover::after {
    background: white;
    color: rgb(255, 200, 0);
}

.right-buttons {
    display: flex;
    flex-direction: row; 
    align-items: center; 
    margin-left: auto;
}

.right-buttons a,
.right-buttons button {
    margin-left: 10px;
}

h2{
margin-left: 50px;
margin-top: 15px;
}

.header-container {
    display: flex; 
    align-items: center; 
}

.logout-link {
    margin-left: auto;
    margin-right: 50px; 
    color: rgb(255, 200, 0);
    margin-top: 10px;
    font-size: 17px;
}


    </style>
</head>
<body>
<% 
        String userIdentifier = (String) session.getAttribute("userIdentifier");

       try {
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/todoapp", "root", "");
            PreparedStatement pst = con.prepareStatement("SELECT firstName, lastName FROM user WHERE email = ?");
            pst.setString(1, userIdentifier);
            ResultSet rs = pst.executeQuery();
            if (rs.next()) {
            	%> <div class="header-container">
    <h2> Welcome <span style="color:rgb(255, 200, 0);"><%= rs.getString("firstName") %> <%= rs.getString("lastName") %></span></h2>
    <a href="/ToDoApp/auth/logout" class="logout-link">Logout</a>
</div>

            	<% 
            }
            rs.close();
            pst.close();
            con.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    %>
    
    
    <header>
               
                           
    
        <h1>My To Do List</h1>
        
       
    </header>
    <form action="addItem" method="post">
        <input type="text" class="todo-input" name="description">
        
        <div class="select">
    <!-- <label for="datePicker">Sélectionnez une date :</label> -->
    <input type="date" id="datePicker" name="date" class="filter-date">


        </div>

       <button class="todo-button" type="submit">
            <i class="fas fa-plus-circle fa-lg"></i>
        </button>
        
    </form>
    
    
 <% 
   String successParam = request.getParameter("success");
   String errorParam = request.getParameter("error");

   if (successParam != null && successParam.equals("1")) {
       out.println("<center><p id='successMessage' style='color: green; background-color: rgb(255, 200, 0); width: 30%; text-align: center; border-radius: 0.8rem; '>The item has been deleted successfully</p></center>");
   } else if (errorParam != null && errorParam.equals("1")) {
       out.println("<center><p style='color: red;'>The item has not been deleted</p></center>");
   }
   
   if (successParam != null && successParam.equals("2")) {
       out.println("<center><p id='successMessage' style='color: green; background-color: rgb(255, 200, 0); width: 30%; text-align: center; border-radius: 0.8rem;'>The item has been updated successfully</p></center>");
   } else if (errorParam != null && errorParam.equals("2")) {
       out.println("<center><p style='color: red;'>The item has not been updated</p></center>");
   }
   
%>

<div class="todo-container">
    <ul class="todo-list">
        <%
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/todoapp", "root", "");
                
                int userId = (int) session.getAttribute("userId");
                
                PreparedStatement pst = con.prepareStatement("SELECT id, description, status FROM items WHERE id_user = ?");
                pst.setInt(1, userId);
                
                ResultSet rs = pst.executeQuery();
                
                while (rs.next()) {
        %>
        
        <li class="todo">
    <span class="todo-item" id="editable<%= rs.getString(1) %>" contenteditable="false"><%= rs.getString("description") %></span>
    <div class="right-buttons">
        <a href="deleteItem?id=<%= rs.getString(1) %>"><i class="fas fa-trash"></i></a>
        <button class="complete-btn" name="completeButton" value="<%= rs.getString(1) %>">
         <i class="fas fa-check-circle"></i>
        </button>
        <a href="#" onclick="enableEdit('<%= rs.getString(1) %>')">Edit</a>
        <a href="#" style="display: none;" id="saveLink<%= rs.getString(1) %>" onclick="saveEdit('<%= rs.getString(1) %>')">Save</a>
    </div>
</li>


        
        <%
                }
                rs.close();
                pst.close();
                con.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>
    </ul>
</div>


<script>

    function hideSuccessMessage() {
        var successMessage = document.getElementById('successMessage');
        if (successMessage) {
            successMessage.style.display = 'none';
        }
    }

    setTimeout(hideSuccessMessage, 2000); 
    
    function enableEdit(itemId) {
        const editableSpans = document.querySelectorAll('[contenteditable="true"]');
        editableSpans.forEach(span => span.setAttribute('contenteditable', 'false'));

        const editableSpan = document.getElementById('editable' + itemId);
        editableSpan.setAttribute('contenteditable', 'true');

        document.getElementById('saveLink' + itemId).style.display = 'inline';
    }



    function saveEdit(itemId) {
        const editableSpan = document.getElementById('editable' + itemId);
        const editedText = editableSpan.innerText;

        const xhr = new XMLHttpRequest();
        xhr.open('POST', 'editItem', true);
        xhr.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                
                if (xhr.responseText === 'success') {
                    alert('Edit saved successfully');
                } else {
                    alert('Edit failed');
                }
            }
        };
        xhr.send('itemId=' + itemId + '&description=' + editedText);


        editableSpan.setAttribute('contenteditable', 'false');
        
        const editLink = document.querySelector('a[href*="enableEdit(' + itemId + '"]');
        const saveLink = document.querySelector('a[href*="saveEdit(' + itemId + '"]');
        
        if (editLink) {
            editLink.style.display = 'inline';
        }

        if (saveLink) {
            saveLink.style.display = 'none';
        }
    }

    
    
    
</script>


</body>
</html>