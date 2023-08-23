import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../core/common/widgets/craftbox_container.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/utils/date_utils.dart';
import '../../../../core/utils/protocol_utils.dart';
import '../../../../core/utils/ui_utils.dart';
import '../../../../generated/l10n.dart';
import '../../../assignments/domain/entities/article.dart';
import '../../../assignments/domain/entities/assignments_data_holder.dart';
import '../../../assignments/domain/entities/document.dart';
import '../../../assignments/domain/entities/documentation.dart';
import '../../../assignments/domain/entities/recorded_time.dart';
import '../../../assignments/presentation/blocs/detailed_assignment/detailed_assignment_bloc.dart';
import '../../../assignments/presentation/pages/time_recorder_viewer_screen.dart';
import '../pages/draft_screen.dart';
import '../pages/note_editor_screen.dart';
import '../pages/note_screen.dart';
import '../pages/photo_editor_screen.dart';
import '../pages/protocol_screen.dart';
import '../pages/submit_approval_screen.dart';

class ProtocolList extends StatelessWidget {
  final Assignment assignment;
  final bool isSigned;
  final RecordedTime totalRecordedTime;

  const ProtocolList({
    super.key,
    required this.assignment,
    required this.isSigned,
    required this.totalRecordedTime,
  });

  @override
  Widget build(BuildContext context) {
    return _buildProtocolItemsList(
      context: context,
      assignment: assignment,
      isSigned: isSigned,
      totalRecordedTime: totalRecordedTime,
    );
  }

