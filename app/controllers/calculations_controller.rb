class CalculationsController < ApplicationController
  before_action :check_null, :only => [:analyse]
  def analyse
    errors = []
    respond = Hash.new
    err = check_array( data_params[:set1])
    if !err
          return render status: 422, json: {message: "invalid data"}
    end
    set = data_params[:set1].collect{ |s| s.to_f}
    respond[:min] = set.min
    respond[:max] = set.max
    respond[:avg] = mean(set)
    respond[:median] = median(set)
    respond[:q1] = q1(set)
    respond[:q3] = q3(set)
    return render status: 200, json: {answer: respond}
  end

  def check_array arr
    arr.each do |item|
      if !is_number?( item ) || has_space?( item )
        return false
      end
    end
    return arr.size >= 3
  end

  private

  def mean(array)
	  array.inject(0) { |sum, x| sum += x } / array.size.to_f
	end

  def median(array)
	  return nil if array.empty?
	  array = array.sort
	  m_pos = array.size / 2
	  return array.size % 2 == 1 ? array[m_pos] : mean(array[m_pos-1..m_pos])
	end

  def q1(array)
    return nil if array.empty?
    arr = array.sort
    return arr[0] if array.size == 3
    m_pos = arr.size / 2
    return median(arr[0...(m_pos+arr.size % 2)])
  end

  def q3(array)
    return nil if array.empty?
    arr = array.sort
    return arr[2] if array.size == 3
    m_pos = arr.size / 2
    return median(arr[(m_pos-arr.size % 2)...arr.size])
  end

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
