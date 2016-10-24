class VerseController < ApplicationController
#   require 'rubygems'
   require 'raa_ordered_hash'
   #require 'ruby-debug'

   BOOKCHAPTERS = RaaOrderedHash["MAT", 28, "MAR", 16, "LUK", 24, "JON", 21, "ACT", 28, "ROM", 16, "1CO", 16, "2CO", 13, "GAL", 6, "EPH", 6, "PHL", 4, "COL", 4, "1TH", 5, "2TH", 3, "1TM", 6, "2TM", 4, "TIT", 3, "PHI", 1, "HEB", 13, "JAM", 5, "1PE", 5, "2PE", 3, "1JN", 5, "2JN", 1, "3JN", 1, "JUD", 1, "REV", 22]

   before_filter :initialize_inst_vars


   #Initialize instance variables from session variables before each action
   def initialize_inst_vars
      @verse= Verse.find(session[:currentVerse] || 1 )
      @search_results = session[:search_results] || []
      @search_results_index = session[:search_results_index] || 0
      @advanced_search_lines = session[:advanced_search_lines] || 3
   end

   def add_advanced_search_line
      @advanced_search_lines += 1
      session[:advanced_search_lines] = @advanced_search_lines
      render :update do |page|
        page.insert_html :bottom, 'advancedSearchTbody', :partial=> 'layouts/advanced_search_line', :locals => {:int => @advanced_search_lines}
        js = 'setHeight();'
        page << js
      end
   end
   
   def remove_advanced_search_line
      if @advanced_search_lines > 1
        @advanced_search_lines -= 1
        session[:advanced_search_lines] = @advanced_search_lines
        render :update do |page|
          page.remove "ad#{@advanced_search_lines + 1}"
          js = ''
          js << 'setHeight();'
          page << js
        end
      end
   end
   
   def show_help
     @background = "/images/peach_texture.jpg"
   end
   
   #AJAX. Hide the simple search form and display the advanced search form
   def show_advanced_search_form
      js = 'document.getElementById("searchFormDiv").className = "invisible";'
      js << 'document.getElementById("advancedSearchFormDiv").className = "visible";'
      js << 'setHeight();'
puts "!!!! here"
     respond_to do |format|
         format.js { render :text => js }
     end
   end

   #AJAX. Hide the advanced search form and display the simple search form
   def show_simple_search_form
      js = 'document.getElementById("searchFormDiv").className = "visible";'
      js << 'document.getElementById("advancedSearchFormDiv").className = "invisible";'
      js << 'document.getElementById("searchFieldset").style.height = "auto";'
      js << 'document.getElementById("findFieldset").style.height = "auto";'
      js << 'setHeight();'
     respond_to do |format|
         format.js { render :text => js }
     end
   end

   #Just a stub for login which we are not supporting at this time
   def login
      userid = params[:userid]
      password = params[:password]
      if not userid == "userid" and password == "password"
         render(:template => "verse/loginfailed")
      end
   end

   #Show the verse identified by the cgi :id variable or the first verse if there is none.
   def show
      show_verse(params[:id] || 1)      
    end
    
   #Show the verse identified by the cgi :id variable or the first verse if there is none.
   def x
   end

   #Ajax. Show the verse identified by the cgi :id variable or the first verse if there is none. Also, set the search_results_index of the search results collection
   #if the requested verse is in the search_results collection. We should only get when a search verse link has been clicked by the user.
   def show_ajax
