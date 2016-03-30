require 'securerandom'

class DownloadFileService

  DIRECTORY = "#{Rails.root}/documents/"
  XML_DIR = "#{Rails.root}/xml_files/"
  # PRODUCTION_URL =  "http://a61ec7f8.ngrok.io/receive"
  PRODUCTION_URL = "http://stg-mortgageclub.herokuapp.com/receive"

  def self.call(raw_post = nil)
    s3 = Aws::S3::Client.new
    message = JSON.parse(raw_post["Message"])
    record = message["Records"].first
    bucket_name = record["s3"]["bucket"]["name"]
    # first_paystubs/9ee9f4bf2ffbd5d32fd6dab8fb7c41cf/IMG_4757_need_a_home.jpg
    key = record["s3"]["object"]["key"]
    file_name = key.split("/").last
    doc_type = file_name.split("-").first

    return if doc_type != "first_paystub" && doc_type != "second_paystub"

    path_to_file = DIRECTORY + file_name
    path_to_xml = XML_DIR + file_name.gsub!(File.extname(file_name),".xml")

    File.delete(path_to_xml) if File.exist?(path_to_xml)

    File.open(path_to_file, "wb") do |file|
      response = s3.get_object({ bucket: bucket_name, key: key }, target: file)
    end

    end_at = Time.zone.now + 20.seconds
    while(!File.exist?(path_to_xml) && Time.zone.now < end_at) do
    end

    if File.exist?(path_to_xml)
        sleep(1)
        File.open(path_to_xml) do |f|
            borrower_id = file_name.gsub("#{doc_type}-Borrower-", '').split('.').first

            data = Nokogiri::XML(f)
            json =  {
                employer_name: data.at_css('_EmployerName').content,
                address_first_line: data.at_css('_EmployerAddressFirstLine').content,
                address_second_line: data.at_css('_EmployerAddressSecondLine').content,
                period_beginning: data.at_css('_PeriodBeginning').content,
                period_ending: data.at_css('_PeriodEnding').content,
                current_salary: data.at_css('_CurrentSalary').content,
                ytd_salary: data.at_css('_YTDSalary').content,
                current_earnings: data.at_css('_CurrentEarnings').content,
                doc_type: doc_type,
                borrower_id: borrower_id

              }

            RestClient.post PRODUCTION_URL, json, :content_type => :json, :accept => :json
        end
    end
  end
end
