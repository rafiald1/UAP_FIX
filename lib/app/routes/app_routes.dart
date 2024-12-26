part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const LOGIN = _Paths.LOGIN;
  static const HTTP = _Paths.HTTP;
  static const REGISTER = _Paths.REGISTER;
  static const CRUD = _Paths.CRUD;
  static const PROFILE = _Paths.PROFILE;
  static const AUDIO = _Paths.AUDIO;
  static const LOCATION = _Paths.LOCATION;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const AUDIO = '/audio';
  static const LOGIN = '/login';
  static const HTTP = '/http';
  static const REGISTER = '/register';
  static const CRUD = '/crud';
  static const PROFILE = '/profile';
  static const LOCATION = '/location';
}
