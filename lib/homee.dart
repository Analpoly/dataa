import 'package:dataa/loginn.dart';
import 'package:dataa/modelclasses.dart';
import 'package:dataa/secondd.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'auth_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home Page"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginPage()),
              result: Provider.of<AuthProvider>(context, listen: false).signOut());
            },
          
          ),
        ],
      ),
      body: FutureBuilder(
        future: fetchCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            List<Category>? categories = snapshot.data;
            return ListView.builder(
              itemCount: categories?.length,
              itemBuilder: (context, index) {
                Category category = categories![index];
                String imageUrl = "https://coinoneglobal.in/crm/${category.imgUrlPath}";
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SecondPage(categoryId: category.id),
                      ),
                    );
                  },
                  child: Card(
                    child: Column(
                      children: [
                        CachedNetworkImage(
                          imageUrl: imageUrl,
                          placeholder: (context, url) => CircularProgressIndicator(),
                          errorWidget: (context, url, error) => Icon(Icons.error),
                        ),
                        Text(category.name),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<Category>> fetchCategories() async {
    final response = await http.get(
      Uri.parse('https://coinoneglobal.in/teresa_trial/webtemplate.asmx/FnGetTemplateCategoryList?PrmCmpId=1&PrmBrId=2'),
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => Category.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}

