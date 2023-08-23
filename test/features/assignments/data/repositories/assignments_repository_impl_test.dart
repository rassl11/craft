import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:share/core/network/network_info.dart';
import 'package:share/core/utils/assignments_utils.dart';
import 'package:share/features/assignments/data/repositories/assignments_repository_impl.dart';
import 'package:share/features/assignments/data/sources/assignments_remote_data_source.dart';

class MockAssignmentsRemoteDataSource extends Mock
    implements AssignmentsRemoteDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  late AssignmentsRepositoryImpl repository;
  late AssignmentsRemoteDataSource dataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    dataSource = MockAssignmentsRemoteDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = AssignmentsRepositoryImpl(
      remoteDataSource: dataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('fetchAssignments', () {
    test('should check network and call remoteDataSource.getAssignments',
        () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.fetchAssignments(withRelation: 'relation');
      // assert
      verify(() => dataSource.getAssignments(withRelation: 'relation'));
    });
  });

  group('getCustomerInfoBy', () {
    test('should check network and call remoteDataSource.getAssignments',
        () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.getCustomerInfoBy(addressId: 1);
      // assert
      verify(() => dataSource.getCustomerBy(addressId: 1));
    });
  });

  group('fetchDetailedAssignment', () {
    test('should check network and call remoteDataSource.getAssignments',
        () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.fetchDetailedAssignment(assignmentId: 1);
      // assert
      verify(() => dataSource.getDetailedAssignment(assignmentId: 1));
    });
  });

  group('putAssignmentState', () {
    test('should check network and call remoteDataSource.getAssignments',
        () async {
      // arrange
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      // act
      await repository.putAssignmentState(
        assignmentId: 1,
        stateToBeSet: InAppAssignmentState.actionRequired,
      );
      // assert
      verify(() => dataSource.putAssignmentState(
            assignmentId: 1,
            stateToBeSet: InAppAssignmentState.actionRequired,
          ));
    });
  });
}
