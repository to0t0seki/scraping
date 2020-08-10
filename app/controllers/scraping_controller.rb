class ScrapingController < ApplicationController
    def index
    end
    
    def jag
        categries = ["81/1","1/0","2/0","6/0"]
        @jag = {}
        @total = []
        agent = Mechanize.new
        
        for category in categries do
            tmp = {}
            total = 0
            current_page = agent.get("https://papimo.jp/h/00041817/hit/index_sort/215060005/1-20-279176/" + category)
            elements = current_page.search("#table-sort tbody tr")
            
            elements.each do |ele|
                td = ele.search("td")
                tmp[td[0].inner_text] = td[2].inner_text.gsub(",","")
                total += td[2].inner_text.gsub(",","").to_i
            end
            @total << total
            
            tmp.each do |key ,value|
                if @jag.has_key?(key)
                    array = @jag[key]
                    array << value
                    @jag[key] = array
                else
                    array = []
                    array << value
                    @jag[key] = array
                end
            end
            
        end
        
        @jag.each do |key ,value|
            count =  value[3].to_i.to_f / ((value[1].to_i * 312 +  + value[2].to_i * 104) - value[0].to_i) * 50
            value << count.round(2)
            @jag[key] = value
        end
        puts @total
        
        
    end
end
