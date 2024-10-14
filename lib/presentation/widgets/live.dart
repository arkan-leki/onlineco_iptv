part of 'widgets.dart';



//-------------------------------------------- _ AppBar Live _ --------------------------------------------\\

class AppBarLive extends StatefulWidget {
  const AppBarLive({
    super.key,
    this.onSearch,
    this.isLiked = false,
    this.onLike,
    this.onClose,
    this.onChannels,
    this.onMovies, // Add onMovies callback
    this.onSeries, // Add onSeries callback
    this.onFavs,
  });
  final Function(String)? onSearch;
  final bool isLiked;
  final Function()? onLike;
  final Function()? onClose; // New onClose parameter
  final Function()? onChannels;
  final Function()? onMovies; // Callback for Movies button
  final Function()? onSeries; // Callback for Series button
  final Function()? onFavs;

  @override
  State<AppBarLive> createState() => _AppBarLiveState();
}

class _AppBarLiveState extends State<AppBarLive> {
  bool showSearch = false;
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3), // Background color with transparency
        borderRadius: BorderRadius.circular(20), // Smooth rounded corners
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/movie-frame.png', // top left logo
            width: 28,
            height: 46,
          ),
          const SizedBox(width: 1),
          const Text(
            "N Lin TV",
            style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 24),
          ),


          // Text(
          //   kAppName,
          //   style: Get.textTheme.headlineMedium,
          // ),
          Container(
            width: 1,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 13),
            color: Colors.white.withOpacity(0.6),
          ),
          
          const Spacer(),


          // other live channels button

          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: widget.onChannels, focusColor: const Color.fromARGB(255, 255, 238, 0),  //Color.fromARGB(255, 0, 238, 255), // focus color
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/live-channel.png', // Movie icon image
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Live',
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //const SizedBox(width: 50),
          const Spacer(),

          // Movies button with background
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: widget.onMovies, focusColor: const Color.fromARGB(255, 255, 238, 0),  //Color.fromARGB(255, 0, 238, 255), // focus color
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/video.png', // Movie icon image
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Movies',
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          //const SizedBox(width: 50),
          const Spacer(),
          // Series button with background
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: widget.onSeries, focusColor: const Color.fromARGB(255, 255, 238, 0), // focus color
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/film-reel.png', // Series icon image
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Series',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),


