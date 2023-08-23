import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../core/blocs/status.dart';
import '../../../../core/common/widgets/craftbox_app_bar.dart';
import '../../../../core/common/widgets/craftbox_author_info.dart';
import '../../../../core/common/widgets/craftbox_bottom_sheet.dart';
import '../../../../core/common/widgets/craftbox_text_field.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/dialog_provider.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../generated/l10n.dart';
import '../../../assignments/domain/entities/creation.dart';
import '../cubits/draft/draft_cubit.dart';
import '../cubits/draft/draft_state.dart';
import '../widgets/craftbox_signature_field.dart';
import '../widgets/protocol_utils.dart';
import '../widgets/share_note_dialog.dart';
import 'signature_screen.dart';

class DraftScreen extends StatelessWidget {
  static const routeName = '/draft';

  const DraftScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final draftArgs = ModalRoute.of(context)!.settings.arguments as DraftArgs;

    return BlocProvider(
      create: (context) => sl<DraftCubit>(),
      child: BlocConsumer<DraftCubit, DraftState>(listener: (context, state) {
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
          appBar: _buildAppBar(
            context: context,
            state: state,
            isProtocolSigned: draftArgs.isProtocolSigned,
            draftArgs: draftArgs,
          ),
          body: _buildBody(
            context: context,
            state: state,
            args: draftArgs,
          ),
          bottomNavigationBar: _buildBottomSheet(
            state: state,
            assignmentId: draftArgs.assignmentId,
          ),
        );
      }),
    );
  }

  CraftboxAppBar _buildAppBar({
    required BuildContext context,
    required DraftState state,
    required bool isProtocolSigned,
    required DraftArgs draftArgs,
  }) {
    return CraftboxAppBar(
      title: S.current.draft,
      leadingIconPath: arrowLeft,
      onLeadingIconPressed: () {
        if (state.title.isNotEmpty || state.draft != null) {
          showPopConfirmationDialog(context, () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          });
        } else {
          Navigator.of(context).pop();
        }
      },
      actions: _getActions(
        draftArgs,
        isProtocolSigned,
        context,
      ),
    );
  }

  List<Widget> _getActions(
    DraftArgs draftArgs,
    bool isProtocolSigned,
    BuildContext context,
  ) {
    if (draftArgs.assignmentId != null) {
      return [];
    }

    return _buildActionButton(
      isProtocolSigned,
      context,
      draftArgs,
    );
  }

  List<Widget> _buildActionButton(
    bool isProtocolSigned,
    BuildContext context,
    DraftArgs draftArgs,
  ) {
    if (isProtocolSigned) {
      return [
        _buildShareButton(
          context,
          draftArgs,
        ),
      ];
    }

    return [
      _buildMoreButton(
        context,
        draftArgs,
      ),
    ];
  }

  IconButton _buildMoreButton(
    BuildContext context,
    DraftArgs draftArgs,
  ) {
    return IconButton(
        onPressed: () {
          ShareDocumentationDialog().show(
              context: context,
              onShareTapped: () {
                _handleOnShareTapped(
                  context,
                  draftArgs.customerName,
                  draftArgs.draft,
                );
              },
              onDeleteTapped: () {
                _handleOnDeleteTapped(
                  context,
                  draftArgs.documentationId,
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
    DraftArgs draftArgs,
  ) {
    return IconButton(
        onPressed: () {
          _handleOnShareTapped(
            context,
            draftArgs.customerName,
            draftArgs.draft,
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
    Uint8List? draft,
  ) {
    final box = context.findRenderObject() as RenderBox?;
    Share.shareXFiles(
      [XFile.fromData(draft ?? Uint8List(0))],
      text: title,
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
        context.read<DraftCubit>().delete(
              documentationId: documentationId,
            );
        Navigator.of(context)
          ..pop()
          ..pop(true);
      },
      negativeButtonTitle: S.current.cancel,
      negativeButtonAction: () {
        Navigator.pop(context);
      },
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required DraftState state,
    required DraftArgs args,
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(
                  context: context,
                  state: state,
                  args: args,
                ),
                20.verticalSpace,
                _buildDraftField(
                  context: context,
                  state: state,
                  draft: args.draft,
                ),
                _buildFooter(
                  context: context,
                  args: args,
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

  Widget _buildTitle({
    required BuildContext context,
    required DraftArgs args,
    required DraftState state,
  }) {
    if (args.customerName != '') {
      return _buildCustomerNameText(
        context: context,
        title: args.customerName,
      );
    } else {
      return _buildTitleTextField(
        context: context,
        state: state,
      );
    }
  }

  Text _buildCustomerNameText({
    required BuildContext context,
    required String title,
  }) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 24,
        fontFamily: AppFonts.latoFont,
        fontWeight: FontWeight.w800,
        color: AppColor.black,
      ),
    );
  }

  CraftboxTextField _buildTitleTextField({
    required BuildContext context,
    required DraftState state,
  }) {
    return CraftboxTextField(
      leadingTitle: S.current.title,
      hint: S.current.enterYourCustomer,
      text: state.title,
      errorText: state.titleError ? S.current.thisFieldIsEmpty : null,
      onChanged: (value) {
        context.read<DraftCubit>().setTitle(value);
      },
    );
  }

  CraftboxSignatureField _buildDraftField({
    required DraftState state,
    required BuildContext context,
    required Uint8List? draft,
  }) {
    return CraftboxSignatureField(
      isErrorIndicationRequired: state.draftError,
      title: draft != null ? '' : '${S.current.draft}:',
      onTap: () async {
        final result = await Navigator.pushNamed(
          context,
          SignatureScreen.routeName,
          arguments: SignatureArgs(
            S.current.draft,
          ),
        );
        if (context.mounted) {
          context.read<DraftCubit>().addDraft(
                result,
              );
        }
      },
      height: 375,
      signature: draft ?? state.draft,
    );
  }

  Widget _buildBottomSheet({
    required DraftState state,
    required int? assignmentId,
  }) {
    return assignmentId != null
        ? Builder(builder: (context) {
            return CraftboxBottomSheet(
                buttonTitle: state.isSaving ? S.current.saving : S.current.save,
                fontStyle: state.isSaving ? FontStyle.italic : FontStyle.normal,
                onButtonPressed: () {
                  context.read<DraftCubit>().save(
                        assignmentId: assignmentId,
                      );
                });
          })
        : const SizedBox.shrink();
  }

  Widget _buildFooter({
    required BuildContext context,
    required DraftArgs args,
  }) {
    if (args.causer != null) {
      return Column(
        children: [
          30.verticalSpace,
          _buildFooterWithCauser(
            context: context,
            causer: args.causer,
            updatedAt: args.updatedAt,
          ),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  CraftboxAuthorInfo _buildFooterWithCauser({
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
}

class DraftArgs {
  final int? assignmentId;
  final String customerName;
  final int documentationId;
  final Uint8List? draft;
  final DateTime? updatedAt;
  final Causer? causer;
  final bool isProtocolSigned;

  const DraftArgs({
    this.assignmentId,
    this.customerName = '',
    this.documentationId = 0,
    this.draft,
    this.updatedAt,
    this.causer,
    this.isProtocolSigned = false,
  });
}
