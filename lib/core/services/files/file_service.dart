import 'package:flutter_dotenv/flutter_dotenv.dart';

class FileService {
  static final _baseUrl = dotenv.env['BASE_URL'] ?? 'http://localhost:8000';

  static getImageUrl(String imageName) => '$_baseUrl/uploads/$imageName';

  static getFileUrl(String fileName) => '$_baseUrl/uploads/$fileName';
}
