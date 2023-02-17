Biz OTORAJA
-----

# 開発環境
## 事前準備
以下をインストールすること
- Docker
- AWS CLI

## コンテナ起動
```sh
docker-compose build
docker-compose up -d
```

## ブラウザアクセス
### Front/Shop Management Console
http://localhost/users/sign_in

### Opts Management Console
http://localhost/console/sign_in

## 初期設定

```sh
docker-compose exec app yarn
docker-compose exec app bundle exec rails db:migrate
```

### 一括実行
下記のデータ投入や上記の初期設定を１つのコマンドで実行する
```sh
docker-compose exec app /bin/bash -c ./initial_settup.sh
```

## データ投入
- seedには環境に依存せず不変なマスタ系のデータのみ設定する。
- テストユーザーを登録する場合は、以下のtaskを実行する。

```sh
# マスタデータ登録
docker-compose exec app bundle exec rails db:seed
# ログインユーザー登録
docker-compose exec app bundle exec rails r lib/tasks/user_create.rb demo_user_20200702.json
# 商品マスタ登録
docker-compose exec app bundle exec rails r lib/tasks/temporary/import_product_master_20190927.rb
```
S3 > otoraja-biz-datastore > User_create 配下にjsonファイルを配置する

```json:demo_user_20200702.json
{
  "accounts": [
    {
      "name": "AdminUser",
      "user_id": "dev-admin",
      "status": "enabled",
      "role": "admin",
      "password": "password",
      "available_shops": []
    },
    {
      "name": "AdminOperatorUser",
      "user_id": "dev-operator",
      "status": "enabled",
      "role": "admin_operator",
      "password": "password",
      "available_shops": []
    },
    {
      "name": "DevMotorOwner",
      "user_id": "dev-owner",
      "status": "enabled",
      "role": "owner",
      "password": "password",
      "available_shops": ["100001"]
    },
    {
      "name": "DevMotorManager",
      "user_id": "dev-manager",
      "status": "enabled",
      "role": "manager",
      "password": "password",
      "available_shops": ["100001"]
    },
    {
      "name": "DevMotorMSOwner",
      "user_id": "dev-ms-owner",
      "status": "enabled",
      "role": "owner",
      "password": "password",
      "available_shops": ["100002","100003"]
    },
    {
      "name": "DevMotorMSManager",
      "user_id": "dev-ms-manager",
      "status": "enabled",
      "role": "shop_manager",
      "password": "password",
      "available_shops": ["100002"]
    },
    {
      "name": "DevMotorMSManager2",
      "user_id": "dev-ms-manager2",
      "status": "enabled",
      "role": "shop_manager",
      "password": "password",
      "available_shops": ["100003"]
    },
    {
      "name": "DevMotorMSStaff",
      "user_id": "dev-ms-staff",
      "status": "enabled",
      "role": "staff",
      "password": "password",
      "available_shops": ["100002"]
    },
    {
      "name": "DevMotorMSStaff2",
      "user_id": "dev-ms-staff2",
      "status": "enabled",
      "role": "staff",
      "password": "password",
      "available_shops": ["100003"]
    },
    {
      "name": "Bengkel Yo Matic Staff",
      "user_id": "B207-stf",
      "status": "enabled",
      "role": "staff",
      "password": "stfB207",
      "available_shops": [
        "100207"
      ]
    },
    {
      "name": "Bengkel Yo Matic Manager",
      "user_id": "B207-mgr",
      "status": "enabled",
      "role": "manager",
      "password": "B207mgr",
      "available_shops": [
        "100207"
      ]
    },
    {
      "name": "Scooter Jam (Tangerang) Staff",
      "user_id": "B312-stf",
      "status": "enabled",
      "role": "staff",
      "password": "stfB312",
      "available_shops": [
        "100312"
      ]
    },
    {
      "name": "Scooter Jam (Tangerang) Manager",
      "user_id": "B312-mgr",
      "status": "enabled",
      "role": "manager",
      "password": "B312mgr",
      "available_shops": [
        "100312"
      ]
    },
    {
      "name": "Rizzky Motor Staff",
      "user_id": "B156-stf",
      "status": "enabled",
      "role": "staff",
      "password": "stfB156",
      "available_shops": [
        "100156"
      ]
    },
    {
      "name": "Rizzky Motor Manager",
      "user_id": "B156-mgr",
      "status": "enabled",
      "role": "manager",
      "password": "B156mgr",
      "available_shops": [
        "100156"
      ]
    },
    {
      "name": "Arya Mandiri Motor Staff",
      "user_id": "B223-stf",
      "status": "enabled",
      "role": "staff",
      "password": "stfB223",
      "available_shops": [
        "100223"
      ]
    },
    {
      "name": "Arya Mandiri Motor Manager",
      "user_id": "B223-mgr",
      "status": "enabled",
      "role": "manager",
      "password": "B223mgr",
      "available_shops": [
        "100223"
      ]
    },
    {
      "name": "Sumber Jaya Motor Staff",
      "user_id": "B240-stf",
      "status": "enabled",
      "role": "staff",
      "password": "stfB240",
      "available_shops": [
        "100240"
      ]
    },
    {
      "name": "Sumber Jaya Motor Manager",
      "user_id": "B240-mgr",
      "status": "enabled",
      "role": "manager",
      "password": "B240mgr",
      "available_shops": [
        "100240"
      ]
    },
    {
      "name": "Scooter Jam Staff",
      "user_id": "B244-stf",
      "status": "enabled",
      "role": "staff",
      "password": "stfB244",
      "available_shops": [
        "100244"
      ]
    },
    {
      "name": "Scooter Jam Manager",
      "user_id": "B244-mgr",
      "status": "enabled",
      "role": "manager",
      "password": "B244mgr",
      "available_shops": [
        "100244"
      ]
    }
  ],
  "staffs": [
    {
      "shop": "100001",
      "list":[
        {
          "name": "[B001]FrontStaff A",
          "is_front_staff": true,
          "is_mechanic": false,
          "active": true
        },
        {
          "name": "[B001]FrontStaff B Mechanic",
          "is_front_staff": true,
          "is_mechanic": true,
          "mechanic_grade": 5,
          "active": true
        },
        {
          "name": "[B001]FrontStaff C Deactive",
          "is_front_staff": true,
          "is_mechanic": false,
          "active": false
        },
        {
          "name": "[B001]SeniorMechanic A",
          "is_front_staff": false,
          "is_mechanic": true,
          "mechanic_grade": 10,
          "active": true
        },
        {
          "name": "[B001]Mechanic B",
          "is_front_staff": false,
          "is_mechanic": true,
          "mechanic_grade": 5,
          "active": true
        },
        {
          "name": "[B001]Mechanic C Deactive",
          "is_front_staff": false,
          "is_mechanic": true,
          "mechanic_grade": 5,
          "active": false
        }
      ]
    },
    {
      "shop": "100002",
      "list":[
        {
          "name": "[B002]FrontStaff A",
          "is_front_staff": true,
          "is_mechanic": false,
          "active": true
        },
        {
          "name": "[B002]FrontStaff B Mechanic",
          "is_front_staff": true,
          "is_mechanic": true,
          "mechanic_grade": 5,
          "active": true
        },
        {
          "name": "[B002]FrontStaff C Deactive",
          "is_front_staff": true,
          "is_mechanic": false,
          "active": false
        },
        {
          "name": "[B002]SeniorMechanic A",
          "is_front_staff": false,
          "is_mechanic": true,
          "mechanic_grade": 10,
          "active": true
        },
        {
          "name": "[B002]Mechanic B",
          "is_front_staff": false,
          "is_mechanic": true,
          "mechanic_grade": 5,
          "active": true
        },
        {
          "name": "[B002]Mechanic C Deactive",
          "is_front_staff": false,
          "is_mechanic": true,
          "mechanic_grade": 5,
          "active": false
        }
      ]
    },
    {
      "shop": "100003",
      "list":[
        {
          "name": "[B003]FrontStaff A",
          "is_front_staff": true,
          "is_mechanic": false,
          "active": true
        },
        {
          "name": "[B003]FrontStaff B Mechanic",
          "is_front_staff": true,
          "is_mechanic": true,
          "mechanic_grade": 5,
          "active": true
        },
        {
          "name": "[B003]FrontStaff C Deactive",
          "is_front_staff": true,
          "is_mechanic": false,
          "active": false
        },
        {
          "name": "[B003]SeniorMechanic A",
          "is_front_staff": false,
          "is_mechanic": true,
          "mechanic_grade": 10,
          "active": true
        },
        {
          "name": "[B003]Mechanic B",
          "is_front_staff": false,
          "is_mechanic": true,
          "mechanic_grade": 5,
          "active": true
        },
        {
          "name": "[B003]Mechanic C Deactive",
          "is_front_staff": false,
          "is_mechanic": true,
          "mechanic_grade": 5,
          "active": false
        }
      ]
    },
    {
      "shop": "100156",
      "list":[
        {
          "name": "[B156]FrontStaff A",
          "is_front_staff": true,
          "is_mechanic": false,
          "active": true
        },
        {
          "name": "[B156]FrontStaff B Mechanic",
          "is_front_staff": true,
          "is_mechanic": true,
          "mechanic_grade": 5,
          "active": true
        },
        {
          "name": "[B156]FrontStaff C Deactive",
          "is_front_staff": true,
          "is_mechanic": false,
          "active": false
        },
        {
          "name": "[B156]SeniorMechanic A",
          "is_front_staff": false,
          "is_mechanic": true,
          "mechanic_grade": 10,
          "active": true
        },
        {
          "name": "[B156]Mechanic B",
          "is_front_staff": false,
          "is_mechanic": true,
          "mechanic_grade": 5,
          "active": true
        },
        {
          "name": "[B156]Mechanic C Deactive",
          "is_front_staff": false,
          "is_mechanic": true,
          "mechanic_grade": 5,
          "active": false
        }
      ]
    },
    {
      "shop": "100207",
      "list": [
        {
          "name": "[B207]FrontStaff",
          "is_front_staff": true,
          "is_mechanic": false,
          "active": true
        },
        {
          "name": "[B207]Mechanic",
          "is_front_staff": false,
          "is_mechanic": true,
          "mechanic_grade": 5,
          "active": true
        }
      ]
    },
    {
      "shop": "100312",
      "list": [
        {
          "name": "[B312]FrontStaff",
          "is_front_staff": true,
          "is_mechanic": false,
          "active": true
        },
        {
          "name": "[B312]Mechanic",
          "is_front_staff": false,
          "is_mechanic": true,
          "mechanic_grade": 5,
          "active": true
        }
      ]
    },
    {
      "shop": "100223",
      "list": [
        {
          "name": "[B223]FrontStaff",
          "is_front_staff": true,
          "is_mechanic": false,
          "active": true
        },
        {
          "name": "[B223]Mechanic",
          "is_front_staff": false,
          "is_mechanic": true,
          "mechanic_grade": 5,
          "active": true
        }
      ]
    },
    {
      "shop": "100240",
      "list": [
        {
          "name": "[B240]FrontStaff",
          "is_front_staff": true,
          "is_mechanic": false,
          "active": true
        },
        {
          "name": "[B240]Mechanic",
          "is_front_staff": false,
          "is_mechanic": true,
          "mechanic_grade": 5,
          "active": true
        }
      ]
    },
    {
      "shop": "100244",
      "list": [
        {
          "name": "[B244]FrontStaff",
          "is_front_staff": true,
          "is_mechanic": false,
          "active": true
        },
        {
          "name": "[B244]Mechanic",
          "is_front_staff": false,
          "is_mechanic": true,
          "mechanic_grade": 5,
          "active": true
        }
      ]
    }
  ]
}
```

