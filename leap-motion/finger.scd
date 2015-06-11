true!5;
~cutoffLeft = 500;
~cutoffRight = 500;

(
OSCdef.new(\oscHandlerLeftPos,
	{ |msg|
		var baseNote,handPos, index, amp, cutoff;
		handPos = msg[1..];
		~cutoffLeft = handPos[1].abs()*10;
		~cutoffLeft.postln;
	}
	, '/leap-motion/hands/left/palmPosition');



OSCdef.new(\oscHandlerRightPos,
	{ |msg|
		var baseNote,handPos, index, amp, cutoff;
		handPos = msg[1..];
		~cutoffRight = handPos[1].abs()*10;
		~cutoffRight.postln;
	}
	, '/leap-motion/hands/right/palmPosition');
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
			//("Finger"+i+"="+fingerState).postln;
			if((fingerState != lastFingerDown[i]) && (fingerState == 1),{
				//("Finger is down now"+i).postln;
				Synth(\jupiter,[
					\freq, (scale[i]+45).midicps,
					\cutoff, ~cutoffLeft
				])
			})
		});
		lastFingerDown = fingerDown;
	}
	, '/leap-motion/hands/left/fingerDown');
)

(
var scale, lastFingerDown;
scale = [8,10,12, 14, 15];
lastFingerDown = 0!5;
OSCdef.new(\oscHandlerRight,
	{ |msg|
		var baseNote,fingerDown;
		msg.postln;
		fingerDown = msg[1..].reverse;
		fingerDown.do ({ |fingerState, i|
			//("Finger"+i+"="+fingerState).postln;
			if((fingerState != lastFingerDown[i]) && (fingerState == 1),{
				//("Finger is down now"+i).postln;
				Synth(\jupiter,[
					\freq, (scale[i]+45).midicps,
					\cutoff, ~cutoffRight
				])
			})
		});
		lastFingerDown = fingerDown;
	}
	, '/leap-motion/hands/right/fingerDown');
)


OSCdef.freeAll;


(
SynthDef(\jupiter, { |out, amp=0.3, freq=80, cutoff=100|
	var snd,snd2,snd3;
	snd = LFSaw.ar([freq,freq-0.2]);
	snd = snd * EnvGen.ar(Env.linen(0.01, 0.4, 0.5), doneAction:2);
	snd = RLPF.ar(snd,cutoff+100,0.2);
	OffsetOut.ar(out, snd*amp*0.5);
}).add;
)