puts "@@ show_ajax params = #{params.inspect}"
       if @search_results.index(params[:id].to_i) != nil
          @search_results_index = @search_results.index(params[:id].to_i)
          session[:search_results_index] = @search_results_index
      end
      show_verse_ajax(params[:id])
   end
    
   #AJAX. Display the next verse
   def next_verse
      id = session[:currentVerse].to_i
      id +=1 unless id == "7943"
      show_verse_ajax(id)
   end

   #AJAX. Display the previous verse
   def prev_verse
      id = session[:currentVerse].to_i
      id -=1 unless id == "1"
      show_verse_ajax (id)
   end

   #AJAX. Display the next chapter
   def next_chapter
      currentVerse = Verse.find(session[:currentVerse].to_i)
      book = currentVerse.book
      nextChapter = currentVerse.chapter + 1
      if nextChapter > BOOKCHAPTERS[book] #bump to the next book
         if currentVerse.book_order == 27 #unless we are in Revelation
            nextChapter = BOOKCHAPTERS[book]
         else
            book = BOOKCHAPTERS.keys[currentVerse.book_order]
            nextChapter = 1
         end
      end
      #paramArray = {:book => book, :chapter => nextChapter, :verse => 1}
      #@verse = Verse.find(:first, :conditions => ["book = :book and chapter = :chapter and verse = :verse", paramArray])
      @verse = Verse.where("book = ? and chapter = ? and verse = ?", book, nextChapter, 1).first
      show_verse_ajax (@verse.id)
   end

   #AJAX. Display the previous chapter
   def prev_chapter
      currentVerse = Verse.find(session[:currentVerse].to_i)
      book = currentVerse.book
      prevChapter = currentVerse.chapter - 1 #bump down to the previous chapter
      if prevChapter == 0 #bump down to previous book
         if currentVerse.book_order == 1  #unless we are in Mathew
            prevChapter = 1
         else
            book = BOOKCHAPTERS.keys[currentVerse.book_order-2] #bump down to previous book
            prevChapter = BOOKCHAPTERS[book]
         end
      end
      paramArray = {:book => book, :chapter => prevChapter, :verse => 1}
      #@verse = Verse.find(:first, :conditions => ["book = :book and chapter = :chapter and verse = :verse", paramArray])
      #@verse = Verse.find(:first, :conditions => ["book = :book and chapter = :chapter and verse = :verse", paramArray])
      @verse = Verse.where("book = ? and chapter = ? and verse = ?", book, prevChapter, 1).first
      show_verse_ajax (@verse.id)
   end

   #AJAX. Display the next book
   def next_book
      currentVerse = Verse.find(session[:currentVerse].to_i)
      book = currentVerse.book
      book = BOOKCHAPTERS.next(book)
#      paramArray = {:book => book, :chapter => 1, :verse => 1}
#      @verse = Verse.find(:first, :conditions => ["book = :book and chapter = :chapter and verse = :verse", paramArray])
      @verse = Verse.where("book = ? and chapter = ? and verse = ?", book, 1, 1).first
      show_verse_ajax (@verse.id)
   end

   #AJAX. Display the previous book
   def prev_book
      currentVerse = Verse.find(session[:currentVerse].to_i)
      book = currentVerse.book
      book = BOOKCHAPTERS.prev(book)
#      paramArray = {:book => book, :chapter => 1, :verse => 1}
#      @verse = Verse.find(:first, :conditions => ["book = :book and chapter = :chapter and verse = :verse", paramArray])
      @verse = Verse.where("book = ? and chapter = ? and verse = ?", book, 1, 1).first
      show_verse_ajax (@verse.id)
   end

   #AJAX. Toggle hide/show of the search result collection. If the shift key is down then clear out the search results.
   def key_F4_pressed
      if params[:id] == "next"
          #js = 'document.getElementById("searchResultsDiv").className = "searchResultsDiv";'
          #render :update do |page|
          #  page << js
          #end        
      else "shift key down"
          clear_search_results
      end
      #render :search
   end

   #AJAX. Show the next verse in the search result collection. If the shift key is down then show the previous verse in the search results.
   def key_F5_pressed
      if session[:search_results].empty?
         return
      end
      current_index = session[:search_results_index]
      if params[:id] == "next"
         current_index += 1 unless current_index == session[:search_results].size - 1
      else #shift key is down
         current_index -= 1 unless current_index == 0
      end
      session[:search_results_index] = current_index
      id = session[:search_results][current_index]
      show_verse_ajax(id)
   end

   #AJAX. Search for word(s) without grammar. I was able to abstract a common search routine for both simple and advanced searches.
   def search
