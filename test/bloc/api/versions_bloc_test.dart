import 'package:flutterhole/bloc/api/versions.dart';
import 'package:flutterhole/bloc/base/event.dart';
import 'package:flutterhole/bloc/base/state.dart';
import 'package:flutterhole/model/api/versions.dart';
import 'package:flutterhole/model/pihole.dart';
import 'package:flutterhole/service/pihole_exception.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';

import '../../mock.dart';

main() {
  group('bloc', () {
    MockVersionsRepository versionsRepository;
    VersionsBloc versionsBloc;

    setUp(() {
      versionsRepository = MockVersionsRepository();
      versionsBloc = VersionsBloc(versionsRepository);
    });

    test('has a correct initialState', () {
      expect(versionsBloc.initialState, BlocStateEmpty<Versions>());
    });

    group('FetchVersions', () {
      test(
          'emits [BlocStateEmpty<Versions>, BlocStateLoading<Versions>, BlocStateSuccess<Versions>] when repository returns Versions',
              () {
            when(versionsRepository.get())
                .thenAnswer((_) => Future.value(mockVersions));

            expectLater(
                versionsBloc.state,
                emitsInOrder([
                  BlocStateEmpty<Versions>(),
                  BlocStateLoading<Versions>(),
                  BlocStateSuccess<Versions>(mockVersions),
                ]));

            versionsBloc.dispatch(Fetch());
          });

      test(
          'emits [BlocStateEmpty<Versions>, BlocStateLoading<Versions>, BlocStateError<Versions>] when home repository throws PiholeException',
              () {
            when(versionsRepository.get()).thenThrow(PiholeException());

            expectLater(
                versionsBloc.state,
                emitsInOrder([
                  BlocStateEmpty<Versions>(),
                  BlocStateLoading<Versions>(),
                  BlocStateError<Versions>(PiholeException()),
                ]));

            versionsBloc.dispatch(Fetch());
          });
    });

    group('FetchForPihole', () {
      test(
          'emits [BlocStateEmpty<Versions>, BlocStateLoading<Versions>, BlocStateSuccess<Versions>] when repository returns Versions for pihole',
              () {
            final pihole = Pihole();
            when(versionsRepository.get(pihole))
                .thenAnswer((_) => Future.value(mockVersions));

            expectLater(
                versionsBloc.state,
                emitsInOrder([
                  BlocStateEmpty<Versions>(),
                  BlocStateLoading<Versions>(),
                  BlocStateSuccess<Versions>(mockVersions),
                ]));

            versionsBloc.dispatch(FetchForPihole(pihole));
          });

      test(
          'emits [BlocStateEmpty<Versions>, BlocStateLoading<Versions>, BlocStateSuccess<Versions>] when repository returns Versions for pihole with cancelOldRequests = true',
              () {
            final pihole = Pihole();
            when(versionsRepository.get(pihole))
                .thenAnswer((_) => Future.value(mockVersions));

            expectLater(
                versionsBloc.state,
                emitsInOrder([
                  BlocStateEmpty<Versions>(),
                  BlocStateLoading<Versions>(),
                  BlocStateSuccess<Versions>(mockVersions),
                ]));

            versionsBloc.dispatch(
                FetchForPihole(pihole, cancelOldRequests: true));
          });

      test(
          'emits [BlocStateEmpty<Versions>, BlocStateLoading<Versions>, BlocStateError<Versions>] when home repository throws PiholeException',
              () {
            final pihole = Pihole();
            when(versionsRepository.get(pihole)).thenThrow(PiholeException());

            expectLater(
                versionsBloc.state,
                emitsInOrder([
                  BlocStateEmpty<Versions>(),
                  BlocStateLoading<Versions>(),
                  BlocStateError<Versions>(PiholeException()),
                ]));

            versionsBloc.dispatch(FetchForPihole(pihole));
          });
    });
  });

  group('repository', () {
    MockPiholeClient client;
    VersionsRepository versionsRepository;

    setUp(() {
      client = MockPiholeClient();
      versionsRepository = VersionsRepository(client);
    });

    test('get', () {
      when(client.fetchVersions())
          .thenAnswer((_) => Future.value(mockVersions));
      expect(versionsRepository.get(), completion(mockVersions));
    });
  });
}
