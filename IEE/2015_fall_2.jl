include("./IEE_structs.jl")
include("./IEE_functions.jl")

comm_auto = Line([2000, 2300], [3400, 3700], [6200, 6600])
work_comp = Line([3000, 3000], [1500, 1500], [5000, 5000])
all_lines = Company([15200, 18500], [31200, 36700], [7600, 9000],
                    [16700, 20000], [comm_auto, work_comp])
                    
allocated_to_comm_auto = allocated_surplus(all_lines, comm_auto)
allocated_to_work_comp = allocated_surplus(all_lines, work_comp)
println("allocated surplus for comm auto = $(round(allocated_to_comm_auto, digits=3))")
println("allocated surplus for work comp = $(round(allocated_to_work_comp, digits=3))")