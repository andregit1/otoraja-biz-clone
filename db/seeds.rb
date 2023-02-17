# This file should contain all the record creation needed to seed the database with its default values. 
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup). 
# 
# Examples: 
# 
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# ========= Region ==========
region_list = [
  [name: 'Sumatera'],
  [name: 'Jawa'],
  [name: 'Nusa Tenggara'],
  [name: 'Kalimantan'],
  [name: 'Sulawesi'],
  [name: 'Maluku'],
  [name: 'Papua']
]
Region.create(region_list)

# ========== Province =========
province_list = []
## Sumatera
region = Region.find_by(name: 'Sumatera')
province = [
  [region: region, name: 'Aceh'],
  [region: region, name: 'Sumatera Utara'],
  [region: region, name: 'Sumatera Barat'],
  [region: region, name: 'Jambi'],
  [region: region, name: 'Riau'],
  [region: region, name: 'Bengkulu'],
  [region: region, name: 'Sumatera Selatan'],
  [region: region, name: 'Lampung'],
  [region: region, name: 'Kepulauan Bangka Belitung'],
  [region: region, name: 'Kepulauan Riau'],
]
province_list << province

## Jawa
region = Region.find_by(name: 'Jawa')
province = [
  [region: region, name: 'Daerah Khusus Ibukota Jakarta'],
  [region: region, name: 'Banten'],
  [region: region, name: 'Jawa Barat'],
  [region: region, name: 'Jawa Tengah'],
  [region: region, name: 'Jawa Timur'],
  [region: region, name: 'Daerah Istimewa Yogyakarta'],
]
province_list << province

## Nusa Tenggara
region = Region.find_by(name: 'Nusa Tenggara')
province = [
  [region: region, name: 'Bali'],
  [region: region, name: 'Nusa Tenggara Barat'],
  [region: region, name: 'Nusa Tenggara Timur'],
]
province_list << province

## Kalimantan
region = Region.find_by(name: 'Kalimantan')
province = [
  [region: region, name: 'Kalimantan Barat'],
  [region: region, name: 'Kalimantan Selatan'],
  [region: region, name: 'Kalimantan Tengah'],
  [region: region, name: 'Kalimantan Timur'],
  [region: region, name: 'Kalimantan Utara'],
]
province_list << province

## Sulawesi
region = Region.find_by(name: 'Sulawesi')
province = [
  [region: region, name: 'Gorontalo'],
  [region: region, name: 'Sulawesi Selatan'],
  [region: region, name: 'Sulawesi Barat'],
  [region: region, name: 'Sulawesi Tenggara'],
  [region: region, name: 'Sulawesi Tengah'],
  [region: region, name: 'Sulawesi Utara'],
]
province_list << province

## Maluku
region = Region.find_by(name: 'Maluku')
province = [
  [region: region, name: 'Maluku'],
  [region: region, name: 'Maluku Utara'],
]
province_list << province

## Papua
region = Region.find_by(name: 'Maluku')
province = [
  [region: region, name: 'Papua Barat'],
  [region: region, name: 'Papua'],
]
province_list << province

province_list.flatten

Province.create(province_list)

# ========== Regency ==========
regency_list = []
## Aceh
province = Province.find_by(name: 'Aceh')
regency = [
  [province: province, name: 'Aceh Besar',capital_name:'Jantho',type:1],
  [province: province, name: 'Aceh Jaya',capital_name:'Calang',type:1],
  [province: province, name: 'Aceh Singkil',capital_name:'Singkil',type:1],
  [province: province, name: 'Aceh Tamiang',capital_name:'Karang Baru',type:1],
  [province: province, name: 'Bener Meriah',capital_name:'Simpang Tiga Redelong',type:1],
  [province: province, name: 'Bireuën',capital_name:'Bireuën',type:1],
  [province: province, name: 'Aceh Tengah',capital_name:'Takengon',type:1],
  [province: province, name: 'Aceh Timur',capital_name:'Langsa',type:1],
  [province: province, name: 'Gayo Lues',capital_name:'Blangkejeren',type:1],
  [province: province, name: 'Nagan Raya',capital_name:'Suka Makmue',type:1],
  [province: province, name: 'Aceh Utara',capital_name:'Lhoksukon',type:1],
  [province: province, name: 'Pidie',capital_name:'Sigli',type:1],
  [province: province, name: 'Pidie Jaya',capital_name:'Meureudu',type:1],
  [province: province, name: 'Simeulue',capital_name:'Sinabang',type:1],
  [province: province, name: 'Aceh Selatan',capital_name:'Tapaktuan',type:1],
  [province: province, name: 'Aceh Tenggara',capital_name:'Kutacane',type:1],
  [province: province, name: 'Aceh Barat Daya',capital_name:'Blangpidie',type:1],
  [province: province, name: 'Aceh Barat',capital_name:'Meulaboh',type:1],
  [province: province, name: 'Banda Aceh',capital_name:'',type:2],
  [province: province, name: 'Langsa',capital_name:'',type:2],
  [province: province, name: 'Lhokseumawe',capital_name:'',type:2],
  [province: province, name: 'Sabang',capital_name:'',type:2],
  [province: province, name: 'Subulussalam',capital_name:'',type:2],
]
regency_list << regency

## Sumatera Utara
province = Province.find_by(name: 'Sumatera Utara')
regency = [
  [province: province, name: 'Asahan',capital_name:'Kisaran',type:1],
  [province: province, name: 'Batubara',capital_name:'Limapuluh',type:1],
  [province: province, name: 'Tapanuli Tengah',capital_name:'Pandan',type:1],
  [province: province, name: 'Dairi',capital_name:'Sidikalang',type:1],
  [province: province, name: 'Deli Serdang',capital_name:'Lubuk Pakam',type:1],
  [province: province, name: 'Humbang Hasundutan',capital_name:'Dolok Sanggul',type:1],
  [province: province, name: 'Karo',capital_name:'Kabanjahe',type:1],
  [province: province, name: 'Labuhan Batu',capital_name:'Rantau Prapat',type:1],
  [province: province, name: 'Langkat',capital_name:'Stabat',type:1],
  [province: province, name: 'Mandailing Natal',capital_name:'Panyabungan',type:1],
  [province: province, name: 'Nias',capital_name:'Gunungsitoli',type:1],
  [province: province, name: 'Labuhan Batu Utara',capital_name:'Aek Kanopan',type:1],
  [province: province, name: 'Nias Utara',capital_name:'Lotu',type:1],
  [province: province, name: 'Lawas Padang Utara',capital_name:'Gunung Tua',type:1],
  [province: province, name: 'Tapanuli Utara',capital_name:'Tarutung',type:1],
  [province: province, name: 'Padang Lawas',capital_name:'Sibuhuan',type:1],
  [province: province, name: 'Pakpak Bharat',capital_name:'Salak',type:1],
  [province: province, name: 'Samosir',capital_name:'Panguruan',type:1],
  [province: province, name: 'Serdang Bedagai',capital_name:'Sei Rampah',type:1],
  [province: province, name: 'Simalungun',capital_name:'Raya',type:1],
  [province: province, name: 'Labuhan Batu Selatan',capital_name:'Kota Pinang',type:1],
  [province: province, name: 'Nias Selatan',capital_name:'Teluk Dalam',type:1],
  [province: province, name: 'Tapanuli Selatan',capital_name:'Sipirok',type:1],
  [province: province, name: 'Toba Samosir',capital_name:'Balige',type:1],
  [province: province, name: 'Nias Barat',capital_name:'Lahomi',type:1],
  [province: province, name: 'Binjai',capital_name:'',type:2],
  [province: province, name: 'Gunungsitoli',capital_name:'',type:2],
  [province: province, name: 'Medan',capital_name:'',type:2],
  [province: province, name: 'Padang Sidempuan',capital_name:'',type:2],
  [province: province, name: 'Pematangsiantar',capital_name:'',type:2],
  [province: province, name: 'Sibolga',capital_name:'',type:2],
  [province: province, name: 'Tanjung Balai',capital_name:'',type:2],
  [province: province, name: 'Tebing Tinggi',capital_name:'',type:2],
]
regency_list << regency

## Sumatera Barat
province = Province.find_by(name: 'Sumatera Barat')
regency = [
  [province: province, name: 'Agam',capital_name:'Lubuk Basung',type:1],
  [province: province, name: 'Dharmasraya',capital_name:'Pulau Punjung',type:1],
  [province: province, name: 'Lima Puluh Kota',capital_name:'Sarilamak',type:1],
  [province: province, name: 'Kepulauan Mentawai',capital_name:'Tuapejat',type:1],
  [province: province, name: 'Padang Pariaman',capital_name:'Parit Malintang',type:1],
  [province: province, name: 'Pasaman',capital_name:'Lubuk Sikaping',type:1],
  [province: province, name: 'Sijunjung',capital_name:'Muaro Sijunjung',type:1],
  [province: province, name: 'Solok',capital_name:'Arosuka',type:1],
  [province: province, name: 'Pesisir Selatan',capital_name:'Painan',type:1],
  [province: province, name: 'Solok Selatan',capital_name:'Padang Aro',type:1],
  [province: province, name: 'Tanah Datar',capital_name:'Batusangkar',type:1],
  [province: province, name: 'Pasaman Barat',capital_name:'Simpang Ampek',type:1],
  [province: province, name: 'Bukittinggi',capital_name:'',type:2],
  [province: province, name: 'Padang',capital_name:'',type:2],
  [province: province, name: 'Padang Panjang',capital_name:'',type:2],
  [province: province, name: 'Pariaman',capital_name:'',type:2],
  [province: province, name: 'Payakumbuh',capital_name:'',type:2],
  [province: province, name: 'Sawahlunto',capital_name:'',type:2],
  [province: province, name: 'Solok',capital_name:'',type:2],
]
regency_list << regency

## Jambi
province = Province.find_by(name: 'Jambi')
regency = [
  [province: province, name: 'Batang Hari',capital_name:'Muara Bulian',type:1],
  [province: province, name: 'Bungo',capital_name:'Bungo',type:1],
  [province: province, name: 'Kerinci',capital_name:'Siulak',type:1],
  [province: province, name: 'Merangin',capital_name:'Bangko',type:1],
  [province: province, name: 'Muaro Jambi',capital_name:'Sengeti',type:1],
  [province: province, name: 'Sarolangun',capital_name:'Sarolangun',type:1],
  [province: province, name: 'Tanjung Jabung Timur',capital_name:'Muara Sabak',type:1],
  [province: province, name: 'Tanjung Jabung Barat',capital_name:'Kuala Tungkal',type:1],
  [province: province, name: 'Tebo',capital_name:'Tebo',type:1],
  [province: province, name: 'Jambi',capital_name:'',type:2],
  [province: province, name: 'Sungai Penuh',capital_name:'',type:2],
]
regency_list << regency

## Riau
province = Province.find_by(name: 'Riau')
regency = [
  [province: province, name: 'Bengkalis',capital_name:'Bengkalis',type:1],
  [province: province, name: 'Indragiri Hilir',capital_name:'Tembilahan',type:1],
  [province: province, name: 'Indragiri Hulu',capital_name:'Rengat',type:1],
  [province: province, name: 'Kampar',capital_name:'Bangkinang',type:1],
  [province: province, name: 'Kuantan Singingi',capital_name:'Teluk Kuantan',type:1],
  [province: province, name: 'Kepulauan Meranti',capital_name:'Selat Panjang',type:1],
  [province: province, name: 'Pelalawan',capital_name:'Pangkalan Kerinci',type:1],
  [province: province, name: 'Rokan Hulu',capital_name:'Pasir Pangaraian',type:1],
  [province: province, name: 'Rokan Hilir',capital_name:'Bagansiapiapi',type:1],
  [province: province, name: 'Siak',capital_name:'Siak Sri Indrapura',type:1],
  [province: province, name: 'Dumai',capital_name:'',type:2],
  [province: province, name: 'Pekanbaru',capital_name:'',type:2],
]
regency_list << regency

## Bengkulu
province = Province.find_by(name: 'Bengkulu')
regency = [
  [province: province, name: 'Bengkulu tengah',capital_name:'Karang Tinggi',type:1],
  [province: province, name: 'Kaur',capital_name:'Bintuhan',type:1],
  [province: province, name: 'Kepahiang',capital_name:'Kepahiang',type:1],
  [province: province, name: 'Lebong',capital_name:'Muara Aman',type:1],
  [province: province, name: 'Muko-Muko',capital_name:'Muko-Muko',type:1],
  [province: province, name: 'Bengkulu Utara',capital_name:'Argamakmur',type:1],
  [province: province, name: 'Rejang Lebong',capital_name:'Curup',type:1],
  [province: province, name: 'Seluma',capital_name:'Tais',type:1],
  [province: province, name: 'Bengkulu Selatan',capital_name:'Manna',type:1],
  [province: province, name: 'Bengkulu',capital_name:'',type:2],
]
regency_list << regency

## Sumatera Selatan
province = Province.find_by(name: 'Sumatera Selatan')
regency = [
  [province: province, name: 'Banyuasin',capital_name:'Pangkalan Balai',type:1],
  [province: province, name: 'Ogan Komering Ulu Timur',capital_name:'Martapura',type:1],
  [province: province, name: 'Empat Lawang',capital_name:'Tebing Tinggi',type:1],
  [province: province, name: 'Lahat',capital_name:'Lahat',type:1],
  [province: province, name: 'Muara Enim',capital_name:'Muara Enim',type:1],
  [province: province, name: 'Musi Banyuasin',capital_name:'Sekayu',type:1],
  [province: province, name: 'Musi Rawas',capital_name:'Muara Beliti Baru',type:1],
  [province: province, name: 'Musi Rawas Utara',capital_name:'Rupit',type:1],
  [province: province, name: 'Ogan Ilir',capital_name:'Indralaya',type:1],
  [province: province, name: 'Ogan Komering Ilir',capital_name:'Kayuagung',type:1],
  [province: province, name: 'Ogan Komering Ulu',capital_name:'Baturaja',type:1],
  [province: province, name: 'Penukal Abab Lematang Ilir',capital_name:'Talang Ubi',type:1],
  [province: province, name: 'Ogan Komering Ulu Selatan',capital_name:'Muaradua',type:1],
  [province: province, name: 'Lubuklinggau',capital_name:'',type:2],
  [province: province, name: 'Pagar Alam',capital_name:'',type:2],
  [province: province, name: 'Palembang',capital_name:'',type:2],
  [province: province, name: 'Prabumulih',capital_name:'',type:2],
]
regency_list << regency

## Lampung
province = Province.find_by(name: 'Lampung')
regency = [
  [province: province, name: 'Lampung Tengah',capital_name:'Gunung Sugih',type:1],
  [province: province, name: 'Lampung Timur',capital_name:'Sukadana',type:1],
  [province: province, name: 'Mesuji',capital_name:'Mesuji',type:1],
  [province: province, name: 'Lampung Utara',capital_name:'Kotabumi',type:1],
  [province: province, name: 'Pesawaran',capital_name:'Gedong Tataan',type:1],
  [province: province, name: 'Pringsewu',capital_name:'Pringsewu',type:1],
  [province: province, name: 'Lampung Selatan',capital_name:'Kalianda',type:1],
  [province: province, name: 'Tanggamus',capital_name:'Kota Agung',type:1],
  [province: province, name: 'Tulang Bawang',capital_name:'Menggala',type:1],
  [province: province, name: 'Way Kanan',capital_name:'Blambangan Umpu',type:1],
  [province: province, name: 'Lampung Barat',capital_name:'Liwa',type:1],
  [province: province, name: 'Pesisir Barat',capital_name:'Krui',type:1],
  [province: province, name: 'Tulang Bawang Barat',capital_name:'Central Tulang Bawang',type:1],
  [province: province, name: 'Bandar Lampung',capital_name:'',type:2],
  [province: province, name: 'Metro',capital_name:'',type:2],
]
regency_list << regency

## Kepulauan Bangka Belitung
province = Province.find_by(name: 'Kepulauan Bangka Belitung')
regency = [
  [province: province, name: 'Bangka',capital_name:'Sungai Liat',type:1],
  [province: province, name: 'Belitung',capital_name:'Tanjung Pandan',type:1],
  [province: province, name: 'Bangka Tengah',capital_name:'Koba',type:1],
  [province: province, name: 'Belitung Timur',capital_name:'Manggar',type:1],
  [province: province, name: 'Bangka Selatan',capital_name:'Toboali',type:1],
  [province: province, name: 'Bangka Barat',capital_name:'Mentok',type:1],
  [province: province, name: 'Pangkalpinang',capital_name:'',type:2],
]
regency_list << regency

## Kepulauan Riau
province = Province.find_by(name: 'Kepulauan Riau')
regency = [
  [province: province, name: 'Kepulauan Anambas',capital_name:'Tarempa',type:1],
  [province: province, name: 'Bintan',capital_name:'Bandar Seri Bentan',type:1],
  [province: province, name: 'Karimun',capital_name:'Tanjung Balai Karimun',type:1],
  [province: province, name: 'Lingga',capital_name:'Daik',type:1],
  [province: province, name: 'Natuna',capital_name:'Ranai',type:1],
  [province: province, name: 'Batam',capital_name:'',type:2],
  [province: province, name: 'Tanjungpinang',capital_name:'',type:2],
]
regency_list << regency

## Daerah Khusus Ibukota Jakarta
province = Province.find_by(name: 'Daerah Khusus Ibukota Jakarta')
regency = [
  [province: province, name: 'Kepulauan Seribu',capital_name:'Pramuka Island',type:1],
  [province: province, name: 'Jakarta Pusat',capital_name:'Menteng',type:2],
  [province: province, name: 'Jakarta Timur',capital_name:'Jatinegara',type:2],
  [province: province, name: 'Jakarta Utara',capital_name:'Koja',type:2],
  [province: province, name: 'Jakarta Selatan',capital_name:'Kebayoran Baru',type:2],
  [province: province, name: 'Jakarta Barat',capital_name:'Kembangan',type:2],
]
regency_list << regency

## Banten
province = Province.find_by(name: 'Banten')
regency = [
  [province: province, name: 'Lebak',capital_name:'Rangkasbitung',type:1],
  [province: province, name: 'Pandeglang',capital_name:'Pandeglang',type:1],
  [province: province, name: 'Serang',capital_name:'Ciruas',type:1],
  [province: province, name: 'Tangerang',capital_name:'Tigaraksa',type:1],
  [province: province, name: 'Cilegon',capital_name:'',type:2],
  [province: province, name: 'Serang',capital_name:'',type:2],
  [province: province, name: 'Tangerang',capital_name:'',type:2],
  [province: province, name: 'Tangerang Selatan',capital_name:'',type:2],
]
regency_list << regency

## Jawa Barat
province = Province.find_by(name: 'Jawa Barat')
regency = [
  [province: province, name: 'Bandung',capital_name:'Soreang',type:1],
  [province: province, name: 'Bekasi',capital_name:'Cikarang',type:1],
  [province: province, name: 'Bogor',capital_name:'Cibinong',type:1],
  [province: province, name: 'Ciamis',capital_name:'Ciamis',type:1],
  [province: province, name: 'Cianjur',capital_name:'Cianjur',type:1],
  [province: province, name: 'Cirebon',capital_name:'Sumber',type:1],
  [province: province, name: 'Garut',capital_name:'Garut',type:1],
  [province: province, name: 'Indramayu',capital_name:'Indramayu',type:1],
  [province: province, name: 'Karawang',capital_name:'Karawang',type:1],
  [province: province, name: 'Kuningan',capital_name:'Kuningan',type:1],
  [province: province, name: 'Majalengka',capital_name:'Majalengka',type:1],
  [province: province, name: 'Pangandaran',capital_name:'Parigi',type:1],
  [province: province, name: 'Purwakarta',capital_name:'Purwakarta',type:1],
  [province: province, name: 'Subang',capital_name:'Subang',type:1],
  [province: province, name: 'Sukabumi',capital_name:'Sukabumi',type:1],
  [province: province, name: 'Sumedang',capital_name:'Sumedang',type:1],
  [province: province, name: 'Tasikmalaya',capital_name:'Singaparna',type:1],
  [province: province, name: 'Bandung Barat',capital_name:'Ngamprah',type:1],
  [province: province, name: 'Bandung',capital_name:'',type:2],
  [province: province, name: 'Banjar',capital_name:'',type:2],
  [province: province, name: 'Bekasi',capital_name:'',type:2],
  [province: province, name: 'Bogor',capital_name:'',type:2],
  [province: province, name: 'Cimahi',capital_name:'',type:2],
  [province: province, name: 'Cirebon',capital_name:'',type:2],
  [province: province, name: 'Depok',capital_name:'',type:2],
  [province: province, name: 'Sukabumi',capital_name:'',type:2],
  [province: province, name: 'Tasikmalaya',capital_name:'',type:2],
]
regency_list << regency

## Jawa Tengah
province = Province.find_by(name: 'Jawa Tengah')
regency = [
  [province: province, name: 'Banjarnegara',capital_name:'Banjarnegara',type:1],
  [province: province, name: 'Banyumas',capital_name:'Purwokerto',type:1],
  [province: province, name: 'Batang',capital_name:'Batang',type:1],
  [province: province, name: 'Blora',capital_name:'Blora',type:1],
  [province: province, name: 'Boyolali',capital_name:'Boyolali',type:1],
  [province: province, name: 'Brebes',capital_name:'Brebes',type:1],
  [province: province, name: 'Cilacap',capital_name:'Cilacap',type:1],
  [province: province, name: 'Demak',capital_name:'Demak',type:1],
  [province: province, name: 'Grobogan',capital_name:'Purwodadi',type:1],
  [province: province, name: 'Jepara',capital_name:'Jepara',type:1],
  [province: province, name: 'Karanganyar',capital_name:'Karanganyar',type:1],
  [province: province, name: 'Kebumen',capital_name:'Kebumen',type:1],
  [province: province, name: 'Kendal',capital_name:'Kendal',type:1],
  [province: province, name: 'Klaten',capital_name:'Klaten',type:1],
  [province: province, name: 'Kudus',capital_name:'Kudus',type:1],
  [province: province, name: 'Magelang',capital_name:'Mungkid',type:1],
  [province: province, name: 'Pati',capital_name:'Pati',type:1],
  [province: province, name: 'Pekalongan',capital_name:'Kajen',type:1],
  [province: province, name: 'Pemalang',capital_name:'Pemalang',type:1],
  [province: province, name: 'Purbalingga',capital_name:'Purbalingga',type:1],
  [province: province, name: 'Purworejo',capital_name:'Purworejo',type:1],
  [province: province, name: 'Rembang',capital_name:'Rembang',type:1],
  [province: province, name: 'Semarang',capital_name:'Ungaran',type:1],
  [province: province, name: 'Sragen',capital_name:'Sragen',type:1],
  [province: province, name: 'Sukoharjo',capital_name:'Sukoharjo',type:1],
  [province: province, name: 'Tegal',capital_name:'Slawi',type:1],
  [province: province, name: 'Temanggung',capital_name:'Temanggung',type:1],
  [province: province, name: 'Wonogiri',capital_name:'Wonogiri',type:1],
  [province: province, name: 'Wonosobo',capital_name:'Wonosobo',type:1],
  [province: province, name: 'Magelang',capital_name:'',type:2],
  [province: province, name: 'Surakarta',capital_name:'',type:2],
  [province: province, name: 'Salatiga',capital_name:'',type:2],
  [province: province, name: 'Semarang',capital_name:'',type:2],
  [province: province, name: 'Pekalongan',capital_name:'',type:2],
  [province: province, name: 'Tegal',capital_name:'',type:2],
]
regency_list << regency

