set top_level dist_sort

#*****************************************************************************
#	Add Filler
#*****************************************************************************

# all done--finish up with decap and finally filler

addFiller -cell {FILLER_ASAP7_75t_R FILLERxp5_ASAP7_75t_R } -prefix FILLER_

# Note that, upon adding the filler cells, the Innovus layout design should look complete/full, without any spaces between the cells. 
# This is important for two reasons: 
# 1) The wells need to be continuous, so that each device is connected to one or more taps through the wells. 
# 2) The M1 power rails need to be continuous. 

#*****************************************************************************
#	Verify Geometry & Connectivity
#*****************************************************************************
#clearDrc
#verify_drc
#verifyGeometry  -error 1000000 -warning 50 > verifyGeometry.txt
#verifyConnectivity -type all -noAntenna -error 1000000 -warning 50 > verifyConnectivity.txt

# easy violation browser open:
# violationBrowser -all -no_display_false -displayByLayer

# to fix DRC issues (should be able to reroute after filler has been placed):
# deselectAll
# editDelete - net <net_name> (i.e. clk)
# selectNet <net_name>
# routeDesign -selected


#report_ccopt_clock_trees -clock_trees {clk} -file dist_sort.apr.ctsrpt
#report_ccopt_clock_trees -clock_trees {clk} -filename dist_sort2.apr.ctsrpt

#Save final Design
saveNetlist $top_level.apr.v
saveNetlist $top_level.apr_pg.v -includePowerGround -excludeLeafCell
saveNetlist $top_level.fillerexcluded.apr_pg.v -includePowerGround -excludeLeafCell -excludeCellInst {FILLERxp5_ASAP7_75t_R FILLER_ASAP7_75t_R}
saveDesign $top_level.final.enc
extractRC -outfile $top_level.cap
rcOut -spef $top_level.spef 
write_sdf dist_sort.sdf

##StreamOutGds
streamOut $top_level.gds -mapFile /classes/ece5746/asap7pdk/asap7PDK_e1p5/cdslib/asap7_TechLib_08/asap7_fromAPR_08b.layermap -libName $top_level -units 4000 -mode ALL

###Summary report
summaryReport -noHtml -outfile summaryReport.rpt
report_timing -max_paths 3 -path_type full_clock > dist_sort.apr_wc3_timing.txt
report_timing -max_paths 3 -path_type full_clock -early > dist_sort.apr_bc3_timing.txt


###best and worst case timings
report_timing -check_type setup -max_paths 3 -nworst 3 > dist_sort.apr_wc3_setup_timing.txt
checkFPlan -outFile details.txt -reportUtil

#postapr initial step command (for easy access)
# v2lvs -i -v /home/rn347/asap7_rundir/finalproj/apr/dist_sort.apr_pg.v -o dist_sort.sp -n -a "[]" -lsr /classes/ece5746/asap7libs/cdl/lvs/asap7_75t_R.cdl -s /classes/ece5746/asap7libs/cdl/lvs/asap7_75t_R.cdl
# /classes/ece5746/asap7pdk/asap7PDK_e1p5/calibre/ruledirs/lvs/lvsRules_calibre_asap7.rul
