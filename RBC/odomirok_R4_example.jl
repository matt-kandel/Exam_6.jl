include("./RBC_structs.jl")
include("./RBC_functions.jl")

# Example from Table 88 Odomirok
HO = Line₄(.989, 1.07, .213, .938, 10000, 0, 0, 0)
PPAL = Line₄(1.022, 1.1, .181, .928, 8000, 0, 0, 0)
WC = Line₄(.952, 1.125, .336, .83, 17000, 0, .2, 0)
OL = Line₄(.966, 1.15, .531, .852, 12000, 0, 0, 0)
lines = [HO, PPAL, WC, OL]

# For purposes of this problem, because we're not given premiums
excess_growth_charge(lines::Vector{<:Line₄}) = 0

# Odomirok's answer is $6948.01
println("R₄ for company is $(R₄(lines))")