import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:dio/dio.dart' as api;
import 'package:machine_test/Model/global_gallery_list_model.dart';
import 'package:machine_test/Utils/constant.dart';
import 'package:machine_test/Utils/enums.dart';

class HomeController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    callApi();
  }

  var galleryList = <ListElement>[].obs;
  var isLoading = false.obs;

  String getDocType(int type) {
    String doctypeValue = DocType.values
        .firstWhere(
          (element) => element.type == type,
          orElse: () => DocType.image,
        )
        .name;
    return doctypeValue;
  }

  Future<void> callApi() async {
    isLoading.value = true;
    update();
    // API endpoint
    String url = 'https://ajcjewel.com:4000/api/global-gallery/list';

    // Request headers
    Map<String, String> headers = {
      'Authorization': Constants.getApikey(),
      'Content-Type': 'application/json',
    };

    // Request body
    var data = jsonEncode({
      "statusArray": [1],
      "screenType": [],
      "responseFormat": [],
      "globalGalleryIds": [],
      "categoryIds": [],
      "docTypes": [],
      "types": [],
      "limit": 10,
      "skip": 0,
      "searchingText": ""
    });

    try {
      // Create Dio instance
      api.Dio dio = api.Dio();

      // Make POST request
      api.Response response = await dio.post(
        url,
        data: data,
        options: api.Options(headers: headers),
      );

      if (response.statusCode == 201) {
        // Request was fulfilled and a new resource was created
        log("${response.data}");
        // var feedback = jsonDecode(response.data);

        var responseData = GlobalGalleryListModel.fromJson(response.data);
        galleryList.value = responseData.data?.list ?? [];
        update();
        print('Response: ${response.data}');
      } else {
        // Request failed or returned an unexpected status code
        print('Request failed with status: ${response.statusCode}');
        print('Response: ${response.data}');
      }
    } catch (e) {
      // Handle error
      log('Error: $e');
    } finally {
      isLoading.value = false;
      update();
    }
  }
}
