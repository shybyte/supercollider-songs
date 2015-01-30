(
var readBuffer, baseDir, drumsDir, readDrum;
baseDir = thisProcess.nowExecutingPath.dirname++"/../samples/";
drumsDir = baseDir++"drums/";
readDrum = {|file| Buffer.read(s, drumsDir++file)};

~bassdrum = readDrum.("bassdrum_acoustic01.wav");
~clap = readDrum.("clap01.wav");
~snare = readDrum.("snare01.wav");

SynthDef(\playbuf, { |amp =1, out=0, rate=1, buf |
	var sig;
	sig = PlayBuf.ar(2, buf, BufRateScale.kr(buf) * rate, doneAction: 2);
	sig = sig * amp * 2;
	Out.ar(out, sig);
}).add;

)