package com.example.demo.product;


import jakarta.transaction.Transactional;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Objects;
import java.util.Optional;

@Service
public class ProductService {

    private final ProductRepository productRepository;

    public ProductService(ProductRepository productRepository) {
        this.productRepository = productRepository;
    }

    public List<Product> getProducts() {
        return productRepository.findAll();
    }

    public void addNewProduct(Product product) {
        Optional<Product> productOptional = productRepository.findProductByName(product.getName());
        if (productOptional.isPresent())
            throw new IllegalStateException("name taken");
        else
            productRepository.save(product);
        System.out.println(product);
    }

    public void deleteProduct(Long productId) {
        boolean exists = productRepository.existsById(productId);
        if (!exists) {
            throw new IllegalStateException("product with id " + productId + " does not exists.");
        }
        productRepository.deleteById(productId);
    }

    @Transactional
    public void updateProduct(Long productId, String name, Double price, String brand) {
        Product product = productRepository.findById(productId)
                .orElseThrow(() -> new IllegalStateException(
                        "product with id " + productId + " does not exists."));

        if (name != null && name.length() > 0 &&
                !Objects.equals(product.getName(), name)) {
            Optional<Product> productOptional = productRepository.findProductByName(name);
            if (productOptional.isPresent())
                throw new IllegalStateException("name taken");
            else
                product.setName(name);
        }

        if (price != null && price > 0.00 &&
                !Objects.equals(product.getPrice(), price)) {
            product.setPrice(price);
        }

        if (brand != null && brand.length() > 0 &&
                !Objects.equals(product.getBrand(), brand)) {
            product.setBrand(brand);
        }
    }
}
