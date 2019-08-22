pair_style      eam/alloy
pair_coeff      * * ./Ag.eam.alloy Ag

neighbor 	    2.0 bin
neigh_modify 	every 1 check yes
# neigh_modify delay 0 every 1 check yes page 500000 one 50000
timestep 	 	1
