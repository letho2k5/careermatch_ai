import 'package:flutter/material.dart';

class AppFrame extends StatelessWidget {
  const AppFrame({
    required this.title,
    required this.body,
    this.actions,
    this.showBackButton = false,
    super.key,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;
  final bool showBackButton;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        automaticallyImplyLeading: showBackButton,
        actions: actions,
      ),
      body: SafeArea(child: body),
    );
  }
}
