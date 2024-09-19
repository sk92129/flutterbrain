import 'package:flutter/material.dart';
import 'package:flutter_braintree/flutter_braintree.dart';
import 'package:simplebrain/braintree_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'brain tree test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  late BraintreeDropInRequest request;
  
  var tokenizationKey = "MY_TOKENIZATION_KEY";

  @override
  void initState() {
   
    super.initState();

    request = BraintreeDropInRequest(tokenizationKey: tokenizationKey, 
    amount: "10.00",
        venmoEnabled: false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Braintree',
            ),
            BraintreeWidget(request: request, onResult: (result) {
              print(result);
            }, isLoading: false),

            
          ],
        ),
      ),
// This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  void openPaymentSheet() {
    
  }
}
