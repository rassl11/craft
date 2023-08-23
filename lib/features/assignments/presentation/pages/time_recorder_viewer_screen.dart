import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/blocs/status.dart';
import '../../../../core/common/widgets/craftbox_app_bar.dart';
import '../../../../core/common/widgets/craftbox_author_info.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/dialog_provider.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../generated/l10n.dart';
import '../../../protocol/presentation/cubits/note/note_cubit.dart';
import '../../domain/entities/creation.dart';
import '../../domain/entities/recorded_time.dart';
import '../widgets/recorded_time_so_far.dart';

class TimeRecordsViewerScreen extends StatelessWidget {
  static const routeName = '/timeRecorderViewer';

  const TimeRecordsViewerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as TimeRecorderViewerScreenArgs;

    return BlocProvider(
      create: (context) => sl<NoteCubit>(),
      child: BlocConsumer<NoteCubit, NoteState>(
        listener: (context, state) {
          switch (state.cubitStatus) {
            case Status.error:
              showColorfulSnackBar(
                context,
                backgroundColor: AppColor.red500,
                text: S.current.somethingWentWrong,
                emojiType: EmojiType.error,
              );
              break;
            case Status.loaded:
              Navigator.of(context).pop(true);
              break;
            default:
              break;
          }
        },
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColor.background,
            appBar: CraftboxAppBar(
              title: S.current.timeRecorderAppBarTitle,
              leadingIconPath: arrowLeft,
              actions: _getActions(args, context),
            ),
            body: _buildBody(
              context: context,
              args: args,
              state: state,
            ),
          );
        },
      ),
    );
  }

  List<Widget> _getActions(
    TimeRecorderViewerScreenArgs args,
    BuildContext context,
  ) {
    if (args.isSigned) {
      return [];
    }

    return [
      _buildDeleteButton(
        context,
        args.documentationId,
      ),
    ];
  }

  SizedBox _buildBody({
    required BuildContext context,
    required TimeRecorderViewerScreenArgs args,
    required NoteState state,
  }) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: _buildScrollableLayerWithLoadingIndicator(
          context: context,
          args: args,
          state: state,
        ),
      ),
    );
  }

  List<Widget> _buildScrollableLayerWithLoadingIndicator({
    required BuildContext context,
    required TimeRecorderViewerScreenArgs args,
    required NoteState state,
  }) {
    final widgetList = [
      _buildScrollableLayer(
        context: context,
        args: args,
      ),
    ];

    if (state.cubitStatus == Status.loading) {
      widgetList.add(
        buildLoadingIndicator(),
      );
    }

    return widgetList;
  }

  Widget _buildScrollableLayer({
    required BuildContext context,
    required TimeRecorderViewerScreenArgs args,
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            30.verticalSpace,
            RecordedTimeSoFar(totalTimeRecorded: args.totalTimeRecorded),
            30.verticalSpace,
            ..._buildTimeFields(
              context: context,
              args: args,
            ),
            30.verticalSpace,
            _buildFooter(
              context: context,
              causer: args.causer,
              updatedAt: args.updatedAt,
            ),
          ],
        ),
      ),
    );
  }

  CraftboxAuthorInfo _buildFooter({
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

  List<Widget> _buildTimeFields({
    required BuildContext context,
    required TimeRecorderViewerScreenArgs args,
  }) {
    return [
      _buildTimeText(
        title: S.current.workingTime,
        time: CraftboxDateTimeUtils.formatTime(
          args.currentTimeRecorded.workingTime,
        ),
      ),
      20.verticalSpace,
      _buildTimeText(
        title: S.current.breakTime,
        time: CraftboxDateTimeUtils.formatTime(
          args.currentTimeRecorded.breakTime,
        ),
      ),
      20.verticalSpace,
      _buildTimeText(
        title: S.current.drivingTime,
        time: CraftboxDateTimeUtils.formatTime(
          args.currentTimeRecorded.drivingTime,
        ),
      ),
      20.verticalSpace,
      _buildAttachmentText(
        text: args.attachment,
      ),
    ];
  }

  Widget _buildAttachmentText({
    required String text,
  }) {
    return text != ''
        ? Text(
            text,
            style: TextStyle(
              fontFamily: AppFonts.latoFont,
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.black,
            ),
          )
        : const SizedBox.shrink();
  }

  Widget _buildTimeText({
    required String time,
    required String title,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 7).h,
          child: Text(
            title,
            style: TextStyle(
              fontFamily: AppFonts.latoFont,
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 7).h,
          child: Text(
            time,
            style: TextStyle(
              fontFamily: AppFonts.latoFont,
              fontSize: 17.sp,
              fontWeight: FontWeight.w700,
              color: AppColor.black,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDeleteButton(
    BuildContext context,
    int documentationId,
  ) {
    return IconButton(
        onPressed: () {
          _handleOnDeleteTapped(
            context,
            documentationId,
          );
        },
        icon: getFaIcon(
          CraftboxIcon.delete,
          color: AppColor.orange,
          height: 24,
        ));
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
        context.read<NoteCubit>().delete(
              documentationId: documentationId,
            );
        Navigator.pop(context);
      },
      negativeButtonTitle: S.current.cancel,
      negativeButtonAction: () {
        Navigator.pop(context);
      },
    );
  }
}

class TimeRecorderViewerScreenArgs {
  final int assignmentId;
  final int documentationId;
  final RecordedTime totalTimeRecorded;
  final RecordedTime currentTimeRecorded;
  final String attachment;
  final Causer? causer;
  final DateTime? updatedAt;
  final bool isSigned;

  const TimeRecorderViewerScreenArgs({
    required this.assignmentId,
    required this.documentationId,
    required this.totalTimeRecorded,
    required this.currentTimeRecorded,
    required this.attachment,
    required this.causer,
    required this.updatedAt,
    required this.isSigned,
  });
}
