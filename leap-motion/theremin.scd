(

SynthDef(\theremin, { |out=0, amp=1, freq=440|
	var snd;
	//freq = Lag.kr(freq,10);
	snd = SinOsc.ar(freq+(freq*SinOsc.ar(7,0,0.02)));
	OffsetOut.ar(out, snd*amp*0.2);
}).add;

~theremin = Synth.new(\theremin);


OSCdef.new(\oscHandlerLeftPos,
	{ |msg|
		var handPos, y, amp;
		handPos = msg[1..];
		y = handPos[1];
		amp = y.linexp(50,500,0.01,1);
		[y, amp].postln;
		~theremin.set(\amp, amp);
	}
	, '/leap-motion/hands/left/palmPosition');



OSCdef.new(\oscHandlerRightPos,
	{ |msg|
		var handPos, y, freq;
		handPos = msg[1..];
		y = handPos[1];
		freq = y.linexp(50,500,100,1000);
		[y, freq].postln;
		~theremin.set(\freq, freq);
	}
	, '/leap-motion/hands/right/palmPosition');



)


(
// Clean up
OSCdef.freeAll;
)






