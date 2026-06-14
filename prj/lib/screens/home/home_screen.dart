import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onBottomNavTap(int index) {
    if (index == 1) {
      Navigator.pushNamed(context, '/transactions');
      return;
    }
    if (index == 2) {
      Navigator.pushNamed(context, '/goals');
      return;
    }
    if (index == 3) {
      Navigator.pushNamed(context, '/profile');
      return;
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const CircleAvatar(
                    radius: 25,
                    child: Icon(Icons.person),
                  ),

                  const SizedBox(width: 12),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Good Morning 👋",
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Quang",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.notifications_none,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Balance Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.circular(24),

                  gradient:
                      const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xff4CAF50),
                      Color(0xff2E7D32),
                    ],
                  ),
                ),

                child: const Column(
                  children: [
                    Text(
                      "Total Balance",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),

                    SizedBox(height: 10),

                    Text(
                      "15,500,000 ₫",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Income Expense
              Row(
                children: [
                  Expanded(
                    child: _summaryCard(
                      context: context,
                      title: "Income",
                      amount: "20,000,000 ₫",
                      icon: Icons.arrow_downward,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: _summaryCard(
                      context: context,
                      title: "Expense",
                      amount: "4,500,000 ₫",
                      icon: Icons.arrow_upward,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // Spending Overview
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Spending Overview",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      height: 220,

                      child: PieChart(
                        PieChartData(
                          sectionsSpace: 2,
                          centerSpaceRadius: 45,

                          sections: [
                            PieChartSectionData(
                              value: 40,
                              color: Colors.orange,
                              title: "40%",
                              radius: 60,
                            ),
                            PieChartSectionData(
                              value: 25,
                              color: Colors.blue,
                              title: "25%",
                              radius: 60,
                            ),
                            PieChartSectionData(
                              value: 20,
                              color: Colors.green,
                              title: "20%",
                              radius: 60,
                            ),
                            PieChartSectionData(
                              value: 15,
                              color: Colors.purple,
                              title: "15%",
                              radius: 60,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    Wrap(
                      spacing: 20,
                      runSpacing: 10,
                      children: [
                        _legend(
                          Colors.orange,
                          "Food",
                        ),
                        _legend(
                          Colors.blue,
                          "Shopping",
                        ),
                        _legend(
                          Colors.green,
                          "Transport",
                        ),
                        _legend(
                          Colors.purple,
                          "Other",
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Recent Transactions
              Container(
                padding: const EdgeInsets.all(20),

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(20),
                ),

                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment:
                          MainAxisAlignment
                              .spaceBetween,
                      children: [
                        const Text(
                          "Recent Transactions",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                FontWeight.bold,
                          ),
                        ),

                            TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/transactions');
                          },
                          child: const Text(
                            "View All",
                          ),
                        ),
                      ],
                    ),

                    const Divider(),

                    _transactionTile(
                      icon: Icons.fastfood,
                      color: Colors.orange,
                      title: "Food",
                      subtitle:
                          "Highlands Coffee",
                      amount: "-150,000 ₫",
                    ),

                    _transactionTile(
                      icon: Icons.local_taxi,
                      color: Colors.blue,
                      title: "Transport",
                      subtitle: "Grab",
                      amount: "-50,000 ₫",
                    ),

                    _transactionTile(
                      icon: Icons.payments,
                      color: Colors.green,
                      title: "Salary",
                      subtitle:
                          "Monthly Salary",
                      amount:
                          "+15,000,000 ₫",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onBottomNavTap,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Transactions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.flag),
            label: 'Goals',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  static Widget _summaryCard({
    required BuildContext context,
    required String title,
    required String amount,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),

      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius:
            BorderRadius.circular(20),
      ),

      child: Column(
        children: [
          CircleAvatar(
            backgroundColor:
                color.withValues(alpha: 0.1),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(height: 10),

          Text(title),

          const SizedBox(height: 6),

          Text(
            amount,
            style: const TextStyle(
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _legend(
    Color color,
    String text,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 6),

        Text(text),
      ],
    );
  }

  static Widget _transactionTile({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String amount,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,

      leading: CircleAvatar(
        backgroundColor:
            color.withValues(alpha: 0.1),

        child: Icon(
          icon,
          color: color,
        ),
      ),

      title: Text(title),

      subtitle: Text(subtitle),

      trailing: Text(
        amount,
        style: TextStyle(
          color: amount.contains("-")
              ? Colors.red
              : Colors.green,
          fontWeight:
              FontWeight.bold,
        ),
      ),
    );
  }
}