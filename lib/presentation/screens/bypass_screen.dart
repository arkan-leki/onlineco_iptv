part of 'screens.dart';

class BypassScreen extends StatefulWidget {
  const BypassScreen({super.key});

  @override
  State<BypassScreen> createState() => _BypassScreenState();
}

class _BypassScreenState extends State<BypassScreen> {
  @override
  void initState() {
    super.initState();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Pass the correct category ID for OSN (assuming it's 1)
      Get.to(() => LiveChannelsScreen(catyId: "1"));
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




// part of 'screens.dart';

// class BypassScreen extends StatefulWidget {
//   const BypassScreen({super.key});

//   @override
//   State<BypassScreen> createState() => _BypassScreenState();
// }

// class _BypassScreenState extends State<BypassScreen> {
//   late InterstitialAd _interstitialAd;


//   @override
//   void initState() {
//     super.initState();
//     context.read<FavoritesCubit>().initialData();
//     context.read<WatchingCubit>().initialData();

//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       Get.toNamed(screenLiveCategories)!.then((value) async {
//         _interstitialAd.show();
//           }
//         );
//       }
//     );
//   }

//   /*

//   WidgetsBinding.instance.addPostFrameCallback((_) {
//       // Replace the category_id with the actual id for OSN channels
//       int osnCategoryId = 1; // Set to the correct ID for OSN channels
//       Get.toNamed('/LiveChannelsScreen', arguments: {'category_id': osnCategoryId})!.then((value) async {
//         _interstitialAd.show();
//       });
//     });

//   */

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       body: Center(
//         child: CircularProgressIndicator(),
//       ),
//     );
//   }
// }
