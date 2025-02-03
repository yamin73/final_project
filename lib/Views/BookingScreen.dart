import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class BookingScreen extends StatefulWidget {
  @override
  _BookingScreenState createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  int step = 1;
  final ScrollController _scrollController = ScrollController();
  Map<String, dynamic> formData = {
    'carBrand': '',
    'carModel': '',
    'year': '',
    'serviceType': '',
    'date': null,
    'timeSlot': '',
    'notes': ''
  };

  // قائمة بجميع أنواع السيارات
  final List<String> carBrands = [
    'Toyota', 'Honda', 'Nissan', 'Mercedes', 'BMW', 'Audi', 'Ford', 'Chevrolet',
    'Volkswagen', 'Hyundai', 'Kia', 'Volvo', 'Mazda', 'Subaru', 'Lexus', 'Tesla',
    'Porsche', 'Jaguar', 'Land Rover', 'Fiat', 'Renault', 'Peugeot', 'Citroen',
    'Suzuki', 'Mitsubishi', 'Infiniti', 'Acura', 'Buick', 'Cadillac', 'Chrysler',
    'Dodge', 'Jeep', 'Ram', 'Alfa Romeo', 'Aston Martin', 'Bentley', 'Ferrari',
    'Lamborghini', 'Maserati', 'McLaren', 'Rolls-Royce', 'Bugatti', 'Lotus',
    'Mini', 'Smart', 'Genesis', 'SsangYong', 'Tata', 'Mahindra', 'Geely', 'BYD'
  ];

  // قائمة بجميع موديلات السيارات
  final Map<String, List<String>> carModels = {
    'Toyota': [
      'Camry', 'Corolla', 'Land Cruiser', 'RAV4', 'Prius', 'Highlander', 'Tacoma',
      'Tundra', '4Runner', 'Sienna', 'Avalon', 'C-HR', 'Venza', 'Sequoia', 'GR Supra'
    ],
    'Honda': [
      'Civic', 'Accord', 'CR-V', 'Pilot', 'Odyssey', 'HR-V', 'Ridgeline',
      'Passport', 'Insight', 'Fit', 'Element', 'CR-Z'
    ],
    'Nissan': [
      'Altima', 'Maxima', 'Patrol', 'Sentra', 'Rogue', 'Murano', 'Pathfinder',
      'Frontier', 'Titan', 'Kicks', 'Armada', 'GT-R', '370Z', 'Leaf'
    ],
    'Mercedes': [
      'A-Class', 'C-Class', 'E-Class', 'S-Class', 'GLA', 'GLB', 'GLC', 'GLE',
      'GLS', 'AMG GT', 'CLA', 'CLS', 'G-Class', 'EQS', 'EQE'
    ],
    'BMW': [
      '1 Series', '2 Series', '3 Series', '4 Series', '5 Series', '6 Series',
      '7 Series', '8 Series', 'X1', 'X2', 'X3', 'X4', 'X5', 'X6', 'X7', 'i3', 'i4', 'i8'
    ],
    'Audi': [
      'A3', 'A4', 'A5', 'A6', 'A7', 'A8', 'Q3', 'Q5', 'Q7', 'Q8', 'TT',
      'R8', 'e-tron', 'RS6', 'RS7', 'S3', 'S4', 'S5'
    ],
    'Ford': [
      'F-150', 'Mustang', 'Explorer', 'Escape', 'Edge', 'Expedition', 'Ranger',
      'Bronco', 'Bronco Sport', 'Maverick', 'Mach-E', 'Transit', 'EcoSport'
    ],
    'Chevrolet': [
      'Silverado', 'Tahoe', 'Suburban', 'Equinox', 'Traverse', 'Malibu', 'Camaro',
      'Corvette', 'Blazer', 'Trax', 'Colorado', 'Spark', 'Bolt EV'
    ],
    'Volkswagen': [
      'Golf', 'Jetta', 'Passat', 'Tiguan', 'Atlas', 'ID.4', 'Arteon', 'Taos',
      'Golf GTI', 'Golf R', 'Atlas Cross Sport', 'e-Golf'
    ],
    'Hyundai': [
      'Elantra', 'Sonata', 'Tucson', 'Santa Fe', 'Palisade', 'Kona', 'Venue',
      'Accent', 'Ioniq', 'Nexo', 'Veloster', 'Genesis'
    ],
    'Kia': [
      'Forte', 'Optima/K5', 'Sportage', 'Sorento', 'Telluride', 'Soul', 'Seltos',
      'Carnival', 'Niro', 'EV6', 'Stinger', 'Rio'
    ],
    'Volvo': [
      'S60', 'S90', 'V60', 'V90', 'XC40', 'XC60', 'XC90', 'C40',
      'Polestar 1', 'Polestar 2'
    ],
    'Lexus': [
      'IS', 'ES', 'GS', 'LS', 'UX', 'NX', 'RX', 'GX', 'LX', 'RC',
      'LC', 'RCF', 'LFA'
    ],
    'Tesla': [
      'Model 3', 'Model Y', 'Model S', 'Model X', 'Cybertruck', 'Roadster'
    ],
    'Porsche': [
      '911', 'Cayenne', 'Panamera', 'Macan', 'Taycan', '718 Cayman',
      '718 Boxster', '918 Spyder'
    ],
    'Jaguar': [
      'XE', 'XF', 'F-TYPE', 'E-PACE', 'F-PACE', 'I-PACE', 'XJ'
    ],
    'Land Rover': [
      'Range Rover', 'Range Rover Sport', 'Range Rover Velar', 'Range Rover Evoque',
      'Discovery', 'Discovery Sport', 'Defender'
    ],
    'Acura': [
      'ILX', 'TLX', 'RDX', 'MDX', 'NSX', 'RSX', 'TSX', 'RLX'
    ],
    'Infiniti': [
      'Q50', 'Q60', 'QX50', 'QX55', 'QX60', 'QX80'
    ],
    'Genesis': [
      'G70', 'G80', 'G90', 'GV70', 'GV80', 'GV60'
    ],
    'Maserati': [
      'Ghibli', 'Quattroporte', 'Levante', 'MC20', 'Grecale'
    ],
    'Alfa Romeo': [
      'Giulia', 'Stelvio', '4C', 'Tonale'
    ],
    'Subaru': [
      'Impreza', 'Legacy', 'Outback', 'Forester', 'Crosstrek', 'Ascent',
      'WRX', 'BRZ'
    ],
    'Mazda': [
      'Mazda3', 'Mazda6', 'CX-3', 'CX-30', 'CX-5', 'CX-9', 'MX-5 Miata',
      'CX-50'
    ]
  };

  // قائمة السنوات
  final List<int> years = List.generate(30, (index) => 2024 - index);

  // قائمة أنواع الخدمات
  final List<String> serviceTypes = [
    'Regular Maintenance',
    'Oil Change',
    'Full Inspection',
    'Repair'
  ];

  // قائمة المواعيد المتاحة
  final List<String> timeSlots = [
    '9:00 AM', '10:00 AM', '11:00 AM',
    '12:00 PM', '1:00 PM', '2:00 PM',
    '3:00 PM', '4:00 PM', '5:00 PM'
  ];

  void handleInputChange(String field, dynamic value) {
    setState(() {
      formData[field] = value;
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
                  itemCount: carBrands.length,
                  itemBuilder: (context, index) {
                    final brand = carBrands[index];
                    return ElevatedButton(
                      onPressed: () => handleInputChange('carBrand', brand),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: formData['carBrand'] == brand ? Colors.blue : Colors.white,
                        foregroundColor: formData['carBrand'] == brand ? Colors.white : Colors.black,
                      ),
                      child: Text(brand),
                    );
                  },
                ),
              ),
            ),
          ],
        );

      case 2:
        final models = carModels[formData['carBrand']] ?? [];
        return Column(
          children: [
            Text('Select Car Model', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
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
                  itemCount: models.length,
                  itemBuilder: (context, index) {
                    final model = models[index];
                    return ElevatedButton(
                      onPressed: () => handleInputChange('carModel', model),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: formData['carModel'] == model ? Colors.blue : Colors.white,
                        foregroundColor: formData['carModel'] == model ? Colors.white : Colors.black,
                      ),
                      child: Text(model),
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
                  itemCount: serviceTypes.length,
                  itemBuilder: (context, index) {
                    final service = serviceTypes[index];
                    return ElevatedButton(
                      onPressed: () => handleInputChange('serviceType', service),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: formData['serviceType'] == service ? Colors.blue : Colors.white,
                        foregroundColor: formData['serviceType'] == service ? Colors.white : Colors.black,
                      ),
                      child: Text(service),
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
          ],
        );

      default:
        return Container();
    }
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
                        onPressed: () => print('Form submitted: $formData'),
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
                        Text('Date: ${formData['date']?.toString()}'),
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
  void dispose(){

  }
  }