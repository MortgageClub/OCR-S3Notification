class UploadFileToS3Service
  DIRECTORY   = "#{Rails.root}/xml_files/"
  BUCKET_NAME = "production-homieo"
  FOLDER_NAME = "ocr_results/"

  def self.call(file_name)
    extension = File.extname(file_name)
    file_name.gsub!(extension, ".xml")

    path_to_file = DIRECTORY + file_name

    unless File.exist?(path_to_file)
      p "file does not exist"
      return
    end

    key = FOLDER_NAME + file_name

    # remove old xml file
    # Aws::S3::Client.new.delete_object(
    #   bucket: BUCKET_NAME,
    #   key: key
    # )

    p key

    s3 = Aws::S3::Resource.new
    s3.bucket(BUCKET_NAME).object(key).upload_file(path_to_file)

    p "uploaded #{path_to_file} at #{Time.zone.now}"
  end
end
