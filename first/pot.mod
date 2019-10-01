# pair_style      eam/alloy
# pair_coeff      * * ./Ag.eam.alloy Ag

pair_style      hybrid eam/alloy tersoff
pair_coeff      1 1 ./Ag.eam.alloy Ag
pair_coeff      2 2 Si.tersoff Si

neighbor 	    2.0 bin
neigh_modify 	every 1 check yes
timestep 	 	1
