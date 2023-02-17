Biz OTORAJA
-----

# Development Environment
## Prep.
Install the following
- Docker
- AWS CLI

## Container startup
```sh
docker-compose build
docker-compose up -d
```

## Browser Access
### Front/Shop Management Console
http://localhost/users/sign_in

### Opts Management Console
http://localhost/console/sign_in

## Initialization.

```sh
docker-compose exec app yarn
docker-compose exec app bundle exec rails db:migrate
```

### Batch execution.
Execute the following data input and initial settings above with one command
```sh
docker-compose exec app /bin/bash -c ./initial_settup.sh
```

## Test Data Input.
- Set only the master data that does not depend on the environment to the seed.
- To register a test user, perform the following task.

```sh
# Master Data Registration
docker-compose exec app bundle exec rails db:seed
# Login User Registration
docker-compose exec app bundle exec rails r lib/tasks/user_create.rb demo_user_20200702.json

# Product Master Registration
docker-compose exec app bundle exec rails r lib/tasks/temporary/import_product_master_20190927.rb
```

S3 > otoraja-biz-datastore > Put the json file under the User_create

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

## Check-in Suggest Data Creation.
- Feeding customer information into Elasticsearch
```sh
docker-compose exec app bundle exec rails r lib/tasks/create_checkin_suggest.rb
```

- Re-create INDEX and submit customer information to Elasticsearch
```sh
docker-compose exec app bundle exec rails r lib/tasks/create_checkin_suggest.rb create_index
```

## Store Product Suggestion Data Creation.
- Submitting store products to Elasticsearch
```sh
docker-compose exec app bundle exec rails r lib/tasks/create_shop_product_suggest.rb
```
The update for each store is performed after the update in the admin page.

- Re-create INDEX and submit store products to Elasticsearch
```sh
docker-compose exec app bundle exec rake update_shop_product_suggest:all create_index
```

### Check with Kibana.
http://localhost:5601/

## docker-sync (Optional)

### Preparing for docker-sync
```sh
gem install docker-sync
brew install fswatch
brew install unison
```
- You must install [brew](https://brew.sh/index_ja) beforehand.
```sh
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

### Starting the Development Environment with docker-sync
```sh
docker-sync-daemon start
docker-compose -f docker-compose.yml -f docker-compose-dev.yml up -d
```

### Stopping the development environment using docker-sync
```sh
docker-compose stop
docker-sync-daemon stop
```

### One command to invoke docker-sync
```sh
# Launch.
. /dev.sh start
# start initial_settup.sh do not execute
. /dev.sh start --with-out-init
# Stop.
. /dev.sh stop
```

## Checking the application log
Because the application log is on a container, it references a file in the container.  

```sh
docker-compose exec app tail -f log/development.log
```

# AWS
## Staging Environment.
### Release Note Deployment.
```sh
aws s3 cp public/release_note.html s3://otoraja-biz-staging-assets-sg
```
