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
  //ChannelLive? channelLive;

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
    final videoUrl = "${user.serverInfo!.serverUrl}/${user.userInfo!.username}/${user.userInfo!.password}/${channel.streamId}";

    _videoPlayerController = VlcPlayerController.network(
      videoUrl,
      hwAcc: HwAcc.full,
      autoPlay: true,
    );

    setState(() {
      channelLive = channel;
      selectedStreamId = channel.streamId;
    });

    // Navigate to full-screen player
    Get.to(() => FullVideoScreen(
      isLive: true,
      link: videoUrl,
      title: channel.name ?? "",
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


class CardEpgStream extends StatelessWidget {
  const CardEpgStream({super.key, required this.streamId});
  final String? streamId;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: streamId == null
          ? const SizedBox()
          : FutureBuilder<List<EpgModel>>(
              future: IpTvApi.getEPGbyStreamId(streamId ?? ""),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: SizedBox(
                      width: 30,
                      height: 30,
                      child: CircularProgressIndicator(),
                    ),
                  );
                } else if (!snapshot.hasData) {
                  return const SizedBox();
                }
                final list = snapshot.data;

                return Container(
                  decoration: const BoxDecoration(
                      color: kColorCardLight,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                      )),
                  margin: const EdgeInsets.only(top: 10),
                  child: ListView.separated(
                    itemCount: list!.length,
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 10,
                    ),
                    itemBuilder: (_, i) {
                      final model = list[i];
                      String description =
                          utf8.decode(base64.decode(model.description ?? ""));

                      String title =
                          utf8.decode(base64.decode(model.title ?? ""));
                      return CardEpg(
                        title:
                            "${getTimeFromDate(model.start ?? "")} - ${getTimeFromDate(model.end ?? "")} - $title",
                        description: description,
                        isSameTime: checkEpgTimeIsNow(
                            model.start ?? "", model.end ?? ""),
                      );
                    },
                    separatorBuilder: (_, i) {
                      return const SizedBox(
                        height: 10,
                      );
                    },
                  ),
                );
              }),
    );
  }
}

class CardEpg extends StatelessWidget {
  const CardEpg(
      {super.key,
      required this.title,
      required this.description,
      required this.isSameTime});
  final String title;
  final String description;
  final bool isSameTime;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Get.textTheme.bodyLarge!.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 15.sp,
            color: isSameTime ? kColorPrimaryDark : Colors.white,
          ),
        ),
        Text(
          description,
          style: Get.textTheme.bodyMedium!.copyWith(
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
