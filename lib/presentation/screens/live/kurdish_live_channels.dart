part of '../screens.dart';

class KurdishLiveChannelsScreen extends StatefulWidget {
  const KurdishLiveChannelsScreen({super.key, required this.catyId});
  final String catyId;

  @override
  State<KurdishLiveChannelsScreen> createState() => _KurdishLiveChannelsScreenState();
}

class _KurdishLiveChannelsScreenState extends State<KurdishLiveChannelsScreen> {
  String keySearch = "";
  ChannelLive? channelLive;

  @override
  void initState() {
    super.initState();
    // Fetch the channels for the selected category
    context.read<ChannelsBloc>().add(GetLiveChannelsEvent(
      catyId: widget.catyId,
      typeCategory: TypeCategory.live,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Ink(
        width: 100.w,
        height: 100.h,
        decoration: kDecorBackground,
        child: Column(
          children: [
            const SizedBox(height: 4),
            BlocBuilder<FavoritesCubit, FavoritesState>(
              builder: (context, state) {
                final isLiked = channelLive != null && state.lives.any((live) => live.streamId == channelLive!.streamId);
                return AppBarLive(
                  onChannels: () => Get.toNamed('/categories-live'),
                  onMovies: () => Get.toNamed('/categories-movie'),
                  onSeries: () => Get.toNamed('/categories-series'),
                  onFavs: () => Get.toNamed('/favourite'),
                  isLiked: isLiked,
                  onLike: channelLive == null ? null : () {
                    context.read<FavoritesCubit>().addLive(channelLive!, isAdd: !isLiked);
                  },
                  onSearch: (String value) => setState(() => keySearch = value),
                );
              },
            ),
            const SizedBox(height: 15),
            Expanded(
              child: BlocBuilder<ChannelsBloc, ChannelsState>(
                builder: (context, state) {
                  if (state is ChannelsLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChannelsLiveSuccess) {
                    final categories = state.channels;
                    final searchList = categories.where((element) => element.name!.toLowerCase().contains(keySearch)).toList();

                    return BlocBuilder<AuthBloc, AuthState>(
  builder: (context, stateAuth) {
    if (stateAuth is AuthLoading) {
      // Show a loading indicator while the authentication state is loading
      return Center(child: CircularProgressIndicator());
    } else if (stateAuth is AuthSuccess) {
      // Safe to access user data only if the state is AuthSuccess
      final user = stateAuth.user;

      return GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        itemCount: keySearch.isEmpty ? categories.length : searchList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 6,
        ),
        itemBuilder: (_, i) {
          final model = keySearch.isEmpty ? categories[i] : searchList[i];
          final link = "${user.serverInfo!.serverUrl}/${user.userInfo!.username}/${user.userInfo!.password}/${model.streamId}";

          return CardLiveItem(
            title: model.name ?? "",
            image: model.streamIcon,
            onTap: () {
              // Navigate to the full-screen view for the selected channel
              Get.to(() => FullVideoScreen(
                isLive: true,
                link: link,
                title: model.name ?? "",
              ));
            },
          );
        },
      );
    } else {
      // Show an error message or alternative UI if the authentication failed or is in another unexpected state
      return Center(child: Text("Unable to load content. Please try again."));
    }
  },
);

                  }
                  return const Center(child: Text("Failed to load data..."));
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
