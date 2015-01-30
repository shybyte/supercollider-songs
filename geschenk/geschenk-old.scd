(
var drumsDir;
TempoClock.default.tempo = 140/120;    // 2 beats/sec, or 120 BPM
~reverbBus = 40;
Buffer.freeAll;

~bassdrum = Buffer.read(s, "/home/shybyte/mymusic/supercollider-songs/samples/drums/bassdrum_acoustic01.wav");
~clap = Buffer.read(s, "/home/shybyte/dev/sc/samples/drums/clap01.wav");
~snare = Buffer.read(s, "/home/shybyte/dev/sc/samples/drums/snare01.wav");
)

~bassdrum.play;
~clap.play;
~snare.play;
~bassdrum.free;
~clap.numChannels;
~clap.duration;
~clap.bufnum;
~clap.sampleRate;
~clap.query;
s.options.numBuffers;

(
SynthDef(\playbuf, { |amp =1, out=0, rate=1, buf |
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, doneAction: 2);
	sig = sig * amp * 2;
	Out.ar(out, sig);
}).add;
)

(
Synth.new(\playbuf, [\buf, ~clap.bufnum, \rate, 1]);
)


(
var p1,p2;

p1 = Pbind(
	\instrument, \playbuf,
	\dur, 0.5,
	\buf, Pseq([~bassdrum.bufnum,~bassdrum.bufnum],8)
);

p2 = Pbind(
	\instrument, \playbuf,
	\dur, 0.5,
	\buf, Pseq([\rest,~clap.bufnum],8)
);

~beatSimple = Pdef(\beatSimple, Ppar([p1,p2]));
~beatSimple.play(quant: 4);

)


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
}).add
)


(
Synth.new(\reverb, [\in,~reverbBus]);
)

(
var p1,p2,p3;
p3 = Pbind(
	\instrument, \bass,
	\dur, 0.5,
	\amp, 0.3,
	\midinote, Pseq([Pseq([53],4),Pseq([50],4),Pseq([45],4),Pseq([47,47,55,50])],1)+12
);

)

Pbindf(Pdef(\bassLine)).play;

s.plotTree;

(
~bass = { |key, baseMidiNotes |
	Pdef(key,
		Pbind(
			\instrument, \bass,
			\out, ~reverbBus,
			\dur, 0.25,
			\amp, Pseq([0.4]++(0.2!7),inf),
			//\midinote, Pseq(baseMidiNotes.collect({|midiNote| Pseq([midiNote],8)}))
			\midinote, Pseq(all {:Pseq([m],8), m <- baseMidiNotes})
	));
};
)

[1,2].collect({|midiNote| Pseq([midiNote],8)} );
[1,2].collect({|midiNote| midiNote!8} );

all {:Pseq([midiNote],8), midiNote<-[1,2]};

(
// Song

~bass_dBFG = ~bass.(\bass_dBFG,[50,46,41,43]);
~bass_hhGD = ~bass.(\bass_hhGD,[47,47,43,50]);
~bass_CB = ~bass.(\bass_CB,[48,46]);

s.freeAll;
Synth.new(\reverb, [\in,~reverbBus]);
Pseq([
	~bass_dBFG,
	Ppar([~bass_dBFG, ~beatSimple], 3),
	Ppar([~bass_hhGD, ~beatSimple], 2),
	Ppar([~bass_CB, Pfindur(2,~beatSimple)])
],inf).play;
)