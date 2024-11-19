include("./RBC_structs.jl")
include("./RBC_functions.jl")

# Givens
comm_multi_peril = Line₅([93, 114, 129, 137], [90, 95, 97, 100], .25,
    0, 0, .8, .94, .961, [.79, .76, .76, .63, 3.5, .76, .7, .79, .62, .72])
workers_comp = Line₅([120, 131, 141, 156], [117, 120, 128, 135], .25,
    .12, .04, .85, .97, .934, [.77, .65, .7, .75, .65, .76, .8, .84, .72, .71])    
lines = [comm_multi_peril, workers_comp]

# Examiner's report has answer = 32.3
println("Spring 2019 q15 answer = $(R₅(lines))")