// Favs button with background
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: widget.onFavs, focusColor: const Color.fromARGB(255, 255, 238, 0), // focus color
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/love.png', // Series icon image
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Favs',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Search and other actions
          showSearch
              ? Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: TextField(
                      controller: _search,
                      onChanged: widget.onSearch,
                      decoration: const InputDecoration(
                        hintText: "Search...",
                      ),
                    ),
                  ),
                )
              : const Spacer(),
          if (showSearch)
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.xmark,
                color: Colors.white,
              ),
              focusColor: kColorPrimary,
              onPressed: () {
                if (widget.onSearch != null) {
                  widget.onSearch!("");
                }
                setState(() {
                  showSearch = false;
                  _search.clear();
                });
              },
            ),

          if (!showSearch)
            IconButton(
              focusColor: kColorFocus,
              onPressed: () {
                setState(() {
                  showSearch = true;
                });
              },
              icon: const Icon(
                FontAwesomeIcons.magnifyingGlass,
                color: Colors.white,
              ),
            ),

          if (widget.onLike != null)
            IconButton(
              focusColor: kColorFocus,
              onPressed: widget.onLike,
              icon: Icon(
                widget.isLiked
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart,
                color: Colors.white,
              ),
            ),

          if (widget.onLike != null)
            IconButton(
              focusColor: kColorFocus,
              onPressed: widget.onClose,
              icon: const Icon(
                FontAwesomeIcons.chevronRight,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}







//-------------------------------------------- _ AppBar Live Category _ --------------------------------------------\\

class AppBarLiveCategory extends StatefulWidget {
  const AppBarLiveCategory({
    super.key,
    this.onSearch,
    this.isLiked = false,
    this.onLike,
    this.onClose,
    //this.onChannels,
    this.onMovies, // Add onMovies callback
    this.onSeries, // Add onSeries callback
    this.onFavs,


  });
  final Function(String)? onSearch;
  final bool isLiked;
  final Function()? onLike;
  final Function()? onClose; // New onClose parameter
  //final Function()? onChannels;
  final Function()? onMovies; // Callback for Movies button
  final Function()? onSeries; // Callback for Series button
  final Function()? onFavs;

  @override
  State<AppBarLiveCategory> createState() => _AppBarLiveCategoryState();
}

class _AppBarLiveCategoryState extends State<AppBarLiveCategory> {
  bool showSearch = false;
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3), // Background color with transparency
        borderRadius: BorderRadius.circular(20), // Smooth rounded corners
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/movie-frame.png', // top left logo
            width: 50,
            height: 50,
          ),
          // const SizedBox(width: 5),
          // Text(
          //   kAppName,
          //   style: Get.textTheme.headlineMedium,
          // ),
          Container(
            width: 1,
            height: 40,
            margin: const EdgeInsets.symmetric(horizontal: 13),
            color: Colors.white.withOpacity(0.6),
          ),
          const Spacer(),


          // // other live channels button

          // Container(
          //   padding: const EdgeInsets.all(8),
          //   decoration: BoxDecoration(
          //     color: Colors.white.withOpacity(0.2),
          //     borderRadius: BorderRadius.circular(12),
          //   ),
          //   child: Row(
          //     mainAxisSize: MainAxisSize.min,
          //     children: [
          //       InkWell(
          //         onTap: widget.onChannels, focusColor: const Color.fromARGB(255, 255, 238, 0),  //Color.fromARGB(255, 0, 238, 255), // focus color
          //         child: Row(
          //           children: [
          //             Image.asset(
          //               'assets/images/live-channel.png', // Movie icon image
          //               width: 40,
          //               height: 40,
          //             ),
          //             const SizedBox(width: 10),
          //             const Text(
          //               'Live Channels',
          //               style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 18),
          //             ),
          //           ],
          //         ),
          //       ),
          //     ],
          //   ),
          // ),

          // const SizedBox(width: 50),


          // Movies button with background
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: widget.onMovies, focusColor: const Color.fromARGB(255, 255, 238, 0),  //Color.fromARGB(255, 0, 238, 255), // focus color
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/video.png', // Movie icon image
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Movies',
                        style: TextStyle(color: Color.fromARGB(255, 255, 255, 255), fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Series button with background
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: widget.onSeries, focusColor: const Color.fromARGB(255, 255, 238, 0), // focus color
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/film-reel.png', // Series icon image
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Series',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),


          
// Favs button with background
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  onTap: widget.onFavs, focusColor: const Color.fromARGB(255, 255, 238, 0), // focus color
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/love.png', // Series icon image
                        width: 40,
                        height: 40,
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'Favs',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),

          // Search and other actions
          showSearch
              ? Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(left: 15),
                    child: TextField(
                      controller: _search,
                      onChanged: widget.onSearch,
                      decoration: const InputDecoration(
                        hintText: "Search...",
                      ),
                    ),
                  ),
                )
              : const Spacer(),
          if (showSearch)
            IconButton(
              icon: const Icon(
                FontAwesomeIcons.xmark,
                color: Colors.white,
              ),
              focusColor: kColorPrimary,
              onPressed: () {
                if (widget.onSearch != null) {
                  widget.onSearch!("");
                }
                setState(() {
                  showSearch = false;
                  _search.clear();
                });
              },
            ),

          if (!showSearch)
            IconButton(
              focusColor: kColorFocus,
              onPressed: () {
                setState(() {
                  showSearch = true;
                });
              },
              icon: const Icon(
                FontAwesomeIcons.magnifyingGlass,
                color: Colors.white,
              ),
            ),

          if (widget.onLike != null)
            IconButton(
              focusColor: kColorFocus,
              onPressed: widget.onLike,
              icon: Icon(
                widget.isLiked
                    ? FontAwesomeIcons.solidHeart
                    : FontAwesomeIcons.heart,
                color: Colors.white,
              ),
            ),

          if (widget.onLike != null)
            IconButton(
              focusColor: kColorFocus,
              onPressed: widget.onClose,
              icon: const Icon(
                FontAwesomeIcons.chevronRight,
                color: Colors.white,
              ),
            ),

            IconButton(
              focusColor: kColorFocus,
              onPressed: () {
                context.read<VideoCubit>().changeUrlVideo(false);
                
                // Navigate explicitly to the Live Channels screen and remove previous routes
                Get.offAllNamed('/KurdishLiveChannelsScreen', arguments: {'catyId': '1'});
                
                print("Navigating to Live Channels screen from the beginning.");
              },
              icon: const Icon(
                FontAwesomeIcons.chevronLeft, // Change to chevronLeft for clarity
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}





//-------------------------------------------- _ AppBar Movie categoty _ --------------------------------------------\\

class AppBarMoviecategoty extends StatefulWidget {
  const AppBarMoviecategoty(
      {super.key,
      this.onSearch,
      this.onFavorite,
      this.top,
      this.isLiked = false});

  final Function()? onFavorite;
  final Function(String)? onSearch;
  final double? top;
  final bool isLiked;

  @override
  State<AppBarMoviecategoty> createState() => _AppBarMoviecategotyState();
}

class _AppBarMoviecategotyState extends State<AppBarMoviecategoty> {
  bool showSearch = false;
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 100.w,
      color: Colors.transparent,
      margin: EdgeInsets.only(top: widget.top ?? 4.h, left: 10, right: 10),
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            Image.asset(
            'assets/images/movie-frame.png', // // top left logo
            width: 50,
            height: 50,
          ),
            // const SizedBox(width: 5),
            // Text(
            //   kAppName,
            //   style: Get.textTheme.headlineMedium,
            // ),
            Container(
              width: 1,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 13),
              color: kColorHint,
            ),
            Image.asset(
                        'assets/images/video.png', // Movie icon image
                        width: 40,
                        height: 40,
                      ),
            const Spacer(),
            showSearch
                ? Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: TextField(
                        controller: _search,
                        onChanged: widget.onSearch,
                        decoration: const InputDecoration(
                          hintText: "Search...",
                        ),
                      ),
                    ),
                  )
                : const Spacer(),
            if (showSearch)
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.xmark,
                  color: Colors.white,
                ),
                focusColor: kColorPrimary,
                onPressed: () {
                  if (widget.onSearch != null) {
                    widget.onSearch!("");
                  }

                  setState(() {
                    showSearch = false;
                    _search.clear();
                  });
                },
              ),
            if (widget.onSearch != null)
              if (!showSearch)
                IconButton(
                  focusColor: kColorFocus,
                  onPressed: () {
                    setState(() {
                      showSearch = true;
                    });
                  },
                  icon: const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.white,
                  ),
                ),
            if (widget.onFavorite != null)
              IconButton(
                focusColor: kColorFocus,
                onPressed: widget.onFavorite,
                icon: Icon(
                  widget.isLiked
                      ? FontAwesomeIcons.solidHeart
                      : FontAwesomeIcons.heart,
                  color: Colors.white,
                ),
              ),
            IconButton(
              focusColor: kColorFocus,
              onPressed: () {
                context.read<VideoCubit>().changeUrlVideo(false);
                
                // Navigate explicitly to the Live Channels screen and remove previous routes
                Get.offAllNamed('/KurdishLiveChannelsScreen', arguments: {'catyId': '1'});
                
                print("Navigating to Live Channels screen from the beginning.");
              },
              icon: const Icon(
                FontAwesomeIcons.chevronLeft, // Change to chevronLeft for clarity
                color: Colors.white,
              ),
            ),


          ],
        ),
      ),
    );
  }
}





