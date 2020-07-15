import 'package:flutter/material.dart';
import 'package:connect_plus/widgets/app_scaffold.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:connect_plus/Navbar.dart';

class emergencyContact extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        centerTitle: true,
        title: Text(
            'Emergency Contacts'
        ),
      ),
      body:ListView(
          children: <Widget>[
            SizedBox(height:20.0),
            ExpansionTile(
              title: Text(
                "Services (Bupa & Medical)",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                      'BUPA Egypt Hotline'
                  ),
                  onTap:()=>launch("tel://16816") ,
                ),
                ListTile(
                  title: Text(
                      'Bupa Medical queries (Outside Egypt)'
                  ),
                  onTap:()=>launch("tel:+202 27681100") ,
                ),
                ListTile(
                  title: Text(
                      'BUPA Emergency contact'
                  ),
                  onTap:()=>launch("tel:+201227624595") ,
                ),
                ListTile(
                  title: Text(
                      'BUPA Medical Center'
                  ),
                  onTap:()=>launch("tel: +44 1273333911") ,
                ),
                ListTile(
                  title: Text(
                      'BUPA 24/7 Hotline'
                  ),
                  onTap:()=>launch("tel: +44 1273 323 563") ,
                ),
                ListTile(
                  title: Text(
                      'Travel Security Emergency (ISOS)'
                  ),
                  onTap:()=>launch("tel: +44 20 7939 8899") ,
                ),
                ListTile(
                  title: Text(
                      '*Rehab Emergency Medical Center'
                  ),
                  onTap:()=>launch("tel: +202 26077980") ,
                ),
                ListTile(
                  title: Text(
                      '*Air Force Specialized Hospital'
                  ),
                  onTap:()=>launch("tel://19448") ,
                )
              ],
            ),
            ExpansionTile(
              title: Text(
                "DellEMC",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                      'DELL EMC Office'
                  ),
                  onTap:()=>launch("tel:+202 2 5032500") ,
                  ),
                  ListTile(
                    title: Text(
                        'DELL EMC Fax'
                    ),
                    onTap:()=>launch("tel: +202 2503 2555") ,
                  ),
                  ListTile(
                    title: Text(
                        'IT Global Desk: +1 800-782-3797 opt 1 x58126'
                    ),
                  ),
                  ListTile(
                    title: Text(
                        'IT International Direct'
                    ),
                    onTap:()=>launch("tel: +1 (508) 898-5812") ,
                  )
              ],
            ),
            ExpansionTile(
              title: Text(
                "Emergency",
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold
                ),
              ),
              children: <Widget>[
                ListTile(
                  title: Text(
                      'Ambulance – 123'
                  ),
                  onTap:()=>launch("tel:+202 35345260") ,
                ),
                ListTile(
                  title: Text(
                      'Police'
                  ),
                  onTap:()=>launch("tel: 122") ,
                ),
                ListTile(
                  title: Text(
                      'New Cairo Police Station'
                  ),
                  onTap:()=>launch("tel:+202 26173630") ,
                ),
                ListTile(
                  title: Text(
                      'Fire Brigade – 180'
                  ),
                  onTap:()=>launch("tel:+202 23910115") ,
                ),
                ListTile(
                  title: Text(
                      'Road Rescue'
                  ),
                  onTap:()=>launch("Road Rescue") ,
                ),
                ListTile(
                  title: Text(
                      'Road Accident'
                  ),
                  onTap:()=>launch("tel:+201221110000") ,
                )
              ],
            ),
          ],
      ),
    );
  }
}