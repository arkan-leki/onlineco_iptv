part of 'screens.dart';

class NewWelcomeScreen extends StatefulWidget {
  const NewWelcomeScreen({super.key});

  @override
  State<NewWelcomeScreen> createState() => _NewWelcomeScreenState();
}

class _NewWelcomeScreenState extends State<NewWelcomeScreen> {
  late InterstitialAd _interstitialAd;


  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().initialData();
    context.read<WatchingCubit>().initialData();


  //   // Automatically navigate to Kurdish channels with category_id = 1
  //   WidgetsBinding.instance.addPostFrameCallback((_) {
  //     Get.to(() => KurdishLiveChannelsScreen(catyId: '1'))!.then((value) async {
  //       _interstitialAd.show();
        
  //     });
  //   });
  // }



  // Automatically navigate to Kurdish channels with category_id = 1
  WidgetsBinding.instance.addPostFrameCallback((_) {
    // Only navigate if not already navigating
    if (!Get.currentRoute.contains('KurdishLiveChannelsScreen')) {
      Get.to(() => KurdishLiveChannelsScreen(catyId: '1'))!.then((value) async {
        _interstitialAd.show();
      });
    }
  });
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Ink(
        width: getSize(context).width,
        height: getSize(context).height,
        decoration: kDecorBackground,
        padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
        child: Column(
          children: [
            const AppBarWelcome(),
            const SizedBox(height: 10),
            Expanded(
              child: Center(
                child: Text("Redirecting to Kurdish Channels..."),
              ),
            ),
            AdmobWidget.getBanner(),
          ],
        ),
      ),
    );
  }
}
