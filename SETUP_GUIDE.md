# Hướng dẫn cài đặt và chạy ứng dụng

## Bước 1: Cài đặt Flutter

1. Tải Flutter SDK từ: https://flutter.dev/docs/get-started/install
2. Giải nén và thêm vào PATH
3. Chạy `flutter doctor` để kiểm tra cài đặt

## Bước 2: Cài đặt Android Studio

1. Tải Android Studio từ: https://developer.android.com/studio
2. Cài đặt Android SDK và Android Emulator
3. Tạo một AVD (Android Virtual Device)

## Bước 3: Khởi động Spring Boot Backend

1. Mở terminal và chuyển đến thư mục Spring Boot:
   ```bash
   cd d:\flutter\TH3\th3\th3
   ```

2. Khởi động ứng dụng:
   ```bash
   # Trên Windows
   .\mvnw.cmd spring-boot:run
   
   # Trên Linux/Mac
   ./mvnw spring-boot:run
   ```

3. Kiểm tra backend đang chạy:
   - Truy cập: http://localhost:8080/swagger-ui.html
   - Hoặc: http://localhost:8080/api/products

## Bước 4: Cài đặt Flutter App

1. Mở terminal và chuyển đến thư mục Flutter:
   ```bash
   cd D:\flutter\th3_fe
   ```

2. Cài đặt dependencies:
   ```bash
   flutter pub get
   ```

3. Kiểm tra thiết bị kết nối:
   ```bash
   flutter devices
   ```

## Bước 5: Chạy ứng dụng

### Chạy trên Android Emulator

1. Khởi động Android Emulator từ Android Studio
2. Chạy ứng dụng:
   ```bash
   flutter run
   ```

### Chạy trên thiết bị thật

1. Kết nối điện thoại qua USB và bật USB Debugging
2. Tìm IP của máy tính:
   ```bash
   ipconfig  # Windows
   ifconfig  # Linux/Mac
   ```
3. Sửa file `lib/config/api_config.dart`:
   ```dart
   static const String baseUrl = 'http://YOUR_IP_ADDRESS:8080/api/products';
   ```
4. Chạy ứng dụng:
   ```bash
   flutter run
   ```

## Bước 6: Kiểm tra kết nối

1. Mở ứng dụng trên điện thoại/emulator
2. Nếu thấy lỗi kết nối, kiểm tra:
   - Spring Boot backend đang chạy
   - URL trong `api_config.dart` đúng
   - Firewall không chặn port 8080

## Troubleshooting

### Lỗi kết nối API

1. **Android Emulator**: Sử dụng `10.0.2.2` thay vì `localhost`
2. **Thiết bị thật**: Sử dụng IP thật của máy tính
3. **Firewall**: Tắt Windows Firewall hoặc thêm exception cho port 8080

### Lỗi build

1. Chạy `flutter clean`
2. Chạy `flutter pub get`
3. Chạy `flutter run`

### Lỗi dependencies

1. Kiểm tra `pubspec.yaml` có đúng version
2. Chạy `flutter pub deps` để kiểm tra conflicts
3. Cập nhật Flutter: `flutter upgrade`

## Cấu hình nâng cao

### Thay đổi URL API

Sửa file `lib/config/api_config.dart`:

```dart
class ApiConfig {
  // Thay đổi URL này
  static const String baseUrl = 'http://YOUR_API_URL:8080/api/products';
  
  // Có thể thay đổi timeout
  static const int timeoutDuration = 30000;
}
```

### Thêm authentication

1. Thêm token vào headers trong `ApiConfig`
2. Implement login/logout flow
3. Store token trong SharedPreferences

### Thêm offline support

1. Sử dụng Hive hoặc SQLite để cache data
2. Implement sync khi có internet
3. Show offline indicator

## Liên hệ hỗ trợ

Nếu gặp vấn đề, vui lòng:
1. Kiểm tra log trong terminal
2. Chạy `flutter doctor -v` để xem thông tin chi tiết
3. Kiểm tra README.md để xem thông tin thêm
