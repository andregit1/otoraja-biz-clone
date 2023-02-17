class SeedSearchTagAndShopSearchTag < ActiveRecord::Migration[5.2]
  def change
    SearchTag.create([
      {tag: "OLI"},
      {tag: "REM"},
      {tag: "AKI"},
      {tag: "BAN"},
      {tag: "BELT"},
      {tag: "JASA"},
      {tag: "HONDA"},
      {tag: "YAMAHA"},
      {tag: "SUZUKI"},
      {tag: "VESPA"},
      {tag: "BUSI"},
      {tag: "KABEL"},
      {tag: "TROMOL"},
      {tag: "LAMPU"},
      {tag: "RANTAI"},
      {tag: "GIGI"},
      {tag: "FILTER"},
      {tag: "CLEANER"},
      {tag: "SAKLAR"},
      {tag: "PER"},
    ])
  end
end