## Jawa Timur
province = Province.find_by(name: 'Jawa Timur')
regency = [
  [province: province, name: 'Bangkalan',capital_name:'Bangkalan',type:1],
  [province: province, name: 'Banyuwangi',capital_name:'Banyuwangi',type:1],
  [province: province, name: 'Blitar',capital_name:'Wlingi',type:1],
  [province: province, name: 'Bojonegoro',capital_name:'Bojonegoro',type:1],
  [province: province, name: 'Bondowoso',capital_name:'Bondowoso',type:1],
  [province: province, name: 'Gresik',capital_name:'Gresik',type:1],
  [province: province, name: 'Jember',capital_name:'Jember',type:1],
  [province: province, name: 'Jombang',capital_name:'Jombang',type:1],
  [province: province, name: 'Kediri',capital_name:'Pare',type:1],
  [province: province, name: 'Lamongan',capital_name:'Lamongan',type:1],
  [province: province, name: 'Lumajang',capital_name:'Lumajang',type:1],
  [province: province, name: 'Madiun',capital_name:'Madiun',type:1],
  [province: province, name: 'Magetan',capital_name:'Magetan',type:1],
  [province: province, name: 'Malang',capital_name:'Kepanjen',type:1],
  [province: province, name: 'Mojokerto',capital_name:'Mojokerto',type:1],
  [province: province, name: 'Nganjuk',capital_name:'Nganjuk',type:1],
  [province: province, name: 'Ngawi',capital_name:'Ngawi',type:1],
  [province: province, name: 'Pacitan',capital_name:'Pacitan',type:1],
  [province: province, name: 'Pamekasan',capital_name:'Pamekasan',type:1],
  [province: province, name: 'Pasuruan',capital_name:'Pasuruan',type:1],
  [province: province, name: 'Ponorogo',capital_name:'Ponorogo',type:1],
  [province: province, name: 'Probolinggo',capital_name:'Probolinggo',type:1],
  [province: province, name: 'Sampang',capital_name:'Sampang',type:1],
  [province: province, name: 'Sidoarjo',capital_name:'Sidoarjo',type:1],
  [province: province, name: 'Situbondo',capital_name:'Situbondo',type:1],
  [province: province, name: 'Sumenep',capital_name:'Sumenep',type:1],
  [province: province, name: 'Trenggalek',capital_name:'Trenggalek',type:1],
  [province: province, name: 'Tuban',capital_name:'Tuban',type:1],
  [province: province, name: 'Tulungagung',capital_name:'Tulungagung',type:1],
  [province: province, name: 'Batu',capital_name:'',type:2],
  [province: province, name: 'Blitar',capital_name:'',type:2],
  [province: province, name: 'Kediri',capital_name:'',type:2],
  [province: province, name: 'Madiun',capital_name:'',type:2],
  [province: province, name: 'Malang',capital_name:'',type:2],
  [province: province, name: 'Mojokerto',capital_name:'',type:2],
  [province: province, name: 'Pasuruan',capital_name:'',type:2],
  [province: province, name: 'Probolinggo',capital_name:'',type:2],
  [province: province, name: 'Surabaya',capital_name:'',type:2],
]
regency_list << regency

## Daerah Istimewa Yogyakarta
province = Province.find_by(name: 'Daerah Istimewa Yogyakarta')
regency = [
  [province: province, name: 'Bantul',capital_name:'Bantul',type:1],
  [province: province, name: 'Gunung Kidul',capital_name:'Wonosari',type:1],
  [province: province, name: 'Kulon Progo',capital_name:'Wates',type:1],
  [province: province, name: 'Sleman',capital_name:'Sleman',type:1],
  [province: province, name: 'Yogyakarta',capital_name:'',type:2],
]
regency_list << regency

## Bali
province = Province.find_by(name: 'Bali')
regency = [
  [province: province, name: 'Badung',capital_name:'Mangupura',type:1],
  [province: province, name: 'Bangli',capital_name:'Bangli',type:1],
  [province: province, name: 'Buleleng',capital_name:'Singaraja',type:1],
  [province: province, name: 'Gianyar',capital_name:'Gianyar',type:1],
  [province: province, name: 'Jembrana',capital_name:'Negara',type:1],
  [province: province, name: 'Karangasem',capital_name:'Amlapura',type:1],
  [province: province, name: 'Klungkung',capital_name:'Semarapura',type:1],
  [province: province, name: 'Tabanan',capital_name:'Tabanan',type:1],
  [province: province, name: 'Denpasar',capital_name:'',type:2],
]
regency_list << regency

## Nusa Tenggara Barat
province = Province.find_by(name: 'Nusa Tenggara Barat')
regency = [
  [province: province, name: 'Bima',capital_name:'Woha',type:1],
  [province: province, name: 'Lombok Tengah',capital_name:'Praya',type:1],
  [province: province, name: 'Dompu',capital_name:'Dompu',type:1],
  [province: province, name: 'Lombok Timur',capital_name:'Selong',type:1],
  [province: province, name: 'Lombok Utara',capital_name:'Tanjung',type:1],
  [province: province, name: 'Sumbawa',capital_name:'Sumbawa Besar',type:1],
  [province: province, name: 'Lombok Barat',capital_name:'Gerung',type:1],
  [province: province, name: 'Sumbawa Barat',capital_name:'Taliwang',type:1],
  [province: province, name: 'Mataram',capital_name:'',type:2],
  [province: province, name: 'Bima',capital_name:'',type:2],
]
regency_list << regency

## Nusa Tenggara Timur
province = Province.find_by(name: 'Nusa Tenggara Timur')
regency = [
  [province: province, name: 'Alor',capital_name:'Kalabahi',type:1],
  [province: province, name: 'Belu',capital_name:'Atambua',type:1],
  [province: province, name: 'Sumba Tengah',capital_name:'Waibakul',type:1],
  [province: province, name: 'Flores Timur',capital_name:'Larantuka',type:1],
  [province: province, name: 'Manggarai Timur',capital_name:'Borong',type:1],
  [province: province, name: 'Sumba Timur',capital_name:'Waingapu',type:1],
  [province: province, name: 'Ende',capital_name:'Ende',type:1],
  [province: province, name: 'Kupang',capital_name:'Oelamasi',type:1],
  [province: province, name: 'Lembata',capital_name:'Lewoleba',type:1],
  [province: province, name: 'Malaka',capital_name:'Betun',type:1],
  [province: province, name: 'Manggarai',capital_name:'Ruteng',type:1],
  [province: province, name: 'Nagekeo',capital_name:'Mbay',type:1],
  [province: province, name: 'Ngada',capital_name:'Bajawa',type:1],
  [province: province, name: 'Timor Tengah Utara',capital_name:'Kefamenanu',type:1],
  [province: province, name: 'Rote Ndao',capital_name:'Baa',type:1],
  [province: province, name: 'Sabu Raijua',capital_name:'West Savu',type:1],
  [province: province, name: 'Sikka',capital_name:'Maumere',type:1],
  [province: province, name: 'Timor Tengah Selatan',capital_name:'Soe',type:1],
  [province: province, name: 'Sumba Barat Daya',capital_name:'Tambolaka',type:1],
  [province: province, name: 'Manggarai Barat',capital_name:'Labuan Bajo',type:1],
  [province: province, name: 'Sumba Barat',capital_name:'Waikabubak',type:1],
  [province: province, name: 'Kupang',capital_name:'',type:2],
]
regency_list << regency

## Kalimantan Barat
province = Province.find_by(name: 'Kalimantan Barat')
regency = [
  [province: province, name: 'Bengkayang',capital_name:'Bengkayang',type:1],
  [province: province, name: 'Kapuas Hulu',capital_name:'Putussibau',type:1],
  [province: province, name: 'Kayong Utara',capital_name:'Sukadana',type:1],
  [province: province, name: 'Ketapang',capital_name:'Ketapang',type:1],
  [province: province, name: 'Kubu Raya',capital_name:'Sungai Raya',type:1],
  [province: province, name: 'Landak',capital_name:'Ngabang',type:1],
  [province: province, name: 'Melawi',capital_name:'Nanga Pinoh',type:1],
  [province: province, name: 'Pontianak',capital_name:'Mempawah',type:1],
  [province: province, name: 'Sambas',capital_name:'Sambas',type:1],
  [province: province, name: 'Sanggau',capital_name:'Sanggau',type:1],
  [province: province, name: 'Sekadau',capital_name:'Sekadau',type:1],
  [province: province, name: 'Sintang',capital_name:'Sintang',type:1],
  [province: province, name: 'Pontianak',capital_name:'',type:2],
  [province: province, name: 'Singkawang',capital_name:'',type:2],
]
regency_list << regency

## Kalimantan Selatan
province = Province.find_by(name: 'Kalimantan Selatan')
regency = [
  [province: province, name: 'Balangan',capital_name:'Paringin',type:1],
  [province: province, name: 'Banjar',capital_name:'Martapura',type:1],
  [province: province, name: 'Barito Kuala',capital_name:'Marabahan',type:1],
  [province: province, name: 'Hulu Sungai Tengah',capital_name:'Barabai',type:1],
  [province: province, name: 'Kotabaru',capital_name:'Kotabaru',type:1],
  [province: province, name: 'Hulu Sungai Utara',capital_name:'Amuntai',type:1],
  [province: province, name: 'Hulu Sungai Selatan',capital_name:'Kandangan',type:1],
  [province: province, name: 'Tabalong',capital_name:'Batulicin',type:1],
  [province: province, name: 'Tanah Laut',capital_name:'Tanjung',type:1],
  [province: province, name: 'Tanah Bumbu',capital_name:'Pelaihari',type:1],
  [province: province, name: 'Tapin',capital_name:'Rantau',type:1],
  [province: province, name: 'Banjarbaru',capital_name:'',type:2],
  [province: province, name: 'Banjarmasin',capital_name:'',type:2],
]
regency_list << regency

## Kalimantan Tengah
province = Province.find_by(name: 'Kalimantan Tengah')
regency = [
  [province: province, name: 'Barito Timur',capital_name:'Tamiang',type:1],
  [province: province, name: 'Kotawaringin Timur',capital_name:'Sampit',type:1],
  [province: province, name: 'Gunung Mas',capital_name:'Kuala Kurun',type:1],
  [province: province, name: 'Kapuas',capital_name:'Kapuas',type:1],
  [province: province, name: 'Katingan',capital_name:'Kasongan',type:1],
  [province: province, name: 'Lamandau',capital_name:'Nanga Bulik',type:1],
  [province: province, name: 'Murung Raya',capital_name:'Puruk Cahu',type:1],
  [province: province, name: 'Barito Utara',capital_name:'Muarateweh',type:1],
  [province: province, name: 'Pulang Pisau',capital_name:'Pulang Pisau',type:1],
  [province: province, name: 'Sukamara',capital_name:'Sukamara',type:1],
  [province: province, name: 'Seruyan',capital_name:'Kuala Pembuang',type:1],
  [province: province, name: 'Barito Selatan',capital_name:'Buntok',type:1],
  [province: province, name: 'Kotawaringin Barat',capital_name:'Pangkalan Bun',type:1],
  [province: province, name: 'Palangka Raya',capital_name:'',type:2],
]
regency_list << regency

## Kalimantan Timur
province = Province.find_by(name: 'Kalimantan Timur')
regency = [
  [province: province, name: 'Berau',capital_name:'Tanjung Redeb',type:1],
  [province: province, name: 'Kutai Timur',capital_name:'Sangatta',type:1],
  [province: province, name: 'Kutai Kartanegara',capital_name:'Tenggarong',type:1],
  [province: province, name: 'Mahakam Ulu',capital_name:'Ujoh Bilang',type:1],
  [province: province, name: 'Penajam Paser Utara',capital_name:'Penajam',type:1],
  [province: province, name: 'Paser',capital_name:'Tanah Grogot',type:1],
  [province: province, name: 'Kutai Barat',capital_name:'Sendawar',type:1],
  [province: province, name: 'Balikpapan',capital_name:'',type:2],
  [province: province, name: 'Bontang',capital_name:'',type:2],
  [province: province, name: 'Samarinda',capital_name:'',type:2],
]
regency_list << regency

## Kalimantan Utara
province = Province.find_by(name: 'Kalimantan Utara')
regency = [
  [province: province, name: 'Bulungan',capital_name:'Tanjung Selor',type:1],
  [province: province, name: 'Malinau',capital_name:'Malinau',type:1],
  [province: province, name: 'Nunukan',capital_name:'Nunukan',type:1],
  [province: province, name: 'Tana Tidung',capital_name:'Tideng Pale',type:1],
  [province: province, name: 'Tarakan',capital_name:'',type:2],
]
regency_list << regency

## Gorontalo
province = Province.find_by(name: 'Gorontalo')
regency = [
  [province: province, name: 'Boalemo',capital_name:'Tilamuta',type:1],
  [province: province, name: 'Bone Bolango',capital_name:'Suwawa',type:1],
  [province: province, name: 'Gorontalo',capital_name:'Limboto',type:1],
  [province: province, name: 'Gorontalo Utara',capital_name:'Kwandang',type:1],
  [province: province, name: 'Pahuwato',capital_name:'Marisa',type:1],
  [province: province, name: 'Gorontalo',capital_name:'',type:2],
]
regency_list << regency

## Sulawesi Selatan
province = Province.find_by(name: 'Sulawesi Selatan')
regency = [
  [province: province, name: 'Bantaeng',capital_name:'Bantaeng',type:1],
  [province: province, name: 'Barru',capital_name:'Barru',type:1],
  [province: province, name: 'Tulang',capital_name:'Watampone',type:1],
  [province: province, name: 'Bulukumba',capital_name:'Bulukumba',type:1],
  [province: province, name: 'Luwu Timur',capital_name:'Malili',type:1],
  [province: province, name: 'Enrekang',capital_name:'Enrekang',type:1],
  [province: province, name: 'Gowa',capital_name:'Sungguminasa',type:1],
  [province: province, name: 'Jeneponto',capital_name:'Bontosunggu',type:1],
  [province: province, name: 'Luwu',capital_name:'Belopa',type:1],
  [province: province, name: 'Luwu Utara',capital_name:'Masamba',type:1],
  [province: province, name: 'Toraja Utara',capital_name:'Rantepao',type:1],
  [province: province, name: 'Maros',capital_name:'Maros',type:1],
  [province: province, name: 'Kepulauan Pangkajene',capital_name:'Pangkajene',type:1],
  [province: province, name: 'Pinrang',capital_name:'Pinrang',type:1],
  [province: province, name: 'Kepulauan Selayar',capital_name:'Benteng',type:1],
  [province: province, name: 'Sinjai',capital_name:'Sinjai',type:1],
  [province: province, name: 'Sidenreng Rappang',capital_name:'Sidenreng',type:1],
  [province: province, name: 'Soppeng',capital_name:'Watan Soppeng',type:1],
  [province: province, name: 'Takalar',capital_name:'Takalar',type:1],
  [province: province, name: 'Tana Toraja',capital_name:'Makale',type:1],
  [province: province, name: 'Wajo',capital_name:'Sengkang',type:1],
  [province: province, name: 'Makassar',capital_name:'',type:2],
  [province: province, name: 'Palopo',capital_name:'',type:2],
  [province: province, name: 'Parepare',capital_name:'',type:2],
]
regency_list << regency

## Sulawesi Barat
province = Province.find_by(name: 'Sulawesi Barat')
regency = [
  [province: province, name: 'Mamuju Tengah',capital_name:'Tobadak',type:1],
  [province: province, name: 'Majene',capital_name:'Majene',type:1],
  [province: province, name: 'Mamasa',capital_name:'Mamasa',type:1],
  [province: province, name: 'Mamuju',capital_name:'Mamuju',type:1],
  [province: province, name: 'Pasangkayu',capital_name:'Pasangkayu',type:1],
  [province: province, name: 'Polewali Mandar',capital_name:'Polewali',type:1],
]
regency_list << regency

## Sulawesi Tenggara
province = Province.find_by(name: 'Sulawesi Tenggara')
regency = [
  [province: province, name: 'Bombana',capital_name:'Rumbia',type:1],
  [province: province, name: 'Buton',capital_name:'Pasar Wajo',type:1],
  [province: province, name: 'Buton Tengah',capital_name:'Labungkari',type:1],
  [province: province, name: 'Kolaka Timur',capital_name:'Tirawuta',type:1],
  [province: province, name: 'Kolaka',capital_name:'Kolaka',type:1],
  [province: province, name: 'Konawe',capital_name:'Unaaha',type:1],
  [province: province, name: 'Kepulauan Konawe',capital_name:'Langara',type:1],
  [province: province, name: 'Muna',capital_name:'Raha',type:1],
  [province: province, name: 'Buton Utara',capital_name:'Burangga',type:1],
  [province: province, name: 'Kolaka Utara',capital_name:'Lasusua',type:1],
  [province: province, name: 'Konawe Utara',capital_name:'Wanggudu',type:1],
  [province: province, name: 'Buton Selatan',capital_name:'Batauga',type:1],
  [province: province, name: 'Konawe Selatan',capital_name:'Andolo',type:1],
  [province: province, name: 'Wakatobi',capital_name:'Wangi-Wangi',type:1],
  [province: province, name: 'Muna Barat',capital_name:'Laworo',type:1],
  [province: province, name: 'Baubau',capital_name:'',type:2],
  [province: province, name: 'Kendari',capital_name:'',type:2],
]
regency_list << regency

## Sulawesi Tengah
province = Province.find_by(name: 'Sulawesi Tengah')
regency = [
  [province: province, name: 'Banggai',capital_name:'Luwuk',type:1],
  [province: province, name: 'Kepulauan Banggai',capital_name:'Salakan',type:1],
  [province: province, name: 'Banggai Laut',capital_name:'Banggai',type:1],
  [province: province, name: 'Buol',capital_name:'Buol',type:1],
  [province: province, name: 'Donggala',capital_name:'Donggala',type:1],
  [province: province, name: 'Morowali',capital_name:'Bungku',type:1],
  [province: province, name: 'Morowali Utara',capital_name:'Kolonodale',type:1],
  [province: province, name: 'Parigi Moutong',capital_name:'Parigi',type:1],
  [province: province, name: 'Poso',capital_name:'Poso',type:1],
  [province: province, name: 'Sigi',capital_name:'Sigi Biromaru',type:1],
  [province: province, name: 'Tojo Una-Una',capital_name:'Ampana',type:1],
  [province: province, name: 'Tolitoli',capital_name:'Tolitoli',type:1],
  [province: province, name: 'Palu',capital_name:'',type:2],
]
regency_list << regency

## Sulawesi Utara
province = Province.find_by(name: 'Sulawesi Utara')
regency = [
  [province: province, name: 'Bolaang Mongondow',capital_name:'Lolak',type:1],
  [province: province, name: 'Bolaang Mongondow Timur',capital_name:'Tutuyan',type:1],
  [province: province, name: 'Minahasa',capital_name:'Tondano',type:1],
  [province: province, name: 'Bolaang Mongondow Utara',capital_name:'Boroko',type:1],
  [province: province, name: 'Minahasa Utara',capital_name:'Airmadidi',type:1],
  [province: province, name: 'Kepulauan Sangihe',capital_name:'Tahuna',type:1],
  [province: province, name: 'Kepulauan Sitaro',capital_name:'Ondong',type:1],
  [province: province, name: 'Bolaang Mongondow Selatan',capital_name:'Boolang Uki',type:1],
  [province: province, name: 'Minahasa Selatan',capital_name:'Amurang',type:1],
  [province: province, name: 'Minahasa Tenggara',capital_name:'Ratahan',type:1],
  [province: province, name: 'Kepulauan Talaud',capital_name:'Melonguane',type:1],
  [province: province, name: 'Bitung',capital_name:'',type:2],
  [province: province, name: 'Kotamobagu',capital_name:'',type:2],
  [province: province, name: 'Manado',capital_name:'',type:2],
  [province: province, name: 'Tomohon',capital_name:'',type:2],
]
regency_list << regency

## Maluku
province = Province.find_by(name: 'Maluku')
regency = [
  [province: province, name: 'Kepulauan Aru',capital_name:'Dobo',type:1],
  [province: province, name: 'Buru',capital_name:'Namlea',type:1],
  [province: province, name: 'Maluku Tengah',capital_name:'Masohi',type:1],
  [province: province, name: 'Seram Bagian Timur',capital_name:'Bula',type:1],
  [province: province, name: 'Buru Selatan',capital_name:'Namrole',type:1],
  [province: province, name: 'Maluku Tenggara',capital_name:'Langgur',type:1],
  [province: province, name: 'Maluku Barat Daya',capital_name:'Tiakur',type:1],
  [province: province, name: 'Kepulauan Tanimbar',capital_name:'Saumlaki',type:1],
  [province: province, name: 'Seram Barat',capital_name:'Piru',type:1],
  [province: province, name: 'Ambon',capital_name:'',type:2],
  [province: province, name: 'Tual',capital_name:'',type:2],
]
regency_list << regency

## Maluku Utara
province = Province.find_by(name: 'Maluku Utara')
regency = [
  [province: province, name: 'Halmahera Tengah',capital_name:'Weda',type:1],
  [province: province, name: 'Halmahera Timur',capital_name:'Maba',type:1],
  [province: province, name: 'Pulau Morotai',capital_name:'Daruba',type:1],
  [province: province, name: 'Halmahera Utara',capital_name:'Tobelo',type:1],
  [province: province, name: 'Halmahera Selatan',capital_name:'Labuha',type:1],
  [province: province, name: 'Kepulauan Sula',capital_name:'Sanana',type:1],
  [province: province, name: 'Pulau Taliabu',capital_name:'Bobong',type:1],
  [province: province, name: 'Halmahera Barat',capital_name:'Jailolo',type:1],
  [province: province, name: 'Ternate',capital_name:'',type:2],
  [province: province, name: 'Tidore',capital_name:'',type:2],
]
regency_list << regency

## Papua Barat
province = Province.find_by(name: 'Papua Barat')
regency = [
  [province: province, name: 'Fak-Fak',capital_name:'Fak-Fak',type:1],
  [province: province, name: 'Kaimana',capital_name:'Kaimana',type:1],
  [province: province, name: 'Manokwari',capital_name:'Manokwari',type:1],
  [province: province, name: 'Maybrat',capital_name:'Kumurkek',type:1],
  [province: province, name: 'Raja Ampat',capital_name:'Waisai',type:1],
  [province: province, name: 'Pegunungan Arfak',capital_name:'Anggi',type:1],
  [province: province, name: 'Sorong',capital_name:'Aimas',type:1],
  [province: province, name: 'Manokwari Selatan',capital_name:'Ransiki',type:1],
  [province: province, name: 'Sorong Selatan',capital_name:'Teminabuan',type:1],
  [province: province, name: 'Tambrauw',capital_name:'Fef',type:1],
  [province: province, name: 'Teluk Bintuni',capital_name:'Bintuni',type:1],
  [province: province, name: 'Teluk Wondama',capital_name:'Rasiei',type:1],
  [province: province, name: 'Sorong',capital_name:'',type:2],
]
regency_list << regency

