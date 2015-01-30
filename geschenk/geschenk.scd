(
TempoClock.default.tempo = 140/120;    // 2 beats/sec, or 120 BPM
~reverbBus = 40;
Buffer.freeAll;
~thisDir = thisProcess.nowExecutingPath.dirname++"/";
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

~beat = { | buffer,beatString ,dur=0.125|
	var durArray,buf,beatArray;
	beatArray = Array.newFrom(beatString);
	buf = beatArray.collect({|s|
		if (s==$x, {buffer.bufnum},{\rest})
	});
	durArray = beatArray.collect({|s|
		if (s==$x, {dur},{Rest(dur)})
	});
	Pbind(
		\instrument, \playbuf,
		\dur, Pseq(durArray,1),
		\buf, Pseq(buf,1)
	);
};

)


(
~beatSimple = Pdef(\beatSimple, Ppar([
	~beat.(~bassdrum,"x...x...x...x..."),
	~beat.(~clap,    "....x.......x..."),
],4));
~beatSimple.play(quant: 4);
)


(
~beatChorus = Pdef(\beatChorus, Ppar([
	~beat.(~bassdrum,"x.x...x.x.x...x."),
	~beat.(~clap,    "....x.......x..."),
	~beat.(~zap,     "..x...x..x.x.x.x"),
	~beat.(~snare,   "....x..x....x.x.")
],4));
~beatChorus.play(quant: 0);
)


(
// Song

~bass_dBFG = ~bass.(\bass_dBFG,[50,46,41,43]);
~bass_hhGD = ~bass.(\bass_hhGD,[47,47,43,50]);
~bass_CB = ~bass.(\bass_CB,[48,46]);
~bass_dBFF = ~bass.(\bass_dBFF,[50,46,41,41]);


//s.freeAll;
Synth.new(\reverb, [\in,~reverbBus]);
Pseq([
	~bass_dBFG,
	Ppar([~bass_dBFG, ~beatSimple], 3),
	Ppar([~bass_hhGD, ~beatSimple], 2),
	Ppar([~bass_CB, Pfindur(2,~beatSimple)]),
	// Chorus
	Ppar([~bass_dBFF, ~beatChorus], 2),
	Ppar([~bass_dBFG, ~beatChorus], 1),
	Ppar([~bass_dBFF, ~beatChorus], 1),
],inf).play;

)