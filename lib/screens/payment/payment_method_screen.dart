import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../constants/styles.dart';
import '../../routes.dart';

class PaymentMethodScreen extends StatefulWidget {
  const PaymentMethodScreen({super.key});

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  final List<Map<String, dynamic>> _paymentMethods = const [
    {
      'id': 'evc',
      'name': 'EVC PLUS',
      'prefix': '252',
      'color': AppStyles.secondaryColor,
      'icon': 'assets/icons/evc.png',
    },
    {
      'id': 'zaad',
      'name': 'ZAAD SERVICE',
      'prefix': '25263',
      'color': AppStyles.primaryColor,
      'icon': 'assets/icons/somtel.jpeg',
    },
    {
      'id': 'sahal',
      'name': 'SAHAL',
      'prefix': '25290',
      'color': Color(0xFFFF9800),
      'icon': 'assets/icons/sahal.png',
    },
  ];

  String? _selectedMethodId;
  final _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  void _showPhoneNumberInput(BuildContext context, Map<String, dynamic> method, double amount) {
    _phoneController.clear();
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.5,
        decoration: const BoxDecoration(
          color: AppStyles.surfaceColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Enter your ${method['name']} Number',
                      style: AppStyles.headingStyle.copyWith(
                        fontSize: 20,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppStyles.backgroundColor,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                color: method['color'],
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                method['prefix']!,
                                style: AppStyles.subheadingStyle.copyWith(
                                  fontSize: 16,
                                  color: method['color'],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            style: const TextStyle(
                              fontSize: 16,
                              letterSpacing: 1.2,
                            ),
                            maxLength: 8,
                            decoration: InputDecoration(
                              hintText: 'Enter phone number',
                              counterText: '',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: Colors.grey[300]!,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: method['color'],
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: AppStyles.surfaceColor,
                              prefixText: '${method['prefix']} ',
                              prefixStyle: TextStyle(
                                color: method['color'],
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn().slideY(),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppStyles.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: AppStyles.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'You will receive a prompt on your phone to confirm the payment',
                              style: TextStyle(
                                color: AppStyles.primaryColor,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Amount to Pay',
                              style: TextStyle(
                                color: AppStyles.subtitleColor,
                                fontSize: 13,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '\$${amount.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: method['color'],
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ElevatedButton(
                              onPressed: () {
                                final phone = _phoneController.text.trim();
                                if (phone.length != 8) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Please enter a valid phone number',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: AppStyles.errorColor,
                                    ),
                                  );
                                  return;
                                }
                                Navigator.pushNamed(
                                  context,
                                  Routes.paymentSuccess,
                                  arguments: {
                                    'methodId': method['id'],
                                    'amount': amount,
                                    'phone': phone,
                                  },
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: method['color'],
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 0,
                              ),
                              child: const Text(
                                'Confirm Payment',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    final totalAmount = args['totalAmount'] as double;

    return Scaffold(
      backgroundColor: AppStyles.backgroundColor,
      appBar: AppBar(
        title: const Text(
          'Select Payment Method',
          style: AppStyles.headingStyle,
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: _paymentMethods.length,
        itemBuilder: (context, index) {
          final method = _paymentMethods[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: _buildPaymentCard(method, totalAmount, index),
          );
        },
      ),
    );
  }

  Widget _buildPaymentCard(Map<String, dynamic> method, double amount, int index) {
    final isSelected = _selectedMethodId == method['id'];
    
    return Card(
      elevation: 0,
      color: AppStyles.surfaceColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected ? method['color'] : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: () {
          setState(() => _selectedMethodId = method['id']);
          _showPhoneNumberInput(context, method, amount);
        },
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Container(
                width: 56,
                height: 56,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    method['icon']!,
                    width: 36,
                    height: 36,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  method['name']!,
                  style: AppStyles.headingStyle.copyWith(
                    fontSize: 16,
                    color: isSelected ? method['color'] : null,
                  ),
                ),
              ),
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isSelected ? method['color'] : Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.check,
                  color: isSelected ? Colors.white : Colors.grey[400],
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate(delay: Duration(milliseconds: 100 * index))
      .fadeIn()
      .slideX();
  }
}
