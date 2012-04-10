class MediaFileEncodeResque
  QUEUE_NAME = :media_file_encode
  @queue = QUEUE_NAME 
  
  def self.enqueue(id)
    Resque.enqueue(MediaFileEncodeResque, id)
  end
  
  def self.perform(id)
    media_file = MediaFile.find(id)
    return true if !media_file.is_video?
    
    media_file.video_encode_status = MediaFile::ENCODING
    media_file.save
    
    origin_path = media_file.file.path
    flv_path = media_file.flv_path
    VideoUtil.encode_to_flv(origin_path,flv_path)
    
    if File.exists?(flv_path)
      media_file.video_encode_status = MediaFile::SUCCESS
    else
      media_file.video_encode_status = MediaFile::FAILURE
    end
    media_file.save
  end
end