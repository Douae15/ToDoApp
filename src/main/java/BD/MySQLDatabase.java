package BD;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class MySQLDatabase {
    private static final String URL = "jdbc:mysql://localhost:3306/todoapp";
    private static final String UTILISATEUR = "root";
    private static final String MOT_DE_PASSE = "";
    private static Connection connexion;

    private MySQLDatabase() {}

    public static synchronized Connection getConnection() throws SQLException {
        if (connexion == null) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                connexion = DriverManager.getConnection(URL, UTILISATEUR, MOT_DE_PASSE);
            } catch (ClassNotFoundException e) {
                e.printStackTrace();
            }
        }
        return connexion;
    }
}
