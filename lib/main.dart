import 'package:cached_network_image/cached_network_image.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Testing',
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
                    array.value = await ApiProvider().search(
                        controller.text.toString().split(' ').join('+'));
                  },
                  icon: Icon(Icons.search))
            ],
          ),
          SizedBox(
            height: 10,
          ),
          if (array != null)
            ValueListenableBuilder(
                valueListenable: array,
                builder: (_, data, __) {
                  if (data == null) {
                    return Text('pls search');
                  } else {
                    return Expanded(
                      child: GridView.builder(
                        physics: BouncingScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2),
                        itemCount: data.hits!.length,
                        itemBuilder: (context, index) {
                          return Image.network(
                              data.hits![index].previewURL.toString());
                        },
                      ),
                    );
                  }
                }),
        ],
      ),
    );
  }
}
