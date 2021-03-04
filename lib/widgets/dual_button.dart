import 'package:flutter/material.dart';

class DualButton extends StatelessWidget {

  final Function topOnPressed;
  final Function bottomOnPressed;
  final Icon iconTop;
  final Icon iconBottom;
  final String text;

  DualButton({this.text,this.iconTop,this.iconBottom,this.topOnPressed,this.bottomOnPressed});


  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;

    return Container(
      height: size.height * 0.21,
      width: size.width * 0.17 ,
      decoration: new BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: new BorderRadius.all(
          Radius.circular(40.0),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          IconButton(
            icon: iconTop,
            onPressed: this.topOnPressed,
          ),
          Text(
            (text!=null) ? text : "",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: size.width*0.05,
            ),
          ),
          IconButton(
            icon: iconBottom,
            onPressed: this.bottomOnPressed,
          ),
        ],
      ),
    );
  }
}
