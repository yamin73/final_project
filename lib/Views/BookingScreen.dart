// import 'package:flutter/material.dart';
// import 'package:table_calendar/table_calendar.dart';
// import 'package:http/http.dart' as http;
//
// import '../Utills/ClientConfig.dart';
//
// class BookingScreen extends StatefulWidget {
//   @override
//
//   _BookingScreenState createState() => _BookingScreenState();
// }
//
//
// class _BookingScreenState extends State<BookingScreen> {
//   int step = 1;
//   final ScrollController _scrollController = ScrollController();
//   Map<String, dynamic> formData = {
//     'carBrand': '',
//     'carModel': '',
//     'year': '',
//     'serviceType': '',
//     'date': null,
//     'timeSlot': '',
//     'notes': ''
//   };
//
//   // قائمة بجميع أنواع السيارات
//   final List<String> carBrands = [
//     'Toyota', 'Honda', 'Nissan', 'Mercedes', 'BMW', 'Audi', 'Ford', 'Chevrolet',
//     'Volkswagen', 'Hyundai', 'Kia', 'Volvo', 'Mazda', 'Subaru', 'Lexus', 'Tesla',
//     'Porsche', 'Jaguar', 'Land Rover', 'Fiat', 'Renault', 'Peugeot', 'Citroen',
//     'Suzuki', 'Mitsubishi', 'Infiniti', 'Acura', 'Buick', 'Cadillac', 'Chrysler',
//     'Dodge', 'Jeep', 'Ram', 'Alfa Romeo', 'Aston Martin', 'Bentley', 'Ferrari',
//     'Lamborghini', 'Maserati', 'McLaren', 'Rolls-Royce', 'Bugatti', 'Lotus',
//     'Mini', 'Smart', 'Genesis', 'SsangYong', 'Tata', 'Mahindra', 'Geely', 'BYD'
//   ];
//
//   // قائمة بجميع موديلات السيارات
//   final Map<String, List<String>> carModels = {
//     'Toyota': [
//       'Camry', 'Corolla', 'Land Cruiser', 'RAV4', 'Prius', 'Highlander', 'Tacoma',
//       'Tundra', '4Runner', 'Sienna', 'Avalon', 'C-HR', 'Venza', 'Sequoia', 'GR Supra'
//     ],
//     'Honda': [
//       'Civic', 'Accord', 'CR-V', 'Pilot', 'Odyssey', 'HR-V', 'Ridgeline',
//       'Passport', 'Insight', 'Fit', 'Element', 'CR-Z'
//     ],
//     'Nissan': [
//       'Altima', 'Maxima', 'Patrol', 'Sentra', 'Rogue', 'Murano', 'Pathfinder',
//       'Frontier', 'Titan', 'Kicks', 'Armada', 'GT-R', '370Z', 'Leaf'
//     ],
//     'Mercedes': [
//       'A-Class', 'C-Class', 'E-Class', 'S-Class', 'GLA', 'GLB', 'GLC', 'GLE',
//       'GLS', 'AMG GT', 'CLA', 'CLS', 'G-Class', 'EQS', 'EQE'
//     ],
//     'BMW': [
//       '1 Series', '2 Series', '3 Series', '4 Series', '5 Series', '6 Series',
//       '7 Series', '8 Series', 'X1', 'X2', 'X3', 'X4', 'X5', 'X6', 'X7', 'i3', 'i4', 'i8'
//     ],
//     'Audi': [
//       'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'Q3', 'Q5', 'Q7', 'Q8', 'TT',
//       'R8', 'e-tron', 'RS6', 'RS7', 'S3', 'S4', 'S5'
//     ],
//     'Ford': [
//       'F-150', 'Mustang', 'Explorer', 'Escape', 'Edge', 'Expedition', 'Ranger',
//       'Bronco', 'Bronco Sport', 'Maverick', 'Mach-E', 'Transit', 'EcoSport'
//     ],
//     'Chevrolet': [
//       'Silverado', 'Tahoe', 'Suburban', 'Equinox', 'Traverse', 'Malibu', 'Camaro',
//       'Corvette', 'Blazer', 'Trax', 'Colorado', 'Spark', 'Bolt EV'
//     ],
//     'Volkswagen': [
//       'Golf', 'Jetta', 'Passat', 'Tiguan', 'Atlas', 'ID.4', 'Arteon', 'Taos',
//       'Golf GTI', 'Golf R', 'Atlas Cross Sport', 'e-Golf'
//     ],
//     'Hyundai': [
//       'Elantra', 'Sonata', 'Tucson', 'Santa Fe', 'Palisade', 'Kona', 'Venue',
//       'Accent', 'Ioniq', 'Nexo', 'Veloster', 'Genesis'
//     ],
//     'Kia': [
//       'Forte', 'Optima/K5', 'Sportage', 'Sorento', 'Telluride', 'Soul', 'Seltos',
//       'Carnival', 'Niro', 'EV6', 'Stinger', 'Rio'
//     ],
//     'Volvo': [
//       'S60', 'S90', 'V60', 'V90', 'XC40', 'XC60', 'XC90', 'C40',
//       'Polestar 1', 'Polestar 2'
//     ],
//     'Lexus': [
//       'IS', 'ES', 'GS', 'LS', 'UX', 'NX', 'RX', 'GX', 'LX', 'RC',
//       'LC', 'RCF', 'LFA'
//     ],
//     'Tesla': [
//       'Model 3', 'Model Y', 'Model S', 'Model X', 'Cybertruck', 'Roadster'
//     ],
//     'Porsche': [
//       '911', 'Cayenne', 'Panamera', 'Macan', 'Taycan', '718 Cayman',
//       '718 Boxster', '918 Spyder'
//     ],
//     'Jaguar': [
//       'XE', 'XF', 'F-TYPE', 'E-PACE', 'F-PACE', 'I-PACE', 'XJ'
//     ],
//     'Land Rover': [
//       'Range Rover', 'Range Rover Sport', 'Range Rover Velar', 'Range Rover Evoque',
//       'Discovery', 'Discovery Sport', 'Defender'
//     ],
//     'Acura': [
//       'ILX', 'TLX', 'RDX', 'MDX', 'NSX', 'RSX', 'TSX', 'RLX'
//     ],
//     'Infiniti': [
//       'Q50', 'Q60', 'QX50', 'QX55', 'QX60', 'QX80'
//     ],
//     'Genesis': [
//       'G70', 'G80', 'G90', 'GV70', 'GV80', 'GV60'
//     ],
//     'Maserati': [
//       'Ghibli', 'Quattroporte', 'Levante', 'MC20', 'Grecale'
//     ],
//     'Alfa Romeo': [
//       'Giulia', 'Stelvio', '4C', 'Tonale'
//     ],
//     'Subaru': [
//       'Impreza', 'Legacy', 'Outback', 'Forester', 'Crosstrek', 'Ascent',
//       'WRX', 'BRZ'
//     ],
//     'Mazda': [
//       'Mazda3', 'Mazda6', 'CX-3', 'CX-30', 'CX-5', 'CX-9', 'MX-5 Miata',
//       'CX-50'
//     ]
//   };
//
//   // قائمة السنوات
//   final List<int> years = List.generate(30, (index) => 2024 - index);
//
//   // قائمة أنواع الخدمات
//   final List<String> serviceTypes = [
//     'Regular Maintenance',
//     'Oil Change',
//     'Full Inspection',
//     'Repair'
//   ];
//
//   // قائمة المواعيد المتاحة
//   final List<String> timeSlots = [
//     '9:00 AM', '10:00 AM', '11:00 AM',
//     '12:00 PM', '1:00 PM', '2:00 PM',
//     '3:00 PM', '4:00 PM', '5:00 PM'
//   ];
//
//   void handleInputChange(String field, dynamic value) {
//     setState(() {
//       formData[field] = value;
//     });
//   }
//
//   void nextStep() {
//     setState(() {
//       step++;
//       _scrollController.animateTo(
//         0,
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     });
//   }
//
//   void prevStep() {
//     setState(() {
//       step--;
//       _scrollController.animateTo(
//         0,
//         duration: Duration(milliseconds: 300),
//         curve: Curves.easeOut,
//       );
//     });
//   }
//
//   Widget renderStep() {
//     switch (step) {
//       case 1:
//         return Column(
//           children: [
//             Text('Select Car Brand', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             ConstrainedBox(
//               constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
//               child: SingleChildScrollView(
//                 child: GridView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 2,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                   ),
//                   itemCount: carBrands.length,
//                   itemBuilder: (context, index) {
//                     final brand = carBrands[index];
//                     return ElevatedButton(
//                       onPressed: () => handleInputChange('carBrand', brand),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: formData['carBrand'] == brand ? Colors.blue : Colors.white,
//                         foregroundColor: formData['carBrand'] == brand ? Colors.white : Colors.black,
//                       ),
//                       child: Text(brand),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         );
//
//       case 2:
//         final models = carModels[formData['carBrand']] ?? [];
//         return Column(
//           children: [
//             Text('Select Car Model', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             ConstrainedBox(
//               constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
//               child: SingleChildScrollView(
//                 child: GridView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 2,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                   ),
//                   itemCount: models.length,
//                   itemBuilder: (context, index) {
//                     final model = models[index];
//                     return ElevatedButton(
//                       onPressed: () => handleInputChange('carModel', model),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: formData['carModel'] == model ? Colors.blue : Colors.white,
//                         foregroundColor: formData['carModel'] == model ? Colors.white : Colors.black,
//                       ),
//                       child: Text(model),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         );
//
//       case 3:
//         return Column(
//           children: [
//             Text('Select Manufacturing Year', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             ConstrainedBox(
//               constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
//               child: SingleChildScrollView(
//                 child: GridView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 3,
//                     childAspectRatio: 1.5,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                   ),
//                   itemCount: years.length,
//                   itemBuilder: (context, index) {
//                     final year = years[index];
//                     return ElevatedButton(
//                       onPressed: () => handleInputChange('year', year),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: formData['year'] == year ? Colors.blue : Colors.white,
//                         foregroundColor: formData['year'] == year ? Colors.white : Colors.black,
//                       ),
//                       child: Text(year.toString()),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         );
//
//       case 4:
//         return Column(
//           children: [
//             Text('Select Service Type', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             ConstrainedBox(
//               constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
//               child: SingleChildScrollView(
//                 child: GridView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 2,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                   ),
//                   itemCount: serviceTypes.length,
//                   itemBuilder: (context, index) {
//                     final service = serviceTypes[index];
//                     return ElevatedButton(
//                       onPressed: () => handleInputChange('serviceType', service),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: formData['serviceType'] == service ? Colors.blue : Colors.white,
//                         foregroundColor: formData['serviceType'] == service ? Colors.white : Colors.black,
//                       ),
//                       child: Text(service),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         );
//
//       case 5:
//         return Column(
//           children: [
//             Text('Select Date', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             TableCalendar(
//               firstDay: DateTime.now(),
//               lastDay: DateTime.now().add(Duration(days: 365)),
//               focusedDay: formData['date'] ?? DateTime.now(),
//               selectedDayPredicate: (day) => isSameDay(formData['date'], day),
//               onDaySelected: (selectedDay, focusedDay) => handleInputChange('date', selectedDay),
//             ),
//           ],
//         );
//
//       case 6:
//         return Column(
//           children: [
//             Text('Select Available Time', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             ConstrainedBox(
//               constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
//               child: SingleChildScrollView(
//                 child: GridView.builder(
//                   shrinkWrap: true,
//                   physics: NeverScrollableScrollPhysics(),
//                   gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                     crossAxisCount: 2,
//                     childAspectRatio: 2,
//                     crossAxisSpacing: 10,
//                     mainAxisSpacing: 10,
//                   ),
//                   itemCount: timeSlots.length,
//                   itemBuilder: (context, index) {
//                     final time = timeSlots[index];
//                     return ElevatedButton(
//                       onPressed: () => handleInputChange('timeSlot', time),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: formData['timeSlot'] == time ? Colors.blue : Colors.white,
//                         foregroundColor: formData['timeSlot'] == time ? Colors.white : Colors.black,
//                       ),
//                       child: Text(time),
//                     );
//                   },
//                 ),
//               ),
//             ),
//           ],
//         );
//
//       case 7:
//         return Column(
//           children: [
//             Text('Additional Notes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//             SizedBox(height: 20),
//             TextField(
//               maxLines: 5,
//               decoration: InputDecoration(
//                 hintText: 'Describe any specific issues or requests...',
//                 border: OutlineInputBorder(),
//               ),
//               onChanged: (value) => handleInputChange('notes', value),
//             ),
//           ],
//         );
//
//       default:
//         return Container();
//     }
//   }
//
//
//   Future insertBooking(BuildContext context, String Brand, String Model,int Year,String Service,String Date,String Time,String Note )
//   async {
//
//     //   SharedPreferences prefs = await SharedPreferences.getInstance();
//     //  String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
//     var url = "bookings/insertBooking.php?Brand=" + Brand + "&Model=" + Model+ "&Year="+ "${Year}" + "&ServiceID="+Service +"&Date="+Date +"&Time="+Time+"&Note="+Note;
//     final response = await http.get(Uri.parse(serverPath + url));
//     print(serverPath + url);
//     setState(() { });
//     Navigator.pop(context);
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey[50],
//       body: SingleChildScrollView(
//         controller: _scrollController,
//         padding: EdgeInsets.all(16),
//         child: Card(
//           child: Padding(
//             padding: EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 // Progress Bar
//                 Column(
//                   children: [
//                     LinearProgressIndicator(
//                       value: step / 7,
//                       backgroundColor: Colors.grey[200],
//                       color: Colors.blue,
//                     ),
//                     SizedBox(height: 8),
//                     Text('Step $step of 7', style: TextStyle(color: Colors.grey)),
//                   ],
//                 ),
//
//                 SizedBox(height: 20),
//
//                 // Form Content
//                 renderStep(),
//
//                 SizedBox(height: 20),
//
//                 // Navigation Buttons
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     if (step > 1)
//                       ElevatedButton(
//                         onPressed: prevStep,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.white,
//                           foregroundColor: Colors.black,
//                           side: BorderSide(color: Colors.blue),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(Icons.chevron_left),
//                             Text('Previous'),
//                           ],
//                         ),
//                       ),
//                     if (step < 7)
//                       ElevatedButton(
//                         onPressed: nextStep,
//                         child: Row(
//                           children: [
//                             Text('Next'),
//                             Icon(Icons.chevron_right),
//                           ],
//                         ),
//                       )
//                     else
//                       ElevatedButton(
//                         onPressed: () => {
//                           print('Form submitted: $formData'),
//                           insertBooking(context,formData['carBrand'],formData['carModel'],formData['year'],formData['serviceType'],formData['date'].toString(),formData['timeSlot'],formData['notes']),
//                           },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.green,
//                           foregroundColor: Colors.white,
//                         ),
//                         child: Text('Confirm Booking'),
//                       ),
//                   ],
//                 ),
//
//                 // Summary
//                 if (step == 7)
//                   Container(
//                     margin: EdgeInsets.only(top: 20),
//                     padding: EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.grey[200],
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Booking Summary:', style: TextStyle(fontWeight: FontWeight.bold)),
//                         SizedBox(height: 8),
//                         Text('Vehicle: ${formData['carBrand']} ${formData['carModel']} (${formData['year']})'),
//                         Text('Service: ${formData['serviceType']}'),
//                         Text('Date: ${formData['date']?.toString()}'),
//                         Text('Time: ${formData['timeSlot']}'),
//                       ],
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   @override
//   void dispose(){
//
//   }
//   }