puts "## SEARCH"
      begin
         #flash.clear
         advanced_search
      rescue Exception => exc
puts "EXCEPTION = #{exc.inspect}"
         #NOTE: The @verse variable ends up being nil when referenced in the view for some odd reason. Must have something to do with the exception
         if exc.class == ActiveRecord::RecordNotFound
            flash[:error] = "There was a problem finding verse #{params[:userVerse]} in the bible. Please enter a valid verse of the form MAT 20:1"
         else
            flash[:error] = exc.message
         end
         #redirect_to(:action => "show")
         @search_results = []
         render :search
      end
   end

   #AJAX. Search word with or without grammar. Note: the strongs number can be missing and that is OK.
   #Note: the search results are instances of Word and not Verse.
   def advanced_search
puts "@@ advance_search <NEW>"
puts "@@ params = #{params.inspect}"
      if params[:action] == "search"
        counter = 0
        parameters = params[:searchWord].split(/ /).inject({}) {| hash, strongs_number |
          counter += 1
          hash["strong_number_id" + counter.to_s] = strongs_number
          hash
        }
      else
        parameters = params
      end

      #Select all of the cgi variables for each search word into a separate collection. Ignore search
      #conditions not specified i.e. the drop down value is 0 (picklist item was like '---').
      search_words = convert_cgi_params_to_array_of_hashes(parameters)
      
      session[:search_words] = search_words    
      session[:search_type] = params[:search_type]
      
      #Build the where clause conditions for each search word including the grammar. 
      conditionsForAny = ""
      conditionsForAllPhrase  = []
      paramArray = {}
      search_words.each_index do | index |
         search_word_criteria = search_words[index]
         conditionsForAny += " or " unless conditionsForAny.empty?
         conditionsForAny += "("
         conditions = ""
         search_word_criteria.each_pair do | key, value |
            conditions += " and " unless conditions.empty?
            conditions += key + "= :" + key + index.to_s
            paramArray [(key + index.to_s).intern] = value
         end
         conditionsForAny += conditions + ")"
         conditionsForAllPhrase  << "(" + conditions + ")"
       end
puts "@@ gere @@"
      #Build the SQL conditions for the query
      case params[:search_type]
        when "All"
           sqlConditions = conditionsForAllPhrase [0]
           1.upto(conditionsForAllPhrase .size-1) do |index|
              sqlConditions += " and exists (select a.verse_id from words a where a.verse_id = words.verse_id and " + conditionsForAllPhrase [index]+ ")"
            end

        when "Any"
           sqlConditions = "words.verse_id = verses.id and " + conditionsForAny
        when "Phrase"
           sqlConditions = conditionsForAllPhrase [0]
           1.upto(conditionsForAllPhrase .size-1) do |index|
              sqlConditions += " and exists (select word_order from words a where a.verse_id = words.verse_id and " + conditionsForAllPhrase [index]+ " and a.word_order = words.word_order + " + index.to_s + ")"
            end
      end

      #Submit the SQL. We use parameter tokens to prevent SQL injection attacks. Why not just get Verse objects? I would like to but the
      #database is way to slow if I change Word to Verse and remove the include. It does return the correct result set though.
puts "@@ sqlConditions = #{sqlConditions.inspect}"
puts "@@ paramArray = #{paramArray.inspect}"
      @search_results = Word.includes(:verse).where(sqlConditions, paramArray)      
      #Get rid of duplicate search results. The database is too slow when we use distinct so we will do it ourselves.
puts "@@ advanced search results size = #{@search_results.size.to_s}"
if @search_results.size > 4000
   #raise "Search results are greater than 4000. Please narrow down your search."