## Papua
province = Province.find_by(name: 'Papua')
regency = [
  [province: province, name: 'Asmat',capital_name:'Agats',type:1],
  [province: province, name: 'Biak Numfor',capital_name:'Biak',type:1],
  [province: province, name: 'Boven Digoel',capital_name:'Tanahmerah',type:1],
  [province: province, name: 'Mamberamo Tengah',capital_name:'Kobakma',type:1],
  [province: province, name: 'Deiyai',capital_name:'Tigi',type:1],
  [province: province, name: 'Dogiyai',capital_name:'Kigamani',type:1],
  [province: province, name: 'Intan Jaya',capital_name:'Sugapa',type:1],
  [province: province, name: 'Jayapura',capital_name:'Sentani',type:1],
  [province: province, name: 'Jayawijaya',capital_name:'Wamena',type:1],
  [province: province, name: 'Keerom',capital_name:'Waris',type:1],
  [province: province, name: 'Lanny Jaya',capital_name:'Tiom',type:1],
  [province: province, name: 'Mamberamo Raya',capital_name:'Burmeso',type:1],
  [province: province, name: 'Mappi',capital_name:'Kepi',type:1],
  [province: province, name: 'Merauke',capital_name:'Merauke',type:1],
  [province: province, name: 'Mimika',capital_name:'Timika',type:1],
  [province: province, name: 'Nabire',capital_name:'Nabire',type:1],
  [province: province, name: 'Nduga',capital_name:'Kenyam',type:1],
  [province: province, name: 'Paniai',capital_name:'Enarotali',type:1],
  [province: province, name: 'Pegunungan Bintang',capital_name:'Oksibil',type:1],
  [province: province, name: 'Puncak',capital_name:'Ilaga',type:1],
  [province: province, name: 'Puncak Jaya',capital_name:'Kota Mulia',type:1],
  [province: province, name: 'Sarmi',capital_name:'Sarmi',type:1],
  [province: province, name: 'Supiori',capital_name:'Sorendiweri',type:1],
  [province: province, name: 'Tolikara',capital_name:'Karubaga',type:1],
  [province: province, name: 'Waropen',capital_name:'Botawa',type:1],
  [province: province, name: 'Yahukimo',capital_name:'Sumohai',type:1],
  [province: province, name: 'Yalimo',capital_name:'Elelim',type:1],
  [province: province, name: 'Kepulauan Yapen',capital_name:'Serui',type:1],
  [province: province, name: 'Jayapura',capital_name:'',type:2],
]
regency_list << regency

regency_list.flatten

Regency.create(regency_list)
# ========== Shop Group ==========
shop_groups = [
  [name: 'Rizzky Motor', subscriber_type: 1],
  [name: 'Bengkel Yo Matic', subscriber_type: 1],
  [name: 'ARYA Mandiri Motor', subscriber_type: 1],
  [name: 'Sumber Jaya Motor', subscriber_type: 1],
  [name: 'Scooter Jam', subscriber_type: 2],
  [name: 'Devmotor', subscriber_type: 1],
  [name: 'Devmotor-ms', subscriber_type: 2]
]

ShopGroup.create(shop_groups)

