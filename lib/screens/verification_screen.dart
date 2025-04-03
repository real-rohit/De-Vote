import 'package:flutter/material.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  _VerificationScreenState createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _genderController = TextEditingController();
  final TextEditingController _aadhaarController = TextEditingController();
  final TextEditingController _voterIdController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool isOtpSent = false;
  bool isLoading = false;

  Future<void> _sendOtp() async {
    setState(() => isLoading = true);
    try {
      await Future.delayed(Duration(seconds: 2));
      setState(() => isOtpSent = true);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("OTP sent to your email")));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to send OTP")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _verifyOtp() async {
    setState(() => isLoading = true);
    try {
      await Future.delayed(Duration(seconds: 2));
      if (_otpController.text == "123456") {
        showDialog(
          context: context,
          builder:
              (context) => AlertDialog(
                title: Text("Verification Successful"),
                content: Text("Your details have been successfully verified."),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/home');
                    },
                    child: Text("OK"),
                  ),
                ],
              ),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text("Invalid OTP")));
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Verification failed")));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Voter Verification",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(_nameController, "Name", Icons.person),
                _buildTextField(
                  _ageController,
                  "Age",
                  Icons.calendar_today,
                  isNumber: true,
                ),
                _buildTextField(_genderController, "Gender", Icons.transgender),
                _buildTextField(
                  _aadhaarController,
                  "Aadhaar Card",
                  Icons.credit_card,
                ),
                _buildTextField(
                  _voterIdController,
                  "Voter ID",
                  Icons.perm_identity,
                ),
                _buildTextField(
                  _phoneController,
                  "Phone Number",
                  Icons.phone,
                  isNumber: true,
                ),
                _buildTextField(
                  _emailController,
                  "Email",
                  Icons.email,
                  isEmail: true,
                ),
                if (isOtpSent)
                  _buildTextField(
                    _otpController,
                    "OTP",
                    Icons.lock,
                    isNumber: true,
                  ),
                SizedBox(height: 30),
                isLoading
                    ? CircularProgressIndicator(color: Colors.red)
                    : ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          isOtpSent ? _verifyOtp() : _sendOtp();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: Colors.red,
                      ),
                      child: Text(
                        isOtpSent ? "Verify OTP" : "Send OTP",
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool isNumber = false,
    bool isEmail = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20.0),
      child: TextFormField(
        controller: controller,
        style: TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.white70),
          prefixIcon: Icon(icon, color: Colors.red),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.red),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.black45,
        ),
        keyboardType:
            isNumber
                ? TextInputType.number
                : (isEmail ? TextInputType.emailAddress : TextInputType.text),
        validator: (value) => value!.isEmpty ? "Enter your $label" : null,
      ),
    );
  }
}
