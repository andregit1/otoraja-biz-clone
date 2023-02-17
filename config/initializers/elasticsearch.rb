config = {
  url:  ENV['ELASTICSEARCH_URL'] || "http://es:9200",
}

Elasticsearch::Model.client = Elasticsearch::Client.new(config)
