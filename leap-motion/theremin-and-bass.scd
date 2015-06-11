

(


SynthDef(\bass, { |out=0, amp=0.3, freq=440|
	var snd,fc, meanFc;
	snd = [Saw.ar(freq-0.22),Saw.ar(freq+0.22)];
	snd = snd+[Saw.ar(freq/2-0.2,),Saw.ar(freq/2+0.2)];
	snd = snd+[Saw.ar(freq/2-0.1),Saw.ar(freq/2+0.1)];
	snd = snd * EnvGen.ar(Env.linen(0.01, 0.2, 0.25), doneAction:2);
	snd = RLPF.ar(snd, 1000,0.1);
	OffsetOut.ar(out, snd*amp*0.2);
}).add;


SynthDef(\theremin, { |out=0, amp=1, freq=220, mod=0, vibFreq=7, freqMul=1|
	var snd,modP, mouseX;
	freq = Lag.kr(freq*freqMul,1);
	modP = SinOsc.ar(freq/2,mul: Lag.kr(mod,1));
	snd = SinOsc.ar([freq+(freq*SinOsc.ar(vibFreq,0,0.02)),freq+1+(freq*SinOsc.ar(vibFreq+0.234,0,0.02))],modP);
	snd = snd + DelayL.ar(snd, 0.1, 0.1);
	snd = FreeVerb.ar(snd);
	OffsetOut.ar(out, snd*amp*0.2);
}).add;
)






(
~leftFingerDown = 0;
~leftHandPos = 0;

// ->
~bassNote = 48;


~playBass = {
	var lage = ~leftHandPos[1].linlin(50,500,0,3).floor;
	lage.postln;
	~bassNote = Scale.romanianMinor[~leftFingerDown+(lage*5)]+48;
};




Pdef(\bassLine,
	Pbind(
		\instrument, \bass,
		\dur, 0.25,
		\amp, Pseq([0.4]++(0.3!7),inf),
		\midinote, Pfunc({ ~bassNote })+Pseq([0,12],inf)
)).play;



~theremin = Synth.new(\theremin);

OSCdef.new(\oscHandlerLeftFingerDirection,
	{ |msg|
		var fingersDirection, fingerDownIndex;
		fingersDirection = msg[1..];
		fingerDownIndex = fingersDirection[[1,4,7,10,13]].minIndex;
		~leftFingerDown = fingerDownIndex;
		~playBass.();
	}
	, '/leap-motion/hands/left/fingers/direction'
);

OSCdef.new(\oscHandlerLeftPos,
	{ |msg|
		var handPos, y, midi;
		handPos = msg[1..];
		~leftHandPos = handPos;
		//midi = y.linlin(50,500,1,10).floor;
		//midi = midi.nearestInScale(Scale.romanianMinor);
		//midi.postln;
		//~leftFingerDown = midi;
		//~playBass.();
		//[y, amp].postln;
	}
	, '/leap-motion/hands/left/palmPosition'
);



OSCdef.new(\oscHandlerRightPos,
	{ |msg|
		var handPos, y, midi, freq;
		handPos = msg[1..];
		y = handPos[1];
		midi = y.linlin(50,500,48,60).floor+12;
		midi = midi.nearestInScale(Scale.romanianMinor);
		//midi.postln;
		freq = midi.midicps;
		//[y,midi, freq].postln;
		~theremin.set(\freq, freq);
	}
	, '/leap-motion/hands/right/palmPosition');

OSCdef.new(\oscHandlerRightFingers,
	{ |msg|
		var fingerExtended, freqMul;
		fingerExtended = msg[1..];
		freqMul = if (fingerExtended[4] == 1, 1 ,2);
		~theremin.set(\freqMul, freqMul);
	}
	, '/leap-motion/hands/right/fingers/extended');


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
		//[y, mod].postln;
		~theremin.set(\vibFreq, mod);
	}
	, '/leap-motion/hands/right/middleFinger/direction'
 );

)


\romanianMinor
Scale.romanianMinor.degrees;
1.nearestInScale(Scale.romanianMinor)


(
// Clean up
OSCdef.freeAll;
)


t = (Pfunc({ ~bassNote })+Pseq([1,2],inf)).asStream;
t.next;


a = [1,2,3,4,5,6];
a[[1,4]].minIndex;

