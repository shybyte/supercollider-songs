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