
days = case
         when calendar.saturday?
           %w(SAT)
         when calendar.sunday?
           %w(SUN)
         else
           %w(MON TUE WED THU FRI)
       end

json.array! days