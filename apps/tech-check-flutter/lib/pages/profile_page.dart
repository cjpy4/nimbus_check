import 'package:flutter/material.dart';


class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Account Page',
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: const Color(0xFF1F2937),
        scaffoldBackgroundColor: const Color(0xFF111827),
        cardColor: const Color(0xFF1F2937),
        fontFamily: 'Inter',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFD1D5DB)),
          bodyMedium: TextStyle(color: Color(0xFF9CA3AF)),
          titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          titleMedium: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: const Color(0xFF2563EB),
          textTheme: ButtonTextTheme.primary,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFF374151),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          hintStyle: const TextStyle(color: Color(0xFF9CA3AF)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const AccountPage(),
    );
  }
}

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  int _selectedIndex = 0;
  bool _isExtended = false;

  late final List<Widget> _views;

  @override
  void initState() {
    super.initState();
    _views = [
      const ProfileView(),
      const UsersView(),
      const BillingView(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final bool isSmallScreen = MediaQuery.of(context).size.width < 768;

    // Use a BottomNavigationBar for small screens
    if (isSmallScreen) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('SynthWave Inc.'),
          backgroundColor: const Color(0xFF111827),
          elevation: 0,
        ),
        body: IndexedStack(
          index: _selectedIndex,
          children: _views,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          backgroundColor: const Color(0xFF1F2937),
          selectedItemColor: Colors.blueAccent,
          unselectedItemColor: const Color(0xFF9CA3AF),
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
            BottomNavigationBarItem(icon: Icon(Icons.group_outlined), label: 'Users'),
            BottomNavigationBarItem(icon: Icon(Icons.credit_card_outlined), label: 'Billing'),
          ],
        ),
      );
    }
    
    // Use a NavigationRail for larger screens
    return Scaffold(
      body: Row(
        children: [
          LayoutBuilder(
            builder: (context, constraint) {
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraint.maxHeight),
                  child: IntrinsicHeight(
                    child: NavigationRail(
                      selectedIndex: _selectedIndex,
                      onDestinationSelected: (index) {
                        setState(() {
                          _selectedIndex = index;
                        });
                      },
                      extended: _isExtended,
                      minExtendedWidth: 200,
                      backgroundColor: const Color(0xFF111827),
                      indicatorColor: const Color(0xFF1F2937),
                      selectedIconTheme: const IconThemeData(color: Colors.blueAccent),
                      unselectedIconTheme: const IconThemeData(color: Color(0xFF9CA3AF)),
                      selectedLabelTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      unselectedLabelTextStyle: const TextStyle(color: Color(0xFF9CA3AF)),
                      leading: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.layers, color: Colors.white, size: 30),
                            if(_isExtended) const SizedBox(width: 10),
                            if(_isExtended) const Text("SynthWave", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                      destinations: const [
                        NavigationRailDestination(icon: Icon(Icons.person_outline), selectedIcon: Icon(Icons.person), label: Text('Profile')),
                        NavigationRailDestination(icon: Icon(Icons.group_outlined), selectedIcon: Icon(Icons.group), label: Text('Users')),
                        NavigationRailDestination(icon: Icon(Icons.credit_card_outlined), selectedIcon: Icon(Icons.credit_card), label: Text('Billing')),
                      ],
                      trailing: Expanded(
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: IconButton(
                              icon: Icon(_isExtended ? Icons.arrow_back_ios : Icons.arrow_forward_ios),
                              onPressed: () {
                                setState(() {
                                  _isExtended = !_isExtended;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: IndexedStack(
              index: _selectedIndex,
              children: _views,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Profile View Widget ---
class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Account Settings', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 28)),
              const SizedBox(height: 8),
              Text('Manage your profile, and organization settings.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 32),
              Card(
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[800]!)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Profile Information", style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 24),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const CircleAvatar(
                                  radius: 40,
                                  backgroundImage: NetworkImage('https://placehold.co/100x100/3b82f6/FFFFFF?text=AV'),
                                ),
                                const SizedBox(width: 24),
                                Expanded(child: _buildProfileForm(context)),
                              ],
                            ),
                          ],
                        ),
                    ),
                    Container(
                      color: Colors.grey[900]?.withOpacity(0.5),
                      padding: const EdgeInsets.all(16.0),
                      child: const Align(
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(onPressed: null, child: Text('Save Changes')),
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildThemeSettings(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileForm(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          initialValue: 'Admin User',
          decoration: const InputDecoration(labelText: 'Full Name'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: 'admin@synthwave.io',
          readOnly: true,
          decoration: const InputDecoration(labelText: 'Email Address'),
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: 'Lead Administrator',
          decoration: const InputDecoration(labelText: 'Title'),
        ),
      ],
    );
  }

  Widget _buildThemeSettings(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[800]!)),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Theme", style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text("Customize the appearance of the application.", style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 16),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text("Dark Mode"),
              trailing: Switch(
                value: true,
                onChanged: (val) {},
                activeColor: Colors.blueAccent,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Users View Widget ---
class UsersView extends StatelessWidget {
  const UsersView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> users = [
      {'name': 'Admin User', 'role': 'Admin', 'status': 'Active', 'avatar': 'https://placehold.co/40x40/7e22ce/FFFFFF?text=AU'},
      {'name': 'Jane Doe', 'role': 'Developer', 'status': 'Active', 'avatar': 'https://placehold.co/40x40/16a34a/FFFFFF?text=JD'},
      {'name': 'Mike Smith', 'role': 'Analyst', 'status': 'Invited', 'avatar': 'https://placehold.co/40x40/c2410c/FFFFFF?text=MS'},
    ];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Users', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 28)),
                      const SizedBox(height: 8),
                      Text('Manage who has access to your organization.', style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Invite User'),
                    onPressed: () {},
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Card(
                elevation: 0,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[800]!)),
                child: SizedBox(
                  width: double.infinity,
                  child: DataTable(
                    headingRowColor: MaterialStateProperty.all(Colors.grey[850]),
                    columns: const [
                      DataColumn(label: Text('NAME')),
                      DataColumn(label: Text('ROLE')),
                      DataColumn(label: Text('STATUS')),
                      DataColumn(label: Text('')),
                    ],
                    rows: users.map((user) => DataRow(cells: [
                      DataCell(Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundImage: NetworkImage(user['avatar']!),
                          ),
                          const SizedBox(width: 12),
                          Text(user['name']!, style: const TextStyle(color: Colors.white)),
                        ],
                      )),
                      DataCell(Text(user['role']!)),
                      DataCell(
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: user['status'] == 'Active' ? Colors.green.withOpacity(0.2) : Colors.yellow.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            user['status']!,
                            style: TextStyle(color: user['status'] == 'Active' ? Colors.green[300] : Colors.yellow[300]),
                          ),
                        )
                      ),
                      DataCell(TextButton(onPressed: () {}, child: Text(user['status'] == 'Invited' ? 'Resend' : 'Edit'))),
                    ])).toList(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Billing View Widget ---
class BillingView extends StatelessWidget {
  const BillingView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 800),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Billing', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 28)),
              const SizedBox(height: 8),
              Text('Manage your subscription and payment details.', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 32),
              LayoutBuilder(builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  return Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _buildCurrentPlanCard(context)),
                      const SizedBox(width: 24),
                      Expanded(child: _buildPaymentMethodCard(context)),
                    ],
                  );
                }
                return Column(
                  children: [
                    _buildCurrentPlanCard(context),
                    const SizedBox(height: 24),
                    _buildPaymentMethodCard(context),
                  ],
                );
              }),
              const SizedBox(height: 32),
              _buildBillingHistory(context)
            ],
          ),
        ),
      ),
    );
  }
  
  Widget _buildCurrentPlanCard(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[800]!)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Current Plan", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                Text("Enterprise", style: Theme.of(context).textTheme.titleLarge?.copyWith(fontSize: 32)),
                const SizedBox(height: 8),
                Text("Next payment of \$2,499 on July 1, 2025.", style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
          Container(
            color: Colors.grey[900]?.withOpacity(0.5),
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text("Change Plan"),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPaymentMethodCard(BuildContext context) {
    return Card(
      elevation: 0,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[800]!)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Payment Method", style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.credit_card, color: Colors.blueAccent, size: 40),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Visa ending in 1234", style: Theme.of(context).textTheme.titleMedium?.copyWith(fontSize: 16)),
                        Text("Expires 06/2028", style: Theme.of(context).textTheme.bodyMedium),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
          Container(
            color: Colors.grey[900]?.withOpacity(0.5),
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[600]),
                onPressed: () {},
                child: const Text("Update Card"),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBillingHistory(BuildContext context) {
    return Card(
       elevation: 0,
       clipBehavior: Clip.antiAlias,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: Colors.grey[800]!)),
       child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Text("Billing History", style: Theme.of(context).textTheme.titleMedium),
          ),
          SizedBox(
            width: double.infinity,
            child: DataTable(
              headingRowColor: MaterialStateProperty.all(Colors.grey[850]),
              columns: const [
                DataColumn(label: Text('DATE')),
                DataColumn(label: Text('DESCRIPTION')),
                DataColumn(label: Text('AMOUNT')),
                DataColumn(label: Text('INVOICE')),
              ],
              rows: const [
                 DataRow(cells: [
                   DataCell(Text('June 1, 2025')),
                   DataCell(Text('Monthly Subscription', style: TextStyle(color: Colors.white))),
                   DataCell(Text('\$2,499.00', style: TextStyle(color: Colors.white))),
                   DataCell(TextButton(onPressed: null, child: Text('Download'))),
                 ]),
                  DataRow(cells: [
                   DataCell(Text('May 1, 2025')),
                   DataCell(Text('Monthly Subscription', style: TextStyle(color: Colors.white))),
                   DataCell(Text('\$2,499.00', style: TextStyle(color: Colors.white))),
                   DataCell(TextButton(onPressed: null, child: Text('Download'))),
                 ]),
              ],
            ),
          ),
        ],
       ),
    );
  }
}
