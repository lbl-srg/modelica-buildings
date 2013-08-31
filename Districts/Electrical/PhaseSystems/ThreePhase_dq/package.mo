within Districts.Electrical.PhaseSystems;
package ThreePhase_dq "AC system, symmetrically loaded three phases"
  extends PartialPhaseSystem(phaseSystemName="ThreePhase_dq", n=2, m=1);


  redeclare function j "Return vector rotated by 90 degrees"
    extends Modelica.Icons.Function;
    input Real x[n];
    output Real y[n];
  algorithm
    y := {-x[2], x[1]};
  end j;


  redeclare function thetaRel
  "Return absolute angle of rotating system as offset to thetaRef"
    input SI.Angle theta[m];
    output SI.Angle thetaRel;
  algorithm
    thetaRel := 0;
  end thetaRel;


  redeclare function thetaRef
  "Return absolute angle of rotating reference system"
    input SI.Angle theta[m];
    output SI.Angle thetaRef;
  algorithm
    thetaRef := theta[1];
  end thetaRef;


  redeclare function phase "Return phase"
    extends Modelica.Icons.Function;
    input Real x[n];
    output SI.Angle phase;
  algorithm
    phase := atan2(x[2], x[1]);
  end phase;


  redeclare function phaseVoltages "Return phase to neutral voltages"
    extends Modelica.Icons.Function;
    input SI.Voltage V "system voltage";
    input SI.Angle phi = 0 "phase angle";
    output SI.Voltage v[n] "phase to neutral voltages";
  algorithm
    v := {V*cos(phi), V*sin(phi)}/sqrt(3);
  end phaseVoltages;


  redeclare function phaseCurrents "Return phase currents"
    extends Modelica.Icons.Function;
    input SI.Current I "system current";
    input SI.Angle phi = 0 "phase angle";
    output SI.Current i[n] "phase currents";
  algorithm
    i := {I*cos(phi), I*sin(phi)};
  end phaseCurrents;


  redeclare function phasePowers "Return phase powers"
    extends Modelica.Icons.Function;
    input SI.ActivePower P "active system power";
    input SI.Angle phi = 0 "phase angle";
    output SI.Power p[n] "phase powers";
  algorithm
    p := {P, P*tan(phi)};
  end phasePowers;


  redeclare function phasePowers_vi "Return phase powers"
    extends Modelica.Icons.Function;
    input SI.Voltage v[n] "phase voltages";
    input SI.Current i[n] "phase currents";
    output SI.Power p[n] "phase powers";
  algorithm
    p := {v*i, -j(v)*i};
  end phasePowers_vi;


  redeclare function systemVoltage
  "Return system voltage as function of phase voltages"
    extends Modelica.Icons.Function;
    input SI.Voltage v[n];
    output SI.Voltage V;
  algorithm
    V := sqrt(3*v*v);
  end systemVoltage;


  redeclare function systemCurrent
  "Return system current as function of phase currents"
    extends Modelica.Icons.Function;
    input SI.Current i[n];
    output SI.Current I;
  algorithm
    I := sqrt(i*i);
  end systemCurrent;


  redeclare function activePower
  "Return total power as function of phase powers"
    extends Modelica.Icons.Function;
    input SI.Voltage v[n] "phase voltages";
    input SI.Current i[n] "phase currents";
    output SI.ActivePower P "active system power";
  algorithm
    P := v[1]*i[1];
  end activePower;


  annotation (Icon(graphics={
        Line(
          points={{-70,12},{-58,32},{-38,52},{-22,32},{-10,12},{2,-8},{22,-28},
              {40,-8},{50,12}},
          color={95,95,95},
          smooth=Smooth.Bezier),
        Line(
          points={{-70,-70},{50,-70}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-70,-46},{50,-46}},
          color={95,95,95},
          smooth=Smooth.None)}));
end ThreePhase_dq;
