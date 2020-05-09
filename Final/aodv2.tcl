# ========================================================================================
#                      Wireless Ad-hoc Routing Protocol AODV
#=========================================================================================
 
# Protocol options

set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            Queue/DropTail/PriQueue    ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             10                         ;# number of mobilenodes
set val(rp)             AODV                       ;# routing protocol
set val(x)              1000                               ;# X dimension of topography
set val(y)              1000                               ;# Y dimension of topography  
set val(stop)                   100                                  ;# time of simulation end
 


#Creat Simulator object
set ns                 [new Simulator]
 
 
#set up trace files
set tracefd       [open aodv2.tr w]
$ns trace-all $tracefd
set namtrace      [open aodv2.nam w]   
$ns namtrace-all-wireless $namtrace $val(x) $val(y) 
 
set windowVsTime2 [open aodv2.tr w] 
 
 
 
#Set up Topgraphy
set topo       [new Topography]
 
 
#Topgraphy border
$topo load_flatgrid $val(x) $val(y)
 
#General Operations Director.store global information 
#state of the environment, network or nodes 
create-god $val(nn)
 
#Congifure wireless nodes
        $ns node-config -adhocRouting $val(rp) \
                                     -llType $val(ll) \
                                     -macType $val(mac) \
                                     -ifqType $val(ifq) \
                                     -ifqLen $val(ifqlen) \
                                     -antType $val(ant) \
                                     -propType $val(prop) \
                                     -phyType $val(netif) \
                                     -channelType $val(chan) \
                                     -topoInstance $topo \
                                     -agentTrace ON \
                                     -routerTrace ON \
                                     -macTrace OFF \
                                     -movementTrace ON
 
#Create the nodes                                  
for {set i 0} {$i < $val(nn) } { incr i } {
                        set node_($i) [$ns node]
			 
            }

#weighted random

#max limit for the number (would be 500)
set min1 550
set max1 800
proc group1RAND {min1 max1} {
    return [expr {int(rand()*($max1-$min1+1)+$min1)}]
}

set min2 200
set max2 550
proc group2RAND {min2 max2} {
    return [expr {int(rand()*($max2-$min2+1)+$min2)}]
}
#group 1 destination generator
for {set i 0} {$i < 5} {incr i} {
    set a($i) [group1RAND 550 800]
    set b($i) [group1RAND 550 800]
    #puts -nonewline "\t $a($i) $b($i)"
    
}

#group 2 destination generator
for {set i 5} {$i < 10} {incr i} {
    set c($i) [group2RAND 200 550]
    set d($i) [group2RAND 200 550]
    #puts -nonewline "\t $c($i) $d($i)"
    
}





# Provide initial location of mobilenodes


#group 1 nodes 0-4

$node_(0) set X_ 250.0
$node_(0) set Y_ 250.0
#$node_(0) set Z_ 0.0
 
$node_(1) set X_ 250.0
$node_(1) set Y_ 250.0
#$node_(1) set Z_ 0.0

$node_(2) set X_ 250.0
$node_(2) set Y_ 250.0
#$node_(2) set Z_ 0.0

$node_(3) set X_ 250.0
$node_(3) set Y_ 250.0
#$node_(3) set Z_ 0.0
 
$node_(4) set X_ 250.0
$node_(4) set Y_ 250.0
#$node_(4) set Z_ 0.0

#group 2 nodes 5-9

$node_(5) set X_ 750.0
$node_(5) set Y_ 750.0
#$node_(5) set Z_ 0.0

$node_(6) set X_ 750.0
$node_(6) set Y_ 750.0
#$node_(6) set Z_ 0.0

$node_(7) set X_ 750.0
$node_(7) set Y_ 750.0
#$node_(7) set Z_ 0.0

$node_(8) set X_ 750.0
$node_(8) set Y_ 750.0
#$node_(8) set Z_ 0.0

