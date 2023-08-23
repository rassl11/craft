import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/blocs/status.dart';
import '../../../../core/common/widgets/craftbox_app_bar.dart';
import '../../../../core/common/widgets/craftbox_bottom_sheet.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../generated/l10n.dart';
import '../../../assignments/domain/entities/assignments_data_holder.dart';
import '../../../assignments/domain/entities/documentation.dart';
import '../../../assignments/domain/entities/recorded_time.dart';
import '../../../assignments/presentation/blocs/detailed_assignment/detailed_assignment_bloc.dart';
import '../../../assignments/presentation/pages/time_recorder_screen.dart';
import '../widgets/protocol_entries_dialog.dart';
import '../widgets/protocol_list.dart';
import 'camera_screen.dart';
import 'draft_screen.dart';
import 'note_screen.dart';
import 'submit_approval_screen.dart';

class ProtocolScreen extends StatelessWidget {
  static const routeName = '/protocol';

  const ProtocolScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final assignmentId = ModalRoute.of(context)!.settings.arguments as int;

    return BlocProvider(
      create: (context) => sl<DetailedAssignmentBloc>(),
      child: BlocBuilder<DetailedAssignmentBloc, DetailedAssignmentState>(
        builder: (context, state) {
          return Scaffold(
            backgroundColor: AppColor.background,
            appBar: _buildAppBar(
              assignmentId: assignmentId,
              state: state,
            ),
            body: _buildBodyWithRefresh(context, assignmentId, state),
            bottomNavigationBar: _buildBottomSheet(
              assignmentId: assignmentId,
            ),
          );
        },
      ),
    );
  }

  RefreshIndicator _buildBodyWithRefresh(
    BuildContext context,
    int assignmentId,
    DetailedAssignmentState state,
  ) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<DetailedAssignmentBloc>().add(
              DetailedAssignmentFetched(
                assignmentId: assignmentId,
              ),
            );
      },
      child: _buildBody(
        context: context,
        assignmentId: assignmentId,
        state: state,
      ),
    );
  }

  Widget _buildBody({
    required BuildContext context,
    required int assignmentId,
    required DetailedAssignmentState state,
  }) {
    switch (state.blocStatus) {
      case Status.initial:
        context.read<DetailedAssignmentBloc>().add(
              DetailedAssignmentFetched(
                assignmentId: assignmentId,
              ),
            );
        return _buildLoadingIndicator();
      case Status.loading:
        return _buildLoadingIndicator();
      case Status.error:
        return _buildError(
          context: context,
          assignmentId: assignmentId,
        );
      case Status.loaded:
        final assignment = state.assignment;

        return _buildProtocolList(
          state.isSigned,
          assignment,
          context,
          state.totalTimeHolder,
        );
    }
  }

  Widget _buildProtocolList(
    bool isSigned,
    Assignment? assignment,
    BuildContext context,
    RecordedTime totalRecordedTime,
  ) {
    if (assignment == null || (assignment.documentations.isEmpty)) {
      return _buildListPlaceholder();
    }

    return ProtocolList(
      assignment: assignment,
      isSigned: isSigned,
      totalRecordedTime: totalRecordedTime,
    );
  }

  PreferredSize _buildAppBar({
    required int assignmentId,
    required DetailedAssignmentState state,
  }) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Builder(builder: (context) {
        final assignment = state.assignment;

        return CraftboxAppBar(
          title: S.current.protocolAppBarTitle,
          leadingIconPath: arrowLeft,
          onLeadingIconPressed: () {
            Navigator.of(context).pop();
          },
          actions: [
            IconButton(
                onPressed: () => assignment != null
                    ? _showProtocolEntriesDialog(
                        context,
                        assignment,
                        assignmentId,
                        state.totalTimeHolder,
                      )
                    : () {},
                icon: SvgPicture.asset(plus, height: 20, width: 20)),
          ],
        );
      }),
    );
  }

  Future<Object?> _showProtocolEntriesDialog(
    BuildContext context,
    Assignment assignment,
    int assignmentId,
    RecordedTime time,
  ) {
    return ProtocolEntriesDialog().show(
      context: context,
      onNoteItemTap: () {
          _openNoteScreen(
            context,
            assignment,
            assignmentId,
          );
        },
        onSignatureItemTap: () => {
              _openSignatureScreen(
                context,
                assignmentId,
                true,
              ),
            },
        onDraftItemTap: () => {
              _openDraftScreen(
                context,
                assignmentId,
              )
            },
        onPhotoItemTap: () => {
              _openPhotoScreen(
                context,
                assignmentId,
              )
            },
      onTimeItemTap: () => {
        _handleOnTimeItemTapped(
          context,
          assignmentId,
          time,
        )
      },
    );
  }

  Future<void> _openNoteScreen(
    BuildContext context,
    Assignment assignment,
    int assignmentId,
  ) async {
    final noteAdded = await Navigator.popAndPushNamed(
      context,
      NoteScreen.routeName,
      arguments: NoteArgs(
        assignmentId: assignment.id,
        causer: assignment.creation?.causer,
      ),
    ) as bool?;
    if (context.mounted && (noteAdded ?? false)) {
      context.read<DetailedAssignmentBloc>().add(
            DetailedAssignmentFetched(
              assignmentId: assignmentId,
            ),
          );
      showColorfulSnackBar(
        context,
        backgroundColor: AppColor.green500,
        text: S.current.success,
        emojiType: EmojiType.success,
      );
    }
  }

  Future<void> _handleOnTimeItemTapped(
    BuildContext context,
    int assignmentId,
    RecordedTime time,
  ) async {
    final timeAdded = await Navigator.popAndPushNamed(
      context,
      TimeRecordsScreen.routeName,
      arguments: TimeRecorderScreenArgs(
        assignmentId: assignmentId,
        totalTimeRecorded: time,
        openedFromProtocolDialog: true,
      ),
    ) as bool?;
    if (context.mounted && (timeAdded ?? false)) {
      context.read<DetailedAssignmentBloc>().add(
            DetailedAssignmentFetched(
              assignmentId: assignmentId,
            ),
          );
      showColorfulSnackBar(
        context,
        backgroundColor: AppColor.green500,
        text: S.current.success,
        emojiType: EmojiType.success,
      );
    }
  }

  Widget _buildListPlaceholder() {
    return Builder(builder: (context) {
      return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 21),
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                90.verticalSpace,
                SvgPicture.asset(protocolPlaceholder),
                24.verticalSpace,
                Text(
                  S.current.noDocumentsYet,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.latoFont,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w900,
                    color: AppColor.black,
                  ),
                ),
              ],
            ),
          ]);
    });
  }
}

