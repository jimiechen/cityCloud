import 'package:cityCloud/widgets/default_app_bar.dart';
import 'package:flutter/material.dart';

class EmptyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: DefaultAppBar(
        titleText: '空白页',
      ),
    );
  }
}
