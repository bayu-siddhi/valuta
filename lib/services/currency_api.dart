import "dart:convert";
import "package:http/http.dart" as http;

class CurrencyApiService {
  final String _primaryBaseUrl =
      "https://cdn.jsdelivr.net/npm/@fawazahmed0/currency-api@{date}/{version}/{endpoint}";

  final String _fallbackBaseUrl =
      "https://{date}.currency-api.pages.dev/{version}/{endpoint}";

  Future<Map<String, dynamic>> _fetchWithFallback({
    required String date,
    required String version,
    required String endpoint,
  }) async {
    final primaryUrl = _primaryBaseUrl
        .replaceAll("{date}", date)
        .replaceAll("{version}", version)
        .replaceAll("{endpoint}", endpoint);

    final fallbackUrl = _fallbackBaseUrl
        .replaceAll("{date}", date)
        .replaceAll("{version}", version)
        .replaceAll("{endpoint}", endpoint);

    try {
      final response = await http
          .get(Uri.parse(primaryUrl))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (_) {}

    // Fallback
    try {
      final response = await http
          .get(Uri.parse(fallbackUrl))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        return json.decode(response.body);
      }
    } catch (_) {}

    // Both primary and fallback failed
    throw Exception("Failed to fetch data.\nCheck your internet connection.");
  }

  Future<Map<String, dynamic>> getCurrencies({String date = "latest"}) async {
    return _fetchWithFallback(
      date: date,
      version: "v1",
      endpoint: "currencies.min.json",
    );
  }

  Future<Map<String, dynamic>> getExchangeRates(
    String baseCurrency, {
    String date = "latest",
  }) async {
    return _fetchWithFallback(
      date: date,
      version: "v1",
      endpoint: "currencies/${baseCurrency.toLowerCase()}.json",
    );
  }
}
