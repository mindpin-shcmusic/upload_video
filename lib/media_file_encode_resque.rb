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
    
    info = VideoInfo.get_info(origin_path)
    fps = info[:video][:fps]
    size = info[:video][:size]
    video_bitrate = info[:video][:bitrate].to_i*1000
    audio_bitrate = info[:audio][:bitrate]
    
    encode_command = "ffmpeg -i #{origin_path} -ar 44100 -ab #{audio_bitrate}   -b:v #{video_bitrate} -s #{size} -r #{fps} -y #{flv_path}" 
    
    `#{encode_command}`
    `yamdi -i #{flv_path} -o #{flv_path}.tmp`
    `rm #{flv_path}`
    `mv #{flv_path}.tmp #{flv_path}`
    p encode_command
    if File.exists?(flv_path)
      media_file.video_encode_status = MediaFile::SUCCESS
    else
      media_file.video_encode_status = MediaFile::FAILURE
    end
    media_file.save
  end
end