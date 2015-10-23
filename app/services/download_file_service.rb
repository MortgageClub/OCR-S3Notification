require 'securerandom'

class DownloadFileService
  PATH = "#{Rails.root}/documents/"

  def self.call(raw_post)
    s3 = Aws::S3::Client.new
    message = JSON.parse(raw_post["Message"])
    record = message["Records"].first
    bucket_name = record["s3"]["bucket"]["name"]
    key = record["s3"]["object"]["key"]
    extension = File.extname(key)
    file_name = PATH << random_name << extension

    File.open(file_name, 'wb') do |file|
      response = s3.get_object({ bucket: bucket_name, key: key }, target: file)
    end
  end

  def self.random_name
    SecureRandom.hex(8)
  end
end
