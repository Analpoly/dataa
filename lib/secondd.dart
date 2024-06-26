// second_page.dart
import 'package:dataa/modelclasses.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';

class SecondPage extends StatelessWidget {
  final String categoryId;

  SecondPage({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Subcategories")),
      body: FutureBuilder(
        future: fetchSubCategories(categoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            List<SubCategory>? subCategories = snapshot.data;
            return ListView.builder(
              itemCount: subCategories?.length,
              itemBuilder: (context, index) {
                SubCategory subCategory = subCategories![index];
                String imageUrl = "https://coinoneglobal.in/crm/${subCategory.imgUrlPath}";
                return Card(
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        imageUrl: imageUrl,
                        placeholder: (context, url) => CircularProgressIndicator(),
                        errorWidget: (context, url, error) => Icon(Icons.error),
                      ),
                      Text(subCategory.name),
                    ],
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<List<SubCategory>> fetchSubCategories(String categoryId) async {
    final response = await http.get(
      Uri.parse('https://coinoneglobal.in/teresa_trial/webtemplate.asmx/FnGetTemplateSubCategoryList?PrmCmpId=1&PrmBrId=2&PrmCategoryId=$categoryId'),
    );

    if (response.statusCode == 200) {
      List data = json.decode(response.body);
      return data.map((item) => SubCategory.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load subcategories');
    }
  }
}

