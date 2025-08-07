import 'package:flutter_test/flutter_test.dart';
import 'package:g6_assessment/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:mocktail/mocktail.dart';

import '../repositories/auth_repository_test.mocks.dart';

void main() {
  Map<String, String> values = {'ACCESS_TOKEN': 'lsdkglsdlkjl'};
  late MockFlutterSecureStorage storage;
  late AuthLocalDataSourceImpl localDataSourceImpl;

  setUp(() {
    storage = MockFlutterSecureStorage();
    localDataSourceImpl = AuthLocalDataSourceImpl(storage: storage);
  });

  test('verify the local data source return as we expected', () async {
    when(() => storage.read(key: any())).thenAnswer((invocation) async {
      final key = invocation.positionalArguments.first as String;
      return values[key];
    });

    // ACT
    final result = await localDataSourceImpl.getAccessToken('ACCESS_TOKEN');

    // ASSERT
    expect(result, isA<String?>());
  });
}
