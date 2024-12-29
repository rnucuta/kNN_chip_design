# ensure basic checks
set skip_nets {vss clk vdd Net "|" ""}
timeDesign -postRoute -pathReports -drvReports -slackReports -numPaths 500 -outDir timingReports/
timeDesign -postRoute -hold -pathReports -slackReports -numPaths 500 -outDir timingReports/
# Note: uncomment if necessary
deleteFiller -prefix FILLER_
# Note: This runs in an infinite while loop, may not break
# for a very long time if you have many hold time violations
while {1} {
    set nets [split [exec zcat ./timingReports/dist_sort_postRoute_all_hold.tarpt.gz | sed -n "/Path 1: VIOLATED/,/Other End Path:/p" | sed -n "/Timing Path:/,/Other End Path:/p" | awk "{if (NF >= 6 && \$6 !~ /^Net\$|^\\|\$|^\$/) print \$6}" | sort | uniq] "\n"]

    if {[llength $nets] == 0} {
        puts "*******************************************************"
        puts "No nets found violating hold time. Exiting..."
	puts "*******************************************************"
        # break
	report_ccopt_clock_trees -clock_trees {clk} -file dist_sort.apr.ctsrpt
        return
    }

    foreach net $nets {
        if {[lsearch -exact $skip_nets $net] != -1} {
            puts "########Skipping net: $net"
            continue
        }
        puts "########Processing net: $net"
        puts "########Fixing hold time violation for net: $net"

        deselectAll
        editDelete -net $net
        ecoAddRepeater -cell asap7sc7p5t_22b_INVBUF_RVT_TT_170906/BUFx10_ASAP7_75t_R -net $net
        selectNet $net
        routeDesign -selected
	puts "*******************************************************"
        puts "Hold time violation fixed for net: $net"
	puts "*******************************************************"
    }
    puts "*******************************************************"
    puts "Regenerating timing reports..."
    timeDesign -postRoute -pathReports -drvReports -slackReports -numPaths 500 -outDir timingReports/
    timeDesign -postRoute -hold -pathReports -slackReports -numPaths 500 -outDir timingReports/
    puts "Timing reports regenerated."
    puts "*******************************************************"
}

