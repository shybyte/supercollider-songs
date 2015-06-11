NetAddr.langPort;
NetAddr.localAddr;
OSCFunc.trace(true);
OSCFunc.trace(false);

(
var scale, last;
scale = [0,3,5,7,8,10];
last= -1;
OSCdef.new(\oscHandler,
	{ |msg|
		var baseNote,handPos, index, amp, cutoff;
		msg.postln;
		handPos = msg[1..];
		index = ((handPos[1]/100).round(1)-1).max(0);
		amp = 5/(handPos[0].abs()+10);
		cutoff = handPos[2].abs()*20;
		baseNote = scale[index % scale.size];
		if( last != baseNote, {
			[baseNote, amp,cutoff].postln;
			last = baseNote;
			Pdefn(\baseNote, Pseq([baseNote],4));
		});
		Pdefn(\cutoff, cutoff);
		//Pdefn(\amp, amp);
	}
	, '/leap-motion/hands/left/palmPosition');
)

(
var scale, last;
scale = [0,2,3,5,7,8,10,11];
last= -1;
OSCdef.new(\oscHandlerRight,
	{ |msg|
		var baseNote,handPos, index, amp, cutoff;
		msg.postln;
		handPos = msg[1..];
		index = ((handPos[1]/50).round(1)-1).max(0);
		baseNote = scale[index % scale.size]+50;
		baseNote.midicps.postln;
		c.set(\freq, baseNote.midicps);
	}
	, '/leap-motion/hands/right/palmPosition');
)

(
var scale, last;
scale = [0,2,3,5,7,8,10,11];
last= -1;
OSCdef.new(\oscHandlerLeft,
	{ |msg|
		var baseNote,handPos, index, amp, cutoff;
		msg.postln;
		handPos = msg[1..];
		index = ((handPos[1]/50).round(1)-1).max(0);
		baseNote = scale[index % scale.size]+50;
		baseNote.midicps.postln;
		d.set(\freq, baseNote.midicps);
	}
	, '/leap-motion/hands/left/palmPosition');
)

OSCdef.freeAll;

c = Synth(\cello);
d = Synth(\cello);



(
	b = Bus.control(s, 1);
)
b.index;
b.set(100);
Pdefn

(
Pdef(\test,
	Pbind(
		\instrument, \jupiter,
		\dur, 0.25,
		\amp, Pdefn(\amp, 0.1),
		\cutoff, Pdefn(\cutoff, 1000),
		\midinote, Pseq([Pseq([50,57,62,69])+Pdefn(\baseNote,Pseq([0],4))],inf)
)).play(quant: 1);
//c = Synth(\cello);
)

Synth.new(\jupiter,[\freq,200]);

Pdefn(\baseNote, Pseq([1],4)).quant_(2);
Pdefn(\baseNote, Pseq([2],4)).quant_(2);
Pdefn(\baseNote, Pseq([3],4)).quant_(2);
Pdefn(\baseNote, Pseq([4],4)).quant_(2);


Pdefn(\cutoff, 1000);

(
SynthDef(\jupiter, { |out, amp=0.3, freq=80, cutoff=2200|
	var snd,snd2,snd3;
	snd = LFSaw.ar([freq,freq-0.2]);
	snd = snd * EnvGen.ar(Env.linen(0.01, 0.2, 0.5), doneAction:2);
	snd = RLPF.ar(snd,cutoff+300,0.3);
	OffsetOut.ar(out, snd*amp*0.5);
}).add;

SynthDef(\cello, { |out, amp=0.1, freq=440, gate=1, lastNote, midinote|
	var snd,freqLine,lastFreq,fmod,amod;
	freqLine = freq;
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


