class UploadFileToS3Service
  DIRECTORY   = "#{Rails.root}/xml_files/"
  BUCKET_NAME = "dev-homieo"
  FOLDER_NAME = "ocr_results/"

  def self.call(file_name)
    path_to_file = DIRECTORY << file_name
    return unless File.exist?(path_to_file)

    key = FOLDER_NAME << file_name
    s3 = Aws::S3::Resource.new
    s3.bucket(BUCKET_NAME).object(key).upload_file(path_to_file)
  end
end
