import 'package:flutter_test/flutter_test.dart';
import 'package:share/features/assignments/presentation/blocs/bottom_bar/bottom_bar_bloc.dart';
import 'package:share/features/assignments/presentation/widgets/craftbox_bottom_bar.dart';

void main() {
  late BottomBarBloc bottomBarBloc;

  setUp(() {
    bottomBarBloc = BottomBarBloc();
  });

  test('initial state should be BottomBarState', () {
    // assert
    expect(bottomBarBloc.state, const BottomBarState());
  });

  group('BottomBarTabChanged', () {
    const tBottomBarTab = ActiveTab.more;

    test(
      'should emit [BottomBarState] with the ActiveTab.more if the event is'
      ' BottomBarTabChanged',
      () async {
        // act
        bottomBarBloc.add(const BottomBarTabChanged(activeTab: tBottomBarTab));
        // assert
        const expected = [
          BottomBarState(activeTab: ActiveTab.more),
        ];
        await expectLater(bottomBarBloc.stream, emitsInOrder(expected));
      },
    );
  });
}
