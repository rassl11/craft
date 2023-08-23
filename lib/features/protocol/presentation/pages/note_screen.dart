import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/blocs/status.dart';
import '../../../../core/common/widgets/craftbox_app_bar.dart';
import '../../../../core/common/widgets/craftbox_author_info.dart';
import '../../../../core/common/widgets/craftbox_bottom_sheet.dart';
import '../../../../core/common/widgets/craftbox_text_field.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../generated/l10n.dart';
import '../../../assignments/domain/entities/creation.dart';
import '../cubits/note/note_cubit.dart';
import '../widgets/protocol_utils.dart';

class NoteScreen extends StatelessWidget {
  static const routeName = '/note';

  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final noteArgs = ModalRoute.of(context)!.settings.arguments as NoteArgs;

    return BlocProvider(
      create: (context) => sl<NoteCubit>()
        ..setInitialValue(title: noteArgs.title, text: noteArgs.text),
      child: BlocConsumer<NoteCubit, NoteState>(listener: (context, state) {
        if (state.cubitStatus == Status.loaded) {
          Navigator.of(context).pop(true);
          return;
        }

        if (state.cubitStatus == Status.error) {
          showColorfulSnackBar(
            context,
            backgroundColor: AppColor.red500,
            text: S.current.somethingWentWrong,
            emojiType: EmojiType.error,
          );
        }
      }, builder: (
        context,
        state,
      ) {
        return Scaffold(
          backgroundColor: AppColor.background,
          appBar: _buildAppBar(context: context, state: state),
          body: _buildBody(
            context: context,
            state: state,
            noteArgs: noteArgs,
          ),
          bottomNavigationBar: _buildBottomSheet(
            state: state,
            noteArgs: noteArgs,
          ),
        );
      }),
    );
  }

  CraftboxAppBar _buildAppBar({
    required BuildContext context,
    required NoteState state,
  }) {
    return CraftboxAppBar(
      title: S.current.note,
      leadingIconPath: arrowLeft,
      onLeadingIconPressed: () {
        if (state.title.isNotEmpty || state.text.isNotEmpty) {
          showPopConfirmationDialog(context, () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else {
          Navigator.of(context).pop();
        }
      },
    );
  }

  SingleChildScrollView _buildBody({
    required BuildContext context,
    required NoteState state,
    required NoteArgs noteArgs,
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildTitleTextField(
                  context: context,
                  state: state,
                  title: noteArgs.title,
                ),
                20.verticalSpace,
                _buildDescriptionTextField(
                  context: context,
                  state: state,
                  text: noteArgs.text,
                ),
                35.verticalSpace,
                _buildFooter(
                  context: context,
                  causer: noteArgs.causer,
                  updatedAt: noteArgs.updatedAt,
                ),
              ],
            ),
            if (state.cubitStatus == Status.loading)
              Positioned.fill(
                child: Align(
                  child: buildLoadingIndicator(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  CraftboxTextField _buildTitleTextField({
    required BuildContext context,
    required NoteState state,
    required String title,
  }) {
    return CraftboxTextField(
      leadingTitle: S.current.title,
      hint: S.current.enterYourTitle,
      text: state.title,
      errorText: state.titleError ? S.current.thisFieldIsEmpty : null,
      onChanged: (value) {
        context.read<NoteCubit>().setTitle(value);
      },
    );
  }

  CraftboxTextField _buildDescriptionTextField({
    required BuildContext context,
    required NoteState state,
    required String text,
  }) {
    return CraftboxTextField(
      leadingTitle: S.current.text,
      hint: S.current.enterYourText,
      text: state.text,
      errorText: state.textError ? S.current.thisFieldIsEmpty : null,
      onChanged: (value) {
        context.read<NoteCubit>().setText(value);
      },
      bottomPadding: 165,
    );
  }

  Widget _buildFooter({
    required BuildContext context,
    required Causer? causer,
    required DateTime? updatedAt,
  }) {
    final updatedAtDate = CraftboxDateTimeUtils.getFormattedDate(
      context,
      updatedAt,
      isDateWithTimeRequired: true,
    );

    return updatedAtDate != ''
        ? CraftboxAuthorInfo(
            causer: causer,
            text: S.current.created,
            updatedAtDate: updatedAtDate,
          )
        : const SizedBox.shrink();
  }

  Widget _buildBottomSheet({
    required NoteState state,
    required NoteArgs noteArgs,
  }) {
    return Builder(builder: (context) {
      return CraftboxBottomSheet(
          buttonTitle: S.current.save,
          onButtonPressed: () {
            if (noteArgs.edit) {
              context.read<NoteCubit>().edit(
                    assignmentId: noteArgs.assignmentId,
                    documentationId: noteArgs.documentationId,
                  );
            } else {
              context.read<NoteCubit>().save(
                    assignmentId: noteArgs.assignmentId,
                  );
            }
          });
    });
  }
}

class NoteArgs {
  final int assignmentId;
  final Causer? causer;
  final DateTime? updatedAt;
  final int documentationId;
  final String title;
  final String text;
  final bool edit;
  final bool isProtocolSigned;

  const NoteArgs({
    required this.assignmentId,
    required this.causer,
    this.updatedAt,
    this.documentationId = 0,
    this.title = '',
    this.text = '',
    this.edit = false,
    this.isProtocolSigned = false,
  });
}
