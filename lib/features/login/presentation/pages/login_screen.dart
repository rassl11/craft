import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/craftbox_app_bar.dart';
import '../../../../core/common/widgets/craftbox_big_button.dart';
import '../../../../core/common/widgets/craftbox_text_field.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/utils/dialog_provider.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../generated/l10n.dart';
import '../../../assignments/presentation/pages/assignments_home_screen.dart';
import '../blocs/login/login_bloc.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatelessWidget {
  static const routeName = '/login';

  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: CraftboxAppBar(
        title: S.current.launchLogin,
        leadingIconPath: arrowLeft,
      ),
      body: BlocProvider(
        create: (context) => sl<LoginBloc>(),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      _buildLogo(),
                      _buildForm(context),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.only(top: 35, bottom: 35).r,
      height: 135.r,
      child: Image.asset(craftboxLogoHead),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Expanded(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 30.h,
        ),
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(17.r),
            topRight: Radius.circular(17.r),
          ),
        ),
        child: BlocConsumer<LoginBloc, LoginState>(
          listener: (context, state) {
            if (state.termsState == TermsState.dialogCalled) {
              _showTermDialog(context);
            }

            _handleLoginStatus(context, state);
          },
          builder: (builderContext, state) {
            return Column(
              children: [
                _buildCredentialsFields(builderContext, state),
                _buildSwitcherWithText(builderContext, state),
                30.verticalSpace,
                CraftboxBigButton(
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    Future.delayed(const Duration(milliseconds: 100), () {
                      context.read<LoginBloc>().add(LoginSubmitted());
                    });
                  },
                  title: S.current.launchLogin,
                ),
                30.verticalSpace,
                _buildFooter(),
              ],
            );
          },
        ),
      ),
    );
  }

  void _showTermDialog(BuildContext context) {
    sl<DialogProvider>().showPlatformSpecificDialog(
      builderContext: context,
      title: S.current.termsDialogTitle,
      content: S.current.termsDialogContent,
      positiveButtonTitle: S.current.termsDialogPositive,
      positiveButtonAction: () {
        context.read<LoginBloc>().add(LoginTermsAccepted());
        Navigator.pop(context);
      },
      negativeButtonTitle: S.current.cancel,
      negativeButtonAction: () {
        context.read<LoginBloc>().add(LoginTermsRejected());
        Navigator.pop(context);
      },
    );
  }
}

void _handleLoginStatus(BuildContext context, LoginState state) {
  switch (state.loginStatus) {
    case LoginStatus.loading:
      showSnackBarWithText(context, S.current.indicatorLoggingIn);
      break;
    case LoginStatus.success:
      hideSnackBar(context);
      Navigator.pushNamedAndRemoveUntil(
        context,
        AssignmentsHomeScreen.routeName,
        (route) => false,
      );
      break;
    case LoginStatus.failure:
      showSnackBarWithText(
        context,
        state.errorMessage ?? S.current.indicatorUnknownError,
      );
      break;
    default:
      break;
  }
}

Widget _buildCredentialsFields(BuildContext context, LoginState state) {
  return SizedBox(
    width: double.infinity,
    child: Column(
      children: [
        buildLoginTextField(context, state),
        15.verticalSpace,
        _buildPasswordTextField(context, state),
        _buildForgotPasswordButton(context),
      ],
    ),
  );
}

CraftboxTextField buildLoginTextField(BuildContext context, LoginState state) {
  final emailErrorText =
      (state.isUsernameValid ?? true) ? null : S.current.emailError;

  return CraftboxTextField(
    leadingTitle: S.current.email,
    hint: S.current.emailHint,
    errorText: emailErrorText,
    inputAction: TextInputAction.next,
    hasFocus: () {
      context.read<LoginBloc>().add(LoginFieldFocused());
    },
    onEditingComplete: (value) {
      context.read<LoginBloc>().add(
            LoginUsernameChanged(username: value),
          );
    },
  );
}

Widget _buildPasswordTextField(
  BuildContext context,
  LoginState state,
) {
  final passwordErrorText =
      (state.isPasswordValid ?? true) ? null : S.current.passwordError;

  return CraftboxTextField(
    leadingTitle: S.current.password,
    hint: S.current.passwordHint,
    errorText: passwordErrorText,
    inputAction: TextInputAction.done,
    hasFocus: () {
      context.read<LoginBloc>().add(PasswordFieldFocused());
    },
    passwordFieldData: PasswordFieldData(
      isPasswordVisible: state.isPasswordVisible,
      visibilityIcon: _getEyeIcon(state.isPasswordVisible, context),
    ),
    onEditingComplete: (value) {
      context.read<LoginBloc>().add(
            LoginPasswordChanged(password: value),
          );
    },
  );
}

Row _buildSwitcherWithText(BuildContext context, LoginState state) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Flexible(
        child: Text(
          maxLines: 2,
          S.current.termsSwitcherText,
          style: TextStyle(
            fontFamily: AppFonts.latoFont,
            fontSize: 15.sp,
            fontWeight: FontWeight.w500,
            color: AppColor.gray900,
          ),
        ),
      ),
      Container(
        alignment: Alignment.topRight,
        child: CupertinoSwitch(
          value: state.termsState == TermsState.accepted,
          onChanged: (value) {
            context.read<LoginBloc>().add(LoginSwitcherToggled());
          },
        ),
      ),
    ],
  );
}

IconButton _getEyeIcon(bool isPasswordVisible, BuildContext context) {
  return IconButton(
    onPressed: () {
      context.read<LoginBloc>().add(LoginPasswordVisibilityToggled());
    },
    icon: Icon(
      isPasswordVisible ? Icons.visibility : Icons.visibility_off,
      color: AppColor.gray900,
    ),
  );
}

Container _buildForgotPasswordButton(BuildContext context) {
  return Container(
    alignment: Alignment.topRight,
    width: double.infinity,
    padding: const EdgeInsets.only(bottom: 20).h,
    child: TextButton(
      onPressed: () {
        Navigator.pushNamed(
          context,
          ForgotPasswordScreen.routeName,
        );
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 10).h,
      ),
      child: Text(
        S.current.forgotPasswordQ,
        textAlign: TextAlign.end,
        style: TextStyle(
          fontFamily: AppFonts.latoFont,
          fontSize: 17.sp,
          color: AppColor.orange,
        ),
      ),
    ),
  );
}

Text _buildFooter() {
  return Text(
    textAlign: TextAlign.center,
    S.current.loginPageFooterText,
    style: TextStyle(
      fontFamily: AppFonts.latoFont,
      fontSize: 11.sp,
      fontWeight: FontWeight.w400,
      color: AppColor.gray900,
    ),
  );
}
