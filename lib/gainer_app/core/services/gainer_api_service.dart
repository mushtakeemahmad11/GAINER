import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:xml/xml.dart';
import '../../modules/internet_connectivity/no_internet_controller.dart';
import '../../routes/app_routes.dart';
import '../Services/auth_service.dart';

class GainerApiService {
  final String baseUrl = "https://scope.sparecare.in/AppServicesV2.asmx";
  final String scopeApiBaseurl = "https://scopeapi.sparecare.in/api/v1";
  // final String scopeApiBaseurl =
  //     "http://web10.185.238.new.ocpwebserver.com/api/v1";
  // final String baseUrl =
  //     "http://web13.185.238.new.ocpwebserver.com/AppServicesV2.asmx";

  ///checking internet before hit API
  final networkC = Get.find<NoInternetController>();

  Future<T> guardRequest<T>(Future<T> Function() apiCall) async {
    if (!networkC.isConnected.value) {
      Get.toNamed(Routes.NOINTERNETVIEW);
      throw Exception('No Internet Connection');
    }
    return await apiCall();
  }

  Future<http.Response> apiRequest(
    String url,
    Map<String, dynamic> payload, {
    int timeoutSeconds = 20, // default
  }) async {
    return guardRequest<http.Response>(() {
      print("URL::: $url");
      print("Payload::: $payload");
      return http
          .post(
            Uri.parse(url),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode(payload),
          )
          .timeout(Duration(seconds: timeoutSeconds));
    });
  }

