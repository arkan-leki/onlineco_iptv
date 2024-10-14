
part of 'screens.dart';

class OsnChannelsScreen extends StatefulWidget {
  @override
  _OsnChannelsScreenState createState() => _OsnChannelsScreenState();
}

class _OsnChannelsScreenState extends State<OsnChannelsScreen> {
  List<dynamic> osnChannels = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchOsnChannels();
  }

  Future<void> fetchOsnChannels() async {
    const String url = "http://onlinekurdistantv.com:8080/player_api.php";
    const String username = "onlinetv";
    const String password = "onlinetv";
    const String categoryId = "1"; // Assuming category_id for KD is 1

    final Uri uri = Uri.parse("$url?username=$username&password=$password&action=get_live_streams&category_id=$categoryId");

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        print(data); // Debug response structure
        // Assuming you need to access a specific field from the data
        setState(() {
          osnChannels = data['channels'] ?? []; // Adjust based on actual API response
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load channels');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("KD Channels")),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: osnChannels.length,
              itemBuilder: (context, index) {
                final channel = osnChannels[index];
                return ListTile(
                  title: Text(channel['name'] ?? 'Unknown Channel'),
                  subtitle: Text('ID: ${channel['stream_id']}'),
                );
              },
            ),
    );
  }
}
