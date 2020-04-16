require 'nokogiri'
require 'open-uri'

puts "load the page..."
begin
    page = Nokogiri::HTML(open("https://coinmarketcap.com/all/views/all/"))
    puts "page load."
rescue => e
    puts "ERROR, the page cant be load !"
end

begin
    puts "\nload the symbol..."
    all_symbol_link = page.xpath('//td[@class="cmc-table__cell cmc-table__cell--sortable cmc-table__cell--left cmc-table__cell--sort-by__symbol"]/div')
    if all_symbol_link == nil
        raise e
    end
    puts "symbol load."
rescue => e
    puts "ERROR, the symbol cant be load !"
end

begin
    puts "\nload the price..."
    all_price_link = page.xpath('//td[@class="cmc-table__cell cmc-table__cell--sortable cmc-table__cell--right cmc-table__cell--sort-by__price"]/a')
    if all_price_link == nil
        raise e
    end
    puts "price load."
rescue => e
    puts "ERROR, the price cant be load !"
end


result_hash = {}

puts "\nbuild the hash..."
begin
    #taille des array
    if all_price_link.length != all_symbol_link.length || all_price_link.length < 180
        raise e
    end

    all_symbol_link.length.times do |i|
        #valeur des array
        if all_price_link[i].text == nil || all_symbol_link[i].text == nil
            raise e
        end

        result_hash[all_symbol_link[i].text] = all_price_link[i].text
    end

    #existence de certaine monnaie
    if !result_hash.has_key?("BTC") || !result_hash.has_key?("ETC") || !result_hash.has_key?("ALGO")
        raise e
    end

    puts "hash build."

    puts result_hash
rescue => e
    puts "ERROR, the hash cant be build !"
end