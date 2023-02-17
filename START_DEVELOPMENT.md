START DEVELOPMENT
-----
# AWS

## Request a new account
  Tell them the name of the account you are creating.   
  ex) account: testuser -> otoraja-testuser

## Receive the created account information
  Receive the console login password, access key, and secret key of the created AWS IAM User

## Login to the management console
  [Management Console](https://072739647532.signin.aws.amazon.com/console)  
  **Connect to a VPN to access.**  
  Be sure to change the password the first time.
  ### Password policy
  * Minimum password length is 12 characters
  * Requires at least 1 uppercase letter (A-Z)
  * Requires at least 1 lowercase letter (a-z)
  * Requires at least one number
  * Requires at least one non-alphanumeric character

## Set MFA
  https://docs.aws.amazon.com/IAM/latest/UserGuide/id_credentials_mfa_enable_virtual.html#enable-virt-mfa-for-iam-user

## Confirm that CodeCommit is displayed
  Please confirm that the [CodeCommit](https://ap-northeast-1.console.aws.amazon.com/codesuite/codecommit/repositories?region=ap-northeast-1) screen can be used on the AWS Console.

# Git

## Connection settings
  Set the connection using [SSH](https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-ssh-unixes.html) or [HTTPS](https://docs.aws.amazon.com/codecommit/latest/userguide/setting-up-https-unixes.html).

## Clone the repository
  ```sh
  $ git clone https://git-codecommit.ap-northeast-1.amazonaws.com/v1/repos/otoraja-biz
  ```

## Create a branch
  Create a branch from the latest `development` branch before you start development.

## Create a pull request
  When development is completed, push the created branch and create a `Pull Request`.  
  You can make a pull request from the management console.  
  Set the Destination to `development`.  
  **If there is a conflict, please resolve it. **

## Request a code review
  Please request a code review along with the Pull Request URL at Teams`02_dev`.  
  With the approval of someone from the Japanese development team, you can merge  

  ex) 
  ```
  @devteam
  Code review, please.
  [Summary of changes]
  [AzureBoard ID]
  https://ap-northeast-1.console.aws.amazon.com/codesuite/codecommit/repositories/otoraja-biz/pull-requests/99999/details?region=ap-northeast-1
  ```
  **Please note that WebHook cannot be used with the current Teams settings, so it will be operated manually. **

## Merge branch
  If you get the approval of the pull request, please do the merge.

|  |  |
|:-----|:-----|
| Merge strategy | 3-way merge |
| Commit message | (optional) |
| Author name | your name |
| Email address | your email |
| Delete source branch | on |

## Deploy to staging
On the AM of the product review day, the Japanese development team will do so.  
It is also performed in the adjustment before the production release.  
If you want to deploy on other days, please arrange your schedule in advance.

## Deploy to production
It will run on the Thursday of the week in which the product review occurs.  
At 8:00am (JST), the Japanese development team will do so.

## Notes
* Do not commit or push directly to branches of `master`, `staging` or `development`.
  * The change triggers a CodePipeline to run, causing Deploy to run unintentionally.
  * IAM Policy restricts it, but please be aware of it.

# Build Local
See otoraja-biz [README](README_en.md) for more information.

## Brief overview
1. docker-compose build
1. docker-compose up -d
1. docker-compose exec app /bin/bash -c ./initial_settup.sh
