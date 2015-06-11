(


SynthDef(\theremin, { |out=0, amp=1, freq=220, mod=0, vibFreq=7|
	var snd,modP, mouseX;
	freq = Lag.kr(freq,1);
	modP = SinOsc.ar(freq/2,mul: Lag.kr(mod,1));
	snd = SinOsc.ar([freq+(freq*SinOsc.ar(vibFreq,0,0.02)),freq+1+(freq*SinOsc.ar(vibFreq+0.234,0,0.02))],modP);
	snd = snd + DelayL.ar(snd, 0.1, 0.1);
	snd = FreeVerb.ar(snd);
	OffsetOut.ar(out, snd*amp*0.2);
}).add;
)

(
~theremin = Synth.new(\theremin);



OSCdef.new(\oscHandlerLeftPos,
	{ |msg|
		var handPos, y, amp;
		handPos = msg[1..];
		y = handPos[1];
		amp = y.linlin(50,500,0.01,1);
		//[y, amp].postln;
		~theremin.set(\amp, amp);
	}
	, '/leap-motion/hands/left/palmPosition'
);

 OSCdef.new(\oscHandlerRightIndexFingerDirection,
 	{ |msg|
 		var handPos, y, mod;
 		handPos = msg[1..];
 		y = handPos[1];
		mod = y.linlin(-1,-0.25,10,0);
		//[y, mod].postln;
		~theremin.set(\mod, mod);
	}
	, '/leap-motion/hands/right/indexFinger/direction'
);

OSCdef.new(\oscHandlerRightMiddleFingerDirection,
	{ |msg|
		var handPos, y, mod;
		handPos = msg[1..];
		y = handPos[1];
		mod = y.linlin(-1,-0.25,10,0);
		[y, mod].postln;
		~theremin.set(\vibFreq, mod);
	}
	, '/leap-motion/hands/right/middleFinger/direction'
 );


OSCdef.new(\oscHandlerRightPos,
	{ |msg|
		var handPos, y, midi, freq;
		handPos = msg[1..];
		y = handPos[1];
		midi = y.linlin(50,500,48,72).floor+12;
		midi = midi.nearestInScale(Scale.romanianMinor);
		freq = midi.midicps;
		//[y,midi, freq].postln;
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






