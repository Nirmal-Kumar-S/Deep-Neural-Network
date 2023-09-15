# Here are some useful synthesis commands I went over in class

report_timing -delay max -nworst 10
report_timing -delay max -max_paths 10

all_registers
get_nets
get_cells address*
all_connected address_reg[0]/Q
report_net -connections <net>
report_net -connections [all_connected address_reg[0]/Q]

get_pins C_reg_0
report_transitive_fanin -to C_reg_0/D
report_timing -delay max -to C_reg_0/D


# You can use some of the following commands to determine if your modules ports are connected directly to registers
# If you have a port named data_out
all_connected [all_connected [get_port data_out]]
# This will list all the ports and pins connected to the port. You must see only two, the port itself and a instance pin
# e.g.
{data_out_reg/Q data_out}

# When you run a synthesis command such as get_pin, it returns an "object". These objects have attributes.
# If you run the following, you will see the "object class" of each of the connected pins/ports
foreach_in_collection i [all_connected [all_connected [get_port data_out]]] { puts [get_attr $i object_class }
