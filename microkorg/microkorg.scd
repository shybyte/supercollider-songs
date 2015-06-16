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
~notes = Array.newClear(128);
~bend = 8192;
~lastNote = 50;


~makeSynth = { |name, specArg|
	var decayTime = 0.01;
	var spec = ~defaultSpec.merge(specArg, {|a,b| b}) ;
	var osc1 = ~oscByName[spec.osc1Wave];
	spec.postln;
 	SynthDef.new(\instr, { |freq=440, amp = 0.3, gate=0, bend=0 ,lastNote |
		var freqLine = XLine.kr(lastNote.midicps, freq, 0.2);
		var phaserLFO = SinOsc.kr(0.001*spec.modFxLfoSpeed, 0, 0.003, 0.007);
		var phaser2LFO = SinOsc.kr(spec.modFxLfoSpeed/20, 0, freq*6, 440+freq*4);
		var sig, env;
		var sig2, sig3;
		sig = osc1.ar(freqLine * (~bend-8192).midiratio)!2;
		env = EnvGen.kr(Env.adsr(spec.attack/10, spec.decay/10, spec.sustain/127, spec.releaseTime/10),gate, doneAction:2);
		sig = sig * env;
		sig2 = 0;
		sig3 = sig;
		8.do { |x|
			sig3 = AllpassC.ar(sig3, 0.07, phaserLFO, decayTime);
			sig2 = sig2 + sig3;
		};
		sig = (sig + (spec.modFxEffectDepth/256*sig2));
		sig = RLPF.ar(sig, phaser2LFO, 0.1);
		sig = (LPF.ar(sig, 2200)*4+sig)/5;
		Out.ar(0, sig*amp/10);
 	}).add;
 };

~makeSynth.(\instr, (
	osc1Wave: \saw,
	attack: 5,
	releaseTime: 15,
	modFxLfoSpeed: 7,
	modFxEffectDepth: 127
));
//~makeSynth.(\instr, SinOsc);

MIDIdef.noteOn(\noteOn, {
	arg vel, nn, chan, src;
	[vel, nn].postln;
	~notes[nn] = Synth.new(\instr,
		[
			\freq , nn.midicps,
			\lastNote, ~lastNote,
			\amp, vel.linexp(1,127,0.01, 0.3),
			\gate, 1,
			\bend, vel.linlin(0, 16383, -2, 2)
		]
	);
	~lastNote = nn;
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

8.do({|x| x.postln})
