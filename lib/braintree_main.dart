import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';

class BraintreeWidget extends StatelessWidget {
  const BraintreeWidget(
      {Key? key,
      required this.request,
      required this.onResult,
      required this.isLoading})
      : super(key: key);

  final BraintreeDropInRequest request;
  final void Function(BraintreeDropInResult result) onResult;
  final bool isLoading;

  Future<BraintreeDropInResult> start(
          BuildContext context, BraintreeDropInRequest request) =>
      throw UnsupportedError("BraintreeWidget unsupported on this platform");

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}