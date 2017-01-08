require 'sinatra'
require 'csv'
require 'date'

CONF = {
  svet: {
    places: CSV.read('./cities.txt', col_sep: "\t"),
    zoom: 4..8
  },
  srbija: {
    places: CSV.read('./srbija.txt', col_sep: "\t"),
    zoom: 9..12
  }
}
COUNTRIES = Hash[CSV.read('./countries.txt', col_sep: "\t")]

get '/' do
  redirect to('/svet')
end

get '/:gde' do |gde|
  @gde = gde.to_sym
  @conf = CONF[@gde]
  return halt unless @conf
  @city = @conf[:places].sample

  today = Date.today
  first = Date.new(today.year + 1, 1, 1)
  @to_go = (first - today).to_i - 1

  erb :index
end