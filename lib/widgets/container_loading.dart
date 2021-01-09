import 'package:flutter/material.dart';

Container containerLoading() {
  return Container(
    color: Colors.white,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
