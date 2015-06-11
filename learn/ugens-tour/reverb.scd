// FreeVerb
(
{
    // play with the room size
    var x;
    x = Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], Dust.ar(2, 0.1));
    x = Pan2.ar(x, -0.2);
    x = [x[0], DelayC.ar(x[1], 0.01, 0.01)]; // de-correlate
    FreeVerb.ar(x, 0.75, 0.9, 1);
}.scope;
)


// GVerb
(
{
    // play with the room size
    var x;
    x = Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], Dust.ar(2, 0.1));
    GVerb.ar(x, 105, 5, 0.7, 0.8, 60, 0.1, 0.5, 0.4) + x;
}.scope;
)


// FreeVerb2 - demo synthdef
(
SynthDef(\FreeVerb2x2, {|outbus, mix = 0.25, room = 0.15, damp = 0.5, amp = 1.0|
    var signal;

    signal = In.ar(outbus, 2);

    ReplaceOut.ar(outbus,
        FreeVerb2.ar( // FreeVerb2 - true stereo UGen
            signal[0], // Left channel
            signal[1], // Right Channel
            mix, room, damp, amp)); // same params as FreeVerb 1 chn version

}).add;
)

// 2ch source
(
a = SynthDef(\src2x2, {
    Out.ar(0,
        Decay.ar(Impulse.ar(1), 0.25, LFCub.ar(1200, 0, 0.1)) ! 2 +
        Pan2.ar(
            Decay.ar(Impulse.ar(1, pi), 0.1, WhiteNoise.ar(0.1)),
            LFNoise1.kr(0.5).range(-1, 1)
        )
    )
}).play
)



// kick it in
z = Synth(\FreeVerb2x2, [\outbus, 0], addAction:\addToTail)
// experiment with some settings
z.set(\room, 0.7)
z.set(\mix, 0.33)
z.set(\damp, 0.9)

