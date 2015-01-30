(
~thisDir = thisProcess.nowExecutingPath.dirname++"/";
Buffer.freeAll;
(~thisDir++"drums.scd").loadPaths;
(~thisDir++"synth-def.scd").loadPaths;

~bass = { |key, baseMidiNotes |
	Pdef(key,
		Pbind(
			\instrument, \bass,
			\out, ~reverbBus,
			\dur, 0.25,
			\amp, Pseq([0.4]++(0.2!7),inf),
			\midinote, Pseq(all {:Pseq([m],8), m <- baseMidiNotes})
	));
};
)


(
// Song

~bass_dBFG = ~bass.(\bass_dBFG,[50,46,41,43]);
~bass_hhGD = ~bass.(\bass_hhGD,[47,47,43,50]);
~bass_CB = ~bass.(\bass_CB,[48,46]);

s.freeAll;
Synth.new(\reverb, [\in,~reverbBus]);
Pseq([
	~bass_dBFG,
	Ppar([~bass_dBFG, ~beatSimple], 3),
	Ppar([~bass_hhGD, ~beatSimple], 2),
	Ppar([~bass_CB, Pfindur(2,~beatSimple)])
],inf).play;

)