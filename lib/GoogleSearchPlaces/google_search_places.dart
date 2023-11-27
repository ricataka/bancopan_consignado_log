import 'dart:async';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:flutter_google_maps_webservices/places.dart';
import 'package:google_places_flutter_api/google_places_flutter_api.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:hipax_log/core/widgets/ui/styles/app_colors.dart';
import 'package:hipax_log/core/widgets/ui/themes/theme_config.dart';

const kGoogleApiKey = "AIzaSyBltB_XmahnIwOyPDQZp4yX2n13OrRu49M";

class RoutesWidget extends StatelessWidget {
  const RoutesWidget({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: "My App",
        theme: ThemeConfig.theme,
        routes: {
          "/": (_) => const GoogleSearchPlaces(),
          "/search": (_) => CustomSearchScaffold(),
        },
      );
}

class GoogleSearchPlaces extends StatefulWidget {
  const GoogleSearchPlaces({super.key});

  @override
  State<GoogleSearchPlaces> createState() => _GoogleSearchPlacesState();
}

final homeScaffoldKey = GlobalKey<ScaffoldState>();
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class _GoogleSearchPlacesState extends State<GoogleSearchPlaces> {
  Mode _mode = Mode.overlay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: homeScaffoldKey,
      appBar: AppBar(
        title: const Text("My App"),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          _buildDropdownMenu(),
          ElevatedButton(
            onPressed: _handlePressButton,
            child: const Text("Search places"),
          ),
          ElevatedButton(
            child: const Text("Custom"),
            onPressed: () {
              Navigator.of(context).pushNamed("/search");
            },
          ),
        ],
      )),
    );
  }

  Widget _buildDropdownMenu() => DropdownButton(
        value: _mode,
        items: const <DropdownMenuItem<Mode>>[
          DropdownMenuItem<Mode>(
            value: Mode.overlay,
            child: Text("Overlay"),
          ),
          DropdownMenuItem<Mode>(
            value: Mode.fullscreen,
            child: Text("Fullscreen"),
          ),
        ],
        onChanged: (m) {
          setState(() {
            _mode = m!;
          });
        },
      );

  void onError(PlacesAutocompleteResponse response) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.status)),
    );
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction? p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: "pt-BR",
      components: [Component(Component.country, "br")],
    );

    // ignore: use_build_context_synchronously
    displayPrediction(p, context);
  }
}

Future<void> displayPrediction(Prediction? p, BuildContext context) async {
  if (p != null) {
    // get detail (lat/lng)
    GoogleMapsPlaces places = GoogleMapsPlaces(
      apiKey: kGoogleApiKey,
      apiHeaders: await const GoogleApiHeaders().getHeaders(),
    );
    PlacesDetailsResponse detail =
        await places.getDetailsByPlaceId(p.placeId ?? '');
    final lat = detail.result.geometry?.location.lat;
    final lng = detail.result.geometry?.location.lng;

    // ignore: use_build_context_synchronously
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${p.description} - $lat/$lng")),
    );
  }
}

// custom scaffold that handle search
// basically your widget need to extends [GooglePlacesAutocompleteWidget]
// and your state [GooglePlacesAutocompleteState]
class CustomSearchScaffold extends PlacesAutocompleteWidget {
  CustomSearchScaffold({super.key})
      : super(
          apiKey: kGoogleApiKey,
          sessionToken: Uuid().generateV4(),
          language: "pt-BR",
          components: [Component(Component.country, "br")],
        );

  @override
  // ignore: library_private_types_in_public_api
  _CustomSearchScaffoldState createState() => _CustomSearchScaffoldState();
}

class _CustomSearchScaffoldState extends PlacesAutocompleteState {
  @override
  Widget build(BuildContext context) {
    final appBar = AppBar(title: const AppBarPlacesAutoCompleteTextField());
    final body = PlacesAutocompleteResult(
      onTap: (p) {
        displayPrediction(p, context);
      },
      logo: const Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [FlutterLogo()],
      ),
    );
    return Scaffold(key: searchScaffoldKey, appBar: appBar, body: body);
  }

  @override
  void onResponseError(PlacesAutocompleteResponse response) {
    super.onResponseError(response);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(response.status)),
    );
  }

  @override
  void onResponse(PlacesAutocompleteResponse? response) {
    super.onResponse(response);
    if (response!.isOkay && response.predictions.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Got answer")),
      );
    }
  }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    // Generate xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx / 8-4-4-4-12.
    final int special = 8 + _random.nextInt(4);

    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
