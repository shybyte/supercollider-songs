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

~jupiter = { |key, baseMidiNotes |
	Pdef(key,
		Pbind(
			\instrument, \jupiter,
			\dur, 0.25,
			\midinote, Pseq(all {:Pser([m[0]-12,m[0],m[0]+12],m[1]), m <- baseMidiNotes})
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

~beatSimple = Pdef(\beatSimple, Ppar([
	~beat.(~bassdrum,"x...x...x...x..."),
	~beat.(~clap,    "....x.......x..."),
],4));
//~beatSimple.play(quant: 4);


~beatChorus = Pdef(\beatChorus, Ppar([
	~beat.(~bassdrum,"x.x...x.x.x...x."),
	~beat.(~clap,    "....x.......x..."),
	~beat.(~zap,     "..x...x..x.x.x.x"),
	~beat.(~snare,   "....x..x....x.x.")
],4));
//~beatChorus.play(quant: 0);


{
var midiNotes =[43,41,40 ,43,41,40 ,45 ,46,45,43, 43,41,40 ,43,41,40 ,36 ,35]+12;
var dur =[      6,6,4,    6,6,4    ,16 ,6,4,6,    6,6,4,    6,6,4    ,16 ,16];
var leg =[      6,6,4,    6,6,4    ,5  ,6,4,6,    6,6,4,    6,6,4    ,5  ,5];
~celloSolo = Pdef(\celloSolo1,
	Pbind(
		\instrument, \cello,
		\dur, Pseq(dur/8,1),
		\legato, Pseq(leg/5,1),
		\lastNote, Pseq(midiNotes.rotate(1),1),
		\midinote, Pseq(midiNotes,1)
));
}.value

)


(
// Song

~bass_dBFG = ~bass.(\bass_dBFG,[50,46,41,43]);
~bass_hhGD = ~bass.(\bass_hhGD,[47,47,43,50]);
~bass_hGDC = ~bass.(\bass_hGDC,[47,43,50,48]);
~bass_B = ~bass.(\bass_h,[46]);
~bass_CB = ~bass.(\bass_CB,[48,46]);
~bass_dBFF = ~bass.(\bass_dBFF,[50,46,41,41]);

~jupiter_dBFF = ~jupiter.(\jupiter_dBFF,[[50,8], [46,8], [41,16]]);
~jupiter_dBFG = ~jupiter.(\jupiter_dBFG,[[50,8], [46,8], [41,8], [43,8]]);

s.freeAll;
Synth.new(\reverb, [\in,~reverbBus]);
Pseq([
	~bass_dBFG,
	Ppar([~bass_dBFG, ~beatSimple], 3),
	Ppar([~bass_hhGD, ~beatSimple], 2),
	Ppar([~bass_CB, Pfindur(2,~beatSimple)]),

	// Chorus
	Ppar([~bass_dBFF, ~jupiter_dBFF, ~beatChorus], 2),
	Ppar([~bass_dBFG, ~jupiter_dBFG, ~beatChorus], 1),
	Ppar([~bass_dBFF, ~jupiter_dBFF, Pfindur(6,~beatChorus)], 1),

	// Cello Solo
	Ppar([
		Pseq([
			Ppar([~bass_dBFG]),
			Ppar([~bass_dBFG, ~beatSimple])
		]),
		~celloSolo], 1),

	// Verse 2
	Ppar([~bass_dBFG, ~beatSimple], 2),
	Ppar([~bass_hhGD, ~beatSimple], 1),
	Ppar([~bass_hGDC, ~beatSimple], 1),
	Ppar([~bass_h]),

	// // Chorus 2
	Ppar([~bass_dBFF, ~jupiter_dBFF, ~beatChorus], 2),
	Ppar([~bass_dBFG, ~jupiter_dBFG, ~beatChorus], 1),
	Ppar([~bass_dBFF, ~jupiter_dBFF, ~beatChorus], 1),

	// Cello Solo
	Ppar([Ppar([~bass_dBFG, ~beatChorus],2), ~celloSolo], 1),

	//Bridge
	Ppar([~bass_hhGD], 1),
	Ppar([~bass_hGDC], 1),

	// Chorus 3
	Ppar([
		Pseq([
			Ppar([~bass_dBFF, ~jupiter_dBFF, ~beatChorus], 2),
			Ppar([~bass_dBFG, ~jupiter_dBFG, ~beatChorus], 1),
			Ppar([~bass_dBFF, ~jupiter_dBFF, ~beatChorus], 1),
		]),
		Pseq([~celloSolo], 2)], 1),

	// Outro
	Ppar([Ppar([~bass_dBFG],2), ~celloSolo], 1),

],1).play;

)