# refresh drc info before running
# Note: uncomment if needed...
addFiller -cell {FILLER_ASAP7_75t_R FILLERxp5_ASAP7_75t_R } -prefix FILLER_
clearDrc
verify_drc
verifyGeometry  -error 1000000 -warning 50 > verifyGeometry.txt
verifyConnectivity -type all -noAntenna -error 1000000 -warning 50 > verifyConnectivity.txt


# Note: Run on geom first until geom.rpt is clean
# then comment .geom.rpt out and run on .conn.rpt next
# repeat until clean
#set file "dist_sort.geom.rpt"
set file "dist_sort.conn.rpt"


#set nets [split [exec grep -o {Net [^ ]*} $file | awk "{print \$2}" | sort | uniq] "\n"]
set nets [split [exec grep -o {Net [^ ]*} $file | awk "{gsub(\":\", \"\", \$2); print \$2}" | sort | uniq] "\n"]

set skip_nets {vss clk vdd Net "|" has ""}

foreach net $nets {
    if {[lsearch -exact $skip_nets $net] != -1 || $net == ""} {
        puts "Skipping net: $net"
        continue
    }
    puts "*******************************************************"
    puts "Processing net: $net"
    puts "*******************************************************"
    deselectAll
    editDelete -net $net
    selectNet $net
    routeDesign -selected
    puts "*******************************************************"
    puts "Completed routing for net: $net"
    puts "*******************************************************"
}

clearDrc
verify_drc
verifyGeometry  -error 1000000 -warning 50 > verifyGeometry.txt
verifyConnectivity -type all -noAntenna -error 1000000 -warning 50 > verifyConnectivity.txt
