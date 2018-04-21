BEGIN { if(ARGC==7){ ARGC=8; ARGV[7]=ARGV[6]}
		else { print "usage: alinha i1=3 i2=6 f1=30 f2=60 a.srt b.srt\n"; }
		RS="\n\n"; FS="\n"; second_file=0;
		hours_to_millis = 3600000;minutes_to_millis=60000;seconds_to_millis=1000;
		i1=substr(ARGV[1],4); i2=substr(ARGV[2],4);
		f1=substr(ARGV[3],4); f2=substr(ARGV[4],4);}

$1 == i1 && FILENAME == ARGV[5]{ match($2, /([0-9]+):([0-9]+):([0-9]+),([0-9]+) --> ([0-9]+):([0-9]+):([0-9]+),([0-9]+)/,res1);
								 init1 = res1[1]*hours_to_millis + res1[2]*minutes_to_millis + res1[3]*seconds_to_millis +res1[4];}

$1 == f1 && FILENAME == ARGV[5]{ match($2, /([0-9]+):([0-9]+):([0-9]+),([0-9]+) --> ([0-9]+):([0-9]+):([0-9]+),([0-9]+)/,res2);
								 end1 = res2[5]*hours_to_millis + res2[6]*minutes_to_millis + res2[7]*seconds_to_millis + res2[8];}

$1 == i2 && FILENAME == ARGV[6]{ if(second_file == 0) {
								 match($2, /([0-9]+):([0-9]+):([0-9]+),([0-9]+) --> ([0-9]+):([0-9]+):([0-9]+),([0-9]+)/,res3);
								 init2 = res3[1]*hours_to_millis + res3[2]*minutes_to_millis + res3[3]*seconds_to_millis + res3[4];}}

$1 == f2 && FILENAME == ARGV[6]{ if(second_file ==0) {
								 match($2, /([0-9]+):([0-9]+):([0-9]+),([0-9]+) --> ([0-9]+):([0-9]+):([0-9]+),([0-9]+)/,res4);
								 end2 = res4[5]*hours_to_millis + res4[6]*minutes_to_millis + res4[7]*seconds_to_millis + res4[8];}
								 second_file = 2;}

FILENAME==ARGV[6] && second_file==2 { match($2, /([0-9]+):([0-9]+):([0-9]+),([0-9]+) --> ([0-9]+):([0-9]+):([0-9]+),([0-9]+)/,res5);
									  inittl = res5[1]*hours_to_millis + res5[2]*minutes_to_millis + res5[3]*seconds_to_millis + res5[4];
									  endtl = res5[5]*hours_to_millis + res5[6]*minutes_to_millis + res5[7]*seconds_to_millis + res5[8];
									  inittl2 = sync(init1,end1,init2,end2,inittl);
									  endtl2 = sync(init1,end1,init2,end2,endtl);
									  if(inittl2 >= hours_to_millis) {
										hi = int(inittl2/hours_to_millis);
										if(hi < 10) hi = "0"hi;} 
										else hi = "00";
										if((inittl2%hours_to_millis) >= minutes_to_millis) {
											mi = int((inittl2 % hours_to_millis)/minutes_to_millis);
											if(mi < 10) mi = "0"mi;}
										else mi = "00";
										if(((inittl2%hours_to_millis)%minutes_to_millis) >= seconds_to_millis) {
											si = int(((inittl2 % hours_to_millis)%minutes_to_millis)/seconds_to_millis);
											if(si < 10) si = "0"si;
										} else si = "00";
										mli = int(((inittl2%hours_to_millis)%minutes_to_millis)%seconds_to_millis);
										if(mli<10) mli = "00"mli;
										else if(mli<100) mli = "0"mli;
										if(endtl2 >= hours_to_millis) {
											hf = int(endtl2/hours_to_millis);
											if(hf < 10) hf = "0"hf;}
										else hf = "00";
										if((endtl2%hours_to_millis) >= minutes_to_millis) {
											mf = int((endtl2 % hours_to_millis)/minutes_to_millis);
											if(mf < 10) mf = "0"mf;} 
										else mf = "00";
										if(((endtl2%hours_to_millis)%minutes_to_millis) >= seconds_to_millis) {
											sf = int(((endtl2 % hours_to_millis)%minutes_to_millis)/seconds_to_millis);
											if(sf < 10) sf = "0"sf;}
										else sf = "00";
										mlf = int(((endtl2%hours_to_millis)%minutes_to_millis)%seconds_to_millis);
										if(mlf<10) mlf = "00"mlf;
										else if(mlf<100) mlf = "0"mlf;
										string_inittl2 = hi":"mi":"si","mli;
										string_endtl2 = hf":"mf":"sf","mlf;
										tempos[$1] = string_inittl2" --> "string_endtl2;
										for(i=3;i<=NF;i++) {
											if(i==3) info[$1] = $i"\n";
											else if(i==NF) info[$1] = info[$1]$i"\n\n";
												 else info[$1] = info[$1]$i"\n";

										}	
}

function sync(i1,f1,i2,f2,t) {
	dur1 = f1 - i1;
	dur2 = f2 - i2;
	scale = dur1 / dur2;
	shift = (i2*scale) - i1;
	return ((t * scale) - shift);
}

END { for(i in info) { print i"\n"tempos[i]"\n"info[i];}}