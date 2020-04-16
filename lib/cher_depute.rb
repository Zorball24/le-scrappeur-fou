require 'nokogiri'
require 'open-uri'

def display(properties)
    puts "#{properties["first_name"]} #{properties["last_name"]} => #{properties["email"]}"
end

def get_deputy_properties(deputy_url)
    begin
        page = Nokogiri::HTML(open(deputy_url))
    rescue => e
        puts "\033[31mERROR, the page cant be load !\033[32m"
    end

    begin
        email = page.xpath('//a[contains(@href, "mailto")]/@href')[0].text[7..-1]
        if email == ""
            raise e
        end
    rescue => e
        puts "\033[31mERROR, the email cant be load !\033[32m"
        email = "\033[31mThe email cant be found !\033[32m"
    end

    begin
        name = page.xpath('//*[@id="haut-contenu-page"]/article/div[2]/h1').text
        if name == ""
            raise e
        end
    rescue => e
        puts "\033[31mERROR, the name cant be load !\033[32m"
        name = ". \033[31mnone\033[32m \033[31mnone\033[32m"
    end

    name = name.split(" ")
    
    properties = {"first_name" => name[1], "last_name" => name[2..-1].join(" "), "email" => email}
    display(properties)
    return properties
end



def get_deputy_urls
    puts "\033[32mload the deputy page..."
    begin
        deputy_page = Nokogiri::HTML(open("http://www2.assemblee-nationale.fr/deputes/liste/alphabetique"))
        puts "deputy page load."
    rescue => e
        puts "\033[31mERROR, the deputy page cant be load !\033[32m"
    end


    begin
        puts "\nload link..."
        all_deputy_link = deputy_page.xpath('//div[@class="clearfix col-container"]/ul/li/a/@href')
        if all_deputy_link == nil
            raise e
        end
        puts "link load."
    rescue => e
        load "\033[31mERROR, the link cant be load !\033[32m"
    end

    all_properties = []

    puts "\nload properties..."
    all_deputy_link.each do |deputy_link|
        all_properties << get_deputy_properties("http://www2.assemblee-nationale.fr" + deputy_link)
    end
    puts "end load properties."

    return all_properties
end

get_deputy_urls