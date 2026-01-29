<%@ page import="java.sql.*" %>
<%!
    // Database connection variables
    Connection conn = null;
    
    // Oracle 11g XE Connection Method
    public Connection getConnection() {
        try {
            // Load Oracle JDBC Driver
            Class.forName("oracle.jdbc.driver.OracleDriver");
            
            // Oracle 11g XE Connection String
            // Default: localhost, Port: 1521, SID: xe
            String url = "jdbc:oracle:thin:@localhost:1521:xe";
            String username = "system";  // Change if needed
            String password = "sohan1";  // Change to your Oracle password
            
            conn = DriverManager.getConnection(url, username, password);
            
            return conn;
            
        } catch(ClassNotFoundException e) {
            System.out.println("Oracle Driver not found: " + e.getMessage());
            return null;
        } catch(SQLException e) {
            System.out.println("Database connection error: " + e.getMessage());
            return null;
        }
    }
    
    // Close connection method
    public void closeConnection(Connection conn) {
        try {
            if(conn != null && !conn.isClosed()) {
                conn.close();
            }
        } catch(SQLException e) {
            System.out.println("Error closing connection: " + e.getMessage());
        }
    }
%>