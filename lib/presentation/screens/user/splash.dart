part of '../screens.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  // Hardcoded credentials for auto-login
  final String hardcodedUsername = "onlinetv";
  final String hardcodedPassword = "onlinetv";
  final String hardcodedLink =
      "http://onlinekurdistantv.com:8080"; // This could be your API endpoint

  void goScreen(String screen) {
    Future.delayed(const Duration(seconds: 3)).then((value) {
      Get.offAndToNamed(screen);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (isTv(context)) {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      } else {
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitDown,
          DeviceOrientation.portraitUp,
        ]);
      }
      context.read<SettingsCubit>().getSettingsCode();

      // Trigger the auto-login
      context.read<AuthBloc>().add(AuthRegister(
          hardcodedUsername, hardcodedPassword, hardcodedPassword));
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("width: ${MediaQuery.of(context).size.width}");
    return Scaffold(
      body: OrientationBuilder(builder: (context, orientation) {
        return BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSuccess) {
              context.read<LiveCatyBloc>().add(GetLiveCategories());
              context.read<MovieCatyBloc>().add(GetMovieCategories());
              context.read<SeriesCatyBloc>().add(GetSeriesCategories());
              goScreen(screenWelcome);
            } else if (state is AuthFailed) {
              if (isTv(context)) {
                goScreen(screenRegisterTv);
              } else {
                goScreen(screenIntro);
              }
            }
          },
          child: const LoadingWidget(),
        );
      }),
    );
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: getSize(context).width,
      height: getSize(context).height,
      decoration: kDecorBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image(
            width: getSize(context).height * .22,
            height: getSize(context).height * .22,
            image: const AssetImage(kIconSplash),
          ),
          const SizedBox(height: 10),
          Text(
            kAppName,
            style: Get.textTheme.displaySmall,
          ),
          BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthLoading) {
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 15),
                  child: const CircularProgressIndicator(),
                );
              } else if (state is AuthFailed) {
                return const Text('');
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
