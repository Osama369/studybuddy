import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:studyapp/controllers/quiz_paper/data_uploader.dart';

import '../firebase_ref/loading_status.dart';

class DataUploadscreen extends StatelessWidget {
  DataUploadscreen({super.key});

  PapersDataUploader controller = Get.put(PapersDataUploader());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Obx(()=>Text(controller.loadingStatus.value==LoadingStatus.completed?"uploading completed":"uplaoding ...")),
      ),
    );
  }
}