import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/car_visit.dart';
import '../services/database_service.dart';
import '../widgets/search_bar.dart';

class CarsHistoryPage extends StatefulWidget {
  const CarsHistoryPage({Key? key}) : super(key: key);

  @override
  _CarsHistoryPageState createState() => _CarsHistoryPageState();
}

class _CarsHistoryPageState extends State<CarsHistoryPage> {
  final DatabaseService _databaseService = DatabaseService();
  List<CarVisit> _allCarVisits = [];
  List<CarVisit> _filteredCarVisits = [];
  bool _isLoading = true;
  String _searchQuery = '';

  final List<String> _filterOptions = ['الكل', 'اليوم', 'هذا الأسبوع', 'هذا الشهر'];
  String _selectedFilter = 'الكل';

  @override
  void initState() {
    super.initState();
    _loadCarVisits();
  }

  Future<void> _loadCarVisits() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final carVisits = await _databaseService.getAllCarVisits();
      setState(() {
        _allCarVisits = carVisits;
        _filterCarVisits();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('حدث خطأ أثناء تحميل سجل السيارات');
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _filterCarVisits() {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day);
    final DateTime startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final DateTime startOfMonth = DateTime(now.year, now.month, 1);

    setState(() {
      // أولاً، تطبيق فلتر البحث
      var searchFiltered = _allCarVisits.where((visit) {
        final String searchString = '${visit.carMake} ${visit.carModel} ${visit.carPlate} ${visit.customerName}'
            .toLowerCase();
        return _searchQuery.isEmpty || searchString.contains(_searchQuery.toLowerCase());
      }).toList();

      // ثم تطبيق فلتر التاريخ
      switch (_selectedFilter) {
        case 'اليوم':
          _filteredCarVisits = searchFiltered.where((visit) =>
              visit.visitDate.isAfter(today.subtract(const Duration(seconds: 1)))).toList();
          break;
        case 'هذا الأسبوع':
          _filteredCarVisits = searchFiltered.where((visit) =>
              visit.visitDate.isAfter(startOfWeek.subtract(const Duration(seconds: 1)))).toList();
          break;
        case 'هذا الشهر':
          _filteredCarVisits = searchFiltered.where((visit) =>
              visit.visitDate.isAfter(startOfMonth.subtract(const Duration(seconds: 1)))).toList();
          break;
        case 'الكل':
        default:
          _filteredCarVisits = searchFiltered;
      }

      // ترتيب النتائج حسب التاريخ (الأحدث أولاً)
      _filteredCarVisits.sort((a, b) => b.visitDate.compareTo(a.visitDate));
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _filterCarVisits();
  }

  void _onFilterChanged(String? filter) {
    if (filter != null && filter != _selectedFilter) {
      setState(() {
        _selectedFilter = filter;
      });
      _filterCarVisits();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('سجل دخول السيارات', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCarVisits,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  flex: 3,
                  child: CustomSearchBar(
                    hintText: 'البحث عن سيارة أو لوحة أو عميل...',
                    onChanged: _onSearchChanged,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 2,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedFilter,
                        isExpanded: true,
                        icon: const Icon(Icons.filter_list),
                        items: _filterOptions.map((String option) {
                          return DropdownMenuItem<String>(
                            value: option,
                            child: Text(option),
                          );
                        }).toList(),
                        onChanged: _onFilterChanged,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCarVisits.isEmpty
                ? _buildEmptyState()
                : _buildCarVisitsList(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'إجمالي عدد الزيارات: ${_filteredCarVisits.length}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.directions_car_off,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty || _selectedFilter != 'الكل'
                ? 'لا توجد نتائج تطابق معايير البحث'
                : 'لا توجد سجلات لزيارات السيارات',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isNotEmpty || _selectedFilter != 'الكل') ...[
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة ضبط الفلاتر'),
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                  _selectedFilter = 'الكل';
                });
                _filterCarVisits();
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCarVisitsList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _filteredCarVisits.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final carVisit = _filteredCarVisits[index];
        return CarVisitCard(carVisit: carVisit);
      },
    );
  }
}

class CarVisitCard extends StatelessWidget {
  final CarVisit carVisit;

  const CarVisitCard({Key? key, required this.carVisit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${carVisit.carMake} ${carVisit.carModel}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          carVisit.carPlate,
                          style: TextStyle(
                            color: Colors.grey[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      DateFormat('dd/MM/yyyy', 'ar').format(carVisit.visitDate),
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormat('hh:mm a', 'ar').format(carVisit.visitDate),
                      style: const TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(Icons.person, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  carVisit.customerName,
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(Icons.build, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    carVisit.serviceDescription,
                    style: const TextStyle(fontSize: 16),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildServiceStatusChip(carVisit.serviceStatus),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.blue),
                      onPressed: () {
                        // فتح تفاصيل الزيارة
                        _showVisitDetails(context, carVisit);
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.orange),
                      onPressed: () {
                        // تعديل الزيارة
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceStatusChip(String status) {
    Color backgroundColor;
    Color textColor = Colors.white;

    switch (status.toLowerCase()) {
      case 'مكتمل':
        backgroundColor = Colors.green;
        break;
      case 'قيد التنفيذ':
        backgroundColor = Colors.blue;
        break;
      case 'معلق':
        backgroundColor = Colors.orange;
        break;
      case 'ملغي':
        backgroundColor = Colors.red;
        break;
      default:
        backgroundColor = Colors.grey;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  void _showVisitDetails(BuildContext context, CarVisit carVisit) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.6,
        minChildSize: 0.4,
        maxChildSize: 0.9,
        expand: false,
        builder: (_, scrollController) => SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'تفاصيل الزيارة',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                const Divider(),
                _buildDetailItem('السيارة', '${carVisit.carMake} ${carVisit.carModel}'),
                _buildDetailItem('رقم اللوحة', carVisit.carPlate),
                _buildDetailItem('العميل', carVisit.customerName),
                _buildDetailItem('رقم الهاتف', carVisit.customerPhone),
                _buildDetailItem('تاريخ الزيارة', DateFormat('dd/MM/yyyy', 'ar').format(carVisit.visitDate)),
                _buildDetailItem('وقت الزيارة', DateFormat('hh:mm a', 'ar').format(carVisit.visitDate)),
                _buildDetailItem('حالة الخدمة', carVisit.serviceStatus),
                _buildDetailItem('الكيلومتراج', '${carVisit.mileage} كم'),
                _buildDetailItem('الخدمات المقدمة', carVisit.serviceDescription),
                if (carVisit.additionalNotes.isNotEmpty)
                  _buildDetailItem('ملاحظات إضافية', carVisit.additionalNotes),
                if (carVisit.cost > 0)
                  _buildDetailItem('التكلفة', '${carVisit.cost} ريال'),

                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                      icon: const Icon(Icons.print),
                      label: const Text('طباعة الفاتورة'),
                      onPressed: () {
                        // طباعة الفاتورة
                      },
                    ),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.edit),
                      label: const Text('تعديل'),
                      onPressed: () {
                        Navigator.pop(context);
                        // تعديل الزيارة
                      },
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

  Widget _buildDetailItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}