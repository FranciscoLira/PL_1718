# Conversões tempo
# 1s - 1000ms
# 1m - 60 * 1000 ms
# 1h - 60 * 60 * 1000 ms
# [H]:[M]:[S]:[MS]


BEGIN { if(ARGC==7){ ARGC=8; ARGV[7]=ARGV[6]}
else { print "usage: awk -f strsync.awk i1=3 i2=6 f1=30 f2=60 a.srt b.srt > new_file.str \n"; }
RS="\n\n";FS="\n";read=1;
hours_to_milliseconds = 3600000; minutes_to_milliseconds = 60000; seconds_to_milliseconds = 1000;
i1=substr(ARGV[1],4); i2=substr(ARGV[2],4);
f1=substr(ARGV[3],4); f2=substr(ARGV[4],4); }

# Armazenamento dos tempos
$1 == i1 && FILENAME == ARGV[5]{ match($2, /([0-9]+):([0-9]+):([0-9]+),([0-9]+) --> ([0-9]+):([0-9]+):([0-9]+),([0-9]+)/,temp1);
								 str_i1 = temp1[1] * hours_to_milliseconds + temp1[2] * minutes_to_milliseconds + temp1[3] * seconds_to_milliseconds +temp1[4];
 							   }
$1 == f1 && FILENAME==ARGV[5] { match($2, /([0-9]+):([0-9]+):([0-9]+),([0-9]+) --> ([0-9]+):([0-9]+):([0-9]+),([0-9]+)/,temp2);
								str_f1 = temp2[5] * hours_to_milliseconds + temp2[6] * minutes_to_milliseconds + temp2[7] * seconds_to_milliseconds + temp2[8];
							  }
$1 == i2 && FILENAME==ARGV[6] { if(read == 1) {
									match($2, /([0-9]+):([0-9]+):([0-9]+),([0-9]+) --> ([0-9]+):([0-9]+):([0-9]+),([0-9]+)/,temp3);
									str_i2 = temp3[1] * hours_to_milliseconds + temp3[2] * minutes_to_milliseconds + temp3[3] * seconds_to_milliseconds + temp3[4];
								}	
							  }
$1 == f2 && FILENAME==ARGV[6] {
								if(read == 1) {

									match($2, /([0-9]+):([0-9]+):([0-9]+),([0-9]+) --> ([0-9]+):([0-9]+):([0-9]+),([0-9]+)/,temp4);
									str_f2 = temp4[5] * hours_to_milliseconds + temp4[6] * minutes_to_milliseconds + temp4[7] * seconds_to_milliseconds + temp4[8];
								}
								read = 2;
							  }

# Cálculo do novo tempo em ms
FILENAME==ARGV[6] && read==2 {
										  match($2, /([0-9]+):([0-9]+):([0-9]+),([0-9]+) --> ([0-9]+):([0-9]+):([0-9]+),([0-9]+)/,temp6);
										  ti1 = temp6[1] * hours_to_milliseconds + temp6[2] * minutes_to_milliseconds + temp6[3] * seconds_to_milliseconds + temp6[4];
										  tf1 = temp6[5] * hours_to_milliseconds + temp6[6] * minutes_to_milliseconds + temp6[7] * seconds_to_milliseconds + temp6[8];
										  new_ti1 = sync(str_i1,str_f1,str_i2,str_f2,ti1);
										  new_tf1 = sync(str_i1,str_f1,str_i2,str_f2,tf1);
# Conversão em [H]:[M]:[S]:[MS]
										  if(new_ti1 >= 3600000) {
										  		hi = int(new_ti1/3600000);
										  		if(hi < 10) hi = "0"hi;
										  } else hi = "00";
										  if((new_ti1%3600000) >= 60000) {
										  		mi = int((new_ti1 % 3600000)/60000);
										  		if(mi < 10) mi = "0"mi;
										  } else mi = "00";
										  if(((new_ti1%3600000)%60000) >= 1000) {
										  		si = int(((new_ti1 % 3600000)%60000)/1000);
										  		if(si < 10) si = "0"si;
										  } else si = "00";
										  mli = int(((new_ti1%3600000)%60000)%1000);
										  if(mli<10) mli = "00"mli;
										  else if(mli<100) mli = "0"mli;
										  if(new_tf1 >= 3600000) {
										  		hf = int(new_tf1/3600000);
										  		if(hf < 10) hf = "0"hf;
										  } else hf = "00";
										  if((new_tf1%3600000) >= 60000) {
										  		mf = int((new_tf1 % 3600000)/60000);
										  		if(mf < 10) mf = "0"mf;
										  } else mf = "00";
										  if(((new_tf1%3600000)%60000) >= 1000) {
										  		sf = int(((new_tf1 % 3600000)%60000)/1000);
										  		if(sf < 10) sf = "0"sf;
										  } else sf = "00";
										  mlf = int(((new_tf1%3600000)%60000)%1000);
										  if(mlf<10) mlf = "00"mlf;
										  else if(mlf<100) mlf = "0"mlf;


										  time_format_new_ti1 = hi":"mi":"si","mli;
										  time_format_new_tf1 = hf":"mf":"sf","mlf;
										  timestamps[$1] = time_format_new_ti1" --> "time_format_new_tf1;
										  for(i=3;i<=NF;i++) {
										  	if(i==3) substitles[$1] = $i"\n";
											else if(i==NF) substitles[$1] = substitles[$1]$i"\n\n";
												 else substitles[$1] = substitles[$1]$i"\n";

										  }

	
}


function sync(i1,f1,i2,f2,t) {
	dur1 = f1 - i1;
	dur2 = f2 - i2;
	scale = dur1 / dur2;
	shift = (i2*scale) - i1;
	return ((t * scale) - shift);
}

END { for(i in substitles) { print i"\n"timestamps[i]"\n"substitles[i];}}

