import 'package:flutter/material.dart';

class AppPrimaryButton extends StatelessWidget {
  const AppPrimaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return _ButtonWidth(
      expand: expand,
      child: FilledButton(
        onPressed: onPressed,
        child: _ButtonContent(label: label, icon: icon),
      ),
    );
  }
}

class AppSecondaryButton extends StatelessWidget {
  const AppSecondaryButton({
    required this.label,
    required this.onPressed,
    this.icon,
    this.expand = true,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    return _ButtonWidth(
      expand: expand,
      child: OutlinedButton(
        onPressed: onPressed,
        child: _ButtonContent(label: label, icon: icon),
      ),
    );
  }
}

class _ButtonWidth extends StatelessWidget {
  const _ButtonWidth({required this.expand, required this.child});

  final bool expand;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: expand ? double.infinity : null, child: child);
  }
}

class _ButtonContent extends StatelessWidget {
  const _ButtonContent({required this.label, this.icon});

  final String label;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    if (icon == null) return Text(label);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Flexible(child: Text(label, textAlign: TextAlign.center)),
      ],
    );
  }
}
