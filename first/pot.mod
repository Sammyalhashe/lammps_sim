pair_style      eam/alloy
pair_coeff      * * ./Ag.eam.alloy Ag

neighbor 	    1.0 bin
neigh_modify 	every 1 check yes
timestep 	 	1
