s.boot;

(
SynthDef( \sin, { | amp = 0.01, freq = 333, trig = 1 |
    var env, sig;
    env = EnvGen.kr( Env.asr( 0.001, 0.9, 0.001 ), trig, doneAction: 0 );
    sig = LFTri.ar( [ freq, freq * 0.999 ], 0.0, amp ) * env;
    Out.ar( [ 0 ], sig * 0.6 );
}).add;

h = Synth( \sin, [ \amp, 0.4 ] );

x = OSCFunc( { | msg, time, addr, port |
    var pyFreq;
    pyFreq = msg[1].asFloat;
    ( "freq is " + pyFreq ).postln; h.set( \freq, pyFreq );
}, '/print' );
)

