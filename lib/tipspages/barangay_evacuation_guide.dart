import 'package:flutter/material.dart';

class BarangayEvacuationGuide extends StatelessWidget {
  const BarangayEvacuationGuide({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 
        const Text(
          'BARANGAY EVACUATION GUIDE', 
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)
          ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back arrow
          onPressed: () => Navigator.of(context).pop(),
        ), // AppBar color
      ),
      backgroundColor: Colors.blue[100], // Background color of the page
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'SA UNANG ABISO SA NAPIPINTONG PAGBAHA, DAPAT MAGING ALERTO',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                    decoration: TextDecoration.underline, // Adding underline
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // Evacuation steps as numbered list
              const Text(
                '1. Ipinaparatang ang unang ABISO sa mga binabahang mga barangay na malapit sa ilog at mabababang lugar sa Sta. Barbara.',
                style: TextStyle(fontSize: 16, height: 1.5), // Adjust line height
              ),
              const SizedBox(height: 15),
              const Text(
                '2. Ugaling makinig sa radyo at manood ng telebisyon para malaman ang pinakasariwang ulat-panahon mula sa PAGASA. Maghintay din sa mga susunod na anunsiyo mula sa Municipal Disaster Risk Reduction and Management Office (MDRRMO).',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '3. Ang mga namamahala sa Evacuation Center ay ihahanda na ang Center para sa mga lilikas.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '4. Sasabihan ang Barangay Disaster Risk Reduction and Management Committee (BDRRMC) at General Services Office (GSO) ay ihahanda ang mga kailangan sa evacuation center at titiyakin na ang mga sasakyan ay laging nasa good running condition. Hihintayin ang susunod na abiso ng MDRRMO.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '5. Ang mga HEPE ng Kapulisan at Bureau of Fire Protection, ang nakatalaga upang tumingin sa seguridad ng buong bayan. Kailangan din na laging handa at hintayin ang mga susunod na anunsyo ng MDRRMO.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '6. Ang Municipal Social Welfare and Development (MSWD) ang nakatalaga sa Paghahanda ng relief goods at evacuation center.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '7. Ang Municipal Health Office (MHO) o Rural Health Unit (RHU) ang siyang nakatalaga sa pag-inbentaryo ng gamot na maaaring kailanganin ng mga evacuees.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '8. Ang Municipal Treasurer ang siyang nakatalaga na maghanda ng kaukulang pondo para sa mga supplies na kakailanganin.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              const Text(
                '9. Ang Engineering Office at Agriculture Office ay laging nakahanda at hihintayin ang susunod na abiso mula sa MDRRMO.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              Center(
                child: Text(
                  'PANGALAWANG ABISO NG PAGBAHA. PAGHAHANDA SA POSIBLENG PAGLIKAS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                    decoration: TextDecoration.underline, // Adding underline
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // Evacuation steps as numbered list
              const Text(
                '1. Ipaparating ang pangalawang abisong pagbaha sa mga barangay na malapit sa ilog at sa mga mabababang lugar.',
                style: TextStyle(fontSize: 16, height: 1.5), // Adjust line height
              ),
              const SizedBox(height: 15),
              const Text(
                '2. Ang mga leader na nakatalaga sa evacuation center ay sasabihan na mayroon ng pangalawang abiso. Ang mga mamamayan sa apektadong lugar ay pinapayuhan na maghanda para sa posibleng paglikas. Hintayin ang susunod na abiso ng MDRRMO.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '3. Ang Municipal Engineering Office, Kapulisan at MDRRMO ay magsasagawa ng cleaning operations sa mga kalsada kung may mga nakaharang o mga natumbang mga puno upang mapabilis ang gagawing paglikas.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '4. Ihahanda ng MSWD ang mga relief goods para sa mga apektadong mamamayan.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '5. Ang MHO/RHU, Municipal Nutrition Action Officer (MNAO) at Barangay Health Workers(BHW) ang maghahanda para sa kakailanganing medical para sa apektadong mamamamayan.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '6. Ang MHO/RHU ay pupunta sa evacuation center para gumawa ng Rapid Assessment on Health sa mga apektadong mga mamamayan.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '7. Ihahanda ang mga kagamitan sa pagtulong sa mga nasira ng kalamidad.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '8. Ihananda ang mga kagamitan sa Search and Rescue Operations.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              Center(
                child: Text(
                  'PANGATLONG PAG-ABISO SA PAGBAHA (PAGLIKAS/PAG-EVACUATE)',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                    decoration: TextDecoration.underline, // Adding underline
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // Evacuation steps as numbered list
              const Text(
                '1. Paparating ang pangatlong abisong pagbaha sa mga barangay na malapit sa ilog at sa mga mabababang lugar.',
                style: TextStyle(fontSize: 16, height: 1.5), // Adjust line height
              ),
              const SizedBox(height: 15),
              const Text(
                '2. Ang mga tagapamahala sa evacuation center ay aalamin ang mga maapektuhang mga barangay para sa ibayong paghananda ng kakailanganin sa evacuation center.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '3. Ang Municipal Engineering Office, Kapulisan at MDRRMO ay magsasagawa ng clearing operations sa mga kalsada kung may mga nakaharang o mga natumbang mga puno upang mapabilis ang gagawing paglikas.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '4. Ang MDRRMO, MSWD at BHW ay magtutulong-tulong sa paghahanda at pamimigay ng mga relief goods at aalamin kung sinu-sino ang mga nararapat bigyan.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '5. Magsasagawa ang MHO/RHU ng Rapid Assessment on Health sa mga evacuation center upang alamin ang kalusugan ng mga lumikas.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '6. hahanda ang mga kagamitan para sa pagsalba ng buhay.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '7. Ihahanda ng Municipal Treasury ang kaukulang pondo para sa Disaster Operations.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              Center(
                child: Text(
                  'PAGKATAPOS NG BAHA',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                    decoration: TextDecoration.underline, // Adding underline
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 20),
              // Evacuation steps as numbered list
              const Text(
                '1. Kapag wala nang Typhoon Signal mula sa PAGASA, ia-assess ng kinauukulan kung pwede nang bumalik ang mga lumikas na residente sa kanilang mga tahanan.',
                style: TextStyle(fontSize: 16, height: 1.5), // Adjust line height
              ),
              const SizedBox(height: 15),
              const Text(
                '2. Kapag wala nang Peligro, ang mga nasa evacuation center ay ihahatid ng MDRRMO sa kanilang mga tahanan ngunit kung may banta pa ng panganib, mananatili pa sa evacuation center ang mga apektadong mamamayan at hintayin ang abiso mula sa MDRRMO.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '3. Magbibigay ang MSWD sa MDRRMO ng mga talaan ng mga evacuess at mga nabigyan ng relief goods.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '4. Ang mga evacuees ay inaasahang lilinisan ang tinirahang evacuation center bago nila ito iwanan.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '5. Magbibigay ng talaan ang Municipal Engineering Office sa MDRRMO ng mga nasirang imprastraktura.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '6. Magbibigay ng talaan ang Municipal Agriculture Office sa MDRRMO ng mga nasira at napinsalang mga pananim.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '7. Ang MDRRMO ay gagawa ng terminal report at ipapasa sa Pangasinan Provincial Disaster Risk Reduction and Management Office, sa Office of Civil Defense - RO1 at sa Department of Interior and Local Government-Pangasinan.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '8. Magpapasa rin ng report ang MDRRMO sa Provincial Government Office at sa Provincial Planning and Development Office para sa Kaukulang tutong sa rehabilitasyon.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
