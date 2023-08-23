part of 'signature_cubit.dart';

abstract class SignatureCubitState extends Equatable {
  const SignatureCubitState();
}

class Initial extends SignatureCubitState {
  @override
  List<Object> get props => [];
}

class DrawingStarted extends SignatureCubitState {
  @override
  List<Object> get props => [];
}

class DrawingStopped extends SignatureCubitState {
  @override
  List<Object> get props => [];
}
