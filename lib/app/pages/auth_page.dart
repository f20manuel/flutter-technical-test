import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/app/data/enums/image_width.dart';
import 'package:fluttertest/app/data/http/http_client.dart';
import 'package:fluttertest/app/data/models/series.dart';
import 'package:fluttertest/app/widgets/image.dart';
import 'package:skeletons/skeletons.dart';

/// States
final StateProvider<bool> loginShowProvider = StateProvider<bool>(
  (ref) => false,
);
final StateProvider<bool> securePasswordProvider = StateProvider<bool>(
  (ref) => true,
);

/// Get front series
final futurePrincipalSeriesProvider = FutureProvider<Series?>((ref) async {
  final Response response = await fetchGet(
    '/tv/popular',
    parameters: <String, dynamic>{
      'page': 1,
    },
  );
  final List<Series> series = <Series>[];
  for (final Map<String, dynamic> json in response.data['results']) {
    final Series seriesModel = Series(
      id: json['id'],
      backdropPath: json['backdrop_path'],
      firstAirDate: DateTime.parse(json['first_air_date']),
      genreIds: json['genre_ids'],
      name: json['name'],
    );
    series.add(seriesModel);
  }
  return series.isNotEmpty ? series.first : null;
});

/// Auth page
class AuthPage extends ConsumerWidget {
  /// Auth page constructor
  AuthPage({Key? key}) : super(key: key);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loginShow = ref.watch(loginShowProvider);
    final securePassword = ref.watch(securePasswordProvider);
    final AsyncValue<Series?> principalSeries = ref.watch(
      futurePrincipalSeriesProvider,
    );
    return Scaffold(
      body: Stack(
        children: <Widget>[
          principalSeries.when(
            loading: () => SkeletonLine(
              style: SkeletonLineStyle(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
              ),
            ),
            data: (Series? data) => data != null
                ? AppNetworkImage(
                    width: ImageWidth.original,
                    path: data.backdropPath,
                  )
                : Container(),
            error: (err, stack) => Text('Error: $err'),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: Colors.black.withOpacity(0.7),
            padding: const EdgeInsets.all(16),
            child: SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Welcome!',
                    style: TextStyle(
                      fontFamily: 'Gilroy',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      AnimatedContainer(
                        height: loginShow ? 0 : 36,
                        width: loginShow ? 0 : 128,
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              const Color(0xFFFFD233),
                            ),
                            foregroundColor: MaterialStateProperty.all(
                              Colors.black,
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                          onPressed: () {},
                          child: const Text('Sign up'),
                        ),
                      ),
                      AnimatedContainer(
                        height: loginShow ? 0 : 36,
                        width: loginShow ? 0 : 128,
                        duration: const Duration(milliseconds: 300),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                              Colors.white,
                            ),
                            foregroundColor: MaterialStateProperty.all(
                              Colors.black,
                            ),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(100),
                              ),
                            ),
                          ),
                          onPressed: () {
                            ref.read(loginShowProvider.notifier).state = true;
                          },
                          child: const Text('Log in'),
                        ),
                      ),
                      AnimatedOpacity(
                        opacity: loginShow ? 0 : 1,
                        duration: const Duration(milliseconds: 300),
                        child: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'Forgot password?',
                            style: TextStyle(
                              fontFamily: 'Gilroy',
                              color: Colors.grey,
                              decorationColor: Colors.grey,
                              decorationThickness: 1,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Container(),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedContainer(
              height: loginShow ? 380 : 0,
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF191919).withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        IconButton(
                          onPressed: () {
                            ref.read(loginShowProvider.notifier).state = false;
                          },
                          icon: const Icon(Icons.close),
                          color: Colors.grey,
                        )
                      ],
                    ),
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            labelText: 'Name',
                            labelStyle: TextStyle(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                              )
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                          ),
                        ),
                        TextFormField(
                          style: TextStyle(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          decoration:InputDecoration(
                            labelText: 'Password',
                            labelStyle: TextStyle(
                              color: Colors.grey.withOpacity(0.5),
                            ),
                            alignLabelWithHint: true,
                            enabledBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.grey.withOpacity(0.5),
                                )
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.grey.withOpacity(0.5),
                                width: 2,
                              ),
                            ),
                            suffix: IconButton(
                              onPressed: () {
                                ref.read(
                                  securePasswordProvider.notifier,
                                ).state = !securePassword;
                              },
                              icon: Icon(securePassword
                                ? Icons.visibility_rounded
                                : Icons.visibility_off_rounded
                              ),
                              color: Colors.grey.withOpacity(0.5)
                            )
                          ),
                          obscureText: securePassword,
                        ),
                        AnimatedContainer(
                          height: loginShow ? 36 : 0,
                          width: loginShow ? 128 : 0,
                          margin: const EdgeInsets.only(top: 64),
                          duration: const Duration(milliseconds: 300),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                              foregroundColor: MaterialStateProperty.all(
                                Colors.black,
                              ),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100),
                                ),
                              ),
                            ),
                            onPressed: () {
                              ref.read(loginShowProvider.notifier).state = true;
                            },
                            child: const Text('Log in'),
                          ),
                        ),
                      ]
                    )
                  )
                ]
              )
            ),
          ),
        ],
      ),
    );
  }
}
