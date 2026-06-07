import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lab 7 - Signup Form',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const SignupScreen(),
    );
  }
}

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Form key for validation
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Focus nodes for each field
  late FocusNode _nameFocus;
  late FocusNode _emailFocus;
  late FocusNode _passwordFocus;
  late FocusNode _confirmPasswordFocus;

  // Text controllers to store values
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // State variables
  bool _isCheckingEmail = false;
  bool _showPassword = false;
  bool _showConfirmPassword = false;
  String _passwordStrength = '';

  @override
  void initState() {
    super.initState();
    _nameFocus = FocusNode();
    _emailFocus = FocusNode();
    _passwordFocus = FocusNode();
    _confirmPasswordFocus = FocusNode();
  }

  @override
  void dispose() {
    _nameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Validation functions
  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    // Check for @ and .
    if (!value.contains('@') || !value.contains('.')) {
      return 'Enter a valid email';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least 1 digit';
    }

    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Confirm password is required';
    }
    if (value != _passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _updatePasswordStrength(String password) {
    int strength = 0;
    if (password.length >= 8) strength++;
    if (password.length >= 12) strength++;
    if (RegExp(r'[0-9]').hasMatch(password)) strength++;
    if (RegExp(r'[a-z]').hasMatch(password) &&
        RegExp(r'[A-Z]').hasMatch(password)) {
      strength++;
    }
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(password)) {
      strength++;
    }

    setState(() {
      if (strength <= 2) {
        _passwordStrength = 'Weak';
      } else if (strength <= 3) {
        _passwordStrength = 'Medium';
      } else {
        _passwordStrength = 'Strong';
      }
    });
  }

  Future<void> _submit() async {
    // First validate the form
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Save form state
    _formKey.currentState!.save();

    // Start async email check
    setState(() {
      _isCheckingEmail = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    // Check if email is already taken (emails starting with "taken" are taken)
    if (_emailController.text.toLowerCase().startsWith('taken')) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This email is already taken'),
            backgroundColor: Colors.red,
          ),
        );
      }
      setState(() {
        _isCheckingEmail = false;
      });
      return;
    }

    setState(() {
      _isCheckingEmail = false;
    });

    // Show success message
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Welcome ${_nameController.text}! Signup successful.'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 3),
        ),
      );

      // Clear form
      _formKey.currentState!.reset();
      _nameController.clear();
      _emailController.clear();
      _passwordController.clear();
      _confirmPasswordController.clear();
      setState(() {
        _passwordStrength = '';
      });
    }
  }

  Color _getPasswordStrengthColor() {
    switch (_passwordStrength) {
      case 'Weak':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Strong':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Dismiss keyboard when tapping outside form
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Signup'), centerTitle: true),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20),
                  // Full Name Field
                  TextFormField(
                    controller: _nameController,
                    focusNode: _nameFocus,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      hintText: 'Enter your full name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      // Move to email field
                      _nameFocus.unfocus();
                      FocusScope.of(context).requestFocus(_emailFocus);
                    },
                    validator: _validateName,
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  TextFormField(
                    controller: _emailController,
                    focusNode: _emailFocus,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      hintText: 'Enter your email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.email),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      // Move to password field
                      _emailFocus.unfocus();
                      FocusScope.of(context).requestFocus(_passwordFocus);
                    },
                    validator: _validateEmail,
                  ),
                  const SizedBox(height: 16),

                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    focusNode: _passwordFocus,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      hintText: 'Enter your password (min 8 chars, 1 digit)',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _showPassword = !_showPassword;
                          });
                        },
                      ),
                    ),
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) {
                      // Move to confirm password field
                      _passwordFocus.unfocus();
                      FocusScope.of(
                        context,
                      ).requestFocus(_confirmPasswordFocus);
                    },
                    onChanged: (value) {
                      if (value.isNotEmpty) {
                        _updatePasswordStrength(value);
                      } else {
                        setState(() {
                          _passwordStrength = '';
                        });
                      }
                    },
                    validator: _validatePassword,
                  ),

                  // Password Strength Indicator
                  if (_passwordStrength.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          const Text(
                            'Strength: ',
                            style: TextStyle(fontSize: 12),
                          ),
                          Text(
                            _passwordStrength,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: _getPasswordStrengthColor(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Confirm Password Field
                  TextFormField(
                    controller: _confirmPasswordController,
                    focusNode: _confirmPasswordFocus,
                    obscureText: !_showConfirmPassword,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      hintText: 'Re-enter your password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showConfirmPassword
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                      ),
                    ),
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) {
                      // Call submit on done
                      _confirmPasswordFocus.unfocus();
                      _submit();
                    },
                    validator: _validateConfirmPassword,
                  ),
                  const SizedBox(height: 24),

                  // Submit Button
                  ElevatedButton.icon(
                    onPressed: _isCheckingEmail ? null : _submit,
                    icon: _isCheckingEmail
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : const Icon(Icons.check),
                    label: Text(
                      _isCheckingEmail ? 'Checking Email...' : 'Sign Up',
                    ),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
