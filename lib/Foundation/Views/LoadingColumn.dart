import 'package:flutter/material.dart';

class LoadingColumn extends StatelessWidget {
  const LoadingColumn({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
      return  Container(child:Center(child: CircularProgressIndicator(strokeWidth: 1,)), height: MediaQuery.of(context).size.height,);

  }
}