# ========== Shop ==========
region = Region.find_by(name: 'Jawa')
province_11 = Province.find_by(name: 'Daerah Khusus Ibukota Jakarta')
province_12 = Province.find_by(name: 'Banten')
regency_159 = Regency.find_by(name: 'Jakarta Selatan')
regency_160 = Regency.find_by(name: 'Jakarta Barat')
regency_167 = Regency.find_by(name: 'Tangerang', type: 2)
regency_168 = Regency.find_by(name: 'Tangerang Selatan')
shop_list = [
  [bengkel_id: '100001', shop_group_id: 6, name: 'Devmotor', address: 'Jl. Kasuari Blok HB2 No.31, Pd. Aren, Kota Tangerang Selatan, Banten 15229',tel: '',region: region, province: province_12, regency: regency_168, subscriber_type: 1, expiration_date: DateTime.now + 30],
  [bengkel_id: '100002', shop_group_id: 7, name: 'Devmotor-ms1', address: 'Jl. Sabar No.25, RT.1/RW.3, Petukangan Sel., Pesanggrahan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12270',tel: '',region: region, province: province_11, regency: regency_159, subscriber_type: 1, expiration_date: DateTime.now + 30],
  [bengkel_id: '100003', shop_group_id: 7, name: 'Devmotor-ms2', address: 'Blok E 8 No. 12,, Lengkong Gudang Tim., Tangerang,, Jl. Letnan Sutopo, Lengkong Gudang Tim., Serpong, Kota Tangerang Selatan, Banten 15310',tel: '(061) 7326167',region: region, province: province_12, regency: regency_168, subscriber_type: 1, expiration_date: DateTime.now + 30],
  [bengkel_id: '100004', name: 'Katros Garage', address: 'Jl. Cemp.1 no.2, Rengas, Ciputat Tim., Kota Tangerang Selatan, Banten 15412',tel: '',region: region, province: province_12, regency: regency_168, subscriber_type: 1, expiration_date: DateTime.now + 30],
  [bengkel_id: '100005', name: 'ICHIRO Motor', address: 'Jl. Raya Pd. Kacang Tim. No.9, Pd. Kacang Tim., Tangerang, Kota Tangerang Selatan, Banten 15226',tel: '',region: region, province: province_12, regency: regency_168, subscriber_type: 1, expiration_date: DateTime.now + 30],
  [bengkel_id: '100006', name: 'Garage 19 | Big Twin Supply', address: 'no. Mampang Prapatan, Jalan Bangka Raya No.19, RT.6/RW.1, Pela Mampang, Mampang Prapatan, South Jakarta City, Jakarta 12720',tel: '',region: region, province: province_11, regency: regency_159, subscriber_type: 1, expiration_date: DateTime.now + 30],
  [bengkel_id: '100007', name: 'Cleveland Cyclewerks Indonesia (PT. Sumatra Motor Indonesia)', address: 'Jl. Bintaro Utama 3 Blok AP No.49, Pd. Betung, Pd. Aren, Kota Tangerang Selatan, Banten 15221',tel: '',region: region, province: province_12, regency: regency_168, subscriber_type: 1, expiration_date: DateTime.now + 30],
  [bengkel_id: '100008', name: 'Bengkel Press Jbb Pressindo Kreo Ciledug', address: 'Kreo Larangan No 2, Jalan HOS. Cokroaminoto Dpn Gian Kreo, Kreo Selatan, Larangan, Kota Tangerang, Banten 15154',tel: '',region: region, province: province_12, regency: regency_168, subscriber_type: 1, expiration_date: DateTime.now + 30],
  [bengkel_id: '100009', name: 'Bengkel Federal Jumbo Motor (Bajaj Pulsar)', address: 'Ruko Puri Beta 1, Jl. HOS Cokroaminoto No.8, Larangan Utara, Larangan, Kota Tangerang, Banten, Banten 15154',tel: '',region: region, province: province_12, regency: regency_168, subscriber_type: 1, expiration_date: DateTime.now + 30],
  [bengkel_id: '100010', name: 'Aerospeed 74 - Speedshop', address: 'Jalan Deplu Raya No.74, RT.1/RW.3, Bintaro, Pesanggrahan, RT.1/RW.3, Bintaro, Pesanggrahan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12330',tel: '',region: region, province: province_11, regency: regency_159, subscriber_type: 1, expiration_date: DateTime.now + 30],
  [bengkel_id: '100011', name: 'Umam Motor Ciledug', address: 'Jalan Raden Fattah, Jl. Swadaya Raya No.66, Parung Serab, Ciledug, Kota Tangerang, Banten 15153',tel: '0859-2130-0042',region: region, province: province_12, regency: regency_168, subscriber_type: 1, expiration_date: DateTime.now + 30],
  [bengkel_id: '100012', name: 'THRIVE MOTORCYCLE', address: 'Jl. Kemang Timur No.15, RT.7/RW.3, Bangka, Mampang Prpt., Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12730',tel: '',region: region, province: province_11, regency: regency_159, subscriber_type: 1, expiration_date: DateTime.now + 30],
  [bengkel_id: '100013', name: 'ProScooter', address: 'Jl. Pd. Betung Raya No.88, Pd. Karya, Pd. Aren, Kota Tangerang Selatan, Banten 15225',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100014', name: 'Permana Motor', address: 'Jl. RS Fatmawati No.33, RT.2/RW.2, Cipete Sel., Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12420',tel: '(021) 55726155',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100015', name: 'Motospa Jakarta', address: 'Jl. Prapanca Raya No.12E, RT.9/RW.8, Cipete Utara, Kby. Baru, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12150',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100016', name: 'Modifikasi Motor Roda 3 Catur Bambang', address: 'Jl. Jambu No.10B, Cemp. Putih, Ciputat Tim., Kota Tangerang Selatan, Banten 15412',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100017', name: 'Lukas Spool Motor', address: 'Jl. Ceger No.48, Jurang Mangu Barat, Pd. Aren, Kota Tangerang Selatan, Banten 15223',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100018', name: 'Fast Pancoran', address: 'Jl. MT Haryono Kav 1, RT.01/RW.06, Pancoran, Tebet Barat, Tebet, RT.1/RW.6, Tebet Bar., Tebet, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12810',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100019', name: 'Eliazar Scooter Work', address: 'Jalan Padang Putera No.29, RT.2/RW.9, Jati Padang, Ps. Minggu, Kota Jakarta Selatan, DKI Jakarta 12540',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100020', name: 'Bengkel Motor Rido Racing', address: 'Jl. Mawar 1 No.9a, RT.2, Rempoa, Ciputat Tim., Kota Tangerang Selatan, Banten 15412',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100021', name: 'BENGKEL MOTOR 99', address: 'Depan Calissa Home, Jl. Duren Bangka No.2, RT.2/RW.2, Duren Tiga, Pancoran, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12530',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100022', name: 'BENGKEL AKANG MILYS', address: 'Jl. Aria Putra No.19, Serua Indah, Ciputat, Kota Tangerang Selatan, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100023', name: 'Warung Bengkel Deden', address: 'Jl. Ki Hajar Dewantara No.101, Sawah Lama, Ciputat, Kota Tangerang Selatan, Banten 15413',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100024', name: 'Wahyu Motor', address: 'Jl. Sukamulya Raya No.6-7, Serua Indah, Ciputat, Kota Tangerang Selatan, Banten 15414',tel: '(021) 42873837',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100025', name: 'Top Press', address: 'Jl. Bangka Raya No.3C, RT.2/RW.1, Pela Mampang, Mampang Prpt., Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12720',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100026', name: 'Thrill Bitz', address: 'Jalan Benda Raya No.20B,Cilandak Timur, Pasar Minggu, Jakarta Selatan 12560, RT.6/RW.4, Cilandak Tim., Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12560',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100027', name: 'Suji Putera Motor', address: 'Jl. Bangka 3 No.41, RT.14/RW.3, Pela Mampang, Mampang Prpt., Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12720',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100028', name: 'Showroom Bangka Jaya Motor', address: 'Jl. Bangka Raya No.11, RT.11/RW.11, Pela Mampang, Mampang Prpt., Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12720',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100029', name: 'SARANA JAYA motor', address: 'Jalan Pucung Raya RT 012 RW 001 Bintaro Sektor 8 Pondok Pondok Aren, Pd. Jaya, Pd. Aren, Kota Tangerang Selatan, Banten 15220',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100030', name: 'Sam RedBlack Jok Motor', address: 'Jl. Aria Putra No.8, Sawah Baru, Ciputat, Kota Tangerang Selatan, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100031', name: 'Ricky Motor', address: 'Jl. Serua Poncol No.118, Pd. Pucung, Tangerang, Kota Tangerang Selatan, Banten 15229',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100032', name: 'RICH MOTOR', address: 'Jalan Tegal Rotan Raya RT 002 RW 001 No 24 Pondok Aren, Pd. Jaya, Pd. Aren, Kota Tangerang Selatan, Banten 15413',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100033', name: 'Pungky Motor Modification', address: 'Jl. Kramat No.15, Rengas, Ciputat Tim., Kota Tangerang Selatan, Banten 15412',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100034', name: 'PT. Nusa Prima Motor', address: 'Jl. W R Supratman No.6A, RT.2/RW.9, Cemp. Putih, Ciputat Tim., Kota Tangerang Selatan, Banten 15412',tel: '(021) 75903390',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100035', name: 'PRIMA MANDIRI MOTOR', address: 'RT 001 RW 005 Pondok Aren, Jl. Kp. Rw. Bar., Pd. Pucung, Pd. Aren, Kota Tangerang Selatan, Banten 15229',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100036', name: 'Pancoran Bengkel Motor', address: 'Jl. Raya Pasar Minggu No.20, RT.6/RW.2, Pancoran, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12780',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100037', name: 'Palem Biru Motor 2', address: 'Sawah Baru, Ciputat, South Tangerang City, Banten 15413',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100038', name: 'Mastom Custom', address: 'Jl. Kemang Selatan VIII B No.67, RT.7/RW.2, Bangka, Mampang Prpt., Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12730',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100039', name: 'Maleo Garage', address: 'Jl. Maleo Ⅳ jb3 no.7, Pd. Pucung, Pd. Aren, Kota Tangerang Selatan, Banten 15229',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100040', name: 'MALEO CUSTOM (Ricky)', address: 'Jl. Swadaya No.31, Pd. Pucung, Pd. Aren, Kota Tangerang Selatan, Banten 15229',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100041', name: 'Male Motor', address: 'Jl. Pendidikan II, Parigi, Pd. Aren, Kota Tangerang Selatan, Banten 15227',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100042', name: 'Mail Motor Custom', address: 'Jl. Aria Putra Blok Sukasari II No.21, Serua Indah, Ciputat, Kota Tangerang Selatan, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100043', name: 'Lamro Motor Building', address: 'Jl. Lb. Bulus I No.30, RT.4/RW.4, Cilandak Bar., Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100044', name: 'Kembar Racing Team', address: 'JL. M Saidi 4 RT 005/01, Jakarta, 12270, RT.7/RW.5, South Petukangan, Pesanggrahan, South Jakarta City, Jakarta 12270',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100045', name: 'JMS Mitsuto', address: 'Jl. Ciputat Raya No.42, RT.13/RW.1, Kby. Lama Sel., Kby. Lama, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12240',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100046', name: 'Fahmi Motor', address: 'JL. Waru Doyong, Kp. Pasir, Jombang, Tangerang, Kota Tangerang Selatan, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100047', name: 'Evolution Motor', address: 'No.63B, RT.9/RW.3, Tegal Parang, Mampang Prpt., Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12790',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100048', name: 'Dunia Motor', address: 'Jl. Raya Pasar Minggu No.3, RT.6/RW.1, Pejaten Bar., Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12510',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100049', name: 'DMM Motor', address: 'komplek permai, blok D7 no. 19 bsd, Jl. Dahlia III, Ciater, Serpong, Kota Tangerang Selatan, Banten 15310',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100050', name: 'Dimas Motor', address: 'Jl. Ceger Raya No.44, Jurang Manggu Tim., Pd. Aren, Kota Tangerang Selatan, Banten 15225',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100051', name: 'Dieci Moto Indonesia', address: 'Jl. Pangeran Antasari No.25, RT.5/RW.13, Cilandak Bar., Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100052', name: 'Candi Jaya Motor', address: 'Jl. H. Nawi Raya No.80, RT.3, Gandaria Utara, Kby. Baru, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12140',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100053', name: 'Bintang Motor', address: 'Jl. H.Mencong, Paninggilan Utara, Ciledug, Kota Tangerang, Banten 15153',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100054', name: 'BERKAT MOTOR', address: '# Perempatan Zodiac Pondok Aren, Gg. Buntu No.99, Parigi, Pd. Aren, Kota Tangerang Selatan, Banten 15229',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100055', name: 'Benny Motor', address: 'Jl. Kp. Cilalung, Jombang, Ciputat, Kota Tangerang Selatan, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100056', name: 'Bengkel Satrio', address: 'Jl. Asem II No.54, RT.1/RW.3, Cipete Sel., Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12410',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100057', name: 'bengkel romasly', address: 'Unnamed Road, Pd. Karya, Pd. Aren, Pd. Karya, Pd. Aren, Kota Tangerang Selatan, Banten 15225',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100058', name: 'Bengkel Racun Speed', address: 'Jl. Delima Jaya IV No.23, Rempoa, Ciputat Tim., Kota Tangerang Selatan, Banten 15412',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100059', name: 'Bengkel Pak Karlan', address: 'Jl. KH. Muhasyim VII No.40, RT.14/RW.6, Cilandak Bar., Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430',tel: '(0411) 3627323',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100060', name: 'Bengkel Motor Tama Speed', address: 'Jalan Merpati Raya No. 29, Sawah Lama, Ciputat, Sawah Baru, Ciputat, Kota Tangerang Selatan, Banten 15413',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100061', name: 'Bengkel Motor Pa\de', address: 'Pasar Jumat Jalan Batan No. 3 1 2, RT.1/RW.2, Lb. Bulus, Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12440',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100062', name: 'Bengkel Motor Kardi', address: 'Jl. Kalibata Tengah, RT.1/RW.9, Kalibata, Pancoran, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12740',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100063', name: 'Bengkel Motor Jaya', address: 'Plaza Cordoba, Jl. Batam, Rw. Mekar Jaya, Serpong, Kota Tangerang Selatan, Banten 15310',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100064', name: 'Bengkel Motor Eva Bunga', address: 'East Lengkong Gudang, Serpong, South Tangerang City, Banten 15310',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100065', name: 'Bengkel Motor Doms Daffa Otomotif', address: 'Jl. Tidore, RT.04/RW.17, Jombang, Ciputat, Kota Tangerang Selatan, Banten 15227',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100066', name: 'Bengkel Motor Deny', address: 'Jl. Raya Pd. Kacang No.25, Parigi, Pd. Aren, Kota Tangerang Selatan, Banten 15228',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100067', name: 'Bengkel Motor Ano', address: 'Jl. Aria Putra No.1011, Serua, Ciputat, Kota Tangerang Selatan, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100068', name: 'Bengkel Motor 57', address: 'Jl. Menjangan III, Pd. Ranji, Ciputat Tim., Kota Tangerang Selatan, Banten 15412',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100069', name: 'Bengkel Motor', address: 'Jl. Pancoran Barat VII No.2, RT.15/RW.1, Pancoran, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12760',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100070', name: 'Bengkel Motor', address: 'Jl. Pancoran Barat VII No.2, RT.15/RW.1, Pancoran, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12760',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100071', name: 'Bengkel Las', address: 'Jl. Makam No.57, RT.2/RW.11, Cipulir, Kby. Lama, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12230',tel: '(021) 79192611',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100072', name: 'Bengkel Isep', address: 'Jl. Sektor IX, Sudimara Jaya, Ciledug, Kota Tangerang, Banten 15151',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100073', name: 'Bengkel HRS MOTORS', address: 'Jl. Aria Putra, Serua Indah, Ciputat, Kota Tangerang Selatan, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100074', name: 'Bengkel Garasi78', address: 'Jalan Pondok Betung Raya Blok BC No.38, Pondok Karya, Pondok Aren, Pd. Karya, Pd. Aren, Kota Tangerang Selatan, Banten 15225',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100075', name: 'bengkel dedi', address: 'Jl. Cendrawasih, RT.004 rw03/RW.no 45, Sawah Baru, Ciputat, Kota Tangerang Selatan, Banten 15413',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100076', name: 'Bengkel Bubut Bali Ayu Motor', address: 'Jl. Belem No.29, RT.1/RW.8, Jombang, Ciputat, Kota Tangerang Selatan, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100077', name: 'Bengkel Berkah Motor-Bang Budi', address: 'Gang Sawo, Jombang, Ciputat, Kota Tangerang Selatan, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100078', name: 'Bengkel Bayu Motor', address: 'Jl. Musyawarah No.16, Sawah Lama, Ciputat, Kota Tangerang Selatan, Banten 15413',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100079', name: 'Bangka Motor Service & Sparepart', address: 'Jl. Bangka Raya, RT.8/RW.11, Pela Mampang, Mampang Prpt., Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12730',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100080', name: 'AS Bengkel Bubut Dan Korter', address: 'Pondok Aren, Jl. Pd. Betung Raya No.9, Pd. Betung, Tangerang selatan, Kota Tangerang Selatan, Banten 15225',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100081', name: 'Armand Jaya Motor', address: 'Jl. Masjid Ar-Rachman No.15A, RT.16/RW.6, Cilandak Bar., Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100082', name: 'Anugrah Motor Bintaro', address: 'Jl. Pd. Betung Raya No.4, Pd. Karya, Pd. Aren, Kota Tangerang Selatan, Banten 15225',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100083', name: 'Amanah Bengkel Motor', address: 'Jl. Merpati Raya No.33, Sawah Baru, Ciputat, Kota Tangerang Selatan, Banten 15413',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100084', name: 'Akbar Motor', address: 'Jl. Ceger Raya No.40, Jurang Manggu Tim., Pd. Aren, Kota Tangerang Selatan, Banten 15222',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100085', name: 'Acoy motor', address: 'Jl. Pangeran Antasari No.17, RT.4/RW.13, Cilandak Bar., Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100086', name: 'Acong Cs Motor', address: 'Jl. Wr. Supratman, Cemp. Putih, Ciputat Tim., Kota Tangerang Selatan, Banten 15412',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100087', name: 'Abdi Jaya Motor', address: 'Jl. Lio Garut, Pd. Kacang Bar., Pd. Aren, Kota Tangerang Selatan, Banten 15228',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100088', name: 'Wd Motor', address: 'Bintaro - Bintaro Trade Centre lt.1 blok e4 no.9, Jl. Jend. Sudirman, Pd. Jaya, Pd. Aren, Kota Tangerang Selatan, Banten 15220',tel: '0857-8255-3444',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100089', name: 'Wahyu Motor', address: 'Jl. Sukamulya Raya No.6-7, Serua Indah, Ciputat, Kota Tangerang Selatan, Banten 15414',tel: '0813-8064-7224',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100090', name: 'Wahana', address: 'Jl. Ir H. Juanda No.135, RT.2/RW.4, Cemp. Putih, Ciputat Tim., Kota Tangerang Selatan, Banten 15412',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100091', name: 'UD Kaisar Bintaro', address: 'Jl. Jombang Raya No. 12 /Gg.H. Sarmah, Pondok Aren, Perigi Lama, Tangerang, Parigi, Pd. Aren, Kota Tangerang Selatan, Banten 15227',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100092', name: 'Ton\s Motor Sport', address: 'K No.25C, Jl. Praja Dalam F, RT.11/RW.2, Kby. Lama Sel., Kby. Lama, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12240',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100093', name: 'Studio Motor Custom Bike', address: 'Jl. Gapura Menteng Asri No. 4, Sektor 5, Bintaro Jaya, Pd. Ranji, Tangerang Selatan, Kota Tangerang Selatan, Banten 15412',tel: '0812-8393-9642',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100094', name: 'Ricky Motor', address: 'Jl. Serua Poncol No.118, Pd. Pucung, Tangerang, Kota Tangerang Selatan, Banten 15229',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100095', name: 'REVOLUSI Motor', address: 'Komplek Ruko Sektor 1-1 Blok RD No 7 Griya Loka BSD City Serpong, Rw. Buntu, Serpong, Kota Tangerang Selatan, Banten 15310',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100096', name: 'Raja Ban 12 motor', address: 'Jl. Kemang Timur No.53A, RT.8/RW.3, Bangka, Mampang Prpt., Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12730',tel: '0812-8396-1200',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100097', name: 'R&J MOTOSPORT', address: 'Jl. Duren Tiga Selatan V No.28, RT.12/RW.1, Duren Tiga, Pancoran, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12760',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100098', name: 'Putera Ragunan Motor', address: 'Jalan Taman Margasatwa No.22, Ragunan, Pasar Minggu, RT.7/RW.5, Jati Padang, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12560',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100099', name: 'Poncol Jaya Bengkel', address: 'Jl. Poncol Jaya No.6, RT.1/RW.5, Kuningan Bar., Mampang Prpt., Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12710',tel: '0897-4489-035',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100100', name: 'PGM Motor (Gaper Motor)', address: 'Jombang, Ciputat, South Tangerang City, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100101', name: 'Perdana Jaya Motor', address: 'Bintaro Trade Centre ( BTC ), Jl. Jend. Sudirman, Pd. Jaya, Pd. Aren, Kota Tangerang Selatan, Banten 15220',tel: '0822-1846-8022',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100102', name: 'Ozi Motor Slow (OMS)', address: 'Jl. Merpati Raya No.1, Sawah Lama, Ciputat, Kota Tangerang Selatan, Banten 15413',tel: '(0411) 420980',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100103', name: 'Ovil Motor', address: 'Komplek Ciputat Molek Blok E1 No. 1, Jl. Legoso Raya, Pisangan, Ciputat Tim., Kota Tangerang Selatan, Banten 15419',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100104', name: 'ORION MINI BIKE', address: 'Jalan Raya No 04 02, Jl. Kp. Rw. Tim. No.9, Jombang, Pd. Aren, Kota Tangerang Selatan, Banten 15229',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100105', name: 'Mustika Motor Antasari', address: 'NO, Jl. Pangeran Antasari No.44, RT.3/RW.11, Cipete Utara, Jakarta Selatan, DKI Jakarta, Daerah Khusus Ibukota Jakarta 12150',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100106', name: 'MR Classic - TGR', address: 'Jl. W R Supratman No.17, Cemp. Putih, Ciputat Tim., Kota Tangerang Selatan, Banten 15412',tel: '(021) 85913048',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100107', name: 'MJ Motor - Bajaj Workshop', address: 'No., Jl. Sultan Iskandar Muda No.28L, RT.2/RW.1, Kby. Lama Sel., Kby. Lama, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12240',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100108', name: 'Mega Finance (Mega Zip) Fatmawati', address: 'Jalan Rs Fatmawati No. 52 B - C, Cilandak Barat, Cilandak, RT.7/RW.3, Cilandak Bar., Jakarta Selatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12430',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100109', name: 'Max Motor', address: 'Jl. Sultan Iskandar Muda No.28A, RT.2/RW.1, Kby. Lama Sel., Kby. Lama, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12240',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100110', name: 'Mas Eko Bengkel', address: 'Jl. Yado 3 Blok A No.9D, RT.1/RW.4, Gandaria Utara, Kby. Baru, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12140',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100111', name: 'Kubis Motor', address: 'Jalan Kubis II 137 1 6, RT.1/RW.6, Pulo, Kby. Baru, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12140',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100112', name: 'Kedai Riders', address: 'Jl. Puri Beta Utara No.58, Larangan Utara, Larangan, Kota Tangerang, Banten 15154',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100113', name: 'Jual Bli Motor Rx King', address: 'Jl. Jurang Mangu Bar., Jurang Mangu Barat, Pd. Aren, Kota Tangerang Selatan, Banten 15222',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100114', name: 'Jo 88 Motor', address: 'Jalan Haji Nawi Raya #7, Gandaria Utara, Kebayoran Baru, RT.4/RW.2, Gandaria Utara, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12140',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100115', name: 'Humisar Motor', address: 'Jl. Anggrek No.1, RT.1/RW.2, Cilandak Tim., Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12560',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100116', name: 'Hotpipes', address: 'No. 15A-B, Ruko JL. RS. Fatmawati, JL. RS. Fatmawati, Gandaria Selatan, 12420 Jakarta Selatan, Indonesia, RT.3/RW.4, South Gandaria, Cilandak, South Jakarta City, Jakarta 12420',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100117', name: 'Hobby Motor', address: 'Jl. Sultan Iskandar Muda, RT.14/RW.6, Kby. Lama Utara, Kby. Lama, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12240',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100118', name: 'Gunung Mas Motor', address: 'No. 20 A, Jl. Raya Pasar Minggu, RT.6/RW.1, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12510',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100119', name: 'Ganesha Motor', address: 'Kp. Gunung, Jl. Jombang Raya No.70, Jombang, Ciputat, Kota Tangerang Selatan, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100120', name: 'Era Motor Pasar Minggu', address: 'Jalan Raya Rawa Bambu No.13, Jl. Raya Pasar Minggu No.5, RT.13/RW.RW, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12520',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100121', name: 'ECX MOTOR', address: 'Jl. Cipete Raya, RT.8/RW.4, Cipete Sel., Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12410',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100122', name: 'Dunia Sepeda Motor', address: 'Jl. Raya Pasar Minggu, RT.5/RW.7, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12510',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100123', name: 'Deni Motor', address: 'Jl. H. Abdul Majid Raya No. 23 Cipete utara kebayoran baru Jakarta Selatan, DKI, Jakarta selatan, RT.13 rw 7, Cipete utara, Kebayoran baru, RT.13/RW.7, Cipete Utara, Kby. Baru, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12150',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100124', name: 'City Motor / D\WA Knalpot', address: 'Jl. Pangeran Antasari No.43, RT.2/RW.11, Cipete Utara, Kby. Baru, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12150',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100125', name: 'Cahaya Tandean Motor', address: 'Jl. Kapten Tendean No.16, RT.1/RW.1, Pela Mampang, Mampang Prpt., Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12720',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100126', name: 'Cahaya Motor', address: 'Jalan Pondok Aren Nomor 9 Rt 02 Rw 01, Pondok Aren, Pd. Aren, Kota Tangerang Selatan, Banten 15224',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100127', name: 'Berutu Bengkel Motor', address: 'Jl. Palem Puri No.3 abc, Pd. Pucung, Pd. Aren, Kota Tangerang Selatan, Banten 15229',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100128', name: 'Berkah Jaya Motor', address: 'Jl. Poncol No.10, RT.6/RW.7, Gandaria Sel., Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12420',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100129', name: 'Berkah Jaya Motor', address: 'Jl. Poncol No.10, RT.6/RW.7, Gandaria Sel., Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12420',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100130', name: 'BENGKEL SINAGA', address: 'Jalan Pahlawan RT 001 RW 001 No 54 Ciputat Timur, Cemp. Putih, Ciputat Tim., Kota Tangerang Selatan, Banten 15412',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100131', name: 'BENGKEL RONY MOTOR', address: 'jalan raya haji gadung, ciputat timur no.10 Rt004/003, Pd. Ranji, Tangerang Selatan, Kota Tangerang Selatan, Banten 15412',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100132', name: 'Bengkel Motor Selebes', address: 'Jl. Swadaya, RT.2/RW.11, Kby. Lama Sel., Kby. Lama, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12240',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100133', name: 'Bengkel motor noe noe', address: 'RT.1/RW.5, South Kebayoran Lama, Jakarta, South Jakarta City, Jakarta 12240',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100134', name: 'Bengkel Motor Jati Motor', address: 'Jl. Buncit Raya No.11, RT.12/RW.9, Kalibata, Pancoran, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12760',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100135', name: 'Bengkel Motor IJM Racing', address: 'North Petukangan, Pesanggrahan, South Jakarta City, Banten 15156',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100136', name: 'Bengkel MOTOR CB BAPAK MINGGU', address: '7 Eleven, Jl. Raya Pasar Minggu, RT.8/RW.9, Pancoran, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12780',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100137', name: 'Bengkel Motor Bintaro', address: 'Jl. Rw. Papan No.4, RT.10/RW.8, Bintaro, Pesanggrahan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12330',tel: '0812-7290-3088',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100138', name: 'Bengkel Jaws Speed', address: 'No., Jl. Cipto Mangunkusumo No.28, Parung Serab, Ciledug, Kota Tangerang, Banten 15153',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100139', name: 'Bengkel BJM Motor (Banyumas Jaya Motor)', address: 'Jl. W R Supratman No.24, Rengas, Ciputat Tim., Kota Tangerang Selatan, Banten 15412',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100140', name: 'Bengkel Ali Motor', address: 'Jl. Masjid Darussalam No.34, Kedaung, Pamulang, Kota Tangerang Selatan, Banten 15415',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100141', name: 'Batavia Motor', address: 'Jl. Merpati Raya No.54, Sawah Lama, Ciputat, Kota Tangerang Selatan, Banten 15413',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100142', name: 'Bajaj', address: 'Jalan TB. Simatupang No. 5, Jagakarsa, RT.8/RW.5, Tj. Bar., Jagakarsa, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12530',tel: '0882-1394-6301',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100143', name: 'ARS Motor Store', address: 'Ruko GRAHA ARS, Jl Raya Ceger No 2A-2B,, Jurang Mangu Timur, Pondok Aren, Jurang Manggu Tim., Pd. Aren, Kota Tangerang Selatan, Banten 15222',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100144', name: 'Anugrah Dika Motor', address: 'Jl. Jombang Raya No.17, RT.2/RW.7, Parigi, Pd. Aren, Kota Tangerang Selatan, Banten 15227',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100145', name: 'Andini Motor', address: 'Jl. Jombang Raya, Jombang, Ciputat, Kota Tangerang Selatan, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100146', name: 'Andalan Betawi Motor', address: 'Jl. Jombang Raya, Pd. Aren, Kota Tangerang Selatan, Banten 15158',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100147', name: 'Amink Motor', address: 'Gang H Sapri Kp Kebantenan, Pd. Aren,, Pd. Aren, Kota Tangerang Selatan, Banten 15224',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100148', name: 'Akbar Motor', address: 'Jl. Ceger Raya No.40, Jurang Manggu Tim., Pd. Aren, Kota Tangerang Selatan, Banten 15222',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100149', name: 'Tri Star Motor', address: 'Jl. Naripan No. 88 Kebon Pisang Sumurbandung Bandung Jawa Barat, RT.1/RW.2, Cipete Utara, Kby. Baru, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12420',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100150', name: 'Yoyo Motor', address: 'Gg. Salih Jenggot No.112, Parigi, Pd. Aren, Kota Tangerang Selatan, Banten 15227',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100151', name: 'Surya Motor', address: 'Jl. Taman Makam Bahagia ABRI, Parigi, Pd. Aren, Kota Tangerang Selatan, Banten 15227',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100152', name: 'Surya Motor', address: 'Jl. Taman Makam Bahagia ABRI, Parigi, Pd. Aren, Kota Tangerang Selatan, Banten 15227',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100153', name: 'Sugi Motor Cipete', address: 'Jl. Abd. Madjid 4, RT.1, Rw. Bar., Jakarta Selatan, DKI Jakarta, Daerah Khusus Ibukota Jakarta 12150',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100154', name: 'Steam Motor BMJ', address: 'West Pondok Kacang, Pondok Aren, South Tangerang City, Banten 15226',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100155', name: 'Roda Jaya Motor', address: 'Jl. Pangeran Antasari No.6A, RT.4/RW.11, Cipete Utara, Kby. Baru, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12150',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100156', shop_group_id: 1, name: 'Rizzky Motor', address: 'Jalan Ceger Raya No.94, Pondok Karya, Kota Tangerang Selatan, Banten 15225',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100157', name: 'Rama Putra Jaya Bengkel', address: 'Jl. Jombang Raya RT 001 %2F RW 01 Perigi Pondok Aren Karawang Jawa Barat, Jurang Mangu Barat, Pd. Aren, Kota Tangerang Selatan, Banten 15222',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100158', name: 'Raffa Motor', address: 'Jl. Kemang Selatan No.65, RT.7/RW.2, Bangka, Mampang Prpt., Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12730',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100159', name: 'Pt.Sentra Armada Motor', address: 'Mitsubishi Motors, Jalan Raya, Rw. Mekar Jaya, Serpong, Kota Tangerang Selatan, Banten 15310',tel: '(021) 8467087',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100160', name: 'Pelita Motor', address: 'Jl. TB Simatupang No.25, RT.2/RW.1, Cilandak Tim., Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12560',tel: '(021) 8752902',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100161', name: 'Ngelektre Ncep IR..1 Motor Modifikasi', address: 'Jl. Swadaya Gg. Swadaya No.21,Pesanggrahan,Kota Jakarta Selatan,Daerah Khusus Ibukota Jakarta, Jl. Swadaya Blok Swadaya No.29, Pd. Karya, Pd. Aren, Kota Tangerang Selatan, Banten 15225',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100162', name: 'Leman Motor', address: 'Jalan Raya Ceger RT2 RW2 #83, Jurang Mangu Timur, Pondok Aren, Jurang Manggu Tim., Pd. Aren, Kota Tangerang Selatan, Banten 15222',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100163', name: 'Kymco Bengkel', address: 'No., Jl. Pahlawan No.3B, RW.13, Rempoa, Ciputat Tim., Kota Tangerang Selatan, Banten 15412',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100164', name: 'JAYA MOTOR', address: 'JL H. Sarmah, No. 37, Pondok Kacang Timur, Tangerang Selatan, Parigi, Tangerang, Kota Tangerang Selatan, Banten 15227',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100165', name: 'Ibana Jaya Motor', address: 'Jalan Kemang Selatan, RT.6/RW.7, Cipete Sel., Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12730',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100166', name: 'Happy Motor Toko', address: 'Jl. Hidup Baru No.22, RT.5/RW.10, Gandaria Utara, Kby. Baru, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12140',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100167', name: 'Golio Motor', address: 'JL. Raya Tegal Rotan, Bintaro, Sawah Baru, Ciputat, Kota Tangerang Selatan, Jakarta 15413',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100168', name: 'GOGOLIO MOTOR', address: 'RT 001 RW 008 Ciputat, Jl. Tegal Rotan Raya, Sawah Baru, Ciputat, Kota Tangerang Selatan, Banten 15413',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100169', name: 'Fitri motor', address: 'Jl. Duren Tiga Selatan No.26, RT.9/RW.2, Duren Tiga, Pancoran, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12740',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100170', name: 'FEBY MOTOR', address: 'No., Jl. Abdul Majid Raya No.6, RT.4/RW.5, Cipete Sel., Jakarta Selatan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12410',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100171', name: 'Family Motor', address: 'Jl. Duren Tiga Selatan No.8, RT.4/RW.2, Duren Tiga, Pancoran, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12760',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100172', name: 'DJ Motor', address: '01 Pondok Aren, Jl. Musholla Nurul Huda No.11, Pd. Aren, Kota Tangerang Selatan, Banten 15224',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100173', name: 'Bursa Motor PD', address: 'Jl. RS Fatmawati No.37 D, RT.5/RW.3, Cilandak Bar., Cilandak, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12150',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100174', name: 'BOWO MOTOR', address: 'Gg. Pos & Giro, Pd. Jaya, Pd. Aren, Kota Tangerang Selatan, Banten 15220',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100175', name: 'Bintang Motor', address: 'Jl. H.Mencong, Paninggilan Utara, Ciledug, Kota Tangerang, Banten 15153',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100176', name: 'Bersama Motor', address: 'Jl. Taman Margasatwa Raya 20 Ragunan Pasar Minggu Jakarta Selatan DKI Jakarta, RT.12/RW.5, Jati Padang, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12550',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100177', name: 'Bengkel Tambal Ban', address: 'Jl. KH.Wahid Hasyim Pd. Raya, Jurang Manggu Tim., Pd. Aren, Kota Tangerang Selatan, Banten 15222',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100178', name: 'Bengkel T.Jo East Java Motor', address: 'Jl. H. Sarmah no 96 RT.005 RW.02 kel, Parigi, Pd. Aren, Kota Tangerang Selatan, Banten 15227',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100179', name: 'BENGKEL SILEANG 86 MOTOR', address: 'Jl. Aria Putra No.7, Serua Indah, Ciputat, Kota Tangerang Selatan, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100180', name: 'Bengkel Sarena Motor', address: 'Jl. Serua Raya No.13B, 2, Serua, Ciputat, Kota Tangerang Selatan, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100181', name: 'Bengkel Ponorogo Tiger', address: 'Jl. Kemajuan Blk. B No.49, RT.7/RW.4, Petukangan Sel., Pesanggrahan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12270',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100182', name: 'BENGKEL PAK ARA', address: 'Jalan Jurang Mangu depan cluster Pesona Jurang Mangu Pondok Aren, Jurang Manggu Tim., Pd. Aren, Kota Tangerang Selatan, Banten 15154',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100183', name: 'Bengkel Motor Utama', address: 'Jalan Bungur Raya Nomor 13 RT 09 RW 07 Kebayoran Lama, Jakarta Selatan, RT.8/RW.4, Kby. Lama Utara, Kby. Lama, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12240',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100184', name: 'Bengkel Motor Polmas 1', address: 'JL Kampung Gedong, RT 02 RW 02, Kampung Gedong Ciputat, Jombang, Tangerang, Kota Tangerang Selatan, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100185', name: 'Bengkel Motor Bahtiar', address: 'C, Jl. Mampang Prapatan XV No.21, RT.7/RW.6, Duren Tiga, Pancoran, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12760',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100186', name: 'BENGKEL MOTOR 2 PONDOK JAYA', address: 'Jl. Pd. Jaya No.8, Pd. Jaya, Pd. Aren, Kota Tangerang Selatan, Banten 15224',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100187', name: 'Bengkel Motor', address: 'Jl. Pancoran Barat VII No.2, RT.15/RW.1, Pancoran, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12760',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100188', name: 'Bengkel Mas Ari', address: 'Masjid Al barkah pondok aren, Jl. Al Barkah Blok Masjid No.24, Cireundeu, Ciputat Tim., Kota Tangerang Selatan, Banten 15419',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100189', name: 'Bengkel Lae Chelsi', address: 'Jalan Sumatra Nomor 2 Rawa Lele Dekat Bintaro Indah Ciputat, Jombang, Ciputat, Kota Tangerang Selatan, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100190', name: 'Bengkel Kita Motor', address: 'Jalan Panti Asuhan RT3 RW11, Jurang Mangu Barat, Pondok Aren, Jurang Manggu Tim., Pd. Aren, Kota Tangerang Selatan, Banten 15223',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100191', name: 'Bengkel Ico Oil II', address: 'Jl. Graha Raya Bintaro No.31, Parigi Baru, Pd. Aren, Kota Tangerang Selatan, Banten 15228',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100192', name: 'Bengkel Ibnu Motor', address: 'Jl. Sumatera, Jombang, Ciputat, Kota Tangerang Selatan, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100193', name: 'Bengkel Berkah Motor', address: 'Jl. Sumatra, Jombang Rawa Lele, Gang Sawo, Jombang, Ciputat, Kota Tangerang Selatan, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100194', name: 'Bengkel Bang Jemboy', address: 'RT.3/RW.3, Bintaro, Pesanggrahan, South Jakarta City, Jakarta 12330',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100195', name: 'Bengkel Aspira', address: 'Jalan Jati Padang, RT.8/RW.9, Jati Padang, Ps. Minggu, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12540',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100196', name: 'Barkara Jaya Motor', address: 'Jl. Duren Tiga Raya No.130, RT.2/RW.6, Pancoran, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12760',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100197', name: 'Asan Motor', address: 'Jl. Kemang Utara IX No.1, RT.3/RW.4, Bangka, Mampang Prpt., Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12730',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100198', name: 'Antique Motorcycle Repair Bimo', address: 'Bengkel Motor Antik ( Bimo ), Jl. Pangeran Antasari, RT.7/RW.2, Cipete Sel., Jakarta, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12410',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100199', name: 'Afung Motor (Bengkel Motor)', address: 'Jombang, Ciputat, South Tangerang City, Banten 15414',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100200', name: '306 Motor', address: 'Jl. Tegal Rotan Raya, Pd. Jaya, Pd. Aren, Kota Tangerang Selatan, Banten 15224',tel: '',region: region, province: province_12, regency: regency_168],
  [bengkel_id: '100201', name: 'Xtreme Motor Sport', address: 'Jl. Pangeran Tubagus Angke No.19, RT.7/RW.5, 5, Wijaya Kusuma, Jakarta, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11460',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100202', name: 'Motori', address: 'Mangga 16 blok CC no.37B, RT.9/RW.4, Duri Kepa, Kebon Jeruk, West Jakarta City, Jakarta 11510',tel: '‪+62 22 4207580',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100203', name: 'Layz Motor', address: 'ARTERI KELAPA DUA NO 90.D-E, Jl. Panjang Arteri Klp. Dua Raya Blok D No.17, RT.7/RW.4, Klp. Dua, Kb. Jeruk, DKI Jakarta, Daerah Khusus Ibukota Jakarta 11560',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100204', name: 'Call the bike shop', address: 'Jl. Salman No.170, RT.2/RW.3, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11530',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100205', name: 'Rezeki Motor Taman Cosmos', address: 'Jl. Taman Cosmos Blok C No.38, RT.6/RW.7, Kedoya Utara, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11520',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100206', name: 'NIN ROCKSTAR', address: 'Pos Pengumben No.14, Jl. Arteri, RT.2/RW.8, Sukabumi Sel., Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11560',tel: '0857-6671-1404',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100207', shop_group_id: 2, name: 'Bengkel Yo Matic', address: 'No., Jl. Meruya Selatan No.25, RT.1/RW.2, Meruya Sel., Kembangan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11640',tel: '(021) 91857827',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100208', name: 'Warno Jaya Motor', address: 'Jl. Alpukat 2 No.45, RT.1/RW.2, Tj. Duren Utara, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11470',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100209', name: 'Utama Motor', address: 'Jl. Raya Menceng No.7, RT.4/RW.7, Tegal Alur, Kalideres, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11820',tel: '0858-8882-0828',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100210', name: 'TMS Bengkel Mas Supri SCORPiOHOLiC', address: 'Jalan Budi Raya No.101, Kemanggisan, Palmerah, RT.1/RW.5, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11530',tel: '(021) 73450347',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100211', name: 'THO Motor', address: 'Jl. Indraloka II No.1857, Wijaya Kusuma, Grogol petamburan, Kota Jakarta, Barat,, RT.6/RW.6, Wijaya Kusuma, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11460',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100212', name: 'Teras Motor Sport', address: 'Jl. Panjang, RT.1/RW.2, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11530',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100213', name: 'Sukses Gemilang Motor', address: 'Jl. Kamal Raya No.38a, RT.6/RW.4, Cengkareng Bar., Cengkareng, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11730',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100214', name: 'Samroni Bengkel Motor', address: 'Jalan Bakti No.46, RT.10/RW.13, Kapuk, Cengkareng, RT.9/RW.13, Kapuk, Cengkareng, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11720',tel: '(021) 74861958',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100215', name: 'Rifath Motor', address: 'Jl. Rw. Gabus No.293, RT.10/RW.11, Kapuk, Cengkareng, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11720',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100216', name: 'MJ Steam Motor', address: 'Jl. Taman Kota Raya No.114, RT.1/RW.7, Kembangan Utara, Kembangan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11610',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100217', name: 'Mari Mampir Motor Jelambar', address: 'Jl. Indraloka II No.1771C, RT.7/RW.6, Wijaya Kusuma, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11460',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100218', name: 'Maju Jaya Motor', address: 'Jl. Jelambar Jaya 3 No.8, RT.9/RW.2, Jelambar Baru, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11460',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100219', name: 'Kismer Ringo Motor', address: 'Jl. Meruya Selatan No.36, RT.8/RW.1, Joglo, Kembangan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11640',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100220', name: 'Jenn Motor', address: 'Jl. Meruya Ilir Raya No.9A, RT.4/RW.7, Meruya Utara, Kembangan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11620',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100221', name: 'IB Standar Motor', address: 'Jalan Kresek Raya Nomor 41A Rt 08 Rw 03, Kelurahan Duri Kosambi Kecamatan Cengkareng, RT.4/RW.8, Duri Kosambi, Jakarta Barat, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11750',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100222', name: 'Dragon Motor Speed', address: 'Ruko Green Garden Blok Y 3 No. 9, RT.4/RW.3, Kedoya Utara, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11520',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100223', shop_group_id: 3, name: 'ARYA Mandiri Motor', address: 'Jl. Joglo Raya No.1, RT.7/RW.1, Joglo, Kembangan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11640',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100224', name: 'Bengkel Sentra Otopart', address: 'RT.2/RW.7, North Kedoya, Kebon Jeruk, West Jakarta City, Jakarta 11520',tel: '(0711) 720770',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100225', name: 'Bengkel Resmi Sepeda Motor KYMCO', address: 'JL. Utan Jati, No. 1A, Wadas, Kalideres, RT.8/RW.12, Pegadungan, Kalideres, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11840',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100226', name: 'Bengkel Motor PMS', address: 'RT.13/RW.14, Kapuk, Cengkareng, West Jakarta City, Jakarta 11720',tel: '(021) 55756006',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100227', name: 'Bengkel Motor GONGGO', address: 'Jl. Wana Mulya No.59-61, RT.3/RW.3, Meruya Sel., Kembangan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11610',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100228', name: 'Bengkel Manalu', address: 'Jl. Kostrad Pusri, RT.3/RW.5, Petukangan Utara, Pesanggrahan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12260',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100229', name: 'Bengkel Iwan', address: 'Jalan kh abdul wahab 1, RT/RW:03/06, Cengkareng Barat, RT.3/RW.6, Duri Kosambi, Cengkareng, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11720',tel: '(021) 70444364',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100230', name: 'Bengkel HMS Botak', address: 'Jl. Palem Raya No.78, RT.7, Petukangan Utara, Pesanggrahan, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12260',tel: '',region: region, province: province_11, regency: regency_159],
  [bengkel_id: '100231', name: 'Bengkel Bajaj Utama 1', address: 'Jl. Jelambar Utama I No.2, RT.6/RW.4, Jelambar Baru, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11460',tel: '(021) 87919000',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100232', name: 'Bengkel & Tambal Ban ,Marisi Jaya Motor', address: 'Jl. Anggrek Rosliana No.2, RT.3/RW.2, Kemanggisan, Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11480',tel: '(021) 8411355',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100233', name: 'BAS Motor KAISAR, JOGLO', address: 'Jl. Joglo Raya, RT.10/RW.3, Joglo, Kembangan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11640',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100234', name: 'Barokah Motor', address: 'Jl. Pedongkelan Baru No.28, RT.15/RW.16, Kapuk, Cengkareng, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11720',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100235', name: 'ANS MotoR', address: 'Jl. Delima 8 No.63, RT.1/RW.3, Kedoya Sel., Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11520',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100236', name: 'ADNAN MOTOR', address: 'Jl. Kali Sekretaris No.1, RT.8/RW.1, Kedoya Utara, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11520',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100237', name: 'Abadi Motor', address: 'Jl. Palmerah Utara No.6, RT.1/RW.6, Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11480',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100238', name: 'XOMOTOSHOP', address: 'Jalan Aries Elok III, Jl. Taman Aries No.12a, RT.7/RW.6, North Meruya, Kembangan, Jakarta, 11620',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100239', name: 'Warung 1526 Workshop', address: 'Jl. Palding Jaya No.113, RT.13/RW.3, Kembangan Utara, Kembangan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11610',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100240', shop_group_id: 4, name: 'Sumber Jaya Motor', address: 'No. 96 B, Jl. Palmerah Utara, RT.1/RW.7, Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11480',tel: '(021) 548 5766',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100241', name: 'SIMPATI MOTOR', address: 'Jl. Jelambar Utama I No.12C, RT.2/RW.4, Jelambar Baru, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11460',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100242', name: 'SIMPATI MOTOR', address: 'Jl. Jelambar Utama I No.12C, RT.2/RW.4, Jelambar Baru, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11460',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100243', name: 'Service Shockbreaker motors', address: 'Jl. Raya Duri Kosambi No.25, RT.13/RW.7, Duri Kosambi, Cengkareng, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11750',tel: '0813-8005-9006',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100244', shop_group_id: 5, name: 'Scooter Jam', address: 'Jalan Joglo Raya, Taman Kebon Jeruk Intercon Blok W3 No.21 Jakarta Barat, RT.12/RW.3, Joglo, Kembangan, West Jakarta City, Jakarta 11640',tel: '0811-9751-268',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100245', name: 'PUTERA MOTOR', address: 'Jl. Panjang No.24, RT.8/RW.1, Kedoya Sel., Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11520',tel: '(021) 6260030',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100246', name: 'PT. TECHNO MOTOR INDONESIA', address: 'The Capitol Building Kav. 73, Jalan Letjen. S. Parman, RT.4/RW.3, Slipi, Palmerah, RT.4/RW.3, Slipi, Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11410',tel: '0812-8335-6780',region: region, province: province_11, regency: regency_160, subscriber_type: 1, expiration_date: DateTime.now + 30],
  [bengkel_id: '100247', name: 'PT. EL RHINO GLOBAL', address: 'Jl. Kedoya Duri Raya No. 3, RT. 001 / RW. 001, RT.11/RW.5, North Kedoya, Jakarta Barat - Indonesia, West Jakarta City, Jakarta 11520',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100248', name: 'Probike Motor', address: 'Jl. Panjang Arteri Klp. Dua Raya No.88C, RT.7/RW.4, Klp. Dua, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11550',tel: '0815-1141-6848',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100249', name: 'Pro Bike Motor', address: 'JL Panjang, No. 88-A, Duri Kepa, Kebon Jeruk, RT.5/RW.11, Kedoya Utara, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11510',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100250', name: 'Pratama Motor (Jamaludin)', address: 'Jl. Pilar Baru No.11, RT.5/RW.3, 3, Kedoya Sel., Jakarta, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11520',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100251', name: 'Polaris Motor', address: 'Jalan Srengseng Raya Rt 04 Rw 06 Nomor 131, Srengseng, Kembangan, RT.4/RW.6, Srengseng, Kembangan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11630',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100252', name: 'Panprisa Jaya Motor', address: 'Jl. Panjang, RT.11/RW.1, Kedoya Sel., Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11520',tel: '(0411) 873881',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100253', name: 'Nusantara Sakti', address: 'Jl. Meruya Ilir Raya No.50, RT.11/RW.6, Meruya Utara, Kembangan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11620',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100254', name: 'Motolab', address: 'Arteri No 88i Kebon Jeruk, Jl. Panjang Arteri Klp. Dua Raya, RT.7/RW.4, Klp. Dua, Jakarta Barat, DKI Jakarta, Daerah Khusus Ibukota Jakarta 11550',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100255', name: 'Megah Matahari', address: 'Jl. Tanjung Duren Raya No.99, RT.6/RW.5, Tj. Duren Sel., Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11470',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100256', name: 'Mari Mampir Motor Pesing', address: 'Jl. Daan Mogot No.48, RT.1/RW.3, Wijaya Kusuma, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11460',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100257', name: 'Lestari Motor', address: 'no 14 Flamboyan Patokan Sebelum SMP 108, Jalan Kamal Raya, RT.5/RW.8, Cengkareng Barat, Cengkareng, RT.5/RW.8, Cengkareng Bar., Cengkareng, DKI Jakarta, Daerah Khusus Ibukota Jakarta 11730',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100258', name: 'Lestari Motor', address: 'no 14 Flamboyan Patokan Sebelum SMP 108, Jalan Kamal Raya, RT.5/RW.8, Cengkareng Barat, Cengkareng, RT.5/RW.8, Cengkareng Bar., Cengkareng, DKI Jakarta, Daerah Khusus Ibukota Jakarta 11730',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100259', name: 'Karunia Motor. CV', address: 'JL. Tali, No. 37 A RT. 005 RW. 08, RT.1/RW.4, Kedoya Utara, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11420',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100260', name: 'Juan ringo motor', address: 'no, Jl. Kemanggisan Utama VII No.22, RT.4/RW.7, Kemanggisan, Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11480',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100261', name: 'Jual Beli Motor Pak Aris', address: 'Jl. Klp. Dua Raya No.5B, RT.3/RW.8, Klp. Dua, Kebonjeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11550',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100262', name: 'JATAYU Motor Sport', address: 'jl.Tubagus Angke Komplek Taman Harapan blok Q no. 29, Indah, RT.11/RW.7, Jelambar Baru, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11460',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100263', name: 'GoMotoRide', address: 'Jl. Panjang No.88A, Kebon Jeruk, RT.7/RW.4, Klp. Dua, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11550',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100264', name: 'Gama Motor', address: 'Jl. Raya Pos Pengumben No.9, RT.2/RW.6, Klp. Dua, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11550',tel: '0812-8245-2759',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100265', name: 'Domu Motor Service', address: 'Jl. H. Kelik No.12, RT.5/RW.6, Srengseng, Kembangan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11630',tel: '(021) 5383655',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100266', name: 'DMX (Didi Motor X)', address: 'No., Jl. Patra No.15, RT.6/RW.2, Duri Kepa, Jakarta Barat, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11510',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100267', name: 'Dinamika Motor', address: 'Jl. Meruya Ilir Raya No.37, RT.8/RW.2, Meruya Utara, Kembangan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11620',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100268', name: 'DIDI Black Motor', address: 'Jl. Kedoya Duri No.5, RT.6/RW.1, Kedoya Sel., Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11520',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100269', name: 'Citra Jaya Motor', address: 'Jl. Pangeran Tubagus Angke, RT.14/RW.11, Jelambar Baru, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11460',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100270', name: 'Cengkareng Motor Dealer', address: 'Jl. Kembangan Raya No.57, RT.9/RW.3, Kembangan Utara, Kembangan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11610',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100271', name: 'Cahaya Motor', address: 'Jalan Pondok Aren Nomor 9 Rt 02 Rw 01, Pondok Aren, Pd. Aren, Kota Tangerang Selatan, Banten 15224',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100272', name: 'Bengkel Saudara Motor', address: 'Jl. Makaliwe Raya No.26B, RT.9/RW.6, Grogol, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11450',tel: '0853-7293-2091',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100273', name: 'Bengkel Putri Jaya Motor', address: 'Jl. Gili Sampeng No.11, RT1/RW5, RT.11/RW.5, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11530',tel: '(021) 4215888',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100274', name: 'Bengkel Motor Bajaj Pulsar', address: 'Jl. Cemara No No.2C, RT.9/RW.2, Cengkareng Barat, Cengkareng, RT.9/RW.5, Cengkareng Bar., Cengkareng, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11730',tel: '(021) 5480355',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100275', name: 'Bengkel Motor', address: 'Jl. Pancoran Barat VII No.2, RT.15/RW.1, Pancoran, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12760',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100276', name: 'Bengkel IRM 88', address: 'Jl. Pakembangan 1/ Inspeksi Slipi No.44 12, RT.12/RW.3, Kemanggisan, Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11480',tel: '(021) 22731635',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100277', name: 'bengkel gemilang motor service & parts', address: 'Jl. Palmerah Utara No.39, RT.1/RW.1, Gelora, Tanah Abang, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10270',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100278', name: 'Bengkel Eka Jaya Motor (Service+Tune Up)', address: 'Jl. Al Amanah No.1, RT.1/RW.10, Wijaya Kusuma, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11460',tel: '0812-1015-018',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100279', name: 'Bengkel Dan Cuci Steam Air Pam Bika Ambon', address: 'Jalan Kav Polri Blok D5 No 992, Jelambar, Grogol Petamburan, RT.9/RW.1, Jelambar, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11640',tel: '(021) 5514321',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100280', name: 'Bengkel Cahaya Motor', address: 'Jl. Pedongkelan Dalam No.97, RT.6/RW.13, Kapuk, Cengkareng, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11720',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100281', name: 'Bengkel Asih Motor', address: 'Jl. Fajar Baru Selatan No.12A, RT.13/RW.7, Cengkareng Tim., Cengkareng, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11730',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100282', name: 'Baru Motor Sport', address: 'Jl. Palmerah Barat No.25, RT.1/RW.2, Gelora, Tanah Abang, Kota Jakarta Pusat, Daerah Khusus Ibukota Jakarta 10270',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100283', name: 'Baraya Motor', address: 'Jl. Srengseng Raya No.244, RT.2/RW.6, Srengseng, Kembangan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11630',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100284', name: 'Arena Bengkel', address: 'Jl. Panjang 4 Kebon Jeruk Kebon Jeruk Jakarta Barat DKI Jakarta, RT.11/RW.10, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11530',tel: '(0411) 871075',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100285', name: 'Aphin Motor', address: 'Jalan Pangeran Tubagus Angke Raya No.GI-7B, RT.7/RW.5, Wijaya Kusuma, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11460',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100286', name: 'Agung Motor', address: 'Jl. Palmerah Barat No. 53 RT 003 RW 07 Kemanggisan Palmerah Jakarta Barat DKI Jakarta, RT.3/RW.7, Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11480',tel: '(021) 6620144',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100287', name: 'Vin Bengkel Motor', address: 'Jalan Panjang Cidodol, RT.1/RW.13, Grogol Selatan, Kebayoran Lama, RT.1/RW.13, Grogol Sel., Kby. Lama, Kota Jakarta Selatan, Daerah Khusus Ibukota Jakarta 12220',tel: '0859-2009-8293',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100288', name: 'Saudara Motor', address: 'Jl. Panjang No.26, RT.1/RW.4, Kedoya Utara, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11520',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100289', name: 'Saerah', address: 'Jl. Panjang Blok X No.12, RT.2, Kedoya Utara, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11520',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100290', name: 'Roofi Motor', address: 'Taman kota, Rt 016/ 05, No. 57 Kecamatan Cengkareng, RT.16/RW.5, Kembangan Utara, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11610',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100291', name: 'Refi Motor', address: 'Jl. Panjang, RT.15/RW.7, Kedoya Utara, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11520',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100292', name: 'Ramayana Motor', address: 'Jalan Puri Kembangan Raya Rt 011/05 #90A, Kembangan, RT.4/RW.6, Kembangan Sel., Kembangan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11610',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100293', name: 'Lancar Motor Jelambar', address: 'Jl. Hadiah 2 No.34, RT.13/RW.3, Jelambar, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11460',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100294', name: 'Kondang Motor', address: 'Jl. Taman Kota No.1, RT.1/RW.8, Kedaung Kali Angke, Cengkareng, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11610',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100295', name: 'Kjv Motor Sport 1', address: '7, RT.6/RW.7, Kedoya Utara, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11520',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100296', name: 'Kings Motor Sport', address: 'no. grogol petamburan, Jalan Anyar No.8, RT.2/RW.6, Jelambar, Jakarta barat, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11460',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100297', name: 'Hikaru Motor', address: 'Motor Blok BB No.7 ,Pesing,Kebon Jeruk, Jl. Kedoya Raya, RT.10/RW.6, Kedoya Utara, Jakarta Barat, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11520',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100298', name: 'Harapan Motor', address: 'RT.10/RW.10, West Cengkareng, Cengkareng, West Jakarta City, Jakarta 11730',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100299', name: 'Eka Jaya Motor', address: 'Jalan anyar raya I no.1 grogol petamburan, RT.7/RW.1, Jelambar, Jakarta, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11460',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100300', name: 'Dedy Motor', address: 'Jl. Kedoya Raya No.3a, RT.2/RW.2, Kedoya Sel., Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11520',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100301', name: 'Bhakti Motor', address: 'Jl. Kemanggisan Raya No.35, RT.1/RW.7, Kemanggisan, Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11480',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100302', name: 'Bengkel Motor Lukman Borneo', address: 'Jl. Fajar Baru Selatan No.3, RT.9/RW.6, Cengkareng Tim., Cengkareng, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11730',tel: '0878-0876-3521',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100303', name: 'Bengkel Motor Djokam 354', address: 'Jl. Raya Kb. Jeruk No.42, RT.1/RW.11, Kb. Jeruk, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11530',tel: '(021) 4220129',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100304', name: 'Bengkel Jaya Abadi', address: 'Jl. Raya Pondok Randu, RT.3/RW.2, Duri Kosambi, Cengkareng, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11750',tel: '(061) 7342570',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100305', name: 'Bengkel Bubut Ahong Lijaya', address: 'JL. Jelambar, RT.14/RW.9, Jelambar Baru, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11460',tel: '(061) 8455050',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100306', name: 'Bengkel Bobby', address: 'JL Daan Mogot Raya, No. 351, Jelambar, Grogol Petamburan, RT.4/RW.2, Wijaya Kusuma, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11470',tel: '0813-8188-5965',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100307', name: 'Bengkel Ajon', address: 'Jl. Tanjung Duren Utara IIIE No.234, RT.8/RW.3, Tj. Duren Utara, Grogol petamburan, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11470',tel: '(021) 99222050',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100308', name: 'Ari motor', address: 'no., Jl. Inspeksi Kali Grogol No.12, RT.2/RW.4, Slipi, Jakarta barat, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11480',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100309', name: 'Adinda Motor', address: 'No.11-14, Jl. Kemanggisan Pulo, RT.1/RW.17, Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11480',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100310', name: 'Adang motor', address: 'Jl. H. Saili No.17, RT.5/RW.5, Kemanggisan, Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11480',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100311', name: 'Abil jaya motor', address: 'Jl.budi no., Jl. Swadaya No.12, RT.13/RW.3, Palmerah, Kota Jakarta Barat, Daerah Khusus Ibukota Jakarta 11480',tel: '',region: region, province: province_11, regency: regency_160],
  [bengkel_id: '100312', shop_group_id: 5, name: 'Scooter Jam (Tangerang)', address: 'Jl. KH Hasyim Ashari, Buaran Indah, Kec. Tangerang, Kota Tangerang, Banten 15119',tel: '',region: region, province: province_12, regency: regency_167, subscriber_type: 1, expiration_date: DateTime.now + 30],
]

Shop.create(shop_list)

Shop.find_by(bengkel_id: 100001).update(latitude: -6.2786658,longitude:106.7096831)
Shop.find_by(bengkel_id: 100002).update(latitude: -6.2398485,longitude:106.752358)
Shop.find_by(bengkel_id: 100003).update(latitude: -6.3008603,longitude:106.6837957)
Shop.find_by(bengkel_id: 100004).update(latitude: -6.2867856,longitude:106.7506957)
Shop.find_by(bengkel_id: 100005).update(latitude: -6.2520414,longitude:106.6876913)
Shop.find_by(bengkel_id: 100006).update(latitude: -6.243067,longitude:106.816586)
Shop.find_by(bengkel_id: 100007).update(latitude: -6.273315,longitude:106.745139)
Shop.find_by(bengkel_id: 100008).update(latitude: -6.235117,longitude:106.739816)
Shop.find_by(bengkel_id: 100009).update(latitude: -6.231111,longitude:106.72682)
Shop.find_by(bengkel_id: 100010).update(latitude: -6.2725189,longitude:106.7671702)
Shop.find_by(bengkel_id: 100011).update(latitude: -6.2459494,longitude:106.699729)
Shop.find_by(bengkel_id: 100012).update(latitude: -6.266888,longitude:106.824065)
Shop.find_by(bengkel_id: 100013).update(latitude: -6.2674658,longitude:106.7433843)
Shop.find_by(bengkel_id: 100014).update(latitude: -6.2664684,longitude:106.7972191)
Shop.find_by(bengkel_id: 100015).update(latitude: -6.2561705,longitude:106.805331)
Shop.find_by(bengkel_id: 100016).update(latitude: -6.2996033,longitude:106.7501589)
Shop.find_by(bengkel_id: 100017).update(latitude: -6.2544378,longitude:106.727219)
Shop.find_by(bengkel_id: 100018).update(latitude: -6.2427094,longitude:106.8445892)
Shop.find_by(bengkel_id: 100019).update(latitude: -6.2883354,longitude:106.8309518)
Shop.find_by(bengkel_id: 100020).update(latitude: -6.2857715,longitude:106.762833)
Shop.find_by(bengkel_id: 100021).update(latitude: -6.259364,longitude:106.827263)
Shop.find_by(bengkel_id: 100022).update(latitude: -6.3130785,longitude:106.7308856)
Shop.find_by(bengkel_id: 100023).update(latitude: -6.2970752,longitude:106.73763)
Shop.find_by(bengkel_id: 100024).update(latitude: -6.3145479,longitude:106.7230007)
Shop.find_by(bengkel_id: 100025).update(latitude: -6.2411646,longitude:106.8177893)
Shop.find_by(bengkel_id: 100026).update(latitude: -6.2760742,longitude:106.8158855)
Shop.find_by(bengkel_id: 100027).update(latitude: -6.245935,longitude:106.816173)
Shop.find_by(bengkel_id: 100028).update(latitude: -6.247354,longitude:106.815101)
Shop.find_by(bengkel_id: 100029).update(latitude: -6.277918,longitude:106.718205)
Shop.find_by(bengkel_id: 100030).update(latitude: -6.304014,longitude:106.7181389)
Shop.find_by(bengkel_id: 100031).update(latitude: -6.2904583,longitude:106.71515)
Shop.find_by(bengkel_id: 100032).update(latitude: -6.283475,longitude:106.725622)
Shop.find_by(bengkel_id: 100033).update(latitude: -6.2830567,longitude:106.7496496)
Shop.find_by(bengkel_id: 100034).update(latitude: -6.2946711,longitude:106.7472423)
Shop.find_by(bengkel_id: 100035).update(latitude: -6.287379,longitude:106.708325)
Shop.find_by(bengkel_id: 100036).update(latitude: -6.2468942,longitude:106.8428969)
Shop.find_by(bengkel_id: 100037).update(latitude: -6.2988968,longitude:106.7230193)
Shop.find_by(bengkel_id: 100038).update(latitude: -6.26765,longitude:106.814467)
Shop.find_by(bengkel_id: 100039).update(latitude: -6.2814361,longitude:106.711345)
Shop.find_by(bengkel_id: 100040).update(latitude: -6.282738,longitude:106.7116921)
Shop.find_by(bengkel_id: 100041).update(latitude: -6.276264,longitude:106.698791)
Shop.find_by(bengkel_id: 100042).update(latitude: -6.3126563,longitude:106.7279375)
Shop.find_by(bengkel_id: 100043).update(latitude: -6.2966083,longitude:106.7949153)
Shop.find_by(bengkel_id: 100044).update(latitude: -6.2428655,longitude:106.7561669)
Shop.find_by(bengkel_id: 100045).update(latitude: -6.255643,longitude:106.777561)
Shop.find_by(bengkel_id: 100046).update(latitude: -6.294387,longitude:106.700913)
Shop.find_by(bengkel_id: 100047).update(latitude: -6.2465883,longitude:106.825925)
Shop.find_by(bengkel_id: 100048).update(latitude: -6.2690209,longitude:106.845999)
Shop.find_by(bengkel_id: 100049).update(latitude: -6.3190791,longitude:106.6974502)
Shop.find_by(bengkel_id: 100050).update(latitude: -6.2621265,longitude:106.7371559)
Shop.find_by(bengkel_id: 100051).update(latitude: -6.2834628,longitude:106.8071096)
Shop.find_by(bengkel_id: 100052).update(latitude: -6.2635775,longitude:106.7946497)
Shop.find_by(bengkel_id: 100053).update(latitude: -6.243079,longitude:106.714114)
Shop.find_by(bengkel_id: 100054).update(latitude: -6.285852,longitude:106.702483)
Shop.find_by(bengkel_id: 100055).update(latitude: -6.3051682,longitude:106.7049456)
Shop.find_by(bengkel_id: 100056).update(latitude: -6.2725099,longitude:106.8040626)
Shop.find_by(bengkel_id: 100057).update(latitude: -6.2593066,longitude:106.7421341)
Shop.find_by(bengkel_id: 100058).update(latitude: -6.2889445,longitude:106.7580436)
Shop.find_by(bengkel_id: 100059).update(latitude: -6.2901922,longitude:106.7891663)
Shop.find_by(bengkel_id: 100060).update(latitude: -6.3030607,longitude:106.7217173)
Shop.find_by(bengkel_id: 100061).update(latitude: -6.2902745,longitude:106.7708143)
Shop.find_by(bengkel_id: 100062).update(latitude: -6.2638732,longitude:106.8317283)
Shop.find_by(bengkel_id: 100063).update(latitude: -6.3007823,longitude:106.6922409)
Shop.find_by(bengkel_id: 100064).update(latitude: -6.29923,longitude:106.6886555)
Shop.find_by(bengkel_id: 100065).update(latitude: -6.2918511,longitude:106.6944293)
Shop.find_by(bengkel_id: 100066).update(latitude: -6.2603058,longitude:106.6920308)
Shop.find_by(bengkel_id: 100067).update(latitude: -6.3069457,longitude:106.7185946)
Shop.find_by(bengkel_id: 100068).update(latitude: -6.2898373,longitude:106.7394961)
Shop.find_by(bengkel_id: 100069).update(latitude: -6.2529899,longitude:106.837783)
Shop.find_by(bengkel_id: 100070).update(latitude: -6.2529899,longitude:106.837783)
Shop.find_by(bengkel_id: 100071).update(latitude: -6.241183,longitude:106.777386)
Shop.find_by(bengkel_id: 100072).update(latitude: -6.229249,longitude:106.7078152)
Shop.find_by(bengkel_id: 100073).update(latitude: -6.3097284,longitude:106.7205024)
Shop.find_by(bengkel_id: 100074).update(latitude: -6.2695388,longitude:106.7425327)
Shop.find_by(bengkel_id: 100075).update(latitude: -6.2921414,longitude:106.7233244)
Shop.find_by(bengkel_id: 100076).update(latitude: -6.3031257,longitude:106.7155148)
Shop.find_by(bengkel_id: 100077).update(latitude: -6.2930615,longitude:106.6962713)
Shop.find_by(bengkel_id: 100078).update(latitude: -6.3018424,longitude:106.7405885)
Shop.find_by(bengkel_id: 100079).update(latitude: -6.2492056,longitude:106.8145488)
Shop.find_by(bengkel_id: 100080).update(latitude: -6.261165,longitude:106.747173)
Shop.find_by(bengkel_id: 100081).update(latitude: -6.291136,longitude:106.78821)
Shop.find_by(bengkel_id: 100082).update(latitude: -6.2693522,longitude:106.7425931)
Shop.find_by(bengkel_id: 100083).update(latitude: -6.3038349,longitude:106.7242974)
Shop.find_by(bengkel_id: 100084).update(latitude: -6.263428,longitude:106.726954)
Shop.find_by(bengkel_id: 100085).update(latitude: -6.28639,longitude:106.8069651)
Shop.find_by(bengkel_id: 100086).update(latitude: -6.2992487,longitude:106.7574897)
Shop.find_by(bengkel_id: 100087).update(latitude: -6.2618175,longitude:106.6861279)
Shop.find_by(bengkel_id: 100088).update(latitude: -6.2794555,longitude:106.7211794)
Shop.find_by(bengkel_id: 100090).update(latitude: -6.3118798,longitude:106.7529454)
Shop.find_by(bengkel_id: 100091).update(latitude: -6.27692,longitude:106.704438)
Shop.find_by(bengkel_id: 100092).update(latitude: -6.2518861,longitude:106.7833546)
Shop.find_by(bengkel_id: 100093).update(latitude: -6.2741622,longitude:106.7286044)
Shop.find_by(bengkel_id: 100094).update(latitude: -6.2904583,longitude:106.71515)
Shop.find_by(bengkel_id: 100095).update(latitude: -6.304992,longitude:106.681594)
Shop.find_by(bengkel_id: 100096).update(latitude: -6.2641028,longitude:106.8237154)
Shop.find_by(bengkel_id: 100097).update(latitude: -6.2578923,longitude:106.8331175)
Shop.find_by(bengkel_id: 100098).update(latitude: -6.2873774,longitude:106.8257922)
Shop.find_by(bengkel_id: 100099).update(latitude: -6.2386,longitude:106.818859)
Shop.find_by(bengkel_id: 100100).update(latitude: -6.2891637,longitude:106.6961382)
Shop.find_by(bengkel_id: 100101).update(latitude: -6.2793231,longitude:106.7204628)
Shop.find_by(bengkel_id: 100102).update(latitude: -6.3045598,longitude:106.7272822)
Shop.find_by(bengkel_id: 100103).update(latitude: -6.3149579,longitude:106.7540266)
Shop.find_by(bengkel_id: 100104).update(latitude: -6.286426,longitude:106.702882)
Shop.find_by(bengkel_id: 100105).update(latitude: -6.264443,longitude:106.808242)
Shop.find_by(bengkel_id: 100106).update(latitude: -6.3021333,longitude:106.7514048)
Shop.find_by(bengkel_id: 100107).update(latitude: -6.248569,longitude:106.7810359)
Shop.find_by(bengkel_id: 100108).update(latitude: -6.2861831,longitude:106.7958147)
Shop.find_by(bengkel_id: 100109).update(latitude: -6.2456121,longitude:106.7815106)
Shop.find_by(bengkel_id: 100110).update(latitude: -6.2546337,longitude:106.7889856)
Shop.find_by(bengkel_id: 100111).update(latitude: -6.256487,longitude:106.795038)
Shop.find_by(bengkel_id: 100112).update(latitude: -6.230476,longitude:106.7258293)
Shop.find_by(bengkel_id: 100113).update(latitude: -6.2675856,longitude:106.7235437)
Shop.find_by(bengkel_id: 100114).update(latitude: -6.2635916,longitude:106.7947201)
Shop.find_by(bengkel_id: 100115).update(latitude: -6.291688,longitude:106.814675)
Shop.find_by(bengkel_id: 100116).update(latitude: -6.27118,longitude:106.79732)
Shop.find_by(bengkel_id: 100117).update(latitude: -6.247454,longitude:106.7816)
Shop.find_by(bengkel_id: 100118).update(latitude: -6.2789936,longitude:106.8452489)
Shop.find_by(bengkel_id: 100119).update(latitude: -6.299232,longitude:106.7145207)
Shop.find_by(bengkel_id: 100120).update(latitude: -6.2896817,longitude:106.842544)
Shop.find_by(bengkel_id: 100121).update(latitude: -6.2778264,longitude:106.802856)
Shop.find_by(bengkel_id: 100122).update(latitude: -6.2803654,longitude:106.8451599)
Shop.find_by(bengkel_id: 100123).update(latitude: -6.266191,longitude:106.804952)
Shop.find_by(bengkel_id: 100124).update(latitude: -6.2634137,longitude:106.8081844)
Shop.find_by(bengkel_id: 100125).update(latitude: -6.2398404,longitude:106.8188427)
Shop.find_by(bengkel_id: 100126).update(latitude: -6.2638,longitude:106.717655)
Shop.find_by(bengkel_id: 100127).update(latitude: -6.2853653,longitude:106.7156419)
Shop.find_by(bengkel_id: 100128).update(latitude: -6.2785314,longitude:106.7919675)
Shop.find_by(bengkel_id: 100130).update(latitude: -6.295454,longitude:106.757771)
Shop.find_by(bengkel_id: 100131).update(latitude: -6.285745,longitude:106.7383374)
Shop.find_by(bengkel_id: 100132).update(latitude: -6.257091,longitude:106.7852315)
Shop.find_by(bengkel_id: 100133).update(latitude: -6.2528309,longitude:106.781978)
Shop.find_by(bengkel_id: 100134).update(latitude: -6.2650332,longitude:106.8303177)
Shop.find_by(bengkel_id: 100135).update(latitude: -6.232366,longitude:106.744537)
Shop.find_by(bengkel_id: 100136).update(latitude: -6.2501394,longitude:106.8429322)
Shop.find_by(bengkel_id: 100137).update(latitude: -6.2652679,longitude:106.7569489)
Shop.find_by(bengkel_id: 100138).update(latitude: -6.2433987,longitude:106.7041963)
Shop.find_by(bengkel_id: 100139).update(latitude: -6.3040992,longitude:106.7552162)
Shop.find_by(bengkel_id: 100140).update(latitude: -6.311263,longitude:106.7386126)
Shop.find_by(bengkel_id: 100141).update(latitude: -6.3031314,longitude:106.7266822)
Shop.find_by(bengkel_id: 100142).update(latitude: -6.3041812,longitude:106.8446136)
Shop.find_by(bengkel_id: 100143).update(latitude: -6.263172,longitude:106.7262761)
Shop.find_by(bengkel_id: 100144).update(latitude: -6.2762141,longitude:106.7055028)
Shop.find_by(bengkel_id: 100145).update(latitude: -6.2941503,longitude:106.7079023)
Shop.find_by(bengkel_id: 100146).update(latitude: -6.256819,longitude:106.704031)
Shop.find_by(bengkel_id: 100147).update(latitude: -6.2532316,longitude:106.7061)
Shop.find_by(bengkel_id: 100149).update(latitude: -6.2655421,longitude:106.7973371)
Shop.find_by(bengkel_id: 100150).update(latitude: -6.2770143,longitude:106.7051193)
Shop.find_by(bengkel_id: 100151).update(latitude: -6.2786306,longitude:106.6964865)
Shop.find_by(bengkel_id: 100153).update(latitude: -6.26685,longitude:106.803063)
Shop.find_by(bengkel_id: 100154).update(latitude: -6.2553706,longitude:106.6857363)
Shop.find_by(bengkel_id: 100155).update(latitude: -6.2649392,longitude:106.8085832)
Shop.find_by(bengkel_id: 100156).update(latitude: -6.2609651,longitude:106.7392085)
Shop.find_by(bengkel_id: 100157).update(latitude: -6.262574,longitude:106.71999)
Shop.find_by(bengkel_id: 100158).update(latitude: -6.267434,longitude:106.8141365)
Shop.find_by(bengkel_id: 100159).update(latitude: -6.312209,longitude:106.690765)
Shop.find_by(bengkel_id: 100160).update(latitude: -6.2925716,longitude:106.8092104)
Shop.find_by(bengkel_id: 100161).update(latitude: -6.262573,longitude:106.744635)
Shop.find_by(bengkel_id: 100162).update(latitude: -6.262865,longitude:106.728657)
Shop.find_by(bengkel_id: 100163).update(latitude: -6.288164,longitude:106.759851)
Shop.find_by(bengkel_id: 100164).update(latitude: -6.2751861,longitude:106.7026889)
Shop.find_by(bengkel_id: 100165).update(latitude: -6.2669032,longitude:106.8112003)
Shop.find_by(bengkel_id: 100166).update(latitude: -6.260687,longitude:106.792068)
Shop.find_by(bengkel_id: 100167).update(latitude: -6.28497,longitude:106.725801)
Shop.find_by(bengkel_id: 100168).update(latitude: -6.281457,longitude:106.724971)
Shop.find_by(bengkel_id: 100169).update(latitude: -6.2588058,longitude:106.835951)
Shop.find_by(bengkel_id: 100170).update(latitude: -6.265898,longitude:106.79969)
Shop.find_by(bengkel_id: 100171).update(latitude: -6.2592996,longitude:106.8292834)
Shop.find_by(bengkel_id: 100172).update(latitude: -6.263664,longitude:106.71809)
Shop.find_by(bengkel_id: 100173).update(latitude: -6.2844635,longitude:106.796614)
Shop.find_by(bengkel_id: 100174).update(latitude: -6.2701777,longitude:106.7177102)
Shop.find_by(bengkel_id: 100176).update(latitude: -6.2916199,longitude:106.8242876)
Shop.find_by(bengkel_id: 100177).update(latitude: -6.2596821,longitude:106.7365619)
Shop.find_by(bengkel_id: 100178).update(latitude: -6.2638455,longitude:106.6993529)
Shop.find_by(bengkel_id: 100179).update(latitude: -6.308778,longitude:106.719097)
Shop.find_by(bengkel_id: 100180).update(latitude: -6.3164968,longitude:106.7162356)
Shop.find_by(bengkel_id: 100181).update(latitude: -6.240015,longitude:106.752937)
Shop.find_by(bengkel_id: 100182).update(latitude: -6.251501,longitude:106.728588)
Shop.find_by(bengkel_id: 100183).update(latitude: -6.247103,longitude:106.779711)
Shop.find_by(bengkel_id: 100184).update(latitude: -6.297407,longitude:106.7091)
Shop.find_by(bengkel_id: 100185).update(latitude: -6.2519701,longitude:106.8360892)
Shop.find_by(bengkel_id: 100186).update(latitude: -6.269085,longitude:106.7173584)
Shop.find_by(bengkel_id: 100187).update(latitude: -6.2529899,longitude:106.837783)
Shop.find_by(bengkel_id: 100188).update(latitude: -6.2598132,longitude:106.7042868)
Shop.find_by(bengkel_id: 100189).update(latitude: -6.296243,longitude:106.703803)
Shop.find_by(bengkel_id: 100190).update(latitude: -6.256235,longitude:106.729847)
Shop.find_by(bengkel_id: 100191).update(latitude: -6.2652382,longitude:106.6876591)
Shop.find_by(bengkel_id: 100192).update(latitude: -6.2959711,longitude:106.7088568)
Shop.find_by(bengkel_id: 100193).update(latitude: -6.2928283,longitude:106.6963187)
Shop.find_by(bengkel_id: 100194).update(latitude: -6.2741529,longitude:106.7673049)
Shop.find_by(bengkel_id: 100195).update(latitude: -6.2895,longitude:106.8290745)
Shop.find_by(bengkel_id: 100196).update(latitude: -6.2534028,longitude:106.8385494)
Shop.find_by(bengkel_id: 100197).update(latitude: -6.2578445,longitude:106.8244809)
Shop.find_by(bengkel_id: 100198).update(latitude: -6.2676508,longitude:106.8084527)
Shop.find_by(bengkel_id: 100199).update(latitude: -6.2926093,longitude:106.7065187)
Shop.find_by(bengkel_id: 100200).update(latitude: -6.2874274,longitude:106.7274392)
Shop.find_by(bengkel_id: 100201).update(latitude: -6.147571,longitude:106.774655)
Shop.find_by(bengkel_id: 100202).update(latitude: -6.175383,longitude:106.7717376)
Shop.find_by(bengkel_id: 100203).update(latitude: -6.210869,longitude:106.771131)
Shop.find_by(bengkel_id: 100204).update(latitude: -6.1963116,longitude:106.776975)
Shop.find_by(bengkel_id: 100205).update(latitude: -6.1667569,longitude:106.765913)
Shop.find_by(bengkel_id: 100206).update(latitude: -6.2171127,longitude:106.7755172)
Shop.find_by(bengkel_id: 100207).update(latitude: -6.213079,longitude:106.737769)
Shop.find_by(bengkel_id: 100208).update(latitude: -6.1702253,longitude:106.7863638)
Shop.find_by(bengkel_id: 100209).update(latitude: -6.122854,longitude:106.7175114)
Shop.find_by(bengkel_id: 100210).update(latitude: -6.189841,longitude:106.7826103)
Shop.find_by(bengkel_id: 100211).update(latitude: -6.1555725,longitude:106.7777192)
Shop.find_by(bengkel_id: 100212).update(latitude: -6.1986113,longitude:106.7691064)
Shop.find_by(bengkel_id: 100213).update(latitude: -6.1301491,longitude:106.727282)
Shop.find_by(bengkel_id: 100214).update(latitude: -6.143458,longitude:106.7412576)
Shop.find_by(bengkel_id: 100215).update(latitude: -6.1314285,longitude:106.7418139)
Shop.find_by(bengkel_id: 100216).update(latitude: -6.160159,longitude:106.753715)
Shop.find_by(bengkel_id: 100217).update(latitude: -6.155845,longitude:106.777937)
Shop.find_by(bengkel_id: 100218).update(latitude: -6.1544497,longitude:106.7883737)
Shop.find_by(bengkel_id: 100219).update(latitude: -6.217626,longitude:106.73727)
Shop.find_by(bengkel_id: 100220).update(latitude: -6.198019,longitude:106.7425723)
Shop.find_by(bengkel_id: 100221).update(latitude: -6.178836,longitude:106.71768)
Shop.find_by(bengkel_id: 100222).update(latitude: -6.1613724,longitude:106.7626448)
Shop.find_by(bengkel_id: 100223).update(latitude: -6.2197167,longitude:106.742801)
Shop.find_by(bengkel_id: 100224).update(latitude: -6.1660923,longitude:106.7633287)
Shop.find_by(bengkel_id: 100225).update(latitude: -6.144479,longitude:106.7028723)
Shop.find_by(bengkel_id: 100226).update(latitude: -6.1451294,longitude:106.7498796)
Shop.find_by(bengkel_id: 100227).update(latitude: -6.2109952,longitude:106.7219528)
Shop.find_by(bengkel_id: 100228).update(latitude: -6.2326873,longitude:106.7572667)
Shop.find_by(bengkel_id: 100229).update(latitude: -6.155227,longitude:106.72645)
Shop.find_by(bengkel_id: 100230).update(latitude: -6.227745,longitude:106.7573711)
Shop.find_by(bengkel_id: 100231).update(latitude: -6.151847,longitude:106.783902)
Shop.find_by(bengkel_id: 100232).update(latitude: -6.1912206,longitude:106.7955335)
Shop.find_by(bengkel_id: 100233).update(latitude: -6.2175423,longitude:106.7496108)
Shop.find_by(bengkel_id: 100234).update(latitude: -6.1425056,longitude:106.7463364)
Shop.find_by(bengkel_id: 100235).update(latitude: -6.1801516,longitude:106.7572299)
Shop.find_by(bengkel_id: 100236).update(latitude: -6.1628049,longitude:106.7678317)
Shop.find_by(bengkel_id: 100237).update(latitude: -6.2052822,longitude:106.7964749)
Shop.find_by(bengkel_id: 100238).update(latitude: -6.1961671,longitude:106.7492212)
Shop.find_by(bengkel_id: 100239).update(latitude: -6.166633,longitude:106.7491927)
Shop.find_by(bengkel_id: 100240).update(latitude: -6.2067107,longitude:106.7961044)
Shop.find_by(bengkel_id: 100241).update(latitude: -6.1526416,longitude:106.7839204)
Shop.find_by(bengkel_id: 100242).update(latitude: -6.1526416,longitude:106.7839204)
Shop.find_by(bengkel_id: 100243).update(latitude: -6.1630663,longitude:106.7261763)
Shop.find_by(bengkel_id: 100244).update(latitude: -6.2177955,longitude:106.7573926)
Shop.find_by(bengkel_id: 100245).update(latitude: -6.1826679,longitude:106.7676275)
Shop.find_by(bengkel_id: 100246).update(latitude: -6.1923762,longitude:106.7976129)
Shop.find_by(bengkel_id: 100247).update(latitude: -6.1758939,longitude:106.7617984)
Shop.find_by(bengkel_id: 100248).update(latitude: -6.211174,longitude:106.771247)
Shop.find_by(bengkel_id: 100249).update(latitude: -6.173974,longitude:106.765822)
Shop.find_by(bengkel_id: 100250).update(latitude: -6.183744,longitude:106.759225)
Shop.find_by(bengkel_id: 100251).update(latitude: -6.212218,longitude:106.75936)
Shop.find_by(bengkel_id: 100252).update(latitude: -6.17845,longitude:106.76615)
Shop.find_by(bengkel_id: 100253).update(latitude: -6.1967931,longitude:106.7481362)
Shop.find_by(bengkel_id: 100254).update(latitude: -6.211497,longitude:106.771266)
Shop.find_by(bengkel_id: 100255).update(latitude: -6.176903,longitude:106.7836577)
Shop.find_by(bengkel_id: 100256).update(latitude: -6.1610766,longitude:106.7698956)
Shop.find_by(bengkel_id: 100257).update(latitude: -6.131927,longitude:106.728414)
Shop.find_by(bengkel_id: 100259).update(latitude: -6.168204,longitude:106.75888)
Shop.find_by(bengkel_id: 100260).update(latitude: -6.1911223,longitude:106.7856905)
Shop.find_by(bengkel_id: 100261).update(latitude: -6.2086896,longitude:106.7692311)
Shop.find_by(bengkel_id: 100262).update(latitude: -6.146436,longitude:106.789221)
Shop.find_by(bengkel_id: 100263).update(latitude: -6.211143,longitude:106.7711961)
Shop.find_by(bengkel_id: 100264).update(latitude: -6.2164108,longitude:106.7683341)
Shop.find_by(bengkel_id: 100265).update(latitude: -6.209523,longitude:106.759535)
Shop.find_by(bengkel_id: 100266).update(latitude: -6.184269,longitude:106.78125)
Shop.find_by(bengkel_id: 100267).update(latitude: -6.1975803,longitude:106.758631)
Shop.find_by(bengkel_id: 100268).update(latitude: -6.1834092,longitude:106.7669214)
Shop.find_by(bengkel_id: 100269).update(latitude: -6.1442892,longitude:106.781715)
Shop.find_by(bengkel_id: 100270).update(latitude: -6.174397,longitude:106.748474)
Shop.find_by(bengkel_id: 100272).update(latitude: -6.1617766,longitude:106.7907347)
Shop.find_by(bengkel_id: 100273).update(latitude: -6.1939199,longitude:106.781791)
Shop.find_by(bengkel_id: 100274).update(latitude: -6.1494889,longitude:106.7211096)
Shop.find_by(bengkel_id: 100275).update(latitude: -6.2529899,longitude:106.837783)
Shop.find_by(bengkel_id: 100276).update(latitude: -6.196558,longitude:106.7947892)
Shop.find_by(bengkel_id: 100277).update(latitude: -6.202742,longitude:106.798434)
Shop.find_by(bengkel_id: 100278).update(latitude: -6.1588695,longitude:106.7797065)
Shop.find_by(bengkel_id: 100279).update(latitude: -6.1604368,longitude:106.781926)
Shop.find_by(bengkel_id: 100280).update(latitude: -6.1449664,longitude:106.7428301)
Shop.find_by(bengkel_id: 100281).update(latitude: -6.1466021,longitude:106.7340452)
Shop.find_by(bengkel_id: 100282).update(latitude: -6.207505,longitude:106.794789)
Shop.find_by(bengkel_id: 100283).update(latitude: -6.210069,longitude:106.75917)
Shop.find_by(bengkel_id: 100284).update(latitude: -6.1981343,longitude:106.768867)
Shop.find_by(bengkel_id: 100285).update(latitude: -6.1492185,longitude:106.7733654)
Shop.find_by(bengkel_id: 100286).update(latitude: -6.2072942,longitude:106.794984)
Shop.find_by(bengkel_id: 100287).update(latitude: -6.231783,longitude:106.771849)
Shop.find_by(bengkel_id: 100288).update(latitude: -6.1673915,longitude:106.7635458)
Shop.find_by(bengkel_id: 100289).update(latitude: -6.1672883,longitude:106.7634717)
Shop.find_by(bengkel_id: 100290).update(latitude: -6.158898,longitude:106.757194)
Shop.find_by(bengkel_id: 100291).update(latitude: -6.1683816,longitude:106.764282)
Shop.find_by(bengkel_id: 100292).update(latitude: -6.184499,longitude:106.754159)
Shop.find_by(bengkel_id: 100293).update(latitude: -6.1617462,longitude:106.7851001)
Shop.find_by(bengkel_id: 100294).update(latitude: -6.1584691,longitude:106.7571417)
Shop.find_by(bengkel_id: 100295).update(latitude: -6.1658468,longitude:106.7646983)
Shop.find_by(bengkel_id: 100296).update(latitude: -6.158838,longitude:106.791193)
Shop.find_by(bengkel_id: 100297).update(latitude: -6.172723,longitude:106.755955)
Shop.find_by(bengkel_id: 100298).update(latitude: -6.1327019,longitude:106.7242974)
Shop.find_by(bengkel_id: 100299).update(latitude: -6.159818,longitude:106.785392)
Shop.find_by(bengkel_id: 100300).update(latitude: -6.1784909,longitude:106.7574521)
Shop.find_by(bengkel_id: 100301).update(latitude: -6.1865388,longitude:106.7873592)
Shop.find_by(bengkel_id: 100302).update(latitude: -6.146788,longitude:106.7303146)
Shop.find_by(bengkel_id: 100303).update(latitude: -6.197558,longitude:106.770455)
Shop.find_by(bengkel_id: 100304).update(latitude: -6.1713223,longitude:106.7274825)
Shop.find_by(bengkel_id: 100305).update(latitude: -6.1511917,longitude:106.7916295)
Shop.find_by(bengkel_id: 100306).update(latitude: -6.1640863,longitude:106.7788911)
Shop.find_by(bengkel_id: 100307).update(latitude: -6.1730337,longitude:106.7835306)
Shop.find_by(bengkel_id: 100308).update(latitude: -6.199303,longitude:106.794977)
Shop.find_by(bengkel_id: 100309).update(latitude: -6.1984776,longitude:106.7922142)
Shop.find_by(bengkel_id: 100310).update(latitude: -6.191219,longitude:106.79371)
Shop.find_by(bengkel_id: 100311).update(latitude: -6.201917,longitude:106.790444)
Shop.find_by(bengkel_id: 100312).update(latitude: -6.184635,longitude:106.646612)

# ========== Shop Business Hours ==========

ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100002), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100002), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100002), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100002), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100002), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100002), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100005), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100005), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100005), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100005), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100005), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100005), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100005), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100006), day_of_week: :sun, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100006), day_of_week: :mon, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100006), day_of_week: :tue, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100006), day_of_week: :wed, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100006), day_of_week: :thu, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100006), day_of_week: :fri, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100006), day_of_week: :sat, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100009), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100009), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100009), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100009), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100009), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100009), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100009), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100012), day_of_week: :sun, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100012), day_of_week: :mon, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100012), day_of_week: :tue, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100012), day_of_week: :wed, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100012), day_of_week: :thu, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100012), day_of_week: :fri, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100012), day_of_week: :sat, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:16, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100013), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100013), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100013), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100013), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100013), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100013), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100015), day_of_week: :sun, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100015), day_of_week: :tue, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100015), day_of_week: :wed, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100015), day_of_week: :thu, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100015), day_of_week: :fri, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100015), day_of_week: :sat, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100019), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100019), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100019), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100019), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100019), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100019), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100019), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100021), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100021), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100021), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100021), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100021), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100021), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100021), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100022), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100022), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100022), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100022), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100022), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100022), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100022), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100023), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100023), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100023), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100023), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100023), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100023), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100023), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100025), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100025), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100025), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100025), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100025), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100025), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100025), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100028), day_of_week: :sun, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100028), day_of_week: :mon, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100028), day_of_week: :tue, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100028), day_of_week: :wed, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100028), day_of_week: :thu, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100028), day_of_week: :fri, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100028), day_of_week: :sat, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100029), day_of_week: :sun, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100029), day_of_week: :mon, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100029), day_of_week: :tue, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100029), day_of_week: :wed, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100029), day_of_week: :thu, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100029), day_of_week: :fri, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100029), day_of_week: :sat, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100033), day_of_week: :sun, is_holiday:false, open_time_hour: 18, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100033), day_of_week: :mon, is_holiday:false, open_time_hour: 18, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100033), day_of_week: :tue, is_holiday:false, open_time_hour: 18, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100033), day_of_week: :wed, is_holiday:false, open_time_hour: 18, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100033), day_of_week: :thu, is_holiday:false, open_time_hour: 18, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100033), day_of_week: :fri, is_holiday:false, open_time_hour: 18, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100033), day_of_week: :sat, is_holiday:false, open_time_hour: 18, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100036), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100036), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100036), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100036), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100036), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100036), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100036), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100039), day_of_week: :sun, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100039), day_of_week: :mon, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100039), day_of_week: :tue, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100039), day_of_week: :wed, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100039), day_of_week: :thu, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100039), day_of_week: :fri, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100039), day_of_week: :sat, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100042), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100042), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100042), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100042), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100042), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100042), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100042), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100044), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100044), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100044), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100044), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100044), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100044), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100045), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100045), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100045), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100045), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100045), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100045), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100045), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100047), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:20, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100047), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:20, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100047), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:20, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100047), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:20, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100047), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:20, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100047), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:20, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100047), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:20, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100048), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100048), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100048), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100048), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100048), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100048), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100048), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100052), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100052), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100052), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100052), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100052), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100052), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100052), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100053), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100053), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100053), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100053), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100053), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100053), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100053), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100054), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100054), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100054), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100054), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100054), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100054), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100054), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100058), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100058), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100058), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100058), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100058), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100058), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100058), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100059), day_of_week: :sun, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100059), day_of_week: :mon, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100059), day_of_week: :tue, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100059), day_of_week: :wed, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100059), day_of_week: :thu, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100059), day_of_week: :fri, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100059), day_of_week: :sat, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100061), day_of_week: :sun, is_holiday:false, open_time_hour: 0, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100061), day_of_week: :mon, is_holiday:false, open_time_hour: 0, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100061), day_of_week: :tue, is_holiday:false, open_time_hour: 0, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100061), day_of_week: :wed, is_holiday:false, open_time_hour: 0, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100061), day_of_week: :thu, is_holiday:false, open_time_hour: 0, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100061), day_of_week: :fri, is_holiday:false, open_time_hour: 0, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100061), day_of_week: :sat, is_holiday:false, open_time_hour: 0, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100062), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100062), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100062), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100062), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100062), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100062), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100062), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100063), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100063), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100063), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100063), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100063), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100063), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100063), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100064), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100064), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100064), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100064), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100064), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100064), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100064), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100065), day_of_week: :sun, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100065), day_of_week: :mon, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100065), day_of_week: :tue, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100065), day_of_week: :wed, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100065), day_of_week: :thu, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100065), day_of_week: :fri, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100065), day_of_week: :sat, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100066), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100066), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100066), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100066), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100066), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100066), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100066), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100067), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100067), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100067), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100067), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100067), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100067), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100067), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100068), day_of_week: :sun, is_holiday:false, open_time_hour: 14, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100068), day_of_week: :mon, is_holiday:false, open_time_hour: 14, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100068), day_of_week: :tue, is_holiday:false, open_time_hour: 14, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100068), day_of_week: :wed, is_holiday:false, open_time_hour: 14, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100068), day_of_week: :thu, is_holiday:false, open_time_hour: 14, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100068), day_of_week: :fri, is_holiday:false, open_time_hour: 14, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100068), day_of_week: :sat, is_holiday:false, open_time_hour: 14, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100070), day_of_week: :sun, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100070), day_of_week: :mon, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100070), day_of_week: :tue, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100070), day_of_week: :wed, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100070), day_of_week: :thu, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100070), day_of_week: :fri, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100070), day_of_week: :sat, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100072), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100072), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100072), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100072), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100072), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100072), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100072), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100073), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100073), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100073), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100073), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100073), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100073), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100073), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100075), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100075), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100075), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100075), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100075), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100075), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100075), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100076), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100076), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100076), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100076), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100076), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100076), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100076), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100078), day_of_week: :sun, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100078), day_of_week: :mon, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100078), day_of_week: :tue, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100078), day_of_week: :wed, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100078), day_of_week: :thu, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100078), day_of_week: :fri, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100078), day_of_week: :sat, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100084), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100084), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100084), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100084), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100084), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100084), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100084), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100085), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100085), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100085), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100085), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100085), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100085), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100085), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100087), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100087), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100087), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100087), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100087), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100087), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100087), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100089), day_of_week: :sun, is_holiday:false, open_time_hour: 7, open_time_minute: 30,close_time_hour:16, close_time_minute:39)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100089), day_of_week: :mon, is_holiday:false, open_time_hour: 7, open_time_minute: 30,close_time_hour:16, close_time_minute:39)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100089), day_of_week: :tue, is_holiday:false, open_time_hour: 7, open_time_minute: 30,close_time_hour:16, close_time_minute:39)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100089), day_of_week: :wed, is_holiday:false, open_time_hour: 7, open_time_minute: 30,close_time_hour:16, close_time_minute:39)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100089), day_of_week: :thu, is_holiday:false, open_time_hour: 7, open_time_minute: 30,close_time_hour:16, close_time_minute:39)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100089), day_of_week: :fri, is_holiday:false, open_time_hour: 7, open_time_minute: 30,close_time_hour:16, close_time_minute:39)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100089), day_of_week: :sat, is_holiday:false, open_time_hour: 7, open_time_minute: 30,close_time_hour:16, close_time_minute:39)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100092), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100092), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100092), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100092), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100092), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100092), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100092), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100095), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100095), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100095), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100095), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100095), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100095), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100096), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100096), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100096), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100096), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100096), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100096), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100096), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100102), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100102), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100102), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100102), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100102), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100102), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100102), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100103), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100103), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100103), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100103), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100103), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100103), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100103), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100106), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100106), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100106), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100106), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100106), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100106), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100106), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100110), day_of_week: :sun, is_holiday:false, open_time_hour: 12, open_time_minute: 0,close_time_hour:24, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100110), day_of_week: :mon, is_holiday:false, open_time_hour: 12, open_time_minute: 0,close_time_hour:24, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100110), day_of_week: :tue, is_holiday:false, open_time_hour: 12, open_time_minute: 0,close_time_hour:24, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100110), day_of_week: :wed, is_holiday:false, open_time_hour: 12, open_time_minute: 0,close_time_hour:24, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100110), day_of_week: :thu, is_holiday:false, open_time_hour: 12, open_time_minute: 0,close_time_hour:24, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100110), day_of_week: :sat, is_holiday:false, open_time_hour: 12, open_time_minute: 0,close_time_hour:24, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100112), day_of_week: :sun, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100112), day_of_week: :mon, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100112), day_of_week: :tue, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100112), day_of_week: :wed, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100112), day_of_week: :thu, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100112), day_of_week: :fri, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100112), day_of_week: :sat, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100114), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:16, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100114), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:16, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100114), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:16, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100114), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:16, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100114), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:16, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100114), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:16, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100114), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:16, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100115), day_of_week: :sun, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100115), day_of_week: :mon, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100115), day_of_week: :tue, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100115), day_of_week: :wed, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100115), day_of_week: :thu, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100115), day_of_week: :fri, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100115), day_of_week: :sat, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100122), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100122), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100122), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100122), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100122), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100122), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100122), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100123), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100123), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100123), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100123), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100123), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100123), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100123), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100126), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100126), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100126), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100126), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100126), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100126), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100127), day_of_week: :sun, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100127), day_of_week: :mon, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100127), day_of_week: :tue, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100127), day_of_week: :wed, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100127), day_of_week: :thu, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100127), day_of_week: :fri, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100127), day_of_week: :sat, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100128), day_of_week: :sun, is_holiday:false, open_time_hour: 7, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100128), day_of_week: :mon, is_holiday:false, open_time_hour: 7, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100128), day_of_week: :tue, is_holiday:false, open_time_hour: 7, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100128), day_of_week: :wed, is_holiday:false, open_time_hour: 7, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100128), day_of_week: :thu, is_holiday:false, open_time_hour: 7, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100128), day_of_week: :fri, is_holiday:false, open_time_hour: 12, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100128), day_of_week: :sat, is_holiday:false, open_time_hour: 7, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100129), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100129), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100129), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100129), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100129), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100129), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100129), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100131), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100131), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100131), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100131), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100131), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100131), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100131), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:0, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100132), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100132), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100132), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100132), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100132), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100132), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100132), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100137), day_of_week: :sun, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100137), day_of_week: :mon, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100137), day_of_week: :tue, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100137), day_of_week: :wed, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100137), day_of_week: :thu, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100137), day_of_week: :fri, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100137), day_of_week: :sat, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100139), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100139), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100139), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100139), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100139), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100139), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100139), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100140), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100140), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100140), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100140), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100140), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100140), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100140), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100144), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100144), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100144), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100144), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100144), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100144), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100148), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100148), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100148), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100148), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100148), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100148), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100148), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100156), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100156), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100156), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100156), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100156), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100156), day_of_week: :fri, is_holiday:false, open_time_hour: 13, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100156), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100167), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100167), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100167), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100167), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100167), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100167), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100167), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100177), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100177), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100177), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100177), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100177), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100177), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100177), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100178), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100178), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100178), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100178), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100178), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100178), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100178), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100179), day_of_week: :sun, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100179), day_of_week: :mon, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100179), day_of_week: :tue, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100179), day_of_week: :wed, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100179), day_of_week: :thu, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100179), day_of_week: :fri, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100179), day_of_week: :sat, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100180), day_of_week: :sun, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:16, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100180), day_of_week: :mon, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:16, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100180), day_of_week: :tue, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:16, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100180), day_of_week: :wed, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:16, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100180), day_of_week: :thu, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:16, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100180), day_of_week: :fri, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:16, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100180), day_of_week: :sat, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:16, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100182), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100182), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100182), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100182), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100182), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100182), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100182), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100185), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100185), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100185), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100185), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100185), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100185), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100185), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100187), day_of_week: :sun, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100187), day_of_week: :mon, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100187), day_of_week: :tue, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100187), day_of_week: :wed, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100187), day_of_week: :thu, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100187), day_of_week: :fri, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100187), day_of_week: :sat, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100188), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100188), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100188), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100188), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100188), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100188), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100188), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100189), day_of_week: :sun, is_holiday:false, open_time_hour: 6, open_time_minute: 30,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100189), day_of_week: :mon, is_holiday:false, open_time_hour: 6, open_time_minute: 30,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100189), day_of_week: :tue, is_holiday:false, open_time_hour: 6, open_time_minute: 30,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100189), day_of_week: :wed, is_holiday:false, open_time_hour: 6, open_time_minute: 30,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100189), day_of_week: :thu, is_holiday:false, open_time_hour: 6, open_time_minute: 30,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100189), day_of_week: :fri, is_holiday:false, open_time_hour: 6, open_time_minute: 30,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100189), day_of_week: :sat, is_holiday:false, open_time_hour: 6, open_time_minute: 30,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100190), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100190), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100190), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100190), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100190), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100190), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100190), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100192), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100192), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100192), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100192), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100192), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100192), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100192), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100194), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100194), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100194), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100194), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100194), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100194), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100194), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100196), day_of_week: :sun, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100196), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100196), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100196), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100196), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100196), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100196), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100198), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100198), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100198), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100198), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100198), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100198), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100199), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100199), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100199), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100199), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100199), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100199), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100199), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100207), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100207), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100207), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100207), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100207), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100207), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100207), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100210), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100210), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100210), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100210), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100210), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100210), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100210), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100214), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100214), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100214), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100214), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100214), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100214), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100214), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100220), day_of_week: :mon, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100220), day_of_week: :tue, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100220), day_of_week: :wed, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100220), day_of_week: :thu, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100220), day_of_week: :fri, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100220), day_of_week: :sat, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:20, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100223), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100223), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100223), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100223), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100223), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100223), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100224), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100224), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100224), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100224), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100224), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100224), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100226), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100226), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100226), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100226), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100226), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100226), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100227), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100227), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100227), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100227), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100227), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100227), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100227), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100228), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100228), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100228), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100228), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100228), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100228), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100228), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100229), day_of_week: :sun, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100229), day_of_week: :mon, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100229), day_of_week: :tue, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100229), day_of_week: :wed, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100229), day_of_week: :thu, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100229), day_of_week: :fri, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100229), day_of_week: :sat, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100235), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100235), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100235), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100235), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100235), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100235), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100235), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100238), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100238), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100238), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100238), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100238), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100238), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100238), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100240), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:16, close_time_minute:50)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100240), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:16, close_time_minute:50)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100240), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:16, close_time_minute:50)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100240), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:16, close_time_minute:50)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100240), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:16, close_time_minute:50)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100240), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:16, close_time_minute:50)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100244), day_of_week: :sun, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100244), day_of_week: :mon, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100244), day_of_week: :tue, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100244), day_of_week: :wed, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100244), day_of_week: :thu, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100244), day_of_week: :sat, is_holiday:false, open_time_hour: 10, open_time_minute: 0,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100265), day_of_week: :sun, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100265), day_of_week: :mon, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100265), day_of_week: :tue, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100265), day_of_week: :wed, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100265), day_of_week: :thu, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100265), day_of_week: :fri, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100265), day_of_week: :sat, is_holiday:false, open_time_hour: 7, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100273), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100273), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100273), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100273), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100273), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100273), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100273), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:22, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100277), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100277), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100277), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100277), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100277), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100277), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100277), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100278), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100278), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100278), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100278), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100278), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100278), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100278), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100280), day_of_week: :sun, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100280), day_of_week: :mon, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100280), day_of_week: :tue, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100280), day_of_week: :wed, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100280), day_of_week: :thu, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100280), day_of_week: :fri, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100280), day_of_week: :sat, is_holiday:false, open_time_hour: 9, open_time_minute: 0,close_time_hour:19, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100281), day_of_week: :sun, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100281), day_of_week: :mon, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100281), day_of_week: :tue, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100281), day_of_week: :wed, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100281), day_of_week: :thu, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100281), day_of_week: :fri, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100281), day_of_week: :sat, is_holiday:false, open_time_hour: 6, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100284), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100284), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100284), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100284), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100284), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100284), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100284), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:17, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100288), day_of_week: :sun, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100288), day_of_week: :mon, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100288), day_of_week: :tue, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100288), day_of_week: :wed, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100288), day_of_week: :thu, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100288), day_of_week: :fri, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100288), day_of_week: :sat, is_holiday:false, open_time_hour: 11, open_time_minute: 0,close_time_hour:21, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100289), day_of_week: :sun, is_holiday:false, open_time_hour: 10, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100289), day_of_week: :mon, is_holiday:false, open_time_hour: 10, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100289), day_of_week: :tue, is_holiday:false, open_time_hour: 10, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100289), day_of_week: :wed, is_holiday:false, open_time_hour: 10, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100289), day_of_week: :thu, is_holiday:false, open_time_hour: 10, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100289), day_of_week: :sat, is_holiday:false, open_time_hour: 10, open_time_minute: 30,close_time_hour:19, close_time_minute:30)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100294), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100294), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100294), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100294), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100294), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100294), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100294), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 30,close_time_hour:18, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100302), day_of_week: :sun, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100302), day_of_week: :mon, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100302), day_of_week: :tue, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100302), day_of_week: :wed, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100302), day_of_week: :thu, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100302), day_of_week: :fri, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:23, close_time_minute:0)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100302), day_of_week: :sat, is_holiday:false, open_time_hour: 8, open_time_minute: 0,close_time_hour:23, close_time_minute:0)

ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100002), day_of_week: :fri, is_holiday:true)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100013), day_of_week: :mon, is_holiday:true)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100015), day_of_week: :mon, is_holiday:true)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100044), day_of_week: :fri, is_holiday:true)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100095), day_of_week: :sun, is_holiday:true)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100110), day_of_week: :fri, is_holiday:true)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100126), day_of_week: :fri, is_holiday:true)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100144), day_of_week: :fri, is_holiday:true)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100198), day_of_week: :sun, is_holiday:true)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100220), day_of_week: :sun, is_holiday:true)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100223), day_of_week: :fri, is_holiday:true)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100224), day_of_week: :tue, is_holiday:true)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100226), day_of_week: :fri, is_holiday:true)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100240), day_of_week: :sun, is_holiday:true)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100244), day_of_week: :fri, is_holiday:true)
ShopBusinessHour.create(shop:Shop.find_by(bengkel_id:100289), day_of_week: :fri, is_holiday:true)

