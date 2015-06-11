(

SynthDef(\theremin, { |out=0, amp=1, freq=220, cutoff=1000|
	var snd;
	freq = Lag.kr(freq,1);
	snd = LFSaw.ar([freq+(freq*SinOsc.ar(7,0,0.01)),freq+0.01+(freq*SinOsc.ar(7.234,0,0.01))]);
	snd = RLPF.ar(snd, freq+cutoff, 0.1);
	OffsetOut.ar(out, snd*amp*0.2);
}).add;

~theremin = Synth.new(\theremin);


OSCdef.new(\oscHandlerLeftPos,
	{ |msg|
		var handPos, y, cutoff;
		handPos = msg[1..];
		y = handPos[1];
		cutoff = y.linexp(50,500,100,4000);
		[y, cutoff].postln;
		~theremin.set(\cutoff, cutoff);
	}
	, '/leap-motion/hands/left/palmPosition');



OSCdef.new(\oscHandlerRightPos,
	{ |msg|
		var handPos, y, midi, freq;
		handPos = msg[1..];
		y = handPos[1];
		midi = y.linlin(50,500,48,72).floor-12;
		midi = midi.nearestInScale(Scale.romanianMinor);
		freq = midi.midicps;
		[y,midi, freq].postln;
		~theremin.set(\freq, freq);
	}
	, '/leap-motion/hands/right/palmPosition');



)

\romanianMinor
Scale.romanianMinor.degrees;
1.nearestInScale(Scale.romanianMinor)


(
// Clean up
OSCdef.freeAll;
)






