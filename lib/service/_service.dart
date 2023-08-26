//TODO: Create more specific extensions of this class
import 'package:amplify_flutter/amplify_flutter.dart';

abstract class AppService<T extends Object> {
  const AppService();

  void create(T entity) {
    throw UnimplementedError();
  }

  Future<T> read(Map<String, dynamic> params) async {
    throw UnimplementedError();
  }

  void update(T entity) {
    throw UnimplementedError();
  }

  void delete(T entity) {
    throw UnimplementedError();
  }
}

abstract class DataStoreService<T extends Model> extends AppService<T> {
  const DataStoreService();
  @override
  void create(T entity) {
    Amplify.DataStore.save(entity);
  }

  @override
  Future<T> read(Map<String, dynamic> params) {
    throw UnimplementedError();
  }

  @override
  void update(T entity) {
    Amplify.DataStore.save(entity);
  }

  @override
  void delete(T entity) {
    Amplify.DataStore.delete(entity);
  }
}
