set project_path ./ 
set search_path [format "%s%s%s" "$search_path " $project_path "./build/"]
set save_path [format "%s%s" $project_path "/out"]
set_app_var target_library "nanGate_15_CCS_typical.db"
set_app_var link_library "* nanGate_15_CCS_typical.db"
define_design_lib work -path [format "%s%s" $project_path "/work"]

set my_verilog_files [list RandomLUTPipe.v]

set my_toplevel RandomLUTPipe

set_host_options -max_cores 16
report_host_options
analyze -f verilog $my_verilog_files
elaborate $my_toplevel
current_design $my_toplevel

set frequency 500
set peri [expr 1000*1000.0 / $frequency]

create_clock clock -name "clock" -period $peri -waveform [list 0.0 [expr $peri / 2.0]]

compile -incremental_mapping -map_effort high -area_effort low -power_effort low -auto_ungroup delay
# compile_ultra -gate_clock -no_autoungroup
check_design

set filename [format "%s%s" $my_toplevel "_dc_netlist.v"]
set filename_cell [format "%s%s" $my_toplevel "_cell.txt"]
set filename_area [format "%s%s" $my_toplevel "_area.txt"]
set filename_timing [format "%s%s" $my_toplevel "_timing.txt"]
set filename_power [format "%s%s" $my_toplevel "_power.txt"]
write -f verilog -output $save_path/$filename -hierarchy
    report_cell   > $save_path/$filename_cell
    report_area   > $save_path/$filename_area
    report_timing > $save_path/$filename_timing
    report_power -analysis_effort medium > $save_path/$filename_power
exit
