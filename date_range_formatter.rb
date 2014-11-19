require 'date'
require 'active_support/core_ext/integer/inflections'

# rspec should is deprecated

# Formats date range
class DateRangeFormatter
  def initialize(from, to, from_time = nil, to_time = nil)
    @from = Date.parse(from)
    @to = Date.parse(to)
    @from_time = from_time
    @to_time = to_time
  end

  def format(date)
    date.strftime "#{date.day.ordinalize} %B %Y"
  end

  def format_with_time(date, time, type)
    time = time.nil? ? '' : " #{type} #{time}"
    date.strftime "#{date.day.ordinalize} %B %Y#{time}"
  end

  def format_short(date)
    date.strftime "#{date.day.ordinalize} %B"
  end

  def normal_format(from, to, from_time, to_time)
    f = format_with_time(from, from_time, :at)
    t = format_with_time(to, to_time, :at)
    "#{f} - #{t}"
  end

  def same_format(from, from_time, to_time)
    base = format(from)
    base += " at #{from_time}" unless from_time.nil?
    base += " to #{to_time}" unless to_time.nil?
    base
  end

  def same_month_format(from, to)
    to_day = to.day.ordinalize
    from.strftime "#{from.day.ordinalize} - #{to_day} %B %Y"
  end

  def same_month_format_with_time(from, to, from_time, to_time)
    f = format_with_time(from, from_time, :at)
    t = format_with_time(to, to_time, :at)
    "#{f} - #{t}"
  end

  def same_year_format(from, to)
    year = to.year
    f = format_short(from)
    t = format_short(to)
    "#{f} - #{t} #{year}"
  end

  def to_s
    if @from == @to
      same_format(@from, @from_time, @to_time)
    elsif @from.year == @to.year && @from.month == @to.month
      if @from_time.nil? && @to_time.nil?
        same_month_format(@from, @to)
      else
        same_month_format_with_time(@from, @to, @from_time, @to_time)
      end
    elsif @from.year == @to.year && @from_time.nil? && @to_time.nil?
      same_year_format(@from, @to)
    else
      normal_format(@from, @to, @from_time, @to_time)
    end
  end
end
