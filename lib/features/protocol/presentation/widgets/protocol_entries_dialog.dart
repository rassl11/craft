import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/common/widgets/craftbox_menu_list.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../generated/l10n.dart';

class ProtocolEntriesDialog {
  Future<Object?> show({
    required BuildContext context,
    required Function onNoteItemTap,
    required Function onSignatureItemTap,
    required Function onDraftItemTap,
    required Function onPhotoItemTap,
    required Function onTimeItemTap,
  }) {
    return showGeneralDialog(
        context: context,
        transitionDuration: const Duration(milliseconds: 200),
        pageBuilder: (
          BuildContext buildContext,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return Scaffold(
            body: Container(
              width: double.infinity,
              height: double.infinity,
              margin: const EdgeInsets.only(top: 60).h,
              decoration: const BoxDecoration(
                color: AppColor.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                  topRight: Radius.circular(10),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTitleBarPart(context),
                  _buildSupportList(
                    onNoteItemTap,
                    onSignatureItemTap,
                    onDraftItemTap,
                    onPhotoItemTap,
                    onTimeItemTap,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Builder _buildSupportList(
    Function onNoteItemTap,
    Function onSignatureItemTap,
    Function onDraftItemTap,
    Function onPhotoItemTap,
    Function onTimeItemTap,
  ) {
    return Builder(builder: (context) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        child: CraftboxMenuList(
          listTitle: '',
          items: [
            CraftboxMenuListItem(
              title: S.current.photo,
              svgPicture: getFaIcon(CraftboxIcon.camera),
              onItemTap: () {
                onPhotoItemTap();
              },
              arrowColor: AppColor.transparent,
            ),
            CraftboxMenuListItem(
              title: S.current.note,
              svgPicture: getFaIcon(CraftboxIcon.noteSticky),
              onItemTap: () {
                onNoteItemTap();
              },
              arrowColor: AppColor.transparent,
            ),
            CraftboxMenuListItem(
              title: S.current.projectTime,
              svgPicture: SvgPicture.asset(
                stopwatch,
                height: 24,
              ),
              onItemTap: () {
                onTimeItemTap();
              },
              arrowColor: AppColor.transparent,
            ),
            CraftboxMenuListItem(
              title: S.current.draft,
              svgPicture: getFaIcon(CraftboxIcon.penLine),
              onItemTap: () {
                onDraftItemTap();
              },
              arrowColor: AppColor.transparent,
            ),
            CraftboxMenuListItem(
              title: S.current.pdf,
              svgPicture: getFaIcon(CraftboxIcon.filePdf),
              onItemTap: () {},
              arrowColor: AppColor.transparent,
            ),
            CraftboxMenuListItem(
              title: S.current.attachment,
              svgPicture: SvgPicture.asset(
                attachment,
              ),
              onItemTap: () {},
              arrowColor: AppColor.transparent,
            ),
            CraftboxMenuListItem(
              title: S.current.approval,
              svgPicture: SvgPicture.asset(
                protocolSignUnconstrained,
              ),
              onItemTap: () {
                onSignatureItemTap();
              },
              arrowColor: AppColor.transparent,
            ),
          ],
        ),
      );
    });
  }

  Container _buildTitleBarPart(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: 2,
            color: AppColor.darkWhite,
          ),
        ),
      ),
      child: Stack(children: [
        _buildTitle(),
        _buildLeadingBackButton(context),
      ]),
    );
  }

  Align _buildTitle() {
    return Align(
      child: Text(
        S.current.allProtocolEntries,
        style: TextStyle(
          fontFamily: AppFonts.latoFont,
          fontSize: 17.sp,
          fontWeight: FontWeight.w500,
          color: AppColor.black,
        ),
      ),
    );
  }

  Align _buildLeadingBackButton(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: SizedBox(
        width: 100,
        height: 60,
        child: IconButton(
          padding: EdgeInsets.zero,
          icon: SvgPicture.asset(
            arrowLeft,
            fit: BoxFit.fill,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}
