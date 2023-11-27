// import 'package:ai_barcode_scanner/ai_barcode_scanner.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

late String _label;
// late Function(String result) _resultCallback;

///
/// AppBarcodeScannerWidget2
class AppBarcodeScannerWidget2 extends StatefulWidget {
  ///
  ///
  AppBarcodeScannerWidget2.defaultStyle({super.key, 
    required Function(String result) resultCallback,
    String label = '',
  }) {
    // _resultCallback = resultCallback;
    _label = label;
  }

  @override
  State<AppBarcodeScannerWidget2> createState() => _AppBarcodeState();
}

class _AppBarcodeState extends State<AppBarcodeScannerWidget2> {
  @override
  Widget build(BuildContext context) {
    return _BarcodePermissionWidget();
  }
}

class _BarcodePermissionWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _BarcodePermissionWidgetState();
  }
}

class _BarcodePermissionWidgetState extends State<_BarcodePermissionWidget> {
  bool _isGranted = false;

  final bool _useCameraScan = true;

  @override
  void initState() {
    super.initState();
  }

  void _requestMobilePermission() async {
    if (await Permission.camera.request().isGranted) {
      setState(() {
        _isGranted = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TargetPlatform platform = Theme.of(context).platform;
    if (!kIsWeb) {
      if (platform == TargetPlatform.android ||
          platform == TargetPlatform.iOS) {
        _requestMobilePermission();
      } else {
        setState(() {
          _isGranted = true;
        });
      }
    } else {
      setState(() {
        _isGranted = true;
      });
    }

    return Column(
      children: <Widget>[
        Expanded(
          child: _isGranted
              ? _useCameraScan
                  ? _BarcodeScannerWidget()
                  : _BarcodeInputWidget.defaultStyle(
                      changed: (value) {},
                    )
              : Center(
                  child: ElevatedButton(
                    onPressed: () {
                      _requestMobilePermission();
                    },
                    child: const Text(""),
                  ),
                ),
        ),
      ],
    );
  }
}

class _BarcodeInputWidget extends StatefulWidget {
  final ValueChanged<String> _changed;

  const _BarcodeInputWidget.defaultStyle({
    required ValueChanged<String> changed,
  }) : _changed = changed;

  @override
  State<StatefulWidget> createState() {
    return _BarcodeInputState();
  }
}

class _BarcodeInputState extends State<_BarcodeInputWidget> {
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      final text = _controller.text.toLowerCase();
      _controller.value = _controller.value.copyWith(
        text: text,
        selection:
            TextSelection(baseOffset: text.length, extentOffset: text.length),
        composing: TextRange.empty,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Padding(padding: EdgeInsets.all(8)),
        Row(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(8)),
            Text(
              "$_label：",
            ),
            Expanded(
              child: TextFormField(
                controller: _controller,
                onChanged: widget._changed,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ),
            const Padding(padding: EdgeInsets.all(8)),
          ],
        ),
        const Padding(padding: EdgeInsets.all(8)),
      ],
    );
  }
}

///ScannerWidget
class _BarcodeScannerWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AppBarcodeScannerWidget2State();
  }
}

class _AppBarcodeScannerWidget2State extends State<_BarcodeScannerWidget> {
  // late ScannerController _scannerController;

  // @override
  // void initState() {
  //   super.initState();

  //   _scannerController = ScannerController(scannerResult: (result) {
  //     _scannerController.stopCameraPreview();

  //     _resultCallback(result);
  //   });
  // }

  // @override
  // void dispose() {
  //   super.dispose();

  //   _scannerController.stopCameraPreview();
  //   _scannerController.stopCamera();
  // }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _getScanWidgetByPlatform(),
    );
  }

  Widget _getScanWidgetByPlatform() {
    return const SizedBox();
    // return PlatformAiBarcodeScannerWidget(
    //   platformScannerController: _scannerController,
    // );
  }
}
