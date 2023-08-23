import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

import 'colors.dart';

const arrowRightYellow = 'assets/icons/login/arrow_right.svg';
const arrowLeft = 'assets/icons/login/arrow_left.svg';
const plus = 'assets/icons/login/plus_icon.svg';
const craftboxLogoHead = 'assets/images/login/head_craftbox.png';
const coins = 'assets/icons/login/coins.svg';
const assignmentsFilter = 'assets/icons/assignments/filter.svg';
const activeFiltersIcon = 'assets/icons/assignments/active_filters.svg';
const assignmentsEmptyListLogo =
    'assets/images/assignments/assignments_init.svg';
const protocolPlaceholder = 'assets/images/protocol/protocol_placeholder.svg';
const takePhoto = 'assets/images/protocol/take_photo.svg';
const rotate = 'assets/images/protocol/rotate.svg';
const gallery = 'assets/images/protocol/gallery.svg';
const close = 'assets/images/protocol/close.svg';
const delete = 'assets/images/protocol/delete.svg';
const protocolCamera = 'assets/icons/assignments/camera.svg';
const protocolClock = 'assets/icons/assignments/clock.svg';
const protocolLayers = 'assets/icons/assignments/layers.svg';
const protocolNote = 'assets/icons/assignments/note.svg';
const protocolSign = 'assets/icons/protocol/sign.svg';
const protocolSignUnconstrained =
    'assets/icons/protocol/sign_unconstrained.svg';
const protocolTimer = 'assets/icons/protocol/timer.svg';
const share = 'assets/icons/documents/share-nodes.svg';
const stopwatch = 'assets/icons/protocol/stopwatch.svg';
const attachment = 'assets/icons/protocol/attachment.svg';

//Bottom Tab Bar
const fileBlack = 'assets/icons/assignments/file_black.svg';
const fileGray = 'assets/icons/assignments/file_gray.svg';
const timerBlack = 'assets/icons/assignments/timer_black.svg';
const timerGray = 'assets/icons/assignments/timer_gray.svg';
const etcBlack = 'assets/icons/assignments/etc_black.svg';
const etcGray = 'assets/icons/assignments/etc_gray.svg';

String getFAIconPath(String name, {bool isPrefixRemovingRequired = true}) {
  const defaultIconPath = 'assets/icons/fa/solid/file.svg';

  if (name.isEmpty) {
    return defaultIconPath;
  }

  final iconName = isPrefixRemovingRequired ? name.substring(3) : name;
  if (iconName == 'file-alt') {
    return defaultIconPath;
  }
  return 'assets/icons/fa/solid/$iconName.svg';
}

SvgPicture getFaIcon(
  CraftboxIcon icon, {
  Color color = AppColor.black,
  double height = 18,
}) {
  return SvgPicture.asset(
    getFAIconPath(
      icon.name,
      isPrefixRemovingRequired: false,
    ),
    height: height,
    colorFilter: ColorFilter.mode(
      color,
      BlendMode.srcIn,
    ),
  );
}

SvgPicture getFaIconByString(
  String iconName, {
  bool isPrefixRemovingRequired = true,
  double height = 18,
  Color color = AppColor.black,
}) {
  return SvgPicture.asset(
    getFAIconPath(
      iconName,
      isPrefixRemovingRequired: isPrefixRemovingRequired,
    ),
    height: height,
    colorFilter: ColorFilter.mode(
      color,
      BlendMode.srcIn,
    ),
  );
}

Future<Uint8List> urlToUint8List(String url) async {
  try {
    final ByteData data = await NetworkAssetBundle(Uri.parse(url)).load(url);
    return data.buffer.asUint8List();
  } catch (e) {
    log('Error converting URL to Uint8List: $e');
    return Uint8List(0);
  }
}

enum CraftboxIcon {
  clipboard('clipboard'),
  phone('phone'),
  locationDot('location-dot'),
  bell('bell'),
  user('user'),
  key('key'),
  files('files'),
  envelope('envelope'),
  lock('lock'),
  circleInfo('circle-info'),
  earth('earth-europe'),
  share('share-nodes'),
  worker('user-helmet-safety'),
  penLine('pen-line'),
  arrowRotateLeft('arrow-rotate-left'),
  camera('camera'),
  noteSticky('note-sticky'),
  stopwatch('stopwatch'),
  filePdf('file-pdf'),
  link('link'),
  signature('signature'),
  more('more'),
  delete('trash-can');

  final String name;

  const CraftboxIcon(this.name);
}
