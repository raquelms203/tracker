import 'package:flutter/material.dart';

Container containerLoading() {
  return Container(
    color: Colors.transparent,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );
}