/*import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../Utills/ClientConfig.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int step = 1;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;

  // Updated formData to include IDs for database relationships
  Map<String, dynamic> formData = {
    'carBrand': '',
    'carBrand_id': 0,
    'carModel': '',
    'carModel_id': 0,
    'year': '',
    'serviceType': '',
    'serviceType_id': 0,
    'date': null,
    'timeSlot': '',
    'notes': ''
  };

  // Lists that will be populated from the server
  List<Map<String, dynamic>> carBrands = [];
  List<Map<String, dynamic>> carModels = [];
  List<Map<String, dynamic>> serviceTypes = [];

  // Time slots can stay hardcoded unless you want to make them dynamic too
  final List<String> timeSlots = [
    '9:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '1:00 PM', '2:00 PM',
    '3:00 PM', '4:00 PM', '5:00 PM'
  ];

  // Years list can stay as is
  final List<int> years = List.generate(30, (index) => 2024 - index);

  @override
  void initState() {
    super.initState();
    // Fetch data when screen loads
    _fetchCarBrands();
    _fetchServiceTypes();
  }

  // Fetch car brands from server
  Future<void> _fetchCarBrands() async {
    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(
          Uri.parse('https://darkgray-hummingbird-925566.hostingersite.com/yamen/test/getTest.php')
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {
            // Convert the data to the format we need
            carBrands = List<Map<String, dynamic>>.from(
                jsonData['data'].map((brand) => {
                  'id': brand['id'],
                  'name': brand['name'],
                })
            );
          });
        } else {
          print('Error: ${jsonData['message']}');
          _showErrorSnackBar('Failed to load car brands: ${jsonData['message']}');
        }
      } else {
        print('Failed to load brands: ${response.statusCode}');
        _showErrorSnackBar('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during brand fetch: $e');
      _showErrorSnackBar('Network error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch car models for selected brand
  Future<void> _fetchCarModels(int brandId) async {
    setState(() {
      isLoading = true;
      carModels = []; // Clear existing models
    });

    try {
      final response = await http.get(
          Uri.parse('https://darkgray-hummingbird-925566.hostingersite.com/yamen/test/getTest.php?brandId=$brandId')
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {
            // Convert the data to the format we need
            carModels = List<Map<String, dynamic>>.from(
                jsonData['data'].map((model) => {
                  'id': model['id'],
                  'name': model['name'],
                })
            );
          });
        } else {
          print('Error: ${jsonData['message']}');

          // If no models found, we can still proceed
          if (jsonData['message'] == 'No models found for this brand') {
            // This is acceptable - maybe a new brand with no models yet
            _showInfoSnackBar('No models found for this brand. You can still proceed.');
          } else {
            _showErrorSnackBar('Failed to load car models: ${jsonData['message']}');
          }
        }
      } else {
        print('Failed to load models: ${response.statusCode}');
        _showErrorSnackBar('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during models fetch: $e');
      _showErrorSnackBar('Network error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fetch service types
  Future<void> _fetchServiceTypes() async {
    setState(() {
      isLoading = true;
    });

    try {
      // final response = await http.get(
      //     Uri.parse('https://darkgray-hummingbird-925566.hostingersite.com/yamen/test/getTest.php')
      // );

      final response = await http.get(
          Uri.parse('https://darkgray-hummingbird-925566.hostingersite.com/yamen/brands/getBrands.php')
      );


      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          setState(() {
            // Convert the data to the format we need
            serviceTypes = List<Map<String, dynamic>>.from(
                jsonData['data'].map((type) => {
                  'id': type['id'],
                  'name': type['name'],
                })
            );
          });
        } else {
          print('Error: ${jsonData['message']}');
          _showErrorSnackBar('Failed to load service types: ${jsonData['message']}');
        }
      } else {
        print('Failed to load service types: ${response.statusCode}');
        _showErrorSnackBar('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during service types fetch: $e');
      _showErrorSnackBar('Network error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showInfoSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.blue,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  // Modified handleInputChange to handle IDs as well as display values
  void handleInputChange(String field, dynamic value, [int? id]) {
    setState(() {
      formData[field] = value;

      // If there's an ID parameter, store it too
      if (id != null) {
        formData['${field}_id'] = id;
      }

      // If changing car brand, fetch models for that brand
      if (field == 'carBrand' && id != null) {
        _fetchCarModels(id);

        // Reset car model when brand changes
        formData['carModel'] = '';
        formData['carModel_id'] = 0;
      }
    });
  }

  void nextStep() {
    // Validate current step before proceeding
    if (!_validateCurrentStep()) {
      return;
    }

    setState(() {
      step++;
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void prevStep() {
    setState(() {
      step--;
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  bool _validateCurrentStep() {
    switch (step) {
      case 1:
        if (formData['carBrand'].isEmpty) {
          _showErrorSnackBar('Please select a car brand');
          return false;
        }
        return true;
      case 2:
        if (formData['carModel'].isEmpty) {
          _showErrorSnackBar('Please select a car model');
          return false;
        }
        return true;
      case 3:
        if (formData['year'] == '') {
          _showErrorSnackBar('Please select a manufacturing year');
          return false;
        }
        return true;
      case 4:
        if (formData['serviceType'].isEmpty) {
          _showErrorSnackBar('Please select a service type');
          return false;
        }
        return true;
      case 5:
        if (formData['date'] == null) {
          _showErrorSnackBar('Please select a date');
          return false;
        }
        return true;
      case 6:
        if (formData['timeSlot'].isEmpty) {
          _showErrorSnackBar('Please select a time slot');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  // Submit booking to the server
  Future<void> insertBooking(BuildContext context) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Format the date correctly for the server (YYYY-MM-DD)
      String formattedDate = '';
      if (formData['date'] != null) {
        final date = formData['date'] as DateTime;
        formattedDate = '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
      }

      final url = Uri.parse(
          'https://darkgray-hummingbird-925566.hostingersite.com/yamen/insertBooking.php'
              '?Brand=${Uri.encodeComponent(formData['carBrand'])}'
              '&Model=${Uri.encodeComponent(formData['carModel'])}'
              '&Year=${formData['year']}'
              '&ServiceID=${formData['serviceType_id'] != 0 ? formData['serviceType_id'] : Uri.encodeComponent(formData['serviceType'])}'
              '&Date=${Uri.encodeComponent(formattedDate)}'
              '&Time=${Uri.encodeComponent(formData['timeSlot'])}'
              '&Note=${Uri.encodeComponent(formData['notes'] ?? '')}'
      );

      print('Submitting booking to: $url');
      final response = await http.get(url);
      print('Server response: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData['status'] == 'success') {
          _showSuccessSnackBar('Booking successful!');
          // Give user time to see success message before closing screen
          await Future.delayed(Duration(seconds: 1));
          Navigator.pop(context);
        } else {
          _showErrorSnackBar('Error: ${jsonData['message']}');
        }
      } else {
        _showErrorSnackBar('Server error: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception during booking submission: $e');
      _showErrorSnackBar('Network error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget renderStep() {
    // Show loading indicator when loading data
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading...')
          ],
        ),
      );
    }

    switch (step) {
      case 1:
        return Column(
          children: [
            Text('Select Car Brand', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            carBrands.isEmpty
                ? Center(child: Text('No car brands available. Please try again.'))
                : ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: carBrands.length,
                  itemBuilder: (context, index) {
                    final brand = carBrands[index];
                    return ElevatedButton(
                      onPressed: () => handleInputChange('carBrand', brand['name'], brand['id']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: formData['carBrand'] == brand['name'] ? Colors.blue : Colors.white,
                        foregroundColor: formData['carBrand'] == brand['name'] ? Colors.white : Colors.black,
                      ),
                      child: Text(brand['name']),
                    );
                  },
                ),
              ),
            ),
          ],
        );

      case 2:
        return Column(
          children: [
            Text('Select Car Model', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            carModels.isEmpty
                ? Center(
              child: Column(
                children: [
                  Text('No models found for ${formData['carBrand']}'),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Enter Model Manually',
                      border: OutlineInputBorder(),
                      hintText: 'Type your car model here',
                    ),
                    onChanged: (value) => handleInputChange('carModel', value),
                  ),
                ],
              ),
            )
                : ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: carModels.length,
                  itemBuilder: (context, index) {
                    final model = carModels[index];
                    return ElevatedButton(
                      onPressed: () => handleInputChange('carModel', model['name'], model['id']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: formData['carModel'] == model['name'] ? Colors.blue : Colors.white,
                        foregroundColor: formData['carModel'] == model['name'] ? Colors.white : Colors.black,
                      ),
                      child: Text(model['name']),
                    );
                  },
                ),
              ),
            ),
          ],
        );

      case 3:
        return Column(
          children: [
            Text('Select Manufacturing Year', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: years.length,
                  itemBuilder: (context, index) {
                    final year = years[index];
                    return ElevatedButton(
                      onPressed: () => handleInputChange('year', year),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: formData['year'] == year ? Colors.blue : Colors.white,
                        foregroundColor: formData['year'] == year ? Colors.white : Colors.black,
                      ),
                      child: Text(year.toString()),
                    );
                  },
                ),
              ),
            ),
          ],
        );

      case 4:
        return Column(
          children: [
            Text('Select Service Type', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            serviceTypes.isEmpty
                ? Center(child: Text('No service types available. Please try again.'))
                : ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: serviceTypes.length,
                  itemBuilder: (context, index) {
                    final service = serviceTypes[index];
                    return ElevatedButton(
                      onPressed: () => handleInputChange('serviceType', service['name'], service['id']),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: formData['serviceType'] == service['name'] ? Colors.blue : Colors.white,
                        foregroundColor: formData['serviceType'] == service['name'] ? Colors.white : Colors.black,
                      ),
                      child: Text(service['name']),
                    );
                  },
                ),
              ),
            ),
          ],
        );

      case 5:
        return Column(
          children: [
            Text('Select Date', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(Duration(days: 365)),
              focusedDay: formData['date'] ?? DateTime.now(),
              selectedDayPredicate: (day) => isSameDay(formData['date'], day),
              onDaySelected: (selectedDay, focusedDay) => handleInputChange('date', selectedDay),
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Colors.blue,
                  shape: BoxShape.circle,
                ),
              ),
              // Disable past dates
              enabledDayPredicate: (day) => !day.isBefore(DateTime.now().subtract(Duration(days: 1))),
            ),
          ],
        );

      case 6:
        return Column(
          children: [
            Text('Select Available Time', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: timeSlots.length,
                  itemBuilder: (context, index) {
                    final time = timeSlots[index];
                    return ElevatedButton(
                      onPressed: () => handleInputChange('timeSlot', time),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: formData['timeSlot'] == time ? Colors.blue : Colors.white,
                        foregroundColor: formData['timeSlot'] == time ? Colors.white : Colors.black,
                      ),
                      child: Text(time),
                    );
                  },
                ),
              ),
            ),
          ],
        );

      case 7:
        return Column(
          children: [
            Text('Additional Notes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Describe any specific issues or requests...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => handleInputChange('notes', value),
            ),
            SizedBox(height: 20),
            // Booking Summary
            Container(
              margin: EdgeInsets.only(top: 10),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Booking Summary:', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('Vehicle: ${formData['carBrand']} ${formData['carModel']} (${formData['year']})'),
                  Text('Service: ${formData['serviceType']}'),
                  Text('Date: ${_formatDate(formData['date'])}'),
                  Text('Time: ${formData['timeSlot']}'),
                  if (formData['notes']?.isNotEmpty ?? false)
                    Text('Notes: ${formData['notes']}'),
                ],
              ),
            ),
          ],
        );

      default:
        return Container();
    }
  }

  // Helper method to format date in a more readable way
  String _formatDate(DateTime? date) {
    if (date == null) return 'Not selected';
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Book a Service'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Progress Bar
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: step / 7,
                      backgroundColor: Colors.grey[200],
                      color: Colors.blue,
                    ),
                    SizedBox(height: 8),
                    Text('Step $step of 7', style: TextStyle(color: Colors.grey)),
                  ],
                ),

                SizedBox(height: 20),

                // Form Content
                renderStep(),

                SizedBox(height: 20),

                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (step > 1)
                      ElevatedButton(
                        onPressed: prevStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.blue),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.chevron_left),
                            Text('Previous'),
                          ],
                        ),
                      )
                    else
                      SizedBox(), // Empty space to maintain layout when no previous button

                    if (step < 7)
                      ElevatedButton(
                        onPressed: nextStep,
                        child: Row(
                          children: [
                            Text('Next'),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      )
                    else
                      ElevatedButton(
                        onPressed: () => insertBooking(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Confirm Booking'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}*/
