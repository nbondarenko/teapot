class CalculationsController < ApplicationController
  before_action :check_null, :only => [:analyse]
  def analyse
    errors = []
    err = check_array( data_params[:set1])
    if !err
          return render status: 422, json: {message: "invalid data"}
    end
  end

  def check_array arr
    arr.each do |item|
      debugger
      if !is_number?( item ) || has_space?( item )
        return false
      end
    end
    return arr.size >= 3
  end

  private

  def is_number? string
    true if Float(string) rescue false
  end

  def has_space? string
    string.index(/\s/) == 0
  end

  def check_null
    if data_params[:set1].nil?
      return render status: 422, json: {message: "invalid data"}
    end
  end
  def data_params
    params.require(:dataset)
  end
end
