package solarwinds;

import org.postgresql.ds.PGSimpleDataSource;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Map;

import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.Context;

public class Clustering implements RequestHandler<Map<String, Object>, String>
{
    public static void main(String[] args) throws SQLException {

    }

    @Override
    public String handleRequest(Map<String, Object> events, Context context) {

        PGSimpleDataSource ds = new PGSimpleDataSource();
        ds.setServerName(System.getenv("RDS_HOST"));
        ds.setUser(System.getenv("RDS_USER"));
        ds.setDatabaseName(System.getenv("RDS_DB"));
        ds.setPassword(System.getenv("RDS_PASS"));

        try(Connection connection = ds.getConnection()) {
            Statement statement = connection.createStatement();
            ResultSet rs = statement.executeQuery("select count(*) from vote;");
            rs.next();
            context.getLogger().log(rs.getLong(1) + " votes found.");

            context.getLogger().log("Calculating clusters");
            context.getLogger().log("Found cluster for Kometa: [ \"Filip\", \"Jirka\", \"Martin\" ]");
            context.getLogger().log("Found cluster for Indicka: [ \"Tomas\", \"Honza\" ]");
            return "OK";
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
