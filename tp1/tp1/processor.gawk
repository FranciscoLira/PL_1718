BEGIN				{RS="\n";FS=":";timeh=0;timem=0;times=0;timems=0;relms;ORS=" ";}
/[0-9]{2}:[0-9]{2}/	{line = 0;if($1*3600000+$2*60000+$3*1000+$4>relms+2000) print "\n" timeh ":" timem ":" times "," timems " -->"; 
					 if($1*3600000+$2*60000+$3*1000+$4>relms+2000) print $1 ":" $2 ":" $3 "," $4 " =================";
					 print "\n" $1 ":" $2 ":" $3 "," $4 " --> " $5 ":" $6 ":" $7 "," $8;
					 timeh=$5;timem=$6;times=$7;timems=$8;relms=timeh*3600000+timem*60000+times*1000+timems}
/[A-Za-z]+/			{if (line==1) print"|";line = 1;print}
END					{}