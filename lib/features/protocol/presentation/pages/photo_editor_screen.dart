import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/blocs/status.dart';
import '../../../../core/common/widgets/craftbox_app_bar.dart';
import '../../../../core/common/widgets/craftbox_author_info.dart';
import '../../../../core/common/widgets/craftbox_bottom_sheet.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/dialog_provider.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../generated/l10n.dart';
import '../../../assignments/domain/entities/creation.dart';
import '../cubits/photo/photo_cubit.dart';
import '../cubits/photo/photo_state.dart';
import '../widgets/share_note_dialog.dart';
import 'photo_screen.dart';

class PhotoEditorScreen extends StatelessWidget {
  static const routeName = '/photoEditor';

  const PhotoEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as PhotoEditorArgs;

    return BlocProvider(
      create: (context) => sl<PhotoCubit>(),
      child: BlocListener<PhotoCubit, PhotoState>(
        listener: (context, state) {
          if (state.cubitStatus == Status.loaded) {
            Navigator.of(context)
              ..pop()
              ..pop(true);
          }

          if (state.cubitStatus == Status.error) {
            _showErrorAndNavigateBack(context);
          }
        },
        child: Scaffold(
          backgroundColor: AppColor.background,
          appBar: _buildAppBar(
            context: context,
            args: args,
          ),
          body: _buildBody(
            context: context,
            args: args,
          ),
          bottomNavigationBar: _buildBottomSheet(
            args: args,
          ),
        ),
      ),
    );
  }

  PreferredSize _buildAppBar({
    required BuildContext context,
    required PhotoEditorArgs args,
  }) {
    final isProtocolSigned = args.isProtocolSigned;

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Builder(builder: (context) {
        return CraftboxAppBar(
          title: S.current.photo,
          leadingIconPath: arrowLeft,
          onLeadingIconPressed: () {
            Navigator.of(context).pop();
          },
          actions: [
            if (isProtocolSigned)
              _buildShareButton(context, args)
            else
              _buildMoreButton(context, args),
          ],
        );
      }),
    );
  }

  IconButton _buildMoreButton(
    BuildContext context,
    PhotoEditorArgs args,
  ) {
    return IconButton(
        onPressed: () {
          ShareDocumentationDialog().show(
              context: context,
              onShareTapped: () {
                _handleOnShareTapped(
                  context,
                  args.title,
                  args.photo,
                );
              },
              onDeleteTapped: () {
                _handleOnDeleteTapped(
                  context,
                  args.documentationId,
                );
              });
        },
        icon: getFaIcon(
          CraftboxIcon.more,
          color: AppColor.orange,
          height: 24,
        ));
  }

  IconButton _buildShareButton(
    BuildContext context,
    PhotoEditorArgs args,
  ) {
    return IconButton(
        onPressed: () {
          _handleOnShareTapped(
            context,
            args.title,
            args.photo,
          );
        },
        icon: getFaIcon(
          CraftboxIcon.share,
          color: AppColor.orange,
          height: 24,
        ));
  }

  Future<void> _handleOnShareTapped(
    BuildContext context,
    String title,
    String photo,
  ) async {
    final photoBytes = await urlToUint8List(photo);
    final tempDir = await getTemporaryDirectory();
    final tempFile = File('${tempDir.path}/$title.jpg')
      ..writeAsBytesSync(photoBytes);
    if (context.mounted) {
      final box = context.findRenderObject() as RenderBox?;
      await Share.shareXFiles(
        [XFile(tempFile.path)],
        text: title,
        sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
      );
    }
  }

  void _handleOnDeleteTapped(
    BuildContext context,
    int documentationId,
  ) {
    return sl<DialogProvider>().showPlatformSpecificDialog(
      builderContext: context,
      title: S.current.deleteProtocolEntry,
      content: S.current.deleteProtocolEntryText,
      positiveButtonTitle: S.current.okUppercase,
      positiveButtonAction: () {
        context.read<PhotoCubit>().delete(
              documentationId: documentationId,
            );
        Navigator.pop(context);
      },
      negativeButtonTitle: S.current.cancel,
      negativeButtonAction: () {
        Navigator.pop(context);
      },
    );
  }

  SingleChildScrollView _buildBody({
    required BuildContext context,
    required PhotoEditorArgs args,
  }) {
    return SingleChildScrollView(
      child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleTextField(
                context: context,
                title: args.title,
              ),
              20.verticalSpace,
              _buildPhoto(
                context: context,
                photo: args.photo,
              ),
              35.verticalSpace,
              _buildFooter(
                context: context,
                causer: args.causer,
                updatedAt: args.updatedAt,
              ),
            ],
          )),
    );
  }

  Text _buildTitleTextField({
    required BuildContext context,
    required String title,
  }) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 20,
        fontFamily: AppFonts.latoFont,
        fontWeight: FontWeight.w800,
        color: AppColor.black,
      ),
    );
  }

  Widget _buildPhoto({
    required BuildContext context,
    required String photo,
  }) {
    return Container(
      width: double.maxFinite,
      height: 406.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          width: 2,
        ),
        image: DecorationImage(
          image: NetworkImage(photo),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  CraftboxAuthorInfo _buildFooter({
    required BuildContext context,
    required Causer? causer,
    required DateTime? updatedAt,
  }) {
    final updatedAtDate = CraftboxDateTimeUtils.getFormattedDate(
      context,
      updatedAt,
      isDateWithTimeRequired: true,
    );

    return CraftboxAuthorInfo(
      text: S.current.created,
      causer: causer,
      updatedAtDate: updatedAtDate,
    );
  }

  Widget _buildBottomSheet({
    required PhotoEditorArgs args,
  }) {
    return !args.isProtocolSigned
        ? Builder(builder: (context) {
            return CraftboxBottomSheet(
              buttonTitle: S.current.edit,
              onButtonPressed: () async {
                final photoEdited =
                    await Navigator.of(context).pushNamed(PhotoScreen.routeName,
                        arguments: PhotoArgs(
                          assignmentId: args.assignmentId,
                          photos: [args.photo],
                          hints: [args.title],
                          isEditMode: true,
                        )) as bool?;
                if (context.mounted && (photoEdited ?? false)) {
                  Navigator.of(context).pop(true);
                }
              },
            );
          })
        : const SizedBox.shrink();
  }

  void _showErrorAndNavigateBack(BuildContext context) {
    Navigator.of(context).pop();
    showColorfulSnackBar(
      context,
      backgroundColor: AppColor.red500,
      text: S.current.somethingWentWrong,
      emojiType: EmojiType.error,
    );
  }
}

class PhotoEditorArgs {
  final int assignmentId;
  final Causer? causer;
  final DateTime? updatedAt;
  final int documentationId;
  final String title;
  final String photo;
  final bool isProtocolSigned;

  const PhotoEditorArgs({
    required this.assignmentId,
    required this.causer,
    required this.updatedAt,
    required this.documentationId,
    required this.title,
    required this.photo,
    this.isProtocolSigned = false,
  });
}
