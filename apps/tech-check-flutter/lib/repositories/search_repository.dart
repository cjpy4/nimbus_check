import '/providers/firebase_provider.dart';
import 'package:riverpod/riverpod.dart';



class SearchRepository {
  final _firebaseProvider = ref.watch(fireStoreProvider);

  SearchRepository(this._firebaseProvider);

  Future<List<String>> search(String query) async {
    return _firebaseProvider.search(query);
  }
}