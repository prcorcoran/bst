class Word < ActiveRecord::Base
  belongs_to :verse
  belongs_to :grammar_tense_gender_code
  belongs_to :grammar_voice_case_code
  belongs_to :grammar_mode_code
  belongs_to :grammar_number_person_code
  belongs_to :grammar_participle_case_code
  belongs_to :strong_number

# alias :real_grammar_tense_gender_code :grammar_tense_gender_code 
# def grammar_tense_gender_code
#    code = GrammarTenseGenderCode.getCode(grammar_tense_gender_code_id)   
# end
 
 def attributes
   @attributes
   end
 
 alias :real_strong_number :strong_number 
 def strong_number
    StrongNumber.getCode(strong_number_id)
#    code = getCachedObject(strong_number_id, StrongNumber, :real_strong_number)
 end

 alias :real_grammar_mode_code :grammar_mode_code 
 def grammar_mode_code
    GrammarModeCode.getCode(grammar_mode_code_id)
 end
 
 alias :real_grammar_number_person_code :grammar_number_person_code 
 def grammar_number_person_code
    GrammarNumberPersonCode.getCode(grammar_number_person_code_id)
 end
 
 alias :real_grammar_participle_case_code :grammar_participle_case_code 
 def grammar_participle_case_code
    GrammarParticipleCaseCode.getCode(grammar_participle_case_code_id)   
 end
 
 alias :real_grammar_voice_case_code :grammar_voice_case_code 
 def grammar_voice_case_code
    GrammarVoiceCaseCode.getCode(grammar_voice_case_code_id)   
 end
  
end
