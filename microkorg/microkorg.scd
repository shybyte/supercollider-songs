(
MIDIClient.init;
MIDIIn.connectAll;
)

(

~makeSynth = { |name, osc|
 	"test".postln;
 	SynthDef.new(\instr, { |freq=440, amp = 0.3, gate=0, bend=0 |
 	  var sig, env;
 	  sig = osc.ar(freq * bend.midiratio)!2;
 	  env = EnvGen.kr(Env.adsr,gate, doneAction:2);
 	  sig = sig * env * amp;
 	  Out.ar(0, sig);
 	}).add;
 };

~makeSynth.(\instr, LFTri);
~makeSynth.(\instr, SinOsc);

~notes = Array.newClear(128);
~bend = 8192;

MIDIdef.noteOn(\noteOn, {
	arg vel, nn, chan, src;
	[vel, nn].postln;
	~notes[nn] = Synth.new(\instr,
		[
			\freq , nn.midicps,
			\amp, vel.linexp(1,127,0.01, 0.3),
			\gate, 1,
			\bend, vel.linlin(0, 16383, -2, 2)
		]
	);
}).permanent_(true);

MIDIdef.noteOff(\noteOff, {
	arg vel, nn;
	[vel, nn].postln;
	~notes[nn].set(\gate, 0);
	~notes[nn] = nil;
}).permanent_(true);

MIDIdef.bend(\bend, {
	arg val, chan, src;
	[val, chan, src].postln;
	~bend = val;
	~notes.do({arg synth; synth.set(\bend, val.linlin(0, 16383, -2, 2))});
}, chan: 0).permanent_(true);

)
