// loading required packages
import 'package:flutter/material.dart';

class SupportUs extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(20),
      height: MediaQuery.of(context).size.height -
          MediaQuery.of(context).padding.top,
    );
  }
}