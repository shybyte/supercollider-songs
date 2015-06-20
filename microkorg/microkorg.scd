(
MIDIClient.init;
MIDIIn.connectAll;

s.newBusAllocators;
s.freeAll;

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
 	SynthDef.new(\instr, { |freq=440, amp = 0.3, gate=0, bend=0 ,lastNote, out=0 |
		var feedback;
		var freqLine = XLine.kr(lastNote.midicps, freq, 0.2);
		var phaserLFO = SinOsc.kr(0.001*spec.modFxLfoSpeed, 0, 0.003, 0.007);
		var phaser2LFO = SinOsc.kr(spec.modFxLfoSpeed/20, 0, freq*6, 440+freq*4);
		var sig, env;
		var sig2, sig3;
		sig = [osc1.ar(freqLine * (~bend-8192).midiratio),osc1.ar((freqLine+0.3) *
			(~bend-8192).midiratio)];
		sig = (sig + [osc1.ar(freqLine/2-0.5),osc1.ar(freqLine/2+0.5)])/1;
		env = EnvGen.kr(Env.adsr(spec.attack/10, spec.decay/10, spec.sustain/127, spec.releaseTime/10),gate, doneAction:2);
		//env = EnvGen.kr(Env.adsr(0, 0, 1, 0.4),gate, doneAction:0);
		sig = sig * env;

		//phaser
		sig2 = 0;
		sig3 = sig + (LocalIn.ar(2)*0.1);
		8.do { |x|
			sig3 = AllpassC.ar(sig3, 0.07, phaserLFO, decayTime);
			sig2 = sig2 + sig3;
		};
		LocalOut.ar(sig3);
		sig = (sig + (spec.modFxEffectDepth/256*sig2));
		sig = RLPF.ar(sig, phaser2LFO, 0.1);
		sig = (LPF.ar(sig, 2200)*4+sig)/5/2;

		sig = (sig + (BPeakEQ.ar(sig, 460, 4, 12, 0.4)))/4;


		Out.ar(out, sig*amp);
 	}).add;

	SynthDef.new(\delay, { |in, amp=1 |
	    var sig = In.ar(in,2);
		var feedback = LocalIn.ar(2);
		sig = feedback*0.3 + sig;
		LocalOut.ar(DelayC.ar(sig, 1, 0.5));
		Out.ar(0, sig*amp);
	}).add;

	SynthDef(\flanger, { arg out=0, in=0, delay=0.1, depth=0.08, rate=0.03, fdbk=0.5, decay=0;
		var input, maxdelay, maxrate, dsig, mixed, local;
		maxdelay = 0.013;
		maxrate = 10.0;
		input = In.ar(in, 2);
		local = LocalIn.ar(2);
		dsig = AllpassL.ar( // the delay (you could use AllpassC (put 0 in decay))
			input + (local * fdbk),
			maxdelay * 2,
			LFPar.kr( // very similar to SinOsc (try to replace it) - Even use LFTri
				rate * maxrate,
				0,
				depth * maxdelay,
				delay * maxdelay),
			decay);
		mixed = input + (dsig*0.9);
		LocalOut.ar(mixed);
		Out.ar(out, mixed);
	}).add;

	~delayBus = Bus.audio(s,2);
	~delay = Synth.new(\delay, [\in, ~delayBus]);

	~flangerBus = Bus.audio(s,2);
	~flanger = Synth.new(\flanger, [\in, ~flangerBus, \out, ~delayBus]);
 };




~makeSynth.(\instr, (
	osc1Wave: \saw,
	attack: 5,
	releaseTime: 15,
	modFxLfoSpeed: 7,
	modFxEffectDepth: 127
));

MIDIdef.noteOn(\noteOn, {
	arg vel, nn, chan, src;
	[vel, nn].postln;
	~notes[nn] = Synth.new(\instr,
		[
			//\out, ~delayBus,
			\out, ~flangerBus,
			\freq , nn.midicps,
			\lastNote, ~lastNote,
			\amp, 0.15, //vel.linexp(1,127,0.01, 0.3),
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

s.plotTree;
s.me
~delayBus;
[0.12,0.25,0.5,1].linlin(0.12,1,0.03,0.9)

(
{ // toy with boost/cut
BPeakEQ.ar(
	LFSaw.ar(220),
    MouseX.kr(20, 20000, \exponential),
    12, // rq
    MouseY.kr(12.0, -12.0, \linear),
    1); // mul
}.play

)

