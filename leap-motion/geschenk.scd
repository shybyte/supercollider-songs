
~bassNote = 48;
NetAddr.langPort;

(
Pdef(\bassLine,
	Pbind(
		\instrument, \bass,
		\dur, 0.25,
		\amp, Pseq([0.4]++(0.2!7),inf),
		\midinote, Pseq([Pfunc({ ~bassNote })],inf)
)).play;
)



(
var scale, lastFingerDown;
scale = [0,2,3,5,7,8,10,11];
lastFingerDown = 0!5;
OSCdef.new(\oscHandlerLeft,
	{ |msg|
		var baseNote,fingerDown;
		msg.postln;
		fingerDown = msg[1..];
		fingerDown.do ({ |fingerState, i|
			("Finger"+i+"="+fingerState).postln;
			if((fingerState != lastFingerDown[i]) && (fingerState == 1),{
				("Finger is down now"+i).postln;
				~bassNote = (scale[i]+45);
			})
		});
		lastFingerDown = fingerDown;
	}
	, '/leap-motion/hands/left/fingerDown');

)



(
SynthDef(\bass, { |out=0, amp=0.3, freq=440|
	var snd,fc, meanFc;
	meanFc = Rand(400,2000);
	fc = SinOsc.kr(Rand(1,2),0,Rand(0,meanFc*0.7), meanFc);
	snd = [Saw.ar(freq-0.22),Saw.ar(freq+0.22)];
	snd = snd+[Saw.ar(freq/2-0.2,),Saw.ar(freq/2+0.2)];
	snd = snd+[Saw.ar(freq/2-0.1),Saw.ar(freq/2+0.1)];
	snd = snd * EnvGen.ar(Env.linen(0.01, 0.2, 0.25), doneAction:2);
	snd = RLPF.ar(snd, fc,Rand(0.01,0.2));
	OffsetOut.ar(out, snd*amp*0.2);
}).add;
)

Synth.new(\bass);