  Future<Map<String, dynamic>> loginUser(
    String userId,
    String password,
    String deviceToken,
  ) async {
    String url = '$baseUrl/SPMLoginV2';
    final payload = {
      "UserID": userId,
      "Pwd": password,
      "DeviceToken": deviceToken,
    };

    try {
      final response = await apiRequest(url, payload);
      final jsonData = jsonDecode(response.body);

      // get data as json string from json data
      final data = jsonData['d'];

      // Parse the JSON string into a Dart object
      List<dynamic> jsonList = jsonDecode(data);

      // Extract the first object in the list
      Map<String, dynamic> firstObject = jsonList[0];

      if (response.statusCode == 200) {
        if (firstObject["Status"] == "Success") {
          return {'success': true, 'data': firstObject};
        } else {
          return {
            'success': false,
            'message': firstObject["Msg"] ?? 'Invalid UserID or Password'
          };
        }
      } else {
        return {
          'success': false,
          'message': firstObject["Msg"] ?? 'Invalid UserID or Password'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> searchPart(String partNumber) async {
    String brandId = await AuthService.getBrandId();
    String locationId = await AuthService.getLocationId();
    String tCode = await AuthService.getTCode();
    String url = '$baseUrl/GetPartNumber';
    final payload = {
      "PartNumber": partNumber,
      "BrandID": brandId,
      "LocationId": locationId,
      "UserId": tCode,
    };
    try {
      final response = await apiRequest(url, payload, timeoutSeconds: 2);

      final jsonData = jsonDecode(response.body);
      // get data as json string from json data
      final data = jsonData['d'];
      if (response.statusCode == 200) {
        if (data.isNotEmpty) {
          // Split the string into a list
          List<String> partNumbers = data.split(",");
          return {'success': true, 'data': partNumbers};
        } else {
          return {'success': false, 'data': []};
        }
      } else {
        return {
          'success': false,
          'message': 'Some thing went wrong,Please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out.'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }

  Future<Map<String, dynamic>> trackOrder(
      String orderNumber, String locationId, String tCode) async {
    String url = '$baseUrl/TrackOrder';
    final payload = {
      "DispatchOrderNo": orderNumber,
      "LocationId": locationId,
      "UserId": tCode,
    };

    try {
      final response = await apiRequest(url, payload);
      // convert response into json data
      final jsonData = jsonDecode(response.body);

      // get data as json string from json data
      final data = jsonData['d'];

      if (response.statusCode == 200) {
        if (data.isNotEmpty) {
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': 'Invalid dispatch order number'};
        }
      } else {
        return {'success': false, 'message': 'Unable to check'};
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> getPartDetails(String brandID, String partNumber,
      String locationId, String tCode) async {
    String url = '$baseUrl/GetPartdetails';
    final payload = {
      "brandid": brandID,
      "partnumber": partNumber,
      "LocationId": locationId,
      "UserId": tCode,
    };
    try {
      final response = await apiRequest(url, payload);

      Map<String, dynamic> jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (jsonData["d"] != "[]" && jsonData.isNotEmpty) {
          // final data = jsonData['d'];
          final List<dynamic> decodedList = jsonDecode(jsonData['d']);
          return {'success': true, 'data': decodedList};
        } else {
          return {'success': false, 'message': 'Part not found'};
        }
      } else {
        return {
          'success': false,
          'message': 'Some thing went wrong,Please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> getLSP(String locationID) async {
    String url = '$baseUrl/GetLSP';
    final payload = {"LocationID": locationID};
    try {
      final response = await apiRequest(url, payload);

      // convert response into json data
      final jsonData = jsonDecode(response.body);

      // get data as json string from json data
      final data = jsonData['d'];
      if (response.statusCode == 200) {
        if (data.isNotEmpty) {
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': 'Invalid location ID'};
        }
      } else {
        return {
          'success': false,
          'message': 'Some thing went wrong,Please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> getLocation(String tCode) async {
    String url = '$baseUrl/GetLocation';
    final payload = {"tCode": tCode};

    try {
      final response = await apiRequest(url, payload, timeoutSeconds: 60);

      // convert response into json data
      final jsonData = jsonDecode(response.body);

      // get data as json string from json data
      final data = jsonData['d'];
      if (response.statusCode == 200) {
        if (data.isNotEmpty) {
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': ' invalid tCode'};
        }
      } else {
        return {
          'success': false,
          'message': 'Some thing went wrong,Please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> getCluster(
      String locationID, String tCode) async {
    String url = '$baseUrl/GetCluster';
    final payload = {
      "LocationID": locationID,
      "UserId": tCode,
    };
    try {
      final response = await apiRequest(url, payload);

      // convert response into json data
      final jsonData = jsonDecode(response.body);

      // get data as json string from json data
      final data = jsonData['d'];
      if (response.statusCode == 200) {
        if (data.isNotEmpty) {
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': 'Invalid location ID'};
        }
      } else {
        return {
          'success': false,
          'message': 'Some thing went wrong,Please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> getBuyerValues(
      String locationID, String tCode) async {
    String url = '$baseUrl/GetBuyerValues';
    final payload = {
      "LocationID": locationID,
      "UserId": tCode,
    };
    try {
      // final stopwatch = Stopwatch()..start();
      final response = await apiRequest(url, payload, timeoutSeconds: 60);
      final jsonData = jsonDecode(response.body);

      // get data as json string from json data
      final data = jsonData['d'];
      if (response.statusCode == 200) {
        if (data.isNotEmpty) {
          if (jsonDecode(data)[0]['Status'] == "Error") {
            return {'success': false, 'message': 'No data found'};
          }
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': 'Invalid location ID'};
        }
      } else {
        return {
          'success': false,
          'message': 'Some thing went wrong,Please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> showPartAvailability(
    String brandID,
    String dealerID,
    String locationID,
    String orderFor,
    String lspCode,
    String tat,
    String clusterCode,
    String partNumbers,
    String stockCategory,
    String withInGroup,
    String tCode,
  ) async {
    String url = "$baseUrl/GetSellerLocationForOrder";
    final payload = {
      "BrandID": brandID,
      "DealerID": dealerID,
      "LocationID": locationID,
      "OrderFor": orderFor,
      "LspCode": lspCode,
      "Tat": tat,
      "ClusterCode": clusterCode,
      "PartNumbers": partNumbers,
      "StockCategory": stockCategory,
      "DiscCondition": '',
      "Discount": '',
      "UserId": tCode,
    };

    try {
      final response = await apiRequest(url, payload, timeoutSeconds: 300);

      // convert response into json data
      final jsonData = jsonDecode(response.body);

      // get data as json string from json data
      final data = jsonData['d'];

      if (response.statusCode == 200) {
        if (data.isNotEmpty) {
          if (jsonDecode(data)[0]['Status'] == "Error") {
            return {'success': false, 'message': jsonDecode(data)[0]['Msg']};
          }
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': 'Data not found'};
        }
      } else {
        return {
          'success': false,
          'message': 'Some thing went wrong,Please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  //Request Order submit
  Future<Map<String, dynamic>> orderReqSubmit(
      String brandID,
      String dealerID,
      String locationID,
      String userID,
      String orderFor,
      String lspCode,
      String tableVal) async {
    String url = '$baseUrl/OrderReqSubmit';
    final payload = {
      "BuyerBrandID": brandID,
      "BuyerDealerID": dealerID,
      "BuyerLocationID": locationID,
      "UserID": userID,
      "OrderFor": orderFor,
      "LspCode": lspCode,
      "TableVal": tableVal
    };
    //"PARTNUMBER", "ClusterCode", "SELLERDEALERID", "SELLERLOCATION", "SELLERSTOCKQTY", "SELLERFREESTOCK", "DISCOUNT", "TAT", "SELLERVERIFIED", "SCSVERIFIED", "ORDERQTY", "REMARKS", "PRICE", "MRP", "RATE", "StockCat"
    try {
      final response = await apiRequest(url, payload);

      // convert response into json data
      final jsonData = jsonDecode(response.body);
      // get data as json string from json data
      final data = jsonData['d'];

      if (response.statusCode == 200 &&
          data.isNotEmpty &&
          jsonDecode(data)[0]['Status'] == "Success") {
        return {'success': true, 'data': jsonDecode(data)[0]['Msg']};
      } else {
        if (jsonDecode(data)[0]['Status'] == "Error") {
          return {'success': false, 'message': jsonDecode(data)[0]['Msg']};
        }
        return {
          'success': false,
          'message': 'Something went wrong, please try again'
        };
      }
    } catch (e) {
      // return {'success': true, 'data': 'Part request success'};
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  // Get Buyer stage according to location id and stage name(orderPlaced,POUpdation....)
  Future<Map<String, dynamic>> getBuyerStages(
      String locationID, String stage, String tCode) async {
    String url = '$baseUrl/GetBuyerStages';
    final payload = {
      "LocationID": locationID,
      "Stage": stage,
      "UserId": tCode,
    };

    try {
      final response = await apiRequest(url, payload, timeoutSeconds: 120);
      // convert response into json data
      final jsonData = jsonDecode(response.body);
      // get data as json string from json data
      final data = jsonData['d'];
      if (response.statusCode == 200) {
        if (data.isNotEmpty) {
          if (jsonDecode(data)[0]['Status'] == "Error") {
            // return {'success': false, 'message': jsonDecode(data)[0]['Msg']};
            return {'success': false, 'message': 'order not available'};
          }
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': 'Data not found'};
        }
      } else {
        return {
          'success': false,
          'message': 'Some thing went wrong, Please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  // delete order according to bigID in OrderPlaced screen as buyer
  Future<Map<String, dynamic>> orderPlacedDelete(
      String bigID, String locationId, String tCode) async {
    String url = '$baseUrl/OrderPlace_Delete';
    final payload = {
      "BigID": bigID,
      "LocationId": locationId,
      "UserId": tCode,
    };

    try {
      final response = await apiRequest(url, payload);

      // convert response into json data
      final jsonData = jsonDecode(response.body);

      // get data as json string from json data
      final data = jsonData['d'];
      if (response.statusCode == 200 &&
          data.isNotEmpty &&
          jsonDecode(data)[0]['Status'] == "Success") {
        return {'success': true, 'data': jsonDecode(data)[0]['Msg']};
      } else {
        return {
          'success': false,
          'message': 'Some thing went wrong,Please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  // Get Seller stage according to location id and stage name(OrderReceived,Manifestation....)
  Future<Map<String, dynamic>> getSellerStages(
      String locationID, String stage, String tCode) async {
    String url = '$baseUrl/GetSellerStages';
    final payload = {
      "LocationID": locationID,
      "Stage": stage,
      "UserId": tCode,
    };

    try {
      final response = await apiRequest(url, payload, timeoutSeconds: 120);

      // convert response into json data
      final jsonData = jsonDecode(response.body);
      // get data as json string from json data
      final data = jsonData['d'];
      if (response.statusCode == 200) {
        if (data.isNotEmpty) {
          if (jsonDecode(data)[0]['Status'] == "Error") {
            // return {'success': false, 'message': jsonDecode(data)[0]['Msg']};
            return {'success': false, 'message': 'No Data'};
          }
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': 'Data not found'};
        }
      } else {
        return {
          'success': false,
          'message': 'Some thing went wrong, Please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  // Get Dispatch details as seller stage
  Future<Map<String, dynamic>> dispatchDetailsStage(String brandID,
      String dealerID, String sellerLocationID, String tCode) async {
    String url = '$baseUrl/GetDispatchDetails';
    final payload = {
      "BrandID": brandID,
      "DealerID": dealerID,
      "SellerLocationID": sellerLocationID,
      "UserId": tCode
    };

    try {
      final response = await apiRequest(url, payload);

      // convert response into json data
      final jsonData = jsonDecode(response.body);
      // get data as json string from json data
      final data = jsonData['d'];
      if (response.statusCode == 200) {
        if (data.isNotEmpty) {
          if (jsonDecode(data)[0]['Status'] == "Error") {
            return {'success': false, 'message': jsonDecode(data)[0]['Msg']};
          }
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': 'Data not found'};
        }
      } else {
        return {
          'success': false,
          'message': 'Some thing went wrong, Please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  // Reject order onClick ThumbDown icon in OrderReceived screen as Seller
  Future<Map<String, dynamic>> orderDueReject({
    required String bigID,
    required String remarks,
    required String rejectReason,
    required String freeStock,
    required String partNumber,
    required String stockCatType,
    required String sellerLocationID,
    required String loginUserID,
  }) async {
    String url = '$baseUrl/OrderDueReject';
    final payload = {
      "BigID": bigID,
      "Remarks": remarks,
      "RejectReason": rejectReason,
      "FreeStock": freeStock,
      "PartNumber": partNumber,
      "StockCatType": stockCatType,
      "SellerLocationID": sellerLocationID,
      "LoginUserID": loginUserID,
    };

    try {
      final response = await apiRequest(url, payload);

      // Convert response into JSON
      final jsonData = jsonDecode(response.body);
      final data = jsonData['d'];

      if (response.statusCode == 200 &&
          data.isNotEmpty &&
          jsonDecode(data)[0]['Status'] == "Success") {
        return {'success': true, 'data': jsonDecode(data)[0]['Msg']};
      } else {
        return {
          'success': false,
          'message': 'Something went wrong, please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  // Accept order onClick ThumbUp icon in OrderReceived screen as Seller
  Future<Map<String, dynamic>> orderDueAccept({
    required String bigID,
    required String remarks,
    required String confirmQty,
    required String freeStock,
    required String transporterType,
    required String img1,
    required String img2,
    required String img3,
    required String loginUserID,
  }) async {
    String url = '$baseUrl/OrderDueAccept';
    final payload = {
      "BigID": bigID,
      "Remarks": remarks,
      "ConfirmQty": confirmQty,
      "FreeStock": freeStock,
      "TransporterType": transporterType,
      "Img1": img1,
      "Img2": img2,
      "Img3": img3,
      "LoginUserID": loginUserID
    };

    try {
      final response = await apiRequest(url, payload);

      // Convert response into JSON
      final jsonData = jsonDecode(response.body);
      final data = jsonData['d'];

      if (response.statusCode == 200 &&
          data.isNotEmpty &&
          jsonDecode(data)[0]['Status'] == "Success") {
        return {'success': true, 'data': jsonDecode(data)[0]['Msg']};
      } else {
        return {
          'success': false,
          'message': 'Something went wrong, please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  //POReject on click PoUpdation>ThumbDown>submit
  Future<Map<String, dynamic>> poReject({
    required String freeStock,
    required String rejectReason,
    required String remarks,
    required String bigID,
    required String locationId,
    required String tCode,
  }) async {
    String url = '$baseUrl/POReject';
    final payload = {
      "FreeStock": freeStock,
      "RejectReason": rejectReason,
      "Remarks": remarks,
      "BigID": bigID,
      "LocationId": locationId,
      "UserId": tCode,
    };
    try {
      final response = await apiRequest(url, payload);

      // Convert response into JSON
      final jsonData = jsonDecode(response.body);
      final data = jsonData['d'];
      if (response.statusCode == 200 &&
          data.isNotEmpty &&
          jsonDecode(data)[0]['Status'] == "Success") {
        return {'success': true, 'data': jsonDecode(data)[0]['Msg']};
      } else {
        return {
          'success': false,
          'message': 'Something went wrong, please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  //POUpdation screen for FurtherDetails on click Home=PoUpdation>Remarks>submit
  Future<Map<String, dynamic>> poFurtherDetails({
    required String remarks,
    required String bigID,
    required String locationId,
    required String tCode,
  }) async {
    String url = '$baseUrl/POFurtherDetail';
    final payload = {
      "Remarks": remarks,
      "BigID": bigID,
      "LocationId": locationId,
      "UserId": tCode,
    };

    try {
      final response = await apiRequest(url, payload);

      // Convert response into JSON
      final jsonData = jsonDecode(response.body);
      final data = jsonData['d'];

      if (response.statusCode == 200 &&
          data.isNotEmpty &&
          jsonDecode(data)[0]['Status'] == "Success") {
        return {'success': true, 'data': jsonDecode(data)[0]['Msg']};
      } else {
        return {
          'success': false,
          'message': 'Something went wrong, please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  //POUpdation screen for Raise PO on click Home=PoUpdation>ThumbUp>submit
  Future<Map<String, dynamic>> poRaise({
    required String poNumber,
    required String userID,
    required String brandID,
    required String dealerID,
    required String locationID,
    required String tableValue,
  }) async {
    String url = '$baseUrl/PORaise';
    final payload = {
      "PoNumber": poNumber,
      "UserID": userID,
      "BrandID": brandID,
      "DealerID": dealerID,
      "LocationID": locationID,
      "TableVal": tableValue,
    };

    // print("Request body of PORaise: $requestBody");
    try {
      final response = await apiRequest(url, payload);

      // Convert response into JSON
      final jsonData = jsonDecode(response.body);
      final data = jsonData['d'];
      if (response.statusCode == 200 &&
          data.isNotEmpty &&
          jsonDecode(data)[0]['Status'] == "Success") {
        return {'success': true, 'data': jsonDecode(data)[0]['Msg']};
      } else {
        return {
          'success': false,
          'message': 'Something went wrong, please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  //OrderReceived(Seller Confirmation) screen with image or without on click Home=Order Received>ThumbUp>submit
  Future<Map<String, dynamic>> orderDueAcceptV2({
    required String bigID,
    required String remarks,
    required String confirmQty,
    required String freeStock,
    required String transporterType,
    required String loginUserID,
    required List<File> imageFiles, // List of image files
    required String locationId,
  }) async {
    String apiUrl = "$baseUrl/OrderDueAcceptV2";

    try {
      return await guardRequest<Map<String, dynamic>>(() async {
        var uri = Uri.parse(apiUrl);
        var request = http.MultipartRequest('POST', uri);

        // Add string fields
        request.fields['BigID'] = bigID;
        request.fields['Remarks'] = remarks;
        request.fields['ConfirmQty'] = confirmQty;
        request.fields['FreeStock'] = freeStock;
        request.fields['TransporterType'] = transporterType;
        request.fields['LoginUserID'] = loginUserID;
        request.fields['LocationId'] = locationId;

        for (var file in imageFiles) {
          var stream = http.ByteStream(file.openRead().cast());
          var length = await file.length();

          var multipartFile = http.MultipartFile(
            'file',
            stream,
            length,
            filename: basename(file.path),
            contentType:
                MediaType('image', 'jpeg'), // Change to 'png' if needed
          );

          request.files.add(multipartFile);
        }

        // print("Request Fields: ${request.fields}");
        // Send request
        var response = await request.send();

        // Read response
        var responseBody = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          // Parse XML
          final document = XmlDocument.parse(responseBody);
          final jsonString =
              document.rootElement.innerText; // Extracts JSON string

          // Convert JSON String to List of Maps
          List<dynamic> jsonData = jsonDecode(jsonString);

          // Access Data
          String status = jsonData[0]["Status"].toString(); // "Success"
          String message = jsonData[0]["Msg"].toString(); // "Request Confirm."
          if (status.isNotEmpty && status == "Success") {
            return {'success': true, 'data': message};
          } else {
            return {'success': false, 'message': message};
          }
        } else {
          return {
            'success': false,
            'message':
                'Network is unreachable\nPlease check your Internet connection or try again'
          };
        }
      });
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  //PartReceipt(as Buyer) screen with image or without on click Good and Issue>submit
  Future<Map<String, dynamic>> pendingToBeReceivedV2({
    required String remarks,
    required String actionType,
    required String bigID,
    required List<File> imageFiles, // List of image files
    required String locationId,
    required String tCode,
  }) async {
    String apiUrl = "$baseUrl/PendingToBeReceivedV2";

    /// for with image
    try {
      return await guardRequest<Map<String, dynamic>>(() async {
        var uri = Uri.parse(apiUrl);
        var request = http.MultipartRequest('POST', uri);
        // Add string fields
        request.fields['Remarks'] = remarks;
        request.fields['ActionType'] = actionType;
        request.fields['BigID'] = bigID;
        request.fields['LocationId'] = locationId;
        request.fields['UserId'] = tCode;

        //for image parse
        for (var file in imageFiles) {
          // Get the MIME type dynamically
          String? mimeType =
              lookupMimeType(file.path); // e.g., "image/jpeg" or "image/png"
          MediaType mediaType =
              MediaType.parse(mimeType ?? 'application/octet-stream');

          var stream = http.ByteStream(file.openRead().cast());
          var length = await file.length();

          var multipartFile = http.MultipartFile(
            'file',
            stream,
            length,
            filename: basename(file.path),
            contentType:
                mediaType, // Automatically set the correct content type
          );

          request.files.add(multipartFile);
        }

        // Send request
        var response = await request.send();
        // Read response
        var responseBody = await response.stream.bytesToString();
        if (response.statusCode == 200) {
          // Parse XML
          final document = XmlDocument.parse(responseBody);
          final jsonString =
              document.rootElement.innerText; // Extracts JSON string

          // Convert JSON String to List of Maps
          List<dynamic> jsonData = jsonDecode(jsonString);

          // Access Data
          String status = jsonData[0]["Status"].toString(); // "Success"
          String message = jsonData[0]["Msg"].toString(); // "Request Confirm."
          if (status.isNotEmpty && status == "Success") {
            return {'success': true, 'data': message};
          } else {
            return {'success': false, 'message': message};
          }
        } else {
          return {
            'success': false,
            'message':
                'Network is unreachable\nPlease check your Internet connection or try again'
          };
        }
      });
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  // pendingForDispatch_Reminder according to and AlertLocation(BuyerLocation) bigID in OrderPlaced screen as buyer
  Future<Map<String, dynamic>> pendingForDispatchReminder(
      String alertLocation, String bigID) async {
    String url = '$baseUrl/PendingForDispatch_Reminder';
    final payload = {"AlertLocation": alertLocation, "BigID": bigID};

    try {
      final response = await apiRequest(url, payload);

      // convert response into json data
      final jsonData = jsonDecode(response.body);

      // get data as json string from json data
      final data = jsonData['d'];

      if (response.statusCode == 200 &&
          data.isNotEmpty &&
          jsonDecode(data)[0]['Status'] == "Success") {
        return {'success': true, 'data': jsonDecode(data)[0]['Msg']};
      } else {
        return {
          'success': false,
          'message': 'Some thing went wrong,Please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  //Dispatch Details screen on click Home=Dispatch Details>ThumbUp>submit
  Future<Map<String, dynamic>> dispatchDetailsImgUploadV2({
    required String dispatchOrderNo, //000148072
    required String lRNumber, //12345
    required String tCode, //1
    required String fileName, //fileName
    required File imageFiles,
    required String locationId,
    // required Map<String, File?> imageFiles
    // required List<String> fileName, // List of image files
  }) async {
    String apiUrl = "$baseUrl/DispatchDetailsImgUploadV2";

    try {
      return await guardRequest<Map<String, dynamic>>(() async {
        var uri = Uri.parse(apiUrl);
        var request = http.MultipartRequest('POST', uri);

        // Add string fields
        request.fields['DispatchOrderNo'] = dispatchOrderNo;
        request.fields['LRNumber'] = lRNumber;
        request.fields['tCode'] = tCode;
        request.fields['ImgSource'] = fileName;
        request.fields['LocationId'] = locationId;

        var stream = http.ByteStream(imageFiles.openRead().cast());
        var length = await imageFiles.length();

        var multipartFile = http.MultipartFile(
          'file',
          stream,
          length,
          filename: basename(imageFiles.path),
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);

        // Send request
        var response = await request.send();

        // Read response
        var responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          // Parse XML
          final document = XmlDocument.parse(responseBody);
          final jsonString =
              document.rootElement.innerText; // Extracts JSON string

          // Convert JSON String to List of Maps
          List<dynamic> jsonData = jsonDecode(jsonString);

          // Access Data
          String status = jsonData[0]["Status"].toString(); // "Success"
          String message = jsonData[0]["Msg"].toString(); // "Request Confirm."
          if (status.isNotEmpty && status == "Success") {
            return {'success': true, 'data': message};
          } else {
            return {'success': false, 'message': message};
          }
        } else {
          return {
            'success': false,
            'message':
                'Network is unreachable\nPlease check your Internet connection or try again'
          };
        }
      });
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  // DispatchDetailsSubmit in OrderPlaced screen as seller
  Future<Map<String, dynamic>> dispatchDetailsSubmit(String dispatchOrderNo,
      String lrNumber, String locationId, String tCode) async {
    String url = '$baseUrl/DispatchDetailsSubmit';
    final payload = {
      "DispatchOrderNo": dispatchOrderNo,
      "LRNumber": lrNumber,
      "LocationId": locationId,
      "UserId": tCode,
    };
    try {
      final response = await apiRequest(url, payload);
      // convert response into json data
      final jsonData = jsonDecode(response.body);

      // get data as json string from json data
      final data = jsonData['d'];

      if (response.statusCode == 200 &&
          data.isNotEmpty &&
          jsonDecode(data)[0]['Status'] == "Success") {
        return {'success': true, 'data': jsonDecode(data)[0]['Msg']};
      } else {
        return {
          'success': false,
          'message': 'Some thing went wrong,Please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  //Calculate Freight Cost on click Home=Manifestation>Summary>Manifestation>Calculate Freight
  Future<Map<String, dynamic>> calculateFreightCost({
    required String buyerLocationID,
    required String brandID,
    required String sellerDealerID,
    required String sellerLocationID,
    required String invoiceAmount,
    required String distance,
    required String itemsArr,
    required String noOfBoxes,
    required String isWeFastUse,
    required String userId,
  }) async {
    String url = '$baseUrl/CalculateFreightCost';
    final payload = {
      "BuyerLocationID": buyerLocationID,
      "BrandID": brandID,
      "SellerDealerID": sellerDealerID,
      "SellerLocationID": sellerLocationID,
      "InvoiceAmount": invoiceAmount,
      "Distance": distance,
      "ItemsArr": itemsArr,
      "NoofBoxes": noOfBoxes,
      "isWeFastUse": isWeFastUse,
      "UserId": userId,
    };

    try {
      final response = await apiRequest(url, payload);

      // Convert response into JSON
      final jsonData = jsonDecode(response.body);
      final data = jsonData['d'];
      if (response.statusCode == 200 && data.isNotEmpty) {
        return {'success': true, 'data': jsonDecode(data)};
      } else {
        return {
          'success': false,
          'message': 'Something went wrong, please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  //Calculate Freight Cost on click Home=Manifestation>Summary>Manifestation>Attach file icon
  Future<Map<String, dynamic>> manifestationInvoicePdfUpload({
    required File pdfFile,
    required String bigID,
    required String seqNo,
    required String locationId,
    required String tCode,
  }) async {
    final apiUrl = "$baseUrl/ManifestationInvoicePdfUpload";

    try {
      return await guardRequest<Map<String, dynamic>>(() async {
        final uri = Uri.parse(apiUrl);
        final request = http.MultipartRequest('POST', uri);

        // Fields
        request.fields['BigID'] = bigID;
        request.fields['SeqNo'] = seqNo;
        request.fields['LocationId'] = locationId;
        request.fields['Userid'] = tCode;

        // File
        final multipartFile = await http.MultipartFile.fromPath(
          'file',
          pdfFile.path,
          contentType: MediaType('application', 'pdf'),
        );

        request.files.add(multipartFile);

        // Send
        final streamedResponse =
            await request.send().timeout(const Duration(seconds: 30));

        final responseBody = await streamedResponse.stream.bytesToString();

        if (streamedResponse.statusCode != 200) {
          return {
            'success': false,
            'message': 'Server Error: ${streamedResponse.statusCode}',
          };
        }

        final document = XmlDocument.parse(responseBody);
        final jsonString = document.rootElement.innerText;

        final List<dynamic> jsonData = jsonDecode(jsonString);
        final status = jsonData[0]["Status"].toString();
        final message = jsonData[0]["Msg"].toString();

        if (status == "Success") {
          return {'success': true, 'data': jsonData};
        }

        return {'success': false, 'message': message};
      });
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error or unexpected issue occurred.',
      };
    }
  }

// Manifestation on click Home=Manifestation>Summary>Manifestation>Calculate Freight>Submit
  Future<Map<String, dynamic>> manifestation({
    required String bigIDs,
    required String companyCode,
    required String remarks,
    required String noofInvoioce,
    required String itemInvoice,
    required String noofBoxes,
    required String itemBox,
    required String estFreightCost,
    required String chargeableWeight,
    required String volumetricWt,
    required String odaChargePickup,
    required String odaChargeDelivery,
    required String handlingCharges,
    required String tat,
    required String buyerZone,
    required String sellerZone,
    required String lrNumber,
    required String transporterName,
    required String contactPerson,
    required String phone,
    required String emailID,
    required String itemCN,
    required String noofCN,
    required String loginUserID,
    required String locationId,
  }) async {
    String url = '$baseUrl/Manifestation';
    final payload = {
      "BigIDs": bigIDs,
      "CompanyCode": companyCode,
      "Remarks": remarks,
      "NoofInvoioce": noofInvoioce,
      "ItemInvoice": itemInvoice,
      "NoofBoxes": noofBoxes,
      "ItemBox": itemBox,
      "EstFreightCost": estFreightCost,
      "ChargeableWeight": chargeableWeight,
      "VolumetricWt": volumetricWt,
      "ODAChargePickup": odaChargePickup,
      "ODAChargeDelivery": odaChargeDelivery,
      "HandlingCharges": handlingCharges,
      "TAT": tat,
      "BuyerZone": buyerZone,
      "SellerZone": sellerZone,
      "LRNumber": lrNumber,
      "TransporterName": transporterName,
      "ContactPerson": contactPerson,
      "Phone": phone,
      "EmailID": emailID,
      "ItemCN": itemCN,
      "NoofCN": noofCN,
      "LoginUserID": loginUserID,
      "LocationId": locationId,
    };

    try {
      final response = await apiRequest(url, payload);
      // Convert response into JSON
      final jsonData = jsonDecode(response.body);
      final data = jsonData['d'];

      if (response.statusCode == 200 && data.isNotEmpty) {
        if (jsonDecode(data)[0]['Status'] == "Error") {
          return {'success': false, 'message': jsonDecode(data)[0]['Msg']};
        }
        return {'success': true, 'data': jsonDecode(data)};
      } else {
        return {
          'success': false,
          'message': 'Something went wrong, please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  ///Issue for help section
  Future<Map<String, dynamic>> getIssue() async {
    String apiUrl = "$scopeApiBaseurl/gnr/issue";

    try {
      return await guardRequest<Map<String, dynamic>>(() async {
        final url = Uri.parse(apiUrl);
        final res = await http.get(url);
        if (res.statusCode == 200) {
          var body = json.decode(res.body);
          var data = body['Data'];
          return {'success': true, 'data': data};
        } else {
          return {
            'success': false,
            'message': 'There are some problem to fetch issue option'
          };
        }
      });
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  ///SubIssue for help section
  Future<Map<String, dynamic>> getSubIssue(int issueId) async {
    String apiUrl = "$scopeApiBaseurl/gnr/subissue";

    try {
      final response = await apiRequest(apiUrl, {"issueid": issueId});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Example: access 'Data' field
        if (data['Data'] != null) {
          List<dynamic> subIssueList = data['Data'];
          return {'success': true, 'data': subIssueList};
        }
        return {'success': false, 'message': 'sub issue not found'};
      } else {
        return {
          'success': false,
          'message': 'There are some problem to fetch subIssue item'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  /// In help screen for raise ticket
  Future<Map<String, dynamic>> raiseTicketHelp({
    required issue,
    required desc,
    required userid,
    required locationId,
    required issueId,
    required subIssueId,
    // File? file, // Optional PDF or image
    required List<PlatformFile?> files, // Multiple Optional PDF or image
  }) async {
    final String url = '$scopeApiBaseurl/gnr/help';
    final uri = Uri.parse(url);

    try {
      return await guardRequest<Map<String, dynamic>>(() async {
        final request = http.MultipartRequest('POST', uri);
        // Add fields
        request.fields['issue'] = issue;
        request.fields['desc'] = desc;
        request.fields['userid'] = userid;
        request.fields['locationid'] = locationId;
        request.fields['issueid'] = issueId;
        request.fields['subissueid'] = subIssueId;
        // if (subIssueId != null) {
        //   request.fields['subissueid'] = subIssueId;
        // }

        // Add multiple files
        for (int i = 0; i < files.length && i < 10; i++) {
          final file = files[i];
          if (file != null && file.path != null) {
            final mimeType =
                lookupMimeType(file.path!) ?? 'application/octet-stream';
            final fileType = mimeType.split('/');
            final multipartFile = await http.MultipartFile.fromPath(
              'file',
              file.path!,
              contentType: MediaType(fileType[0], fileType[1]),
              filename: file.name,
            );
            request.files.add(multipartFile);
          }
        }

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        final contentType = response.headers['content-type'] ?? '';

        if (contentType.contains('application/json')) {
          final data = jsonDecode(response.body);
          if (response.statusCode == 200) {
            return {
              "success": true,
              "message": data["message"] ?? "Ticket raised successfully."
            };
          } else {
            return {
              "success": false,
              "Error": data["error"] ?? "An error occurred."
            };
          }
        } else {
          // Handle non-JSON response
          return {
            "success": false,
            "Error": "There are some problem to raise ticket",
          };
        }
      });
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'Error':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  // logout functionality with api
  Future<bool> logoutContinue({
    required String empId,
    required String userId,
    required String deviceToken,
    required String logoutType,
    required String locationId,
  }) async {
    String url = '$baseUrl/Logout_Continue';
    final payload = {
      'EmpID': empId,
      'UserID': userId,
      'Pwd': "",
      'ActionType': logoutType,
      'DeviceToken': deviceToken,
      'LocationId': locationId,
    };
    try {
      final response = await apiRequest(url, payload);

      if (response.statusCode == 200) {
        // Parse XML and extract inner text
        final xmlDoc = XmlDocument.parse(response.body);
        final jsonString = xmlDoc.rootElement.innerText;
        final List<dynamic> resBody = json.decode(jsonString);
        if (resBody.isNotEmpty &&
            resBody[0]['Status'] == 'Success' &&
            resBody[0]['Msg'] == 'Saved') {
          return true;
        }
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<Map<String, dynamic>> uploadProfileImage({
    required String tCode, //18
    required String locationId,
    required File imageFiles, //jpg,jpeg,png,gif
  }) async {
    String apiUrl = "$baseUrl/ProfileImgUpload";

    try {
      return await guardRequest<Map<String, dynamic>>(() async {
        var uri = Uri.parse(apiUrl);
        var request = http.MultipartRequest('POST', uri);

        // Add string fields
        // request.fields['DispatchOrderNo'] = dispatchOrderNo;
        // request.fields['LRNumber'] = lRNumber;
        request.fields['SPMID'] = tCode;
        request.fields['LocationId'] = locationId;
        // request.fields['ProfileImgUpload'] = fileName;

        var stream = http.ByteStream(imageFiles.openRead().cast());
        var length = await imageFiles.length();

        var multipartFile = http.MultipartFile(
          'ProfileImgUpload',
          stream,
          length,
          filename: basename(imageFiles.path),
          contentType: MediaType('image', 'jpeg'),
        );
        request.files.add(multipartFile);

        // Send request
        var response = await request.send();

        // Read response
        var responseBody = await response.stream.bytesToString();

        if (response.statusCode == 200) {
          // Parse XML
          final document = XmlDocument.parse(responseBody);
          final jsonString =
              document.rootElement.innerText; // Extracts JSON string

          // Convert JSON String to List of Maps
          List<dynamic> jsonData = jsonDecode(jsonString);
          // Access Data
          String status = jsonData[0]["Status"].toString(); // "Success"
          String message = jsonData[0]["Msg"].toString(); // "Request Confirm."
          if (status.isNotEmpty && status == "Success") {
            return {'success': true, 'data': message};
          } else {
            return {'success': false, 'message': message};
          }
        } else {
          return {
            'success': false,
            'message': 'There are some problem, Please try again later'
          };
        }
      });
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> fetchAppVersion() async {
    String apiUrl = "$scopeApiBaseurl/dm/version";
    final url = Uri.parse(apiUrl);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data['data'][0]};
        // return data;
      } else {
        return {
          'success': false,
          'message': 'There are some problem, Please try again later'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> getAppAccess(String userCode) async {
    String apiUrl = "$scopeApiBaseurl/dm/app-switcher";
    final payload = {
      'userId': userCode,
    };

    try {
      final response = await apiRequest(apiUrl, payload);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return {'success': true, 'data': data['data'][0]};
      } else {
        return {
          'success': false,
          'message': 'There are some problem, Please try again later'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> getNotifications(String locationId) async {
    String apiUrl = "$baseUrl/App_Notification";

    try {
      final response = await apiRequest(apiUrl, {'LocationId': locationId});
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = jsonData['d'];
        if (jsonDecode(data)[0]['Status'] == 'Error') {
          return {'success': false, 'message': 'No notification found'};
        }
        return {'success': true, 'data': data};
      } else {
        return {
          'success': false,
          'message': 'There are some problem, Please try again later'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<void> readNotification(int notificationId) async {
    String apiUrl = "$baseUrl/isRead";
    await apiRequest(apiUrl, {'Id': notificationId});
  }

  Future<Map<String, dynamic>> getSuggestedDealer(String brandId) async {
    String apiUrl = "$baseUrl/GetSuggestedSeller";

    try {
      final response = await apiRequest(apiUrl, {"BrandId": brandId});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Example: access 'Data' field
        if (data['d'] != null) {
          final List<dynamic> decodedList = jsonDecode(data['d']);
          return {'success': true, 'data': decodedList};
        }
        return {'success': false, 'message': 'Dealer not found'};
      } else {
        return {
          'success': false,
          'message': 'There are some problem to fetch dealer list'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> getSuggestedLocation(int dealerId) async {
    String apiUrl = "$baseUrl/GetSuggestedLocation";

    try {
      final response = await apiRequest(apiUrl, {"DealerId": dealerId});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Example: access 'Data' field
        if (data['d'] != null) {
          final List<dynamic> decodedList = jsonDecode(data['d']);
          return {'success': true, 'data': decodedList};
        }
        return {'success': false, 'message': 'Location not found'};
      } else {
        return {
          'success': false,
          'message': 'There are some problem to fetch location list'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> getSuggestedOrderType() async {
    String apiUrl = "$baseUrl/OrderFor";

    try {
      final response = await apiRequest(apiUrl, {});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Example: access 'Data' field
        if (data['d'] != null) {
          final List<dynamic> decodedList = jsonDecode(data['d']);
          return {'success': true, 'data': decodedList};
        }
        return {'success': false, 'message': 'Order type not found'};
      } else {
        return {
          'success': false,
          'message': 'There are some problem to fetch order type list'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> submitDirectRequest(
      List<Map<String, String>> parts) async {
    String apiUrl = "$baseUrl/submitDirectRequest";

    // final payload = jsonEncode({"Data": parts});

    try {
      final response = await apiRequest(apiUrl, {"Data": parts});

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['d'] != null) {
          // final List<dynamic> decodedList = jsonDecode(data['d']);
          return {'success': true, 'data': data['d']};
        }
        return {'success': false, 'message': 'Something went wrong'};
      } else {
        return {
          'success': false,
          'message': 'There are some problem to submit direct request'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> submitScsRequest(
      List<Map<String, String>> parts) async {
    String apiUrl = "$baseUrl/SubmitNotifyAdmin";

    try {
      final response = await apiRequest(apiUrl, {"Data": parts});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['d'] != null) {
          // final List<dynamic> decodedList = jsonDecode(data['d']);
          return {'success': true, 'data': data['d']};
        }
        return {'success': false, 'message': 'Something went wrong'};
      } else {
        return {
          'success': false,
          'message': 'There are some problem to submit direct request'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> getDrSentOrder(
      String locationID, String tCode) async {
    String url = "$baseUrl/ViewDRBuyer";
    final payload = {
      "locationId": locationID,
      "userId": tCode,
    };

    try {
      final response = await apiRequest(url, payload);
      // convert response into json data

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        // get data as json string from json data
        final data = jsonData['d'];

        if (data.length > 2 && data.isNotEmpty) {
          if (jsonDecode(data)[0]['Status'] == "Error") {
            // return {'success': false, 'message': jsonDecode(data)[0]['Msg']};
            return {'success': false, 'message': 'order not available'};
          }
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': 'Data not found'};
        }
      } else {
        return {
          'success': false,
          'message': 'Some thing went wrong, Please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> getDrReceivedOrder(
      String locationID, String tCode) async {
    String url = "$baseUrl/ViewDRSeller";
    final payload = {
      "locationId": locationID,
      "userId": tCode,
    };

    try {
      final response = await apiRequest(url, payload);
      // convert response into json data

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        // get data as json string from json data
        final data = jsonData['d'];

        if (data.length > 2 && data.isNotEmpty) {
          if (jsonDecode(data)[0]['Status'] == "Error") {
            // return {'success': false, 'message': jsonDecode(data)[0]['Msg']};
            return {'success': false, 'message': 'order not available'};
          }
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': 'Data not found'};
        }
      } else {
        return {
          'success': false,
          'message': 'Some thing went wrong, Please try again'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> getStockCat() async {
    String apiUrl = "$baseUrl/StockableQuality";

    try {
      final response = await apiRequest(apiUrl, {});
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Example: access 'Data' field
        if (data['d'] != null) {
          final List<dynamic> decodedList = jsonDecode(data['d']);
          return {'success': true, 'data': decodedList};
        }
        return {'success': false, 'message': 'Stock category not found'};
      } else {
        return {
          'success': false,
          'message': 'There are some problem to fetch stock category'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> acceptDrReceived({
    required String id,
    required String discount,
    required String sellerStockQty,
    required String stockQuality,
    required String tCode,
    required String locationId,
  }) async {
    String apiUrl = "$baseUrl/AcceptDRSeller";
    final Map<String, dynamic> payload = {
      "id": id,
      "Discount": discount,
      "SellerStockQty": sellerStockQty,
      "StockCat": stockQuality,
      "SellerId": tCode,
      "locationId": locationId,
    };

    try {
      final response = await apiRequest(apiUrl, payload);
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = jsonData['d'];
        if (data != null && data.isNotEmpty) {
          return {'success': true, 'data': data};
        }
        return {'success': false, 'message': 'something went wrong'};
      } else {
        return {
          'success': false,
          'message': 'There are some problem to accept order'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> rejectDRReceived({
    required String id,
    required String tCode,
  }) async {
    String apiUrl = "$baseUrl/RejectDRSeller";
    final Map<String, dynamic> payload = {
      "id": id,
      "SellerId": tCode,
    };

    try {
      final response = await apiRequest(apiUrl, payload);
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = jsonData['d'];
        if (data != null && data.isNotEmpty) {
          return {'success': true, 'data': data};
        }
        return {'success': false, 'message': 'something went wrong'};
      } else {
        return {
          'success': false,
          'message': 'There are some problem to reject order'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> getDirectRequestAccess({
    required String locationId,
  }) async {
    String apiUrl = "$baseUrl/GetDirectRequestAccess";
    final Map<String, dynamic> payload = {"LocationId": locationId};

    try {
      final response = await apiRequest(apiUrl, payload);
      final jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final data = jsonData['d'];
        if (data != null && data.isNotEmpty) {
          return {'success': true, 'data': jsonDecode(data)};
        }
        return {'success': false, 'message': 'something went wrong'};
      } else {
        return {
          'success': false,
          'message': 'There are some problem to fetch direct request access'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }
}
