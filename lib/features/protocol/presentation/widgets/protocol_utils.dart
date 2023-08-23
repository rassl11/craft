import 'package:flutter/material.dart';

import '../../../../core/injection_container.dart';
import '../../../../core/utils/dialog_provider.dart';
import '../../../../generated/l10n.dart';

void showPopConfirmationDialog(
  BuildContext context,
  VoidCallback onNegativeButtonAction,
) {
  sl<DialogProvider>().showPlatformSpecificDialog(
    builderContext: context,
    invertButtonOrder: true,
    title: S.current.popDialogTitle,
    content: S.current.popDialogContent,
    positiveButtonTitle: S.current.signaturePopDialogPositive,
    positiveButtonAction: () {
      Navigator.of(context).pop();
    },
    negativeButtonTitle: S.current.signaturePopDialogNegative,
    negativeButtonAction: onNegativeButtonAction,
  );
}
