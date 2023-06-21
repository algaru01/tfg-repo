package com.example.demo.product;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpStatusCode;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.reactive.function.client.WebClient;
import reactor.core.publisher.Mono;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping(path = "api/v1/product")
public class ProductController {
    private static final String AUTHORIZATION_HEADER = "Authorization";
    private final ProductService productService;
    @Value("${app.auth.url}")
    private String auth_url;

    private boolean isTokenValid(String token) {
        WebClient authClient = WebClient.create(auth_url);
        authClient
                .get()
                .uri("/api/v1/auth/checkToken").header(AUTHORIZATION_HEADER, token)
                .retrieve()
                .onRawStatus(status -> status == 403, response -> Mono.error(new RuntimeException("Error in authentication")))
                .onStatus(HttpStatusCode::is5xxServerError, error ->  Mono.error(new RuntimeException("Authentication service is not responding.")))
                .bodyToMono(String.class)
                .block();

        return true;
    }

    @Autowired
    public ProductController(ProductService productService) {
        this.productService = productService;
    }

    @GetMapping("/")
    public List<Product> getProducts(@RequestHeader Map<String, String> headers) {
        System.out.println(auth_url);
        isTokenValid(headers.get("authorization"));

        return productService.getProducts();
    }

    @PostMapping("/")
    public void registerNewProduct(@RequestHeader Map<String, String> headers, @RequestBody Product product) {
        isTokenValid(headers.get("authorization"));

        productService.addNewProduct(product);
    }

    @DeleteMapping(path = "{productId}")
    public void deleteProduct(@RequestHeader Map<String, String> headers, @PathVariable("productId") Long productId) {
        isTokenValid(headers.get("authorization"));

        productService.deleteProduct(productId);
    }

    @PutMapping(path = "{productId}")
    public void updateProduct(@RequestHeader Map<String, String> headers,
                              @PathVariable("productId") Long productId,
                              @RequestParam(required = false) String name,
                              @RequestParam(required = false) Double price,
                              @RequestParam(required = false) String brand) {
        isTokenValid(headers.get("authorization"));

        productService.updateProduct(productId, name, price, brand);
    }

    @GetMapping("/hello")
    public String hello (@RequestHeader Map<String, String> headers) {
        return "Hola Mundo!";
    }
}
