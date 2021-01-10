import 'package:flutter/material.dart';

Widget defaultButton({Color color, String text, Function onPressed}) {
  return InkWell(
    child: Container( 
      height: 50,
      alignment: Alignment.center, 
      decoration: BoxDecoration(  
        color: color ?? Colors.indigo[300],
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color ?? Colors.indigo[300])
      ),
      child: Text(text, style: TextStyle(color: Colors.white, fontSize: 16,)),
    ),
    onTap: onPressed,
  );
}

Widget outlinedButton({Color color, String text, Function onPressed}) {
  return InkWell(
    child: Container(  
      height: 35,
      alignment: Alignment.center,
      decoration: BoxDecoration(  
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: color ?? Colors.indigo[300])
      ),
      child: Text(text, style: TextStyle(color: color ?? Colors.indigo[300]),),
    ),
    onTap: onPressed,
  );
}
