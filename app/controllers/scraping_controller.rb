require "date"

class ScrapingController < ApplicationController
    def index
        @today = Date.today
    end
    
    def jag
       
       
  
                #  binding.pry
        categries = ["81/1","1/0","2/0","6/0"]
        @jag = {}
        @total = []
        @ave = []
        
        agent = Mechanize.new
        
        for category in categries do
            tmp = {}
            total = 0
            
            begin  
            current_page = agent.get("https://papimo.jp/h/"+params[:hall]+"/hit/index_sort/"+params[:machine]+"/1-20-279176/" + category)
            rescue WWW::Mechanize::ResponseCodeError => e
                puts error
            end
             
            elements = current_page.search("#table-sort tbody tr")
            
            elements.each do |ele|
                td = ele.search("td")
                tmp[td[0].inner_text] = td[params[:date].to_i + 1].inner_text.gsub(",","")
                total += td[params[:date].to_i + 1].inner_text.gsub(",","").to_i
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
            
            @machine_name = elements = current_page.search(".name").inner_text
            @hall_name = elements = current_page.search(".store-ttl").inner_text
            @update_time = elements = current_page.search(".latest").inner_text.gsub("データ更新日時：","")
            
            
            
        end
        
        @jag.each do |key ,value|
            count =  value[3].to_i.to_f / ((value[1].to_i * 312 +  + value[2].to_i * 104) - value[0].to_i) * 50
            value << count.round(2)
            @jag[key] = value
        end
        # binding.pry
        begin
            @ave << @total[3] / @total[1]
        rescue ZeroDivisionError
            @ave << 0
        end
        
        begin    
            @ave << @total[3] / @total[2]
        rescue ZeroDivisionError
            @ave << 0
        end
        
        begin
            @ave << (@total[3].to_i.to_f / ((@total[1].to_i * 312 +  + @total[2].to_i * 104) - @total[0].to_i) * 50).round(2)
        rescue ZeroDivisionError
            @ave << 0
        end
        
    end
end
