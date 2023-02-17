class CreateVisitingReasons < ActiveRecord::Migration[5.2]
  def change
    create_table :visiting_reasons, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci" do |t|
      t.string :name, limit: 255, null: false
      t.timestamps
    end

    # ========== Shop Config ==========
    ['Tidak lihat apa2','dari Bengkel ada berita WA/SMS','Facebook','kolom iklan','Instagram','Bengkel ini langganan saya','Dikenalkan'].each do |txt|
      VisitingReason.create(name: txt)
    end
  end
end
