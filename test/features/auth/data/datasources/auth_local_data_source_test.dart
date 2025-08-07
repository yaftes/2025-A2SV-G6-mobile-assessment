// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:g6_assessment/features/auth/data/datasources/auth_local_data_source.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mocktail/mocktail.dart';
// import 'auth_local_data_source_test.mocks.dart';

// @GenerateMocks([FlutterSecureStorage])
// void main() {
//   Map<String, String> values = {'ACCESS_TOKEN': 'lsdkglsdlkjl'};
//   late MockFlutterSecureStorage storage;
//   late AuthLocalDataSourceImpl localDataSourceImpl;

//   setUp(() {
//     storage = MockFlutterSecureStorage();
//     localDataSourceImpl = AuthLocalDataSourceImpl(storage: storage);
//   });

//   test('verify the local data source returns expected access token', () async {
//     when(
//       () => storage.read(key: 'ACCESS_TOKEN'),
//     ).thenAnswer((_) async => values['ACCESS_TOKEN']);

//     final result = await localDataSourceImpl.getAccessToken('ACCESS_TOKEN');

//     expect(result, equals('lsdkglsdlkjl'));
//   });
// }
