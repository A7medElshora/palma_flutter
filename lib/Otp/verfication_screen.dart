import 'package:flutter/material.dart';
import 'package:p_p/Otp/create_password.dart';

class OTPVerification extends StatelessWidget {
  static const routeName = "/otp-verification";
  const OTPVerification({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: OverflowBar(
              overflowSpacing: 10,
              children: [
                Text(
                  "Verification Code",
                  style: TextStyle(
                      color: Color(0xff3C6255),
                      fontSize: 34,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  "Please enter the verification code we sent to your phone number",
                  style: TextStyle(
                      color: Color(0xFF56B098),
                      fontSize: 15,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 22),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _textFieldOTP(first: true, last: false, context: context),
                    _textFieldOTP(first: false, last: false, context: context),
                    _textFieldOTP(first: false, last: false, context: context),
                    _textFieldOTP(first: false, last: true, context: context),
                  ],
                ),
                const SizedBox(height: 28),
                //verify Button
                Container(
                  width: MediaQuery.of(context).size.width * 0.9,
                  height: 57,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      primary: Color(0xff3C6255),
                    ),
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                          MaterialPageRoute(builder: (BuildContext context) {
                        return CreateNewPassword();
                      }));
                    },
                    child: Text(
                      'Done',
                      style: TextStyle(
                          fontSize: 18,
                          color: Color(0xFF56B098)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _textFieldOTP({bool? first, last, required BuildContext context}) {
    return SizedBox(
      height: 85,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: TextField(
          autofocus: true,
          onChanged: (value) {
            if (value.length == 1 && last == false) {
              FocusScope.of(context).nextFocus();
            }
            if (value.isEmpty && first == false) {
              FocusScope.of(context).previousFocus();
            }
          },
          showCursor: false,
          readOnly: false,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .copyWith(fontWeight: FontWeight.bold),
          keyboardType: TextInputType.number,
          maxLength: 1,
          decoration: InputDecoration(
            counter: const Offstage(),
            enabledBorder: OutlineInputBorder(
              borderSide:
                  BorderSide(width: 2, color: Color.fromARGB(124, 5, 143, 95)),
              borderRadius: BorderRadius.circular(12),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(width: 2, color: Color(0xff3C6255)),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }
}
