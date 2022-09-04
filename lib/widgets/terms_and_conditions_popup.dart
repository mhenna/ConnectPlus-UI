import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/popup.dart';

Widget TermsAndConditionsPopup(BuildContext context) {
  return new Popup(
    text:
        '''This App is only used internally within the COE and Dell Technologies Egypt (“Dell”); The personal data that you provide on this App will not be shared publicly. Dell will only use data about you for the purpose(s) for which it was collected or provided to us (as stated at the point of collection) or as otherwise obvious from the context of collection. We may also use data to:

•	Administer and manage the Connect+ App, communicate with you about this App, process your request for information, or otherwise complete a transaction or service you request or authorize; 

•	Customize or personalize your user experience and the content we deliver to you, including to provide you with content that is more relevant to you;  

•	Contact you about offers on the Connect+ App, provide you with promotional materials or offers for products/services, or send you other communications about Dell’s business and events.

• We may use your car plate number for identification if you are blocking a Dell employee’s car or if a Dell employee is blocking your car in front of the Dell Technologies’ building (“Use”), provided that such employee also has his/her car plate number registered on the Connect+ App. This data will not be shared widely within Dell Technologies or on company-wide emails. This is optional information and it is collected for facilitation purposes only

''',
  );
}
