import 'dart:convert';
import 'dart:io';

import 'package:provider/main.dart';
import 'package:provider/models/base_response.dart';
import 'package:provider/networks/network_utils.dart';
import 'package:provider/networks/rest_apis.dart';
import 'package:provider/provider/blog/model/blog_detail_response.dart';
import 'package:provider/utils/constant.dart';
import 'package:provider/utils/model_keys.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';

import 'model/blog_response_model.dart';

// region Blog List API
Future<List<BlogData>> getBlogListAPI({int? page, required List<BlogData> blogData, Function(bool)? lastPageCallback}) async {
  try {
    BlogResponse res = BlogResponse.fromJson(
      await handleResponse(await buildHttpResponse('blog-list?provider_id=${appStore.userId}&per_page=$PER_PAGE_ITEM&page=$page', method: HttpMethodType.GET)),
    );

    if (page == 1) blogData.clear();

    blogData.addAll(res.data.validate());

    lastPageCallback?.call(res.data.validate().length != PER_PAGE_ITEM);

    appStore.setLoading(false);

    return blogData;
  } catch (e) {
    appStore.setLoading(false);
    throw e;
  }
}
//endregion

// region Add Blog API
Future<void> addBlogMultiPart({required Map<String, dynamic> value, List<File>? imageFile}) async {
  MultipartRequest multiPartRequest = await getMultiPartRequest('blog-save');

  multiPartRequest.fields.addAll(await getMultipartFields(val: value));

  if (imageFile.validate().isNotEmpty) {
    multiPartRequest.files.addAll(await getMultipartImages(files: imageFile.validate(), name: AddBlogKey.blogAttachment));
    multiPartRequest.fields[AddBlogKey.attachmentCount] = imageFile.validate().length.toString();
  }

  log("${multiPartRequest.fields}");

  multiPartRequest.headers.addAll(buildHeaderTokens());

  log("Multi Part Request : ${jsonEncode(multiPartRequest.fields)} ${multiPartRequest.files.map((e) => e.field + ": " + e.filename.validate())}");

  appStore.setLoading(true);

  await sendMultiPartRequest(multiPartRequest, onSuccess: (temp) async {
    appStore.setLoading(false);

    log("Response: ${jsonDecode(temp)}");

    toast(jsonDecode(temp)['message'], print: true);
    finish(getContext, true);
  }, onError: (error) {
    toast(error.toString(), print: true);
    appStore.setLoading(false);
  }).catchError((e) {
    appStore.setLoading(false);
    toast(e.toString());
  });
}
//endregion

//region Delete Blog API
Future<BaseResponseModel> deleteBlogAPI(int? id) async {
  return BaseResponseModel.fromJson(await handleResponse(await buildHttpResponse('blog-delete/$id', method: HttpMethodType.POST)));
}
//endregion

// region Get Blog Detail API
Future<BlogDetailResponse> getBlogDetailAPI(Map request) async {
  return BlogDetailResponse.fromJson(await handleResponse(await buildHttpResponse('blog-detail', request: request, method: HttpMethodType.POST)));
}
//endregion