//-------------------------------------------- _ AppBar Movie channels _ --------------------------------------------\\


class AppBarMovieMovies extends StatefulWidget {
  const AppBarMovieMovies(
      {super.key,
      this.onSearch,
      this.onFavorite,
      this.top,
      this.isLiked = false});

  final Function()? onFavorite;
  final Function(String)? onSearch;
  final double? top;
  final bool isLiked;

  @override
  State<AppBarMovieMovies> createState() => _AppBarMovieMoviesState();
}

class _AppBarMovieMoviesState extends State<AppBarMovieMovies> {
  bool showSearch = false;
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      //width: 100.w,
      color: Colors.transparent,
      margin: EdgeInsets.only(top: widget.top ?? 4.h, left: 10, right: 10),
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            Image.asset(
            'assets/images/movie-frame.png', // // top left logo
            width: 50,
            height: 50,
          ),
            // const SizedBox(width: 5),
            // Text(
            //   kAppName,
            //   style: Get.textTheme.headlineMedium,
            // ),
            Container(
              width: 1,
              height: 40,
              margin: const EdgeInsets.symmetric(horizontal: 13),
              color: kColorHint,
            ),
            Image.asset(
                        'assets/images/video.png', // Movie icon image
                        width: 40,
                        height: 40,
                      ),
            const Spacer(),
            showSearch
                ? Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: TextField(
                        controller: _search,
                        onChanged: widget.onSearch,
                        decoration: const InputDecoration(
                          hintText: "Search...",
                        ),
                      ),
                    ),
                  )
                : const Spacer(),
            if (showSearch)
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.xmark,
                  color: Colors.white,
                ),
                focusColor: kColorPrimary,
                onPressed: () {
                  if (widget.onSearch != null) {
                    widget.onSearch!("");
                  }

                  setState(() {
                    showSearch = false;
                    _search.clear();
                  });
                },
              ),
            if (widget.onSearch != null)
              if (!showSearch)
                IconButton(
                  focusColor: kColorFocus,
                  onPressed: () {
                    setState(() {
                      showSearch = true;
                    });
                  },
                  icon: const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.white,
                  ),
                ),
            if (widget.onFavorite != null)
              IconButton(
                focusColor: kColorFocus,
                onPressed: widget.onFavorite,
                icon: Icon(
                  widget.isLiked
                      ? FontAwesomeIcons.solidHeart
                      : FontAwesomeIcons.heart,
                  color: Colors.white,
                ),
              ),
            IconButton(
              focusColor: kColorFocus,
              onPressed: () {
                context.read<VideoCubit>().changeUrlVideo(false);
                Get.back(); // Ensure this is the last route in the stack
              print("Attempting to go back to the previous screen.");
              

              },
              icon: const Icon(
                FontAwesomeIcons.chevronLeft, // Change to chevronLeft for clarity
                color: Colors.white,
              ),
            ),

          ],
        ),
      ),
    );
  }
}


