(
~thisDir = thisProcess.nowExecutingPath.dirname++"/";
(~thisDir++"drums.scd").loadPaths;

TempoClock.default.tempo = 140/120;

~song = [
	\intro, ["d B F G", 2],
	\verse, [
		["d B F G", 2],
		["h h G D", 2]
	],
	\prechorus, "C B",
	\refrain, [
		["d B F F", 2],
		["d B F G", 1],
		["d B F F", 1]
	],
	\solo, ["d B F G", 2],
	\verse_2, [
		["d B F G", 2],
		["h h G D", 1],
		["h G D C", 1]
	],
	\prechorus_2, "h",
	\refrain, \r,
	\solo, \r,
	\bridge, [
		["h h G D", 1],
		["h G D C", 1]
	],
	\refrain, \r,
	\outro, \solo
];



SynthDef(\bass, { |out=0, amp=0.3, freq=440, cutoff=1000|
	var snd,fc;
	snd = [Saw.ar(freq-0.22),Saw.ar(freq+0.22)];
	snd = snd+[Saw.ar(freq/2-0.2,),Saw.ar(freq/2+0.2)];
	snd = snd+[Saw.ar(freq/2-0.1),Saw.ar(freq/2+0.1)];
	snd = snd * EnvGen.ar(Env.linen(0.01, 0.2, 0.25), doneAction:2);
	snd = RLPF.ar(snd, cutoff,0.1);
	OffsetOut.ar(out, snd*amp*0.2);
}).add;

SynthDef(\jupiter, { |out, amp=0.3, freq=80|
	var snd,snd2,snd3;
	snd = [LFSaw.ar(freq),LFSaw.ar(freq,0.7)];
	snd3 = [LFPulse.kr(freq*2,0.7),LFPulse.ar(freq*2,0.7)]*0.5+0.5;
	snd2 = [LFSaw.ar(freq-0.7,1.2,snd3),LFSaw.ar(freq-0.8,1.3,snd3)];
	snd = snd+snd2;
	snd = snd * EnvGen.ar(Env.linen(0.01, 0.2, 0.5), doneAction:2);
	//snd = RLPF.ar(snd, 800,0.2);
	snd = RLPF.ar(snd,EnvGen.ar(Env.linen(0.01, 0.3, 0.1))*2200+300,0.1);
	OffsetOut.ar(out, snd*amp*0.2);
}).add;

~beatSimple = Pdef(\beatSimple, Ppar([
	~beat.(~bassdrum,"x...x...x...x..."),
	~beat.(~clap,    "....x.......x..."),
],4));

~notesByChordType = Dictionary[
	\dur -> [0, 4, 7],
	\moll -> [0, 3, 7],
	\power -> [0, 7],
	\flat -> [0],
];

~makeBassPattern = { |noteTypePairs|
	Pbind(
		\instrument, [\bass,\jupiter].choose,
		\dur, 0.25,
		\cutoff, Pseq(Array.fill(4,{exprand(500,4000)}),inf),
		\amp, Pseq(Array.fill(4,{exprand(0.1,1)})*0.5,inf),
		\midinote, Pseq(all {:Pseq(Array.fill(8,{~notesByChordType[noteTypePair[1]].choose})+noteTypePair[0],1), noteTypePair <- noteTypePairs})
	);
};


~noteNames = [\a, \b, \h, \c, \cis, \d, \dis, \e, \f, \fis, \g, \gis];

~chordsToPattern = {|chordsString|
	var chordNames,baseNotes;
	chordNames = chordsString.split($ );
	baseNotes = chordNames.collect({|name|
		[~noteNames.indexOf(name.toLower.asSymbol), if(name.toLower == name, \moll, \dur)];
	});
	~makeBassPattern.(baseNotes+45);
};

~patternSpecToPattern = {|patternSpec|
	case
	{patternSpec.isKindOf(String)} {
		~chordsToPattern.(patternSpec);
	}
	{patternSpec.isKindOf(Collection) && patternSpec[0].isKindOf(String)} {
		Pseq([~chordsToPattern.(patternSpec[0])], patternSpec[1]);
	}
	{patternSpec.isKindOf(Collection)} {
		Pseq(patternSpec.collect(~patternSpecToPattern));
	};
};

~playSong = { |songSpec|
	var songSequence = List[];
	var patternBySectionName = Dictionary[];
	songSpec.keysValuesDo({|sectionName, patternSpec|
		var pattern;
		[sectionName, patternSpec].postln;
		case
		{patternSpec == \r} {
			songSequence.add(patternBySectionName[sectionName]);
		}
		{patternSpec.isKindOf(Symbol)} {
			songSequence.add(patternBySectionName[patternSpec]);
		}
		{true} {
			pattern = ~patternSpecToPattern.(patternSpec);
			patternBySectionName[sectionName] = pattern;
			songSequence.add(pattern);
		};
	});
	Ppar([Pseq(songSequence),Pseq([~beatSimple],inf)]).play;
};

~playSong.(~song);

)


Array.fill(3,(1.0).linrand);