  Widget _buildProtocolItemsList({
    required BuildContext context,
    required Assignment assignment,
    required bool isSigned,
    required RecordedTime totalRecordedTime,
  }) {
    final documentations = assignment.documentations;
    final List<DocumentationItemData> items =
        ProtocolUtils.getProtocolDataItems(
      context,
      documentations,
    );

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final documentation = item.documentation;
        final date = item.date;
        if (date != null) {
          return _buildProtocolItemWithDate(
            context: context,
            createdAt: date,
            assignment: assignment,
            documentation: documentation,
            isSigned: isSigned,
            totalRecordedTime: totalRecordedTime,
          );
        }

        return _buildProtocolItem(
          context: context,
          documentation: documentation,
          assignment: assignment,
          isSigned: isSigned,
          totalRecordedTime: totalRecordedTime,
        );
      },
    );
  }

  Column _buildProtocolItemWithDate({
    required BuildContext context,
    required String createdAt,
    required Documentation documentation,
    required Assignment assignment,
    required bool isSigned,
    required RecordedTime totalRecordedTime,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: double.infinity,
          alignment: Alignment.center,
          margin: const EdgeInsets.only(bottom: 18, top: 2),
          child: Text(
            createdAt,
            style: TextStyle(
              fontFamily: AppFonts.latoFont,
              fontSize: 15.sp,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        _buildProtocolItem(
          context: context,
          documentation: documentation,
          assignment: assignment,
          isSigned: isSigned,
          totalRecordedTime: totalRecordedTime,
        ),
      ],
    );
  }

  Widget _buildProtocolItem({
    required BuildContext context,
    required Documentation documentation,
    required Assignment assignment,
    required bool isSigned,
    required RecordedTime totalRecordedTime,
  }) {
    return CraftboxContainer(
      padding: const EdgeInsets.all(16),
      child: InkWell(
        onTap: () async {
          switch (documentation.type) {
            case DocumentationType.note:
              await _handleNoteItemClick(
                context,
                assignment,
                documentation,
                isSigned,
              );
              return;
            case DocumentationType.signing:
              await _handleSignatureItemClick(
                context,
                assignment,
                documentation,
                isSigned,
              );
              return;
            case DocumentationType.time:
              await _handleTimeItemClick(
                context,
                assignment,
                documentation,
                isSigned,
                totalRecordedTime,
              );
              return;
            case DocumentationType.draft:
              await _handleDraftItemClick(
                context,
                assignment,
                documentation,
                isSigned,
              );
              return;
            case DocumentationType.photo:
              await _handlePhotoItemClick(
                context,
                assignment,
                documentation,
                isSigned,
              );
              return;
            default:
              return;
          }
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTitleWithIconAndArrow(
                documentation.title, documentation.type),
            15.verticalSpace,
            _buildWidgetContent(documentation, assignment.articles),
            20.verticalSpace,
            _buildProtocolItemFooter(context, documentation),
          ],
        ),
      ),
    );
  }

  Future<void> _handleNoteItemClick(
    BuildContext context,
    Assignment assignment,
    Documentation documentation,
    bool isSigned,
  ) async {
    final noteEdited = await Navigator.of(context).pushNamed(
      NoteEditorScreen.routeName,
      arguments: NoteArgs(
        assignmentId: assignment.id,
        documentationId: documentation.id ?? 0,
        updatedAt: documentation.createdAt,
        causer: assignment.creation?.causer,
        title: documentation.title,
        text: documentation.description ?? '',
        isProtocolSigned: isSigned,
      ),
    ) as bool?;

    if (context.mounted && (noteEdited ?? false)) {
      context.read<DetailedAssignmentBloc>().add(
            DetailedAssignmentFetched(
              assignmentId: documentation.assignmentId,
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

  Future<void> _handleSignatureItemClick(
    BuildContext context,
    Assignment assignment,
    Documentation documentation,
    bool isSigned,
  ) async {
    final byteListCustomerSignature =
        await urlToUint8List(documentation.upload?.thumbUrl ?? '');
    final byteListExecutorSignature =
        await urlToUint8List(documentation.upload2?.thumbUrl ?? '');

    if (context.mounted) {
      await Navigator.of(context).pushNamed(SubmitApprovalScreen.routeName,
          arguments: SubmitApprovalArgs(
            customerName: documentation.title,
            customerSignature: byteListCustomerSignature,
            executorSignature: byteListExecutorSignature,
            updatedAt: documentation.updatedAt,
            causer: assignment.creation?.causer,
          ));
    }
  }

  Future<void> _handleDraftItemClick(
    BuildContext context,
    Assignment assignment,
    Documentation documentation,
    bool isSigned,
  ) async {
    final byteListDraft =
        await urlToUint8List(documentation.upload?.thumbUrl ?? '');

    if (context.mounted) {
      final draftDeleted = await Navigator.of(context).pushNamed(
        DraftScreen.routeName,
        arguments: DraftArgs(
          customerName: documentation.title,
          documentationId: documentation.id ?? 0,
          draft: byteListDraft,
          updatedAt: documentation.updatedAt,
          causer: assignment.creation?.causer,
          isProtocolSigned: isSigned,
        ),
      ) as bool?;

      if (context.mounted && (draftDeleted ?? false)) {
        context.read<DetailedAssignmentBloc>().add(
              DetailedAssignmentFetched(
                assignmentId: documentation.assignmentId,
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
  }

  Future<void> _handlePhotoItemClick(
    BuildContext context,
    Assignment assignment,
    Documentation documentation,
    bool isSigned,
  ) async {
    if (context.mounted) {
      final photoEdited =
          await Navigator.of(context).pushNamed(PhotoEditorScreen.routeName,
              arguments: PhotoEditorArgs(
                assignmentId: assignment.id,
                isProtocolSigned: isSigned,
                documentationId: documentation.id ?? 0,
                title: documentation.title,
                photo: documentation.upload?.mediumUrl ?? '',
                updatedAt: documentation.updatedAt,
                causer: assignment.creation?.causer,
              )) as bool?;

      if (context.mounted && (photoEdited ?? false)) {
        context.read<DetailedAssignmentBloc>().add(
              DetailedAssignmentFetched(
                assignmentId: documentation.assignmentId,
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
  }

  Future<void> _handleTimeItemClick(
    BuildContext context,
    Assignment assignment,
    Documentation documentation,
    bool isSigned,
    RecordedTime totalRecordedTime,
  ) async {
    if (context.mounted) {
      final timeEdited = await Navigator.of(context)
          .pushNamed(TimeRecordsViewerScreen.routeName,
              arguments: TimeRecorderViewerScreenArgs(
                assignmentId: assignment.id,
                documentationId: documentation.id ?? 0,
                totalTimeRecorded: totalRecordedTime,
                currentTimeRecorded: RecordedTime(
                  workingTime: documentation.workingTime ?? 0,
                  breakTime: documentation.breakTime ?? 0,
                  drivingTime: documentation.drivingTime ?? 0,
                ),
                attachment: documentation.description ?? '',
                updatedAt: documentation.updatedAt,
                causer: assignment.creation?.causer,
                isSigned: isSigned,
              )) as bool?;

      if (context.mounted && (timeEdited ?? false)) {
        context.read<DetailedAssignmentBloc>().add(
          DetailedAssignmentFetched(
            assignmentId: documentation.assignmentId,
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
  }

  Widget _buildTitleWithIconAndArrow(String title, DocumentationType type) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 12),
          child: _getIcon(type),
        ),
        Expanded(
          child: Text(
            type == DocumentationType.signing ? S.current.approval : title,
            maxLines: 2,
            style: TextStyle(
              overflow: TextOverflow.ellipsis,
              fontSize: 19.sp,
              fontFamily: AppFonts.latoFont,
              fontWeight: FontWeight.w700,
              color: AppColor.black,
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(left: 8),
          child: Icon(Icons.arrow_forward_ios, color: AppColor.orange),
        ),
      ],
    );
  }

  Widget _getIcon(DocumentationType type) {
    final Widget icon;
    switch (type) {
      case DocumentationType.note:
        icon = SvgPicture.asset(protocolNote, height: 22);
        break;
      case DocumentationType.photo:
        icon = SvgPicture.asset(protocolCamera, height: 22);
        break;
      case DocumentationType.signing:
        icon = SvgPicture.asset(protocolSign, height: 24);
        break;
      case DocumentationType.time:
        icon = SvgPicture.asset(protocolTimer, height: 22);
        break;
      case DocumentationType.pdf:
        icon = getFaIcon(CraftboxIcon.filePdf, height: 22);
        break;
      case DocumentationType.drawing:
      case DocumentationType.draft:
        icon = getFaIcon(CraftboxIcon.penLine, height: 22);
        break;
      case DocumentationType.material:
        icon = SvgPicture.asset(protocolLayers, height: 22);
        break;
      case DocumentationType.attachment:
      case DocumentationType.unknown:
        icon = getFaIconByString('', height: 22);
        break;
    }
    return icon;
  }

  Widget _buildWidgetContent(
    Documentation documentation,
    List<Article>? articles,
  ) {
    final upload = documentation.upload;
    final upload2 = documentation.upload2;

    final Widget content;
    switch (documentation.type) {
      case DocumentationType.photo:
      case DocumentationType.pdf:
      case DocumentationType.attachment:
        content = _buildImageContainer(upload);
        break;
      case DocumentationType.drawing:
      case DocumentationType.draft:
        content = _buildImageContainer(upload, isDraft: true);
        break;
      case DocumentationType.signing:
        content = _buildSigningContainer(upload: upload, upload2: upload2);
        break;
      case DocumentationType.note:
        content = _buildNoteContainer(documentation);
        break;
      case DocumentationType.time:
        final projectTimeRowsData = _getProjectTimeRowsData(documentation);
        content = _buildTextRowsContainer(projectTimeRowsData);
        break;
      case DocumentationType.material:
        final materialRowsData =
            ProtocolUtils.parseMaterials(documentation.description);
        content = _buildTextRowsContainer(materialRowsData);
        break;
      case DocumentationType.unknown:
      default:
        content = const Placeholder(
          fallbackHeight: 168,
          fallbackWidth: double.infinity,
        );
        break;
    }

    return content;
  }

  SizedBox _buildNoteContainer(Documentation documentation) {
    return SizedBox(
      width: double.infinity,
      child: Text(
        documentation.description ?? '',
        maxLines: 3,
        textAlign: TextAlign.left,
        style: TextStyle(
          overflow: TextOverflow.ellipsis,
          fontSize: 17.sp,
          fontFamily: AppFonts.latoFont,
          fontWeight: FontWeight.w500,
          color: AppColor.black,
        ),
      ),
    );
  }

  Widget _buildImageContainer(Picture? upload, {bool isDraft = false}) {
    if (upload == null) {
      return const SizedBox.shrink();
    }

    final mediumUrl = upload.mediumUrl;
    if (mediumUrl.isNotEmpty) {
      return Container(
        height: 168,
        decoration: BoxDecoration(
          color: isDraft ? AppColor.grayControls : null,
          borderRadius: BorderRadius.circular(6),
          image: DecorationImage(
            image: NetworkImage(mediumUrl),
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return Container(
      height: 168,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColor.grayControls,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 55),
        child: getFaIconByString(upload.icon, color: AppColor.gray400),
      ),
    );
  }

  Widget _buildProtocolItemFooter(
    BuildContext context,
    Documentation documentation,
  ) {
    final author = documentation.author;
    final authorName = '${author?.firstName ?? ''} ${author?.lastName ?? ''}';
    final creationTime =
        CraftboxDateTimeUtils.getTime(context, documentation.createdAt);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildFooterText(S.current.by(authorName)),
        _buildFooterText(creationTime),
      ],
    );
  }

  Text _buildFooterText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 14.sp,
        fontFamily: AppFonts.latoFont,
        fontWeight: FontWeight.w600,
        color: AppColor.darkGray,
      ),
    );
  }

  Map<String, String> _getProjectTimeRowsData(Documentation documentation) {
    final workingTime =
        CraftboxDateTimeUtils.formatTime(documentation.workingTime ?? 0);
    final breakTime =
        CraftboxDateTimeUtils.formatTime(documentation.breakTime ?? 0);
    final drivingTime =
        CraftboxDateTimeUtils.formatTime(documentation.drivingTime ?? 0);
    final Map<String, String> rowsData = {
      S.current.workingTime: workingTime,
      S.current.breakTime: breakTime,
      S.current.drivingTime: drivingTime,
    }..removeWhere((key, value) => value == S.current.timePlaceholder);
    return rowsData;
  }

  Widget _buildTextRowsContainer(Map<String, String> rowsData) {
    if (rowsData.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: _buildTextRowsList(rowsData),
    );
  }

  List<Widget> _buildTextRowsList(final Map<String, String> rowsData) {
    final List<Widget> rows = [];
    rowsData.forEach((key, value) {
      rows.addAll([
        if (rows.isNotEmpty) _buildDivider(),
        _buildTextRow(
          title: key,
          value: value,
        ),
      ]);
    });

    return rows;
  }

  Padding _buildDivider() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Divider(height: 1, color: AppColor.grayDivider, thickness: 1),
    );
  }

  Widget _buildTextRow({required String title, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            textAlign: TextAlign.left,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 17.sp,
              fontFamily: AppFonts.latoFont,
              fontWeight: FontWeight.w500,
              color: AppColor.black,
            ),
          ),
        ),
        20.horizontalSpace,
        Text(
          value,
          maxLines: 1,
          style: TextStyle(
            fontSize: 17.sp,
            fontFamily: AppFonts.latoFont,
            fontWeight: FontWeight.w700,
            color: AppColor.black,
          ),
        ),
      ],
    );
  }

  Widget _buildSigningContainer({Picture? upload, Picture? upload2}) {
    if (upload == null || upload2 == null) {
      return const SizedBox.shrink();
    }

    final customerMediumUrl = upload.mediumUrl;
    final executorMediumUrl = upload2.mediumUrl;
    return SizedBox(
      height: 110,
      child: Row(
        children: [
          _buildSignature(customerMediumUrl),
          10.horizontalSpace,
          _buildSignature(executorMediumUrl),
        ],
      ),
    );
  }

  Expanded _buildSignature(String customerMediumUrl) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: AppColor.grayControls,
          borderRadius: BorderRadius.circular(6),
          image: DecorationImage(
            image: NetworkImage(customerMediumUrl),
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