puts "here before raise error"
   raise "The search yielded too many results (#{@search_results.size.to_s}). Please narrow down the search to 4000 results or fewer."
end
      unique_search_results = RaaOrderedHash[]
      @search_results.each { | word | unique_search_results[word.verse_id] = word}
      @search_results = unique_search_results.values

      #Save the search results in the session variable. Only keep the verse_id.
      session[:search_results] = @search_results.collect {| word | word.verse_id}
      session[:search_results_index] = 0

      #display first search result
      @verse = @search_results[0].verse unless @search_results.empty?

      #Return Javascript back to the browser. Display the results table and grammar for the first search result.
     #render :partial => 'layouts/paginator', :locals => { :collection => @search_results_enum} unless @search_results.empty?

#     js = get_search_results_javascript
#     js << get_grammar_table_javascript      
#     respond_to do |format|
#         format.js { render :text => js }
#     end
      render :search
    end

   #AJAX. Wrap the Javascript to display the grammar table with the <SCRIPT> tag
   def display_table
      js = '<script type="text/javascript">;'
      js << get_grammar_table_javascript
      js << '</script>'
      js
    end

   #AJAX. Wrap the Javascript to display the search results with the <SCRIPT> tag
   def display_search_results
      js = '<script type="text/javascript">;'
      js << get_search_results_javascript
      js << '</script>'
      js
    end

   #Find and display the verse the user entered i.e. MAT 3.5. Reset the search results collection if a new verse was selected.
   def find
      begin
           #@testvar = '<a href="javascript: void(0);" class="defns" onmouseover="coolTip(\'&lt;a href=\\\'/wiki/show_appears?value=Fidel+Castro&amp;name=primaryCharacter\\\' &gt;zAppears...&lt;/a&gt;\',STICKY, MOUSEOFF);" onmouseout="nd();">Hello</a>'
         @search_results = []
         session[:search_results] = []
         userVerse = params[:userVerse]
         if not userVerse or userVerse.empty?
            return render(:template => "verse/show")
         end

         book = userVerse.split.first

         #Allow Mat 1:1 and Mat 1.1 format for the verse
         if chapter = userVerse.split().last.split(".").size == 1
            chapter = userVerse.split().last.split(/\:/).first
            verse = userVerse.split().last.split(/\:/).last
         else
            chapter = userVerse.split().last.split(/\./).first
            verse = userVerse.split().last.split(/\./).last
         end
         paramArray = {:book => book, :chapter => chapter, :verse => verse}
         @verse = Verse.where("book = ? and chapter = ? and verse = ?", book, chapter, verse).first

         #If we got here, Rails didn't raise a RecordNotFound exception so raise it ourself.
         if not @verse
            raise ActiveRecord::RecordNotFound, "Couldn't find verse #{params[:userVerse]}"
         end
         session[:search_results] = []
         session[:currentVerse] = @verse.id.to_s
puts "verse in find method = #{@verse.inspect}"
         show_verse_ajax(@verse.id)
	 #render :search #(:template => "verse/search") #show")

      rescue Exception => exc
puts "EXCEPTION = #{exc.inspect}"
         #NOTE: The @verse variable ends up being nil when referenced in the view for some odd reason. Must have something to do with the exception
         if exc.class == ActiveRecord::RecordNotFound
            flash[:error] = "There was a problem finding verse #{params[:userVerse]} in the bible. Please enter a valid verse of the form MAT 20:1"
         else
            flash[:exception] = " An unexpected error occured: " + exc.message
         end
         redirect_to(:action => "show")
      end
   end

   #Clear the search results collection
   def clear_search_results
      @search_results = []
puts "Clear search results #{params.inspect}"
      render :search
