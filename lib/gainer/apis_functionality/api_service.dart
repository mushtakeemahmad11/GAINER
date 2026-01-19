import 'dart:async';
import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';
import 'package:path/path.dart';
import 'package:xml/xml.dart';

class ApiService {
  final String baseUrl = "https://scope.sparecare.in/AppServices.asmx";

  Future<Map<String, dynamic>> loginUser(
    String userId,
    String password,
    String deviceToken,
  ) async {
    const url = 'https://scope.sparecare.in/AppServices.asmx/SPMLoginV2';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "UserID": userId,
          "Pwd": password,
          "DeviceToken": deviceToken,
        }),
      );
      // convert response into json data
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
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> searchPart(
      String partNumber, String brandId) async {
    const url = 'https://scope.sparecare.in/AppServices.asmx/GetPartNumber';
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({"PartNumber": partNumber, "BrandID": brandId}),
          )
          .timeout(const Duration(seconds: 2));

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

  Future<Map<String, dynamic>> trackOrder(String orderNumber) async {
    const url = 'https://scope.sparecare.in/AppServices.asmx/TrackOrder';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"DispatchOrderNo": orderNumber}),
      );

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
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> getPartDetails(
      String brandID, String partNumber) async {
    const url = 'https://scope.sparecare.in/AppServices.asmx/GetPartdetails';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"brandid": brandID, "partnumber": partNumber}),
      );

      Map<String, dynamic> jsonData = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (jsonData["d"] != "[]" && jsonData.isNotEmpty) {
          final data = jsonData['d'];
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': 'Part not found'};
        }
      } else {
        return {
          'success': false,
          'message': 'Some thing went wrong,Please try again'
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

  Future<Map<String, dynamic>> getLSP(String locationID) async {
    const url = 'https://scope.sparecare.in/AppServices.asmx/GetLSP';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"LocationID": locationID}),
      );

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
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> getLocation(String tCode) async {
    const url = 'https://scope.sparecare.in/AppServices.asmx/GetLocation';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"tCode": tCode}),
      );

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
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> getCluster(String locationID) async {
    const url = 'https://scope.sparecare.in/AppServices.asmx/GetCluster';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"LocationID": locationID}),
      );
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
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  Future<Map<String, dynamic>> getBuyerValues(String locationID) async {
    const url = 'https://scope.sparecare.in/AppServices.asmx/GetBuyerValues';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"LocationID": locationID}),
      );
      // convert response into json data
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
  ) async {
    String url = "$baseUrl/GetSellerLocationForOrder";

    try {
      final response = await http.post(Uri.parse(url),
          headers: ({'Content-Type': 'application/json'}),
          body: jsonEncode({
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
          }));

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
    //"PARTNUMBER", "ClusterCode", "SELLERDEALERID", "SELLERLOCATION", "SELLERSTOCKQTY", "SELLERFREESTOCK", "DISCOUNT", "TAT", "SELLERVERIFIED", "SCSVERIFIED", "ORDERQTY", "REMARKS", "PRICE", "MRP", "RATE", "StockCat"

    try {
      // print({
      //   "BuyerBrandID": brandID,
      //   "BuyerDealerID": dealerID,
      //   "BuyerLocationID": locationID,
      //   "UserID": userID,
      //   "OrderFor": orderFor,
      //   "LspCode": lspCode,
      //   "TableVal": tableVal
      // });
      final response = await http.post(Uri.parse(url),
          headers: ({'Content-Type': 'application/json'}),
          body: jsonEncode({
            "BuyerBrandID": brandID,
            "BuyerDealerID": dealerID,
            "BuyerLocationID": locationID,
            "UserID": userID,
            "OrderFor": orderFor,
            "LspCode": lspCode,
            "TableVal": tableVal
          }));
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
          'message': 'Something went wrong, please try again'
        };
      }
      // if (response.statusCode == 200) {
      //   if (data.isNotEmpty) {
      //     if (jsonDecode(data)[0]['Status'] == "Error") {
      //       return {'success': false, 'message': jsonDecode(data)[0]['Msg']};
      //     }
      //     return {'success': true, 'data': data};
      //   } else {
      //     return {'success': false, 'message': 'Data not found'};
      //   }
      // } else {
      //   return {
      //     'success': false,
      //     'message': 'Some thing went wrong,Please try again'
      //   };
      // }
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  // Get Buyer stage according to location id and stage name(orderPlaced,POUpdation....)
  Future<Map<String, dynamic>> getBuyerStages(
      String locationID, String stage) async {
    String url = '$baseUrl/GetBuyerStages';

    try {
      final response = await http.post(Uri.parse(url),
          headers: ({'Content-Type': 'application/json'}),
          body: jsonEncode({"LocationID": locationID, "Stage": stage}));

      // convert response into json data
      final jsonData = jsonDecode(response.body);

      // print("response: PO : $jsonData");
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
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  // delete order according to bigID in OrderPlaced screen as buyer
  Future<Map<String, dynamic>> orderPlacedDelete(String bigID) async {
    String url = '$baseUrl/OrderPlace_Delete';

    try {
      final response = await http.post(Uri.parse(url),
          headers: ({'Content-Type': 'application/json'}),
          body: jsonEncode({"BigID": bigID}));

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
      String locationID, String stage) async {
    String url = '$baseUrl/GetSellerStages';

    try {
      final response = await http.post(Uri.parse(url),
          headers: ({'Content-Type': 'application/json'}),
          body: jsonEncode({"LocationID": locationID, "Stage": stage}));

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
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  // Get Dispatch details as seller stage
  Future<Map<String, dynamic>> dispatchDetailsStage(
      String brandID, String dealerID, String sellerLocationID) async {
    String url = '$baseUrl/GetDispatchDetails';

    try {
      final response = await http.post(Uri.parse(url),
          headers: ({'Content-Type': 'application/json'}),
          body: jsonEncode({
            "BrandID": brandID,
            "DealerID": dealerID,
            "SellerLocationID": sellerLocationID
          }));

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

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "BigID": bigID,
          "Remarks": remarks,
          "RejectReason": rejectReason,
          "FreeStock": freeStock,
          "PartNumber": partNumber,
          "StockCatType": stockCatType,
          "SellerLocationID": sellerLocationID,
          "LoginUserID": loginUserID,
        }),
      );

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

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "BigID": bigID,
          "Remarks": remarks,
          "ConfirmQty": confirmQty,
          "FreeStock": freeStock,
          "TransporterType": transporterType,
          "Img1": img1,
          "Img2": img2,
          "Img3": img3,
          "LoginUserID": loginUserID
        }),
      );

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
  }) async {
    String url = '$baseUrl/POReject';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "FreeStock": freeStock,
          "RejectReason": rejectReason,
          "Remarks": remarks,
          "BigID": bigID,
        }),
      );

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
  }) async {
    String url = '$baseUrl/POFurtherDetail';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "Remarks": remarks,
          "BigID": bigID,
        }),
      );

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

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "PoNumber": poNumber,
          "UserID": userID,
          "BrandID": brandID,
          "DealerID": dealerID,
          "LocationID": locationID,
          "TableVal": tableValue,
        }),
      );

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
  }) async {
    String apiUrl = "$baseUrl/OrderDueAcceptV2";

    try {
      var uri = Uri.parse(apiUrl);
      var request = http.MultipartRequest('POST', uri);

      // Add string fields
      request.fields['BigID'] = bigID;
      request.fields['Remarks'] = remarks;
      request.fields['ConfirmQty'] = confirmQty;
      request.fields['FreeStock'] = freeStock;
      request.fields['TransporterType'] = transporterType;
      request.fields['LoginUserID'] = loginUserID;

      for (var file in imageFiles) {
        var stream = http.ByteStream(file.openRead().cast());
        var length = await file.length();

        var multipartFile = http.MultipartFile(
          'file',
          stream,
          length,
          filename: basename(file.path),
          contentType: MediaType('image', 'jpeg'), // Change to 'png' if needed
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
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  //PartReceipt(as Buyer) screen with image or without on click Good and Issue>submit
  Future<Map<String, dynamic>> pendingToBeReceived({
    required String remarks,
    required String actionType,
    required String bigID,
    required List<File> imageFiles, // List of image files
  }) async {
    String apiUrl = "$baseUrl/PendingToBeReceivedV2";

    /// for with image
    try {
      var uri = Uri.parse(apiUrl);
      var request = http.MultipartRequest('POST', uri);
      // Add string fields
      request.fields['Remarks'] = remarks;
      request.fields['ActionType'] = actionType;
      request.fields['BigID'] = bigID;

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
          contentType: mediaType, // Automatically set the correct content type
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

    try {
      final response = await http.post(Uri.parse(url),
          headers: ({'Content-Type': 'application/json'}),
          body: jsonEncode({"AlertLocation": alertLocation, "BigID": bigID}));

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
    // required Map<String, File?> imageFiles
    // required List<String> fileName, // List of image files
  }) async {
    String apiUrl = "$baseUrl/DispatchDetailsImgUploadV2";
    try {
      var uri = Uri.parse(apiUrl);
      var request = http.MultipartRequest('POST', uri);

      // Add string fields
      request.fields['DispatchOrderNo'] = dispatchOrderNo;
      request.fields['LRNumber'] = lRNumber;
      request.fields['tCode'] = tCode;
      request.fields['ImgSource'] = fileName;

      // // Add images if available
      // for (var entry in imageFiles.entries) {
      //   if (entry.value != null) {
      //     request.files.add(
      //         await http.MultipartFile.fromPath(
      //           entry.key,
      //           entry.value!.path,
      //           filename: basename(entry.value!.path),
      //         )
      //     );
      //   }
      // }

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

      // for (var file in imageFiles) {
      //   var stream = http.ByteStream(file.openRead().cast());
      //   var length = await file.length();
      //
      //   var multipartFile = http.MultipartFile(
      //     'file',
      //     stream,
      //     length,
      //     filename: basename(file.path),
      //     contentType: MediaType('image', 'jpeg'), // Change to 'png' if needed
      //   );
      //
      //   request.files.add(multipartFile);
      // }

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
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  // DispatchDetailsSubmit in OrderPlaced screen as seller
  Future<Map<String, dynamic>> dispatchDetailsSubmit(
      String dispatchOrderNo, String lrNumber) async {
    String url = '$baseUrl/DispatchDetailsSubmit';

    try {
      final response = await http.post(Uri.parse(url),
          headers: ({'Content-Type': 'application/json'}),
          body: jsonEncode(
              {"DispatchOrderNo": dispatchOrderNo, "LRNumber": lrNumber}));

      // convert response into json data
      final jsonData = jsonDecode(response.body);

      // get data as json string from json data
      final data = jsonData['d'];

      //   {
      //     "d": "[{\"Status\":\"Success\",\"Msg\":\"Saved\"}]"
      // }

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
  }) async {
    // const url = '$baseUrl/CalculateFreightCost';
    String url = '$baseUrl/CalculateFreightCost';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "BuyerLocationID": buyerLocationID,
          "BrandID": brandID,
          "SellerDealerID": sellerDealerID,
          "SellerLocationID": sellerLocationID,
          "InvoiceAmount": invoiceAmount,
          "Distance": distance,
          "ItemsArr": itemsArr,
          "NoofBoxes": noOfBoxes,
          "isWeFastUse": isWeFastUse,
        }),
      );

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
  }) async {
    String apiUrl = "$baseUrl/ManifestationInvoicePdfUpload";

    try {
      var uri = Uri.parse(apiUrl);
      var request = http.MultipartRequest('POST', uri);

      // 👉 Add string fields
      request.fields['BigID'] = bigID;
      request.fields['SeqNo'] = seqNo;

      // 👉 Add PDF file
      var stream = http.ByteStream(pdfFile.openRead().cast());
      var length = await pdfFile.length();

      var multipartFile = http.MultipartFile(
        'file',
        stream,
        length,
        filename: basename(pdfFile.path),
        contentType: MediaType('application', 'pdf'),
      );

      request.files.add(multipartFile);

      // 👉 Send request
      var response = await request.send();

      // 👉 Read response
      var responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final document = XmlDocument.parse(responseBody);
        final jsonString = document.rootElement.innerText;

        List<dynamic> jsonData = jsonDecode(jsonString);

        String status = jsonData[0]["Status"].toString();
        String message = jsonData[0]["Msg"].toString();

        if (status == "Success") {
          return {'success': true, 'data': jsonData};
        } else {
          return {'success': false, 'message': message};
        }
      } else {
        return {
          'success': false,
          'message': 'Server Error: ${response.statusCode}'
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error or unexpected issue occurred.'
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
  }) async {
    String url = '$baseUrl/Manifestation';

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
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
        }),
      );

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
    } catch (e) {
      return {
        'success': false,
        'message':
            'Network is unreachable\nPlease check your Internet connection or try again'
      };
    }
  }

  /// In help screen for raise ticket
  Future<Map<String, Object>> raiseTicketHelp({
    required issue,
    required desc,
    required userid,
    required locationId,
    required issueId,
    required subIssueId,
    // File? file, // Optional PDF or image
    required List<PlatformFile?> files, // Multiple Optional PDF or image
  }) async {
    final uri =
        Uri.parse('http://web27.185.238.new.ocpwebserver.com/api/v1/gnr/help');
    // 'https://6mztnd0t-3001.inc1.devtunnels.ms/api/v1/gainer/help');
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

    // Add optional file
    // if (file != null) {
    //   final mimeType = lookupMimeType(file.path) ?? 'application/octet-stream';
    //   final fileType = mimeType.split('/');
    //
    //   request.files.add(await http.MultipartFile.fromPath(
    //     'file',
    //     file.path,
    //     contentType: MediaType(fileType[0], fileType[1]),
    //     filename: basename(file.path),
    //   ));
    // }

    try {
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
          "Error": "There is some problem to raise ticket",
        };
      }
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
  }) async {
    String url = '$baseUrl/Logout_Continue';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'EmpID': empId,
          'UserID': userId,
          'Pwd': "",
          'ActionType': logoutType,
          'DeviceToken': deviceToken,
        },
      );
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
}
