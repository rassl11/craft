import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../generated/l10n.dart';
import '../constants/theme/colors.dart';

class DialogProvider {
  void showPlatformSpecificDialog({
    required BuildContext builderContext,
    bool invertButtonOrder = false,
    String? title,
    String? content,
    String? positiveButtonTitle,
    String? negativeButtonTitle,
    VoidCallback? positiveButtonAction,
    VoidCallback? negativeButtonAction,
  }) {
    if (Platform.isIOS) {
      _showIosDialog(
        builderContext,
        invertButtonOrder,
        title,
        content,
        positiveButtonTitle,
        negativeButtonTitle,
        positiveButtonAction,
        negativeButtonAction,
      );
    } else {
      _showAndroidDialog(
        builderContext,
        invertButtonOrder,
        title,
        content,
        positiveButtonTitle,
        negativeButtonTitle,
        positiveButtonAction,
        negativeButtonAction,
      );
    }
  }

  void showTimeDialog({
    required BuildContext builderContext,
    required String? content,
    required VoidCallback? onRecordMoreTime,
    required VoidCallback? onChangeStatusOnly,
  }) {
    if (Platform.isIOS) {
      _showIosTimeDialog(
        builderContext,
        content,
        onRecordMoreTime,
        onChangeStatusOnly,
      );
    } else {
      _showAndroidTimeDialog(
        builderContext,
        content,
        onRecordMoreTime,
        onChangeStatusOnly,
      );
    }
  }

  void showAccidentalExitTimeDialog({
    required BuildContext builderContext,
    required VoidCallback? onStay,
    required VoidCallback? onDiscard,
  }) {
    if (Platform.isIOS) {
      _showAccidentalIosTimeDialog(
        builderContext,
        onStay,
        onDiscard,
      );
    } else {
      _showAccidentalAndroidTimeDialog(
        builderContext,
        onStay,
        onDiscard,
      );
    }
  }

  void _showAndroidDialog(
    BuildContext builderContext,
    bool invertButtonOrder,
    String? title,
    String? content,
    String? positiveButtonTitle,
    String? negativeButtonTitle,
    VoidCallback? positiveButtonAction,
    VoidCallback? negativeButtonAction,
  ) {
    showDialog<void>(
      context: builderContext,
      builder: (BuildContext context) => AlertDialog(
        title: title != null ? Text(title) : null,
        content: content != null ? Text(content) : null,
        actions: _getAndroidDialogActions(
          invertButtonOrder,
          positiveButtonTitle,
          negativeButtonTitle,
          positiveButtonAction,
          negativeButtonAction,
        ),
      ),
    );
  }

  List<Widget> _getAndroidDialogActions(
    bool invertButtonOrder,
    String? positiveButtonTitle,
    String? negativeButtonTitle,
    VoidCallback? positiveButtonAction,
    VoidCallback? negativeButtonAction,
  ) {
    if (invertButtonOrder) {
      return [
        _getAndroidAction(negativeButtonAction, negativeButtonTitle),
        _getAndroidAction(positiveButtonAction, positiveButtonTitle)
      ];
    }

    final actions = <Widget>[];
    if (positiveButtonTitle != null) {
      actions.add(
        _getAndroidAction(positiveButtonAction, positiveButtonTitle),
      );
    }

    if (negativeButtonTitle != null) {
      actions.add(
        _getAndroidAction(negativeButtonAction, negativeButtonTitle),
      );
    }

    return actions;
  }

  TextButton _getAndroidAction(
    VoidCallback? buttonAction,
    String? buttonTitle,
  ) {
    return TextButton(
      onPressed: buttonAction,
      child: Text(
        buttonTitle ?? '-',
        style: const TextStyle(color: AppColor.black),
      ),
    );
  }