#      session[:search_results] = []
#      session[:search_results_index] = 0        
#      session[:search_words] = []
#      session[:search_type] = ""
#      js = 'div = document.getElementById("searchResultsDiv");'
#      js << 'try {div.removeChild(document.getElementById("searchResultsTable"))} catch (e) {};'
#      js << 'hideShowSearchResults();'
#     respond_to do |format|
#         format.js { render :text => js }
#     end
   end

   #######################
   private
   #######################
   def show_verse(id)
      @verse = Verse.find(id)
      session[:currentVerse] = @verse.id.to_s
      render :show
   end

   def show_verse_ajax(id)
      @verse = Verse.includes(:words).find(id)
      js = get_grammar_table_javascript
      respond_to do |format| 
         format.js { render :text => js }
         format.html { render :text => "<p>HELLO</p>" }
      end
   #    format.js { render :text => "alert('testing')" }
   end
#proxy_1 | nginx.1    | 104.236.11.136 75.168.57.17 - - [23/Oct/2016:16:00:38 +0000] "GET /verse/show_ajax/2669 HTTP/1.1" 200 15801 "http://104.236.11.136/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36"
#proxy_1 | nginx.1    | 104.236.11.136 75.168.57.17 - - [23/Oct/2016:16:01:51 +0000] "GET /verse/find?utf8=%E2%9C%93&userVerse=MAR+1.1%C2%A0%C2%A0 HTTP/1.1" 302 99 "http://104.236.11.136/" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_9_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/53.0.2785.143 Safari/537.36"

    
   # Generate the Javascript to display the Grammar Table. This does two things for us. It lets us use Ajax and IE doesn't support
   # changing tables in the DOM.
   def get_grammar_table_javascript
      session[:currentVerse] = @verse.id.to_s 
      #Display the tranlastion of the verse
      js = 'document.getElementById("translationDiv").innerHTML = "' + CGI.escapeHTML(@verse.kjv_bible.translation.strip) + '";'      

      #Initialization
      js << 'var div = null;'
      js << 'var table = null;'
      js << 'var tbody = null;'
      js << 'var tr = null;'
      js << 'var th = null;'
      js << 'var td = null;'
      js << 'var colgroup = null;'
      js << 'var col = null;'
      #Remove old table
      js << 'div = document.getElementById("grammarTableDiv");'
      js << 'try {div.removeChild(document.getElementById("grammarTable"))} catch (e) {};'
      #Create new table
      js << 'table = document.createElement("table");'
      js << 'table.id="grammarTable";'
      #js << 'table.style.clear = "left";'
      js << 'table.className = "grammarTable";'
      #js << 'table.style.border = "0";'
      #js << 'table.style.cellPadding = "0";'
      #js << 'table.style.cellspacing = "2";'
      #js << 'table.style.width = "85%";'
      js << 'div.appendChild(table);'
      #Create colGroups
      js << 'colgroup = document.createElement("colgroup");'
      js << 'col = document.createElement("col");'
      js << 'col.width="19%";'
      js << 'colgroup.appendChild(col);'
      js << 'col = document.createElement("col");'
      js << 'col.width="6%";'
      js << 'colgroup.appendChild(col);'
      js << 'col = document.createElement("col");'
      js << 'col.width="6%";'
      js << 'colgroup.appendChild(col);'
      js << 'col = document.createElement("col");'
      js << 'col.width="6%";'
      js << 'colgroup.appendChild(col);'
      js << 'col = document.createElement("col");'
      js << 'col.width="6%";'
      js << 'colgroup.appendChild(col);'
      js << 'col = document.createElement("col");'
      js << 'col.width="6%";'
      js << 'colgroup.appendChild(col);'
      js << 'col = document.createElement("col");'
      js << 'col.width="6%";'
      js << 'colgroup.appendChild(col);'
      js << 'col = document.createElement("col");'
      js << 'col.width="13%";'
      js << 'colgroup.appendChild(col);'
      js << 'col = document.createElement("col");'
      js << 'col.width="31%";'
      js << 'colgroup.appendChild(col);'

      js << 'table.appendChild(colgroup);'
      #Create tbody
      js << 'tbody = document.createElement("tbody");'
      js << 'table.appendChild(tbody);'
      #Create header
      js << 'tr = document.createElement("tr");'
      js << 'tbody.appendChild(tr);'
      js << 'tr.align = "left";'
      js << 'th = document.createElement("th");'
      js << 'tr.appendChild(th);'
      js << 'th.innerHTML = "Nestles Text";'
      js << 'th = document.createElement("th");'
      js << 'tr.appendChild(th);'
      js << 'th.colSpan = "2";'
      js << 'th.style.color = "#00FFFF";'
      js << 'th.innerHTML = "Word/Numb";'
      js << 'th = document.createElement("th");'
      js << 'tr.appendChild(th);'
      js << 'th.colSpan = "4";'
      js << 'th.align = "center";'
      js << 'th.style.color = "#00FFFF";'
      js << 'th.innerHTML = "Grammar";'
      js << 'th = document.createElement("th");'
      js << 'tr.appendChild(th);'
      js << 'th.style.background = "Black";'
      js << 'th.style.color = "White";'
      js << 'th.innerHTML = "' + @verse.book + " " + @verse.chapter.to_s + ":" + @verse.verse.to_s + '";'
      js << 'th = document.createElement("th");'
      js << 'tr.appendChild(th);'
      js << 'th.style.color = "#FFFFFF";'
      js << 'th.innerHTML = "Translation";'

    #If we are searching for a phrase it gets a bit tricky. Here we loop through all words in the verse and keep a collection of "word_order"s 
    #for each phrase we find in the verse. There could be more than one. A phrase is a succession of words in the verse.
    search_word_orders = []
    if session[:search_type] == "Phrase" and !session[:search_words].empty?
      @verse.words.each_index { | index | 
         #see if the word matches the search criteria for first search word 
         matches = match_specific_search_criteria(@verse.words[index], session[:search_words][0], [])
         if matches != {} #we found a match so keep going
            temp_search_word_orders = [@verse.words[index].word_order] #keep a collection of the word_orders of the matched words 
            match = "y" #assume we will match
            for offset in 1...session[:search_words].size do  #check the remaining search words in the phrase to the next words in the verse
              if index + offset < @verse.words.size #don't go past the end 
                match = "n" unless match_specific_search_criteria(@verse.words[index + offset], session[:search_words][offset], temp_search_word_orders).empty? != true
              else
                match = "n"
              end
            end
            #If we found a match keep the word_order which we will use to hilite the word
            if match == 'y'
              (search_word_orders << temp_search_word_orders).flatten!
            end
          end
      }
    end

      #Build data rows
      counter = 0
      @verse.words.each_index do |index|
         word = @verse.words[index]
         search_matches = match_search_criteria(word, session[:search_words] || [], search_word_orders) 
         #puts "\nmatches=#{matches.inspect} word_order=#{word.word_order} serach_words=#{session[:search_words].inspect} search_wrods_orders=#{search_word_orders}\n"

         #Create tr
         js << 'tr = document.createElement("tr");'
         js << 'tbody.appendChild(tr);'
         js << 'tr.align = "left";'
         #Create td - greek word
         js << 'td = document.createElement("td");'
         js << 'tr.appendChild(td);'
         js << 'td.innerHTML = "' + word.strong_number.greek_word + '";'
         #Create td - strongs nbr
         js << 'td = document.createElement("td");'
         js << 'tr.appendChild(td);'
         js << 'td.className = "hiliteSearchWord";' unless search_matches["strong_number_id"] == nil
         #Note: XHTML does not support span here. js << 'td.innerHTML = "<span title=' + "'Click to search'" + '>' + sprintf("%04d", word.strong_number_id) + '</span>";'
         js << 'td.innerHTML = "<span title=' + "'Click to search'" + '>' + sprintf("%04d", word.strong_number_id) + '</span>";'
         #js << 'td.innerHTML = "' + sprintf("%04d", word.strong_number_id) + '";'
         js << 'td.onmousedown=function (evt) { editCell(this);};'
         #td.ondblclick = function (evt) { editCell(this);};
         #Create td -  ordinal position
         js << 'td = document.createElement("td");'
         js << 'tr.appendChild(td);'
         js << 'td.innerHTML = "' + (counter += 1).to_s + '";'
         #Create td - tense/gender
         js << 'td = document.createElement("td");'
         js << 'tr.appendChild(td);'
         js << 'td.className = "hiliteSearchWord";' unless search_matches["grammar_tense_gender_code_id"] == nil
         js << 'td.innerHTML = "' + word.grammar_tense_gender_code.descr + '";'
         #Create td - voice/case
         js << 'td = document.createElement("td");'
         js << 'tr.appendChild(td);'
         js << 'td.className = "hiliteSearchWord";' unless search_matches["grammar_voice_case_code_id"] == nil
         js << 'td.innerHTML = "' + word.grammar_voice_case_code.descr + '";'
         #Create td - mode
         js << 'td = document.createElement("td");'
         js << 'tr.appendChild(td);'
         js << 'td.className = "' + (word.grammar_mode_code.descr == "nom" ? "nomCase" : "") + '";'
         js << 'td.className = "hiliteSearchWord";' unless search_matches["grammar_mode_code_id"] == nil
         js << 'td.innerHTML = "' + word.grammar_mode_code.descr + '";'
         #Create td - number/person
         js << 'td = document.createElement("td");'
         js << 'tr.appendChild(td);'
         js << 'td.className = "hiliteSearchWord";' unless search_matches["grammar_number_person_code_id"] == nil
         js << 'td.innerHTML = "' + word.grammar_number_person_code.descr + '";'
         #Create td - partciple/case
         js << 'td = document.createElement("td");'
         js << 'tr.appendChild(td);'
         case word.grammar_participle_case_code.descr
          when "---verb"  then js << 'td.className = "verb";'
          when "---infn"  then js << 'td.className = "verb";'
          else js << 'td.className = "hiliteSearchWord";' unless search_matches["grammar_participle_case_code_id"] == nil
         end
         js << 'td.innerHTML = "' + word.grammar_participle_case_code.descr + '";'
         #Create td - translation
         js << 'td = document.createElement("td");'
         js << 'tr.appendChild(td);'
         js << 'td.innerHTML = "' + word.strong_number.translation[0,25] + '";'
       end
      js
   end
    
   # Generate the Javascript to display the Search Results Table. This does two things for us. It lets us use Ajax and IE doesn't support
   # changing tables in the DOM.
   def get_search_results_javascript
