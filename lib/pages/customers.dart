import 'package:flutter/material.dart';
import 'package:my_market/util/customer_detail.dart';
import 'package:my_market/util/cust_info.dart';

class Customers extends StatefulWidget {
  const Customers({super.key});

  @override
  State<Customers> createState() => _CustomersState();
}

class _CustomersState extends State<Customers> {
  bool _ispressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.transparent
        ),
        title: const Text(
          'Customers',
          style: TextStyle(
            fontFamily: 'Merriweather',
            color: Colors.black,
          ),
        ),
        backgroundColor: const Color(0xFF95D6A4),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            GestureDetector(
                onTap: () {
                  setState(() {
                    _ispressed = !_ispressed;
                  });
                },
                child: _ispressed ? CustInfo() : CustDetail()),
            CustDetail(),
            CustDetail(),
            CustDetail(),
            CustDetail(),
            CustDetail(),
            CustDetail(),
            CustDetail(),
            CustDetail(),
            CustDetail(),
            CustDetail(),
            CustDetail(),
            CustDetail(),
          ],
        ),
      ),
    );
  }
}
