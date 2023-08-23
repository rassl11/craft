import 'package:equatable/equatable.dart';

import '../../../../generated/l10n.dart';

class Article extends Equatable {
  final int id;
  final String name;
  final ArticleUnit unit;
  final Pivot? pivot;

  const Article({
    required this.id,
    required this.name,
    required this.unit,
    required this.pivot,
  });

  @override
  List<Object?> get props => [id, name, unit, pivot];
}

class Pivot extends Equatable {
  final int articleId;
  final int assignmentId;
  final int amount;
  final int used;

  const Pivot({
    required this.articleId,
    required this.assignmentId,
    required this.amount,
    required this.used,
  });

  @override
  List<Object?> get props => [articleId, assignmentId, amount, used];
}

enum ArticleUnit {
  kiloGrams('KILOGRAMS'),
  piece('PIECE'),
  box('BOX'),
  bottle('BOTTLE'),
  litre('LITRE'),
  unknown('UNKNOWN'),
  bag('BAG'),
  bar('BAR'),
  bucket('BUCKET'),
  bunch('BUNCH'),
  cane('CANE'),
  canister('CANISTER'),
  cardboard('CARDBOARD'),
  cubicMetre('CUBIC_METRE'),
  days('DAYS'),
  dozen('DOZEN'),
  flatFee('FLAT_FEE'),
  grams('GRAMS'),
  hours('HOURS'),
  kilometer('KILOMETER'),
  kilowattPeak('KILOWATT_PEAK'),
  metres('METRES'),
  millilitre('MILLILITRE'),
  millimetres('MILLIMETRES'),
  pack('PACK'),
  pair('PAIR'),
  panel('PANEL'),
  parcel('PARCEL'),
  percent('PERCENT'),
  roll('ROLL'),
  runningMeter('RUNNING_METER'),
  sac('SAC'),
  set('SET'),
  tons('TONS'),
  trimming('TRIMMING'),
  tube('TUBE'),
  squareMeter('SQUAREMETER');

  final String name;

  const ArticleUnit(this.name);

  String get localizedName {
    switch (this) {
      case ArticleUnit.kiloGrams:
        return S.current.kiloGrams;
      case ArticleUnit.piece:
        return S.current.piece;
      case ArticleUnit.box:
        return S.current.box;
      case ArticleUnit.bottle:
        return S.current.bottle;
      case ArticleUnit.litre:
        return S.current.litre;
      case ArticleUnit.unknown:
        return S.current.unknown;
      case ArticleUnit.bag:
        return S.current.bag;
      case ArticleUnit.bar:
        return S.current.bar;
      case ArticleUnit.bucket:
        return S.current.bucket;
      case ArticleUnit.bunch:
        return S.current.bunch;
      case ArticleUnit.cane:
        return S.current.cane;
      case ArticleUnit.canister:
        return S.current.canister;
      case ArticleUnit.cardboard:
        return S.current.cardboard;
      case ArticleUnit.cubicMetre:
        return S.current.cubicMetre;
      case ArticleUnit.days:
        return S.current.days;
      case ArticleUnit.dozen:
        return S.current.dozen;
      case ArticleUnit.flatFee:
        return S.current.flatFee;
      case ArticleUnit.grams:
        return S.current.grams;
      case ArticleUnit.hours:
        return S.current.hours;
      case ArticleUnit.kilometer:
        return S.current.kilometer;
      case ArticleUnit.kilowattPeak:
        return S.current.kilowattPeak;
      case ArticleUnit.metres:
        return S.current.metres;
      case ArticleUnit.millilitre:
        return S.current.millilitre;
      case ArticleUnit.millimetres:
        return S.current.millimetres;
      case ArticleUnit.pack:
        return S.current.pack;
      case ArticleUnit.pair:
        return S.current.pair;
      case ArticleUnit.panel:
        return S.current.panel;
      case ArticleUnit.parcel:
        return S.current.parcel;
      case ArticleUnit.percent:
        return S.current.percent;
      case ArticleUnit.roll:
        return S.current.roll;
      case ArticleUnit.runningMeter:
        return S.current.runningMeter;
      case ArticleUnit.sac:
        return S.current.sac;
      case ArticleUnit.set:
        return S.current.set;
      case ArticleUnit.tons:
        return S.current.tons;
      case ArticleUnit.trimming:
        return S.current.trimming;
      case ArticleUnit.tube:
        return S.current.tube;
      case ArticleUnit.squareMeter:
        return S.current.squareMeter;
    }
  }
}
