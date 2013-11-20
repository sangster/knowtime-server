
days = []
days << "MON" if calendar.monday?
days << "TUE" if calendar.tuesday?
days << "WED" if calendar.wednesday?
days << "THU" if calendar.thursday?
days << "FRI" if calendar.friday?
days << "SAT" if calendar.saturday?
days << "SUN" if calendar.sunday?

json.array! days