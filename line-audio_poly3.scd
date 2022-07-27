s.boot;



(
z = List.new(12);
//y = Array.new(12);
y = List.new(12);
w = List.new(12);
//s = List.new(12);




//i = Synth( \sin,[ \amp, 0.0] );

12.do(
	{
		arg i;
		var ii;
		var iis;
		var key;
		var keyHead;
		var theIndex;


		theIndex = -1;
		//i.postln;
		i.asAscii;
		ii = i.asAscii;
		ii = '/key'++i;
		iis = '\\sin'++i;
		ii.postln;
		//iis.postln;

		SynthDef( iis, { | amp = 0.01, freq = 333, trig = 1 |
			var env, sig, sig0, sig1, sig2;
			env = EnvGen.kr( Env.asr( 0.001, 0.9, 0.001 ), trig, doneAction: 0 );
			//sig = LFTri.ar( [ freq, freq * 0.999 ], 0.0, amp ) * env;
			sig0 = LFTri.ar( [ freq, freq * 0.999 ], 0.0, amp );
			sig1 = SinOsc.ar(freq, amp);
			sig2 = Pulse.ar(freq*0.98,0.5, 1.0, amp);
			sig  = (sig0  + sig1 + sig2) / 3.0 * env;
			// Out.ar( [ 0 ], sig * 0.6 * amp );
		}).add;

		h = Synth( iis, [ \amp, 0.0 ] );

		x = OSCFunc( { | msg, time, addr, port |
			var pyFreq;
			var theI;
			theI = 0;
			pyFreq = msg[1].asFloat;

			("OSC" + msg[0] + " freq is" + pyFreq ).postln;
			//h.set( \freq, pyFreq );
			12.do(
				{
					arg jj;
					var a1;
					var a2;
					var c;
					var c1;
					var c2;
					var cc1;
					var cc2;
					var ppp;

					a1 = w[jj].asString;
					a2 = msg[0].asString;
					c1 = a1[4].asString++a1[5].asString;
					c2 = a2[4].asString++a2[5].asString;
					cc1 = c1.asInteger;
					cc2 = c2.asInteger;

					if ( cc1==cc2,
						{theI = jj; jj.postln;},
						{ppp=0;}// "no".postln;}
					);
				}
			);
			//theI.postln;
			if ( msg[2].asInteger > 0,
				{
					z[theI].set( \trig, 1);
					z[theI].set( \amp, 0.4 );
					"trig on".postln;
				},
				{
					z[theI].set( \trig,0);
					z[theI].set( \amp, 0.0);
					"trig off".postln;
				}
			);
			z[theI].set( \freq, pyFreq );
			//z[theI].set( \amp, 0.4 );
		}
		, ii );


		//s.add(r);
		w.add(ii);
		y.add(x);
		z.add(h);

		w.postln;
		y.postln;
		z.postln;
	}

)

)

w.postln;
y.postln;
z.postln;
