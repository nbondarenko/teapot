##
#This class gathered operations for providing calculations
class CalculationsController < ApplicationController
  before_action :check_null

  def analyse
    unless(cookies[:token])
      return render json: { error: "Authorization error" }, status: 401
    end
    respond = Hash.new
    valid_array = check_array(data_params[:set1])
    return render json: { error: "invalid data", status: 400 }, status: 400 unless valid_array
    set = data_params[:set1].collect{ |s| s.to_f}
    respond[:min] = set.min
    respond[:max] = set.max
    respond[:avg] = mean(set)
    respond[:median] = median(set)
    first_quartilie = q1(set)
    third_quartilie = q3(set)
    respond[:q1] = first_quartilie
    respond[:q3] = third_quartilie
    respond[:outl] = outliers(set, first_quartilie, third_quartilie)
    render json: {answer: respond}, status: 200
  end

  def correlate
    unless(cookies[:token])
      return render json: { error: "Authorization error" }, status: 401
    end
    respond = Hash.new
    valid_set = check_array(data_params[:set1]) && check_array(data_params[:set2]) && data_params[:set1].size == data_params[:set2].size
    return render json: { error: "invalid data", status: 400 }, status: 400 unless valid_set
    set1 = data_params[:set1].collect{ |s| s.to_f }
    set2 = data_params[:set2].collect{ |s| s.to_f }
    x_m = mean(set1)
    y_m = mean(set2)
    prod = 0
    x_sq = 0
    y_sq = 0
    set1.zip(set2).each do |x, y|
      prod = prod + (x - x_m)*(y - y_m)
      x_sq = x_sq + (x - x_m)**2
      y_sq = y_sq + (y - y_m)**2
    end
    ro = prod / (Math.sqrt(x_sq)*Math.sqrt(y_sq))
    respond[:coef] = ro
    render json: {answer: respond}, status: 200
  end

  private

  def check_array(arr)
    arr.each do |item|
      return false if !is_number?(item) || has_space?(item)
    end
    arr.size >= 3
  end

  def mean(array)
	  array.inject(0) { |sum, x| sum += x } / array.size.to_f
	end

  def median(array)
	  return nil if array.empty?
	  array = array.sort
	  m_pos = array.size / 2
	  array.size % 2 == 1 ? array[m_pos] : mean(array[m_pos-1..m_pos])
	end

  def q1(array)
    return nil if array.empty?
    array = array.sort
    return array[0] if array.size == 3
    m_pos = array.size / 2
    median(array[0...(m_pos)])
  end

  def q3(array)
    return nil if array.empty?
    array = array.sort
    return array[2] if array.size == 3
    m_pos = array.size / 2
    median(array[(m_pos + array.size % 2)..array.size])
  end

  def outliers(array, q1, q3)
    iqr = q3 - q1
    h_value = q3 + 1.5*iqr
    l_value = q1 - 1.5*iqr
    array.select { |item| item > h_value || item < l_value}
  end

  def is_number?(string)
    true if Float(string) rescue false
  end

  def has_space?(string)
    string[" "]
  end

  def check_null
    data_params.each do |set|
      return render json: {error: "invalid data"}, status: 400 if set.nil?
    end
  end

  def data_params
    params.require(:dataset)
  end
end
