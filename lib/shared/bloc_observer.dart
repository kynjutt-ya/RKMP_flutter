import 'package:bloc/bloc.dart';

class AppBlocObserver extends BlocObserver {
  const AppBlocObserver();

  @override
  void onCreate(BlocBase<dynamic> bloc) {
    super.onCreate(bloc);
    print('BLoC CREATED: ${bloc.runtimeType}');
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    print('STATE CHANGE: ${bloc.runtimeType}');
    print('FROM: ${change.currentState}');
    print('TO: ${change.nextState}');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    print('BLoC ERROR: ${bloc.runtimeType}');
    print('ERROR: $error');
    super.onError(bloc, error, stackTrace);
  }
}