/*
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:final_project/Views/HomePageScreen.dart';
import '../Utills/ClientConfig.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int step = 1;
  final ScrollController _scrollController = ScrollController();
  Map<String, dynamic> formData = {
    'carBrand': '',
    'carBrandId': '',
    'carModel': '',
    'carModelId': '',
    'year': '',
    'serviceType': '',
    'serviceTypeId': '',
    'date': null,
    'timeSlot': '',
    'notes': ''
  };

  // قوائم ستُملأ من قاعدة البيانات
  List<dynamic> carBrands = [];
  List<dynamic> carModels = [];
  List<dynamic> serviceTypes = [];

  // قائمة السنوات
  final List<int> years = List.generate(30, (index) => 2024 - index);

  // قائمة المواعيد المتاحة
  final List<String> timeSlots = [
    '9:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '1:00 PM', '2:00 PM',
    '3:00 PM', '4:00 PM', '5:00 PM'
  ];

  @override
  void initState() {
    super.initState();
    // جلب البيانات عند بدء الشاشة
    fetchCarBrands();
    fetchServiceTypes();
  }

  // دالة لجلب أنواع السيارات من قاعدة البيانات
  Future<void> fetchCarBrands() async {
    try {
      final response = await http.get(Uri.parse(serverPath + '/cars/getCarBrands.php'));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          carBrands = data;
        });
      } else {
        print('Error fetching car brands: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception when fetching car brands: $e');
    }
  }

  // دالة لجلب موديلات السيارات من قاعدة البيانات بناءً على نوع السيارة المختار
  Future<void> fetchCarModels(String brandId) async {
    try {
      var url = serverPath + '/cars/getcarModels.php?brandId=$brandId';
      print("url: " + url);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          carModels = data;
        });
      } else {
        print('Error fetching car models: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception when fetching car models: $e');
    }
  }

  // دالة لجلب أنواع الخدمات من قاعدة البيانات
  Future<void> fetchServiceTypes() async {
    try {
      var url = serverPath + '/bookings/getServiceTypes.php';
      print("url: " + url);
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          serviceTypes = data;
        });
      } else {
        print('Error fetching service types: ${response.statusCode}');
      }
    } catch (e) {
      print('Exception when fetching service types: $e');
    }
  }

  void handleInputChange(String field, dynamic value) {
    setState(() {
      formData[field] = value;

      // إذا تم تغيير نوع السيارة، نجلب الموديلات المناسبة
      if (field == 'carBrandId') {
        fetchCarModels(value);
        // إعادة ضبط الموديل المختار
        formData['carModel'] = '';
        formData['carModelId'] = '';
      }
    });
  }

  void nextStep() {
    setState(() {
      step++;
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void prevStep() {
    setState(() {
      step--;
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  Widget renderStep() {
    switch (step) {
      case 1:
        return Column(
          children: [
            Text('Select Car Brand', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            carBrands.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: carBrands.length,
                  itemBuilder: (context, index) {
                    final brand = carBrands[index];
                    return ElevatedButton(
                      onPressed: () {
                        handleInputChange('carBrand', brand['carBrandsName']);
                        handleInputChange('carBrandId', brand['carBrandsID']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: formData['carBrandId'] == brand['carBrandsID'] ? Colors.blue : Colors.white,
                        foregroundColor: formData['carBrandId'] == brand['carBrandsID'] ? Colors.white : Colors.black,
                      ),
                      child: Text(brand['carBrandsName']),
                    );
                  },
                ),
              ),
            ),
          ],
        );

      case 2:
        return Column(
          children: [
            Text('Select Car Model', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            carModels.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: carModels.length,
                  itemBuilder: (context, index) {
                    final model = carModels[index];
                    return ElevatedButton(
                      onPressed: () {
                        handleInputChange('carModel', model['carModelsName']);
                        handleInputChange('carModelId', model['carModelsID']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: formData['carModelId'] == model['carModelsID'] ? Colors.blue : Colors.white,
                        foregroundColor: formData['carModelId'] == model['carModelsID'] ? Colors.white : Colors.black,
                      ),
                      child: Text(model['carModelsName']),
                    );
                  },
                ),
              ),
            ),
          ],
        );

      case 3:
        return Column(
          children: [
            Text('Select Manufacturing Year', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 1.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: years.length,
                  itemBuilder: (context, index) {
                    final year = years[index];
                    return ElevatedButton(
                      onPressed: () => handleInputChange('year', year),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: formData['year'] == year ? Colors.blue : Colors.white,
                        foregroundColor: formData['year'] == year ? Colors.white : Colors.black,
                      ),
                      child: Text(year.toString()),
                    );
                  },
                ),
              ),
            ),
          ],
        );

      case 4:
        return Column(
          children: [
            Text('Select Service Type', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            serviceTypes.isEmpty
                ? Center(child: CircularProgressIndicator())
                : ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: serviceTypes.length,
                  itemBuilder: (context, index) {
                    final service = serviceTypes[index];
                    return ElevatedButton(
                      onPressed: () {
                        handleInputChange('serviceType', service['serviceTypeName']);
                        handleInputChange('serviceTypeId', service['serviceTypeID']);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: formData['serviceTypeId'] == service['serviceTypeID'] ? Colors.blue : Colors.white,
                        foregroundColor: formData['serviceTypeId'] == service['serviceTypeID'] ? Colors.white : Colors.black,
                      ),
                      child: Text(service['serviceTypeName']),
                    );
                  },
                ),
              ),
            ),
          ],
        );

      case 5:
        return Column(
          children: [
            Text('Select Date', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TableCalendar(
              firstDay: DateTime.now(),
              lastDay: DateTime.now().add(Duration(days: 365)),
              focusedDay: formData['date'] ?? DateTime.now(),
              selectedDayPredicate: (day) => isSameDay(formData['date'], day),
              onDaySelected: (selectedDay, focusedDay) => handleInputChange('date', selectedDay),
            ),
          ],
        );

      case 6:
        return Column(
          children: [
            Text('Select Available Time', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
              child: SingleChildScrollView(
                child: GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: timeSlots.length,
                  itemBuilder: (context, index) {
                    final time = timeSlots[index];
                    return ElevatedButton(
                      onPressed: () => handleInputChange('timeSlot', time),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: formData['timeSlot'] == time ? Colors.blue : Colors.white,
                        foregroundColor: formData['timeSlot'] == time ? Colors.white : Colors.black,
                      ),
                      child: Text(time),
                    );
                  },
                ),
              ),
            ),
          ],
        );

      case 7:
        return Column(
          children: [
            Text('Additional Note', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 20),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Describe any specific issues or requests...',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) => handleInputChange('Note', value),
            ),
          ],
        );

      default:
        return Container();
    }
  }

  Future insertBooking(BuildContext context, String carBrandID, String carModelId,String year, String serviceTypeID,String date,String time,String Note) async {
    print("my link:" + serverPath);
    //   SharedPreferences prefs = await SharedPreferences.getInstance();
    //  String? getInfoDeviceSTR = prefs.getString("getInfoDeviceSTR");
    var url = "users/insertBooking.php?carBrandID=" + carBrandID + "&carModelId=" + carModelId +"&year=" + year +"&serviceTypeID=" + serviceTypeID + "&date=" + date + "&time=" + time + "&Note=" + Note ;
    final response = await http.get(Uri.parse(serverPath + url));
    print("my link:" + serverPath + url);
    // setState(() { });
    // Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Progress Bar
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: step / 7,
                      backgroundColor: Colors.grey[200],
                      color: Colors.blue,
                    ),
                    SizedBox(height: 8),
                    Text('Step $step of 7', style: TextStyle(color: Colors.grey)),
                  ],
                ),

                SizedBox(height: 20),

                // Form Content
                renderStep(),

                SizedBox(height: 20),

                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (step > 1)
                      ElevatedButton(
                        onPressed: prevStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.blue),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.chevron_left),
                            Text('Previous'),
                          ],
                        ),
                      ),
                    if (step < 7)
                      ElevatedButton(
                        onPressed: nextStep,
                        child: Row(
                          children: [
                            Text('Next'),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      )
                    else
                      ElevatedButton(
                        onPressed: () => {
                          print('Form submitted: $formData'),
                          insertBooking(context,formData['carBrandID'],formData['carModelId'],formData['year'],formData['year'],formData['date'],formData['time'],formData['Note']),
                          //Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()))
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: Text('Confirm Booking'),
                      ),

                  ],
                ),

                // Summary
                if (step == 7)
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Booking Summary:', style: TextStyle(fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('Vehicle: ${formData['carBrand']} ${formData['carModel']} (${formData['year']})'),
                        Text('Service: ${formData['serviceType']}'),
                        Text('Date: ${formData['date']?.toString().split(' ')[0]}'),
                        Text('Time: ${formData['timeSlot']}'),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}*/
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import '../Utills/ClientConfig.dart';
import 'HomePageScreen.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int step = 1;
  final ScrollController _scrollController = ScrollController();
  bool isLoading = false;
  String? errorMessage;
  String? userID;

  Map<String, dynamic> formData = {
    'carBrand': '',
    'carBrandId': '',
    'carModel': '',
    'carModelId': '',
    'year': '',
    'serviceType': '',
    'serviceTypeId': '',
    'date': null,
    'timeSlot': '',
    'notes': ''
  };

  // Lists that will be populated from the server
  List<dynamic> carBrands = [];
  List<dynamic> carModels = [];
  List<dynamic> serviceTypes = [];

  // Years list
  final List<int> years = List.generate(30, (index) => 2024 - index);

  // Time slots
  final List<String> timeSlots = [
    '9:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '1:00 PM', '2:00 PM',
    '3:00 PM', '4:00 PM', '5:00 PM'
  ];

  @override
  void initState() {
    super.initState();
    _getUserID();
    _fetchData();
  }

  Future<void> _getUserID() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        userID = prefs.getString('token');
      });
    } catch (e) {
      print('Error getting user ID: $e');
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      // Fetch car brands
      await fetchCarBrands();

      // Fetch service types
      await fetchServiceTypes();
    } catch (e) {
      setState(() {
        errorMessage = 'Error loading data: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Function for fetching car brands
  Future<void> fetchCarBrands() async {
    try {
      final response = await http.get(Uri.parse(serverPath + 'cars/getCarBrands.php'));

      if (response.statusCode == 200) {
        setState(() {
          carBrands = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load car brands: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching car brands: $e');
      rethrow;
    }
  }

  // Function for fetching car models
  Future<void> fetchCarModels(String brandId) async {
    setState(() {
      isLoading = true;
      carModels = [];
    });

    try {
      var url = serverPath + 'cars/getCarModels.php?brandId=$brandId';
      print("Loading car models from: $url");

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          carModels = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          errorMessage = 'Failed to load car models: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching car models: $e';
      });
    }
  }

  // Function for fetching service types
  Future<void> fetchServiceTypes() async {
    try {
      var url = serverPath + 'bookings/getServiceTypes.php';
      print("Loading service types from: $url");

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        setState(() {
          serviceTypes = json.decode(response.body);
        });
      } else {
        throw Exception('Failed to load service types: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching service types: $e');
      rethrow;
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void handleInputChange(String field, dynamic value) {
    setState(() {
      formData[field] = value;

      // If changing car brand, fetch models for that brand
      if (field == 'carBrandId') {
        fetchCarModels(value);
        // Reset car model selection
        formData['carModel'] = '';
        formData['carModelId'] = '';
      }
    });
  }

  void nextStep() {
    if (!_validateCurrentStep()) {
      return;
    }

    setState(() {
      step++;
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void prevStep() {
    setState(() {
      step--;
      _scrollController.animateTo(
        0,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  bool _validateCurrentStep() {
    switch (step) {
      case 1:
        if (formData['carBrandId'] == '') {
          _showErrorSnackBar('Please select a car brand');
          return false;
        }
        return true;
      case 2:
        if (formData['carModelId'] == '') {
          _showErrorSnackBar('Please select a car model');
          return false;
        }
        return true;
      case 3:
        if (formData['year'] == '') {
          _showErrorSnackBar('Please select a manufacturing year');
          return false;
        }
        return true;
      case 4:
        if (formData['serviceTypeId'] == '') {
          _showErrorSnackBar('Please select a service type');
          return false;
        }
        return true;
      case 5:
        if (formData['date'] == null) {
          _showErrorSnackBar('Please select a date');
          return false;
        }
        return true;
      case 6:
        if (formData['timeSlot'] == '') {
          _showErrorSnackBar('Please select a time slot');
          return false;
        }
        return true;
      default:
        return true;
    }
  }

  Future<void> _submitBooking() async {
    if (userID == null) {
      _showErrorSnackBar('User not logged in. Please log in again.');
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Format the date for API
      String formattedDate = '';
      if (formData['date'] != null) {
        formattedDate = DateFormat('yyyy-MM-dd').format(formData['date']);
      }

      print("Submitting booking with data:");
      print("userID: $userID");
      print("carBrandId: ${formData['carBrandId']}");
      print("carModelId: ${formData['carModelId']}");
      print("year: ${formData['year']}");
      print("serviceTypeId: ${formData['serviceTypeId']}");
      print("date: $formattedDate");
      print("time: ${formData['timeSlot']}");
      print("notes: ${formData['notes']}");


      final url = Uri.parse('${serverPath}booking/insertBooking.php?userID=$userID&carBrandID=${formData['carBrandId']}&carModelId=${formData['carModelId']}&year=${formData['year']}&serviceTypeID=${formData['serviceTypeId']}&date=$formattedDate&time=${formData['timeSlot']}&Note=${formData['notes'] ?? ''}');

      print("Submitting to URL: ${url.toString()}");

      final response = await http.get(url);

      print("Response: ${response.body}");

      if (response.statusCode == 200) {
        var result = json.decode(response.body);



        if (result['result'] == '1') {
          _showSuccessSnackBar('Booking created successfully!');

          // Navigate to home after a short delay
          Future.delayed(Duration(seconds: 1), () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HomePage())
            );
          });
        } else {
          _showErrorSnackBar('Failed to create booking: ${result['message'] ?? "Unknown error"}');
        }
      } else {
        _showErrorSnackBar('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackBar('Error: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget renderStep() {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text('Loading...')
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 48),
            SizedBox(height: 16),
            Text(errorMessage!, style: TextStyle(color: Colors.red)),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: _fetchData,
              child: Text('Try Again'),
            )
          ],
        ),
      );
    }

    switch (step) {
    case 1:
    return Column(
    children: [
    Text('Select Car Brand', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    SizedBox(height: 20),
    carBrands.isEmpty
    ? Center(child: Text('No car brands available. Please try again.'))
        : ConstrainedBox(
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
    child: SingleChildScrollView(
    child: GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    ),
    itemCount: carBrands.length,
    itemBuilder: (context, index) {
    final brand = carBrands[index];
    return ElevatedButton(
    onPressed: () {
    handleInputChange('carBrand', brand['carBrandsName']);
    handleInputChange('carBrandId', brand['carBrandsID']);
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: formData['carBrandId'] == brand['carBrandsID'] ? Colors.blue : Colors.white,
    foregroundColor: formData['carBrandId'] == brand['carBrandsID'] ? Colors.white : Colors.black,
    ),
    child: Text(brand['carBrandsName']),
    );
    },
    ),
    ),
    ),
    ],
    );

    case 2:
    return Column(
    children: [
    Text('Select Car Model', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    SizedBox(height: 20),
    carModels.isEmpty
    ? Center(
    child: Column(
    children: [
    Text('No models found for ${formData['carBrand']}'),
    SizedBox(height: 20),
    TextField(
    decoration: InputDecoration(
    labelText: 'Enter Model Manually',
    border: OutlineInputBorder(),
    hintText: 'Type your car model here',
    ),
    onChanged: (value) {
    handleInputChange('carModel', value);
    // Use a placeholder ID for custom models
    handleInputChange('carModelId', '0');
    },
    ),
    ],
    ),
    )
        : ConstrainedBox(
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
    child: SingleChildScrollView(
    child: GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    ),
    itemCount: carModels.length,
    itemBuilder: (context, index) {
    final model = carModels[index];
    return ElevatedButton(
    onPressed: () {
    handleInputChange('carModel', model['carModelsName']);
    handleInputChange('carModelId', model['carModelsID']);
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: formData['carModelId'] == model['carModelsID'] ? Colors.blue : Colors.white,
    foregroundColor: formData['carModelId'] == model['carModelsID'] ? Colors.white : Colors.black,
    ),
    child: Text(model['carModelsName']),
    );
    },
    ),
    ),
    ),
    ],
    );

    case 3:
    return Column(
    children: [
    Text('Select Manufacturing Year', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    SizedBox(height: 20),
    ConstrainedBox(
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
    child: SingleChildScrollView(
    child: GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    childAspectRatio: 1.5,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    ),
    itemCount: years.length,
    itemBuilder: (context, index) {
    final year = years[index];
    return ElevatedButton(
    onPressed: () => handleInputChange('year', year),
    style: ElevatedButton.styleFrom(
    backgroundColor: formData['year'] == year ? Colors.blue : Colors.white,
    foregroundColor: formData['year'] == year ? Colors.white : Colors.black,
    ),
    child: Text(year.toString()),
    );
    },
    ),
    ),
    ),
    ],
    );

    case 4:
    return Column(
    children: [
    Text('Select Service Type', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    SizedBox(height: 20),
    serviceTypes.isEmpty
    ? Center(child: Text('No service types available. Please try again.'))
        : ConstrainedBox(
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
    child: SingleChildScrollView(
    child: GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    ),
    itemCount: serviceTypes.length,
    itemBuilder: (context, index) {
    final service = serviceTypes[index];
    return ElevatedButton(
    onPressed: () {
    handleInputChange('serviceType', service['serviceTypeName']);
    handleInputChange('serviceTypeId', service['serviceTypeID']);
    },
    style: ElevatedButton.styleFrom(
    backgroundColor: formData['serviceTypeId'] == service['serviceTypeID'] ? Colors.blue : Colors.white,
    foregroundColor: formData['serviceTypeId'] == service['serviceTypeID'] ? Colors.white : Colors.black,
    ),
    child: Text(service['serviceTypeName']),
    );
    },
    ),
    ),
    ),
    ],
    );

    case 5:
    return Column(
    children: [
    Text('Select Date', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    SizedBox(height: 20),
    TableCalendar(
    firstDay: DateTime.now(),
    lastDay: DateTime.now().add(Duration(days: 365)),
    focusedDay: formData['date'] ?? DateTime.now(),
    selectedDayPredicate: (day) => isSameDay(formData['date'], day),
    onDaySelected: (selectedDay, focusedDay) => handleInputChange('date', selectedDay),
    calendarStyle: CalendarStyle(
    todayDecoration: BoxDecoration(
    color: Colors.blue.withOpacity(0.3),
    shape: BoxShape.circle,
    ),
    selectedDecoration: BoxDecoration(
    color: Colors.blue,
    shape: BoxShape.circle,
    ),
    ),
    // Disable past dates
    enabledDayPredicate: (day) => !day.isBefore(DateTime.now().subtract(Duration(days: 1))),
    ),
    ],
    );

    case 6:
    return Column(
    children: [
    Text('Select Available Time', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    SizedBox(height: 20),
    ConstrainedBox(
    constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
    child: SingleChildScrollView(
    child: GridView.builder(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    childAspectRatio: 2,
    crossAxisSpacing: 10,
    mainAxisSpacing: 10,
    ),
    itemCount: timeSlots.length,
    itemBuilder: (context, index) {
    final time = timeSlots[index];
    return ElevatedButton(
    onPressed: () => handleInputChange('timeSlot', time),
    style: ElevatedButton.styleFrom(
    backgroundColor: formData['timeSlot'] == time ? Colors.blue : Colors.white,
    foregroundColor: formData['timeSlot'] == time ? Colors.white : Colors.black,
    ),
    child: Text(time),
    );
    },
    ),
    ),
    ),
    ],
    );

    case 7:
    return Column(
    children: [
    Text('Additional Notes', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
    SizedBox(height: 20),
    TextField(
    maxLines: 5,
    decoration: InputDecoration(
    hintText: 'Describe any specific issues or requests...',
    border: OutlineInputBorder(),
    ),
    onChanged: (value) => handleInputChange('notes', value),
    ),
    SizedBox(height: 20),
    // Booking Summary
    Container(margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Booking Summary:', style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text('Vehicle: ${formData['carBrand']} ${formData['carModel']} (${formData['year']})'),
          Text('Service: ${formData['serviceType']}'),
          Text('Date: ${_formatDate(formData['date'])}'),
          Text('Time: ${formData['timeSlot']}'),
          if (formData['notes']?.isNotEmpty ?? false)
            Text('Notes: ${formData['notes']}'),
        ],
      ),
    ),
    ],
    );

      default:
        return Container();
    }
  }

  // Helper method to format date in a more readable way
  String _formatDate(DateTime? date) {
    if (date == null) return 'Not selected';
    return DateFormat('EEE, MMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text('Book a Service'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding: EdgeInsets.all(16),
        child: Card(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Progress Bar
                Column(
                  children: [
                    LinearProgressIndicator(
                      value: step / 7,
                      backgroundColor: Colors.grey[200],
                      color: Colors.blue,
                    ),
                    SizedBox(height: 8),
                    Text('Step $step of 7', style: TextStyle(color: Colors.grey)),
                  ],
                ),

                SizedBox(height: 20),

                // Form Content
                renderStep(),

                SizedBox(height: 20),

                // Navigation Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (step > 1)
                      ElevatedButton(
                        onPressed: prevStep,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          side: BorderSide(color: Colors.blue),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.chevron_left),
                            Text('Previous'),
                          ],
                        ),
                      )
                    else
                      SizedBox(width: 40), // Empty space to maintain layout

                    if (step < 7)
                      ElevatedButton(
                        onPressed: nextStep,
                        child: Row(
                          children: [
                            Text('Next'),
                            Icon(Icons.chevron_right),
                          ],
                        ),
                      )
                    else
                      ElevatedButton(
                        onPressed: isLoading ? null : _submitBooking,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                        child: isLoading
                            ? SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                            : Text('Confirm Booking'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}