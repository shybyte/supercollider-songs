// LF "Low Frequency" Noise Generators.

{ LFClipNoise.ar(MouseX.kr(200, 10000, 1), 0.125) }.scope(1);

//use as frequency control
(
SynthDef("help-LFClipNoise", { arg out=0;
    Out.ar(out,
        SinOsc.ar(
            LFClipNoise.ar(4, 200, 600),
            0, 0.2
        )
    )
}).play;
)

{ LFNoise0.ar(MouseX.kr(200, 10000, 1), 0.25) }.scope(1);
{ LFNoise1.ar(MouseX.kr(200, 10000, 1), 0.25) }.scope(1); // interpolated
{ LFNoise2.ar(MouseX.kr(200, 10000, 1), 0.25) }.scope(1); // quadratic interpolation

// Broad Spectrum Noise Generators

{ ClipNoise.ar(0.2) }.scope(1);
{ WhiteNoise.ar(0.2) }.scope(1);
{ PinkNoise.ar(0.4) }.scope(1);
{ BrownNoise.ar(0.2) }.scope(1);
{ GrayNoise.ar(0.2) }.scope(1);


// Impulse Noise Generators
{ Dust.ar(MouseX.kr(1,10000,1), 0.4) }.scope(1, zoom:4);
{ Dust2.ar(MouseX.kr(1,10000,1), 0.4) }.scope(1, zoom:4);

// Chaotic Noise Generators