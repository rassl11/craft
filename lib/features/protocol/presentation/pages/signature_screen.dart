import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signature/signature.dart';

import '../../../../core/common/widgets/craftbox_app_bar.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/injection_container.dart';
import '../../../../generated/l10n.dart';
import '../cubits/signature/signature_cubit.dart';
import '../widgets/craftbox_signature_canvas.dart';
import '../widgets/protocol_utils.dart';

class SignatureScreen extends StatefulWidget {
  static const routeName = '/signature';

  const SignatureScreen({super.key});

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final SignatureController _signatureController = SignatureController(
    strokeJoin: StrokeJoin.round,
    strokeCap: StrokeCap.round,
  );

  @override
  void initState() {
    super.initState();
    final List<DeviceOrientation> orientation;
    if (Platform.isIOS) {
      orientation = [DeviceOrientation.landscapeRight];
    } else {
      orientation = [DeviceOrientation.landscapeLeft];
    }

    SystemChrome.setPreferredOrientations(orientation);
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as SignatureArgs;

    return BlocProvider(
      create: (context) => sl<SignatureCubit>(),
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: _buildAppBar(args, context),
        body: _buildSignatureCanvas(),
      ),
    );
  }

  CraftboxAppBar _buildAppBar(SignatureArgs args, BuildContext context) {
    return CraftboxAppBar(
      title: args.title,
      leadingIconPath: arrowLeft,
      onLeadingIconPressed: () async {
        if (_signatureController.isNotEmpty) {
          showPopConfirmationDialog(context, () async {
            Navigator.of(context).pop();
            await _revertOrientationAndPop(context);
          });
        } else {
          await _revertOrientationAndPop(context);
        }
      },
      actions: [_buildDoneButton(context)],
    );
  }

  TextButton _buildDoneButton(BuildContext context) {
    return TextButton(
      onPressed: () async {
        final pngBytes = await _signatureController.toPngBytes();
        if (context.mounted) {
          await _revertOrientationAndPop(context, signature: pngBytes);
        }
      },
      child: Text(
        S.current.filterDone,
        style: const TextStyle(
          color: AppColor.accent400,
          fontSize: 17,
        ),
      ),
    );
  }

  Builder _buildSignatureCanvas() {
    return Builder(builder: (context) {
      return Container(
        height: double.infinity,
        width: double.infinity,
        margin: const EdgeInsets.all(16),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2),
        ),
        child: CraftboxSignatureCanvas(
          signatureController: _signatureController,
        ),
      );
    });
  }

  Future<void> _revertOrientationAndPop(
    BuildContext context, {
    Uint8List? signature,
  }) async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);

    if (context.mounted) {
      Navigator.of(context).pop(signature);
    }
  }

  @override
  void dispose() {
    _signatureController.dispose();

    super.dispose();
  }
}

class SignatureArgs {
  final String title;

  SignatureArgs(this.title);
}
