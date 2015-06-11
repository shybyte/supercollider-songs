(
var readBuffer, baseDir, drumsDir, readDrum;
baseDir = thisProcess.nowExecutingPath.dirname++"/../samples/";
drumsDir = baseDir++"drums/";
readDrum = {|file| Buffer.read(s, drumsDir++file)};

~bassdrum = readDrum.("bassdrum_acoustic01.wav");
~clap = readDrum.("clap01.wav");
~snare = readDrum.("snare01.wav");
~zap = readDrum.("zap.wav");

SynthDef(\playbuf, { |amp =1, out=0, rate=1, buf |
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, doneAction: 2);
	sig = sig * amp * 2;
	Out.ar(out, sig);
}).add;

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

