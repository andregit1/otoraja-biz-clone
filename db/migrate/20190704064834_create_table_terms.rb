class CreateTableTerms < ActiveRecord::Migration[5.2]
  def change
    create_table :terms, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.text :terms, null:false
      t.datetime :effective_date, null:false
      t.timestamps
    end
    # ========== Terms ==========
    Term.create(
      terms:
    '
    <ol>
    <li>Apa yang ingin kami lakukan sebagai proyek kami.<br>
      Kami ( PT. Marketing Sentratama Indonesia , Cleat Inc., dan PT. Parimitra Abadi Internasional) ingin
      mengadakan percobaan dalam skala kecil (pilot-scale) dengan menyediakan layanan platform dan/atau
      aplikasi mobile (“Layanan”) yang diharapkan akan memperbaiki kegiatan Bengkel. Untuk menerima Layanan,
      kami meminta Anda untuk mengikuti petunjuk-petunjuk dari kami mengenai Layanan dan menyediakan informasi
      yang berhubungan dengan Layanan yang ditawarkan. Data yang kami kumpulkan dari Anda dapat meliputi juga
      data pribadi Anda dan oleh karenanya kami berharap Anda dapat menyetujui hal-hal berikut sebelum Anda
      menyediakan informasi Anda kepada kami.</li>
    <li>Apa itu Data Pribadi dan tujuan penggunaan Data Pribadi Anda <br>
      Kami akan mengumpulkan data pribadi (“Data Pribadi”) dan akan menggunakan Data Pribadi tersebut untuk
      tujuan-tujuan berikut (“Tujuan”): <br>
      Data Pribadi yang akan dikumpulkan: nama Anda, nomor telepon, alamat surel (e-mail) Anda, tanggal lahir
      Anda, nama perusahaan Anda, sejarah kedatangan Anda ke Bengkel, catatan penggunaan Layanan (informasi
      dalam cookies, daftar operasional, dan lainnya), informasi tentang sepeda motor yang Anda miliki (nama
      model, kode model, nomor seri, nomor pendaftaran dan masa berlakunya, jumlah jarak yang ditempuh, dan
      lain sebagainya), catatan perawatan sepeda motor Anda (tanggal dan jam perawatan, kategori/hal
      perawatan, suku cadang yang dipergunakan untuk perawatan, jumlah pembayaran, dan lain sebagainya) dan
      rincian lain yang dapat mengidentifikasikan seseorang. <br>
      Tujuan penggunaan Data Pribadi Anda:
      <ul>
        <li>Untuk menyediakan Layanan.</li>
        <li>Untuk memberikan tanggapan terhadap pertanyaan-pertanyaan terkait dengan Layanan. </li>
        <li>Untuk memberikan notifikasi kepada pengguna-pengguna mengenai Layanan. </li>
        <li>Untuk menyediakan Layanan dengan aman. Hal ini termasuk mencari tahu pengguna-pengguna yang
          melanggar ketentuan penggunaan ini dan memberitahu pengguna-pengguna tersebut, melakukan
          investigasi, mendeteksi atau melakukan pencegahan perbuatan yang tidak sesuai seperti penipuan atau
          akses tanpa izin yang menyalahgunakan Layanan, dan lain sebagainya, serta mengambil tindakan
          terhadap pengguna tersebut.</li>
        <li>Untuk memperbaiki Layanan dan sebagai bahan pertimbangan penambahan fungsi-fungsi baru Layanan.
        </li>
        <li>Untuk menganalisis situasi penggunaan Layanan. </li>
        <li>Untuk melakukan analisis lanjutan setelah data termasuk Data Pribadi diproses secara statistik.
        </li>
        <li>Riset pasar, perolehan pengetahuan, dan kepentingan analisis lainnya guna meningkatkan kualitas
          dan mengembangkan produk.</li>
        <li>Tujuan-tujuan penggunaan lainnya yang disebutkan secara jelas pada saat Data Pribadi diperoleh.
        </li>
      </ul>
    </li>
    <li>Kami akan membagikan Data Pribadi yang kami peroleh dari Anda kepada Bengkel dimana Anda akan
      memperoleh pelayanan, afiliasi, subkontraktor, dan kepada pihak ketiga lainnya sepanjang diperlukan
      untuk menyediakan Layanan untuk Tujuan di atas. Data Pribadi Anda tidak akan ditawarkan atau diungkapkan
      ke pihak ketiga manapun tanpa persetujuan terlebih dahulu dari Anda, kecuali dalam kondisi-kondisi yang
      disebutkan di bawah ini:
      <ol style="list-style-type: upper-roman">
        <li>Saat Anda menyetujui penawaran atau pengungkapan Data Pribadi Anda. </li>
        <li>Kondisi-kondisi di mana penanganan Data Pribadi dilakukan berdasarkan ketentuan peraturan
          perundang-undangan.</li>
      </ol>
    <li>Data Pribadi akan disimpan sesuai dengan jangka waktu pemberian Layanan dan untuk jangka waktu
      tertentu yang diperlukan untuk memenuhi persyaratan ketentuan peraturan perundang-undangan yang berlaku.
    </li>
    <li>Anda memberikan persetujuan secara sukarela dan persetujuan tersebut dapat ditarik kembali kapanpun
      juga. Jika anda menarik kembali persetujuan Anda untuk menggunakan Data Pribadi yang telah Anda berikan
      kepada kami melalui Layanan, maka kami akan berusaha untuk menghapus data tersebut dari basis data kami.
      Namun, meskipun Anda telah menarik kembali persetujuan Anda, hal tersebut tidak akan mempengaruhi
      keabsahan penggunaan Data Pribadi Anda sebelum persetujuan tersebut ditarik kembali. Anda dapat menarik
      kembali persetujuan Anda melalui surel (e-mail) ke alamat di bawah ini. </li>
    <li>Kami tidak akan melakukan apapun yang akan menimbulkan akibat hukum atau akibat signifikan yang
      serupa kepada Anda atas dasar pemrosesan otomatis, termasuk profiling tanpa mendapatkan persetujuan
      eksplisit dari Anda. </li>
    <li>Keputusan untuk menyediakan Data Pribadi Anda melalui Layanan bergantung kepada Anda. </li>
    <li>Anda memiliki hak-hak tertentu sehubungan dengan pemrosesan Data Pribadi Anda yang kami lakukan.
      Anda dapat:
      <ul>
        <li>meminta akses ke Data Pribadi Anda melalui kami.</li>
        <li>meminta kami untuk memperbaiki atau melengkapi informasi Anda jika Anda percaya bahwa Data
          Pribadi yang kami proses tentang Anda tidak akurat atau belum lengkap.</li>
        <li>meminta kami untuk menghapus Data Pribadi tertentu.</li>
        <li>meminta kami untuk membatasi pemrosesan Data Pribadi Anda.</li>
        <li>menolak pemrosesan Data Pribadi Anda yang kami lakukan.</li>
      </ul>
      Namun, kami mungkin tidak dapat memenuhi permohonan-permohonan Anda di atas apabila kami harus memenuhi
      suatu kewajiban hukum yang mewajibkan pemrosesan Data Pribadi atas dasar ketentuan peraturan
      perundang-undangan yang berlaku. <br>
      Apabila terdapat pertanyaan atau keluhan mengenai pemrosesan Data Pribadi Anda, harap menghubungi
      divisi/nama di bawah ini secara tertulis:<br>
      Nama perusahaan yang melakukan percobaan: Cleat Inc.<br>
      Alamat surel (e-mail): otoraja@cleat.jp<br>
    </li>
    <li>Apabila Data Pribadi Anda berubah atau apabila kami memiliki informasi yang tidak akurat, kami akan
      berusaha untuk memperbaiki, memperbaharui, atau menghapus Data Pribadi Anda dari basis data kami.
      Apabila Anda tidak ingin kami hubungi lebih lanjut, kami akan segera menghentikan pemrosesan Data
      Pribadi Anda. Pada saat Anda menghubungi kami, mohon pastikan bahwa Anda memberitahukan kami nama
      lengkap, alamat, alamat surel (e-mail) dan/atau nomor(-nomor) telepon Anda agar kami dapat menangani
      permohonan Anda dengan benar. </li>
    </ol>
    ',
      effective_date: DateTime.new(2019, 7, 1)
    )

  end
end