# ========== Maintenance Menu ==========

MaintenanceMenu.create(
  [
    {name: 'Ganti Oli Mesin'},
    {name: 'Ganti Oli Gear'},
    {name: 'Ganti Kampas Rem Depan'},
    {name: 'Ganti Kampas Rem Belakang'},
    {name: 'Ganti Ban Depan'},
    {name: 'Ganti Ban Belakang'},
    {name: 'Service Ringan'},
    {name: 'Aksesori'},
    {name: 'Lainnya'},
    {name: 'Diskon'}
  ]
)

# ========== Maker ==========

Maker.create(
  [
    {name: 'HONDA', order: 1},
    {name: 'YAMAHA', order: 2},
    {name: 'SUZUKI', order: 3},
    {name: 'KAWASAKI', order: 4},
    {name: 'BAJAJ', order: 5},
    {name: 'TVS', order: 6},
    {name: 'APRILIA', order: 7},
    {name: 'BENELLI', order: 8},
    {name: 'BIMOTA', order: 9},
    {name: 'BMW', order: 10},
    {name: 'BUELL', order: 11},
    {name: 'CAGIVA', order: 12},
    {name: 'DUCATI', order: 13},
    {name: 'GASGAS', order: 14},
    {name: 'GILERA', order: 15},
    {name: 'HARLEY-DAVIDSON', order: 16},
    {name: 'HARTFORD', order: 17},
    {name: 'HUSQVARNA', order: 18},
    {name: 'HYOSUNG', order: 19},
    {name: 'INDIAN MOTORCYCLE', order: 20},
    {name: 'JIALING', order: 21},
    {name: 'KANZEN', order: 22},
    {name: 'KREIDLER', order: 23},
    {name: 'KTM', order: 24},
    {name: 'KYMCO', order: 25},
    {name: 'MBK', order: 26},
    {name: 'MEGALLI', order: 27},
    {name: 'MINERVA', order: 28},
    {name: 'MOTO GUZZI', order: 29},
    {name: 'MV AGUSTA', order: 30},
    {name: 'PEUGEOT', order: 31},
    {name: 'PIAGGIO', order: 32},
    {name: 'ROYAL ENFIELD', order: 33},
    {name: 'SANEX', order: 34},
    {name: 'SCORPA', order: 35},
    {name: 'SYM', order: 36},
    {name: 'TOSSA', order: 37},
    {name: 'TRIUMPH', order: 38},
    {name: 'VESPA', order: 39},
    {name: 'VIAR', order: 40},
    {name: 'VICTORY', order: 41},
    {name: 'ABRTH', order: 42},
    {name: 'ALFA ROMEO', order: 43},
    {name: 'ASTON MARTIN', order: 44},
    {name: 'AUDI', order: 45},
    {name: 'BMW(Auto)', order: 46},
    {name: 'CHEVROLET', order: 47},
    {name: 'CHRYSLER', order: 48},
    {name: 'CITROEN', order: 49},
    {name: 'DACIA', order: 50},
    {name: 'DAIHATSU', order: 51},
    {name: 'DATSUN', order: 52},
    {name: 'FERRARI', order: 53},
    {name: 'FIAT', order: 54},
    {name: 'FORD', order: 55},
    {name: 'HINO', order: 56},
    {name: 'HONDA(Auto)', order: 57},
    {name: 'HYUNDAI', order: 58},
    {name: 'ISUZU', order: 59},
    {name: 'JAGUAR', order: 60},
    {name: 'KIA', order: 61},
    {name: 'LADA', order: 62},
    {name: 'LAMBORGHINI', order: 63},
    {name: 'LANCIA', order: 64},
    {name: 'LAND ROVER', order: 65},
    {name: 'LEXUS', order: 66},
    {name: 'LOTUS', order: 67},
    {name: 'MAZDA', order: 68},
    {name: 'MERCEDES-BENZ', order: 69},
    {name: 'MINI', order: 70},
    {name: 'MITSUBISHI', order: 71},
    {name: 'NISSAN', order: 72},
    {name: 'PEUGEOT(Auto)', order: 73},
    {name: 'PORSCHE', order: 74},
    {name: 'PROTON', order: 75},
    {name: 'RENAULT', order: 76},
    {name: 'SEAT', order: 77},
    {name: 'SKODA', order: 78},
    {name: 'SMART', order: 79},
    {name: 'SUBARU', order: 80},
    {name: 'SUZUKI(Auto)', order: 81},
    {name: 'TATA', order: 82},
    {name: 'TESLA', order: 83},
    {name: 'TOYOTA', order: 84},
    {name: 'VOLKSWAGEN', order: 85},
    {name: 'VOLVO', order: 86},
    {name: 'Other', order: 87}
  ]
)

