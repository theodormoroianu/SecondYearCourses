package com.jdbc;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class jdbc {
    private static String user = "remember";
    private static String password = "remember";
    private static String url = "jdbc:mysql://localhost:3306/db_remember";
    
    public void InitializeTables() {
        try (Connection connection = DriverManager.getConnection(url, user, password);
                    Statement statement = connection.createStatement()) {
                
                String query = "CREATE TABLE IF NOT EXISTS my_table ( "
                                    + "     name VARCHAR(100),"
                                    + "     content VARCHAR(300)"
                                    + " )";
                statement.executeUpdate(query);
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }


    public void ReadAllFromMemory() {
        try (Connection connection = DriverManager.getConnection(url, user, password);
                Statement statement = connection.createStatement()) {
            
            String query = "SELECT content FROM my_table";
            ResultSet results = statement.executeQuery(query);
            List<String> db_content = new ArrayList<>();

            // iterate through all the lines of the table.
            while (results.next()) {
                // retreive the content, and parse it as a csv.
                String content = results.getString(1); // Starts at 1
                db_content.add(content);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void PreparaStatment() {
        try (Connection connection = DriverManager.getConnection(url, user, password);
                Statement statement = connection.createStatement()) {
            String sql = "UPDATE persoane SET nume=? WHERE cod=?";
            PreparedStatement pstmt = connection.prepareStatement(sql);
            pstmt.setString(1, "Ionescu");
            pstmt.setInt(2, 45);
            pstmt.executeUpdate();
        }
        catch (Exception e) {
            e.printStackTrace();
        }
    }
}