//-------------------------------------------- _ AppBar Series _ --------------------------------------------\\



class AppBarSeries extends StatefulWidget {
  const AppBarSeries(
      {super.key,
      this.onSearch,
      this.onFavorite,
      this.top,
      this.isLiked = false});

  final Function()? onFavorite;
  final Function(String)? onSearch;
  final double? top;
  final bool isLiked;

  @override
  State<AppBarSeries> createState() => _AppBarSeriesState();
}

class _AppBarSeriesState extends State<AppBarSeries> {
  bool showSearch = false;
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(top: widget.top ?? 4.h, left: 10, right: 10),
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            Image.asset(
            'assets/images/movie-frame.png', // top left logo
            width: 50,
            height: 50,
          ),
            const SizedBox(width: 5),
            // Text(
            //   kAppName,
            //   style: Get.textTheme.headlineMedium,
            // ),
            Container(
              width: 1,
              height: 8.h,
              margin: const EdgeInsets.symmetric(horizontal: 13),
              color: kColorHint,
            ),
             Image.asset(
                        'assets/images/film-reel.png', // Series icon image
                        width: 40,
                        height: 40,
                      ),
            const Spacer(),
            showSearch
                ? Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: TextField(
                        controller: _search,
                        onChanged: widget.onSearch,
                        decoration: const InputDecoration(
                          hintText: "Search...",
                        ),
                      ),
                    ),
                  )
                : const Spacer(),
            if (showSearch)
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.xmark,
                  color: Colors.white,
                ),
                focusColor: kColorPrimary,
                onPressed: () {
                  if (widget.onSearch != null) {
                    widget.onSearch!("");
                  }

                  setState(() {
                    showSearch = false;
                    _search.clear();
                  });
                },
              ),
            if (widget.onSearch != null)
              if (!showSearch)
                IconButton(
                  focusColor: kColorFocus,
                  onPressed: () {
                    setState(() {
                      showSearch = true;
                    });
                  },
                  icon: const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.white,
                  ),
                ),
            if (widget.onFavorite != null)
              IconButton(
                focusColor: kColorFocus,
                onPressed: widget.onFavorite,
                icon: Icon(
                  widget.isLiked
                      ? FontAwesomeIcons.solidHeart
                      : FontAwesomeIcons.heart,
                  color: Colors.white,
                ),
              ),
            IconButton(
              focusColor: kColorFocus,
              onPressed: () {
                context.read<VideoCubit>().changeUrlVideo(false);
                Get.back();
              },
              icon: const Icon(
                FontAwesomeIcons.chevronLeft,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}








//-------------------------------------------- _ AppBar Series category _ --------------------------------------------\\



class AppBarSeriesCategory extends StatefulWidget {
  const AppBarSeriesCategory(
      {super.key,
      this.onSearch,
      this.onFavorite,
      this.top,
      this.isLiked = false});

  final Function()? onFavorite;
  final Function(String)? onSearch;
  final double? top;
  final bool isLiked;

  @override
  State<AppBarSeriesCategory> createState() => _AppBarSeriesCategoryState();
}

class _AppBarSeriesCategoryState extends State<AppBarSeriesCategory> {
  bool showSearch = false;
  final _search = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      margin: EdgeInsets.only(top: widget.top ?? 4.h, left: 10, right: 10),
      child: Material(
        color: Colors.transparent,
        child: Row(
          children: [
            Image.asset(
            'assets/images/movie-frame.png', // top left logo
            width: 50,
            height: 80,
          ),
            // const SizedBox(width: 5),
            // Text(
            //   kAppName,
            //   style: Get.textTheme.headlineMedium,
            // ),
            Container(
              width: 1,
              height: 8.h,
              margin: const EdgeInsets.symmetric(horizontal: 13),
              color: kColorHint,
            ),
            Image.asset(
                        'assets/images/film-reel.png', // Series icon image
                        width: 40,
                        height: 40,
            ),
            const Spacer(),
            showSearch
                ? Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(left: 15),
                      child: TextField(
                        controller: _search,
                        onChanged: widget.onSearch,
                        decoration: const InputDecoration(
                          hintText: "Search...",
                        ),
                      ),
                    ),
                  )
                : const Spacer(),
            if (showSearch)
              IconButton(
                icon: const Icon(
                  FontAwesomeIcons.xmark,
                  color: Colors.white,
                ),
                focusColor: kColorPrimary,
                onPressed: () {
                  if (widget.onSearch != null) {
                    widget.onSearch!("");
                  }

                  setState(() {
                    showSearch = false;
                    _search.clear();
                  });
                },
              ),
            if (widget.onSearch != null)
              if (!showSearch)
                IconButton(
                  focusColor: kColorFocus,
                  onPressed: () {
                    setState(() {
                      showSearch = true;
                    });
                  },
                  icon: const Icon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.white,
                  ),
                ),
            if (widget.onFavorite != null)
              IconButton(
                focusColor: kColorFocus,
                onPressed: widget.onFavorite,
                icon: Icon(
                  widget.isLiked
                      ? FontAwesomeIcons.solidHeart
                      : FontAwesomeIcons.heart,
                  color: Colors.white,
                ),
              ),
            IconButton(
              focusColor: kColorFocus,
              onPressed: () {
                context.read<VideoCubit>().changeUrlVideo(false);
                
                // Navigate explicitly to the Live Channels screen and remove previous routes
                Get.offAllNamed('/KurdishLiveChannelsScreen', arguments: {'catyId': '1'});
                
                print("Navigating to Live Channels screen from the beginning.");
              },
              icon: const Icon(
                FontAwesomeIcons.chevronLeft, // Change to chevronLeft for clarity
                color: Colors.white,
              ),
            ),

          ],
        ),
      ),
    );
  }
}




