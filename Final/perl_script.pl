use :strict;
if($#ARGV<0){
printf("Usage: <trace-file>\n");
exit 1;
}
# to open the given trace file
open(Trace, $ARGV[0]) or die "Cannot open the trace file";
my $totalSend = 0; # sending counter
my $totalReceived = 0; # receiving counter
my $msg = 0; #message counter for overhead
my $totalCBR = 0;
my $totalNONCBR = 0;
my $startTime = 0;
my $endTime = 0;


while(<Trace>){ # read one line in from the file
	my @line = split; #split the line with delimin as space
	
	if($line[3] eq "AGT" || "RTR" && $line[6] eq "cbr"){ # an application agent trace line
		if($line[0] eq "s" && $line[2] eq "_0_"){ # a packet sent by node 0
			$totalSend++;
			#save start time with first simulation time value
			if(!$startTime || ($line[1] < $startTime)){
				$startTime = $line[1];

			}
			
		
		}
		
		if($line[0] eq "r" && $line[2] eq "_9_"){ # a packet received by node 10
			$totalReceived++;
			if($line[1] > $endTime) {
				$endTime = $line[1];

			}
		
			
		}
		
				
	}

	#printing node footprints
	if($line[0] eq "M") {
		
		$string = $line[0];
		if(/$string/){print}
	}
	#printing total CBR packets
	if($line[6] eq "cbr") {
		$totalCBR++;
		
	}
	#printing non total CBR packets
	if($line[6] ne "cbr" && $line[0] ne "M") {
		$totalNONCBR++;
		
	}
	
	
}
close(Trace); #close the file


#if there is at least one received packets
if($totalReceived > 0)
{
	printf("Packets sent by Node 0= %d\n",$totalSend);
	printf("Packets sent by Node 9= %d\n",$totalReceived);
	printf("Packets dropped = %d\n",($totalSend-$totalReceived));	
	printf("Total Overhead =%f\n",($totalNONCBR/$totalCBR));
	printf("StartTime =%f\n",($startTime));	
	printf("EndTime =%f\n",($endTime));
	printf("Throughput in mbps = %f\n",(($totalReceived)*(500*8)/($endTime-$startTime))/1000000);	
	
}

#Command use to run perl totalSendript from terminal 
#perl perl_script.pl tracefilename.tr
