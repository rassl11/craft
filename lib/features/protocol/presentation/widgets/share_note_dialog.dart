import 'package:flutter/cupertino.dart';

import '../../../../core/constants/theme/colors.dart';
import '../../../../generated/l10n.dart';

class ShareDocumentationDialog {
  Future<Object?> show({
    required BuildContext context,
    required Function onShareTapped,
    required Function onDeleteTapped,
  }) {
    return showCupertinoModalPopup(
        context: context,
        builder: (
          BuildContext buildContext,
        ) {
          return CupertinoActionSheet(
              actions: <Widget>[
                _buildMoreOptionsButton(),
                _buildShareButton(onShareTapped),
                _buildDeleteButton(onDeleteTapped),
              ],
              cancelButton: CupertinoActionSheetAction(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  S.current.cancel,
                  style: const TextStyle(
                      color: AppColor.black, fontWeight: FontWeight.w600),
                ),
              ));
        });
  }

  Container _buildDeleteButton(Function onDeleteTapped) {
    return Container(
      color: AppColor.white,
      child: CupertinoActionSheetAction(
        isDestructiveAction: true,
        onPressed: () {
          onDeleteTapped();
        },
        child: Text(
          S.current.delete,
          style: const TextStyle(color: AppColor.red500),
        ),
      ),
    );
  }

  Container _buildShareButton(Function onShareTapped) {
    return Container(
      color: AppColor.white,
      child: CupertinoActionSheetAction(
        child: Text(
          S.current.share,
          style: const TextStyle(color: AppColor.black),
        ),
        onPressed: () {
          onShareTapped();
        },
      ),
    );
  }

  Container _buildMoreOptionsButton() {
    return Container(
      height: 48,
      color: AppColor.white,
      child: CupertinoActionSheetAction(
        child: Text(
          S.current.moreOptions,
          style: const TextStyle(
            color: AppColor.grayCupertino,
            fontStyle: FontStyle.normal,
            fontWeight: FontWeight.w400,
            fontSize: 13,
            letterSpacing: -0.078,
          ),
        ),
        onPressed: () {},
      ),
    );
  }
}
