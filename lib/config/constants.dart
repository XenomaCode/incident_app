import 'package:flutter_dotenv/flutter_dotenv.dart';

class Constants {
  static String baseApiUrl = dotenv.env["BASE_API_URL"] ?? "";
  static String mapsApiKey = dotenv.env["MAPS_API_KEY"] ?? "";
  static String mapsGeoCodeUrl = dotenv.env["GEOCODE_URL"] ?? "";
}