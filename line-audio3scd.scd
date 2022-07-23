s.boot;

(
SynthDef( \sin, { | amp = 0.01, freq = 333, trig = 1 |
    var env, sig;
    env = EnvGen.kr( Env.asr( 0.001, 0.9, 0.001 ), trig, doneAction: 0 );
    sig = LFTri.ar( [ freq, freq * 0.999 ], 0.0, amp ) * env;
    Out.ar( [ 0 ], sig * 0.6 );
}).add;

SynthDef( \sin1, { | amp1 = 0.01, freq1 = 333, trig1 = 1 |
    var env1, sig1;
    env1 = EnvGen.kr( Env.asr( 0.001, 0.9, 0.001 ), trig1, doneAction: 0 );
    sig1 = LFTri.ar( [ freq1, freq1 * 0.999 ], 0.0, amp1 ) * env1;
    Out.ar( [ 0 ], sig1 * 0.6 );
}).add;




h = Synth( \sin, [ \amp, 0.4 ] );
i = Synth( \sin1,[ \amp1, 0.0] );

x = OSCFunc( { | msg, time, addr, port |
    var pyFreq;
    pyFreq = msg[1].asFloat;
    ( "freq is " + pyFreq ).postln; h.set( \freq, pyFreq );
}, '/print' );


y = OSCFunc( { | msg, time, addr, port |
    var pyFreq;
    pyFreq = msg[1].asFloat/2.0;
    ( "freq is " + pyFreq).postln; i.set( \freq1, pyFreq );
}, '/print1' );
)

