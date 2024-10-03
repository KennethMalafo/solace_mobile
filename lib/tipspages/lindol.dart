import 'package:flutter/material.dart';

class LindolGuide extends StatelessWidget {
  const LindolGuide({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 
        const Text(
          'LINDOL', 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
          ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.blue[100],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                'LINDOL',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.center,
              ),
            ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue[300],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Ang LINDOL ay biglaang paggalaw o pagyanig ng lupa dulot ng mabilis na pagpapakawala ng enerhiya mula sa nagbabanggaang tectonic plates. \n\n'
                  'Tinataya may higit sa isang milyong lindol ang naitatala sa loob ng isang taon. Kahit ang karamihan dito ay mahina lamang, may posibilidad pa ring magkaroon ng malakas at mapaminsalang lindol.\n\n'
                  'Ang ating bansa ay nabibilang sa rehiyon ng "Pacific Ring of Fire," kung saan mas maraming mapaminsalang lindol ang nagaganap.',
                  style: TextStyle(fontSize: 16, height: 1.5),
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'PAGHAHANDA BAGO ANG SAKUNA',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 15),
              // Preparedness tips with icons
              _buildTipWithIcon(
                icon: Icons.house,
                text:
                    '1. Alamin ang hazards at risks sa inyong tahanan, eskwelahan at lugar ng trabaho. Pag-usapan kung saan ang inyong magiging evacuation area.',
              ),
              _buildTipWithIcon(
                icon: Icons.warning_amber_rounded,
                text:
                    '2. Iwasang maglagay ng mabibigat na bagay sa mataas na lugar. Siguraduhin ang mga gamit ay bahay na may matibay na pagkakabit upang hindi matumba at magdulot ng kapinsalaan.',
              ),
              _buildTipWithIcon(
                icon: Icons.groups,
                text:
                    '3. Makiisa sa mga isinasagawang Earthquake Drills at Disaster Preparedness Sessions sa inyong lugar.',
              ),
              _buildTipWithIcon(
                icon: Icons.backpack,
                text:
                    '4. Siguraduhing handa ang inyong 72-hour Emergency Kit sa lugar na madali ninyong magtupanan.',
              ),
              _buildTipWithIcon(
                icon: Icons.family_restroom,
                text: '5. Pag-usapan ang inyong Family Disaster Plan.',
              ),
              const SizedBox(height: 20),
              // New section: Habang LUMILINDOL
              Center(
                child: Text(
                'Habang LUMILINDOL:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                  decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              // Single image for Drop, Cover, Hold
              Center(
                child: Image.asset(
                  'images/drop_cover_hold.png', // Replace with the path to your image
                  width: MediaQuery.of(context).size.width * 0.9, // Adjust width if needed
                ),
              ),
              const SizedBox(height: 20),
              // Additional tips for during the earthquake
              const Text(
                '• Drop, Cover & Hold. Manatili sa ganitong posisyon habang nagaganap ang pagyanig.\n\n'
                '• Hintayin tumigil ang pagyanig bago lumabas o lumikas.\n\n'
                '• Maging kalmado at huwag mag-panic.\n\n'
                '• Mahalagang maging alerto sa panahon ng lindol. Isipin ang pinakamadaling ruta upang makalabas ng ligtas.\n\n'
                '• Kung nagmamaneho o nasa loob ng umaandar na sasakyan, ihinto ang sasakyan sa isang ligtas na lugar.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              // New section: Pagkatapos ng LINDOL.
              Center(
                child: Text(
                'Pagkatapos ng LINDOL.:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[900],
                  decoration: TextDecoration.underline,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                '1. Tumungo sa isang ligtas na lugar sa labas ng mga gusali.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '2. Huwag tumakbo o sumigaw habang lumalabas ng bahay o gusali.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '3. Huwag gumamit ng elevator o escalator',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '4. Dalhin ang inyong72-hour Emergency Kit sa paglikas.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                "5. Manatili sa labas ng mga gusali hangga't makapagbigay abiso ang mga otoridad.",
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '6. Kung may pinsala ang mga gusali o inyong tahanan, huwag tangkain pang pumasok dito.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '7. Makinig at tumalima sa mga pagbibigay anunsiyo mula sa LDRRMC. Pag-usapan sa inyong tahanan ang inyong mga susunod na hakbang',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to create rows with icons and text
  Widget _buildTipWithIcon({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 40, color: Colors.orange), // Icon size and color
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
          ),
        ],
      ),
    );
  }
}