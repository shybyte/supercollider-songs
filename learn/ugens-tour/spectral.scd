// FFT

// alloc a buffer for the FFT
b = Buffer.alloc(s,2048,1);
// read a sound
c = Buffer.read(s, Platform.resourceDir +/+ "sounds/a11wlk01.wav");

(
// do nothing
{
    var in, chain;
    in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
    chain = FFT(b, in);
    0.5 * IFFT(chain);
}.scope(1);
)

(
// pass only magnitudes above a threshold
{
    var in, chain;
    in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
    chain = FFT(b, in);
    chain = PV_MagAbove(chain, MouseX.kr(0.1,512,1));
    0.5 * IFFT(chain);
}.scope(1);
)


(
// pass only magnitudes below a threshold
{
    var in, chain;
    in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
    chain = FFT(b, in);
    chain = PV_MagBelow(chain, MouseX.kr(0.1,512,1));
    0.5 * IFFT(chain);
}.scope(1);
)

(
// brick wall filter.
{
    var in, chain;
    in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
    chain = FFT(b, in);
    chain = PV_BrickWall(chain, MouseX.kr(-1,1));
    0.5 * IFFT(chain);
}.scope(1);
)

(
// pass random frequencies. Mouse controls how many to pass.
// trigger changes the frequencies periodically
{
    var in, chain;
    in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
    chain = FFT(b, in);
    chain = PV_RandComb(chain, MouseX.kr(0,1), Impulse.kr(0.4));
    0.5 * IFFT(chain);
}.scope(1);
)

(
// rectangular comb filter
{
    var in, chain;
    in = PlayBuf.ar(1,c, BufRateScale.kr(c), loop:1);
    chain = FFT(b, in);
    chain = PV_RectComb(chain, 8, MouseY.kr(0,1), MouseX.kr(0,1));
    0.5 * IFFT(chain);
}.scope(1);
)