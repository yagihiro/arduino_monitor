require "open-uri"
class ArduinoController < ApplicationController
  def index
    @json = sampling
  end

  def sample
    render :text=>sampling
  end

  private
  def sampling
    open("http://192.168.10.177").read
  end
end
