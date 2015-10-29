require "rails_helper"

describe DownloadFileService do
  before(:each) do
    @raw_post = {
      "Message" => {
        "Records" => [
          "s3" => {
            "bucket" => {
              "name" => "production-homieo"
            },
            "object" => {
              "key" => "first_paystubs/9ee9f4bf2ffbd5d32fd6dab8fb7c41cf/document.pdf"
            }
          }
        ]
      }.to_json
    }

    allow_any_instance_of(Aws::S3::Client).to receive(:get_object).and_return("")
  end

  it "downloads a file" do
    expect_any_instance_of(Aws::S3::Client).to receive(:get_object)
    DownloadFileService.call(@raw_post)
  end

  it "calls UploadFileToS3Service" do
    expect(Delayed::Job.count).to eq(0)
    DownloadFileService.call(@raw_post)
    expect(Delayed::Job.count).to eq(1)
  end
end