Widget _buildError({
  required BuildContext context,
  required int assignmentId,
}) {
  return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            154.verticalSpace,
            Container(
              alignment: Alignment.center,
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColor.yellow50,
                borderRadius: BorderRadius.circular(17),
                border: Border.all(),
              ),
              child: const Text(
                '😵‍💫️‍',
                style: TextStyle(fontSize: 34),
              ),
            ),
            24.verticalSpace,
            Text(
              S.current.somethingWentWrong,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28.sp,
                fontStyle: FontStyle.normal,
                fontFamily: AppFonts.latoFont,
                fontWeight: FontWeight.w900,
                color: AppColor.black,
              ),
            ),
            267.verticalSpace,
            Text(
              S.current.tapToRefresh,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 17.sp,
                fontStyle: FontStyle.normal,
                fontFamily: AppFonts.latoFont,
                fontWeight: FontWeight.w500,
                color: AppColor.darkGray,
              ),
            ),
          ],
        ),
      ]);
}

Widget _buildBottomSheet({
  required int assignmentId,
}) {
  return Builder(builder: (context) {
    final state = context.watch<DetailedAssignmentBloc>().state;

    return state.blocStatus == Status.error
        ? CraftboxBottomSheet(
            buttonTitle: S.current.refresh,
            onButtonPressed: () async {
              context.read<DetailedAssignmentBloc>().add(
                    DetailedAssignmentFetched(
                      assignmentId: assignmentId,
                    ),
                  );
            },
          )
        : CraftboxBottomSheet(
            buttonTitle: S.current.submitApproval,
            onButtonPressed: () async {
              await _openSignatureScreen(context, assignmentId, false);
            },
          );
  });
}

Future<void> _openSignatureScreen(
  BuildContext context,
  int assignmentId,
  bool popCurrentWidget,
) async {
  final approvalSuccessfullySent = popCurrentWidget
      ? await Navigator.popAndPushNamed(
          context,
          SubmitApprovalScreen.routeName,
          arguments: SubmitApprovalArgs(
            assignmentId: assignmentId,
          ),
        )
      : await Navigator.pushNamed(
          context,
          SubmitApprovalScreen.routeName,
          arguments: SubmitApprovalArgs(
            assignmentId: assignmentId,
          ),
        );
  if (context.mounted && (approvalSuccessfullySent as bool? ?? false)) {
    context.read<DetailedAssignmentBloc>().add(
          DetailedAssignmentFetched(assignmentId: assignmentId),
        );
    showColorfulSnackBar(
      context,
      backgroundColor: AppColor.green500,
      text: S.current.success,
      emojiType: EmojiType.success,
    );
  }
}

Future<void> _openDraftScreen(
  BuildContext context,
  int assignmentId,
) async {
  final draftAdded = await Navigator.popAndPushNamed(
    context,
    DraftScreen.routeName,
    arguments: DraftArgs(
      assignmentId: assignmentId,
    ),
  );
  if (context.mounted && (draftAdded as bool? ?? false)) {
    context.read<DetailedAssignmentBloc>().add(
      DetailedAssignmentFetched(assignmentId: assignmentId),
    );
    showColorfulSnackBar(
      context,
      backgroundColor: AppColor.green500,
      text: S.current.success,
      emojiType: EmojiType.success,
    );
  }
}

Future<void> _openPhotoScreen(
  BuildContext context,
  int assignmentId,
) async {
  final cameras = await availableCameras();
  if (context.mounted) {
    final result = await Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        settings: const RouteSettings(),
        builder: (_) => CameraScreen(
          cameras: cameras,
          currentImages: List.empty(),
          currentHints: List.empty(),
          assignmentId: assignmentId,
        ),
      ),
    ) as bool?;
    if (context.mounted && (result ?? false)) {
      context.read<DetailedAssignmentBloc>().add(
        DetailedAssignmentFetched(assignmentId: assignmentId),
      );
      showColorfulSnackBar(
        context,
        backgroundColor: AppColor.green500,
        text: S.current.success,
        emojiType: EmojiType.success,
      );
    }
  }
}

Widget _buildLoadingIndicator() {
  return const Center(
    child: CircularProgressIndicator(),
  );
}

class DocumentationItemData {
  final String? date;
  final Documentation documentation;

  DocumentationItemData({
    this.date,
    required this.documentation,
  });
}
