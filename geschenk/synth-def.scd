(
SynthDef(\bass, { |out, amp=0.3, freq=440, reverbWet=0.3|
	var snd,fc, meanFc, reverb;
	meanFc = Rand(400,2000);
	fc = SinOsc.kr(Rand(1,2),0,Rand(0,meanFc*0.7), meanFc);
	snd = [Saw.ar(freq-0.22),Saw.ar(freq+0.22)];
	snd = snd+[Saw.ar(freq/2-0.2,),Saw.ar(freq/2+0.2)];
	snd = snd+[Saw.ar(freq/2-0.1),Saw.ar(freq/2+0.1)];
	snd = snd * EnvGen.ar(Env.linen(0.01, 0.2, 0.25), doneAction:2);
	//snd = RLPF.ar(snd, 800,0.2);
	snd = RLPF.ar(snd, fc,Rand(0.01,0.2));
	OffsetOut.ar(out, snd*amp*0.2);
}).add;

SynthDef(\reverb, { |in, out=0|
	var sig;
	sig = In.ar(in, 2);
	sig = FreeVerb.ar(sig, 0.3, 0.6, 0.2);
	Out.ar(out, sig);
}).add;

SynthDef(\jupiter, { |out, amp=0.3, freq=80|
	var snd,snd2,snd3;
	snd = [LFSaw.ar(freq),LFSaw.ar(freq,0.7)];
	snd3 = [LFPulse.kr(freq*2,0.7),LFPulse.ar(freq*2,0.7)]*0.5+0.5;
	snd2 = [LFSaw.ar(freq-0.7,1.2,snd3),LFSaw.ar(freq-0.8,1.3,snd3)];
	snd = snd+snd2;
	snd = snd * EnvGen.ar(Env.linen(0.01, 0.2, 0.5), doneAction:2);
	//snd = RLPF.ar(snd, 800,0.2);
	snd = RLPF.ar(snd,EnvGen.ar(Env.linen(0.01, 0.3, 0.1))*2200+300,0.1);
	OffsetOut.ar(out, snd*amp*0.2);
}).add;

SynthDef(\cello, { |out, amp=0.1, freq=440, gate=1, lastNote, midinote|
	var snd,freqLine,lastFreq,fmod,amod;
	freqLine = XLine.kr(lastNote.midicps, freq, 0.07*max(abs(lastNote-midinote),1));
	fmod = SinOsc.kr(5)*1;
	amod = SinOsc.kr(4)*0.05;
	snd = [LFSaw.ar(freqLine+fmod-0.1),LFSaw.ar(freqLine+fmod+0.1)];
	//snd = snd+[LFSaw.ar(freqLine/2+fmod-0.1,0.7),LFSaw.ar(freqLine/2+fmod+0.1,0.1)];
	snd = snd+[LFSaw.ar(freqLine*2+fmod-0.1,0.3),LFSaw.ar(freqLine*2+fmod+0.1,1.5)];
	snd = snd * EnvGen.ar(Env.adsr(0.1,0.1,0.8,2),gate, doneAction:2);
	snd = RLPF.ar(snd, 2000,0.1);
	OffsetOut.ar(out, snd*amp*(0.3+amod));
}).add;

)
/*
(Pdef(\test,
	Pbind(
		\instrument, \jupiter,
		\dur, 0.25,
		\midinote, Pseq([36,48,60],inf)
)).play;

)*/