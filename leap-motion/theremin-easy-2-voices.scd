(

SynthDef(\theremin, { |out=0, amp=1, freq=440|
	var snd;
	freq = Lag.kr(freq,1);
	snd = SinOsc.ar([freq+(freq*SinOsc.ar(7,0,0.02)),freq+1+(freq*SinOsc.ar(7.234,0,0.02))]);
	OffsetOut.ar(out, snd*amp*0.2);
}).add;

~thereminLeft = Synth.new(\theremin);
~thereminRight = Synth.new(\theremin);


OSCdef.new(\oscHandlerLeftPos,
	{ |msg|
		var handPos, y, midi, freq;
		handPos = msg[1..];
		y = handPos[1];
		midi = y.linlin(50,500,48,60).floor;
		midi = midi.nearestInScale(Scale.romanianMinor);
		freq = midi.midicps;
		[y,midi, freq].postln;
		~thereminLeft.set(\freq, freq);
	}
	, '/leap-motion/hands/left/palmPosition');



OSCdef.new(\oscHandlerRightPos,
	{ |msg|
		var handPos, y, midi, freq;
		handPos = msg[1..];
		y = handPos[1];
		midi = y.linlin(50,500,60,72).floor;
		midi = midi.nearestInScale(Scale.romanianMinor);
		freq = midi.midicps;
		[y,midi, freq].postln;
		~thereminRight.set(\freq, freq);
	}
	, '/leap-motion/hands/right/palmPosition');

)




(
// Clean up
OSCdef.freeAll;
)






