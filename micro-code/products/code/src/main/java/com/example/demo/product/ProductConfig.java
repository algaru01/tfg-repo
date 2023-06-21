package com.example.demo.product;

import org.springframework.boot.CommandLineRunner;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import java.time.LocalDate;
import java.time.Month;
import java.util.List;

@Configuration
public class ProductConfig {

    @Bean
    CommandLineRunner commandLineRunner(ProductRepository repository) {
        return args -> {
            Product macarrones = new Product(
                    "Macarrones",
                    2.59,
                    "Gallo"
            );

            Product tomate = new Product(
                    "Tomate",
                    1.99,
                    "Solis"
            );

            repository.saveAll(
                    List.of(macarrones, tomate)
            );
        };
    }
}
