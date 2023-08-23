import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/common/widgets/craftbox_app_bar.dart';
import '../../../../core/common/widgets/craftbox_big_button.dart';
import '../../../../core/common/widgets/craftbox_text_field.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../generated/l10n.dart';
import '../blocs/forgot_password/forgot_password_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const routeName = '/forgotPassword';

  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: CraftboxAppBar(
        title: S.current.forgotPassword,
        backgroundColor: AppColor.orange,
        leadingIconPath: arrowLeft,
        leadingIconColor: AppColor.black,
      ),
      body: BlocProvider(
        create: (context) => sl<ForgotPasswordBloc>(),
        child: BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
          listener: _handleStatus,
          child: _buildBody(),
        ),
      ),
    );
  }

  void _handleStatus(BuildContext context, ForgotPasswordState state) {
    switch (state.forgotPasswordStatus) {
      case ForgotPasswordStatus.failure:
        showSnackBarWithText(
          context,
          state.errorMessage ?? S.current.indicatorUnknownError,
        );
        break;
      case ForgotPasswordStatus.success:
        showSnackBarWithText(
          context,
          S.current.indicatorPasswordSent,
        );
        break;
      case ForgotPasswordStatus.loading:
        showSnackBarWithText(context, S.current.indicatorChecking);
        break;
      default:
        break;
    }
  }

  Stack _buildBody() {
    return Stack(children: [
      Container(
        height: 65.h,
        decoration: const BoxDecoration(
          color: AppColor.orange,
          border: Border(
            bottom: BorderSide(),
          ),
        ),
      ),
      CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _buildUpperBodyPart(),
          ),
          SliverFillRemaining(
            hasScrollBody: false,
            child: _buildBottomButton(),
          )
        ],
      ),
    ]);
  }

  Padding _buildUpperBodyPart() {
    return Padding(
      padding: EdgeInsets.only(
        top: 20.h,
        left: 14,
        right: 14,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              _buildMainPicture(),
              15.verticalSpace,
              _buildForgotPasswordTitle(),
              20.verticalSpace,
              _buildForgotPasswordDescription(),
              30.verticalSpace,
              _buildTextField(),
              20.verticalSpace,
            ],
          ),
        ],
      ),
    );
  }

  Text _buildForgotPasswordDescription() {
    return Text(
      S.current.forgotPasswordDescription,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: AppFonts.latoFont,
        fontSize: 17.sp,
        fontWeight: FontWeight.w500,
        color: AppColor.black,
      ),
    );
  }

  Text _buildForgotPasswordTitle() {
    return Text(
      S.current.forgotPassword,
      style: TextStyle(
        fontFamily: AppFonts.latoFont,
        fontSize: 28.sp,
        fontWeight: FontWeight.w900,
        color: AppColor.black,
      ),
    );
  }

  SvgPicture _buildMainPicture() {
    return SvgPicture.asset(
      coins,
      height: 155.h,
      width: 256.w,
    );
  }

  BlocBuilder<ForgotPasswordBloc, ForgotPasswordState> _buildTextField() {
    return BlocBuilder<ForgotPasswordBloc, ForgotPasswordState>(
      builder: (context, state) {
        final String? emailErrorText =
            (state.isEmailValid ?? true) ? null : S.current.emailError;
        return CraftboxTextField(
          leadingTitle: S.current.email,
          hint: S.current.emailHint,
          errorText: emailErrorText,
          hasFocus: () {
            context.read<ForgotPasswordBloc>().add(EmailFieldFocused());
          },
          onEditingComplete: (value) {
            context.read<ForgotPasswordBloc>().add(EmailChanged(email: value));
          },
        );
      },
    );
  }

  Builder _buildBottomButton() {
    return Builder(builder: (context) {
      return Padding(
        padding: const EdgeInsets.only(
          top: 60,
          left: 14,
          right: 14,
          bottom: 30,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CraftboxBigButton(
              onPressed: () {
                context.read<ForgotPasswordBloc>().add(EmailSubmitted());
              },
              title: S.current.submit,
            ),
          ],
        ),
      );
    });
  }
}