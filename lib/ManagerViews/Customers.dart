import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/customer.dart';
import '../models/car_visit.dart';
import '../services/database_service.dart';
import '../widgets/search_bar.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({Key? key}) : super(key: key);

  @override
  _CustomersPageState createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  final DatabaseService _databaseService = DatabaseService();
  List<Customer> _allCustomers = [];
  List<Customer> _filteredCustomers = [];
  bool _isLoading = true;
  String _searchQuery = '';
  String _sortBy = 'name'; // 'name', 'lastVisit', 'visitsCount'
  bool _sortAscending = true;

  @override
  void initState() {
    super.initState();
    _loadCustomers();
  }

  Future<void> _loadCustomers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final customers = await _databaseService.getAllCustomers();
      setState(() {
        _allCustomers = customers;
        _applyFiltersAndSort();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('حدث خطأ أثناء تحميل بيانات الزبائن');
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

  void _applyFiltersAndSort() {
    setState(() {
      // تطبيق فلتر البحث
      _filteredCustomers = _allCustomers.where((customer) {
        final String searchString = '${customer.name} ${customer.phone} ${customer.cars.map((car) => '${car.make} ${car.model} ${car.plateNumber}').join(' ')}'
            .toLowerCase();
        return _searchQuery.isEmpty || searchString.contains(_searchQuery.toLowerCase());
      }).toList();

      // تطبيق الترتيب
      _filteredCustomers.sort((a, b) {
        int comparison;
        switch (_sortBy) {
          case 'name':
            comparison = a.name.compareTo(b.name);
            break;
          case 'lastVisit':
            final DateTime aLastVisit = a.lastVisit ?? DateTime(1900);
            final DateTime bLastVisit = b.lastVisit ?? DateTime(1900);
            comparison = aLastVisit.compareTo(bLastVisit);
            break;
          case 'visitsCount':
            comparison = a.visitsCount.compareTo(b.visitsCount);
            break;
          default:
            comparison = a.name.compareTo(b.name);
        }
        return _sortAscending ? comparison : -comparison;
      });
    });
  }

  void _onSearchChanged(String query) {
    setState(() {
      _searchQuery = query;
    });
    _applyFiltersAndSort();
  }

  void _changeSortOrder(String sortBy) {
    setState(() {
      if (_sortBy == sortBy) {
        _sortAscending = !_sortAscending;
      } else {
        _sortBy = sortBy;
        _sortAscending = true;
      }
    });
    _applyFiltersAndSort();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('قائمة الزبائن', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadCustomers,
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              // التنقل إلى صفحة إضافة عميل جديد
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: CustomSearchBar(
              hintText: 'البحث عن زبون، رقم هاتف، سيارة...',
              onChanged: _onSearchChanged,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'ترتيب حسب:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    _buildSortButton('الاسم', 'name'),
                    const SizedBox(width: 8),
                    _buildSortButton('آخر زيارة', 'lastVisit'),
                    const SizedBox(width: 8),
                    _buildSortButton('عدد الزيارات', 'visitsCount'),
                  ],
                ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _filteredCustomers.isEmpty
                ? _buildEmptyState()
                : _buildCustomersList(),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'إجمالي عدد الزبائن: ${_filteredCustomers.length}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // التنقل إلى صفحة إضافة عميل جديد
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }

  Widget _buildSortButton(String label, String sortKey) {
    final bool isActive = _sortBy == sortKey;

    return TextButton.icon(
      onPressed: () => _changeSortOrder(sortKey),
      icon: Icon(
        isActive
            ? _sortAscending ? Icons.arrow_upward : Icons.arrow_downward
            : Icons.swap_vert,
        size: 16,
        color: isActive ? Theme.of(context).primaryColor : Colors.grey,
      ),
      label: Text(
        label,
        style: TextStyle(
          color: isActive ? Theme.of(context).primaryColor : Colors.grey,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.people_outline,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'لا توجد نتائج تطابق معايير البحث'
                : 'لا يوجد زبائن مسجلين',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          if (_searchQuery.isNotEmpty) ...[
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة ضبط البحث'),
              onPressed: () {
                setState(() {
                  _searchQuery = '';
                });
                _applyFiltersAndSort();
              },
            ),
          ] else ...[
            const SizedBox(height: 8),
            TextButton.icon(
              icon: const Icon(Icons.person_add),
              label: const Text('إضافة زبون جديد'),
              onPressed: () {
                // التنقل إلى صفحة إضافة عميل جديد
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomersList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _filteredCustomers.length,
      itemBuilder: (context, index) {
        final customer = _filteredCustomers[index];
        return CustomerCard(
          customer: customer,
          onTap: () => _navigateToCustomerDetails(customer),
        );
      },
    );
  }

  void _navigateToCustomerDetails(Customer customer) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CustomerDetailsPage(customerId: customer.id),
      ),
    ).then((_) => _loadCustomers()); // تحديث البيانات عند العودة
  }
}

class CustomerCard extends StatelessWidget {
  final Customer customer;
  final VoidCallback onTap;

  const CustomerCard({
    Key? key,
    required this.customer,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Theme.of(context).primaryColor.withOpacity(0.1),
                          radius: 24,
                          child: Text(
                            customer.name.isNotEmpty ? customer.name[0].toUpperCase() : '?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                customer.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                customer.phone,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          '${customer.visitsCount} زيارة',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      if (customer.lastVisit != null)
                        Text(
                          'آخر زيارة: ${DateFormat('dd/MM/yyyy', 'ar').format(customer.lastVisit!)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              Text(
                'السيارات:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey[700],
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: customer.cars.isEmpty
                    ? Center(
                  child: Text(
                    'لا توجد سيارات مسجلة',
                    style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic),
                  ),
                )
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: customer.cars.length,
                  itemBuilder: (context, index) {
                    final car = customer.cars[index];
                    return Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.directions_car,
                            size: 16,
                            color: Colors.grey[600],
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '${car.make} ${car.model}',
                            style: TextStyle(
                              color: Colors.grey[800],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomerDetailsPage extends StatefulWidget {
  final String customerId;

  const CustomerDetailsPage({Key? key, required this.customerId}) : super(key: key);

  @override
  _CustomerDetailsPageState createState() => _CustomerDetailsPageState();
}

class _CustomerDetailsPageState extends State<CustomerDetailsPage> with SingleTickerProviderStateMixin {
  final DatabaseService _databaseService = DatabaseService();
  late TabController _tabController;
  bool _isLoading = true;
  Customer? _customer;
  List<CarVisit> _visitHistory = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadCustomerData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadCustomerData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final customer = await _databaseService.getCustomerById(widget.customerId);
      final visits = await _databaseService.getCustomerVisitHistory(widget.customerId);

      setState(() {
        _customer = customer;
        _visitHistory = visits;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      _showErrorSnackBar('حدث خطأ أثناء تحميل بيانات الزبون');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _isLoading ? 'تفاصيل الزبون' : _customer!.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // التنقل إلى صفحة تعديل بيانات الزبون
            },
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'المعلومات الشخصية'),
            Tab(text: 'سجل الزيارات'),
          ],
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
        controller: _tabController,
        children: [
          _buildCustomerInfoTab(),
          _buildVisitHistoryTab(),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // إنشاء موعد جديد للزبون
        },
        icon: const Icon(Icons.add),
        label: const Text('إضافة زيارة جديدة'),
      ),
    );
  }

  Widget _buildCustomerInfoTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle('معلومات الزبون'),
          _buildInfoCard(
            child: Column(
              children: [
                _buildInfoRow(
                  icon: Icons.person,
                  title: 'الاسم',
                  value: _customer!.name,
                ),
                const Divider(),
                _buildInfoRow(
                  icon: Icons.phone,
                  title: 'رقم الهاتف',
                  value: _customer!.phone,
                ),
                const Divider(),
                _buildInfoRow(
                  icon: Icons.email,
                  title: 'البريد الإلكتروني',
                  value: _customer!.email.isEmpty ? 'غير متوفر' : _customer!.email,
                ),
                const Divider(),
                _buildInfoRow(
                  icon: Icons.location_on,
                  title: 'العنوان',
                  value: _customer!.address.isEmpty ? 'غير متوفر' : _customer!.address,
                ),
                const Divider(),
                _buildInfoRow(
                  icon: Icons.calendar_today,
                  title: 'تاريخ التسجيل',
                  value: DateFormat('dd/MM/yyyy', 'ar').format(_customer!.registrationDate),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSectionTitle('سيارات الزبون'),
              TextButton.icon(
                icon: const Icon(Icons.add, size: 16),
                label: const Text('إضافة سيارة'),
                onPressed: () {
                  // إضافة سيارة جديدة للزبون
                },
              ),
            ],
          ),
          _customer!.cars.isEmpty
              ? _buildEmptyState(
            icon: Icons.directions_car_outlined,
            message: 'لا توجد سيارات مسجلة لهذا الزبون',
          )
              : Column(
            children: _customer!.cars.map((car) => _buildCarCard(car)).toList(),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('ملاحظات'),
          _buildInfoCard(
            child: _customer!.notes.isEmpty
                ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'لا توجد ملاحظات',
                  style: TextStyle(color: Colors.grey[500], fontStyle: FontStyle.italic),
                ),
              ),
            )
                : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(_customer!.notes),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildVisitHistoryTab() {
    return _visitHistory.isEmpty
        ? _buildEmptyState(
      icon: Icons.history,
      message: 'لا توجد زيارات سابقة لهذا الزبون',
    )
        : ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: _visitHistory.length,
      itemBuilder: (context, index) {
        final visit = _visitHistory[index];
        return _buildVisitCard(visit);
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildInfoCard({required Widget child}) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: child,
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 20),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  color: Colors.grey[600],
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCarCard(Car car) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${car.make} ${car.model}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, size: 20, color: Colors.blue),
                      onPressed: () {
                        // تعديل بيانات السيارة
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.history, size: 20, color: Colors.green),
                      onPressed: () {
                        // عرض سجل صيانة السيارة
                      },
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildCarPropertyItem(
                  title: 'رقم اللوحة',
                  value: car.plateNumber,
                ),
                _buildCarPropertyItem(
                  title: 'سنة الصنع',
                  value: car.year.toString(),
                ),
                _buildCarPropertyItem(
                  title: 'اللون',
                  value: car.color,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildCarPropertyItem(
                  title: 'آخر كيلومتراج',
                  value: '${car.lastMileage} كم',
                ),
                _buildCarPropertyItem(
                  title: 'وقت التسجيل',
                  value: DateFormat('MM/yyyy', 'ar').format(car.registrationDate),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCarPropertyItem({required String title, required String value}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildVisitCard(CarVisit visit) {
    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  DateFormat('EEEE, dd MMMM yyyy', 'ar').format(visit.visitDate),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  DateFormat('hh:mm a', 'ar').format(visit.visitDate),
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const Divider(),
            Row(
              children: [
                const Icon(Icons.directions_car, size: 16, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  '${visit.carMake} ${visit.carModel} - ${visit.carPlate}',
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
                    visit.serviceDescription,
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
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: _getStatusColor(visit.serviceStatus),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    visit.serviceStatus,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                if (visit.cost > 0)
                  Text(
                    '${visit.cost} ريال',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.info_outline, size: 16),
                  label: const Text('تفاصيل'),
                  onPressed: () {
                    // عرض تفاصيل الزيارة
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'مكتمل':
        return Colors.green;
      case 'قيد التنفيذ':
        return Colors.blue;
      case 'معلق':
        return Colors.orange;
      case 'ملغي':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Widget _buildEmptyState({required IconData icon, required String message}) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}