$node_(9) set X_ 750.0
$node_(9) set Y_ 750.0
#$node_(9) set Z_ 0.0



#creating 2d list for nodes 0-4 to exit at the topEnd
set topEnd {
	{750 750}
}
#for nodes 5-9 to exit at the bottomEnd
set bottomEnd {
	{250 250}
}

#reading in the indexes of the list
set row 0
set column 0
set column1 1
set side1 [lindex $bottomEnd $row $column]
set side2 [lindex $bottomEnd $row $column1]

set row 0
set column 0
set column1 1
set side3 [lindex $topEnd $row $column]
set side4 [lindex $topEnd $row $column1]
 
#declaring variables 

set clocktime 0 
set i 0

#creating an array to hold each nodes x and y location (a,b) is for group 1 nodes and (c,d) for group 2 nodes
#creating an array to hold each nodes x and y location (a,b) is for group 1 nodes and (c,d) for group 2 nodes.
for {set i 0} {$i < 10} {incr i} {
	set nodeLocationA($i) 0
	set nodeLocationB($i) 0
	set nodeLocationC($i) 0
	set nodeLocationD($i) 0
	
}


#while loop is always true so it runs until either of the if statements inside is true
while {1>0} {


	#loop through nodes  0-4 
	for {set i 0} {$i < 5} {incr i} {
			
			#start clocktime at different times
			$ns at $clocktime "$node_($i) setdest $a($i) $b($i) 250.0"
			#set locations for group 1 nodes 			
			set nodeLocationA($i) [expr {0+$a($i)}]
			set nodeLocationB($i) [expr {0+$b($i)}]
			set clocktime [expr {$clocktime+0.5}]

		}
	#check if the node 0 goes out of destination and break loop if out of bounds
	if {($nodeLocationA(0)>$side3||$nodeLocationB(0)>$side4)} {
		break
	}
	#loop through nodes  5-9 
	for {set i 5} {$i < 10} {incr i} {
			
			#start clocktime at different times
			$ns at $clocktime "$node_($i) setdest $c($i) $d($i) 250.0"
			#set locations for group 2 nodes 			
			set nodeLocationC($i) [expr {0+$c($i)}]
			set nodeLocationD($i) [expr {0+$d($i)}]
			set clocktime [expr {$clocktime+0.5}]
			
					
		}

	#check if the node 9 goes out of destination and break loop if out of bounds
	if {($nodeLocationC(9)<$side1||$nodeLocationD(9)<$side2)} {
		break
	}

		#reset loop and generate new sets of destinations if not out of bounds
		set i 0
		for {set j 0} {$j < 10} {incr j} {
		    set a($j) [group1RAND 550 800]
   		    set b($j) [group1RAND 550 800]
		    set c($j) [group2RAND 200 550]
   		    set d($j) [group2RAND 200 550] 
		}
		

}


#udp connection
set udp [new Agent/UDP]
#$udp set class_2
set null0 [new Agent/Null]
$ns attach-agent $node_(0) $udp
$ns attach-agent $node_(9) $null0

 
#generate cbr traffic
set cbr0 [new Application/Traffic/CBR]
$cbr0 set packetSize_ 500
$cbr0 set interval .005
$cbr0 attach-agent $udp
$ns at 0.1 "$cbr0 start"

$ns connect $udp $null0
 
 
 
# Define node initial position in nam
for {set i 0} {$i < $val(nn)} { incr i } {
#defines the node size for nam
$ns initial_node_pos $node_($i) 100
}
 
# Telling nodes when the simulation ends
for {set i 0} {$i < $val(nn) } { incr i } {
    $ns at $val(stop) "$node_($i) reset"
}
 
# ending nam and the simulation
proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    close $tracefd
    close $namtrace
    exec nam aodv2.nam &
    exit 0

}

# stop simulation at certain time 


$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 100.0 "puts \"END OF AODV SIMULATION\" ; $ns halt"

 
$ns run 
