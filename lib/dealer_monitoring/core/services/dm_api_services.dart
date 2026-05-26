import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:gainer/gainer_app/core/Services/auth_service.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;

class DMApiServices {
  // String baseUrl = "http://web10.185.238.new.ocpwebserver.com/api/v1/dm";
  // String baseUrl = "https://scopeapi.sparecare.in/api/v1/dm";
  String baseUrl = 'https://6mztnd0t-3000.inc1.devtunnels.ms/api/v1/dm';
  String scopeUrl = "https://scope.sparecare.in/AppServicesV2.asmx";

  Future<Map<String, dynamic>> getUserRole({required String userId}) async {
    String url = '$baseUrl/user-role';

    final Map<String, dynamic> requestBody = {
      "userId": userId,
    };

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(minutes: 10));

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        // print("Response body getUserRole: $json");

        if (json.containsKey('message')) {
          return {
            'success': true,
            'role': json['message'], // e.g., "Scope Admin"
          };
        } else {
          return {
            'success': false,
            'message': 'Role not found in response.',
          };
        }
      } else {
        // print("Server error: ${response.statusCode}");
        return {
          'success': false,
          'message': 'Server returned an error.',
        };
      }
    } on TimeoutException {
      // print("Request timed out.");
      return {
        'success': false,
        'message': 'Request timed out.',
      };
    } on http.ClientException catch (e) {
      // print("Client error: $e"/);
      return {
        'success': false,
        'message': 'Client error: $e',
      };
    } catch (e) {
      // print("Unexpected error: $e");
      return {
        'success': false,
        'message': 'Unexpected error: $e',
      };
    }
  }

  Future<Map<String, dynamic>> getPartDetails({
    required String brandId,
    required String dealerId,
    required String locationId,
    required String partNumber,
  }) async {
    String url = '$baseUrl/partdetail';

    final Map<String, dynamic> requestBody = {
      "brandid": brandId,
      "dealerid": dealerId,
      "locationid": locationId,
      "partnumber": partNumber,
    };

    // print("request body of partDetails: $requestBody");

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 10));
      // print("Response of partdetail: ${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        if (json.containsKey('Data') &&
            json['Data'] is List &&
            json['Data'].isNotEmpty) {
          // final part = json['Data'][0];
          // print("Part Number: ${part['partnumber']}");
          return {'success': true, 'data': json['Data']};
        } else {
          // print("Empty or invalid 'Data' field: ${response.body}");
          return {'success': false, 'message': 'No part details found.'};
        }
      } else {
        // print("Server error: ${response.statusCode}");
        return {
          'success': false,
          'message': 'There are some problem to fetch data'
        };
      }
    } on TimeoutException {
      // print("Request timed out. Please try again.");
      return {'success': false, 'message': 'Request timed out.'};
    } on http.ClientException catch (e) {
      // print("Client error: $e");
      return {'success': false, 'message': 'Client error: $e'};
    } catch (e) {
      // print("Unexpected error: $e");
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }

  Future<Map<String, dynamic>> getPartSale({
    required String brandId,
    required String dealerId,
    required String locationId,
    required String partNumber,
    required String userId,
  }) async {
    String url = '$baseUrl/partsale';
    final Map<String, dynamic> requestBody = {
      "brandid": brandId,
      "dealerid": dealerId,
      "locationid": locationId,
      "partnumber": partNumber,
      "userId": userId,
    };

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 10));

      // print("response of partsale: ${response.body}");
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['Details'];
        if (data is List && data.isNotEmpty) {
          return {'success': true, 'data': json};
        } else {
          // print("Data list is empty");
          // return {'success': false, 'message': 'No part details found.'};
          return {
            'success': false,
            'message': "Month's wise sale not available"
          };
        }
      } else {
        // print("Server responded with error: ${response.statusCode}");
        final msg = jsonDecode(response.body)['message'];
        return {
          'success': false,
          'message': msg == "Invalid Partnumber"
              ? msg
              : 'There are some problem to fetch data',
        };
      }
    } on TimeoutException {
      // print("Request timed out. Please try again.");
      return {'success': false, 'message': 'Request timed out.'};
    } on http.ClientException catch (e) {
      // print("Client error: $e");
      return {'success': false, 'message': 'Client error: $e'};
    } catch (e) {
      // print("An unexpected error occurred: $e");
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }

  Future<Map<String, dynamic>> getPartStock({
    required String brandId,
    required String dealerId,
    required String locationId,
    required String partNumber,
    required String userId,
  }) async {
    String url = '$baseUrl/partstock';

    final Map<String, dynamic> requestBody = {
      "brandid": brandId,
      "dealerid": dealerId,
      "locationid": locationId,
      "partnumber": partNumber,
      "userId": userId,
    };

    // print("Request Body of part stock check: $requestBody");
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 20));

      // print("response of part stock ${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        // print("json body part stock: $json");
        if (json.containsKey('Details') &&
            json['Details'] is List &&
            json['Details'].isNotEmpty) {
          return {'success': true, 'data': json};
        } else {
          // print("Empty or invalid 'Details' field: ${response.body}");
          return {'success': false, 'message': 'No part details found.'};
        }
      } else {
        // print("Server error: ${response.statusCode}");
        final msg = jsonDecode(response.body)['message'];
        return {
          'success': false,
          'message': msg == "Invalid Partnumber"
              ? msg
              : 'There are some problem to fetch data',
        };
      }
    } on TimeoutException {
      // print("Request timed out. Please try again.");
      return {
        'success': false,
        'message': 'Request timed out. Please try again.'
      };
    } catch (e) {
      // print("Unexpected error: $e");
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  Future<Map<String, dynamic>> fetchPPNIValuesByDealer({
    required String dealerId,
    required String locationId,
    required String? nonStockable,
    required String? jobCardStatus,
    required String userId,
    String? monthDate,
  }) async {
    String url = '$baseUrl/ppni-l';
    final Map<String, dynamic> requestBody = {
      "dealerid": dealerId,
      "locationid": locationId,
      "nonstockable": nonStockable, // should be "Y" or "N" or Null
      "jobcardstatus": jobCardStatus, // e.g., "Open" or Close or Null
      "month": monthDate, // e.g., date or Null
      "userId": userId,
    };
    // print("Request body of fetchPPNIValuesByDealer to $requestBody");
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(minutes: 5));

      // print("Response of ppni location: ${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        // print("Response JSON: $json");

        if (json.containsKey('Data') && json['Data'] is List) {
          // final transformed = transformPPNIData(json['Data']);
          // final jsonList = transformed.map((e) => e.toJson()).toList();
          // print("Data from Grouped: ${jsonEncode(jsonList)} ---");

          return {
            'success': true,
            'data': json['Data'], // List of location-wise values
          };
        } else {
          return {
            'success': false,
            'message': 'No data found',
          };
        }
      } else {
        // print("Server error: ${response.statusCode}, ${response.body}");
        return {
          'success': false,
          'message': 'Server error',
        };
      }
    } on TimeoutException {
      // print("Request timed out.");
      return {
        'success': false,
        'message': 'Request timed out.',
      };
    } catch (e) {
      // print("Unexpected error: $e");
      return {
        'success': false,
        'message': 'Unexpected error',
      };
    }
  }

  final Dio _dio = Dio();
  // CancelToken? _cancelToken;
  final cancelToken = CancelToken();
  void cancelRequest() {
    cancelToken.cancel("User canceled request");
  }

  Future<Map<String, dynamic>> fetchVehiclePPNIValuesByAdvisor({
    required String dealerId,
    required String? nonStockable,
    required String? jobCardStatus,
    required String locationId,
    required String advisor,
    required String userId,
    String? monthDate,
    int page = 1,
    int limit = 15,
  }) async {
    String url = '$baseUrl/ppni-v';

    final Map<String, dynamic> requestBody = {
      "dealerid": dealerId,
      "nonstockable": nonStockable,
      "jobcardstatus": jobCardStatus,
      "locationid": locationId,
      "advisor": advisor,
      "month": monthDate, // e.g., date or Null
      "pageno": page,
      "pagesize": limit,
      "userId": userId,
    };

    try {
      // final response = await http
      //     .post(
      //       Uri.parse(url),
      //       headers: {'Content-Type': 'application/json'},
      //       body: jsonEncode(requestBody),
      //     )
      //     .timeout(const Duration(minutes: 5));
      final response = await _dio.post(
        url,
        data: jsonEncode(requestBody),
        options: Options(headers: {"Content-Type": "application/json"}),
        cancelToken: cancelToken,
      );
      if (response.statusCode == 200) {
        // final Map<String, dynamic> json = jsonDecode(response.data);
        final Map<String, dynamic> json = response.data;

        if (json.containsKey('Data') && json['Data'] is List) {
          final List<dynamic> data = json['Data'][1];
          if (data.isEmpty) {
            return {
              'success': false,
              'message': 'Data not available',
            };
          }
          // data.sort((a, b) =>
          //     (b['ppniValue'] as num).compareTo(a['ppniValue'] as num));

          final totalPPNI = data.fold<double>(
            0.0,
            (sum, item) => sum + (item['PPNI_Value'] ?? 0).toDouble(),
          );
          final totalCount = json['Data'][0]['TotalCount'];
          bool hasMore = page * limit < totalCount;
          return {
            'success': true,
            'data': data,
            'totalPPNI': totalPPNI,
            'hasMore': hasMore,
          };
        } else {
          return {
            'success': false,
            'message': 'No data found.',
          };
        }
      } else {
        // print("Server error: ${response.statusCode}");
        return {
          'success': false,
          'message': 'Server error',
        };
      }
    } on TimeoutException {
      // print("Request timed out.");
      return {
        'success': false,
        'message': 'Request timed out.',
      };
    }
    // on http.ClientException catch (e) {
    //   return {'success': false, 'message': 'Client error'};
    // }
    catch (e) {
      // print("Unexpected error: $e");
      return {
        'success': false,
        'message': 'Unexpected error',
      };
    }
  }

  Future<Map<String, dynamic>> fetchPPNIParts({
    required String dealerId,
    required String locationId,
    required String vehicleNum,
    required String? nonStockable,
    required String? jobCardStatus,
    required String? advisor,
    required String userId,
    String? monthDate,
  }) async {
    String url = '$baseUrl/ppni-p';

    final Map<String, dynamic> requestBody = {
      "dealerid": dealerId,
      "locationid": locationId,
      "advisor": advisor,
      "vehicleno": vehicleNum,
      "nonstockable": nonStockable,
      "jobcardstatus": jobCardStatus,
      "month": monthDate, // e.g., date or Null
      "userId": userId,
    };

    // print("request of ppni parts $requestBody");

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(minutes: 5));

      if (response.statusCode == 204) {
        return {
          'success': false,
          'message': 'Part not available in the latest stock update',
        };
      }
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        if (json.containsKey('Data') && json['Data'] is List) {
          final data = json['Data'];
          if (data.isEmpty) {
            return {'success': false, 'message': 'No data found.'};
          }
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': 'Invalid data format.'};
        }
      } else {
        // print("Server error: ${response.statusCode}");
        return {'success': false, 'message': 'Server error'};
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      // print("Unexpected error: $e");
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  Future<Map<String, dynamic>> fetchAdvisorPPNIData({
    required String dealerId,
    required String locationId,
    required String? nonStockable,
    required String? jobCardStatus,
    required String userId,
    String? date,
  }) async {
    String url = '$baseUrl/ppni-a';

    final Map<String, dynamic> requestBody = {
      "dealerid": dealerId,
      "nonstockable": nonStockable,
      "jobcardstatus": jobCardStatus,
      "locationid": locationId,
      "month": date, // e.g., date or Null
      "userId": userId,
    };

    // print("PrintData For hit API $requestBody");

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(minutes: 5));

      // print("response of a: ${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        if (json.containsKey('Data') && json['Data'] is List) {
          if (json['Data'].isEmpty) {
            return {
              'success': false,
              'message': 'No data found.',
            };
          }
          return {
            'success': true,
            'data': List<Map<String, dynamic>>.from(json['Data']),
          };
        } else {
          return {'success': false, 'message': 'Invalid data format.'};
        }
      } else {
        // print("Server error: ${response.statusCode}");
        return {'success': false, 'message': 'Server error'};
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      // print("Unexpected error: $e");
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  Future<Map<String, dynamic>> fetchGraphPPNIValue({
    required String dealerId,
    required String? locationId,
    required String? nonStockable,
    required String? jobCardStatus,
    String? advisor,
  }) async {
    String url = '$baseUrl/ppni';

    final Map<String, dynamic> requestBody = {
      "dealerid": dealerId,
      "locationid": locationId,
      "nonstockable": nonStockable,
      "jobcardstatus": jobCardStatus,
      "advisor": advisor,
    };

    // print("🔸 Request Body fetchGraphPPNIValue to : $requestBody");

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(minutes: 5));

      // print("🔹 Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        if (json.containsKey('Data') && json['Data'] is List) {
          final List<dynamic> data = json['Data'];
          if (data.isEmpty) {
            return {'success': false, 'message': 'No PPNI data found.'};
          }

          return {
            'success': true,
            'data': data,
          };
        } else {
          return {'success': false, 'message': 'Invalid response format.'};
        }
      } else {
        return {
          'success': false,
          'message': 'Server error: ${response.statusCode}'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out.'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error try again'};
    }
  }

  Future<Map<String, dynamic>> fetchVehicleData({
    required String dealerId,
    required String locationId,
    required String vehicleNo,
    required String userId,
    String? jobCardStatus,
    String? issued,
    String? nonStockable,
    int page = 1,
    int limit = 10,
  }) async {
    String url = '$baseUrl/vehicle';

    // String url = 'https://6mztnd0t-3000.inc1.devtunnels.ms/api/v1/dm/vehicle';

    final Map<String, dynamic> requestBody = {
      "dealerid": dealerId,
      "locationid": locationId,
      "vehicleno": vehicleNo,
      "filter": jobCardStatus,
      "issued": issued,
      "alltimestk": nonStockable,
      "pageno": page,
      "pagesize": limit,
      "userId": userId,
    };

    print("Request Body for Vehicle: $url, $requestBody");
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 10));
      print(
          "🔹 Response Body Vehicle: ${response.statusCode}, ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);

        // final Map<String, dynamic> json = {
        //   "Data": [
        //     {"Count": 23},
        //     [
        //       {
        //         "bigid": "96625",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0W32111NA",
        //         "Latest": "0W32111NA",
        //         "partdesc": "CED BOL PANEL ROOF",
        //         "category": "Spare Part",
        //         "Price": 11612.7,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 11612.7,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 0,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 0,
        //         "GroupStock": 0,
        //         "LocationQtyJson": null
        //       },
        //       {
        //         "bigid": "96613",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0101EN2070A",
        //         "Latest": "0101EN2070A",
        //         "partdesc": "PANEL BODY SIDE QTR RH-CED.",
        //         "category": "Spare Part",
        //         "Price": 9666.41,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 9666.41,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 0,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 0,
        //         "GroupStock": 0,
        //         "LocationQtyJson": null
        //       },
        //       {
        //         "bigid": "96614",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0101EN2080A",
        //         "Latest": "0101EN2080A",
        //         "partdesc": "PANEL BODY SIDE QTR LH-CED..",
        //         "category": "Spare Part",
        //         "Price": 9666.41,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 9666.41,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "Y",
        //         "PPNI_Qty": 1,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 1,
        //         "GroupStock": 1,
        //         "LocationQtyJson": "[{\"Location\":\"Alwar\",\"Qty\":1.00}]"
        //       },
        //       {
        //         "bigid": "96616",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0103AAN00910A",
        //         "Latest": "0103AAN00910A",
        //         "partdesc": "FRONT DOOR ASSY COMPLETE LH - CED",
        //         "category": "Spare Part",
        //         "Price": 6712.24,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 6712.24,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 1,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 1,
        //         "GroupStock": 1,
        //         "LocationQtyJson": "[{\"Location\":\"Alwar\",\"Qty\":1.00}]"
        //       },
        //       {
        //         "bigid": "96617",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0103AN0350A",
        //         "Latest": "0103AN0350A",
        //         "partdesc": "ASSY DOOR FRT WELDG COMP RT-ced",
        //         "category": "Spare Part",
        //         "Price": 6712.24,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 6712.24,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 0,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 1,
        //         "GroupStock": 4,
        //         "LocationQtyJson":
        //             "[{\"Location\":\"Alwar\",\"Qty\":1.00},{\"Location\":\"Bharatpur\",\"Qty\":2.00},{\"Location\":\"Bhiwadi\",\"Qty\":1.00}]"
        //       },
        //       {
        //         "bigid": "96618",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0103BN0280A",
        //         "Latest": "0103BN0280A",
        //         "partdesc": "ASSY DOOR REAR WELDG COMP RH-ced",
        //         "category": "Spare Part",
        //         "Price": 6712.24,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 6712.24,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 1,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 3,
        //         "GroupStock": 4,
        //         "LocationQtyJson":
        //             "[{\"Location\":\"Alwar\",\"Qty\":3.00},{\"Location\":\"Bhiwadi\",\"Qty\":1.00}]"
        //       },
        //       {
        //         "bigid": "96619",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0103BN0290A",
        //         "Latest": "0103BN0290A",
        //         "partdesc": "ASSY DOOR REAR WELDG COMP LH-ced",
        //         "category": "Spare Part",
        //         "Price": 6712.24,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 6712.24,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 0,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 0,
        //         "GroupStock": 1,
        //         "LocationQtyJson": "[{\"Location\":\"Bharatpur\",\"Qty\":1.00}]"
        //       },
        //       {
        //         "bigid": "96611",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0101CN0130NCED",
        //         "Latest": "0101CN0130NCED",
        //         "partdesc": "assy C/ TOP+W/SHILED FRAME- Bolero -CED",
        //         "category": "Spare Part",
        //         "Price": 6211.16,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 6211.16,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 1,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 3,
        //         "GroupStock": 6,
        //         "LocationQtyJson":
        //             "[{\"Location\":\"Alwar\",\"Qty\":3.00},{\"Location\":\"Bharatpur\",\"Qty\":3.00}]"
        //       },
        //       {
        //         "bigid": "96620",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0105CAN00910A",
        //         "Latest": "0105CAN00910A",
        //         "partdesc": "ROOF TRIM HIGH BEIGE",
        //         "category": "Spare Part",
        //         "Price": 3738.3,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 3738.3,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 1,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 2,
        //         "GroupStock": 2,
        //         "LocationQtyJson": "[{\"Location\":\"Alwar\",\"Qty\":2.00}]"
        //       },
        //       {
        //         "bigid": "96628",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "1701AAA06421N",
        //         "Latest": "1701AAA06421N",
        //         "partdesc": "HEAD LAMP ASSY RH",
        //         "category": "Spare Part",
        //         "Price": 2805,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 2805,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 0,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 0,
        //         "GroupStock": 2,
        //         "LocationQtyJson":
        //             "[{\"Location\":\"Bharatpur\",\"Qty\":1.00},{\"Location\":\"Bhiwadi\",\"Qty\":1.00}]"
        //       },
        //       {
        //         "bigid": "96622",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0108EAN03220N",
        //         "Latest": "0108EAN03220N",
        //         "partdesc": "DECAL FOR LIGHT BODIES",
        //         "category": "Spare Part",
        //         "Price": 2149.65,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 2149.65,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "Y",
        //         "PPNI_Qty": 0,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 0,
        //         "GroupStock": 0,
        //         "LocationQtyJson": null
        //       },
        //       {
        //         "bigid": "96615",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0102CAN02850NA",
        //         "Latest": "0102CAN02850NA",
        //         "partdesc": "CED FENDER ASSY COMPLETE RH",
        //         "category": "Spare Part",
        //         "Price": 1987.58,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 1987.58,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "Y",
        //         "PPNI_Qty": 1,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 2,
        //         "GroupStock": 4,
        //         "LocationQtyJson":
        //             "[{\"Location\":\"Alwar\",\"Qty\":2.00},{\"Location\":\"Bharatpur\",\"Qty\":2.00}]"
        //       },
        //       {
        //         "bigid": "96641",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0108AAN00210N",
        //         "Latest": "0108AAN00210N",
        //         "partdesc": "RADIATOR GRILL ASSY COMP",
        //         "category": "Spare Part",
        //         "Price": 1556.78,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 1556.78,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 1,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 2,
        //         "GroupStock": 4,
        //         "LocationQtyJson":
        //             "[{\"Location\":\"Alwar\",\"Qty\":2.00},{\"Location\":\"Bharatpur\",\"Qty\":2.00}]"
        //       },
        //       {
        //         "bigid": "96612",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0101DK0570A",
        //         "Latest": "0101DK0570A",
        //         "partdesc": "DRIP RAIL SIDE LH CED Bolero SLX",
        //         "category": "Spare Part",
        //         "Price": 632.4,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 632.4,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 1,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 2,
        //         "GroupStock": 2,
        //         "LocationQtyJson": "[{\"Location\":\"Alwar\",\"Qty\":2.00}]"
        //       },
        //       {
        //         "bigid": "96624",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0109AN0010A",
        //         "Latest": "0109AN0010A",
        //         "partdesc": "MIRROR-INSIDE-ANTIGLARE WITH CAP",
        //         "category": "Spare Part",
        //         "Price": 395.25,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 395.25,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "Y",
        //         "PPNI_Qty": 1,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 1,
        //         "GroupStock": 1,
        //         "LocationQtyJson": "[{\"Location\":\"Alwar\",\"Qty\":1.00}]"
        //       },
        //       {
        //         "bigid": "96621",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0105CN0060A",
        //         "Latest": "0105CN0060A",
        //         "partdesc": "KIT PILLAR TRIM",
        //         "category": "Spare Part",
        //         "Price": 323.85,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 323.85,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 1,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 1,
        //         "GroupStock": 1,
        //         "LocationQtyJson": "[{\"Location\":\"Alwar\",\"Qty\":1.00}]"
        //       },
        //       {
        //         "bigid": "96608",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0028446CED",
        //         "Latest": "0028446CED",
        //         "partdesc": "ASSYA-PILLAR INNERRHWITHCED",
        //         "category": "Spare Part",
        //         "Price": 310.46,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 310.46,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 1,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 2,
        //         "GroupStock": 2,
        //         "LocationQtyJson": "[{\"Location\":\"Alwar\",\"Qty\":2.00}]"
        //       },
        //       {
        //         "bigid": "96607",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0028445CED1",
        //         "Latest": "0028445CED1",
        //         "partdesc": "Assy. A-Pillar Inner Lh with CED",
        //         "category": "Spare Part",
        //         "Price": 301.54,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 301.54,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 1,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 1,
        //         "GroupStock": 2,
        //         "LocationQtyJson":
        //             "[{\"Location\":\"Alwar\",\"Qty\":1.00},{\"Location\":\"Bharatpur\",\"Qty\":1.00}]"
        //       },
        //       {
        //         "bigid": "96626",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0W33211",
        //         "Latest": "0W33211",
        //         "partdesc": "FRT PLR OTR RT",
        //         "category": "Spare Part",
        //         "Price": 249.9,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 249.9,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 1,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 2,
        //         "GroupStock": 3,
        //         "LocationQtyJson":
        //             "[{\"Location\":\"Alwar\",\"Qty\":2.00},{\"Location\":\"Bharatpur\",\"Qty\":1.00}]"
        //       },
        //       {
        //         "bigid": "96627",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0W33212",
        //         "Latest": "0W33212",
        //         "partdesc": "FRT PLR OUTER LT",
        //         "category": "Spare Part",
        //         "Price": 249.9,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 249.9,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 0,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 1,
        //         "GroupStock": 1,
        //         "LocationQtyJson": "[{\"Location\":\"Alwar\",\"Qty\":1.00}]"
        //       },
        //       {
        //         "bigid": "96609",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0029202",
        //         "Latest": "29202",
        //         "partdesc": "STRIP RR.DOOR RT.",
        //         "category": "Spare Part",
        //         "Price": 153,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 153,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 1,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 3,
        //         "GroupStock": 4,
        //         "LocationQtyJson":
        //             "[{\"Location\":\"Alwar\",\"Qty\":3.00},{\"Location\":\"Bharatpur\",\"Qty\":1.00}]"
        //       },
        //       {
        //         "bigid": "96610",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0029203",
        //         "Latest": "29203",
        //         "partdesc": "W/STRIP RR DOOR LT",
        //         "category": "Spare Part",
        //         "Price": 153,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 153,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 1,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 3,
        //         "GroupStock": 4,
        //         "LocationQtyJson":
        //             "[{\"Location\":\"Alwar\",\"Qty\":3.00},{\"Location\":\"Bharatpur\",\"Qty\":1.00}]"
        //       },
        //       {
        //         "bigid": "96623",
        //         "DealerId": 8,
        //         "LocationId": 14,
        //         "Vehiclenumber": "RJ02UA9554",
        //         "jobcard_number": "RO26A022906",
        //         "part_number1": "0108FN0990N",
        //         "Latest": "0108FN0990N",
        //         "partdesc": "COVER ASSY VENTILATOR RH",
        //         "category": "Spare Part",
        //         "Price": 44.63,
        //         "Qty": 1,
        //         "Final_close": "Close",
        //         "Value": 44.63,
        //         "OrderDate": "2026-02-03T17:07:56.753Z",
        //         "All_Time_NonStck": "N",
        //         "PPNI_Qty": 1,
        //         "IssueStatus": "Not Issued",
        //         "BrandID": 9,
        //         "StockQty": 6,
        //         "GroupStock": 15,
        //         "LocationQtyJson":
        //             "[{\"Location\":\"Alwar\",\"Qty\":6.00},{\"Location\":\"Bharatpur\",\"Qty\":5.00},{\"Location\":\"Bhiwadi\",\"Qty\":3.00},{\"Location\":\"Neemrana\",\"Qty\":1.00}]"
        //       }
        //     ]
        //   ],
        //   "Score": [
        //     {
        //       "InStockCount": 18,
        //       "InStockTotal": 46110.88,
        //       "OutStockCount": 5,
        //       "OutStockTotal": 32946
        //     }
        //   ]
        // };

        if (json.containsKey('Data') && json['Data'] is List) {
          final List<dynamic> jobCard = json['Data'][1];
          final totalCount = json['Data'][0]['Count'];
          bool hasMore = page * limit < totalCount;
          final List<dynamic> score = json['Score'] ?? [];

          if (jobCard.isEmpty) {
            // return {'success': false, 'message': 'Vehicle data not found.'};
            return {
              'success': false,
              // 'message': 'All parts for this vehicle has been issued'
              'message': 'Data not available'
            };
          }

          return {
            'success': true,
            'data': jobCard,
            'score': score,
            'hasMore': hasMore,
          };
        } else {
          return {'success': false, 'message': 'Invalid response format.'};
        }
      } else {
        final msg =
            jsonDecode(response.body)["message"] == "Invalid Vehicle Number"
                ? "Invalid Vehicle Number"
                : "Unexpected error";
        return {
          'success': false,
          'message': msg,
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out.'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error try again'};
    }
  }

  Future<Map<String, dynamic>> getNorms({
    required String locationId,
    required String dealerId,
    required String partNumber,
    required String brandId,
    required String userId,
  }) async {
    // print("DealerId: $dealerId, PartNumber: $partNumber");

    String url = '$baseUrl/norms';
    final Map<String, dynamic> requestBody = {
      "locationid": locationId,
      "dealerid": dealerId,
      "partnumber": partNumber,
      "brandid": brandId,
      "userId": userId,
    };

    // print("Request data of $requestBody");
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 10));

      // print("response of Norms: ${response.body}");
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        final details = json['Details'];
        if (details.isNotEmpty) {
          return {'success': true, 'data': json};
        } else {
          return {'success': false, 'message': "Norms details not available"};
        }
      } else {
        final msg = jsonDecode(response.body)['message'];
        return {
          'success': false,
          'message': msg == "Invalid Partnumber"
              ? msg
              : 'There are some problem to fetch data',
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out.'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  Future<Map<String, dynamic>> getOrderInfo({
    required String dealerId,
    required String brandId,
    required String locationId,
    required String partNumber,
    required String uDate,
    required String lDate,
    required String userId,
  }) async {
    String url = '$baseUrl/order';

    final Map<String, dynamic> requestBody = {
      "dealerid": dealerId,
      "brandid": brandId,
      "locationid": locationId,
      "partnumber": partNumber,
      "Udate": uDate,
      "Ldate": lDate,
      "userId": userId,
    };

    // print("request body of getOrderInfo $requestBody");
    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 10));

      // print("response of order Info: ${response.body}");
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);

        // final data = json['Data'];
        if (json.isNotEmpty) {
          return {'success': true, 'data': json};
        } else {
          return {
            'success': false,
            'message': "Order Information not available"
          };
        }
      } else {
        final msg = jsonDecode(response.body)['message'];
        return {
          'success': false,
          'message': msg == "Invalid Partnumber"
              ? msg
              : 'There are some problem to fetch data'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out.'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  Future<Map<String, dynamic>> getSubstitution({
    required brandId,
    required dealerId,
    required locationId,
    required partNumber,
    required String userId,
  }) async {
    String url = "$baseUrl/subparts";
    final Map<String, dynamic> requestBody = {
      "brandid": brandId,
      "dealerid": dealerId,
      "locationid": locationId,
      "partnumber": partNumber,
      "userId": userId,
    };

    // print("requestBody of subParts: $requestBody");

    try {
      final response = await http
          .post(
            Uri.parse(url),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode(requestBody),
          )
          .timeout(const Duration(seconds: 10));
      // print("Response of substitution part: ${response.body}");
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['Data'];
        if (data is List && data.isNotEmpty) {
          return {'success': true, 'data': data};
        } else {
          return {
            'success': false,
            'message': "Substitution parts not available"
          };
        }
      } else {
        final msg = jsonDecode(response.body)['message'];
        return {
          'success': false,
          'message': msg == "Invalid Partnumber"
              ? msg
              : 'There are some problem to fetch data',
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out.'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  Future<Map<String, dynamic>> getStockDate({
    required dealerId,
    required locationId,
  }) async {
    final String url = "https://scopeapi.sparecare.in/api/v1/master/dates";
    final Map<String, dynamic> requestBody = {
      "dealerid": dealerId,
      "locationid": locationId
    };
    // print("RequestBody of Dates: $requestBody");

    try {
      final response = await http
          .post(Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(requestBody))
          .timeout(const Duration(minutes: 5));

      // print("Response of Dates: ${response.body}");

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['Data'];
        // Extract and flatten the list
        List<Map<String, dynamic>> flattenedList = [];

        for (var innerList in data) {
          if (innerList is List && innerList.isNotEmpty) {
            final item = innerList.first;
            if (item is Map<String, dynamic>) {
              flattenedList.add(item);
            }
          }
        }
        if (data is List && data.isNotEmpty) {
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': "No date available"};
        }
      } else {
        return {
          'success': false,
          'message': 'There are some problem to fetch data'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  Future<Map<String, dynamic>> getGainerListing({
    required dealerId,
    required locationId,
    required partNumber,
  }) async {
    final String url = "$baseUrl/gnr-listing";
    final Map<String, dynamic> requestBody = {
      "dealerid": dealerId,
      "locationid": locationId,
      "partnumber": partNumber
    };
    // print("RequestBody of gnr-listing: $requestBody");

    try {
      final response = await http
          .post(Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(requestBody))
          .timeout(const Duration(seconds: 20));

      // print("Response of gnr-listing: ${response.body}");

      if (response.statusCode == 200) {
        // print("Response Body: ${response.body}");
        final json = jsonDecode(response.body);
        final data = json['Data'];
        if (data is List && data.isNotEmpty) {
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': "Gainer Listing not available"};
        }
      } else {
        return {
          'success': false,
          'message': 'There are some problem to fetch data'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  Future<Map<String, dynamic>> getVehicleSuggestion({
    required dealerId,
    required vehicleNumber,
  }) async {
    final String url = "$baseUrl/predictive-v";
    final Map<String, dynamic> requestBody = {
      "dealerid": dealerId,
      "vehicleno": vehicleNumber
    };
    // print("RequestBody of getVehicleSuggestion: $requestBody");

    try {
      final response = await http
          .post(Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(requestBody))
          .timeout(const Duration(seconds: 10));
      // print("Response Body of getVehicleSuggestion: ${response.body}");
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['Data'];
        if (data is List && data.isNotEmpty) {
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': "No Vehicle Match"};
        }
      } else {
        return {
          'success': false,
          'message': 'There are some problem to fetch data'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  Future<Map<String, dynamic>> getRemarksItem({
    required type,
  }) async {
    final String url = "$baseUrl/remark";
    final Map<String, dynamic> requestBody = {
      "type": type,
    };
    // print("RequestBody of getRemarksItem: $requestBody");

    try {
      final response = await http
          .post(Uri.parse(url),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(requestBody))
          .timeout(const Duration(seconds: 10));

      // print("Response Body of getRemarksItem: ${response.body}");
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['Data'];
        if (data is List && data.isNotEmpty) {
          data.add({"Id": 0, "Remark": "Others"});
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': "No remarks available"};
        }
      } else {
        return {
          'success': false,
          'message': 'There are some problem to fetch remarks'
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  /// Upload remark + optional file and optional advancevalue
  Future<Map<String, dynamic>> addRemarks({
    required String url,
    required String dealerId,
    required String locationId,
    String? bigId,
    String? partNumber,
    String? remark,
    required String remarkId,
    required String userId,
    required String vehicleNumber,

    // optional fields
    File? file, // optional image/file
    String? advanceValue, // optional int
  }) async {
    // Debug print all values
//     print("""
//               ===== AddRemarks Request =====
//               url           : $url
//               dealerId      : $dealerId
//               locationId    : $locationId
//               bigId         : $bigId
//               partNumber    : $partNumber
//               remark        : $remark
//               remarkId      : $remarkId
//               userId        : $userId
//               vehicleNumber : $vehicleNumber
//               advanceValue  : $advanceValue
//               file          : ${file != null ? file.path : "No file selected"}
//               ======================================
// """);
    // Adjust the path if your endpoint differs
    final String apiUrl = "$baseUrl/$url";

    try {
      final uri = Uri.parse(apiUrl);
      final request = http.MultipartRequest('POST', uri);

      // Required fields
      request.fields['Dealerid'] = dealerId;
      request.fields['LocationId'] = locationId;
      // request.fields['bigid'] = bigId;
      // request.fields['partnumber'] = partNumber;
      request.fields['remarkid'] = remarkId; // your selected Id from dropdown
      request.fields['userid'] = userId;
      request.fields['vehiclenumber'] = vehicleNumber;

      // if remarks not for PPNI vehicle
      if (url != "rmrk-pv" && (bigId != null && partNumber != null)) {
        request.fields['bigid'] = bigId;
        request.fields['partnumber'] = partNumber;
      }

      if (remark != null) {
        request.fields['remark'] = remark; // can be "" or null
      }

      if (file != null) {
        request.fields['advancevalue'] = advanceValue.toString();
        final ext = p.extension(file.path).toLowerCase();
        final mt = ext == '.png'
            ? MediaType('image', 'png')
            : ext == '.webp'
                ? MediaType('image', 'webp')
                : MediaType('image', 'jpeg'); // default
        request.files.add(await http.MultipartFile.fromPath(
          'file',
          file.path,
          filename: p.basename(file.path),
          contentType: mt,
        ));
      }

      // Send with timeout
      final streamed =
          await request.send().timeout(const Duration(seconds: 20));
      final body = await streamed.stream.bytesToString();

      // print("Body of add remarks: $body");

      // Expecting JSON: {"message":"Insertion Successful"}
      if (streamed.statusCode == 200) {
        final decoded = jsonDecode(body);
        final msg = (decoded is Map && decoded['message'] != null)
            ? decoded['message'].toString()
            : 'OK';
        final success = msg.toLowerCase().contains('success');
        return {'success': success, 'message': msg};
      } else {
        return {
          'success': false,
          'message': 'There are some problem to add remarks',
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } on http.ClientException catch (e) {
      return {'success': false, 'message': 'Client error: $e'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error: $e'};
    }
  }

  Future<Map<String, dynamic>> viewRemarks({
    required String type,
    String? vehicleNumber,
    String? partNumber,
  }) async {
    final String url = "$baseUrl/view-log";
    final Map<String, dynamic> requestBody = {
      "type": type,
      "partnumber": partNumber,
      "vehiclenumber": vehicleNumber,
      "from": null,
      "to": null
    };

    // print("requestBody of viewRemarks: $requestBody");

    try {
      final http.Response response = await http
          .post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(requestBody),
          )
          .timeout(Duration(seconds: 10));
      // print("ResponseBody of viewRemarks: ${response.body}");
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['Data'];
        if (data is List && data.isNotEmpty) {
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': "No remarks available"};
        }
      } else {
        return {
          'success': false,
          'message': "There are some problem to fetch data"
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  Future<Map<String, dynamic>> gainerStockChekLog({
    // required String vehicleNumber,
    required Map<String, dynamic> payload,
    required String userId,
    required String locationId,
  }) async {
    final String url = "$baseUrl/log";
    // final String url =
    // "http://web10.185.238.new.ocpwebserver.com/api/v1/dm/log";
    final Map<String, dynamic> requestBody = {
      // "moduleName": "VehicleSearch",
      "locationid": locationId,
      "moduleName": "GainerStockCheck",
      "event": "PartCheck",
      "details": payload,
      "userid": userId,
    };

    try {
      final http.Response response = await http
          .post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(requestBody),
          )
          .timeout(Duration(seconds: 10));
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final data = json['Data'];
        if (data is List && data.isNotEmpty) {
          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': ""};
        }
      } else {
        return {
          'success': false,
          'message': "There are some problem to vehicle log"
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  Future<Map<String, dynamic>> vehicleSearchCheckBox({
    required String vehicleNumber,
    required String dealerId,
    required String locationId,
    required String userId,
  }) async {
    final String url = "$baseUrl/vehicle-consent";
    final Map<String, dynamic> requestBody = {
      "vehiclenumber": vehicleNumber,
      "dealerid": dealerId,
      "locationid": locationId,
      "userId": userId,
    };

    // print("requestBody of checkJobcard: $requestBody");

    try {
      final http.Response response = await http
          .post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(requestBody),
          )
          .timeout(Duration(seconds: 10));
      // print(response.body);
      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final isSuccess = json['success'];
        if (isSuccess) {
          return {'success': true, 'data': json};
        } else {
          return {'success': false, 'message': ""};
        }
      } else {
        return {
          'success': false,
          'message': "There are some problem to confirmation job card"
        };
      }
    } on TimeoutException {
      return {'success': false, 'message': 'Request timed out'};
    } catch (e) {
      return {'success': false, 'message': 'Unexpected error'};
    }
  }

  Future<Map<String, dynamic>> searchPart(String partNumber) async {
    String brandId = await AuthService.getBrandId();
    String locationId = await AuthService.getLocationId();
    String tCode = await AuthService.getTCode();
    String url = '$scopeUrl/GetPartNumber';
    final payload = {
      "PartNumber": partNumber,
      "BrandID": brandId,
      "LocationId": locationId,
      "UserId": tCode,
    };
    try {
      final http.Response response = await http
          .post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(payload),
          )
          .timeout(Duration(seconds: 2));

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

  Future<Map<String, dynamic>> getGrpStockForVehicle(String partNumber) async {
    String brandId = await AuthService.getBrandId();
    String dealerId = await AuthService.getDealerId();
    String locationId = await AuthService.getLocationId();
    String url = '$baseUrl/grpstk';
    // String url = 'http://web10.185.238.new.ocpwebserver.com/api/v1/dm/grpstk';
    final payload = {
      "brandid": brandId,
      "dealerid": dealerId,
      "locationid": locationId,
      "partnumber": partNumber,
    };
    try {
      print("url: $url, $payload");
      final http.Response response = await http
          .post(
            Uri.parse(url),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode(payload),
          )
          .timeout(Duration(seconds: 10));

      final jsonData = jsonDecode(response.body);
      // get data as json string from json data
      print("jsonData: ${response.body}");

      if (response.statusCode == 200) {
        // final data = jsonData['d'];
        if (jsonData['success']) {
          // Split the string into a list
          final stockDetails = jsonData['data'];
          return {'success': true, 'data': stockDetails};
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
}
