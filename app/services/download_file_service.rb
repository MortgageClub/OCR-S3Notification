require 'securerandom'

class DownloadFileService
  DIRECTORY = "#{Rails.root}/documents/"
  XML_DIR = "#{Rails.root}/xml_files/"

  def self.call(raw_post = nil)
    p "received notification at #{Time.zone.now}"
    s3 = Aws::S3::Client.new
    message = JSON.parse(raw_post["Message"])
    record = message["Records"].first
    bucket_name = record["s3"]["bucket"]["name"]
    # first_paystubs/9ee9f4bf2ffbd5d32fd6dab8fb7c41cf/IMG_4757_need_a_home.jpg
    key = record["s3"]["object"]["key"]
    file_name = key.split("/").last
    path_to_file = DIRECTORY + file_name
    path_to_xml = XML_DIR + file_name
    File.delete(path_to_xml) if File.exist?(path_to_xml)

    File.open(path_to_file, "wb") do |file|
      response = s3.get_object({ bucket: bucket_name, key: key }, target: file)
    end

    end_at = Time.zone.now + 20.seconds
    while(!File.exist?(path_to_xml) && Time.zone.now < end_at) do
    end
    p "#{end_at}"
    p "#{Time.zone.now}"
    # UploadFileToS3Service.delay(run_at: 8.seconds.from_now).call(file_name)
    UploadFileToS3Service.call(file_name)
  end
end
