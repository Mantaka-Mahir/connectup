import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_styles.dart';
import '../widgets/review_prompt_banner.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  // Dummy balance
  double balance = 520.75;
  
  // Mock transaction data
  final List<Map<String, dynamic>> transactions = [
    {
      'amount': 75.0,
      'type': 'credit',
      'description': 'Session payment from client',
      'timestamp': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'amount': 50.0,
      'type': 'debit',
      'description': 'Withdrawal to bank account',
      'timestamp': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'amount': 120.0,
      'type': 'credit',
      'description': 'Bonus for completing 10 sessions',
      'timestamp': DateTime.now().subtract(const Duration(days: 3)),
    },
    {
      'amount': 65.0,
      'type': 'credit',
      'description': 'Session payment from client',
      'timestamp': DateTime.now().subtract(const Duration(days: 5)),
    },
    {
      'amount': 100.0,
      'type': 'debit',
      'description': 'Withdrawal to bank account',
      'timestamp': DateTime.now().subtract(const Duration(days: 7)),
    },
    {
      'amount': 85.0,
      'type': 'credit',
      'description': 'Session payment from client',
      'timestamp': DateTime.now().subtract(const Duration(days: 10)),
    },
    {
      'amount': 45.0,
      'type': 'credit',
      'description': 'Session payment from client',
      'timestamp': DateTime.now().subtract(const Duration(days: 12)),
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,      appBar: AppBar(
        title: Text(
          'My Wallet',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            color: AppColors.text,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: AppColors.text,
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.card_giftcard),
            color: AppColors.text,
            onPressed: () => Navigator.pushNamed(context, '/referral'),
            tooltip: 'Refer & Earn',
          ),
        ],
      ),
      body: Column(
        children: [          // Balance card
          _buildBalanceCard(),
          
          // Referral banner
          _buildReferralBanner(),
          
          // Review banner
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: ReviewPromptBanner(
              onReviewPressed: () {
                Navigator.pushNamed(
                  context, 
                  '/review',
                  arguments: {
                    'expertName': 'Your Recent Mentor',
                    'sessionDate': 'Recent session',
                  },
                );
              },
            ),
          ),
          
          // Transactions section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Transaction History',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text,
                  ),
                ),
                Text(
                  'See All',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ),
          ),
          
          // Transactions list
          Expanded(
            child: transactions.isEmpty
                ? _buildEmptyTransactionsState()
                : _buildTransactionsList(),
          ),
        ],
      ),
    );
  }
  
  // Balance card widget
  Widget _buildBalanceCard() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGradient,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Balance',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${balance.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Refreshing balance...'),
                      duration: Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                _showAddBalanceDialog();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Add Balance',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  // Transaction list widget
  Widget _buildTransactionsList() {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionCard(transaction);
      },
    );
  }
  
  // Transaction card widget
  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isCredit = transaction['type'] == 'credit';
    final DateTime timestamp = transaction['timestamp'] as DateTime;
    
    // Format date
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final transactionDate = DateTime(
      timestamp.year, 
      timestamp.month, 
      timestamp.day
    );
    
    String formattedDate;
    if (transactionDate == today) {
      // Today
      final hour = timestamp.hour > 12 
          ? timestamp.hour - 12 
          : timestamp.hour == 0 ? 12 : timestamp.hour;
      final minute = timestamp.minute.toString().padLeft(2, '0');
      final period = timestamp.hour >= 12 ? 'PM' : 'AM';
      formattedDate = 'Today, $hour:$minute $period';
    } else if (transactionDate == today.subtract(const Duration(days: 1))) {
      // Yesterday
      formattedDate = 'Yesterday';
    } else {
      // Other dates
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                     'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      formattedDate = '${months[timestamp.month - 1]} ${timestamp.day}, ${timestamp.year}';
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // Transaction icon
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: isCredit 
                    ? Colors.green.withOpacity(0.1) 
                    : Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                isCredit 
                    ? Icons.arrow_downward_rounded 
                    : Icons.arrow_upward_rounded,
                color: isCredit ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(width: 16),
            // Transaction details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    transaction['description'],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: AppColors.text,
                    ),
                  ),
                  Text(
                    formattedDate,
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.textLight,
                    ),
                  ),
                ],
              ),
            ),
            // Amount
            Text(
              isCredit 
                  ? '+\$${transaction['amount'].toStringAsFixed(2)}' 
                  : '-\$${transaction['amount'].toStringAsFixed(2)}',
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isCredit ? Colors.green : Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  // Empty transactions state
  Widget _buildEmptyTransactionsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.receipt_long,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 16),
          Text(
            'No transactions yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textLight,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your transaction history will appear here',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.textLight,
            ),
          ),
        ],
      ),
    );
  }
  
  // Dialog to add balance
  void _showAddBalanceDialog() {
    TextEditingController amountController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Add Balance',
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '\$',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Select payment method:',
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.credit_card),
              title: const Text('Credit/Debit Card'),
              trailing: Radio(
                value: 'card',
                groupValue: 'card',
                onChanged: (value) {},
              ),
              dense: true,
            ),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text('Bank Transfer'),
              trailing: Radio(
                value: 'bank',
                groupValue: 'card',
                onChanged: (value) {},
              ),
              dense: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(
                color: AppColors.textLight,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Add the balance (demo)
              Navigator.pop(context);
              
              // Try to parse the amount
              double? amount;
              try {
                amount = double.parse(amountController.text);
              } catch (_) {
                amount = 0;
              }
              
              // Demo: update balance if amount is valid
              if (amount > 0) {
                setState(() {
                  balance += amount!;
                  
                  // Add new transaction
                  transactions.insert(0, {
                    'amount': amount,
                    'type': 'credit',
                    'description': 'Added funds',
                    'timestamp': DateTime.now(),
                  });
                });
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added \$${amount.toStringAsFixed(2)} to your balance'),
                    backgroundColor: Colors.green,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),            child: Text(
              'Add',
              style: GoogleFonts.poppins(),
            ),
          ),
        ],
      ),
    );
  }
  
  // Referral banner widget
  Widget _buildReferralBanner() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, '/referral'),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Center(
                    child: Icon(
                      Icons.card_giftcard,
                      color: AppColors.primary,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Refer & Earn Rewards',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.text,
                        ),
                      ),
                      Text(
                        'Invite friends and earn 50 BDT for each signup',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
