module Notifications
  module Mail
    def initialize(notification)
      @notification = notification
    end

    def self.send
      message_content = "From: #{Rails.configuration.netam.dig(:notification, :mail, :from)}\n"
      message_content += "MIME-Version: 1.0\n"
      message_content += "Content-Type: text/html\n"
      message_content += "Subject: [NetAM] Scan finished\n"
      message_body = "New scan finished on NetAM <br/>"
      message_body += "Section: #{@notification[:section][:network].to_s} (#{@notification[:section][:id]})<br/><br/>"

      auth_type = Rails.configuration.netam.dig(:notification, :mail, :type).present? ? Rails.configuration.netam.dig(:notification, :mail, :type).to_sym : nil
      Net::SMTP.start(
        Rails.configuration.netam.dig(:notification, :mail, :host),
        Rails.configuration.netam.dig(:notification, :mail, :port),
        Rails.configuration.netam.dig(:notification, :mail, :helo),
        Rails.configuration.netam.dig(:notification, :mail, :user),
        Rails.configuration.netam.dig(:notification, :mail, :pass),
        auth_type
      ) do |smtp|
        Rails.configuration.netam.dig(:notification, :mail, :to).each do |mail_to|
          message_content += "To: #{mail_to}\n"
          message = message_content + message_body
          begin
            smtp.send_message message, Rails.configuration.netam.dig(:notification, :mail, :from), mail_to
          rescue => e
            Rails.logger.error("Unable to send email with exception : #{e.message}")
          end
        end
      end
    end
  end
end
