import 'dart:io';

import 'package:camera/camera.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/blocs/status.dart';
import '../../../../core/common/widgets/craftbox_app_bar.dart';
import '../../../../core/common/widgets/craftbox_bottom_sheet.dart';
import '../../../../core/common/widgets/craftbox_text_field.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../generated/l10n.dart';
import '../cubits/photo/photo_cubit.dart';
import '../cubits/photo/photo_state.dart';
import '../widgets/protocol_utils.dart';
import 'camera_screen.dart';

class PhotoScreen extends StatelessWidget {
  static const routeName = '/photo';

  const PhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final photoArgs = ModalRoute.of(context)!.settings.arguments as PhotoArgs;

    return BlocProvider(
      create: (context) => sl<PhotoCubit>()
        ..addImages(
          photoArgs.photos,
          photoArgs.hints,
          hasChanges: !photoArgs.isEditMode,
        ),
      child: BlocConsumer<PhotoCubit, PhotoState>(
        listener: (context, state) {
          if (state.cubitStatus == Status.loaded) {
            Navigator.of(context).pop(true);
            return;
          }

          if (state.photosPath.isEmpty) {
            Navigator.of(context).pop(false);
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
        },
        builder: (context, state) {
          return WillPopScope(
            onWillPop: () async {
              Navigator.of(context).pop(false);
              return true;
            },
            child: Scaffold(
              backgroundColor: AppColor.background,
              appBar: _buildAppBar(
                context: context,
                photoArgs: photoArgs,
                state: state,
              ),
              body: _buildBody(
                context: context,
                photoArgs: photoArgs,
                state: state,
              ),
              bottomNavigationBar: _buildBottomSheet(
                photoArgs: photoArgs,
                state: state,
                assignmentId: photoArgs.assignmentId,
              ),
            ),
          );
        },
      ),
    );
  }

  PreferredSize _buildAppBar({
    required BuildContext context,
    required PhotoArgs photoArgs,
    required PhotoState state,
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Builder(builder: (context) {
        return CraftboxAppBar(
          title: S.current.photo,
          leadingIconPath: arrowLeft,
          onLeadingIconPressed: () {
            if (state.hasChanges) {
              showPopConfirmationDialog(context, () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(false);
              });
            } else {
              Navigator.of(context).pop(false);
            }
          },
        );
      }),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required PhotoArgs photoArgs,
    required PhotoState state,
  }) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleTextField(
                context: context,
                state: state,
              ),
              _buildPhotoListWithPadding(
                state,
                context,
              ),
              12.verticalSpace,
              _buildBottomText(state),
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
    );
  }

  Widget _buildBottomText(PhotoState state) {
    return state.photosPath.isNotEmpty
        ? Center(
            child: Text(
              '${state.selectedImageIndex + 1} of ${state.photosPath.length}',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 17.sp,
              ),
            ),
          )
        : const SizedBox.shrink();
  }

  Padding _buildPhotoListWithPadding(
    PhotoState state,
    BuildContext context,
  ) {
    return Padding(
      padding: state.photosPath.length > 1
          ? const EdgeInsets.only(left: 16)
          : const EdgeInsets.symmetric(horizontal: 16),
      child: _buildPhotoList(
        context: context,
        state: state,
      ),
    );
  }

  Widget _buildTitleTextField({
    required BuildContext context,
    required PhotoState state,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      child: CraftboxTextField(
        leadingTitle: S.current.title,
        hint: S.current.enterYourTitle,
        text: state.photosPath.isNotEmpty
            ? state.hints[state.selectedImageIndex]
            : ' ',
        onChanged: (value) {
          context.read<PhotoCubit>().changeHint(value);
        },
      ),
    );
  }

  Widget _buildPhotoList({
    required BuildContext context,
    required PhotoState state,
  }) {
    if (state.photosPath.length == 1) {
      final String imagePath = state.photosPath[0];
      ImageProvider imageProvider;

      if (File(imagePath).existsSync()) {
        imageProvider = FileImage(File(imagePath));
      } else {
        imageProvider = NetworkImage(imagePath);
      }

      return Stack(
        children: [
          Container(
            width: double.maxFinite,
            height: 386.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              border: Border.all(
                width: 2,
              ),
              image: DecorationImage(
                image: imageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          _buildDeletePhotoButton(context, 0, 8)
        ],
      );
    }

    return CarouselSlider.builder(
      itemCount: state.photosPath.length,
      itemBuilder: (context, index, realIndex) {
        final imagePath = state.photosPath[index];
        return Stack(
          children: [
            _buildPhoto(imagePath),
            _buildDeletePhotoButton(context, index, 24),
          ],
        );
      },
      options: CarouselOptions(
        height: 386.h,
        enableInfiniteScroll: false,
        viewportFraction: 0.85,
        padEnds: false,
        onPageChanged: (index, _) {
          context.read<PhotoCubit>().changeCurrentPhotoListIndex(index);
        },
      ),
    );
  }

  Positioned _buildDeletePhotoButton(
    BuildContext context,
    int index,
    double rightPadding,
  ) {
    return Positioned(
      top: 8,
      right: rightPadding,
      child: InkWell(
        onTap: () {
          context.read<PhotoCubit>().removeImage();
        },
        child: SvgPicture.asset(delete),
      ),
    );
  }

  Padding _buildPhoto(String imagePath) {
    ImageProvider imageProvider;

    if (File(imagePath).existsSync()) {
      imageProvider = FileImage(File(imagePath));
    } else {
      imageProvider = NetworkImage(imagePath);
    }

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            width: 2,
          ),
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildBottomSheet({
    required PhotoArgs photoArgs,
    required PhotoState state,
    required int assignmentId,
  }) {
    return Builder(builder: (context) {
      return CraftboxBottomSheet(
        secondButtonTitle: S.current.newPhoto,
        buttonTitle: S.current.save,
        outlinedButtonIcon: plus,
        onSecondButtonPressed: () async {
          await _addNewPhotos(
            context,
            state,
            assignmentId,
            isEditMode: photoArgs.isEditMode,
          );
        },
        onButtonPressed: () {
          context.read<PhotoCubit>().uploadImages(assignmentId);
        },
      );
    });
  }

  Future<void> _addNewPhotos(
    BuildContext context,
    PhotoState state,
    int assignmentId, {
    required bool isEditMode,
  }) async {
    final cameras = await availableCameras();
    if (context.mounted) {
      final res = await Navigator.push(
        context,
        MaterialPageRoute(
          settings: const RouteSettings(),
          builder: (_) => CameraScreen(
            cameras: cameras,
            currentImages: state.photosPath,
            currentHints: state.hints,
            assignmentId: assignmentId,
          ),
        ),
      ) as PhotoArgs?;
      if (context.mounted) {
        context.read<PhotoCubit>().addImages(
              res?.photos ?? List.empty(),
              res?.hints ?? List.empty(),
              hasChanges: state.hasChanges || isEditMode,
            );
      }
    }
  }
}

class PhotoArgs {
  final int assignmentId;
  final List<String> photos;
  final List<String> hints;
  final bool isEditMode;

  const PhotoArgs({
    required this.assignmentId,
    required this.photos,
    required this.hints,
    required this.isEditMode,
  });
}