# ========== Bike Model ==========

model_list = []
maker = Maker.find_by(name: 'HONDA')
models = [ 
  {maker: maker, name: 'Blade 125 FI Drum Brake'},
  {maker: maker, name: 'Blade 125 FI Disc Brake MMC'},
  {maker: maker, name: 'Blade 125 FI Repsol MMC'},
  {maker: maker, name: 'Supra X 125 FI Spoke Wheel'},
  {maker: maker, name: 'Supra X 125 FI Cast Wheel'},
  {maker: maker, name: 'Supra X 125 FI Helm In'},
  {maker: maker, name: 'Supra GTR 150 Sporty Nictic Orange'},
  {maker: maker, name: 'Supra GTR 150 Sporty Spartan Red'},
  {maker: maker, name: 'Supra GTR 150 Exclusive Gun Black'},
  {maker: maker, name: 'Revo Fit FI MMC'},
  {maker: maker, name: 'Revo Spoke FI MMC'},
  {maker: maker, name: 'Revo CW FI MMC'},
  {maker: maker, name: 'Spacy CW FI'},
  {maker: maker, name: 'Vario 110 eSP CBS'},
  {maker: maker, name: 'Vario 110 eSP CBS Advanced'},
  {maker: maker, name: 'Vario 110 eSP CBS - ISS'},
  {maker: maker, name: 'Vario 110 eSP CBS - ISS Advanced'},
  {maker: maker, name: 'Vario 125 CBS'},
  {maker: maker, name: 'Vario 125 CBS-ISS'},
  {maker: maker, name: 'Vario 150 Sporty'},
  {maker: maker, name: 'Vario 150'},
  {maker: maker, name: 'PCX 150'},
  {maker: maker, name: 'Scoopy Sporty'},
  {maker: maker, name: 'Scoopy Stylish'},
  {maker: maker, name: 'Scoopy Playful'},
  {maker: maker, name: 'BeAT Sporty CW'},
  {maker: maker, name: 'BeAT Sporty CBS'},
  {maker: maker, name: 'BeAT Sporty CBS ISS'},
  {maker: maker, name: 'BeAT Pop CW Pixel'},
  {maker: maker, name: 'BeAT Pop CW Comic'},
  {maker: maker, name: 'BeAT Pop CBS Pixel'},
  {maker: maker, name: 'BeAT Pop CBS Comic'},
  {maker: maker, name: 'BeAT Pop CBS ISS Pixel'},
  {maker: maker, name: 'BeAT Pop CBS ISS Comic'},
  {maker: maker, name: 'BeAT Streat eSP'},
  {maker: maker, name: 'Mega Pro FI'},
  {maker: maker, name: 'CBR 150R Slick Black White'},
  {maker: maker, name: 'CBR 150R Victory Black Red'},
  {maker: maker, name: 'CBR 150R Racing Red'},
  {maker: maker, name: 'CBR 150R Repsol Edition'},
  {maker: maker, name: 'CBR250RR Black Metallic Standar'},
  {maker: maker, name: 'CBR250RR Racing Red Standar'},
  {maker: maker, name: 'CBR250RR Black Metallic ABS'},
  {maker: maker, name: 'CBR250RR Racing Red ABS'},
  {maker: maker, name: 'CBR250RR Graymetallic Standar'},
  {maker: maker, name: 'CBR250RR Graymetallic ABS'},
  {maker: maker, name: 'CBR250RR Repsol Edition ABS'},
  {maker: maker, name: 'CRF250RALLY - Extreme Red'},
  {maker: maker, name: 'Verza 150 Spoke MMC'},
  {maker: maker, name: 'Verza 150 CW MMC'},
  {maker: maker, name: 'Sonic 150R Standar'},
  {maker: maker, name: 'Sonic 150R Repsol'},
  {maker: maker, name: 'Sonic 150R Special (Black)'},
  {maker: maker, name: 'Honda CB150R Streetfire SE'},
  {maker: maker, name: 'Honda CB150R Streetfire'},
] 
model_list << models