//-------------------------------------------- _ AppBar Settings _ --------------------------------------------\\




class AppBarSettings extends StatelessWidget {
  const AppBarSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      color: Colors.transparent,
      //  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Image(
            width: 0.3.dp,
            height: 0.3.dp,
            image: const AssetImage(kIconSplash),
          ),
          const SizedBox(width: 5),
          Text(
            "Settings",
            style: Get.textTheme.headlineMedium,
          ),
          Container(
            width: 1,
            height: 8.h,
            margin: const EdgeInsets.symmetric(horizontal: 13),
            color: kColorHint,
          ),
          Icon(
            FontAwesomeIcons.gear,
            size: 20.sp,
            color: Colors.white,
          ),
          const Spacer(),
          IconButton(
            focusColor: kColorFocus,
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              FontAwesomeIcons.chevronRight,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}




//-------------------------------------------- _ Card Live Item _ --------------------------------------------\\


class CardLiveItem extends StatelessWidget {
  const CardLiveItem(
      {super.key,
      required this.title,
      required this.onTap,
      this.isSelected = false,
      this.link,
      this.image});
  final String title;
  final Function() onTap;
  final bool isSelected;
  final String? link;
  final String? image;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      focusColor: kColorFocus,
      borderRadius: BorderRadius.circular(10),
      child: Ink(
        decoration: BoxDecoration(
          color: kColorCardLight,
          borderRadius: BorderRadius.circular(10),
          border: isSelected ? Border.all(color: Colors.yellow) : null,
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: [
            image != null && !isSelected
                ? CachedNetworkImage(
                    imageUrl: image ?? "",
                    width: 14.w,
                    //height: 50.h,
                    errorWidget: (_, i, e) {
                      return Icon(
                        FontAwesomeIcons.tv,
                        size: isSelected ? 18.sp : 16.sp,
                        color: Colors.white,
                      );
                    },
                  )
                : Icon(
                    isSelected ? FontAwesomeIcons.play : FontAwesomeIcons.tv,
                    size: isSelected ? 18.sp : 16.sp,
                    color: Colors.white,
                  ),
            const SizedBox(width: 13),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Get.textTheme.headlineSmall!.copyWith(
                  color: Colors.white,
                ),
              ),
            ),
            if (isSelected && link != null)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Icon(
                  FontAwesomeIcons.expand,
                  size: 18.sp,
                  color: isSelected ? Colors.yellow : null,
                ),
              ),
          ],
        ),
      ),
    );
  }
}





