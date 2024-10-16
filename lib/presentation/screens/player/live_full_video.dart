part of '../screens.dart';

class LiveFullVideoScreen extends StatefulWidget {
  const LiveFullVideoScreen({
    super.key,
    required this.baseUrl,
    required this.title,
    required this.channels,
    required this.initialIndex,
    this.isLive = false,
  });
  final String baseUrl;
  final String title;
  final List<ChannelLive> channels;
  final int initialIndex;
  final bool isLive;

  @override
  State<LiveFullVideoScreen> createState() => _LiveFullVideoScreenState();
}

class _LiveFullVideoScreenState extends State<LiveFullVideoScreen> {
  late VlcPlayerController _videoPlayerController;
  int currentIndex = 0;
  bool isPlayed = true;
  bool progress = true;
  bool showControllersVideo = true;
  String position = '';
  String duration = '';
  double sliderValue = 0.0;
  bool validPosition = false;
  double _currentVolume = 0.0;
  double _currentBright = 0.0;
  late Timer timer;

  final ScreenBrightnessUtil _screenBrightnessUtil = ScreenBrightnessUtil();

  _settingPage() async {
    try {
      double brightness = await _screenBrightnessUtil.getBrightness();
      if (brightness == -1) {
        debugPrint("Oops... something wrong!");
      } else {
        _currentBright = brightness;
      }

      VolumeController().listener((volume) {
        setState(() => _currentVolume = volume);
      });
      VolumeController().getVolume().then((volume) => _currentVolume = volume);

      setState(() {});
    } catch (e) {
      debugPrint("Error: setting: $e");
    }
  }

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
    _initializeVideoPlayer(_getChannelLink(widget.channels[currentIndex]));
    _settingPage();

    timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (showControllersVideo) {
        setState(() {
          showControllersVideo = false;
        });
      }
    });
  }

  String _getChannelLink(ChannelLive channel) {
    return "${widget.baseUrl}/${channel.streamId}";
  }

  void _initializeVideoPlayer(String link) {
    _videoPlayerController = VlcPlayerController.network(
      link,
      hwAcc: HwAcc.full,
      autoPlay: true,
      autoInitialize: true,
      options: VlcPlayerOptions(),
    );
    _videoPlayerController.addListener(_videoListener);
  }

  void _videoListener() {
    if (!mounted) return;

    if (progress && _videoPlayerController.value.isPlaying) {
      setState(() => progress = false);
    }

    if (_videoPlayerController.value.isInitialized) {
      final oPosition = _videoPlayerController.value.position;
      final oDuration = _videoPlayerController.value.duration;

      if (oDuration.inHours == 0) {
        position = "${oPosition.toString().split(':')[1]}:${oPosition.toString().split(':')[2]}";
        duration = "${oDuration.toString().split(':')[1]}:${oDuration.toString().split(':')[2]}";
      } else {
        position = oPosition.toString().split('.')[0];
        duration = oDuration.toString().split('.')[0];
      }
      validPosition = oDuration.compareTo(oPosition) >= 0;
      sliderValue = validPosition ? oPosition.inSeconds.toDouble() : 0;
      setState(() {});
    }
  }

  Future<void> _switchChannel(int direction) async {
    // Calculate the new channel index
    currentIndex = (currentIndex + direction) % widget.channels.length;
    if (currentIndex < 0) currentIndex = widget.channels.length - 1;

    String newLink = _getChannelLink(widget.channels[currentIndex]);

    // Stop the current video stream and set a new one without disposing the controller
    await _videoPlayerController.stop();
    await _videoPlayerController.setMediaFromNetwork(newLink);
    _videoPlayerController.play();
  }

  void _onSliderPositionChanged(double progress) {
    setState(() {
      sliderValue = progress.floor().toDouble();
    });
    _videoPlayerController.setTime((sliderValue * 1000).toInt());
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    timer.cancel();
    VolumeController().removeListener();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKey: (node, event) {
        if (event is RawKeyDownEvent) {
          if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
            _switchChannel(-1);
          } else if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
            _switchChannel(1);
          }
        }
        return KeyEventResult.handled;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: getSize(context).width,
              height: getSize(context).height,
              color: Colors.black,
              child: VlcPlayer(
                controller: _videoPlayerController,
                aspectRatio: 16 / 9,
                virtualDisplay: true,
                placeholder: const Center(child: CircularProgressIndicator()),
              ),
            ),
            if (progress)
              const Center(child: CircularProgressIndicator(color: kColorPrimary)),

            GestureDetector(
              onTap: () {
                setState(() => showControllersVideo = !showControllersVideo);
              },
              child: Container(
                width: getSize(context).width,
                height: getSize(context).height,
                color: Colors.transparent,
                child: AnimatedSize(
                  duration: const Duration(milliseconds: 200),
                  child: !showControllersVideo
                      ? const SizedBox()
                      : SafeArea(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  IconButton(
                                    focusColor: kColorFocus,
                                    onPressed: () async {
                                      await Future.delayed(const Duration(milliseconds: 1000))
                                          .then((value) {
                                        Get.back(
                                          result: progress
                                              ? null
                                              : [sliderValue, _videoPlayerController.value.duration.inSeconds.toDouble()],
                                        );
                                      });
                                    },
                                    icon: Icon(
                                      FontAwesomeIcons.chevronLeft,
                                      size: 19.sp,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Expanded(
                                    child: Text(
                                      widget.title,
                                      maxLines: 1,
                                      style: Get.textTheme.labelLarge!.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.sp,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (!progress && !widget.isLive)
                                Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Slider(
                                          activeColor: kColorPrimary,
                                          inactiveColor: Colors.white,
                                          value: sliderValue,
                                          min: 0.0,
                                          max: (!validPosition)
                                              ? 1.0
                                              : _videoPlayerController.value.duration.inSeconds.toDouble(),
                                          onChanged: validPosition ? _onSliderPositionChanged : null,
                                        ),
                                      ),
                                      Text(
                                        "$position / $duration",
                                        style: Get.textTheme.titleSmall!.copyWith(fontSize: 15.sp),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
