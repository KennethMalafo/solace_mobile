import 'package:flutter/material.dart';

class BagyoAtBaha extends StatelessWidget {
  const BagyoAtBaha({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: 
        const Text(
          'BAGYO AT BAHA', 
        style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // White back arrow
          onPressed: () => Navigator.of(context).pop(),
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
                  'Maging Handa: BAGYO at PAGBAHA',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[900],
                    decoration: TextDecoration.underline,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 5),
              const Text(
                'Maaaring magdulot ng pagbaha ang bagyo, dam release, high tide, habagat at storm surge.',
                style: TextStyle(fontSize: 16, height: 1.5, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ang Sta. Barbara ay:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                '1. Isa sa itinuturing na catch basin ng lalawigan ng Pangasinan. Nanggagaling ang baha mula sa malakas na pag-ulan at pag-apaw ng tubig sa Sinucalan River.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '2. Dumaranas ng may 6-7 bagyo bawat taon.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '3. Kadalasan din itong naaapektuhan ng HABAGAT.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 15),
              const Text(
                '4. Ito rin ang daanan ng mga tubig mula sa kabundukan sa pamamagitan ng Sinucalan River.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ang Municipal Disaster Risk Reduction and Management Office (MDRRMO) ay nakikipagtulungan sa iba\'t ibang ahensya ng pamahalaan tulad ng Philippine National Police, Bureau of Fire Protection at Department of Social Welfare and Development, Office of Civil Defense at Pangasinan Provincial DRRMO upang paghandaang ang mga kalamidad na darating sa ating bayan. Ang MDRRMO rin at mga kasamang ahensya ay nagtutulungan sa pagmamatyag at pagbibigay ng abiso sa mga mamamayan ukol sa mga weather disturbance na maaaring magdulot ng pagbaha.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              const Text(
                'Ang mga mamamayan ay hinihikayat na ugaling makinig sa lokal na himpilan ng mga radyo at telebisyon para sa mga opisyal na mga anunsyo mula sa mga kinauukulan.',
                style: TextStyle(fontSize: 16, height: 1.5),
              ),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Bago ang BAGYO O PAGBAHA',
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
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.backpack, size: 40, color: Colors.orange), // Icon 1
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '1. Ihanda ang inyong 72-hour Emergency Kit.',
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.family_restroom, size: 40, color: Colors.orange), // Icon 2
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '2. Pag-usapan ang inyong Family Disaster Plan.',
                      style: TextStyle(fontSize: 16, height: 1.5),
                    ),
                  ),
                ],
              ),
             const Text(
              "3. Tiyaking ligtas at matibay ang inyong tahanan at mga kagamitan.",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 15),
            const Text(
              "4. Kung nagbigay na ng babala sa pagdating ng bagyo - lumikas na sa mas mataas at ligtas na lugar dala ang inyong 72-hour Emergency Survival Kit.",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 15),
           const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.radio, size: 40, color: Colors.orange), // Icon 3
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '5. Patuloy din na mag-monitor ng latest updates ukol sa kalagayan ng panahon at abiso ng mga otoridad.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Center(
              child: Text(
               'Habang may BAGYO AT PAGBAHA',
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
            const Text(
              "1. Maging kalmado. Huwag mag-panic.",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 15),
            const Text(
              "2. Agad Sundin ang mga kinauukulan kapag naglabas na ng Evacuation Notice. Dalhin ang inyong 72-hour Emergency Kit.",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 15),
            const Text(
              "3. Siguraduhin naka off ang power source ng inyong kuryente at ang gas tanks.",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 15),
            const Text(
              "4. Kung na-stranded sa isang mataas na lugar, huwag nang subukan pang lumusong sa baha.",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 15),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Icon(Icons.pool, size: 40, color: Colors.blue),  // Swimming icon
                    Icon(Icons.not_interested, size: 50, color: Colors.red),  // No swimming overlay
                  ],
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '5. Huwag subukang lumangoy sa tubig-baha - kahit ang hanggang tuhod lamang na baha ay mapanganib na.',
                    style: TextStyle(fontSize: 16, height: 1.5),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            const Center(
              child: Text(
               'SAFETY FIRST!',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                  decoration: TextDecoration.underline,
                ),
                  textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 15),
            const Text(
              "1. Hintayin ang abiso ng mga kinauukulan bago bumalik sa inyong mga tahanan.",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 15),
            const Text(
              "2. Magsuot ng protective gear - bota, rubber gowns, long pants - sa paglilinis ng inyong bahay.",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 15),
            const Text(
              "3. Sigurahing tuyo at ligtas ang mga electrical outlet at switch bago muling gamitin.",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 15),
            const Text(
              "4. Maging alerto sa mga ahas at iba pang hayop na maaaring nadala ng tubig baha.",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 15),
            const Text(
              "5. Pakuluin o gamitan ng water treatment ang inyong inuming tubig. Itapon na ang mga gamot, packed foods at inumin na nalublob sa baha.",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            const SizedBox(height: 15),
            const Text(
              "6. I-report din sa mga kinauukulan ang mga pinsala na nangyari sa inyong kapaligiran.",
              style: TextStyle(fontSize: 16, color: Colors.black),
            ),
            ],
          ),
        ),
      ),
    );
  }
}
