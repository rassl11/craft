import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share_plus/share_plus.dart';

import '../../generated/l10n.dart';
import '../common/widgets/craftbox_app_bar.dart';
import '../constants/theme/colors.dart';
import '../constants/theme/fonts.dart';
import '../constants/theme/images.dart';

class MediaViewer extends StatefulWidget {
  static const routeName = '/viewer';

  const MediaViewer({Key? key}) : super(key: key);

  @override
  State<MediaViewer> createState() => _MediaViewerState();
}

class _MediaViewerState extends State<MediaViewer> {
  late PhotoViewScaleState _scaleState;
  late PhotoViewScaleStateController _scaleStateController;

  @override
  void initState() {
    _scaleState = PhotoViewScaleState.initial;
    _scaleStateController = PhotoViewScaleStateController()
      ..outputScaleStateStream.listen(onScaleState);
    super.initState();
  }

  // ignore: use_setters_to_change_properties
  void onScaleState(PhotoViewScaleState scaleState) {
    _scaleState = scaleState;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MediaArgs;

    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: CraftboxAppBar(
        title: args.title,
        backgroundColor: AppColor.white,
        leadingIconPath: arrowLeft,
        onLeadingIconPressed: () {
          if (_scaleState == PhotoViewScaleState.zoomedIn) {
            _scaleStateController.scaleState = PhotoViewScaleState.initial;
            Navigator.of(context).pop();
          } else {
            Navigator.of(context).pop();
          }
        },
        actions: [
          IconButton(
            onPressed: () {
              final box = context.findRenderObject() as RenderBox?;
              Share.shareXFiles(
                [XFile(args.file.path)],
                sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size,
              );
            },
            icon: SvgPicture.asset(share, height: 24, width: 24),
          ),
        ],
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: AppColor.white,
        child: PhotoView(
          minScale: PhotoViewComputedScale.contained * 0.8,
          scaleStateController: _scaleStateController,
          errorBuilder: (context, object, stackTrace) {
            return Center(
              child: Text(
                S.current.documentLoadingError,
                style: TextStyle(
                  fontSize: 17.sp,
                  fontFamily: AppFonts.latoFont,
                  fontWeight: FontWeight.w700,
                  color: AppColor.black,
                ),
              ),
            );
          },
          imageProvider: FileImage(args.file),
          backgroundDecoration: const BoxDecoration(
            color: AppColor.white,
          ),
          customSize: MediaQuery.of(context).size * 0.92,
          basePosition: const Alignment(0, -0.2),
          loadingBuilder: (context, event) {
            if (event == null) {
              return Center(
                child: Text(
                  S.current.loading,
                  style: const TextStyle(
                    fontSize: 17,
                    fontFamily: AppFonts.latoFont,
                    fontWeight: FontWeight.w700,
                    color: AppColor.darkGray,
                  ),
                ),
              );
            }

            final value = event.cumulativeBytesLoaded /
                (event.expectedTotalBytes ?? event.cumulativeBytesLoaded);

            final percentage = (100 * value).floor();
            return Center(
              child: Text(
                '$percentage%',
                style: const TextStyle(
                  fontSize: 17,
                  fontFamily: AppFonts.latoFont,
                  fontWeight: FontWeight.w700,
                  color: AppColor.darkGray,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scaleStateController.dispose();
    super.dispose();
  }
}

class MediaArgs {
  final File file;
  final String title;

  const MediaArgs({
    required this.file,
    required this.title,
  });
}
