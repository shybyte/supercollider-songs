~entropie = [
	\octave, -1,

	// voice
	\singleLayer, \single,
	\voiceAssign, \poly,

	// pitch
	\transpose, 0,
	\tune, 0,
	\portamento, 32, //!
	\bendRange, 2,
	\vibratoInt, 5,

	// osc1
	\osc1Wave, \saw,
	\osc1Control1, 0,
	\osc1Control2, 0,

	// osc1
	\osc2Wave, \saw,
	\osc2Mod, \off,
	\osc2Semitone, 0,
	\osc2Tune, 0,

	// mixer
	\osc1Level, 127
	\osc2Level, 0
	\noiseLevel, 0

	// filter
	\filterType, \12lpf,
	\filterCutoff, 127,
	\filterResonance, 20,
	\filterEgInt, 0,
	\filterKeyTrack 0,

	// filter eg
	\filterAttack, 0,
	\filterDecay, 64,
	\filterSustain, 127,
	\filterRelease, 0,
	\filterEgReset, \on,

	// amp
	\ampLevel, 127,
	\panpot, 0,
	\distortion, \off
	\kbdTrack, 0

	// amp eg
	\attack, 5, //!
	\decay, 64,
	\sustain, 127,
	\release, 15 //!
	\egReset, \on,

	// lfo1
	\lfo1Wave, \triangle
	\lfo1KeySync, \off,
	\lfo1TempoSync, \off,
	\lfo1Frequency, 10,

	// lfo2
	\lfo2Wave, \sine
	\lfo2KeySync, \off,
	\lfo2TempoSync, \off,
	\lfo2Frequency, 70,

	//patch 1
	\patch1Source, \lfo1,
	\patch1Dest, \pitch,
	\patch1ModInt, 0,

	//patch 2
	\patch2Source, \lfo2,
	\patch2Dest, \pitch,
	\patch3ModInt, 0,

	//patch 3
	\patch3Source, \lfo2,
	\patch3Dest, \pitch,
	\patch3ModInt, 0,

	//patch 4
	\patch4Source, \lfo2,
	\patch4Dest, \cutOff,
	\patch4ModInt, 0,

	//patch modFx
	\modFxType, \phaser //!
	\modFxLfoSpeed, 7, //!
	\modFxEffectDepth, 127, //!

	// delay
	\delayType, \crossDelay, //!
	\delayTempoSync, \on, //! (why not delay time?)
	\delaySyncNote, \3_16, //!

	\delayTempoSync, \off, //! (alternativ)
	\delayTime, 88, //!

	\delayDepth, 86, //!

	// eq
	\lowEqFreq, 460, //! (default 320)
	\lowEqGain, 12, //! (default 0)
	\hiEqFreq, 18, //! (default 6)
	\hiEqGain, 12, //! (default 0)


]
