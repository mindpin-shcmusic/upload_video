class VideoInfo
  def self.get_info(file_path)
    info_string = `ffmpeg -i #{file_path} 2<&1|grep Stream`

    # 分析音频信息
    audio_info_string = info_string.match("Stream.*Audio:([^\n]*)")[1]
    
    audio_info_arr = audio_info_string.split(",").map{|str|str.strip}
    audio_info = {}
    audio_info[:encode] = audio_info_arr[0]
    audio_info[:sampling_rate] = audio_info_arr[1]
    audio_info[:bitrate] = audio_info_arr[4].match(/\d+/)[0]

    # 分析视频信息
    video_info_string = info_string.match("Stream.*Video:([^\n]*)")[1]
    video_info_arr = video_info_string.split(",").map{|str|str.strip}
    
    video_info = {}
    video_info[:encode] = video_info_arr[0]
    video_info[:size] = video_info_arr[2].match(/\d*x\d*/)[0]
    video_info[:bitrate] = video_info_arr[3].match(/\d+/)[0]
    fps = video_info_arr.select{|info|!info.match("fps").blank?}[0] || "25 fps"
    video_info[:fps] = fps.match(/\d+/)[0]
    
    video_info_string.match(/\d*.*fps/)
    
    {
      :video=>video_info,
      :audio=>audio_info
    }
  end
end