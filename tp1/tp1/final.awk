BEGIN { if(ARGC==7){ ARGC=8; ARGV[7]=ARGV[6]}
else { print "usage: alinha i1=3 i2=6 f1=30 f2=60 a.srt b.srt\n"; }
RS="\n\n";FS="\n";second_file_run=0; i1=substr(ARGV[1],4); i2=substr(ARGV[2],4);
 f1=substr(ARGV[3],4); f2=substr(ARGV[4],4); }

$1 == i1 && FILENAME == ARGV[5]{ match($2, /([0-9]+):([0-9]+):([0-9]+),([0-9]+) --> ([0-9]+):([0-9]+):([0-9]+),([0-9]+)/,res1);
								 tempo_inicio1 = res1[1]*3600000 + res1[2]*60000 + res1[3]*1000 +res1[4];
 							   }
$1 == f1 && FILENAME==ARGV[5] { match($2, /([0-9]+):([0-9]+):([0-9]+),([0-9]+) --> ([0-9]+):([0-9]+):([0-9]+),([0-9]+)/,res2);
								tempo_fim1 = res2[5]*3600000 + res2[6]*60000 + res2[7]*1000 + res2[8];
							  }
$1 == i2 && FILENAME==ARGV[6] { if(second_file_run ==0) {
									match($2, /([0-9]+):([0-9]+):([0-9]+),([0-9]+) --> ([0-9]+):([0-9]+):([0-9]+),([0-9]+)/,res3);
									tempo_inicio2 = res3[1]*3600000 + res3[2]*60000 + res3[3]*1000 + res3[4];
								}	
							  }
$1 == f2 && FILENAME==ARGV[6] {
								if(second_file_run ==0) {

									match($2, /([0-9]+):([0-9]+):([0-9]+),([0-9]+) --> ([0-9]+):([0-9]+):([0-9]+),([0-9]+)/,res4);
									tempo_fim2 = res4[5]*3600000 + res4[6]*60000 + res4[7]*1000 + res4[8];
								}
								second_file_run = 2;
							  }

FILENAME==ARGV[6] && second_file_run==2 { 
										  match($2, /([0-9]+):([0-9]+):([0-9]+),([0-9]+) --> ([0-9]+):([0-9]+):([0-9]+),([0-9]+)/,res5);
										  tl_inicio = res5[1]*3600000 + res5[2]*60000 + res5[3]*1000 + res5[4];
										  tl_fim = res5[5]*3600000 + res5[6]*60000 + res5[7]*1000 + res5[8];
										  tl_inicio_novo = sincroniza(tempo_inicio1,tempo_fim1,tempo_inicio2,tempo_fim2,tl_inicio);
										  tl_fim_novo = sincroniza(tempo_inicio1,tempo_fim1,tempo_inicio2,tempo_fim2,tl_fim);
										  if(tl_inicio_novo >= 3600000) {
										  		hi = int(tl_inicio_novo/3600000);
										  		if(hi < 10) hi = "0"hi;
										  } else hi = "00";
										  if((tl_inicio_novo%3600000) >= 60000) {
										  		mi = int((tl_inicio_novo % 3600000)/60000);
										  		if(mi < 10) mi = "0"mi;
										  } else mi = "00";
										  if(((tl_inicio_novo%3600000)%60000) >= 1000) {
										  		si = int(((tl_inicio_novo % 3600000)%60000)/1000);
										  		if(si < 10) si = "0"si;
										  } else si = "00";
										  mli = int(((tl_inicio_novo%3600000)%60000)%1000);
										  if(mli<10) mli = "00"mli;
										  else if(mli<100) mli = "0"mli;
										  if(tl_fim_novo >= 3600000) {
										  		hf = int(tl_fim_novo/3600000);
										  		if(hf < 10) hf = "0"hf;
										  } else hf = "00";
										  if((tl_fim_novo%3600000) >= 60000) {
										  		mf = int((tl_fim_novo % 3600000)/60000);
										  		if(mf < 10) mf = "0"mf;
										  } else mf = "00";
										  if(((tl_fim_novo%3600000)%60000) >= 1000) {
										  		sf = int(((tl_fim_novo % 3600000)%60000)/1000);
										  		if(sf < 10) sf = "0"sf;
										  } else sf = "00";
										  mlf = int(((tl_fim_novo%3600000)%60000)%1000);
										  if(mlf<10) mlf = "00"mlf;
										  else if(mlf<100) mlf = "0"mlf;
										  string_tl_inicio_novo = hi":"mi":"si","mli;
										  string_tl_fim_novo = hf":"mf":"sf","mlf;
										  tempos[$1] = string_tl_inicio_novo" --> "string_tl_fim_novo;
										  for(i=3;i<=NF;i++) {
										  	if(i==3) info[$1] = $i"\n";
											else if(i==NF) info[$1] = info[$1]$i"\n\n";
												 else info[$1] = info[$1]$i"\n";

										  }

	
}


function sincroniza(ti1,tf1,ti2,tf2,t) {
	dur1 = tf1 - ti1;
	dur2 = tf2 - ti2;
	scale = dur1 / dur2;
	shift = (ti2*scale) -ti1;
	return ((t * scale) - shift);
}

END { 	
		for(i in info) {
			print i"\n"tempos[i]"\n"info[i];
		}	
}

