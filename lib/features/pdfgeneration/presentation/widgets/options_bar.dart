import 'package:flutter/material.dart';

//! important to add new callback Names
enum CallbackName {
  onPrint,
  onShare,
}

class OptionsBar extends StatelessWidget {
  final VoidCallback? onPrint;
  final VoidCallback? onShare;

  OptionsBar({super.key, this.onPrint, this.onShare});
  //! important to add new callback for it to work
  VoidCallback? _getCallback(CallbackName name) {
    switch (name) {
      case CallbackName.onPrint:
        return onPrint;
      case CallbackName.onShare:
        return onShare;
      default:
        return null; // Should not reach here
    }
  }

  Widget _getIconButton(CallbackName name) {
    VoidCallback? callback = _getCallback(name);
    if (callback == null) {
      return Container(); // Return an empty container if callback is null
    }

    switch (name) {
      case CallbackName.onShare:
        return IconButton(onPressed: callback, icon: Icon(Icons.share));
      case CallbackName.onPrint:
        return IconButton(onPressed: callback, icon: Icon(Icons.print));
      default:
        return Container(); // Should not reach here
    }
  }

  //!
  @override
  Widget build(BuildContext context) {
    final buttons = CallbackName.values
        .map((name) => _getIconButton(name))
        .where((widget) => widget is IconButton) // Filter out empty containers
        .toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: buttons,
    );
  }
}
