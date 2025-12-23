import 'package:flutter/material.dart';

enum CustomButtonType {
  primary,
  secondary,
  outline,
  text,
  danger,
}

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final CustomButtonType type;
  final bool isLoading;
  final IconData? icon;
  final double? width;
  final EdgeInsetsGeometry? padding;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = CustomButtonType.primary,
    this.isLoading = false,
    this.icon,
    this.width,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDisabled = onPressed == null || isLoading;

    final buttonStyle = _getButtonStyle(theme);
    final foregroundColor = _getForegroundColor(theme);

    Widget buttonChild = isLoading
        ? SizedBox(
      height: 20,
      width: 20,
      child: CircularProgressIndicator(
        strokeWidth: 2,
        valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
      ),
    )
        : _buildButtonContent(foregroundColor);

    return SizedBox(
      width: width,
      child: _buildButtonByType(
        context: context,
        style: buttonStyle,
        child: buttonChild,
        isDisabled: isDisabled,
      ),
    );
  }

  Widget _buildButtonByType({
    required BuildContext context,
    required ButtonStyle style,
    required Widget child,
    required bool isDisabled,
  }) {
    switch (type) {
      case CustomButtonType.outline:
        return OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: style,
          child: child,
        );
      case CustomButtonType.text:
        return TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: style,
          child: child,
        );
      default:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: style,
          child: child,
        );
    }
  }

  Widget _buildButtonContent(Color foregroundColor) {
    if (icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 20, color: foregroundColor),
          const SizedBox(width: 8),
          Text(text),
        ],
      );
    }
    return Text(text);
  }

  ButtonStyle _getButtonStyle(ThemeData theme) {
    final basePadding = padding ??
        const EdgeInsets.symmetric(horizontal: 24, vertical: 12);

    switch (type) {
      case CustomButtonType.primary:
        return ElevatedButton.styleFrom(
          backgroundColor: theme.primaryColor,
          foregroundColor: Colors.white,
          padding: basePadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );

      case CustomButtonType.secondary:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.grey[200],
          foregroundColor: Colors.grey[800],
          padding: basePadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );

      case CustomButtonType.outline:
        return OutlinedButton.styleFrom(
          foregroundColor: theme.primaryColor,
          padding: basePadding,
          side: BorderSide(color: theme.primaryColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );

      case CustomButtonType.text:
        return TextButton.styleFrom(
          foregroundColor: theme.primaryColor,
          padding: basePadding,
        );

      case CustomButtonType.danger:
        return ElevatedButton.styleFrom(
          backgroundColor: Colors.red[600],
          foregroundColor: Colors.white,
          padding: basePadding,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        );
    }
  }

  Color _getForegroundColor(ThemeData theme) {
    switch (type) {
      case CustomButtonType.primary:
      case CustomButtonType.danger:
        return Colors.white;
      case CustomButtonType.secondary:
        return Colors.grey[800]!;
      case CustomButtonType.outline:
      case CustomButtonType.text:
        return theme.primaryColor;
    }
  }
}

class CustomFloatingButton extends StatelessWidget {
  final VoidCallback onPressed;
  final IconData icon;
  final String? tooltip;

  const CustomFloatingButton({
    super.key,
    required this.onPressed,
    required this.icon,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      child: Icon(icon),
    );
  }
}
