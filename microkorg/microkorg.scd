(
MIDIClient.init;
MIDIIn.connectAll;
)

(

~oscByName = ( saw: LFSaw );
~defaultSpec = (
	osc1Wave: \saw,
	attack: 0,
	decay: 64,
	sustain: 127,
	releaseTime: 0
);


~makeSynth = { |name, specArg|
	var spec = ~defaultSpec.merge(specArg, {|a,b| b}) ;
	var osc1 = ~oscByName[spec.osc1Wave];
	spec.postln;
 	SynthDef.new(\instr, { |freq=440, amp = 0.3, gate=0, bend=0 |
 	  var sig, env;
		sig = osc1.ar(freq * (~bend-8192).midiratio)!2;
	  env = EnvGen.kr(Env.adsr(spec.attack/10, spec.decay/10, spec.sustain/127, spec.releaseTime/10),gate, doneAction:2);
 	  sig = sig * env;
	  sig = sig + AllpassL.ar(sig, 0.4, SinOsc.ar(0.02, 0, 0.005, 0.005), 0);
	  sig = sig * amp;
 	  Out.ar(0, sig);
 	}).add;
 };

~makeSynth.(\instr, (
	osc1Wave: \saw,
	attack: 5,
	releaseTime: 15
));
//~makeSynth.(\instr, SinOsc);

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


