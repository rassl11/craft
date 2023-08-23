import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/injection_container.dart';
import '../../../../generated/l10n.dart';
import '../cubits/camera/camera_cubit.dart';
import '../cubits/camera/camera_state.dart';
import 'photo_screen.dart';

class CameraScreen extends StatefulWidget {
  static const routeName = '/camera';

  final List<CameraDescription> cameras;
  final List<String> currentImages;
  final List<String> currentHints;
  final int assignmentId;

  const CameraScreen({
    super.key,
    required this.cameras,
    required this.currentImages,
    required this.currentHints,
    required this.assignmentId,
  });

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _initializeCamera(widget.cameras[0]);
  }

  Future<void> _initializeCamera(CameraDescription camera) async {
    _controller = CameraController(
      camera,
      ResolutionPreset.max,
      enableAudio: false,
    );
    _initializeControllerFuture = _controller.initialize();
  }

  Future<void> _getImageFromCamera(BuildContext context) async {
    try {
      await _initializeControllerFuture;
      final image = await _controller.takePicture();
      if (context.mounted) {
        context.read<CameraCubit>().addImages([image.path]);
      }
    } catch (e) {
      log('Error taking picture: $e');
    }
  }

  Future<void> _getImageFromGallery(BuildContext context) async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage(imageQuality: 100);
    if (context.mounted) {
      context.read<CameraCubit>().addImages(pickedImages.map((e) => e.path));
    }
  }

  Future<void> _navigateToPhotoScreen(
    List<String> images,
    List<String> hints,
  ) async {
    if (!mounted) {
      return;
    }

    if (widget.currentImages.isEmpty) {
      final result = await _navigateToPhotoScreenWithArguments(images, hints);
      if (result != null && context.mounted) {
        Navigator.of(context).pop(result);
      }
    } else {
      Navigator.of(context).pop(
        PhotoArgs(
          assignmentId: widget.assignmentId,
          photos: images,
          hints: hints,
          isEditMode: false,
        ),
      );
    }
  }

  Future<bool?> _navigateToPhotoScreenWithArguments(
    List<String> images,
    List<String> hints,
  ) async {
    return await Navigator.of(context).pushNamed(
      PhotoScreen.routeName,
      arguments: PhotoArgs(
        assignmentId: widget.assignmentId,
        photos: images,
        hints: hints,
        isEditMode: false,
      ),
    ) as bool?;
  }

  void _onBackButtonPressed() {
    if (widget.currentHints.isEmpty || widget.currentImages.isEmpty) {
      Navigator.of(context).pop(false);
    } else {
      Navigator.of(context).pop(PhotoArgs(
        assignmentId: widget.assignmentId,
        photos: widget.currentImages,
        hints: widget.currentHints,
        isEditMode: false,
      ));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = ScreenUtil().statusBarHeight;

    return BlocProvider(
      create: (context) => sl<CameraCubit>(),
      child: BlocBuilder<CameraCubit, CameraState>(
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              _onBackButtonPressed();
              return true;
            },
            child: Scaffold(
              body: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    _buildCamera(),
                    _buildCloseButton(statusBarHeight),
                    _buildFlashContainer(
                      context,
                      state,
                      statusBarHeight,
                    ),
                    _buildStatusBarArea(statusBarHeight),
                    _buildDoneContainer(
                      hasImages: state.localImages.isNotEmpty,
                      state,
                    ),
                    _buildFooter(
                      context,
                      state,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Positioned _buildFooter(
    BuildContext context,
    CameraState state,
  ) {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        color: Colors.black,
        child: Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildGalleryButton(context),
              _buildTakePictureButton(context),
              _buildRotateButton(
                context,
                state,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Positioned _buildStatusBarArea(double statusBarHeight) {
    return Positioned(
      left: 0,
      right: 0,
      top: 0,
      child: Container(
        color: Colors.black,
        height: statusBarHeight,
      ),
    );
  }

  Positioned _buildCloseButton(double statusBarHeight) {
    return Positioned(
      top: statusBarHeight + 8,
      left: 8,
      child: IconButton(
        icon: const Icon(Icons.close, size: 24, color: Colors.white),
        onPressed: _onBackButtonPressed,
      ),
    );
  }

  Widget _buildFlashContainer(
    BuildContext context,
    CameraState state,
    double statusBarHeight,
  ) {
    return Positioned(
      top: statusBarHeight + 8,
      child: GestureDetector(
        onTap: () async {
          await _handleOnFlashTapped(context, state);
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColor.gray700,
            borderRadius: BorderRadius.circular(8),
          ),
          height: 42.h,
          child: Row(
            children: [
              _buildFlashImage(state),
              4.horizontalSpace,
              _buildFlashText(state),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _handleOnFlashTapped(
    BuildContext context,
    CameraState state,
  ) async {
    context.read<CameraCubit>().changeFlashState();
    await _controller.setFlashMode(
      state.isFlashEnabled ? FlashMode.torch : FlashMode.off,
    );
  }

  FutureBuilder<void> _buildCamera() {
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (_controller.value.isInitialized) {
            return _buildCameraWidget(context);
          } else {
            return _buildLoadingIndicator();
          }
        } else {
          return _buildLoadingIndicator();
        }
      },
    );
  }

  Widget _buildDoneContainer(
    CameraState state, {
    required bool hasImages,
  }) {
    if (hasImages) {
      return Positioned(
        right: 16.w,
        bottom: 148.h,
        child: GestureDetector(
          onTap: () => _handleOnDoneTap(state),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(14),
            ),
            height: 48,
            child: Row(
              children: [
                _buildSmallImageContainer(state),
                10.horizontalSpace,
                _buildDoneText(),
              ],
            ),
          ),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }

  void _handleOnDoneTap(CameraState state) {
    final List<String> images = List.from(widget.currentImages)
      ..addAll(state.localImages);
    final List<String> hints = List.from(widget.currentHints)
      ..addAll(state.localImages.map(path.basename));

    _navigateToPhotoScreen(images, hints);
  }

  Padding _buildDoneText() {
    return Padding(
      padding: EdgeInsets.only(right: 20.w),
      child: Text(
        S.current.done,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontFamily: AppFonts.latoFont,
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    );
  }

  Padding _buildFlashText(
    CameraState state,
  ) {
    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: Text(
        state.isFlashEnabled ? S.current.on : S.current.off,
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontFamily: AppFonts.latoFont,
          color: Colors.white,
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _buildFlashImage(
    CameraState state,
  ) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Icon(
        state.isFlashEnabled ? Icons.flash_off : Icons.flash_on,
        size: 24,
        color: Colors.white,
      ),
    );
  }

  Padding _buildSmallImageContainer(CameraState state) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: AppColor.white,
            width: 2,
          ),
          image: DecorationImage(
            image: FileImage(File(state.localImages.last)),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Text(
            '${state.localImages.length}',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontFamily: AppFonts.latoFont,
              color: Colors.white,
              fontSize: 17,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCameraWidget(BuildContext context) {
    final camera = _controller.value;
    final size = MediaQuery.of(context).size;
    var scale = size.aspectRatio * camera.aspectRatio;
    if (scale < 1) {
      scale = 1 / scale;
    }

    return Transform.scale(
      scale: scale,
      child: Center(
        child: CameraPreview(_controller),
      ),
    );
  }

  Widget _buildRotateButton(
    BuildContext context,
    CameraState state,
  ) {
    return InkWell(
      onTap: () => {
        context.read<CameraCubit>().changeCameraState(),
        _initializeCamera(widget.cameras[state.isRearCameraSelected ? 0 : 1])
      },
      child: SvgPicture.asset(rotate),
    );
  }

  Widget _buildTakePictureButton(BuildContext context) {
    return InkWell(
      customBorder: const CircleBorder(),
      onTap: () => _getImageFromCamera(context),
      child: SvgPicture.asset(takePhoto),
    );
  }

  Widget _buildGalleryButton(BuildContext context) {
    return InkWell(
      onTap: () => _getImageFromGallery(context),
      child: SvgPicture.asset(gallery),
    );
  }

  Widget _buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
