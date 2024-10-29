import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class Place {
  final double lon;
  final double lat;

  Place({required this.lon, required this.lat});

  @override
  String toString() {
    return 'Place(lon: $lon, lat: $lat)';
  }
}

class Suggestion {
  final String placeId;
  final String description;

  Suggestion(this.placeId, this.description);

  @override
  String toString() {
    return 'Suggestion(description: $description, placeId: $placeId)';
  }
}

class PlaceApiProvider {
  final String sessionToken;
  final client = http.Client();

  static final String androidKey = 'AIzaSyD-yXrA6zoQRzns6mTgCJYSsRRzhkoMyXY';
  static final String iosKey = 'AIzaSyBcFY0dn1sCb3IPvZ7ErG2X1sZhTEq4atc';
  final String apiKey = Platform.isAndroid ? androidKey : iosKey;

  PlaceApiProvider(this.sessionToken);

  Future<List<Suggestion>> fetchSuggestions(String input, String lang) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$input&types=address&language=$lang&components=country:ng&key=$apiKey&sessiontoken=$sessionToken';
    var url = Uri.parse(request);
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        // compose suggestions in a list
        return (result['predictions'] as List<dynamic>)
            .map((p) => Suggestion(p['place_id'], p['description']))
            .toList();
      } else if (result['status'] == 'ZERO_RESULTS') {
        return [];
      } else {
        throw Exception(result['error_message']);
      }
    } else {
      throw Exception('Failed to fetch suggestion');
    }
  }

  Future<Place> fetchLatLon(String placeId) async {
    final request =
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey';
    var url = Uri.parse(request);
    final response = await client.get(url);

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result['status'] == 'OK') {
        final location = result['result']['geometry']['location'];
        final lat = location['lat'];
        final lon = location['lng'];

        return Place(lat: lat, lon: lon);
      } else {
        throw Exception(result['error_message']);
      }
    } else {
      throw Exception('Failed to fetch latitude and longitude');
    }
  }
}