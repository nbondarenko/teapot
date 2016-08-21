class CalculationsController < ApplicationController
  before_action :check_null

  def analyse
    respond = Hash.new
    err = check_array( data_params[:set1])
    if !err
      return render json: {error: "invalid data", status: 400}, status: 400
    end
    set = data_params[:set1].collect{ |s| s.to_f}
    respond[:min] = set.min
    respond[:max] = set.max
    respond[:avg] = mean(set)
    respond[:median] = median(set)
    my_q1 = q1(set)
    my_q3 = q3(set)
    respond[:q1] = my_q1
    respond[:q3] = my_q3
    respond[:outl] = outliers(set, my_q1, my_q3)
    render json: {answer: respond}, status: 200
  end

  def correlate
    respond = Hash.new
    err = check_array( data_params[:set1]) && check_array(data_params[:set2])
    err = err && data_params[:set1].size == data_params[:set2].size
    if !err
      return render json: {error: "invalid data", status: 400}, status: 400
    end
    set1 = data_params[:set1].collect{ |s| s.to_f}
    set2 = data_params[:set2].collect{ |s| s.to_f}
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
      if !is_number?(item) || has_space?(item)
        return false
      end
    end
    return arr.size >= 3
  end

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
    array = array.sort
    return array[0] if array.size == 3
    m_pos = array.size / 2
    return median(array[0...(m_pos)])
  end

  def q3(array)
    return nil if array.empty?
    array = array.sort
    return array[2] if array.size == 3
    m_pos = array.size / 2
    return median(array[(m_pos + array.size % 2)..array.size])
  end

  def outliers(array, q1, q3)
    iqr = q3 - q1
    h_value = q3 + 1.5*iqr
    l_value = q1 - 1.5*iqr
    return array.select { |item| item > h_value || item < l_value}
  end

  def is_number?(string)
    true if Float(string) rescue false
  end

  def has_space?(string)
    string.index(/\s/) == 0
  end

  def check_null
    data_params.each do |set|
        return render json: {error: "invalid data", status: 400}, status: 400 if set.nil?
    end
  end
  def data_params
    params.require(:dataset)
  end
end
