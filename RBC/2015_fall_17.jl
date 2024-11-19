include("./RBC_structs.jl")
include("./RBC_functions.jl")

# Not all assets are subject to asset_concentration_charge
# but that's not relevant for the purposes of this question
class_2_bonds = Asset(20150, (20150-550-600), .01, 8)
stocks = Asset(9100, 9100-200, .15, missing)

# Examiner's report has R₁ = 693.75 & R₂ = 2700
println("R₁ = $(R₁(class_2_bonds))")
println("R₂ = $(R₂(stocks))")