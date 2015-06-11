MIDIClient.init;
MIDIIn.connectAll;

//MIDIClient.sources;
//MIDIIn.connect(1)
// MIDIdef.noteOn(\noteOnTest, {"key down".postln});
// stop with Ctrl+. off
//MIDIdef.noteOn(\noteOnTest, {"key down".postln}).permanent_(true);
//MIDIdef(\noteOnTest).disable;
//MIDIdef(\noteOnTest).enable;
//MIDIdef(\noteOnTest).free;
MIDIdef.freeAll

(
MIDIdef.noteOn(\noteOnTestSimple, {
	arg vel, nn, chan, src;
	[vel, nn].postln;
	{
		var sig, env;
		sig = LFTri.ar(nn.midicps)!2;
		//sig = SinOsc.ar(nn.midicps)!2;
		env = EnvGen.kr(Env.perc, doneAction:2);
		sig = sig * env * vel.linexp(1,127,0.01, 0.3);
	}.play;
});
)

x = Synth.new(\tone, [\freq , 700, \amp, 0.1, \gate, 1]);
x.set(\gate, 0);

(
SynthDef.new(\tone, {
	arg freq=440, amp = 0.3, gate=0, bend=0;
	var sig, env;
	sig = LFTri.ar(freq * bend.midiratio)!2;
	env = EnvGen.kr(Env.adsr,gate, doneAction:2);
	sig = sig * env * amp;
	Out.ar(0, sig);
}).add;

~notes = Array.newClear(128);
~bend = 8192;

MIDIdef.noteOn(\noteOnTest, {
	arg vel, nn, chan, src;
	[vel, nn].postln;
	~notes[nn] = Synth.new(\tone,
		[
			\freq , nn.midicps,
			\amp, vel.linexp(1,127,0.01, 0.3),
			\gate, 1,
			\bend, vel.linlin(0, 16383, -2, 2)
		]
	);
}).permanent_(true);

MIDIdef.noteOff(\noteOffTest, {
	arg vel, nn;
	[vel, nn].postln;
	~notes[nn].set(\gate, 0);
	~notes[nn] = nil;
}).permanent_(true);

MIDIdef.bend(\bendTest, {
	arg val, chan, src;
	[val, chan, src].postln;
	~bend = val;
	~notes.do({arg synth; synth.set(\bend, val.linlin(0, 16383, -2, 2))});
}, chan: 0).permanent_(true);

)
