import 'package:flutter/material.dart';
import 'svg_wave.dart'; // Ensure this path is correct

class KulgeetPage extends StatelessWidget {
  const KulgeetPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('कुल-गीत'),
      ),
      body: Column(
        children: [
          SvgWave(isTop: true), // Top SVG wave
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(20.0),
              children: [
                _buildVerse('गया महाविद्यालय सुन्दर,', 'आत्म-दीप की शिखा समुज्ज्वल ।', 'ब्रह्म-योनि की पार्श्व-भूमि में,', 'नित नवीन यह ज्ञान-कमल-दल ।।१।। गया..'),
                _buildVerse('विष्णु-पुरातन-नगरी में यह,', 'अमर-बेलि ज्योतिधुर्वतारा।', 'अन्तःसलिला से अनुप्राणित,', 'ज्ञान-भक्ति-सत्कर्म-सुधारा ।।२।। गया..'),
                _buildVerse('असुर-निकन्दन प्रेम-प्रबोधन,', 'यह विद्या-मन्दिर अविनश्वर।', 'बुद्ध-विवेकानन्द-महाप्रभु,', 'शंकर-पद-अवतारित सरवर ।।३।। गया..'),
                _buildVerse('विज्ञान-कला-वाणिज्य सुसंगम,', 'व्याप्ति-समृष्टि-समन्वित दीक्षा।', 'भौतिकता-अध्यात्म-एकता,', 'सत्य-स्नेह सप्लावित शिक्षा ।।४।। गया..'),
              ],
            ),
          ),
          SvgWave(isTop: false), // Bottom SVG wave
        ],
      ),
    );
  }

  Widget _buildVerse(String line1, String line2, String line3, String line4) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center, // Center align the text
        children: [
          Text(line1, style: TextStyle(fontSize: 18, color: Colors.black), textAlign: TextAlign.center),
          Text(line2, style: TextStyle(fontSize: 18, color: Colors.black), textAlign: TextAlign.center),
          Text(line3, style: TextStyle(fontSize: 18, color: Colors.black), textAlign: TextAlign.center),
          Text(line4, style: TextStyle(fontSize: 18, color: Colors.black), textAlign: TextAlign.center),
        ],
      ),
    );
  }
} 