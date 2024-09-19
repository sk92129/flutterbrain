@JS()
library braintree_payment;

import 'dart:convert';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
//import 'dart:js_interop';
import 'dart:ui_web' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
// ignore: implementation_imports
import 'package:js/js.dart';
import 'package:js/js_util.dart';
import 'package:simplebrain/flutter_braintree_extensions.dart';


String htmlL = """<div id="dropin-container"></div>""";
var paymentDiv = html.DivElement()..appendHtml(htmlL); // attach to container

@JS()
external void initBraintree(auth);

@JS()
external payment(dynamic auth);

@JS()
external requestPaymentMethod(dynamic auth);

class BraintreeWidget extends StatefulWidget {
  const BraintreeWidget(
      {Key? key,
      required this.request,
      required this.onResult,
      required this.isLoading})
      : super(key: key);

  final BraintreeDropInRequest request;
  final void Function(BraintreeDropInResult result) onResult;
  final bool isLoading;

  @override
  State<StatefulWidget> createState() => _BraintreeState();
}

class _BraintreeState extends State<BraintreeWidget> {
  BraintreeDropInResult? result;
  dynamic braintreeInstance;

  void start(BuildContext context, BraintreeDropInRequest request) async {
    paymentDiv.innerHtml = htmlL; // reset inner html

    var requestData = request.toBTJson();
    requestData['container'] = "#dropin-container";

    var promise = payment(json.encode(requestData));

// show dialog
// this MUST be awaited you MUST MUST MUST store dialogResponse for some reason
    try {
      dynamic payload = await promiseToFuture(promise); // 'magic'
      setState(() {
        braintreeInstance = payload;
      });
    } catch (e) {
      rethrow;
    }
  }

  @override
  void initState() {
    ui.platformViewRegistry
        .registerViewFactory('braintree-container', (int viewId) => paymentDiv);
    if (braintreeInstance == null) {
      start(context, widget.request);
    }
    super.initState();
  }

  Future<BraintreeDropInResult?> requestBraintreeNonce() async {
    var promise = requestPaymentMethod(braintreeInstance);

    try {
      dynamic payload = await promiseToFuture(promise); // 'magic'
      // return nonce
      if (payload != null) {
        // more info https://github.com/pikaju/flutter-braintree/blob/main/lib/src/result.dart
        var source = json.decode(payload);
        BraintreePaymentMethodNonce btNonce = BraintreePaymentMethodNonce(
            nonce: source['nonce'],
            typeLabel: source['type'],
            description: source.containsKey('description') ? 'description' : '',
            isDefault:
                source.containsKey('isDefault') ? source['isDefault'] : true);
        if (!mounted) return null;
        result = BraintreeDropInResult(
            paymentMethodNonce: btNonce, deviceData: null);
        setState(() {});
        return result;
      } else {
        // DIALOG CLOSED OR NONCE INVALID
        throw Exception("Payload none");
      }
    } catch (e) {
      rethrow;
    }
  }

  void finishPaymentProcess() async {
    var dropInResult = result;
    var newDropInResult = await requestBraintreeNonce();
    if (dropInResult?.paymentMethodNonce.nonce ==
            newDropInResult?.paymentMethodNonce.nonce &&
        newDropInResult != null) {
      // user clicked on button a second time without changing anything.
      // Proceed with payment
      widget.onResult(newDropInResult);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      if (!widget.isLoading)
        const SizedBox(
            width: 600.0,
            height: 350.0,
            child: HtmlElementView(
              viewType: 'braintree-container',
            )),
      ElevatedButton(
          onPressed: widget.isLoading ? null : finishPaymentProcess,
          child: const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "Buy Now",
                style: TextStyle(fontSize: 18),
              )))
    ]);
  }
}