import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/blocs/status.dart';
import '../../../../core/common/widgets/back_to_top_scroll_view.dart';
import '../../../../core/common/widgets/craftbox_app_bar.dart';
import '../../../../core/common/widgets/craftbox_author_info.dart';
import '../../../../core/common/widgets/craftbox_bottom_sheet.dart';
import '../../../../core/common/widgets/craftbox_text_field.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../generated/l10n.dart';
import '../../../assignments/domain/entities/creation.dart';
import '../../../assignments/presentation/blocs/scroll/scroll_button_bloc.dart';
import '../cubits/approval/approval_cubit.dart';
import '../widgets/craftbox_signature_field.dart';
import '../widgets/protocol_utils.dart';
import 'signature_screen.dart';

class SubmitApprovalScreen extends StatelessWidget {
  static const routeName = '/submitApproval';

  const SubmitApprovalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as SubmitApprovalArgs;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<ApprovalCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<ScrollBloc>(),
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: _buildAppBar(context, args.customerName),
        body: BlocListener<ApprovalCubit, ApprovalState>(
          listener: (context, state) {
            if (state.cubitStatus == Status.loaded) {
              Navigator.of(context).pop(true);
              return;
            }

            _showSnackBar(state, context);
          },
          child: _buildScrollableBody(args),
        ),
        bottomNavigationBar: _buildBottomSheet(args.assignmentId),
      ),
    );
  }

  PreferredSize _buildAppBar(BuildContext context, String? customerName) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: BlocBuilder<ApprovalCubit, ApprovalState>(
        builder: (context, state) {
          return CraftboxAppBar(
            title: customerName != null
                ? S.current.approval
                : S.current.submitApproval,
            leadingIconPath: arrowLeft,
            onLeadingIconPressed: () {
              if (state.customerName.isNotEmpty ||
                  state.customerSignature != null ||
                  state.executorSignature != null) {
                showPopConfirmationDialog(context, () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                });
              } else {
                Navigator.of(context).pop();
              }
            },
          );
        },
      ),
    );
  }

  void _showSnackBar(ApprovalState state, BuildContext context) {
    final noCustomerSignature = state.customerSignature == null;
    final noExecutorSignature = state.executorSignature == null;
    if (state.cubitStatus == Status.error &&
        (noCustomerSignature || noExecutorSignature)) {
      final count = noCustomerSignature && noExecutorSignature ? 2 : 1;
      showColorfulSnackBar(
        context,
        backgroundColor: AppColor.red500,
        text: S.current.signatureEmpty(count),
        emojiType: EmojiType.error,
      );
    }
  }

  BackToTopScrollView _buildScrollableBody(SubmitApprovalArgs args) {
    return BackToTopScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
        child: BlocBuilder<ApprovalCubit, ApprovalState>(
          builder: (context, state) {
            final isErrorStatus = state.cubitStatus == Status.error;
            if (isErrorStatus && state.customerName.isEmpty) {
              context.read<ScrollBloc>().add(ScrollUpRequested());
            }

            return Stack(
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildCustomerTextField(
                      context: context,
                      args: args,
                      state: state,
                      isErrorStatus: isErrorStatus,
                    ),
                    20.verticalSpace,
                    _buildCustomerSignatureField(
                      context: context,
                      isErrorStatus: isErrorStatus,
                      state: state,
                      byteListSignature: args.customerSignature,
                    ),
                    20.verticalSpace,
                    _buildExecutorSignatureField(
                      context: context,
                      isErrorStatus: isErrorStatus,
                      state: state,
                      byteListSignature: args.executorSignature,
                    ),
                    _buildFooter(
                      context: context,
                      args: args,
                    )
                  ],
                ),
                if (state.cubitStatus == Status.loading)
                  Positioned.fill(
                    child: Align(
                      child: buildLoadingIndicator(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCustomerTextField({
    required BuildContext context,
    required SubmitApprovalArgs args,
    required ApprovalState state,
    required bool isErrorStatus,
  }) {
    if (args.customerName != null) {
      return _buildCustomerNameText(
        context: context,
        title: args.customerName ?? '',
      );
    } else {
      return _buildCustomerNameTextField(
        context: context,
        isErrorStatus: isErrorStatus,
        state: state,
      );
    }
  }

  Widget _buildFooter({
    required BuildContext context,
    required SubmitApprovalArgs args,
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

  CraftboxTextField _buildCustomerNameTextField({
    required bool isErrorStatus,
    required ApprovalState state,
    required BuildContext context,
  }) {
    return CraftboxTextField(
      leadingTitle: S.current.customer,
      hint: S.current.enterYourCustomer,
      errorText: isErrorStatus && state.customerName.isEmpty
          ? S.current.thisFieldIsEmpty
          : null,
      onChanged: (value) {
        context.read<ApprovalCubit>().setCustomer(value);
      },
    );
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

  CraftboxSignatureField _buildCustomerSignatureField({
    required bool isErrorStatus,
    required ApprovalState state,
    required BuildContext context,
    required Uint8List? byteListSignature,
  }) {
    return CraftboxSignatureField(
      isErrorIndicationRequired:
          isErrorStatus && state.customerSignature == null,
      title: '${S.current.customerSignature}:',
      onTap: () async {
        final result = await Navigator.pushNamed(
          context,
          SignatureScreen.routeName,
          arguments: SignatureArgs(
            S.current.customerSignature,
          ),
        );
        if (context.mounted) {
          context.read<ApprovalCubit>().addSignature(
                SignatureType.customer,
                result,
              );
        }
      },
      signature: byteListSignature ?? state.customerSignature,
    );
  }

  CraftboxSignatureField _buildExecutorSignatureField({
    required bool isErrorStatus,
    required ApprovalState state,
    required BuildContext context,
    required Uint8List? byteListSignature,
  }) {
    return CraftboxSignatureField(
      isErrorIndicationRequired:
          isErrorStatus && state.executorSignature == null,
      title: '${S.current.executorSignature}:',
      onTap: () async {
        final result = await Navigator.pushNamed(
          context,
          SignatureScreen.routeName,
          arguments: SignatureArgs(
            S.current.executorSignature,
          ),
        );
        if (context.mounted) {
          context.read<ApprovalCubit>().addSignature(
                SignatureType.executor,
                result,
              );
        }
      },
      signature: byteListSignature ?? state.executorSignature,
    );
  }

  Widget _buildBottomSheet(int? assignmentId) {
    return assignmentId != null
        ? BlocBuilder<ApprovalCubit, ApprovalState>(
            builder: (context, state) {
              return CraftboxBottomSheet(
                buttonTitle: state.isSaving
                    ? S.current.saving
                    : S.current.timeRecorderMainButtonTitle,
                fontStyle: state.isSaving ? FontStyle.italic : FontStyle.normal,
                onButtonPressed: () {
                  context.read<ApprovalCubit>().submitApproval(assignmentId);
                },
              );
            },
          )
        : const SizedBox.shrink();
  }
}

class SubmitApprovalArgs {
  final int? assignmentId;
  final String? customerName;
  final Uint8List? customerSignature;
  final Uint8List? executorSignature;
  final DateTime? updatedAt;
  final Causer? causer;

  const SubmitApprovalArgs({
    this.assignmentId,
    this.customerName,
    this.customerSignature,
    this.executorSignature,
    this.updatedAt,
    this.causer,
  });
}
