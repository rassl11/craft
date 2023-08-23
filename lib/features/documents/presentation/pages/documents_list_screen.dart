import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/common/widgets/craftbox_app_bar.dart';
import '../../../../core/common/widgets/craftbox_container.dart';
import '../../../../core/constants/theme/colors.dart';
import '../../../../core/constants/theme/fonts.dart';
import '../../../../core/constants/theme/images.dart';
import '../../../../core/injection_container.dart';
import '../../../../core/utils/file_opener.dart';
import '../../../../core/utils/numeric_utils.dart';
import '../../../../generated/l10n.dart';
import '../../../assignments/domain/entities/document.dart';
import '../cubits/file_management_cubit.dart';

class DocumentsListScreen extends StatelessWidget {
  static const routeName = '/documents';

  const DocumentsListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as DocumentsArgs;

    return BlocProvider(
      create: (context) => sl<FileManagementCubit>(),
      child: Scaffold(
        backgroundColor: AppColor.background,
        appBar: CraftboxAppBar(
          title: S.current.documents,
          backgroundColor: AppColor.white,
          leadingIconPath: arrowLeft,
          onLeadingIconPressed: () => Navigator.of(context).pop(),
        ),
        body: BlocListener<FileManagementCubit, FileManagementState>(
          listener: (context, state) {
            sl<FileOpener>().checkStatusAndOpenFile(state, context);
          },
          child: _buildList(args.documents),
        ),
      ),
    );
  }

  Widget _buildList(List<Document> documents) {
    return Builder(builder: (context) {
      return ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.only(
          left: 16,
          right: 16,
          top: 30,
          bottom: 12,
        ),
        itemCount: documents.length,
        itemBuilder: (itemBuilderContext, index) {
          final document = documents[index];
          return _buildItem(itemBuilderContext, document);
        },
      );
    });
  }

  StatelessWidget _buildItem(BuildContext context, Document document) {
    final picture = document.picture;
    if (picture != null) {
      final thumbUrl = picture.thumbUrl;
      return InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          context.read<FileManagementCubit>().getDocument(
                fileUrl: picture.fileUrl,
                fileName: picture.fileName,
                fileType: picture.fileType,
                title: picture.fileOriginalName,
              );
        },
        child: CraftboxContainer(
          padding: const EdgeInsets.all(16).copyWith(right: 22),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildImageContainer(thumbUrl, document.icon),
              _buildFileTextInfo(document.title, picture)
            ],
          ),
        ),
      );
    }

    return Container();
  }

  Widget _buildImageContainer(String thumbUrl, String iconName) {
    if (thumbUrl.isEmpty) {
      return Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: AppColor.gray200,
        ),
        margin: const EdgeInsets.only(right: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: getFaIconByString(
            iconName,
          ),
        ),
      );
    }

    return Container(
      width: 60,
      height: 60,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        image: DecorationImage(
          image: NetworkImage(thumbUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildFileTextInfo(String title, Picture picture) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTitleWithArrow(title),
          3.verticalSpace,
          _buildFileTypeWithSize(picture),
        ],
      ),
    );
  }

  Row _buildTitleWithArrow(String title) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Text(
            title,
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

  Text _buildFileTypeWithSize(Picture picture) {
    final fileTypeName = picture.fileType.name;
    final fileSizeInBytes = picture.fileSize;
    final formatBytes = NumericUtils.formatBytes(fileSizeInBytes);

    return Text(
      '$fileTypeName $formatBytes',
      style: TextStyle(
        fontSize: 15.sp,
        fontFamily: AppFonts.latoFont,
        fontWeight: FontWeight.w500,
        color: AppColor.gray900,
      ),
    );
  }
}

class DocumentsArgs {
  final List<Document> documents;

  DocumentsArgs({
    required this.documents,
  });
}
