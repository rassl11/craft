import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../constants/theme/colors.dart';
import '../constants/theme/fonts.dart';

void showSnackBarWithText(BuildContext context, String text) {
  hideSnackBar(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(text),
    ),
  );
}

void showColorfulSnackBar(
  BuildContext context, {
  required Color backgroundColor,
  required String text,
  required EmojiType emojiType,
  int durationInSeconds = 2,
}) {
  hideSnackBar(context);
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: durationInSeconds),
      backgroundColor: backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.zero,
      behavior: SnackBarBehavior.floating,
      content: Container(
        alignment: Alignment.centerLeft,
        margin: const EdgeInsets.only(left: 16),
        height: 50,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emojiType.emoji, style: TextStyle(fontSize: 22.sp)),
            const SizedBox(width: 8),
            Text(
              text,
              style: TextStyle(
                color: AppColor.white,
                fontFamily: AppFonts.latoFont,
                fontSize: 17.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

enum EmojiType {
  success('👍'),
  error('🙁');

  final String emoji;

  const EmojiType(this.emoji);
}

void hideSnackBar(BuildContext context) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar();
}

Widget buildLoadingIndicator() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

Widget buildErrorPlaceholder(String errorMessage) {
  return Center(
    child: Text(
      errorMessage,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: AppColor.black,
        fontFamily: AppFonts.latoFont,
        fontSize: 17.sp,
        fontWeight: FontWeight.w500,
      ),
    ),
  );
}
