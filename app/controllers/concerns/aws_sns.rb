module AwsSns
  extend ActiveSupport::Concern

  included do
    helper_method :send_sms
  end

  # SMSを送信する
  def send_sms(phone_number, message, sms_type='Transactional')
    client = Aws::AwsUtility.SNS_client
    resp = client.publish({
      phone_number: phone_number,
      message: message,
      message_attributes: {
        'AWS.SNS.SMS.SMSType' => {
          data_type: 'String',
          string_value: sms_type
        }
      }
    })
  end

end
