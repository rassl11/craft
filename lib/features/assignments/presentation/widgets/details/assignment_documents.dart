import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/common/widgets/craftbox_container.dart';
import '../../../../../core/constants/theme/images.dart';
import '../../../../../core/injection_container.dart';
import '../../../../../core/utils/file_opener.dart';
import '../../../../../generated/l10n.dart';
import '../../../../documents/presentation/cubits/file_management_cubit.dart';
import '../../../../documents/presentation/pages/documents_list_screen.dart';
import '../../../domain/entities/assignments_data_holder.dart';
import '../../../domain/entities/document.dart';
import '../assignment_list_item.dart';
import '../craftbox_list_divider.dart';
import 'container_title.dart';
import 'empty_container.dart';
import 'show_more.dart';

class AssignmentDocuments extends StatelessWidget {
  final Assignment _assignment;

  const AssignmentDocuments({
    super.key,
    required Assignment assignment,
  }) : _assignment = assignment;

  @override
  Widget build(BuildContext context) {
    final documents = _assignment.documents;
    final visibleDocuments = _getVisibleDocumentsList(context, documents);
    if (visibleDocuments.isEmpty) {
      return EmptyContainer(title: S.current.areNotAdded(S.current.documents));
    }

    return BlocProvider(
      create: (context) => sl<FileManagementCubit>(),
      child: BlocListener<FileManagementCubit, FileManagementState>(
        listener: (context, state) {
          sl<FileOpener>().checkStatusAndOpenFile(state, context);
        },
        child: CraftboxContainer(
          child: Column(
            children: [
              ContainerTitle(title: S.current.documents),
              ...visibleDocuments,
              ShowMore(
                numberOfHiddenDocuments: _getHiddenDocumentsNumber(documents),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    DocumentsListScreen.routeName,
                    arguments: DocumentsArgs(documents: documents ?? []),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _getHiddenDocumentsNumber(List<Document>? documents) {
    final documentsLength = documents?.length ?? 0;
    const maxVisibleDocuments = 2;
    final hiddenDocuments = documentsLength > maxVisibleDocuments
        ? documentsLength - maxVisibleDocuments
        : 0;
    return hiddenDocuments;
  }

  List<Widget> _getVisibleDocumentsList(
    BuildContext context,
    List<Document>? documents,
  ) {
    final documentsList = <Widget>[];
    for (final Document document in documents ?? []) {
      if (documentsList.length >= 3) {
        break;
      }

      documentsList.addAll(
        [
          _buildDocumentListItem(document),
          const CraftboxListDivider(),
        ],
      );
    }

    if (documentsList.isNotEmpty) {
      documentsList.removeLast();
    }

    return documentsList;
  }

  Builder _buildDocumentListItem(Document document) {
    final picture = document.picture;
    final thumbUrl = picture?.thumbUrl;

    return Builder(builder: (context) {
      return AssignmentListItem(
        text: document.title,
        svgPicture: (thumbUrl == null || thumbUrl.isEmpty)
            ? getFaIconByString(document.icon)
            : null,
        leadingImageUrl: thumbUrl,
        isTrailingArrowEnabled: true,
        onTap: () {
          if (picture == null) {
            return;
          }

          context.read<FileManagementCubit>().getDocument(
                fileUrl: picture.fileUrl,
                fileName: picture.fileName,
                fileType: picture.fileType,
                title: picture.fileOriginalName,
              );
        },
      );
    });
  }
}
