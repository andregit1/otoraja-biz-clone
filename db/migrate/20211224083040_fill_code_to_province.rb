class FillCodeToProvince < ActiveRecord::Migration[5.2]
  def change
    regencies = [
      {
        "id": 1,
        "name": "Aceh Besar",
        "code": "1106"
      },
      {
        "id": 2,
        "name": "Aceh Jaya",
        "code": "1114"
      },
      {
        "id": 3,
        "name": "Aceh Singkil",
        "code": "1110"
      },
      {
        "id": 4,
        "name": "Aceh Tamiang",
        "code": "1116"
      },
      {
        "id": 5,
        "name": "Bener Meriah",
        "code": "1117"
      },
      {
        "id": 6,
        "name": "Bireuën",
        "code": "1111"
      },
      {
        "id": 7,
        "name": "Aceh Tengah",
        "code": "1104"
      },
      {
        "id": 8,
        "name": "Aceh Timur",
        "code": "1103"
      },
      {
        "id": 9,
        "name": "Gayo Lues",
        "code": "1113"
      },
      {
        "id": 10,
        "name": "Nagan Raya",
        "code": "1115"
      },
      {
        "id": 11,
        "name": "Aceh Utara",
        "code": "1108"
      },
      {
        "id": 12,
        "name": "Pidie",
        "code": "1107"
      },
      {
        "id": 13,
        "name": "Pidie Jaya",
        "code": "1118"
      },
      {
        "id": 14,
        "name": "Simeulue",
        "code": "1109"
      },
      {
        "id": 15,
        "name": "Aceh Selatan",
        "code": "1101"
      },
      {
        "id": 16,
        "name": "Aceh Tenggara",
        "code": "1102"
      },
      {
        "id": 17,
        "name": "Aceh Barat Daya",
        "code": "1112"
      },
      {
        "id": 18,
        "name": "Aceh Barat",
        "code": nil
      },
      {
        "id": 19,
        "name": "Banda Aceh",
        "code": "1171"
      },
      {
        "id": 20,
        "name": "Langsa",
        "code": "1174"
      },
      {
        "id": 21,
        "name": "Lhokseumawe",
        "code": "1173"
      },
      {
        "id": 22,
        "name": "Sabang",
        "code": "1172"
      },
      {
        "id": 23,
        "name": "Subulussalam",
        "code": "1175"
      },
      {
        "id": 24,
        "name": "Asahan",
        "code": "1209"
      },
      {
        "id": 25,
        "name": "Batubara",
        "code": nil
      },
      {
        "id": 26,
        "name": "Tapanuli Tengah",
        "code": "1201"
      },
      {
        "id": 27,
        "name": "Dairi",
        "code": "1211"
      },
      {
        "id": 28,
        "name": "Deli Serdang",
        "code": "1207"
      },
      {
        "id": 29,
        "name": "Humbang Hasundutan",
        "code": "1216"
      },
      {
        "id": 30,
        "name": "Karo",
        "code": "1206"
      },
      {
        "id": 31,
        "name": "Labuhan Batu",
        "code": nil
      },
      {
        "id": 32,
        "name": "Langkat",
        "code": "1205"
      },
      {
        "id": 33,
        "name": "Mandailing Natal",
        "code": "1213"
      },
      {
        "id": 34,
        "name": "Nias",
        "code": "1204"
      },
      {
        "id": 35,
        "name": "Labuhan Batu Utara",
        "code": nil
      },
      {
        "id": 36,
        "name": "Nias Utara",
        "code": "1224"
      },
      {
        "id": 37,
        "name": "Lawas Padang Utara",
        "code": nil
      },
      {
        "id": 38,
        "name": "Tapanuli Utara",
        "code": "1202"
      },
      {
        "id": 39,
        "name": "Padang Lawas",
        "code": "1221"
      },
      {
        "id": 40,
        "name": "Pakpak Bharat",
        "code": "1215"
      },
      {
        "id": 41,
        "name": "Samosir",
        "code": "1217"
      },
      {
        "id": 42,
        "name": "Serdang Bedagai",
        "code": "1218"
      },
      {
        "id": 43,
        "name": "Simalungun",
        "code": "1208"
      },
      {
        "id": 44,
        "name": "Labuhan Batu Selatan",
        "code": nil
      },
      {
        "id": 45,
        "name": "Nias Selatan",
        "code": "1214"
      },
      {
        "id": 46,
        "name": "Tapanuli Selatan",
        "code": "1203"
      },
      {
        "id": 47,
        "name": "Toba Samosir",
        "code": "1212"
      },
      {
        "id": 48,
        "name": "Nias Barat",
        "code": "1225"
      },
      {
        "id": 49,
        "name": "Binjai",
        "code": "1275"
      },
      {
        "id": 50,
        "name": "Gunungsitoli",
        "code": "1278"
      },
      {
        "id": 51,
        "name": "Medan",
        "code": "1271"
      },
      {
        "id": 52,
        "name": "Padang Sidempuan",
        "code": "1277"
      },
      {
        "id": 53,
        "name": "Pematangsiantar",
        "code": "1272"
      },
      {
        "id": 54,
        "name": "Sibolga",
        "code": "1273"
      },
      {
        "id": 55,
        "name": "Tanjung Balai",
        "code": "1274"
      },
      {
        "id": 56,
        "name": "Tebing Tinggi",
        "code": "1276"
      },
      {
        "id": 57,
        "name": "Agam",
        "code": "1306"
      },
      {
        "id": 58,
        "name": "Dharmasraya",
        "code": "1310"
      },
      {
        "id": 59,
        "name": "Lima Puluh Kota",
        "code": "1307"
      },
      {
        "id": 60,
        "name": "Kepulauan Mentawai",
        "code": "1309"
      },
      {
        "id": 61,
        "name": "Padang Pariaman",
        "code": "1305"
      },
      {
        "id": 62,
        "name": "Pasaman",
        "code": "1308"
      },
      {
        "id": 63,
        "name": "Sijunjung",
        "code": "1303"
      },
      {
        "id": 64,
        "name": "Solok",
        "code": "1302"
      },
      {
        "id": 65,
        "name": "Pesisir Selatan",
        "code": "1301"
      },
      {
        "id": 66,
        "name": "Solok Selatan",
        "code": "1311"
      },
      {
        "id": 67,
        "name": "Tanah Datar",
        "code": "1304"
      },
      {
        "id": 68,
        "name": "Pasaman Barat",
        "code": "1312"
      },
      {
        "id": 69,
        "name": "Bukittinggi",
        "code": "1375"
      },
      {
        "id": 70,
        "name": "Padang",
        "code": "1371"
      },
      {
        "id": 71,
        "name": "Padang Panjang",
        "code": "1374"
      },
      {
        "id": 72,
        "name": "Pariaman",
        "code": "1377"
      },
      {
        "id": 73,
        "name": "Payakumbuh",
        "code": "1376"
      },
      {
        "id": 74,
        "name": "Sawahlunto",
        "code": "1373"
      },
      {
        "id": 75,
        "name": "Solok",
        "code": "1372"
      },
      {
        "id": 76,
        "name": "Batang Hari",
        "code": nil
      },
      {
        "id": 77,
        "name": "Bungo",
        "code": "1508"
      },
      {
        "id": 78,
        "name": "Kerinci",
        "code": "1501"
      },
      {
        "id": 79,
        "name": "Merangin",
        "code": "1502"
      },
      {
        "id": 80,
        "name": "Muaro Jambi",
        "code": "1505"
      },
      {
        "id": 81,
        "name": "Sarolangun",
        "code": "1503"
      },
      {
        "id": 82,
        "name": "Tanjung Jabung Timur",
        "code": "1507"
      },
      {
        "id": 83,
        "name": "Tanjung Jabung Barat",
        "code": "1506"
      },
      {
        "id": 84,
        "name": "Tebo",
        "code": "1509"
      },
      {
        "id": 85,
        "name": "Jambi",
        "code": "1571"
      },
      {
        "id": 86,
        "name": "Sungai Penuh",
        "code": "1572"
      },
      {
        "id": 87,
        "name": "Bengkalis",
        "code": "1403"
      },
      {
        "id": 88,
        "name": "Indragiri Hilir",
        "code": "1404"
      },
      {
        "id": 89,
        "name": "Indragiri Hulu",
        "code": "1402"
      },
      {
        "id": 90,
        "name": "Kampar",
        "code": "1401"
      },
      {
        "id": 91,
        "name": "Kuantan Singingi",
        "code": "1409"
      },
      {
        "id": 92,
        "name": "Kepulauan Meranti",
        "code": "1410"
      },
      {
        "id": 93,
        "name": "Pelalawan",
        "code": "1405"
      },
      {
        "id": 94,
        "name": "Rokan Hulu",
        "code": "1406"
      },
      {
        "id": 95,
        "name": "Rokan Hilir",
        "code": "1407"
      },
      {
        "id": 96,
        "name": "Siak",
        "code": "1408"
      },
      {
        "id": 97,
        "name": "Dumai",
        "code": "1472"
      },
      {
        "id": 98,
        "name": "Pekanbaru",
        "code": "1471"
      },
      {
        "id": 99,
        "name": "Bengkulu tengah",
        "code": "1709"
      },
      {
        "id": 100,
        "name": "Kaur",
        "code": "1704"
      },
      {
        "id": 101,
        "name": "Kepahiang",
        "code": "1708"
      },
      {
        "id": 102,
        "name": "Lebong",
        "code": "1707"
      },
      {
        "id": 103,
        "name": "Muko-Muko",
        "code": nil
      },
      {
        "id": 104,
        "name": "Bengkulu Utara",
        "code": "1703"
      },
      {
        "id": 105,
        "name": "Rejang Lebong",
        "code": "1702"
      },
      {
        "id": 106,
        "name": "Seluma",
        "code": "1705"
      },
      {
        "id": 107,
        "name": "Bengkulu Selatan",
        "code": "1701"
      },
      {
        "id": 108,
        "name": "Bengkulu",
        "code": "1771"
      },
      {
        "id": 109,
        "name": "Banyuasin",
        "code": "1607"
      },
      {
        "id": 110,
        "name": "Ogan Komering Ulu Timur",
        "code": "1608"
      },
      {
        "id": 111,
        "name": "Empat Lawang",
        "code": "1611"
      },
      {
        "id": 112,
        "name": "Lahat",
        "code": "1604"
      },
      {
        "id": 113,
        "name": "Muara Enim",
        "code": "1603"
      },
      {
        "id": 114,
        "name": "Musi Banyuasin",
        "code": "1606"
      },
      {
        "id": 115,
        "name": "Musi Rawas",
        "code": "1605"
      },
      {
        "id": 116,
        "name": "Musi Rawas Utara",
        "code": "1613"
      },
      {
        "id": 117,
        "name": "Ogan Ilir",
        "code": "1610"
      },
      {
        "id": 118,
        "name": "Ogan Komering Ilir",
        "code": "1602"
      },
      {
        "id": 119,
        "name": "Ogan Komering Ulu",
        "code": nil
      },
      {
        "id": 120,
        "name": "Penukal Abab Lematang Ilir",
        "code": "1612"
      },
      {
        "id": 121,
        "name": "Ogan Komering Ulu Selatan",
        "code": "1609"
      },
      {
        "id": 122,
        "name": "Lubuklinggau",
        "code": nil
      },
      {
        "id": 123,
        "name": "Pagar Alam",
        "code": "1672"
      },
      {
        "id": 124,
        "name": "Palembang",
        "code": "1671"
      },
      {
        "id": 125,
        "name": "Prabumulih",
        "code": "1674"
      },
      {
        "id": 126,
        "name": "Lampung Tengah",
        "code": "1802"
      },
      {
        "id": 127,
        "name": "Lampung Timur",
        "code": "1807"
      },
      {
        "id": 128,
        "name": "Mesuji",
        "code": "1811"
      },
      {
        "id": 129,
        "name": "Lampung Utara",
        "code": "1803"
      },
      {
        "id": 130,
        "name": "Pesawaran",
        "code": "1809"
      },
      {
        "id": 131,
        "name": "Pringsewu",
        "code": "1810"
      },
      {
        "id": 132,
        "name": "Lampung Selatan",
        "code": "1801"
      },
      {
        "id": 133,
        "name": "Tanggamus",
        "code": "1806"
      },
      {
        "id": 134,
        "name": "Tulang Bawang",
        "code": "1805"
      },
      {
        "id": 135,
        "name": "Way Kanan",
        "code": "1808"
      },
      {
        "id": 136,
        "name": "Lampung Barat",
        "code": "1804"
      },
      {
        "id": 137,
        "name": "Pesisir Barat",
        "code": "1813"
      },
      {
        "id": 138,
        "name": "Tulang Bawang Barat",
        "code": "1812"
      },
      {
        "id": 139,
        "name": "Bandar Lampung",
        "code": "1871"
      },
      {
        "id": 140,
        "name": "Metro",
        "code": "1872"
      },
      {
        "id": 141,
        "name": "Bangka",
        "code": "1901"
      },
      {
        "id": 142,
        "name": "Belitung",
        "code": "1902"
      },
      {
        "id": 143,
        "name": "Bangka Tengah",
        "code": "1904"
      },
      {
        "id": 144,
        "name": "Belitung Timur",
        "code": "1906"
      },
      {
        "id": 145,
        "name": "Bangka Selatan",
        "code": "1903"
      },
      {
        "id": 146,
        "name": "Bangka Barat",
        "code": "1905"
      },
      {
        "id": 147,
        "name": "Pangkalpinang",
        "code": nil
      },
      {
        "id": 148,
        "name": "Kepulauan Anambas",
        "code": "2105"
      },
      {
        "id": 149,
        "name": "Bintan",
        "code": "2101"
      },
      {
        "id": 150,
        "name": "Karimun",
        "code": "2102"
      },
      {
        "id": 151,
        "name": "Lingga",
        "code": "2104"
      },
      {
        "id": 152,
        "name": "Natuna",
        "code": "2103"
      },
      {
        "id": 153,
        "name": "Batam",
        "code": "2171"
      },
      {
        "id": 154,
        "name": "Tanjungpinang",
        "code": nil
      },
      {
        "id": 155,
        "name": "Kepulauan Seribu",
        "code": nil
      },
      {
        "id": 156,
        "name": "Jakarta Pusat",
        "code": "3171"
      },
      {
        "id": 157,
        "name": "Jakarta Timur",
        "code": "3175"
      },
      {
        "id": 158,
        "name": "Jakarta Utara",
        "code": "3172"
      },
      {
        "id": 159,
        "name": "Jakarta Selatan",
        "code": "3174"
      },
      {
        "id": 160,
        "name": "Jakarta Barat",
        "code": "3173"
      },
      {
        "id": 161,
        "name": "Lebak",
        "code": "3602"
      },
      {
        "id": 162,
        "name": "Pandeglang",
        "code": "3601"
      },
      {
        "id": 163,
        "name": "Serang",
        "code": "3604"
      },
      {
        "id": 164,
        "name": "Tangerang",
        "code": "3603"
      },
      {
        "id": 165,
        "name": "Cilegon",
        "code": "3672"
      },
      {
        "id": 166,
        "name": "Serang",
        "code": "3673"
      },
      {
        "id": 167,
        "name": "Tangerang",
        "code": "3671"
      },
      {
        "id": 168,
        "name": "Tangerang Selatan",
        "code": "3674"
      },
      {
        "id": 169,
        "name": "Bandung",
        "code": "3204"
      },
      {
        "id": 170,
        "name": "Bekasi",
        "code": "3216"
      },
      {
        "id": 171,
        "name": "Bogor",
        "code": "3201"
      },
      {
        "id": 172,
        "name": "Ciamis",
        "code": "3207"
      },
      {
        "id": 173,
        "name": "Cianjur",
        "code": "3203"
      },
      {
        "id": 174,
        "name": "Cirebon",
        "code": "3209"
      },
      {
        "id": 175,
        "name": "Garut",
        "code": "3205"
      },
      {
        "id": 176,
        "name": "Indramayu",
        "code": "3212"
      },
      {
        "id": 177,
        "name": "Karawang",
        "code": "3215"
      },
      {
        "id": 178,
        "name": "Kuningan",
        "code": "3208"
      },
      {
        "id": 179,
        "name": "Majalengka",
        "code": "3210"
      },
      {
        "id": 180,
        "name": "Pangandaran",
        "code": "3218"
      },
      {
        "id": 181,
        "name": "Purwakarta",
        "code": "3214"
      },
      {
        "id": 182,
        "name": "Subang",
        "code": "3213"
      },
      {
        "id": 183,
        "name": "Sukabumi",
        "code": "3202"
      },
      {
        "id": 184,
        "name": "Sumedang",
        "code": "3211"
      },
      {
        "id": 185,
        "name": "Tasikmalaya",
        "code": "3206"
      },
      {
        "id": 186,
        "name": "Bandung Barat",
        "code": "3217"
      },
      {
        "id": 187,
        "name": "Bandung",
        "code": "3273"
      },
      {
        "id": 188,
        "name": "Banjar",
        "code": "3279"
      },
      {
        "id": 189,
        "name": "Bekasi",
        "code": "3275"
      },
      {
        "id": 190,
        "name": "Bogor",
        "code": "3271"
      },
      {
        "id": 191,
        "name": "Cimahi",
        "code": "3277"
      },
      {
        "id": 192,
        "name": "Cirebon",
        "code": "3274"
      },
      {
        "id": 193,
        "name": "Depok",
        "code": "3276"
      },
      {
        "id": 194,
        "name": "Sukabumi",
        "code": "3272"
      },
      {
        "id": 195,
        "name": "Tasikmalaya",
        "code": "3278"
      },
      {
        "id": 196,
        "name": "Banjarnegara",
        "code": "3304"
      },
      {
        "id": 197,
        "name": "Banyumas",
        "code": "3302"
      },
      {
        "id": 198,
        "name": "Batang",
        "code": "3325"
      },
      {
        "id": 199,
        "name": "Blora",
        "code": "3316"
      },
      {
        "id": 200,
        "name": "Boyolali",
        "code": "3309"
      },
      {
        "id": 201,
        "name": "Brebes",
        "code": "3329"
      },
      {
        "id": 202,
        "name": "Cilacap",
        "code": "3301"
      },
      {
        "id": 203,
        "name": "Demak",
        "code": "3321"
      },
      {
        "id": 204,
        "name": "Grobogan",
        "code": "3315"
      },
      {
        "id": 205,
        "name": "Jepara",
        "code": "3320"
      },
      {
        "id": 206,
        "name": "Karanganyar",
        "code": "3313"
      },
      {
        "id": 207,
        "name": "Kebumen",
        "code": "3305"
      },
      {
        "id": 208,
        "name": "Kendal",
        "code": "3324"
      },
      {
        "id": 209,
        "name": "Klaten",
        "code": "3310"
      },
      {
        "id": 210,
        "name": "Kudus",
        "code": "3319"
      },
      {
        "id": 211,
        "name": "Magelang",
        "code": "3308"
      },
      {
        "id": 212,
        "name": "Pati",
        "code": "3318"
      },
      {
        "id": 213,
        "name": "Pekalongan",
        "code": "3326"
      },
      {
        "id": 214,
        "name": "Pemalang",
        "code": "3327"
      },
      {
        "id": 215,
        "name": "Purbalingga",
        "code": "3303"
      },
      {
        "id": 216,
        "name": "Purworejo",
        "code": "3306"
      },
      {
        "id": 217,
        "name": "Rembang",
        "code": "3317"
      },
      {
        "id": 218,
        "name": "Semarang",
        "code": "3322"
      },
      {
        "id": 219,
        "name": "Sragen",
        "code": "3314"
      },
      {
        "id": 220,
        "name": "Sukoharjo",
        "code": "3311"
      },
      {
        "id": 221,
        "name": "Tegal",
        "code": "3328"
      },
      {
        "id": 222,
        "name": "Temanggung",
        "code": "3323"
      },
      {
        "id": 223,
        "name": "Wonogiri",
        "code": "3312"
      },
      {
        "id": 224,
        "name": "Wonosobo",
        "code": "3307"
      },
      {
        "id": 225,
        "name": "Magelang",
        "code": "3371"
      },
      {
        "id": 226,
        "name": "Surakarta",
        "code": "3372"
      },
      {
        "id": 227,
        "name": "Salatiga",
        "code": "3373"
      },
      {
        "id": 228,
        "name": "Semarang",
        "code": "3374"
      },
      {
        "id": 229,
        "name": "Pekalongan",
        "code": "3375"
      },
      {
        "id": 230,
        "name": "Tegal",
        "code": "3376"
      },
      {
        "id": 231,
        "name": "Bangkalan",
        "code": "3526"
      },
      {
        "id": 232,
        "name": "Banyuwangi",
        "code": "3510"
      },
      {
        "id": 233,
        "name": "Blitar",
        "code": "3505"
      },
      {
        "id": 234,
        "name": "Bojonegoro",
        "code": "3522"
      },
      {
        "id": 235,
        "name": "Bondowoso",
        "code": "3511"
      },
      {
        "id": 236,
        "name": "Gresik",
        "code": "3525"
      },
      {
        "id": 237,
        "name": "Jember",
        "code": "3509"
      },
      {
        "id": 238,
        "name": "Jombang",
        "code": "3517"
      },
      {
        "id": 239,
        "name": "Kediri",
        "code": "3506"
      },
      {
        "id": 240,
        "name": "Lamongan",
        "code": "3524"
      },
      {
        "id": 241,
        "name": "Lumajang",
        "code": "3508"
      },
      {
        "id": 242,
        "name": "Madiun",
        "code": "3519"
      },
      {
        "id": 243,
        "name": "Magetan",
        "code": "3520"
      },
      {
        "id": 244,
        "name": "Malang",
        "code": "3507"
      },
      {
        "id": 245,
        "name": "Mojokerto",
        "code": "3516"
      },
      {
        "id": 246,
        "name": "Nganjuk",
        "code": "3518"
      },
      {
        "id": 247,
        "name": "Ngawi",
        "code": "3521"
      },
      {
        "id": 248,
        "name": "Pacitan",
        "code": "3501"
      },
      {
        "id": 249,
        "name": "Pamekasan",
        "code": "3528"
      },
      {
        "id": 250,
        "name": "Pasuruan",
        "code": "3514"
      },
      {
        "id": 251,
        "name": "Ponorogo",
        "code": "3502"
      },
      {
        "id": 252,
        "name": "Probolinggo",
        "code": "3513"
      },
      {
        "id": 253,
        "name": "Sampang",
        "code": "3527"
      },
      {
        "id": 254,
        "name": "Sidoarjo",
        "code": "3515"
      },
      {
        "id": 255,
        "name": "Situbondo",
        "code": "3512"
      },
      {
        "id": 256,
        "name": "Sumenep",
        "code": "3529"
      },
      {
        "id": 257,
        "name": "Trenggalek",
        "code": "3503"
      },
      {
        "id": 258,
        "name": "Tuban",
        "code": "3523"
      },
      {
        "id": 259,
        "name": "Tulungagung",
        "code": "3504"
      },
      {
        "id": 260,
        "name": "Batu",
        "code": "3579"
      },
      {
        "id": 261,
        "name": "Blitar",
        "code": "3572"
      },
      {
        "id": 262,
        "name": "Kediri",
        "code": "3571"
      },
      {
        "id": 263,
        "name": "Madiun",
        "code": "3577"
      },
      {
        "id": 264,
        "name": "Malang",
        "code": "3573"
      },
      {
        "id": 265,
        "name": "Mojokerto",
        "code": "3576"
      },
      {
        "id": 266,
        "name": "Pasuruan",
        "code": "3575"
      },
      {
        "id": 267,
        "name": "Probolinggo",
        "code": "3574"
      },
      {
        "id": 268,
        "name": "Surabaya",
        "code": "3578"
      },
      {
        "id": 269,
        "name": "Bantul",
        "code": "3402"
      },
      {
        "id": 270,
        "name": "Gunung Kidul",
        "code": nil
      },
      {
        "id": 271,
        "name": "Kulon Progo",
        "code": "3401"
      },
      {
        "id": 272,
        "name": "Sleman",
        "code": "3404"
      },
      {
        "id": 273,
        "name": "Yogyakarta",
        "code": "3471"
      },
      {
        "id": 274,
        "name": "Badung",
        "code": "5103"
      },
      {
        "id": 275,
        "name": "Bangli",
        "code": "5106"
      },
      {
        "id": 276,
        "name": "Buleleng",
        "code": "5108"
      },
      {
        "id": 277,
        "name": "Gianyar",
        "code": "5104"
      },
      {
        "id": 278,
        "name": "Jembrana",
        "code": "5101"
      },
      {
        "id": 279,
        "name": "Karangasem",
        "code": "5107"
      },
      {
        "id": 280,
        "name": "Klungkung",
        "code": "5105"
      },
      {
        "id": 281,
        "name": "Tabanan",
        "code": "5102"
      },
      {
        "id": 282,
        "name": "Denpasar",
        "code": "5171"
      },
      {
        "id": 283,
        "name": "Bima",
        "code": "5206"
      },
      {
        "id": 284,
        "name": "Lombok Tengah",
        "code": "5202"
      },
      {
        "id": 285,
        "name": "Dompu",
        "code": "5205"
      },
      {
        "id": 286,
        "name": "Lombok Timur",
        "code": "5203"
      },
      {
        "id": 287,
        "name": "Lombok Utara",
        "code": "5208"
      },
      {
        "id": 288,
        "name": "Sumbawa",
        "code": "5204"
      },
      {
        "id": 289,
        "name": "Lombok Barat",
        "code": "5201"
      },
      {
        "id": 290,
        "name": "Sumbawa Barat",
        "code": "5207"
      },
      {
        "id": 291,
        "name": "Mataram",
        "code": "5271"
      },
      {
        "id": 292,
        "name": "Bima",
        "code": "5272"
      },
      {
        "id": 293,
        "name": "Alor",
        "code": "5305"
      },
      {
        "id": 294,
        "name": "Belu",
        "code": "5304"
      },
      {
        "id": 295,
        "name": "Sumba Tengah",
        "code": "5317"
      },
      {
        "id": 296,
        "name": "Flores Timur",
        "code": "5306"
      },
      {
        "id": 297,
        "name": "Manggarai Timur",
        "code": "5319"
      },
      {
        "id": 298,
        "name": "Sumba Timur",
        "code": "5311"
      },
      {
        "id": 299,
        "name": "Ende",
        "code": "5308"
      },
      {
        "id": 300,
        "name": "Kupang",
        "code": "5301"
      },
      {
        "id": 301,
        "name": "Lembata",
        "code": "5313"
      },
      {
        "id": 302,
        "name": "Malaka",
        "code": "5321"
      },
      {
        "id": 303,
        "name": "Manggarai",
        "code": nil
      },
      {
        "id": 304,
        "name": "Nagekeo",
        "code": "5316"
      },
      {
        "id": 305,
        "name": "Ngada",
        "code": "5309"
      },
      {
        "id": 306,
        "name": "Timor Tengah Utara",
        "code": "5303"
      },
      {
        "id": 307,
        "name": "Rote Ndao",
        "code": "5314"
      },
      {
        "id": 308,
        "name": "Sabu Raijua",
        "code": "5320"
      },
      {
        "id": 309,
        "name": "Sikka",
        "code": "5307"
      },
      {
        "id": 310,
        "name": "Timor Tengah Selatan",
        "code": "5302"
      },
      {
        "id": 311,
        "name": "Sumba Barat Daya",
        "code": "5318"
      },
      {
        "id": 312,
        "name": "Manggarai Barat",
        "code": "5315"
      },
      {
        "id": 313,
        "name": "Sumba Barat",
        "code": nil
      },
      {
        "id": 314,
        "name": "Kupang",
        "code": "5371"
      },
      {
        "id": 315,
        "name": "Bengkayang",
        "code": "6107"
      },
      {
        "id": 316,
        "name": "Kapuas Hulu",
        "code": "6106"
      },
      {
        "id": 317,
        "name": "Kayong Utara",
        "code": "6111"
      },
      {
        "id": 318,
        "name": "Ketapang",
        "code": "6104"
      },
      {
        "id": 319,
        "name": "Kubu Raya",
        "code": "6112"
      },
      {
        "id": 320,
        "name": "Landak",
        "code": "6108"
      },
      {
        "id": 321,
        "name": "Melawi",
        "code": "6110"
      },
      {
        "id": 322,
        "name": "Pontianak",
        "code": "6171"
      },
      {
        "id": 323,
        "name": "Sambas",
        "code": "6101"
      },
      {
        "id": 324,
        "name": "Sanggau",
        "code": "6103"
      },
      {
        "id": 325,
        "name": "Sekadau",
        "code": "6109"
      },
      {
        "id": 326,
        "name": "Sintang",
        "code": "6105"
      },
      {
        "id": 327,
        "name": "Pontianak",
        "code": "6171"
      },
      {
        "id": 328,
        "name": "Singkawang",
        "code": "6172"
      },
      {
        "id": 329,
        "name": "Balangan",
        "code": "6311"
      },
      {
        "id": 330,
        "name": "Banjar",
        "code": "6303"
      },
      {
        "id": 331,
        "name": "Barito Kuala",
        "code": "6304"
      },
      {
        "id": 332,
        "name": "Hulu Sungai Tengah",
        "code": "6307"
      },
      {
        "id": 333,
        "name": "Kotabaru",
        "code": "6302"
      },
      {
        "id": 334,
        "name": "Hulu Sungai Utara",
        "code": "6308"
      },
      {
        "id": 335,
        "name": "Hulu Sungai Selatan",
        "code": "6306"
      },
      {
        "id": 336,
        "name": "Tabalong",
        "code": "6309"
      },
      {
        "id": 337,
        "name": "Tanah Laut",
        "code": "6301"
      },
      {
        "id": 338,
        "name": "Tanah Bumbu",
        "code": "6310"
      },
      {
        "id": 339,
        "name": "Tapin",
        "code": "6305"
      },
      {
        "id": 340,
        "name": "Banjarbaru",
        "code": "6372"
      },
      {
        "id": 341,
        "name": "Banjarmasin",
        "code": "6371"
      },
      {
        "id": 342,
        "name": "Barito Timur",
        "code": "6213"
      },
      {
        "id": 343,
        "name": "Kotawaringin Timur",
        "code": "6202"
      },
      {
        "id": 344,
        "name": "Gunung Mas",
        "code": "6210"
      },
      {
        "id": 345,
        "name": "Kapuas",
        "code": "6203"
      },
      {
        "id": 346,
        "name": "Katingan",
        "code": "6206"
      },
      {
        "id": 347,
        "name": "Lamandau",
        "code": "6209"
      },
      {
        "id": 348,
        "name": "Murung Raya",
        "code": "6212"
      },
      {
        "id": 349,
        "name": "Barito Utara",
        "code": "6205"
      },
      {
        "id": 350,
        "name": "Pulang Pisau",
        "code": "6211"
      },
      {
        "id": 351,
        "name": "Sukamara",
        "code": "6208"
      },
      {
        "id": 352,
        "name": "Seruyan",
        "code": "6207"
      },
      {
        "id": 353,
        "name": "Barito Selatan",
        "code": "6204"
      },
      {
        "id": 354,
        "name": "Kotawaringin Barat",
        "code": "6201"
      },
      {
        "id": 355,
        "name": "Palangka Raya",
        "code": nil
      },
      {
        "id": 356,
        "name": "Berau",
        "code": "6403"
      },
      {
        "id": 357,
        "name": "Kutai Timur",
        "code": "6408"
      },
      {
        "id": 358,
        "name": "Kutai Kartanegara",
        "code": "6402"
      },
      {
        "id": 359,
        "name": "Mahakam Ulu",
        "code": "6411"
      },
      {
        "id": 360,
        "name": "Penajam Paser Utara",
        "code": "6409"
      },
      {
        "id": 361,
        "name": "Paser",
        "code": nil
      },
      {
        "id": 362,
        "name": "Kutai Barat",
        "code": "6407"
      },
      {
        "id": 363,
        "name": "Balikpapan",
        "code": "6471"
      },
      {
        "id": 364,
        "name": "Bontang",
        "code": "6474"
      },
      {
        "id": 365,
        "name": "Samarinda",
        "code": "6472"
      },
      {
        "id": 366,
        "name": "Bulungan",
        "code": "6501"
      },
      {
        "id": 367,
        "name": "Malinau",
        "code": "6502"
      },
      {
        "id": 368,
        "name": "Nunukan",
        "code": "6503"
      },
      {
        "id": 369,
        "name": "Tana Tidung",
        "code": "6504"
      },
      {
        "id": 370,
        "name": "Tarakan",
        "code": "6571"
      },
      {
        "id": 371,
        "name": "Boalemo",
        "code": "7502"
      },
      {
        "id": 372,
        "name": "Bone Bolango",
        "code": "7503"
      },
      {
        "id": 373,
        "name": "Gorontalo",
        "code": "7501"
      },
      {
        "id": 374,
        "name": "Gorontalo Utara",
        "code": "7505"
      },
      {
        "id": 375,
        "name": "Pahuwato",
        "code": "7504"
      },
      {
        "id": 376,
        "name": "Gorontalo",
        "code": "7571"
      },
      {
        "id": 377,
        "name": "Bantaeng",
        "code": "7303"
      },
      {
        "id": 378,
        "name": "Barru",
        "code": "7311"
      },
      {
        "id": 379,
        "name": "Tulang",
        "code": nil
      },
      {
        "id": 380,
        "name": "Bulukumba",
        "code": "7302"
      },
      {
        "id": 381,
        "name": "Luwu Timur",
        "code": "7324"
      },
      {
        "id": 382,
        "name": "Enrekang",
        "code": "7316"
      },
      {
        "id": 383,
        "name": "Gowa",
        "code": "7306"
      },
      {
        "id": 384,
        "name": "Jeneponto",
        "code": "7304"
      },
      {
        "id": 385,
        "name": "Luwu",
        "code": nil
      },
      {
        "id": 386,
        "name": "Luwu Utara",
        "code": "7322"
      },
      {
        "id": 387,
        "name": "Toraja Utara",
        "code": "7326"
      },
      {
        "id": 388,
        "name": "Maros",
        "code": "7309"
      },
      {
        "id": 389,
        "name": "Kepulauan Pangkajene",
        "code": nil
      },
      {
        "id": 390,
        "name": "Pinrang",
        "code": "7315"
      },
      {
        "id": 391,
        "name": "Kepulauan Selayar",
        "code": "7301"
      },
      {
        "id": 392,
        "name": "Sinjai",
        "code": "7307"
      },
      {
        "id": 393,
        "name": "Sidenreng Rappang",
        "code": "7314"
      },
      {
        "id": 394,
        "name": "Soppeng",
        "code": "7312"
      },
      {
        "id": 395,
        "name": "Takalar",
        "code": "7305"
      },
      {
        "id": 396,
        "name": "Tana Toraja",
        "code": "7318"
      },
      {
        "id": 397,
        "name": "Wajo",
        "code": "7313"
      },
      {
        "id": 398,
        "name": "Makassar",
        "code": "7371"
      },
      {
        "id": 399,
        "name": "Palopo",
        "code": "7373"
      },
      {
        "id": 400,
        "name": "Parepare",
        "code": nil
      },
      {
        "id": 401,
        "name": "Mamuju Tengah",
        "code": "7606"
      },
      {
        "id": 402,
        "name": "Majene",
        "code": "7605"
      },
      {
        "id": 403,
        "name": "Mamasa",
        "code": "7603"
      },
      {
        "id": 404,
        "name": "Mamuju",
        "code": nil
      },
      {
        "id": 405,
        "name": "Pasangkayu",
        "code": "7601"
      },
      {
        "id": 406,
        "name": "Polewali Mandar",
        "code": "7604"
      },
      {
        "id": 407,
        "name": "Bombana",
        "code": "7406"
      },
      {
        "id": 408,
        "name": "Buton",
        "code": "7404"
      },
      {
        "id": 409,
        "name": "Buton Tengah",
        "code": "7414"
      },
      {
        "id": 410,
        "name": "Kolaka Timur",
        "code": "7411"
      },
      {
        "id": 411,
        "name": "Kolaka",
        "code": nil
      },
      {
        "id": 412,
        "name": "Konawe",
        "code": "7402"
      },
      {
        "id": 413,
        "name": "Kepulauan Konawe",
        "code": nil
      },
      {
        "id": 414,
        "name": "Muna",
        "code": "7403"
      },
      {
        "id": 415,
        "name": "Buton Utara",
        "code": "7410"
      },
      {
        "id": 416,
        "name": "Kolaka Utara",
        "code": "7408"
      },
      {
        "id": 417,
        "name": "Konawe Utara",
        "code": "7409"
      },
      {
        "id": 418,
        "name": "Buton Selatan",
        "code": "7415"
      },
      {
        "id": 419,
        "name": "Konawe Selatan",
        "code": "7405"
      },
      {
        "id": 420,
        "name": "Wakatobi",
        "code": "7407"
      },
      {
        "id": 421,
        "name": "Muna Barat",
        "code": "7413"
      },
      {
        "id": 422,
        "name": "Baubau",
        "code": nil
      },
      {
        "id": 423,
        "name": "Kendari",
        "code": "7471"
      },
      {
        "id": 424,
        "name": "Banggai",
        "code": "7201"
      },
      {
        "id": 425,
        "name": "Kepulauan Banggai",
        "code": nil
      },
      {
        "id": 426,
        "name": "Banggai Laut",
        "code": "7211"
      },
      {
        "id": 427,
        "name": "Buol",
        "code": "7205"
      },
      {
        "id": 428,
        "name": "Donggala",
        "code": "7203"
      },
      {
        "id": 429,
        "name": "Morowali",
        "code": "7206"
      },
      {
        "id": 430,
        "name": "Morowali Utara",
        "code": "7212"
      },
      {
        "id": 431,
        "name": "Parigi Moutong",
        "code": "7208"
      },
      {
        "id": 432,
        "name": "Poso",
        "code": "7202"
      },
      {
        "id": 433,
        "name": "Sigi",
        "code": "7210"
      },
      {
        "id": 434,
        "name": "Tojo Una-Una",
        "code": nil
      },
      {
        "id": 435,
        "name": "Tolitoli",
        "code": nil
      },
      {
        "id": 436,
        "name": "Palu",
        "code": "7271"
      },
      {
        "id": 437,
        "name": "Bolaang Mongondow",
        "code": "7101"
      },
      {
        "id": 438,
        "name": "Bolaang Mongondow Timur",
        "code": "7110"
      },
      {
        "id": 439,
        "name": "Minahasa",
        "code": "7102"
      },
      {
        "id": 440,
        "name": "Bolaang Mongondow Utara",
        "code": "7108"
      },
      {
        "id": 441,
        "name": "Minahasa Utara",
        "code": "7106"
      },
      {
        "id": 442,
        "name": "Kepulauan Sangihe",
        "code": "7103"
      },
      {
        "id": 443,
        "name": "Kepulauan Sitaro",
        "code": nil
      },
      {
        "id": 444,
        "name": "Bolaang Mongondow Selatan",
        "code": "7111"
      },
      {
        "id": 445,
        "name": "Minahasa Selatan",
        "code": "7105"
      },
      {
        "id": 446,
        "name": "Minahasa Tenggara",
        "code": "7107"
      },
      {
        "id": 447,
        "name": "Kepulauan Talaud",
        "code": "7104"
      },
      {
        "id": 448,
        "name": "Bitung",
        "code": "7172"
      },
      {
        "id": 449,
        "name": "Kotamobagu",
        "code": "7174"
      },
      {
        "id": 450,
        "name": "Manado",
        "code": "7171"
      },
      {
        "id": 451,
        "name": "Tomohon",
        "code": "7173"
      },
      {
        "id": 452,
        "name": "Kepulauan Aru",
        "code": "8107"
      },
      {
        "id": 453,
        "name": "Buru",
        "code": "8104"
      },
      {
        "id": 454,
        "name": "Maluku Tengah",
        "code": "8101"
      },
      {
        "id": 455,
        "name": "Seram Bagian Timur",
        "code": "8105"
      },
      {
        "id": 456,
        "name": "Buru Selatan",
        "code": "8109"
      },
      {
        "id": 457,
        "name": "Maluku Tenggara",
        "code": "8102"
      },
      {
        "id": 458,
        "name": "Maluku Barat Daya",
        "code": "8108"
      },
      {
        "id": 459,
        "name": "Kepulauan Tanimbar",
        "code": "8103"
      },
      {
        "id": 460,
        "name": "Seram Barat",
        "code": nil
      },
      {
        "id": 461,
        "name": "Ambon",
        "code": "8171"
      },
      {
        "id": 462,
        "name": "Tual",
        "code": "8172"
      },
      {
        "id": 463,
        "name": "Halmahera Tengah",
        "code": "8202"
      },
      {
        "id": 464,
        "name": "Halmahera Timur",
        "code": "8206"
      },
      {
        "id": 465,
        "name": "Pulau Morotai",
        "code": "8207"
      },
      {
        "id": 466,
        "name": "Halmahera Utara",
        "code": "8203"
      },
      {
        "id": 467,
        "name": "Halmahera Selatan",
        "code": "8204"
      },
      {
        "id": 468,
        "name": "Kepulauan Sula",
        "code": "8205"
      },
      {
        "id": 469,
        "name": "Pulau Taliabu",
        "code": "8208"
      },
      {
        "id": 470,
        "name": "Halmahera Barat",
        "code": "8201"
      },
      {
        "id": 471,
        "name": "Ternate",
        "code": "8271"
      },
      {
        "id": 472,
        "name": "Tidore",
        "code": nil
      },
      {
        "id": 473,
        "name": "Fak-Fak",
        "code": nil
      },
      {
        "id": 474,
        "name": "Kaimana",
        "code": "9208"
      },
      {
        "id": 475,
        "name": "Manokwari",
        "code": "9202"
      },
      {
        "id": 476,
        "name": "Maybrat",
        "code": "9210"
      },
      {
        "id": 477,
        "name": "Raja Ampat",
        "code": "9205"
      },
      {
        "id": 478,
        "name": "Pegunungan Arfak",
        "code": "9212"
      },
      {
        "id": 479,
        "name": "Sorong",
        "code": "9201"
      },
      {
        "id": 480,
        "name": "Manokwari Selatan",
        "code": "9211"
      },
      {
        "id": 481,
        "name": "Sorong Selatan",
        "code": "9204"
      },
      {
        "id": 482,
        "name": "Tambrauw",
        "code": "9209"
      },
      {
        "id": 483,
        "name": "Teluk Bintuni",
        "code": "9206"
      },
      {
        "id": 484,
        "name": "Teluk Wondama",
        "code": "9207"
      },
      {
        "id": 485,
        "name": "Sorong",
        "code": "9271"
      },
      {
        "id": 486,
        "name": "Asmat",
        "code": "9118"
      },
      {
        "id": 487,
        "name": "Biak Numfor",
        "code": "9106"
      },
      {
        "id": 488,
        "name": "Boven Digoel",
        "code": "9116"
      },
      {
        "id": 489,
        "name": "Mamberamo Tengah",
        "code": "9121"
      },
      {
        "id": 490,
        "name": "Deiyai",
        "code": "9128"
      },
      {
        "id": 491,
        "name": "Dogiyai",
        "code": "9126"
      },
      {
        "id": 492,
        "name": "Intan Jaya",
        "code": "9127"
      },
      {
        "id": 493,
        "name": "Jayapura",
        "code": "9103"
      },
      {
        "id": 494,
        "name": "Jayawijaya",
        "code": "9102"
      },
      {
        "id": 495,
        "name": "Keerom",
        "code": "9111"
      },
      {
        "id": 496,
        "name": "Lanny Jaya",
        "code": "9123"
      },
      {
        "id": 497,
        "name": "Mamberamo Raya",
        "code": "9120"
      },
      {
        "id": 498,
        "name": "Mappi",
        "code": "9117"
      },
      {
        "id": 499,
        "name": "Merauke",
        "code": "9101"
      },
      {
        "id": 500,
        "name": "Mimika",
        "code": "9109"
      },
      {
        "id": 501,
        "name": "Nabire",
        "code": "9104"
      },
      {
        "id": 502,
        "name": "Nduga",
        "code": "9124"
      },
      {
        "id": 503,
        "name": "Paniai",
        "code": "9108"
      },
      {
        "id": 504,
        "name": "Pegunungan Bintang",
        "code": "9112"
      },
      {
        "id": 505,
        "name": "Puncak",
        "code": "9125"
      },
      {
        "id": 506,
        "name": "Puncak Jaya",
        "code": "9107"
      },
      {
        "id": 507,
        "name": "Sarmi",
        "code": "9110"
      },
      {
        "id": 508,
        "name": "Supiori",
        "code": "9119"
      },
      {
        "id": 509,
        "name": "Tolikara",
        "code": "9114"
      },
      {
        "id": 510,
        "name": "Waropen",
        "code": "9115"
      },
      {
        "id": 511,
        "name": "Yahukimo",
        "code": "9113"
      },
      {
        "id": 512,
        "name": "Yalimo",
        "code": "9122"
      },
      {
        "id": 513,
        "name": "Kepulauan Yapen",
        "code": "9105"
      },
      {
        "id": 514,
        "name": "Jayapura",
        "code": "9171"
      }
    ]

    regencies.each do|regency|
      Regency.find(regency[:id]).update(code: regency[:code])
    end
  end
end
