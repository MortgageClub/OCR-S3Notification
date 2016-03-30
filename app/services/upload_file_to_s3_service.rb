class UploadFileToS3Service
  DIRECTORY   = "#{Rails.root}/xml_files/"
  #BUCKET_NAME = "production-homieo"
  BUCKET_NAME = "dev-homieo"
  FOLDER_NAME = "ocr_results/"

  def self.call(file_name)
    extension = File.extname(file_name)
    file_name.gsub!(extension, ".xml")

    path_to_file = DIRECTORY + file_name

    unless File.exist?(path_to_file)
      p "file does not exist"
      p path_to_file
      return
    end
    #File.chmod(777, path_to_file)


    # fileXML = File.open(path_to_file).read
    # json = Hash.from_xml(fileXML).to_json
    # p json


    key = FOLDER_NAME + file_name

    # remove old xml file
    # Aws::S3::Client.new.delete_object(
    #   bucket: BUCKET_NAME,
    #   key: key
    # )

    p key

    #s3 = Aws::S3::Resource.new
   # s3.bucket(BUCKET_NAME).object(key).upload_file(path_to_file)

    p "uploaded #{path_to_file} at #{Time.zone.now}"
  end
end
