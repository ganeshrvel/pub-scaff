import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/mobx/{{componentName}}_store.dart';
class {{className}}Screen extends StatelessWidget {
  {{className}}Screen({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final {{componentName}} = Provider.of<{{className}}Store>(context);
    return Scaffold(
      body: Center(
        child: Column(),
      ),
    );
  }
}