puts "get_search_results_javascript #{params.inspect}"
      if @search_results.empty?
          return ""
      end
      if @search_results[0].class == Fixnum
        @search_results = Word.includes(:verse).find(@search_results)      
      end
      #Initialization
      js = 'document.getElementById("searchResultsMessage").innerHTML = "' + "Found #{@search_results.size} verses." + '";'
      js << 'var table = null;'
      js << 'var tbody = null;'
      js << 'var tr = null;'
      js << 'var td = null;'
      js << 'document.getElementById("hideShowSearchResults").className = "";'      
      js << 'document.getElementById("clearSearchResults").className = "";'      
      js << 'document.getElementById("searchResultsMessage").className = "";'            
      #Remove old table
      js << 'div = document.getElementById("searchResultsDiv");'
      js << 'try {div.removeChild(document.getElementById("searchResultsTable"))} catch (e) {};'
      #Create new table
      js << 'table = document.createElement("table");'
      js << 'table.id = "searchResultsTable";'
      js << 'div.appendChild(table);'
      #Create tbody
      js << 'tbody = document.createElement("tbody");'
      js << 'table.appendChild(tbody);'
      counter = 0
      @search_results.each do |word|
        #Build data row
        if counter % 12 == 0
          js << 'tr = document.createElement("tr");'
          js << 'tbody.appendChild(tr);'
        end
        #Create td 
         js << 'td = document.createElement("td");'
         js << 'tr.appendChild(td);'
         #js << 'td.innerHTML = "<span title=' + %Q/'#{word.verse.kjv_bible.translation.strip} ' id='title'><a href='/ + '/verse/show/' + %Q/#{word.verse.id.to_s}'> #{word.verse.book} #{word.verse.chapter.to_s}:#{word.verse.verse.to_s}</ + '/a></span>";'
         #js << 'td.innerHTML = "<a href=/verse/show/' + %Q/#{word.verse.id.to_s}> #{word.verse.book} #{word.verse.chapter.to_s}:#{word.verse.verse.to_s}</ + '/a>";'
         js << %Q/td.innerHTML = '<a href="#"' + ' onclick="new Ajax.Request(' + "'\/verse\/show_ajax\/#{word.verse.id.to_s}', {asynchronous:true, evalScripts:true}); return false;" + '"> #{word.verse.book} #{word.verse.chapter.to_s}:#{word.verse.verse.to_s}<\/a>';/
         counter += 1
       end
      js
    end
    
  #Match the search criteria to the word object to the search_words collection. The search_word_orders collection is used for a Phrase search.
  def match_search_criteria(word, search_words, search_word_orders)
    #Answer the first hash in search_words that matches all of the attributes in the word object.    
    if search_word_orders.empty? 
      search_words.each { | hash |
        match = match_specific_search_criteria(word, hash, [])      
          return match unless match.empty?
      }
    else
      #However, if we are working with a Phrase we need to get the hash that corresponds to the word order
      if search_word_orders.include?(word.word_order)
         #note: there could more than 1 phrase in the verse. That's why we use modulo in the next stmt.
         match = match_specific_search_criteria(word, search_words[search_word_orders.index(word.word_order).modulo(search_words.size)] , [])      
         return match unless match.empty?
      end
    end
    {}
  end

  #Match the search criteria for a single word to the word object. The search_word_orders collection is used for a Phrase search.
  def match_specific_search_criteria(word, hash, search_word_orders)
      match = true
      hash.each_pair {| key, value | 
        match = false unless (word.send key.intern) == value.to_i
      }
      if match 
        if session[:search_type] == "Phrase"
          search_word_orders << word.word_order
        end
        return hash 
      end
    {}
  end
  
  #This method turns the cgi params hash into an array of hashes indexed by the integer at the end of the key. The integer at the end of the key is removed.
  #i.e. given a list of params like this:
  #        {"strong_numberId1" => 0204, "grammar_tense_gender_code_id1" => 2, "strong_numberId2" => 3588, "grammar_mode_code_id2" => 4}
  #this method will answer an array of hashes like this:
  #        [{}, {"strong_numberId"=>132, "grammar_tense_gender_code_id"=>2}, {"strong_numberId"=>3588, "grammar_mode_code_id"=>4}]
  #
  #NOTE: after this routine runs, any empty hashes will be removed. This could happen if the numbering scheme of the html options
  #is 1,2,3 and so on rather than 0,1,2.
  def convert_cgi_params_to_array_of_hashes(parameters, remove_empty_hashes = true)
    search_words = []
    parameters.except!(:utf8).each_pair { | key, value |
      index = key.slice(/\d+/).to_i   #get the number at the end of the variable
      search_words[index] = [] unless search_words[index] #initialize array
      if key.slice(/\d+/) != nil and value != "0" and value != "" #ignore cgi variables that don't end in a digit or that have 0 or blank values
        search_words[index] << key.slice(/\D+/) << value
      end
    }
    search_words.each_index { | index | search_words[index] = Hash[*search_words[index] || [].flatten] }
    search_words.delete({})
    search_words
  end

end

