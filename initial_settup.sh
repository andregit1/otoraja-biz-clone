#!/bin/bash
set -e

echo 'yarn install'
yarn install
echo 'migrate'
bundle exec rails db:migrate
echo 'seed'
bundle exec rails db:seed
echo 'import demo_user'
bundle exec rails r lib/tasks/user_create.rb demo_user_20200702.json
echo 'import demo_product'
bundle exec rails r lib/tasks/temporary/import_product_master_20190927.rb
echo 'create elasticsearch index Customer'
bundle exec rails r lib/tasks/create_checkin_suggest.rb create_index
echo 'create elasticsearch index ShopProduct'
bundle exec rake update_shop_product_suggest:all create_index=true
