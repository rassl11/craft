import 'package:flutter_test/flutter_test.dart';
import 'package:share/features/assignments/presentation/blocs/scroll/scroll_button_bloc.dart';

void main() {
  late ScrollBloc scrollBloc;

  setUp(() {
    scrollBloc = ScrollBloc();
  });

  test('initial state should be ScrollStateInitial', () {
    expect(scrollBloc.state, equals(ScrollStateInitial()));
  });

  test(
      'should emit ScrollButtonState(isVisible: true) when '
      'event = ViewScrolledForward', () {
    // act
    scrollBloc.add(ViewScrolledForward());
    // assert
    expectLater(
      scrollBloc.stream,
      emitsInOrder([
        const ScrollButtonState(isVisible: true),
      ]),
    );
  });

  test(
      'should emit ScrollButtonState(isVisible: false) when '
      'event = ViewScrolledToStart', () {
    // act
    scrollBloc.add(ViewScrolledToStart());
    // assert
    expectLater(
      scrollBloc.stream,
      emitsInOrder([
        const ScrollButtonState(isVisible: false),
      ]),
    );
  });

  test('should emit ScrollButtonTapped when event = ScrollButtonPressed', () {
    // act
    scrollBloc.add(ScrollUpRequested());
    // assert
    expectLater(
      scrollBloc.stream,
      emitsInOrder([
        ScrollUp(),
      ]),
    );
  });
}
