# ========================================================================================
#                      Wireless Ad-hoc Routing Protocol DSR
#=========================================================================================
 
# Protocol options
set val(chan)           Channel/WirelessChannel    ;# channel type
set val(prop)           Propagation/TwoRayGround   ;# radio-propagation model
set val(netif)          Phy/WirelessPhy            ;# network interface type
set val(mac)            Mac/802_11                 ;# MAC type
set val(ifq)            CMUPriQueue                ;# interface queue type
set val(ll)             LL                         ;# link layer type
set val(ant)            Antenna/OmniAntenna        ;# antenna model
set val(ifqlen)         50                         ;# max packet in ifq
set val(nn)             10                         ;# number of mobilenodes
set val(rp)             DSR                       ;# routing protocol
set val(x)              500                               ;# X dimension of topography
set val(y)              500                               ;# Y dimension of topography  
set val(stop)            100                                 ;# time of simulation end
 


#Creat Simulator object
set ns                 [new Simulator]
 
 
#set up trace files
set tracefd       [open dsr.tr w]
$ns trace-all $tracefd
set namtrace      [open dsr.nam w]   
$ns namtrace-all-wireless $namtrace $val(x) $val(y) 
 
set windowVsTime2 [open dsr.tr w] 
 
 
 
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
			#node_($i$) random-motion 1 
            }


#max limit for the number (would be 500)

proc random_int { upper_limit } {
    global myrand
    set myrand [expr int(rand() * $upper_limit + 1)]
    return $myrand
}

#generating movement destinations for the first time 499 to avoid program crashing and ns2 not running
for {set i 0} {$i < 10} {incr i} {
    set a($i) [random_int 499]
    set b($i) [random_int 499]
    #puts -nonewline "\t $a($i) $b($i)"
    
}





# Provide initial location of mobilenodes

# Scenario 1 all node start at center

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
$node_(2) set Y_ 250.0
#$node_(2) set Z_ 0.0

$node_(3) set X_ 250.0
$node_(3) set Y_ 250.0
#$node_(3) set Z_ 0.0

$node_(4) set X_ 250.0
$node_(4) set Y_ 250.0
#$node_(4) set Z_ 0.0

$node_(5) set X_ 250.0
$node_(5) set Y_ 250.0
#$node_(5) set Z_ 0.0

$node_(6) set X_ 250.0
$node_(6) set Y_ 250.0
#$node_(6) set Z_ 0.0

$node_(7) set X_ 250.0
$node_(7) set Y_ 250.0
#$node_(7) set Z_ 0.0

$node_(8) set X_ 250.0
$node_(8) set Y_ 250.0
#$node_(8) set Z_ 0.0

$node_(9) set X_ 250.0
$node_(9) set Y_ 250.0
#$node_(9) set Z_ 0.0


 
#declaring variables 
set steps 0 
set clocktime 0 
set i 0

#counting stepmeter
for {set i 0} {$i < 10} {incr i} {
	set stepMeter($i) 0
	
}

#while steps < 1000
while {$steps<1000} {
	#while i<10 this is for accessing array elements 0-9 ( nodes 1-10)
	while {$i < 10} {
			
			
			
		$ns at $clocktime "$node_($i) setdest $a($i) $b($i) 250.0"	
		#clocktime for nodes start at diff times and stepmeter to accumulate each nodes step meter
		set stepMeter($i) [expr {$stepMeter($i)+0.5}]
		set clocktime [expr {$clocktime+0.5}]
		incr steps 
		incr i
				
		}
		#reset loop and generate new sets of destinations
		set i 0
		for {set j 0} {$j < 10} {incr j} {
		    set a($j) [random_int 499]
		    set b($j) [random_int 499]        
		}
	
		

}

for {set i 0} {$i < 10} {incr i} {
	puts "Step Meter for node $i: $stepMeter($i)"
}

#puts "number of steps: $steps"





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
    $ns at $val(stop) "$node_($i) reset";
}
 
# ending nam and the simulation
proc stop {} {
    global ns tracefd namtrace
    $ns flush-trace
    
    close $tracefd
    close $namtrace
    exec nam dsr.nam &
    exit 0

}

# stop simulation 

$ns at $val(stop) "$ns nam-end-wireless $val(stop)"
$ns at $val(stop) "stop"
$ns at 100.0 "puts \"END OF DSR SIMULATION\" ; $ns halt"

 
$ns run
