import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/blocs/status.dart';
import '../../../../core/common/widgets/craftbox_app_bar.dart';
import '../../../../core/common/widgets/craftbox_bottom_sheet.dart';
import '../../../../core/common/widgets/craftbox_project_time_picker.dart';
import '../../../../core/common/widgets/craftbox_text_field.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/dialog_provider.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../generated/l10n.dart';
import '../../domain/entities/recorded_time.dart';
import '../cubits/documentation/create_documentation_cubit.dart';
import '../cubits/time_picker/time_picker_cubit.dart';
import '../widgets/recorded_time_so_far.dart';

class TimeRecordsScreen extends StatelessWidget {
  static const routeName = '/timeRecorder';

  const TimeRecordsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as TimeRecorderScreenArgs;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => sl<TimePickerCubit>(),
        ),
        BlocProvider(
          create: (context) => sl<CreateDocumentationCubit>(),
        ),
      ],
      child: BlocListener<CreateDocumentationCubit, CreateDocumentationState>(
        listener: (context, state) {
          switch (state.blocStatus) {
            case Status.error:
              showSnackBarWithText(context, state.errorMsg);
              break;
            case Status.loaded:
              if (args.openedFromProtocolDialog) {
                Navigator.of(context).pop(true);
              } else {
                Navigator.of(context)
                  ..pop(true)
                  ..pop(true);
              }
              break;
            default:
              break;
          }
        },
        child: Builder(builder: (context) {
          final timePickerState = context.watch<TimePickerCubit>().state;
          final createDocumentationState =
              context.watch<CreateDocumentationCubit>().state;
          return Scaffold(
            backgroundColor: AppColor.background,
            appBar: CraftboxAppBar(
              title: S.current.timeRecorderAppBarTitle,
              leadingIconPath: arrowLeft,
              onLeadingIconPressed: () {
                _showAccidentalExitDialogIfNeeded(timePickerState, context);
              },
            ),
            body: _buildBody(
              context: context,
              createDocumentationState: createDocumentationState,
              timePickerState: timePickerState,
              args: args,
            ),
            bottomNavigationBar: _buildBottomSheet(
              context: context,
              args: args,
              timePickerState: timePickerState,
            ),
          );
        }),
      ),
    );
  }

  void _showAccidentalExitDialogIfNeeded(
    TimePickerState timePickerState,
    BuildContext context,
  ) {
    bool dialogShown = false;
    timePickerState.timeRecords.forEach((key, value) {
      if (value != null && value.duration > Duration.zero) {
        dialogShown = true;
        sl<DialogProvider>().showAccidentalExitTimeDialog(
          builderContext: context,
          onStay: () {},
          onDiscard: () {
            Navigator.of(context).pop();
          },
        );
        return;
      }
    });

    if (!dialogShown) {
      Navigator.of(context).pop();
    }
  }

  CraftboxBottomSheet _buildBottomSheet({
    required BuildContext context,
    required TimeRecorderScreenArgs args,
    required TimePickerState timePickerState,
  }) {
    return CraftboxBottomSheet(
      buttonTitle: S.current.timeRecorderMainButtonTitle,
      onButtonPressed: () {
        context.read<CreateDocumentationCubit>().createDocumentation(
              assignmentId: args.assignmentId,
              timeRecords: timePickerState.timeRecords,
              title: S.current.documentationTitle,
              attachment: timePickerState.attachment,
            );
      },
    );
  }

  SizedBox _buildBody({
    required BuildContext context,
    required CreateDocumentationState createDocumentationState,
    required TimePickerState timePickerState,
    required TimeRecorderScreenArgs args,
  }) {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Stack(
        children: _buildScrollableLayerWithLoadingIndicator(
          context: context,
          createDocumentationState: createDocumentationState,
          timePickerState: timePickerState,
          args: args,
        ),
      ),
    );
  }

  List<Widget> _buildScrollableLayerWithLoadingIndicator({
    required BuildContext context,
    required CreateDocumentationState createDocumentationState,
    required TimePickerState timePickerState,
    required TimeRecorderScreenArgs args,
  }) {
    final widgetList = [
      _buildScrollableLayer(
        context: context,
        createDocumentationState: createDocumentationState,
        timePickerState: timePickerState,
        args: args,
      ),
    ];

    if (createDocumentationState.blocStatus == Status.loading) {
      widgetList.add(
        buildLoadingIndicator(),
      );
    }

    return widgetList;
  }

  Widget _buildScrollableLayer({
    required BuildContext context,
    required CreateDocumentationState createDocumentationState,
    required TimePickerState timePickerState,
    required TimeRecorderScreenArgs args,
  }) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          children: [
            30.verticalSpace,
            RecordedTimeSoFar(totalTimeRecorded: args.totalTimeRecorded),
            30.verticalSpace,
            ..._buildTimeFields(
              context: context,
              createDocumentationState: createDocumentationState,
              timePickerState: timePickerState,
            ),
            CraftboxTextField(
              leadingTitle: S.current.attachment,
              trailingTitle: S.current.optional,
              hint: S.current.enterAttachment,
              inputAction: TextInputAction.done,
              isMultiline: true,
              onChanged: (value) =>
                  context.read<TimePickerCubit>().updateAttachment(value),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildTimeFields({
    required BuildContext context,
    required CreateDocumentationState createDocumentationState,
    required TimePickerState timePickerState,
  }) {
    final Map<TimeRecordType, String> fieldsData = {
      TimeRecordType.timeSpent: S.current.workingTime,
      TimeRecordType.breakTime: S.current.breakTime,
      TimeRecordType.drivingTime: S.current.drivingTime,
    };

    final List<Widget> timeFields = [];
    fieldsData.forEach((key, value) {
      timeFields.addAll([
        _buildTimeField(
          makeErrorVisible: createDocumentationState.requiredFieldsAreNotFilled,
          recordType: key,
          title: value,
          timePickerState: timePickerState,
          context: context,
        ),
        17.verticalSpace,
      ]);
    });

    return timeFields;
  }

  CraftboxTextField _buildTimeField({
    required bool makeErrorVisible,
    required TimeRecordType recordType,
    required String title,
    required TimePickerState timePickerState,
    required BuildContext context,
  }) {
    final timeRecord = timePickerState.timeRecords[recordType];
    final shouldShowError = makeErrorVisible &&
        (timeRecord == null || timeRecord.duration.inMinutes < 1);

    return CraftboxTextField(
      leadingTitle: title,
      hint: S.current.timePlaceholder,
      text: timePickerState.timeRecords[recordType]?.humanReadableTime,
      isReadOnly: true,
      errorText: shouldShowError ? S.current.required : null,
      onTap: () => _showTimePicker(
        context,
        type: recordType,
      ),
    );
  }

  void _showTimePicker(BuildContext context, {required TimeRecordType type}) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext buildContext) {
        return BlocProvider.value(
          value: context.read<TimePickerCubit>(),
          child: Container(
            height: 287,
            decoration: const BoxDecoration(
              color: AppColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: ProjectTimePicker(
              type: type,
              onDoneTap: (recordType, duration, humanReadableTime) {
                context
                    .read<TimePickerCubit>()
                    .updateTimeRecord(recordType, duration, humanReadableTime);

                if (duration.inMinutes > 0) {
                  context.read<CreateDocumentationCubit>().resetFieldsErrors();
                }
              },
            ),
          ),
        );
      },
    );
  }
}

class TimeRecorderScreenArgs {
  final int assignmentId;
  final RecordedTime totalTimeRecorded;
  final bool openedFromProtocolDialog;

  const TimeRecorderScreenArgs({
    required this.assignmentId,
    required this.totalTimeRecorded,
    this.openedFromProtocolDialog = false,
  });
}
