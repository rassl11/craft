import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/repositories/base_repository.dart';
import '../entities/documentation.dart';
import '../usecases/documentation/create_draft_documentation.dart';
import '../usecases/documentation/create_image_documentation.dart';
import '../usecases/documentation/create_note_documentation.dart';
import '../usecases/documentation/create_signature_documentation.dart';
import '../usecases/documentation/create_time_documentation.dart';
import '../usecases/documentation/delete_documentation.dart';
import '../usecases/documentation/edit_note_documentation.dart';

abstract class DocumentationRepository extends BaseRepository {
  DocumentationRepository(super.networkInfo);

  Future<Either<Failure, SingleDocumentationHolder>> postTime({
    required CreateTimeDocumentationParams params,
  });

  Future<Either<Failure, SingleDocumentationHolder>> postNote({
    required CreateNoteDocumentationParams params,
  });

  Future<Either<Failure, SingleDocumentationHolder>> editNote({
    required EditNoteDocumentationParams params,
  });

  Future<Either<Failure, SingleDocumentationHolder>> postSignature({
    required CreateSignatureDocumentationParams params,
  });

  Future<Either<Failure, SingleDocumentationHolder>> postDraft({
    required CreateDraftDocumentationParams params,
  });

  Future<Either<Failure, SingleDocumentationHolder>> postImage({
    required CreateImageDocumentationParams params,
  });

  Future<Either<Failure, dynamic>> delete({
    required DeleteDocumentationParams params,
  });
}