maker = Maker.find_by(name: 'KAWASAKI')
models = [
  {maker: maker, name: 'Ninja H2 Carbon'},
  {maker: maker, name: 'Ninja H2'},
  {maker: maker, name: 'Ninja ZX10-R'},
  {maker: maker, name: 'Ninja ZX-14R Ohlins'},
  {maker: maker, name: 'Ninja ZX-14R SE'},
  {maker: maker, name: 'Ninja ZX-14R'},
  {maker: maker, name: 'Ninja ZX-6R 636 SE'},
  {maker: maker, name: 'Ninja ZX-6R 636'},
  {maker: maker, name: 'New Ninja 650 SE'},
  {maker: maker, name: 'New Ninja 650'},
  {maker: maker, name: 'Ninja 650 ABS'},
  {maker: maker, name: 'Ninja 650'},
  {maker: maker, name: 'Ninja 300'},
  {maker: maker, name: 'Ninja 250 ABS SE LTD'},
  {maker: maker, name: 'Ninja 250 SE LTD'},
  {maker: maker, name: 'Ninja 250'},
  {maker: maker, name: 'Ninja 250SL'},
  {maker: maker, name: 'Z1000'},
  {maker: maker, name: 'Z900'},
  {maker: maker, name: 'Z800'},
  {maker: maker, name: 'Z650'},
  {maker: maker, name: 'Z250'},
  {maker: maker, name: 'Z250SL ABS'},
  {maker: maker, name: 'Z250SL'},
  {maker: maker, name: 'Z125 PRO'},
  {maker: maker, name: 'Versys 1000'},
  {maker: maker, name: 'Versys 650'},
  {maker: maker, name: 'Versys-X 250 Tourer'},
  {maker: maker, name: 'Versys-X 250 City'},
  {maker: maker, name: 'Vulcan S'},
  {maker: maker, name: 'W800 Special Edition'},
  {maker: maker, name: 'W800'},
  {maker: maker, name: 'ER-6n ABS'},
  {maker: maker, name: 'ER-6n'},
  {maker: maker, name: 'Estrella Special Edition'},
  {maker: maker, name: 'D-TRACKER X'},
  {maker: maker, name: 'D-Tracker SE'},
  {maker: maker, name: 'D-Tracker'},
  {maker: maker, name: 'KSR PRO'},
]

