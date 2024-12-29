# kNN chip Design
Final Project for ECE 5746 -- Applied ASIC Design. A detailed report can be found in `FinalReport.pdf`. 

The basic outline of the task consisted of outlining a basic distance and sorting design, and then working through the entire digital design implementation flow up to fabrication. In other words, RTL, synthesis/pre-layout timing verification, CTS, place & route, post-layout timing verification, physical verification (LVS/DRC), and power assessment were performed. Each of these steps are included in their respective folders in this repository. 

The goal of this process was to optimize the following metric: Quality Metric = (Tot_latency)^2 × Power × Area. My submission ranked 8/20 in the class as I focused primarily on optimizing total latency through pipeline stages. The design used the open-source [ASAP7 PDK](https://asap.asu.edu/).

In addition to these tasks, I also contributed to the class the following scripts to aid in debugging and automating fixing hold and DRC violations:
- `rtl/check_vals.py`: Aid in debugging RTL level logic for the testbench
- `apr/fix_hold.tcl`: Aid in parsing timing reports and fixing hold violations on nets in Innovus
- `apr/fix_drc.tcl`: Aid in parsing geometry/connection reports and fixing DRC violations on nets in Innovus