import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertest/app/core/navigation/route_name.dart';
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

  /// Form fields controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

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
                  pathWidth: ImageWidth.original,
                  path: data.backdropPath,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.cover,
                )
              : Container(),
            error: (err, stack) => Text('Error: $err', style: const TextStyle(color: Colors.white)),
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
                  Text(
                    'Welcome!',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  Column(
                    children: <Widget>[
                      AnimatedContainer(
                        height: loginShow ? 0 : 36,
                        width: loginShow ? 0 : 128,
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.only(bottom: 16),
                        child: ElevatedButton(
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
              height: loginShow ? 400 : 0,
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF191919).withOpacity(0.9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        onPressed: () {
                          FocusManager.instance.primaryFocus?.unfocus();
                          ref.read(loginShowProvider.notifier).state = false;
                        },
                        icon: const Icon(Icons.close),
                        color: Colors.grey,
                      ),
                    ],
                  ),
                  Form(
                    key: formKey,
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          controller: nameController,
                          decoration: const InputDecoration(
                            labelText: 'Name',
                          ),
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return 'This field is required';
                            }
                            if (value == 'maria' || value == 'pedro') {
                              return null;
                            }
                            return 'Not found name: ${nameController.text} '
                                'in our database';
                          },
                        ),
                        TextFormField(
                          controller: passwordController,
                          style: TextStyle(
                            color: Colors.grey.withOpacity(0.5),
                          ),
                          decoration:InputDecoration(
                            labelText: 'Password',
                            alignLabelWithHint: true,
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
                          validator: (String? value) {
                            if (value != null && value.isEmpty) {
                              return 'This field is required';
                            }
                            if (
                              value != 'password' &&
                              nameController.text == 'maria' ||
                              value != '123456' &&
                              nameController.text == 'pedro'
                            ) {
                              return 'Password is incorrect';
                            }
                            return null;
                          },
                        ),
                        Container(
                          height: 36,
                          width: 128,
                          margin: const EdgeInsets.only(top: 64),
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                Colors.white,
                              ),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Navigator.pushNamedAndRemoveUntil(
                                  context,
                                  RouteName.home,
                                  (route) => false,
                                );
                                ref.read(loginShowProvider.notifier)
                                    .state = false;
                              }
                              return;
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
