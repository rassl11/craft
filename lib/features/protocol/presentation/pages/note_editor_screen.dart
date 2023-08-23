import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
import '../cubits/note/note_cubit.dart';
import '../widgets/share_note_dialog.dart';
import 'note_screen.dart';

class NoteEditorScreen extends StatelessWidget {
  static const routeName = '/noteEditor';

  const NoteEditorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final noteArgs = ModalRoute.of(context)!.settings.arguments as NoteArgs;

    return BlocProvider(
      create: (context) => sl<NoteCubit>(),
      child: BlocListener<NoteCubit, NoteState>(
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
            noteArgs: noteArgs,
          ),
          body: _buildBody(
            context: context,
            noteArgs: noteArgs,
          ),
          bottomNavigationBar: _buildBottomSheet(
            noteArgs: noteArgs,
          ),
        ),
      ),
    );
  }

  PreferredSize _buildAppBar({
    required BuildContext context,
    required NoteArgs noteArgs,
  }) {
    final isProtocolSigned = noteArgs.isProtocolSigned;

    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Builder(builder: (context) {
        return CraftboxAppBar(
          title: S.current.note,
          leadingIconPath: arrowLeft,
          onLeadingIconPressed: () {
            Navigator.of(context).pop();
          },
          actions: [
            if (isProtocolSigned)
              _buildShareButton(context, noteArgs)
            else
              _buildMoreButton(context, noteArgs),
          ],
        );
      }),
    );
  }

  IconButton _buildMoreButton(
    BuildContext context,
    NoteArgs noteArgs,
  ) {
    return IconButton(
        onPressed: () {
          ShareDocumentationDialog().show(
              context: context,
              onShareTapped: () {
                _handleOnShareTapped(
                  context,
                  noteArgs.title,
                  noteArgs.text,
                );
              },
              onDeleteTapped: () {
                _handleOnDeleteTapped(
                  context,
                  noteArgs.documentationId,
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
    NoteArgs noteArgs,
  ) {
    return IconButton(
        onPressed: () {
          _handleOnShareTapped(
            context,
            noteArgs.title,
            noteArgs.text,
          );
        },
        icon: getFaIcon(
          CraftboxIcon.share,
          color: AppColor.orange,
          height: 24,
        ));
  }

  void _handleOnShareTapped(
    BuildContext context,
    String title,
    String text,
  ) {
    final box = context.findRenderObject() as RenderBox?;
    Share.share(
      '$title\n$text',
      sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
    );
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
        context.read<NoteCubit>().delete(
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
    required NoteArgs noteArgs,
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
                title: noteArgs.title,
              ),
              20.verticalSpace,
              _buildDescriptionTextField(
                context: context,
                text: noteArgs.text,
              ),
              35.verticalSpace,
              _buildFooter(
                context: context,
                causer: noteArgs.causer,
                updatedAt: noteArgs.updatedAt,
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
        fontSize: 28,
        fontFamily: AppFonts.latoFont,
        fontWeight: FontWeight.w800,
        color: AppColor.black,
      ),
    );
  }

  Text _buildDescriptionTextField({
    required BuildContext context,
    required String text,
  }) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 17,
        fontFamily: AppFonts.latoFont,
        fontWeight: FontWeight.w500,
        color: AppColor.black,
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
    required NoteArgs noteArgs,
  }) {
    return Builder(builder: (context) {
      return CraftboxBottomSheet(
        buttonTitle: S.current.edit,
        onButtonPressed: () async {
          final noteEdited = await Navigator.of(context).pushNamed(
            NoteScreen.routeName,
            arguments: NoteArgs(
              assignmentId: noteArgs.assignmentId,
              causer: noteArgs.causer,
              updatedAt: noteArgs.updatedAt,
              documentationId: noteArgs.documentationId,
              title: noteArgs.title,
              text: noteArgs.text,
              edit: true,
            ),
          ) as bool?;
          if (context.mounted && (noteEdited ?? false)) {
            Navigator.of(context).pop(true);
          }
        },
      );
    });
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
