import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:signature/signature.dart';

import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../generated/l10n.dart';
import '../cubits/signature/signature_cubit.dart';

class CraftboxSignatureCanvas extends StatefulWidget {
  final SignatureController _signatureController;

  const CraftboxSignatureCanvas({
    super.key,
    required SignatureController signatureController,
  }) : _signatureController = signatureController;

  @override
  State<CraftboxSignatureCanvas> createState() =>
      _CraftboxSignatureCanvasState();
}

class _CraftboxSignatureCanvasState extends State<CraftboxSignatureCanvas> {
  @override
  void initState() {
    super.initState();
    widget._signatureController.onDrawStart = () {
      context.read<SignatureCubit>().startDrawing();
    };
    widget._signatureController.onDrawEnd = () {
      context.read<SignatureCubit>().stopDrawing();
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignatureCubit, SignatureCubitState>(
      builder: (context, state) {
        if (state is Initial) {
          return Stack(
            children: [
              _buildPenIcon(),
              _buildSignatureCanvas(),
            ],
          );
        }

        if (state is DrawingStarted) {
          return Stack(
            children: [
              _buildSignatureCanvas(),
            ],
          );
        }

        return Stack(
          children: [
            _buildSignatureCanvas(),
            _buildClearButton(),
          ],
        );
      },
    );
  }

  ClipRRect _buildSignatureCanvas() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Signature(
        controller: widget._signatureController,
        backgroundColor: AppColor.transparent,
      ),
    );
  }

  Align _buildPenIcon() {
    return Align(
      child: SizedBox(
        height: 36,
        width: 36,
        child: getFaIcon(CraftboxIcon.penLine),
      ),
    );
  }

  Align _buildClearButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: GestureDetector(
        onTap: () {
          widget._signatureController.clear();
          context.read<SignatureCubit>().clear();
        },
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              getFaIcon(
                CraftboxIcon.arrowRotateLeft,
                color: AppColor.accent400,
              ),
              const SizedBox(width: 4),
              Text(
                S.current.clear,
                style: const TextStyle(
                  color: AppColor.accent400,
                  fontSize: 17,
                  fontFamily: AppFonts.latoFont,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
