// TGrains - granulation of a buffer

// read sound
b = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

(
{
    var trate, dur;
    trate = MouseY.kr(2,200,1);
    dur = 4 / trate;
    TGrains.ar(2, Impulse.ar(trate), b, 1, MouseX.kr(0,BufDur.kr(b)), dur, 0, 0.1, 2);
}.scope(2, zoom: 4);
)


// GrainSin - sine grain

( // using default window
{
    var trigrate, winsize, trig;
    trigrate = MouseX.kr(2, 120);
    winsize = trigrate.reciprocal;
    trig = Impulse.ar(trigrate);
    GrainSin.ar(2, trig, winsize, TRand.ar(440.0, 880.0, trig), LFNoise1.kr(0.2),
        -1, 0.2)
}.scope(2, zoom: 4);
)


(
var winenv;
// a custom envelope
winenv = Env([0, 1, 0], [0.5, 0.5], [8, -8]);
z = Buffer.sendCollection(s, winenv.discretize, 1);

SynthDef(\fm_grain_test, {arg gate = 1, amp = 1, envbuf;
    var pan, env, freqdev;
    // use mouse x to control panning
    pan = MouseX.kr(-1, 1);
    // use WhiteNoise and mouse y to control deviation from center pitch
    freqdev = WhiteNoise.kr(MouseY.kr(0, 400));
    env = EnvGen.kr(
        Env([0, 1, 0], [1, 1], \sin, 1),
        gate,
        levelScale: amp,
        doneAction: 2);
    Out.ar(0,
        GrainFM.ar(2, Impulse.kr(10), 0.1, 440 + freqdev, 200, LFNoise1.kr.range(1, 10),
            pan, envbuf) * env)
    }).send(s);

)

// use built-in env
x = Synth(\fm_grain_test, [\envbuf, -1])

// switch to the custom env
x.set(\envbuf, z)
x.set(\envbuf, -1);

x.set(\gate, 0);