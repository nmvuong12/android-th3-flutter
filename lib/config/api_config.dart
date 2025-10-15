class ApiConfig {
  // Cấu hình URL API
  // Đối với Android Emulator, sử dụng 10.0.2.2 để kết nối tới localhost của máy host
  // Đối với thiết bị thật, thay thế bằng IP của máy tính chạy Spring Boot
  static const String baseUrl = 'http://10.0.2.2:8080/api/products';
  
  // Headers cho API calls
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Timeout cho HTTP requests (milliseconds)
  static const int timeoutDuration = 30000;
  
  // Các endpoints
  static const String productsEndpoint = '/products';
  static const String searchEndpoint = '/products/search';
  static const String priceRangeEndpoint = '/products/price-range';
  
  // Helper method để build full URL
  static String buildUrl(String endpoint) {
    return '$baseUrl$endpoint';
  }
  
  // Helper method để build search URL
  static String buildSearchUrl(String name) {
    return '$baseUrl/search?name=$name';
  }
  
  // Helper method để build price range URL
  static String buildPriceRangeUrl(double minPrice, double maxPrice) {
    return '$baseUrl/price-range?minPrice=$minPrice&maxPrice=$maxPrice';
  }
}
