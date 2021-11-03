package com.project.gamerent;

import java.sql.*;
        public class DBConnection {
            private String userDb = "up56hznwgltienvh";
            private String passDb = "nSGipqlWFgTNX1G5akUO";
            private String url = "jdbc:mysql://b3msp3iubtuvx4wx6jak-mysql.services.clever-cloud.com:3306/b3msp3iubtuvx4wx6jak";
            private Connection connection;
            private Statement statement;

    public DBConnection(){
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            connection = DriverManager.getConnection(url, userDb, passDb);
            statement = connection.createStatement();
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }
    }

    public ResultSet selectQuery(String query) {
        ResultSet resultSet = null;
        try {
            resultSet = statement.executeQuery(query);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
        return resultSet;
    }

    public void executeInsertDeleteQuery(String query) {
        try {
            statement.executeUpdate(query);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

    public void executeUpdateQuery(String query) {
        PreparedStatement preparedStatement = null;
        try {
            preparedStatement = connection.prepareStatement(query);
            int rowAffected = preparedStatement.executeUpdate();
            System.out.println("Rows affected " + rowAffected);
        } catch (SQLException throwables) {
            throwables.printStackTrace();
        }
    }

    public Connection getConnection() {
        return connection;
    }
}
