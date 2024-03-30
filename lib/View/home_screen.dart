import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:machine_test/Controller/home_controller.dart';
import 'package:shimmer/shimmer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text("Global Gallery"),
        centerTitle: true,
      ),
      body: GetBuilder<HomeController>(builder: (controller) {
        return controller.isLoading.value
            ? Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: ListView.separated(
                  shrinkWrap: true,
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Location",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ));
                  },
                  separatorBuilder: (context, index) => SizedBox(
                    height: 5,
                  ),
                ))
            : SingleChildScrollView(
                child: DataTable(
                    dataRowHeight: 70,
                    columnSpacing: 5,
                    columns: const <DataColumn>[
                      DataColumn(
                        label: Text(
                          'Name',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'UID',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Doc Type',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Image',
                          style: TextStyle(fontStyle: FontStyle.italic),
                        ),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                      controller.galleryList.length,
                      (index) => DataRow(
                        cells: <DataCell>[
                          DataCell(SizedBox(
                              width: size.width * 0.35,
                              child: Text(
                                  controller.galleryList[index].name ?? ''))),
                          DataCell(
                            SizedBox(
                                width: size.width * 0.2,
                                child: Text(
                                    "${controller.galleryList[index].uid ?? 0}")),
                          ),
                          DataCell(SizedBox(
                            width: size.width * 0.15,
                            child: Text(controller.getDocType(
                                controller.galleryList[index].docType ?? 0)),
                          )),
                          DataCell(
                              Padding(
                                padding: const EdgeInsets.all(4.0),
                                child: SizedBox(
                                    width: size.width * 0.2,
                                    child: Image.network(
                                      controller.galleryList[index].url ?? '',
                                      fit: BoxFit.fitHeight,
                                    )),
                              ), onTap: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                      insetPadding: EdgeInsets.all(10),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20))),
                                      title: Row(
                                        children: [
                                          Expanded(
                                            child: Text(
                                              "${controller.galleryList[index].name ?? ''}",
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.grey),
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.topRight,
                                            child: InkWell(
                                                onTap: () {
                                                  Navigator.pop(context);
                                                },
                                                child: Card(
                                                    child: Icon(Icons.close))),
                                          ),
                                        ],
                                      ),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Expanded(
                                            child: Image.network(controller
                                                    .galleryList[index].url ??
                                                ''),
                                          )
                                        ],
                                      ));
                                });
                          }),
                          // Add more DataCell widgets for additional columns
                        ],
                      ),
                    )),
              );
      }),
    );
  }
}
