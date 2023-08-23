import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share/features/protocol/presentation/cubits/signature/signature_cubit.dart';

void main() {
  late SignatureCubit signatureCubit;

  setUp(() {
    signatureCubit = SignatureCubit();
  });

  test('initial state should be Initial', () {
    // assert
    expect(
      signatureCubit.state,
      equals(Initial()),
    );
  });

  blocTest(
    'startDrawing should emit DrawingStarted',
    build: () => signatureCubit,
    act: (cubit) => cubit.startDrawing(),
    expect: () => <SignatureCubitState>[
      DrawingStarted(),
    ],
  );

  blocTest(
    'stopDrawing should emit DrawingStopped',
    build: () => signatureCubit,
    act: (cubit) => cubit.stopDrawing(),
    expect: () => <SignatureCubitState>[
      DrawingStopped(),
    ],
  );

  blocTest(
    'clear should emit Initial',
    build: () => signatureCubit,
    act: (cubit) => cubit.clear(),
    expect: () => <SignatureCubitState>[
      Initial(),
    ],
  );
}