model_list << models

maker = Maker.find_by(name: 'SUZUKI')
models = [
  {maker: maker, name: 'Address FI'},
  {maker: maker, name: 'SATRIA F150'},
  {maker: maker, name: 'GSX-R150'},
  {maker: maker, name: 'GSX-S150'},
  {maker: maker, name: 'Inazuma R'},
  {maker: maker, name: 'V-Strom 650'},
]

model_list << models

maker = Maker.find_by(name: 'YAMAHA')
models = [
  {maker: maker, name: 'AEROX 155VVA S-VERSION'},
  {maker: maker, name: 'AEROX 155VVA R-VERSION'},
  {maker: maker, name: 'AEROX 155 VVA'},
  {maker: maker, name: 'MIO M3 125 AKS SSS'},
  {maker: maker, name: 'MIO M3 125'},
  {maker: maker, name: 'MIO Z'},
  {maker: maker, name: 'FINO 125 BLUE CORE - GRANDE'},
  {maker: maker, name: 'FINO 125 BLUE CORE PREMIUM'},
  {maker: maker, name: 'FINO 125 BLUE CORE SPORTY'},
  {maker: maker, name: 'NMAX ABS'},
  {maker: maker, name: 'NMAX'},
  {maker: maker, name: 'SOUL GT AKS SSS'},
  {maker: maker, name: 'SOUL GT AKS'},
  {maker: maker, name: 'X-RIDE'},
  {maker: maker, name: 'V-IXION ADVANCE'},
  {maker: maker, name: 'V-IXION ADVANCE SPECIAL EDITION'},
  {maker: maker, name: 'XABRE'},
  {maker: maker, name: 'MT-25'},
  {maker: maker, name: 'BYSON FI'},
  {maker: maker, name: 'JUPITER MX KING 150'},
  {maker: maker, name: 'JUPITER MX 150'},
  {maker: maker, name: 'VEGA FORCE'},
  {maker: maker, name: 'JUPITER Z1'},
  {maker: maker, name: 'R25 - ABS'},
  {maker: maker, name: 'R25'},
  {maker: maker, name: 'R15'},
  {maker: maker, name: 'R1'},
  {maker: maker, name: 'R1M'},
  {maker: maker, name: 'MT09'},
  {maker: maker, name: 'R6'},
  {maker: maker, name: 'WR250 R'},
  {maker: maker, name: 'MT09 TRACER'},
]

model_list << models

maker = Maker.find_by(name: 'TVS')
models = [
  {maker: maker, name: 'Apache RTR 200'},
  {maker: maker, name: 'Apache RTR 180'},
  {maker: maker, name: 'Apache RTR 160'},
  {maker: maker, name: 'Dazz Digitech-R'},
  {maker: maker, name: 'Dazz DFI'},
  {maker: maker, name: 'Neo XR'},
  {maker: maker, name: 'Rockz'},
  {maker: maker, name: 'Max 125 Sports'},
  {maker: maker, name: 'Max 125 Semi'},
]

model_list << models

maker = Maker.find_by(name: 'KTM')
models = [
  {maker: maker, name: 'DUKE 200'},
  {maker: maker, name: 'DUKE 250'},
  {maker: maker, name: 'RC 200'},
  {maker: maker, name: 'RC 250'},
  {maker: maker, name: 'RC 390'},
]

model_list << models

maker = Maker.find_by(name: 'BMW')
models = [
  {maker: maker, name: 'HP4 RACE'},
  {maker: maker, name: 'S 1000 RR'},
  {maker: maker, name: 'R 1200 RS'},
  {maker: maker, name: 'K 1600 GTL'},
  {maker: maker, name: 'K 1600 GT'},
  {maker: maker, name: 'R 1200 RT'},
  {maker: maker, name: 'F 800 GT'},
  {maker: maker, name: 'R 1200 R'},
  {maker: maker, name: 'S 1000 R'},
  {maker: maker, name: 'F 800 R'},
  {maker: maker, name: 'G 310 R'},
  {maker: maker, name: 'R NINE T'},
  {maker: maker, name: 'R NINE T PURE'},
  {maker: maker, name: 'R NINE T RACER'},
  {maker: maker, name: 'R NINET SCRAMBLER'},
  {maker: maker, name: 'R NINE T URBAN G/S'},
  {maker: maker, name: 'R 1200 GS ADVENTURE'},
  {maker: maker, name: 'R 1200 GS'},
  {maker: maker, name: 'S 1000 XR'},
  {maker: maker, name: 'F 800 GS ADVENTURE'},
  {maker: maker, name: 'F 800 GS'},
  {maker: maker, name: 'F 700 GS'},
  {maker: maker, name: 'G 310 GS'},
  {maker: maker, name: 'C 650 Sport'},
  {maker: maker, name: 'C 650 GT'},
  {maker: maker, name: 'C EVOLUTION'},
]

model_list << models

maker = Maker.find_by(name: 'DUCATI')
models = [
  {maker: maker, name: 'Diavel'},
  {maker: maker, name: 'Diavel Carbon'},
  {maker: maker, name: 'XDiavelS'},
  {maker: maker, name: 'XDiavel'},
  {maker: maker, name: 'Hypermotard 939'},
  {maker: maker, name: 'Hyperstrada 939'},
  {maker: maker, name: 'Monster 821 Dark'},
  {maker: maker, name: 'Monster 821'},
  {maker: maker, name: 'Monster 1200'},
  {maker: maker, name: 'Multistrada 1200'},
  {maker: maker, name: 'Multistrada 1200 S'},
  {maker: maker, name: 'Multistrada 1200 Enduro'},
  {maker: maker, name: '959 Panigale'},
  {maker: maker, name: 'Panigale R'},
  {maker: maker, name: 'SCRAMBLER ICON'},
  {maker: maker, name: 'SCRAMBLER URBAN ENDURO'},
  {maker: maker, name: 'SCRAMBLER CLASSIC'},
  {maker: maker, name: 'SCRAMBLER FULL THROTTLE'},
  {maker: maker, name: 'SCRAMBLER Sixty2'},
]

model_list << models

maker = Maker.find_by(name: 'APRILIA')
models = [
  {maker: maker, name: 'RSV4 RF'},
  {maker: maker, name: 'RSV4 RR RACE PACK'},
]

model_list << models

maker = Maker.find_by(name: 'HARLEY-DAVIDSON')
models = [
  {maker: maker, name: 'HARLEY-DAVIDSON STREET 500'},
  {maker: maker, name: 'STREET ROD'},
  {maker: maker, name: 'SUPERLOW'},
  {maker: maker, name: 'IRON 883'},
  {maker: maker, name: '1200 CUSTOM'},
  {maker: maker, name: 'FORTY-EIGHT'},
  {maker: maker, name: 'ROADSTER'},
  {maker: maker, name: 'STREET BOB'},
  {maker: maker, name: 'LOW RIDER'},
  {maker: maker, name: 'LOW RIDER S'},
  {maker: maker, name: 'FAT BOB'},
  {maker: maker, name: 'FAT BOY'},
  {maker: maker, name: 'FAT BOY S'},
  {maker: maker, name: 'FAT BOY SPECIAL'},
  {maker: maker, name: 'SOFTAIL DELUXE'},
  {maker: maker, name: 'HERITAGE SOFTAIL CLASSIC'},
  {maker: maker, name: 'SOFTAIL SLIM'},
  {maker: maker, name: 'SOFTAIL SLIM S'},
  {maker: maker, name: 'BREAKOUT'},
  {maker: maker, name: 'NIGHT ROD SPECIAL'},
  {maker: maker, name: 'V-ROD MUSCLE'},
  {maker: maker, name: 'ROAD KING'},
  {maker: maker, name: 'ROAD KING SPECIAL'},
  {maker: maker, name: 'STREET GLIDE SPECIAL'},
  {maker: maker, name: 'ROAD GLIDE ULTRA'},
  {maker: maker, name: 'ROAD GLIDE SPECIAL'},
  {maker: maker, name: 'ULTRA LIMITED'},
  {maker: maker, name: 'ULTRA LIMITED LOW'},
  {maker: maker, name: 'LOW RIDER S'},
  {maker: maker, name: 'SOFTAIL SLIM S'},
  {maker: maker, name: 'FAT BOY S'},
  {maker: maker, name: 'CVO PRO STREET BREAKOUT'},
  {maker: maker, name: 'CVO STREET GLIDE'},
  {maker: maker, name: 'CVO LIMITED'},
  {maker: maker, name: 'FREEWHEELER'},
  {maker: maker, name: 'TRI GLIDE ULTRA'},
]

model_list << models

maker = Maker.find_by(name: 'PIAGGIO')
models = [
  {maker: maker, name: 'LIBERTY ABS'},
  {maker: maker, name: 'MEDLEY ABS'},
  {maker: maker, name: 'BEVELEY'},
  {maker: maker, name: 'MP3 YOURBAN'},
]

model_list << models

maker = Maker.find_by(name: 'VESPA')
models = [
  {maker: maker, name: 'Vespa LX'},
  {maker: maker, name: 'Vespa S'},
  {maker: maker, name: 'Vespa Primavera 150 3V i.e.'},
  {maker: maker, name: 'Vespa Sprint 150 3V i.e'},
  {maker: maker, name: 'Vespa GTS Super 150 3V i.e'},
  {maker: maker, name: 'Vespa 946'},
]

model_list << models
model_list.flatten
 
BikeModel.create(model_list)


# ========== Answer Choice ==========
default_group = AnswerChoiceGroup.find_by(name: 'Default')
AnswerChoice.create(
  [
    # positive
    {export_id: 'S2_1', choice: 'Pelayanan baik/ramah', positive: true, answer_choice_group: default_group},
    {export_id: 'S2_2', choice: 'Pelayanan cepat', positive: true, answer_choice_group: default_group},
    {export_id: 'S2_3', choice: 'Tempat yang rapih', positive: true, answer_choice_group: default_group},
    {export_id: 'S2_4', choice: 'Tempat tunggu nyaman', positive: true, answer_choice_group: default_group},
    {export_id: 'S2_5', choice: 'Kualitas servis baik', positive: true, answer_choice_group: default_group},
    {export_id: 'S2_6', choice: 'Murah', positive: true, answer_choice_group: default_group},
    {export_id: 'S2_7', choice: 'Pelayanan lebih', positive: true, answer_choice_group: default_group},
    # negative
    {export_id: 'S3_1', choice: 'Tidak ramah', positive: false, answer_choice_group: default_group},
    {export_id: 'S3_2', choice: 'Pelayanan yang lama ', positive: false, answer_choice_group: default_group},
    {export_id: 'S3_3', choice: 'Tempat Tidak rapih', positive: false, answer_choice_group: default_group},
    {export_id: 'S3_4', choice: 'Tempat tunggu tidak nyaman', positive: false, answer_choice_group: default_group},
    {export_id: 'S3_5', choice: 'Kualitas teknik rendah', positive: false, answer_choice_group: default_group},
    {export_id: 'S3_6', choice: 'Mahal', positive: false, answer_choice_group: default_group},
    {export_id: 'S3_7', choice: 'Tidak Jujur', positive: false, answer_choice_group: default_group},
    {export_id: 'S3_8', choice: 'Pekerjaan kasar motor rusak', positive: false, answer_choice_group: default_group},
    {export_id: 'S3_9', choice: 'Lainnya', positive: false, answer_choice_group: default_group},
  ]
)

# Devmotor
Shop.where(bengkel_id: ['100001', '100002', '100003']).each do |shop|
  config = ShopConfig.find_by(shop: shop)
  config.use_receipt = true
  config.receipt_layout = 'cut_portrait'
  config.save
end

# Scooter Jam
Shop.where(bengkel_id: ['100244', '100312']).each do |shop|
  config = ShopConfig.find_by(shop: shop)
  config.front_priority_display = 'phone_number'
  config.use_receipt = true
  config.receipt_layout = 'A4_portrait'
  config.save
end
# Sumber Jaya Moter
Shop.where(bengkel_id: ['100240']).each do |shop|
  config = ShopConfig.find_by(shop: shop)
  config.use_receipt = true
  config.receipt_layout = 'cut_portrait'
  config.save
end
# ARYA Mandiri Motor
Shop.where(bengkel_id: ['100223']).each do |shop|
  config = ShopConfig.find_by(shop: shop)
  config.use_receipt = true
  config.receipt_layout = 'cut_portrait'
  config.save
end

# ========== Shop Visiting Reason ==========
reasons = VisitingReason.all
Shop.all.each do |shop|
  reasons.each do |reason|
    ShopVisitingReason.create(
      shop: shop,
      visiting_reason: reason,
      display: 1,
      order: reason.id
    )
  end
end

# ========== Shop Payment Method ==========
payment_method_cash = PaymentMethod.find_by(name: 'Cash')
payment_method_card = PaymentMethod.find_by(name: 'Credit/Debit')
payment_method_other = PaymentMethod.find_by(name: 'Other')
Shop.all.each do |shop|
  ShopAvailablePaymentMethod.create(shop: shop, payment_method: payment_method_cash)
  ShopAvailablePaymentMethod.create(shop: shop, payment_method: payment_method_card)
  ShopAvailablePaymentMethod.create(shop: shop, payment_method: payment_method_other)
end