## チェックインサジェストデータ作成
- 顧客情報をElasticsearchへ投入する
```sh
docker-compose exec app bundle exec rails r lib/tasks/create_checkin_suggest.rb
```

- INDEXを再作成し、顧客情報をElasticsearchへ投入する
```sh
docker-compose exec app bundle exec rails r lib/tasks/create_checkin_suggest.rb create_index
```

## 店舗商品サジェストデータ作成
- 店舗商品をElasticsearchへ投入する
```sh
docker-compose exec app bundle exec rails r lib/tasks/create_shop_product_suggest.rb
```
店舗ごとの更新は管理画面で更新後に実行している。

- INDEXを再作成し、店舗商品をElasticsearchへ投入する
```sh
docker-compose exec app bundle exec rake update_shop_product_suggest:all create_index
```

### Kibanaで確認
http://localhost:5601/

## docker-sync (Optional)
なんだか最近、docker起動してからファイル更新するたびに動作が遅くなると感じたあなたに`docker-sync`のご紹介です。

### docker-sync準備
```sh
gem install docker-sync
brew install fswatch
brew install unison
```
- シンクライアントの場合、管理者ユーザーでインストールしてください。
- [brew](https://brew.sh/index_ja)は事前にインストールしておいてください。
```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### docker-syncを使用した開発環境の起動
```sh
docker-sync-daemon start
docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d
```

### docker-syncを使用した開発環境の停止
```sh
docker-compose stop
docker-sync-daemon stop
```

### docker-syncを起動するコマンドを１つにまとめました
```sh
# 起動
./dev.sh start
# 起動 initial_settup.sh実行しない
./dev.sh start --with-out-init
# 停止
./dev.sh stop
```

## アプリケーションログの確認

アプリケーションのログはコンテナ上に出力しているため、コンテナ内のファイルを参照する。  
```sh
docker-compose exec app tail -f log/development.log
```

# AWS
## ステージング環境
### 起動
```sh
# RDS
aws rds start-db-cluster --db-cluster-identifier otoraja-biz-staging --region ap-southeast-1

# ECS
aws ecs update-service --cluster otoraja-biz-staging --service otoraja-biz-online --desired-count 1 --region ap-southeast-1
aws ecs update-service --cluster otoraja-biz-staging --service otoraja-biz-host --desired-count 1 --region ap-southeast-1
```
### 停止
```sh
# RDS
aws rds stop-db-cluster --db-cluster-identifier otoraja-biz-staging --region ap-southeast-1

# ECS
aws ecs update-service --cluster otoraja-biz-staging --service otoraja-biz-online --desired-count 0  --region ap-southeast-1
aws ecs update-service --cluster otoraja-biz-staging --service otoraja-biz-host --desired-count 0  --region ap-southeast-1
```
### リリースノート配置
```sh
aws s3 cp public/release_note.html s3://otoraja-biz-staging-assets-sg
```
## 本番環境
### 起動
```sh
# RDS
aws rds start-db-cluster --db-cluster-identifier otoraja-biz-production

# ECS
aws ecs update-service --cluster otoraja-biz-production --service otoraja-biz-online --desired-count 2
aws ecs update-service --cluster otoraja-biz-production --service otoraja-biz-host --desired-count 1
```
### 停止
```sh
# RDS
aws rds start-db-cluster --db-cluster-identifier otoraja-biz-staging

# ECS
aws ecs update-service --cluster otoraja-biz-production --service otoraja-biz-online --desired-count 0
aws ecs update-service --cluster otoraja-biz-production --service otoraja-biz-host --desired-count 0
```

### リリースノート配置
```sh
aws s3 cp public/release_note.html s3://otoraja-biz-assets
aws s3 cp public/release_note.html s3://otoraja-biz-assets-sg
```

1. Install debug extension https://marketplace.visualstudio.com/items?itemName=rebornix.Ruby 

# MFAログイン
## 利用方法

### 事前準備
***Google Play Store*** から ***Google Authenticator*** アプリをインストールする事

#### 初ログイン流れ
  1. ***Role*** の ***Admin*** を持ったユーザーでログインする
  2. ***Google Authenticator*** アプリ上で ***+*** または ***開始*** ボタンを押す
  3. ***バーコードをスキャン*** を選択する
  4. ウェブ上に表示されてるQRコードを読み込む
  5. アプリ上表示する ***OTP*** をウェブ上に入力する

#### 2回目から
上記***4***と***5***を行う事

# AWS VPC Client VPN
インドネシア開発チームが接続するClientVPNの証明書発行について  
参考URL  
https://docs.aws.amazon.com/ja_jp/vpn/latest/clientvpn-admin/cvpn-getting-started.html  
https://qiita.com/tomozo6/items/92382f57b747d325352b  
https://dev.classmethod.jp/articles/vpc-client-vpn/  

## Client VPNについて
AWS VPC Client VPNを使用して、VPCへVPN接続し、そのVPCのNATGatewayからインターネットへ接続する。固定グローバルIPとしているため、OTORAJAのVPCで個別でアクセス許可する。

## クライアント証明書発行手順
0. インドネシア開発チームから証明書発行の依頼を受ける。  
Teams上の管理台帳に記載し依頼してもらう。
1. シンガポールリージョンの EC2 **otoraja-biz-create-client-key** へsshで接続。  
    * 踏み台サーバー(otoraja-gateway)経由でsshで接続する
    * 普段はインスタンスを停止しているため、予め起動しておく。
2. 証明書発行  
ユーザー名のプレフィックスに **otoraja.[idn or jpn].** をつける。  
日本のotomoの場合  
**otoraja.jpn.otomo**
```
$ cd easy-rsa/easyrsa3/
$ CLIENTNAME=otoraja.#使用ユーザー名#
$ ./easyrsa build-client-full ${CLIENTNAME} nopass
$ cp pki/issued/${CLIENTNAME}.crt ~/ssl/
$ cp pki/private/${CLIENTNAME}.key ~/ssl/
```
3. SCPまたはSFTPで証明書とプライベートキーを取得する。
4. 暗号化zipにし、Teams上に配置し、DMで本人へzipのパスワードを連絡する。
