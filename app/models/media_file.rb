require "uuidtools"
class MediaFile < ActiveRecord::Base
  WAIT = "WAIT"
  ENCODING = "ENCODING"
  SUCCESS = "SUCCESS"
  FAILURE = "FAILURE"
  
  belongs_to :creator,:class_name=>"User",:foreign_key=>"creator_id"
  validates :creator, :presence => true
  
  has_attached_file :file,
      :path => "/web/2012/:class/:attachment/:id/:style/:basename.:extension"
      
  after_create :into_the_encode_queue
  def into_the_encode_queue
    if is_video?
      MediaFileEncodeResque.enqueue(self.id)
      self.video_encode_status = WAIT
      self.save
    end
  end
  
  def is_video?
    ext = File.extname(self.file_file_name).gsub(".","")
    ["3gp"].include?(ext) || file_content_type.split("/")[0] == "video"
  end
  
  def flv_path
    if is_video?
      origin_path = self.file.path
      "#{origin_path}.flv"
    end
  end
  
  def flv_url
    tmps = flv_path.split("/")
    tmps.shift
    tmps.shift
    tmps.shift
    "http://dev.flv.yinyue.edu/player.swf?type=http&file=#{tmps*"/"}"
  end
  
end