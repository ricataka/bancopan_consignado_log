import 'dart:convert';
import 'dart:async' show Future;

class DistanceMatrix {
  final List<String> destinations;
  final List<String> origins;
  final List<Element> elements;
  final String status;

  DistanceMatrix({
    required this.destinations,
    required this.origins,
    required this.elements,
    required this.status,
  });

  factory DistanceMatrix.fromJson(Map<String, dynamic> json) {
    var destinationsJson = json['destination_addresses'];
    var originsJson = json['origin_addresses'];
    var rowsJson = json['rows'][0]['elements'] as List;

    return DistanceMatrix(
        destinations: destinationsJson.cast<String>(),
        origins: originsJson.cast<String>(),
        elements: rowsJson.map((i) => Element.fromJson(i)).toList(),
        status: json['status']);
  }

  static Future<DistanceMatrix> loadData(String jsonData) async {
    DistanceMatrix distanceMatrix;
    try {
      distanceMatrix = DistanceMatrix.fromJson(json.decode(jsonData));
      return distanceMatrix;
    } catch (e) {
      throw Exception('nada');
    }
  }
}

class Element {
  final Distance distance;
  final Duration2 duration;
  final String status;

  Element({
    required this.distance,
    required this.duration,
    required this.status,
  });

  factory Element.fromJson(Map<String, dynamic> json) {
    return Element(
        distance: Distance.fromJson(json['distance']),
        duration: Duration2.fromJson(json['duration']),
        status: json['status']);
  }
}

class Distance {
  final String text;
  final int value;

  Distance({
    required this.text,
    required this.value,
  });

  factory Distance.fromJson(Map<String, dynamic> json) {
    return Distance(text: json['text'], value: json['value']);
  }
}

class Duration2 {
  final String text;
  final int value;

  Duration2({
    required this.text,
    required this.value,
  });

  factory Duration2.fromJson(Map<String, dynamic> json) {
    return Duration2(text: json['text'], value: json['value']);
  }
}