//-------------------------------------------- _ AppBar Fav _ --------------------------------------------\\





class AppBarFav extends StatelessWidget {
  const AppBarFav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Image(
            width: 0.3.dp,
            height: 0.3.dp,
            image: const AssetImage(kIconSplash),
          ),
          const SizedBox(width: 5),
          Text(
            "Favourites",
            style: Get.textTheme.headlineMedium,
          ),
          Container(
            width: 1,
            height: 8.h,
            margin: const EdgeInsets.symmetric(horizontal: 13),
            color: kColorHint,
          ),
          Icon(
            FontAwesomeIcons.solidHeart,
            size: 20.sp,
            color: Colors.white,
          ),
          const Spacer(),
          IconButton(
            focusColor: const Color.fromARGB(255, 60, 0, 255),
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              FontAwesomeIcons.chevronRight,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}





//-------------------------------------------- _ AppBar  CatchUp _ --------------------------------------------\\




class AppBarCatchUp extends StatelessWidget {
  const AppBarCatchUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      color: Colors.transparent,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        children: [
          Image(
            width: 0.3.dp,
            height: 0.3.dp,
            image: const AssetImage(kIconSplash),
          ),
          const SizedBox(width: 5),
          Text(
            "Catch Up",
            style: Get.textTheme.headlineMedium,
          ),
          Container(
            width: 1,
            height: 8.h,
            margin: const EdgeInsets.symmetric(horizontal: 13),
            color: kColorHint,
          ),
          Icon(
            FontAwesomeIcons.rotate,
            size: 20.sp,
            color: Colors.white,
          ),
          const Spacer(),
          IconButton(
            focusColor: kColorFocus,
            onPressed: () {
              context.read<WatchingCubit>().clearData();
            },
            icon: const Icon(
              FontAwesomeIcons.broom,
              color: Colors.white,
            ),
          ),
          IconButton(
            focusColor: kColorFocus,
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              FontAwesomeIcons.chevronRight,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