  void _showIosDialog(
    BuildContext builderContext,
    bool invertButtonOrder,
    String? title,
    String? content,
    String? positiveButtonTitle,
    String? negativeButtonTitle,
    VoidCallback? positiveButtonAction,
    VoidCallback? negativeButtonAction,
  ) {
    showCupertinoModalPopup<void>(
      context: builderContext,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: title != null ? Text(title) : null,
        content: content != null ? Text(content) : null,
        actions: _getIosDialogActions(
          invertButtonOrder,
          positiveButtonTitle,
          negativeButtonTitle,
          positiveButtonAction,
          negativeButtonAction,
        ),
      ),
    );
  }

  List<CupertinoDialogAction> _getIosDialogActions(
    bool invertButtonOrder,
    String? positiveButtonTitle,
    String? negativeButtonTitle,
    VoidCallback? positiveButtonAction,
    VoidCallback? negativeButtonAction,
  ) {
    if (invertButtonOrder) {
      return [
        _getPositiveCupertinoAction(positiveButtonAction, positiveButtonTitle),
        _getNegativeCupertinoAction(negativeButtonAction, negativeButtonTitle),
      ];
    }

    final actions = <CupertinoDialogAction>[];
    if (negativeButtonTitle != null) {
      actions.add(
        _getNegativeCupertinoAction(negativeButtonAction, negativeButtonTitle),
      );
    }

    if (positiveButtonTitle != null) {
      actions.add(
        _getPositiveCupertinoAction(positiveButtonAction, positiveButtonTitle),
      );
    }

    return actions;
  }

  CupertinoDialogAction _getPositiveCupertinoAction(
    VoidCallback? positiveButtonAction,
    String? positiveButtonTitle,
  ) {
    return CupertinoDialogAction(
      onPressed: positiveButtonAction,
      child: Text(
        positiveButtonTitle ?? '-',
        style: const TextStyle(color: CupertinoColors.activeBlue),
      ),
    );
  }

  CupertinoDialogAction _getNegativeCupertinoAction(
    VoidCallback? negativeButtonAction,
    String? negativeButtonTitle,
  ) {
    return CupertinoDialogAction(
      isDefaultAction: true,
      onPressed: negativeButtonAction,
      child: Text(
        negativeButtonTitle ?? '-',
        style: const TextStyle(color: CupertinoColors.activeBlue),
      ),
    );
  }

  void _showIosTimeDialog(
    BuildContext builderContext,
    String? content,
    VoidCallback? onRecordMoreTime,
    VoidCallback? onChangeStatusOnly,
  ) {
    showCupertinoModalPopup<void>(
      context: builderContext,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(S.current.timeDialogTitle),
        content: content != null ? Text(content) : null,
        actions: _getIosTimeDialogActions(
          context,
          onRecordMoreTime,
          onChangeStatusOnly,
        ),
      ),
    );
  }

  List<CupertinoDialogAction> _getIosTimeDialogActions(
    BuildContext context,
    VoidCallback? onRecordMoreTime,
    VoidCallback? onChangeStatusOnly,
  ) {
    final actions = <CupertinoDialogAction>[
      CupertinoDialogAction(
        isDefaultAction: true,
        onPressed: () {
          Navigator.of(context).pop();
          onRecordMoreTime?.call();
        },
        child: Text(
          S.current.timeDialogPositiveButton,
          style: const TextStyle(color: CupertinoColors.activeBlue),
        ),
      ),
      CupertinoDialogAction(
        onPressed: () {
          Navigator.of(context).pop();
          onChangeStatusOnly?.call();
        },
        child: Text(
          S.current.timeDialogNegativeButton,
          style: const TextStyle(color: CupertinoColors.activeBlue),
        ),
      ),
    ];

    return actions;
  }

  void _showAndroidTimeDialog(
    BuildContext builderContext,
    String? content,
    VoidCallback? onRecordMoreTime,
    VoidCallback? onChangeStatusOnly,
  ) {
    showDialog<void>(
      context: builderContext,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(S.current.timeDialogTitle),
        content: content != null ? Text(content) : null,
        actions: _getAndroidTimeDialogActions(
          context,
          onRecordMoreTime,
          onChangeStatusOnly,
        ),
      ),
    );
  }

  List<Widget> _getAndroidTimeDialogActions(
    BuildContext context,
    VoidCallback? onRecordMoreTime,
    VoidCallback? onChangeStatusOnly,
  ) {
    final actions = <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          onRecordMoreTime?.call();
        },
        child: Text(
          S.current.timeDialogPositiveButton,
          style: const TextStyle(
            color: AppColor.black,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          onChangeStatusOnly?.call();
        },
        child: Text(
          S.current.timeDialogNegativeButton,
          style: const TextStyle(color: AppColor.black),
        ),
      ),
    ];

    return actions;
  }

  void _showAccidentalIosTimeDialog(
    BuildContext builderContext,
    VoidCallback? onStay,
    VoidCallback? onDiscard,
  ) {
    showCupertinoModalPopup<void>(
      context: builderContext,
      barrierDismissible: false,
      builder: (BuildContext context) => CupertinoAlertDialog(
        title: Text(S.current.accidentalTimeDialogTitle),
        content: Text(S.current.accidentalTimeDialogContent),
        actions: _getAccidentalIosTimeDialogActions(
          context,
          onStay,
          onDiscard,
        ),
      ),
    );
  }

  List<CupertinoDialogAction> _getAccidentalIosTimeDialogActions(
    BuildContext context,
    VoidCallback? onStay,
    VoidCallback? onDiscard,
  ) {
    final actions = <CupertinoDialogAction>[
      CupertinoDialogAction(
        onPressed: () {
          Navigator.of(context).pop();
          onStay?.call();
        },
        child: Text(
          S.current.timeDialogStay,
          style: const TextStyle(color: CupertinoColors.activeBlue),
        ),
      ),
      CupertinoDialogAction(
        onPressed: () {
          Navigator.of(context).pop();
          onDiscard?.call();
        },
        child: Text(
          S.current.timeDialogDiscard,
          style: const TextStyle(color: CupertinoColors.activeBlue),
        ),
      ),
    ];

    return actions;
  }

  void _showAccidentalAndroidTimeDialog(
    BuildContext builderContext,
    VoidCallback? onStay,
    VoidCallback? onDiscard,
  ) {
    showDialog<void>(
      context: builderContext,
      barrierDismissible: false,
      builder: (BuildContext context) => AlertDialog(
        title: Text(S.current.accidentalTimeDialogTitle),
        content: Text(S.current.accidentalTimeDialogContent),
        actions: _getAccidentalAndroidTimeDialogActions(
          context,
          onStay,
          onDiscard,
        ),
      ),
    );
  }

  List<Widget> _getAccidentalAndroidTimeDialogActions(
    BuildContext context,
    VoidCallback? onStay,
    VoidCallback? onDiscard,
  ) {
    final actions = <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          onStay?.call();
        },
        child: Text(
          S.current.timeDialogStay,
          style: const TextStyle(
            color: AppColor.black,
          ),
        ),
      ),
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
          onDiscard?.call();
        },
        child: Text(
          S.current.timeDialogDiscard,
          style: const TextStyle(color: AppColor.black),
        ),
      ),
    ];

    return actions;
  }
}
