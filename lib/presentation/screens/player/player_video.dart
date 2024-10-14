part of '../screens.dart';

class StreamPlayerPage extends StatefulWidget {
  const StreamPlayerPage({super.key, required this.controller});
  final VlcPlayerController? controller;

  @override
  State<StreamPlayerPage> createState() => _StreamPlayerPageState();
}

class _StreamPlayerPageState extends State<StreamPlayerPage> {
  bool isPlayed = true;
  bool showControllersVideo = true;
  late Timer timer;
  String? streamId;
  int currentChannelIndex = 0; // Keep track of the current channel index
  List<ChannelLive> channelList = []; // This list should be passed or populated with your channels

//channelList = fetchedChannels.where((channel) => channel.streamId != null).toList();


  @override
  void initState() {
    Wakelock.enable();
    super.initState();
    
    // Fetch live channels when this page is initialized
    _fetchChannels();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (showControllersVideo) {
        setState(() {
          showControllersVideo = false;
        });
      }
    });
  }

   Future<void> _fetchChannels() async {
    // Fetch channels from the bloc or API
    final channelsState = context.read<ChannelsBloc>().state;
    if (channelsState is ChannelsLiveSuccess) {
      setState(() {
        channelList = channelsState.channels
            .where((channel) => channel.streamId != null)
            .toList();
      });
    } else {
      // Handle loading or error states
      debugPrint("Failed to fetch channels");
    }
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // Method to switch channels
void _switchChannel(int direction) {
  print('object');
    if (channelList.isEmpty) {
      debugPrint("Channel list is empty");
      return;
    }

    currentChannelIndex = (currentChannelIndex + direction) % channelList.length;
    if (currentChannelIndex < 0) {
      currentChannelIndex = channelList.length - 1;
    }

    final newChannel = channelList[currentChannelIndex];
    if (newChannel.streamId != null) {
      _initialVideo(newChannel.streamId!);
    } else {
      debugPrint("Channel streamId is null");
    }
  }


    // Placeholder for the method to initialize the video
  void _initialVideo(String streamId) {
    // Your code to play the video stream based on the streamId
  }

  @override
  Widget build(BuildContext context) {
    if (widget.controller == null) {
      return const Center(
        child: Text(
          'Select a player...',
          style: TextStyle(color: Colors.grey),
        ),
      );
    }

    return Focus(
      autofocus: true,
      onKeyEvent : (FocusNode node, KeyEvent  event) {
        if (event is KeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            _switchChannel(-1); // Move to the previous channel
          } else if (event.logicalKey == LogicalKeyboardKey.enter) {
            _switchChannel(1); // Move to the next channel
          }
        }
        return KeyEventResult.handled;
      },
      child: Ink(
        color: Colors.black,
        width: getSize(context).width,
        height: getSize(context).height,
        child: Stack(
          alignment: Alignment.center,
          children: [
            VlcPlayer(
              controller: widget.controller!,
              aspectRatio: 16 / 9,
              placeholder: const Center(child: CircularProgressIndicator()),
            ),

            GestureDetector(
              onTap: () {
                debugPrint("click");
                setState(() {
                  showControllersVideo = !showControllersVideo;
                });
              },
              child: Container(
                width: getSize(context).width,
                height: getSize(context).height,
                color: Colors.transparent,
              ),
            ),

            // Controllers
            BlocBuilder<VideoCubit, VideoState>(
              builder: (context, state) {
                if (!state.isFull) {
                  return const SizedBox();
                }

                return SizedBox(
                  width: getSize(context).width,
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 400),
                    child: !showControllersVideo
                        ? const SizedBox()
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 10,
                                    ),
                                    child: IconButton(
                                      focusColor: kColorFocus,
                                      onPressed: () {
                                        context
                                            .read<VideoCubit>()
                                            .changeUrlVideo(false);
                                      },
                                      icon: const Icon(
                                          FontAwesomeIcons.chevronRight),
                                    ),
                                  ),
                                ],
                              ),
                              IconButton(
                                focusColor: kColorFocus,
                                onPressed: () {
                                  if (isPlayed) {
                                    widget.controller!.pause();
                                    isPlayed = false;
                                  } else {
                                    widget.controller!.play();
                                    isPlayed = true;
                                  }
                                  setState(() {});
                                },
                                icon: Icon(
                                  isPlayed
                                      ? FontAwesomeIcons.pause
                                      : FontAwesomeIcons.play,
                                  size: 24.sp,
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
