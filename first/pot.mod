pair_style      eam/alloy
pair_coeff      * * ./Ag.eam.alloy Ag

neighbor 	    2.0 bin
neigh_modify 	every 1 check yes
timestep 	 	1
