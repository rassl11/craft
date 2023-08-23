import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/documentation.dart';
import '../../domain/repositories/documentation_repository.dart';
import '../../domain/usecases/documentation/create_draft_documentation.dart';
import '../../domain/usecases/documentation/create_image_documentation.dart';
import '../../domain/usecases/documentation/create_note_documentation.dart';
import '../../domain/usecases/documentation/create_signature_documentation.dart';
import '../../domain/usecases/documentation/create_time_documentation.dart';
import '../../domain/usecases/documentation/delete_documentation.dart';
import '../../domain/usecases/documentation/edit_note_documentation.dart';
import '../models/documentation_model.dart';
import '../sources/documentation_remote_data_source.dart';

class DocumentationRepositoryImpl extends DocumentationRepository {
  final DocumentationRemoteDataSource _remoteDataSource;

  DocumentationRepositoryImpl({
    required DocumentationRemoteDataSource remoteDataSource,
    required NetworkInfo networkInfo,
  })  : _remoteDataSource = remoteDataSource,
        super(networkInfo);

  @override
  Future<Either<Failure, SingleDocumentationHolder>> postTime({
    required CreateTimeDocumentationParams params,
  }) async {
    final model = DocumentationModel.postTime(
      assignmentId: params.assignmentId,
      workingTime: params.workingTime,
      breakTime: params.breakTime,
      drivingTime: params.drivingTime,
      type: DocumentationType.time,
      title: params.title,
      description: params.description,
    );

    return checkNetworkAndDoRequest(() => _remoteDataSource.postTime(model));
  }

  @override
  Future<Either<Failure, SingleDocumentationHolder>> postNote({
    required CreateNoteDocumentationParams params,
  }) {
    final model = DocumentationModel.postNote(
      assignmentId: params.assignmentId,
      type: DocumentationType.note,
      title: params.title,
      description: params.description,
    );

    return checkNetworkAndDoRequest(() => _remoteDataSource.postNote(model));
  }

  @override
  Future<Either<Failure, SingleDocumentationHolder>> editNote({
    required EditNoteDocumentationParams params,
  }) {
    final model = DocumentationModel.postEditNote(
      id: params.documentationId,
      assignmentId: params.assignmentId,
      type: DocumentationType.note,
      title: params.title,
      description: params.description,
    );

    return checkNetworkAndDoRequest(() => _remoteDataSource.editNote(model));
  }

  @override
  Future<Either<Failure, dynamic>> delete({
    required DeleteDocumentationParams params,
  }) {
    return checkNetworkAndDoRequest(() => _remoteDataSource.delete(params.id));
  }

  @override
  Future<Either<Failure, SingleDocumentationHolder>> postSignature({
    required CreateSignatureDocumentationParams params,
  }) {
    return checkNetworkAndDoRequest(
        () => _remoteDataSource.postSignatureMultipart(
              assignmentId: params.assignmentId,
              title: params.title,
              uploadFile1Bytes: params.uploadFile1,
              uploadFile2Bytes: params.uploadFile2,
            ));
  }

  @override
  Future<Either<Failure, SingleDocumentationHolder>> postDraft({
    required CreateDraftDocumentationParams params,
  }) {
    return checkNetworkAndDoRequest(() => _remoteDataSource.postDraftMultipart(
          assignmentId: params.assignmentId,
          title: params.title,
          draft: params.draft,
        ));
  }

  @override
  Future<Either<Failure, SingleDocumentationHolder>> postImage({
    required CreateImageDocumentationParams params,
  }) {
    return checkNetworkAndDoRequest(() => _remoteDataSource.postImageMultipart(
          assignmentId: params.assignmentId,
          title: params.title,
          image: params.image,
        ));
  }
}
