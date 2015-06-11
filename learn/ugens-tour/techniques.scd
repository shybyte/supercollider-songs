// Artificial Space

{ var x; x = BrownNoise.ar(0.2); [x,x] }.scope(2); // correlated
{ {BrownNoise.ar(0.2)}.dup }.scope(2); // not correlated

// correlated
{ var x; x = LPF.ar(BrownNoise.ar(0.2), MouseX.kr(100,10000)); [x,x] }.scope(2);
// not correlated
{ LPF.ar({BrownNoise.ar(0.2)}.dup, MouseX.kr(100,10000)) }.scope(2);

// correlated
(
{ var x;
    x = Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar(7e-3));
    [x,x]
}.scope(2))
// not correlated
{ Klank.ar(`[[200, 671, 1153, 1723], nil, [1, 1, 1, 1]], PinkNoise.ar([7e-3,7e-3])) }.scope(2);

// two waves mixed together coming out both speakers
{ var x; x = Mix.ar(VarSaw.ar([100,101], 0, 0.1, 0.2)); [x,x] }.scope(2);
// two waves coming out each speaker independantly
{ VarSaw.ar([100,101], 0, 0.1, 0.2 * 1.414) }.scope(2); // * 1.414 to compensate for power

// delays as cues to direction
// mono
{ var x; x = LFTri.ar(1000,0,Decay2.ar(Impulse.ar(4,0,0.2),0.004,0.2)); [x,x]}.scope(2);

// inter-speaker delays
(
{ var x; x = LFTri.ar(1000,0,Decay2.ar(Impulse.ar(4,0,0.2),0.004,0.2));
    [DelayC.ar(x,0.01,0.01),DelayC.ar(x,0.02,MouseX.kr(0.02, 0))]
}.scope(2);
)

(
// mixing two delays together
// you hear a phasing sound but the sound is still flat.
{ var x; x = BrownNoise.ar(0.2);
    x = Mix.ar([DelayC.ar(x,0.01,0.01),DelayC.ar(x,0.02,MouseX.kr(0,0.02))]);
    [x,x]
}.scope(2);
)

(
// more spatial sounding. phasing causes you to perceive directionality
{ var x; x = BrownNoise.ar(0.2);
    [DelayC.ar(x,0.01,0.01),DelayC.ar(x,0.02,MouseX.kr(0.02, 0))]
}.scope(2);
)



// Parallel Structures

(
{
    // mixing sine oscillators in parallel
    var n = 16; // number of structures to make
    // mix together  parallel structures
    Mix.fill(n,
            // this function creates an oscillator at a random frequency
            { FSinOsc.ar(200 + 1000.0.rand) }
    ) / (2*n)            // scale amplitude
}.scope(1);
)

(
{
    // mixing sine oscillators in parallel
    var n = 16; // number of structures to make
    // mix together  parallel structures
    Mix.fill(n,
            // this function creates an oscillator at a random frequency
            { FSinOsc.ar(200 + 1000.0.rand + [0, 0.5]) }
    ) / (2*n)            // scale amplitude
}.scope(2);
)

(
{
    // mixing sine oscillators in parallel
    var n = 16; // number of structures to make
    // mix together  parallel structures
    Mix.fill(n,
            {
                var amp;
                amp = FSinOsc.kr(exprand(0.1,1),2pi.rand).max(0);
                Pan2.ar(
                    FSinOsc.ar(exprand(100,1000.0), 0, amp),
                    1.0.rand2)
            }
    ) / (2*n)            // scale amplitude
}.scope(2);
)

(
{
    var n;
    n = 8; // number of 'voices'
    Mix.ar( // mix all stereo pairs down.
        Pan2.ar( // pan the voice to a stereo position
            CombL.ar( // a comb filter used as a string resonator
                Dust.ar( // random impulses as an excitation function
                    // an array to cause expansion of Dust to n channels
                    // 1 means one impulse per second on average
                    1.dup(n),
                    0.3 // amplitude
                ),
                0.01, // max delay time in seconds
                // array of different random lengths for each 'string'
                {0.004.rand+0.0003}.dup(n),
                4 // decay time in seconds
            ),
            {1.0.rand2}.dup(n) // give each voice a different pan position
        )
    )
}.scope(2, zoom:4);
)


// Serial structures
(
play {
    var sig, chain;

    // The original sound source
    sig = sum({ SinOsc.ar(rrand(50,6000),0,2*Decay.ar(Dust2.ar(1),0.1)).tanh } ! 7);

    chain = sig;    // Start with the original signal
    8.do {|i|       // Loop 8 times. For each loop, connect the signal through something.

        // A simple reverb
        chain = LeakDC.ar(AllpassL.ar(LPF.ar(chain*0.9,3000), 0.2, {0.19.rand+0.01}!2, 3));
    };

    Limiter.ar(sig+chain);    // dry + wet
}
)
