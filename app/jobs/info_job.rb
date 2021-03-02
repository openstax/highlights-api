class InfoJob
  include SuckerPunch::Job

  def perform(event)
    InfoStore.new.call
  end
end
