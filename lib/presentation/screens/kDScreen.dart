part of 'screens.dart';

class KDScreen extends StatefulWidget {
  const KDScreen({super.key});

  @override
  State<KDScreen> createState() => _KDScreen();
}

class _KDScreen extends State<KDScreen> {
  late InterstitialAd _interstitialAd;


  @override
  void initState() {
    super.initState();
    context.read<FavoritesCubit>().initialData();
    context.read<WatchingCubit>().initialData();

    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   Get.toNamed(kDScreen)!.then((value) async {
    //     _interstitialAd.show();
    //       }
    //     );
    //   }
    // );
  

  

  WidgetsBinding.instance.addPostFrameCallback((_) {
      // Replace the category_id with the actual id for OSN channels
      int osnCategoryId = 1; // Set to the correct ID for OSN channels
      Get.toNamed('/KDScreen', arguments: {'category_id': osnCategoryId})!.then((value) async {
        _interstitialAd.show();
      });
    });

  


}



  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
