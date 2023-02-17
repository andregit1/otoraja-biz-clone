module Aws
  class AwsUtility
    def self.config
      YAML::load(ERB.new(IO.read("#{Rails.root}/config/aws.yml")).result)[Rails.env]
    end

    def self.S3_client(config = self.config)
      Aws::S3::Client.new(
        region: config['region'],
        access_key_id: config['access_key_id'],
        secret_access_key: config['secret_access_key']
      )
    end

    def self.SNS_client(config = self.config)
      Aws::SNS::Client.new(
        region: config['region'],
        access_key_id: config['access_key_id'],
        secret_access_key: config['secret_access_key']
      )
    end

    def self.CloudWatchLogs_client(config = self.config)
      Aws::CloudWatchLogs::Client.new(
        region: config['region'],
        access_key_id: config['access_key_id'],
        secret_access_key: config['secret_access_key']
      )
    end

    def self.STS_client(config = self.config)
      Aws::STS::Client.new(
        region: config['region'],
        access_key_id: config['access_key_id'],
        secret_access_key: config['secret_access_key']
      )
    end

    def self.CognitoIdentityProvider_client(config = self.config)
      Aws::CognitoIdentityProvider::Client.new(
        region: config['cognito_setting']['region'],
        access_key_id: config['access_key_id'],
        secret_access_key: config['secret_access_key']
      )
    end

    def self.DynamoDB_client(config = self.config)
      Aws::DynamoDB::Client.new(
        region: config['dynamodb_setting']['region'],
        access_key_id: config['access_key_id'],
        secret_access_key: config['secret_access_key']
      )
    end
  end
end
