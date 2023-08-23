import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../features/assignments/domain/entities/employee.dart';
import '../../constants/theme/colors.dart';
import '../../constants/theme/fonts.dart';

class CraftboxCircleAvatars extends StatelessWidget {
  final List<Employee> assigners;

  const CraftboxCircleAvatars({super.key, required this.assigners});

  @override
  Widget build(BuildContext context) {
    const maxNumberOfAssignersToBeShown = 3;
    final numberOfAssigners = assigners.length;
    final List<Widget> avatarsToShow = [];
    _addVisibleAssigners(
      numberOfAssigners,
      maxNumberOfAssignersToBeShown,
      avatarsToShow,
    );

    if (numberOfAssigners > maxNumberOfAssignersToBeShown) {
      _addCircleWithNumberOfHiddenAssigners(
        avatarsToShow,
        numberOfAssigners,
        maxNumberOfAssignersToBeShown,
      );
    }

    return _buildAvatarsContainer(avatarsToShow);
  }

  LimitedBox _buildAvatarsContainer(List<Widget> avatarsToShow) {
    return LimitedBox(
      maxHeight: 30,
      maxWidth: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: avatarsToShow.length,
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return Align(
            widthFactor: 0.7,
            child: avatarsToShow[index],
          );
        },
      ),
    );
  }

  void _addVisibleAssigners(int numberOfAssigners,
      int maxNumberOfAssignersToBeShown, List<Widget> avatarsToShow) {
    for (var index = 0; index < numberOfAssigners; index++) {
      if (index == maxNumberOfAssignersToBeShown) {
        break;
      }

      final employee = assigners[index];
      final employeePicture = employee.picture;
      if (employeePicture != null) {
        _addAvatarWithPicture(avatarsToShow, employeePicture);
      } else {
        _addAvatarWithInitials(employee, avatarsToShow);
      }
    }
  }

  void _addCircleWithNumberOfHiddenAssigners(
    List<Widget> avatarsToShow,
    int numberOfAssigners,
    int maxNumberOfAssignersToBeShown,
  ) {
    avatarsToShow.add(
      _getCircleWithHiddenAssigners(
        numberOfAssigners,
        maxNumberOfAssignersToBeShown,
      ),
    );
  }

  void _addAvatarWithInitials(Employee employee, List<Widget> avatarsToShow) {
    final String initials = _getInitials(employee);
    avatarsToShow.add(
      _buildCircle(
        child: Center(
          child: Text(
            initials,
            style: TextStyle(
              color: AppColor.white,
              fontFamily: AppFonts.latoFont,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        backgroundColor: HexColor.fromHex(employee.color),
      ),
    );
  }

  void _addAvatarWithPicture(
      List<Widget> avatarsToShow, EmployeePicture employeePicture) {
    avatarsToShow.add(
      _buildCircle(
        child: CircleAvatar(
          backgroundImage: NetworkImage(employeePicture.thumbUrl),
        ),
      ),
    );
  }

  Widget _getCircleWithHiddenAssigners(
      int numberOfAssigners, int maxNumberOfAssignersToBeShown) {
    final hiddenAssigners = numberOfAssigners - maxNumberOfAssignersToBeShown;
    final circleWithHiddenAssigners = _buildCircle(
      child: Center(
        child: Text(
          '+$hiddenAssigners',
          style: TextStyle(
            color: AppColor.white,
            fontFamily: AppFonts.latoFont,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      backgroundColor: AppColor.black,
    );

    return circleWithHiddenAssigners;
  }

  Widget _buildCircle({Color? backgroundColor, required Widget child}) {
    return ClipOval(
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: backgroundColor,
          border: Border.all(color: AppColor.white, width: 2),
          borderRadius: BorderRadius.circular(50),
        ),
        child: child,
      ),
    );
  }

  String _getInitials(Employee employee) {
    final firstName = employee.firstName;
    final lastName = employee.lastName;
    final initials = firstName.isNotEmpty && lastName.isNotEmpty
        ? '${firstName[0]}${lastName[0]}'
        : '';
    return initials;
  }
}
