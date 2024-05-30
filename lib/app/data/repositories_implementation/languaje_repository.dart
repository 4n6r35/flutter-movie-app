import '../../domain/repositories/languaje_repository.dart';
import '../services/local/languaje_service.dart';

class LanguajeRepositoryImpl implements LanguajeRepository {
  final LanguageService _service;

  LanguajeRepositoryImpl(this._service);

  @override
  void setLanguajeCode(String code) {
    _service.serLanguageCode(code);
  }
}
