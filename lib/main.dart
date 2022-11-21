import 'package:flutter/material.dart';
import 'package:pixabay_image_search/api_provider/api_provider.dart';
import 'Model/search_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ValueNotifier<SearchModel?> array = ValueNotifier(null);

  TextEditingController controller = TextEditingController();
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Pixabay Image Search',
          style: TextStyle(color: Colors.deepPurple),
        ),
      ),
      body: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                  height: 50,
                  width: 250,
                  child: TextField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        filled: true,
                        hintStyle: TextStyle(color: Colors.grey[800]),
                        hintText: " Search",
                        fillColor: Colors.white70),
                  )),
              IconButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    print("testing");
                    array.value = await ApiProvider()
                        .search(controller.text.toString().split(' ').join('+'))
                        .then((value) {
                      setState(() {
                        isLoading = false;
                      });
                    });
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          if (array != null)
            isLoading
                ? ValueListenableBuilder(
                    valueListenable: array,
                    builder: (_, data, __) {
                      if (data == null) {
                        return const Text('Search for Images');
                      } else {
                        return Expanded(
                          child: GridView.builder(
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
                            itemCount: (data as SearchModel).hits!.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => DetailedScreen(
                                            imageUrl: data
                                                .hits![index].largeImageURL
                                                .toString()),
                                      ));
                                },
                                child: Image.network(
                                    data.hits![index].previewURL.toString()),
                              );
                            },
                          ),
                        );
                      }
                    })
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
        ],
      ),
    );
  }
}

class DetailedScreen extends StatelessWidget {
  final String imageUrl;
  const DetailedScreen({
    Key? key,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
    );
  }
}
