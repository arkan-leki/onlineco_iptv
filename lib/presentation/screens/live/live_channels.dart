part of '../screens.dart';

class LiveChannelsScreen extends StatefulWidget {
  const LiveChannelsScreen({Key? key, required this.catyId}) : super(key: key);
  final String catyId;

  @override
  State<LiveChannelsScreen> createState() => _LiveChannelsScreenState();
}

class _LiveChannelsScreenState extends State<LiveChannelsScreen> {
  String keySearch = "";
  ChannelLive? channelLive;
  VlcPlayerController? _videoPlayerController;
  String? selectedStreamId;

  @override
  void initState() {
    super.initState();

    // Use the passed catyId to fetch channels for this category
    context.read<ChannelsBloc>().add(GetLiveChannelsEvent(
      catyId: widget.catyId,
      typeCategory: TypeCategory.live,
    ));
  }

  @override
  void dispose() async {
    super.dispose();
    if (_videoPlayerController != null) {
      await _videoPlayerController!.stopRendererScanning();
      await _videoPlayerController!.dispose();
    }
  }

  // Open selected video in full-screen mode
  void _playChannel(ChannelLive channel) async {
    final user = (context.read<AuthBloc>().state as AuthSuccess).user;
    final baseUrl = "${user.serverInfo!.serverUrl}/${user.userInfo!.username}/${user.userInfo!.password}";

    setState(() {
      channelLive = channel;
      selectedStreamId = channel.streamId;
    });

    // Navigate to full-screen player
    Get.to(() => LiveFullVideoScreen(
      isLive: true,
      baseUrl: baseUrl,
      title: channel.name ?? "",
      channels: context.read<ChannelsBloc>().state is ChannelsLiveSuccess
          ? (context.read<ChannelsBloc>().state as ChannelsLiveSuccess).channels
          : [],
      initialIndex: context.read<ChannelsBloc>().state is ChannelsLiveSuccess
          ? (context.read<ChannelsBloc>().state as ChannelsLiveSuccess).channels.indexOf(channel)
          : 0,
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
            Builder(
              builder: (context) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                  ],
                );
              },
            ),
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
                          return Center(child: CircularProgressIndicator());
                        } else if (stateAuth is AuthSuccess) {
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
                                  _playChannel(model);
                                },
                              );
                            },
                          );
                        } else {
                          return const Center(child: Text("Unable to load content. Please try again."));
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
