require 'sinatra'
require 'csv'
require 'date'

ALL = []
BY_COUNTRY = {}
SLUGS = {}
COUNTRIES = {}

def slugize(str)
  str.downcase.gsub(/[^a-z]+/, '-')
end

def split_alt(str)
  return [] unless str
  str.split(',')
end

CSV.foreach('./cities15000.txt', col_sep: "\t", quote_char: "\x00", external_encoding: 'utf-8') do |row|
  cc = row[8]
  BY_COUNTRY[cc] ||= []
  BY_COUNTRY[cc] << row
  ALL << row
end

CSV.foreach('./countries.txt', col_sep: "\t", external_encoding: 'utf-8') do |row|
  cc = row[0]
  name = row[1]
  slug = slugize(name)
  COUNTRIES[cc] = name
  SLUGS[slug] = cc
end

get '/' do
  @city = ALL.sample
  @country = COUNTRIES[@city[8]]
  @min_zoom = 5
  @max_zoom = 9
  @title_area = "the World"
  @title_city = "#{@city[1]}, #{@country}"
  @alt_names = split_alt(@city[3])
  @random_countries = COUNTRIES.values.sample(5)

  erb :index
end

get '/:slug' do |slug|
  pass unless cc = SLUGS[slug]
  @country = COUNTRIES[cc]
  @city = BY_COUNTRY[cc].sample
  @min_zoom = 9
  @max_zoom = 13
  @title_area = @country
  @title_city = @city[1]
  @alt_names = split_alt(@city[3])
  @random_countries = COUNTRIES.values.sample(5)

  erb :index
end