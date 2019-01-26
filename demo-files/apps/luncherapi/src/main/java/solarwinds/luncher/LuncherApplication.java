package solarwinds.luncher;

import org.postgresql.ds.PGSimpleDataSource;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.transaction.annotation.EnableTransactionManagement;

import javax.sql.DataSource;

@Configuration
@EnableTransactionManagement
@SpringBootApplication()
public class LuncherApplication {

	public static void main(String[] args) {
		SpringApplication.run(LuncherApplication.class, args);
	}

	@Bean
	public DataSource postgresql() {
		PGSimpleDataSource ds = new PGSimpleDataSource();
		ds.setServerName(System.getenv("RDS_HOST"));
		ds.setUser(System.getenv("RDS_USER"));
		ds.setDatabaseName(System.getenv("RDS_DB"));
		ds.setPassword(System.getenv("RDS_PASS"));
		return ds;
	}

}
