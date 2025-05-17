import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'BookingScreen.dart';
import 'CarScreen.dart';

class HomePages extends StatelessWidget {
  const HomePages({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    String _userName = 'John Doe';
    Future<void> _loadUserPreferences() async {
      try {
        SharedPreferences prefs = await SharedPreferences.getInstance();

          _userName = prefs.getString('name') ?? 'John Doe';
      } catch (e) {
        print('Error loading preferences: $e');
      }
    }
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverAppBar(
              pinned: true,
              expandedHeight: 120,
              backgroundColor: Colors.blue,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Brothers Garage',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                  ),
                ),
                background: Stack(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue.shade800, Colors.blue.shade600],
                        ),
                      ),
                    ),
                    Positioned(
                      right: -50,
                      top: -20,
                      child: CircleAvatar(
                        radius: 100,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -50,
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white.withOpacity(0.1),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Welcome message
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Keep your car in top condition with our services',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Book Service Card
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  height: 180,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade700, Colors.blue.shade500],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      // Decorative elements
                      Positioned(
                        right: -20,
                        top: -20,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      Positioned(
                        left: -30,
                        bottom: -30,
                        child: CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.white.withOpacity(0.1),
                        ),
                      ),
                      Positioned(
                        right: 20,
                        top: 20,
                        child: Icon(
                          Icons.car_repair,
                          color: Colors.white.withOpacity(0.6),
                          size: 60,
                        ),
                      ),

                      // Content
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Book Service',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Schedule your next car service now',
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => BookingScreen()
                                    )
                                );
                              },
                              icon: Icon(Icons.calendar_today),
                              label: Text('Book Now'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue.shade700,
                                elevation: 0,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Quick Actions
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(child: _buildActionCard(
                          context: context,
                          title: 'Maintenance',
                          icon: Icons.build,
                          color: Colors.orange,
                          onTap: () {
                            // Handle maintenance
                          },
                        )),
                        SizedBox(width: 12),
                        Expanded(child: _buildActionCard(
                          context: context,
                          title: 'History',
                          icon: Icons.history,
                          color: Colors.green,
                          onTap: () {
                            // Handle history
                          },
                        )),
                        SizedBox(width: 12),
                        Expanded(child: _buildActionCard(
                          context: context,
                          title: 'Support',
                          icon: Icons.headset_mic,
                          color: Colors.purple,
                          onTap: () {
                            // Handle support
                          },
                        )),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Recent Service Card
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Recent Service',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 16),
                    Container(
                      padding: EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.1),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.car_repair,
                                  color: Colors.blue,
                                  size: 24,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'No recent services',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade800,
                                      ),
                                    ),
                                    SizedBox(height: 4),
                                    Text(
                                      'Book your first service with us',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16),
                          Divider(),
                          SizedBox(height: 8),
                          Center(
                            child: TextButton.icon(
                              onPressed: () {
                                // Navigate to service history
                              },
                              icon: Icon(Icons.history),
                              label: Text('View History'),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Stats Grid
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vehicle Stats',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: _buildStatCard(
                            title: 'Next Service',
                            value: 'Not Scheduled',
                            icon: Icons.schedule,
                            color: Colors.blue,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: _buildStatCard(
                            title: 'Vehicle Status',
                            value: 'Good',
                            icon: Icons.check_circle,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Special Offers
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [Colors.purple.shade700, Colors.purple.shade500],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.purple.withOpacity(0.3),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'SPECIAL OFFER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              '20% OFF',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                              ),
                            ),
                            Text(
                              'on Full Car Service',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                // Navigate to special offer details
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.purple.shade700,
                                elevation: 0,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text('Learn More'),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            Icons.local_offer,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom padding
            SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),

    );
  }

  Widget _buildActionCard({
    required BuildContext context,
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 24,
              ),
            ),
            SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade800,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 20,
                ),
              ),
              SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: value == 'Good' ? Colors.green : Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }
}