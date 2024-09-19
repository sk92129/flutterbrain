import 'package:flutter_braintree/flutter_braintree.dart';

extension WebPaypalExtensions on BraintreePayPalRequest {
  Map<String, dynamic> toBTJson() => {
        'flow': 'vault',
        if (amount != null) 'amount': amount,
        if (currencyCode != null) 'currency': currencyCode,
        if (displayName != null) 'displayName': displayName,
        if (billingAgreementDescription != null)
          'billingAgreementDetails': {
            'description': billingAgreementDescription,
          }
      };
}

extension WebDropInExtensions on BraintreeDropInRequest {
  Map<String, dynamic> toBTJson() => {
        if (clientToken != null) 'authorization': clientToken,
        if (paypalRequest != null) 'paypal': paypalRequest!.toBTJson(),
      };
}