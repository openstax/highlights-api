class InfoJob
  include SuckerPunch::Job

  def perform(event)
    InfoData.new.call
  end
end
