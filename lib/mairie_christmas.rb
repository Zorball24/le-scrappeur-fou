require 'nokogiri'
require 'open-uri'

def get_townhall_email(townhall_url)
    begin
        page = Nokogiri::HTML(open(townhall_url))
    rescue => e
        puts "\033[31mERROR, the page cant be load !\033[32m"
    end

    begin
        email_link = page.xpath('/html/body/div/main/section[2]/div/table/tbody/tr[4]/td[2]')
        if email_link.text == ""
            raise e
        end
        puts email_link.text
        return email_link.text
    rescue => e
        puts "\033[31mERROR, the email cant be load !\033[32m"
        return "Aucun email sur cette page !"
    end
end

def get_townhall_urls
    puts "\033[32mload the departement page..."
    begin
        departement_page = Nokogiri::HTML(open("http://annuaire-des-mairies.com/val-d-oise.html"))
        puts "departement page load."
    rescue => e
        puts "\033[31mERROR, the departement page cant be load !\033[32m"
    end


    begin
        puts "\nload link..."
        all_townhall_link = departement_page.xpath('//a[@class="lientxt"]/@href')
        if all_townhall_link == nil
            raise e
        end
        puts "link load."
    rescue => e
        load "\033[31mERROR, the link cant be load !\033[32m"
    end

    all_email = []

    puts "\nload email..."
    all_townhall_link.each do |townhall_link|
        all_email << get_townhall_email("http://annuaire-des-mairies.com" + townhall_link.to_s[1..-1])
    end
    puts "end load email."

    return all_email
end

get_townhall_urls


#//*[@id="voyance-par-telephone"]/table/tbody/tr[2]/td/table/tbody/tr/td[1]/p/a[1]
#//*[@id="voyance-par-telephone"]/table/tbody/tr[2]/td/table/tbody/tr/td[1]/p/a[2]