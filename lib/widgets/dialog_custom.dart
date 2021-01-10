import 'package:flutter/material.dart';
import 'package:tracker/widgets/button_custom.dart';

void dialogCustom(BuildContext context, String title, Function onSubmit) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w400
            ),
          ),
          content: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              InkWell(
                child: Text(
                  "NÃO",
                  style: TextStyle(color: Color(0xff465261)),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 20,
              ),
              Container(width: 80, child: outlinedButton(text: "SIM", onPressed: onSubmit))
            ],
          ),
        );
      });
}
