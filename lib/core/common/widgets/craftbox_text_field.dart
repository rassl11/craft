import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/theme/colors.dart';
import '../../constants/theme/fonts.dart';

class CraftboxTextField extends StatefulWidget {
  final bool isReadOnly;
  final bool isMultiline;
  final PasswordFieldData? passwordFieldData;
  final String leadingTitle;
  final String? trailingTitle;
  final String hint;
  final String? text;
  final String? errorText;
  final TextInputAction? inputAction;
  final Function(String value)? onChanged;
  final Function(String value)? onEditingComplete;
  final Function? hasFocus;
  final VoidCallback? onTap;
  final int bottomPadding;

  const CraftboxTextField({
    super.key,
    required this.leadingTitle,
    this.trailingTitle,
    required this.hint,
    this.text,
    this.onTap,
    this.isMultiline = false,
    this.isReadOnly = false,
    this.onChanged,
    this.onEditingComplete,
    this.hasFocus,
    this.inputAction,
    this.bottomPadding = 17, // default bottom padding
    this.passwordFieldData,
    this.errorText,
  });

  @override
  State<CraftboxTextField> createState() => _CraftboxTextFieldState();
}

class _CraftboxTextFieldState extends State<CraftboxTextField> {
  static const borderCornersRadius = 7.0;
  static const borderWidth = 2.0;

  late TextEditingController _controller;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        widget.hasFocus?.call();
      } else {
        widget.onEditingComplete?.call(_controller.text);
      }
    });
  }

  void _setText() {
    final text = widget.text;
    if (text != null && text.isNotEmpty) {
      final cursorPos = _controller.selection.base.offset;
      _controller
        ..text = text
        ..selection = TextSelection.fromPosition(TextPosition(
          offset: cursorPos > text.length ? 0 : cursorPos,
        ));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
    _focusNode.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _setText();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildLabel(),
        _buildTextField(context),
      ],
    );
  }

  Widget _buildLabel() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 7).h,
          child: Text(
            widget.leadingTitle,
            style: TextStyle(
              fontFamily: AppFonts.latoFont,
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.black,
            ),
          ),
        ),
        if (widget.trailingTitle != null)
          _buildTrailingTitle()
        else
          const SizedBox.shrink(),
      ],
    );
  }

  Widget _buildTrailingTitle() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7).h,
      child: Text(
        widget.trailingTitle!,
        style: TextStyle(
          fontFamily: AppFonts.latoFont,
          fontSize: 15.sp,
          fontWeight: FontWeight.w700,
          fontStyle: FontStyle.italic,
          color: AppColor.gray,
        ),
      ),
    );
  }

  TextField _buildTextField(BuildContext context) {
    return TextField(
      textAlignVertical: TextAlignVertical.top,
      readOnly: widget.isReadOnly,
      minLines: widget.isMultiline ? 1 : null,
      maxLines: widget.isMultiline ? 10 : 1,
      onTap: widget.onTap,
      controller: _controller,
      textInputAction: widget.inputAction,
      keyboardType: _getKeyboardType(),
      obscureText: _isTextHidden(),
      style: TextStyle(
        fontFamily: AppFonts.latoFont,
        fontSize: 17.sp,
        fontWeight: FontWeight.w500,
        color: AppColor.black,
      ),
      decoration: _getDecoration(
        widget.passwordFieldData?.visibilityIcon,
        widget.errorText,
        widget.bottomPadding,
      ),
      onChanged: (value) {
        widget.onChanged?.call(value);
      },
      focusNode: _focusNode,
    );
  }

  bool _isTextHidden() {
    if (widget.passwordFieldData != null) {
      return !widget.passwordFieldData!.isPasswordVisible;
    }
    return false;
  }

  TextInputType _getKeyboardType() => widget.passwordFieldData == null
      ? TextInputType.emailAddress
      : TextInputType.text;

  InputDecoration _getDecoration(
    IconButton? visibilityIcon,
    String? errorText,
    int bottomPadding,
  ) {
    return InputDecoration(
      errorText: errorText,
      suffixIcon: visibilityIcon,
      contentPadding: EdgeInsets.only(
        top: 17.w,
        bottom: bottomPadding.w,
        left: 18.h,
        right: 18.h,
      ),
      enabledBorder: _getEnabledBorder(),
      focusedBorder: _getFocusedBorder(),
      focusedErrorBorder: _getErrorBorder(),
      errorBorder: _getErrorBorder(),
      hintText: widget.hint,
    );
  }

  OutlineInputBorder _getEnabledBorder() {
    return OutlineInputBorder(
      borderRadius: _getBorderRadius(),
      borderSide: const BorderSide(
        width: borderWidth,
        color: AppColor.darkGray,
      ),
    );
  }

  OutlineInputBorder _getFocusedBorder() {
    return OutlineInputBorder(
      borderRadius: _getBorderRadius(),
      borderSide: const BorderSide(width: borderWidth),
    );
  }

  OutlineInputBorder _getErrorBorder() {
    return OutlineInputBorder(
      borderRadius: _getBorderRadius(),
      borderSide: const BorderSide(
        width: borderWidth,
        color: AppColor.red500,
      ),
    );
  }

  BorderRadius _getBorderRadius() {
    return const BorderRadius.all(
      Radius.circular(borderCornersRadius),
    );
  }
}

class PasswordFieldData {
  final bool isPasswordVisible;
  final IconButton visibilityIcon;

  PasswordFieldData({
    required this.visibilityIcon,
    required this.isPasswordVisible,
  });
}
