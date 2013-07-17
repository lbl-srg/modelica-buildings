within Districts.Electrical.PhaseSystems;
package DirectCurrent "DC system"
  extends PartialPhaseSystem(phaseSystemName="DirectCurrent", n=1, m=0);


  redeclare function j "Direct current has no complex component"
    extends Modelica.Icons.Function;
    input Real x[n];
    output Real y[n];
  algorithm
    y := zeros(n);
  end j;


  redeclare function rotate
  "Rotate a vector of an angle Theta (anti-counterclock)"
    extends Modelica.Icons.Function;
    input Real x[n];
    input Modelica.SIunits.Angle theta;
    output Real y[n];
  algorithm
    y[n] := x[n];
  end rotate;


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
    thetaRef := 0;
  end thetaRef;


  redeclare function phase "Return phase"
    extends Modelica.Icons.Function;
    input Real x[n];
    output SI.Angle phase;
  algorithm
    phase := 0;
  end phase;


  redeclare replaceable function phaseVoltages
  "Return phase to neutral voltages"
    extends Modelica.Icons.Function;
    input SI.Voltage V "system voltage";
    input SI.Angle phi = 0 "phase angle";
    output SI.Voltage v[n] "phase to neutral voltages";
  algorithm
    v := {V};
  end phaseVoltages;


  redeclare function phaseCurrents "Return phase currents"
    extends Modelica.Icons.Function;
    input SI.Current I "system current";
    input SI.Angle phi = 0 "phase angle";
    output SI.Current i[n] "phase currents";
  algorithm
    i := {I};
  end phaseCurrents;


  redeclare function phasePowers "Return phase powers"
    extends Modelica.Icons.Function;
    input SI.ActivePower P "active system power";
    input SI.Angle phi = 0 "phase angle";
    output SI.Power p[n] "phase powers";
  algorithm
    p := {P};
  end phasePowers;


  redeclare function phasePowers_vi "Return phase powers"
    extends Modelica.Icons.Function;
    input SI.Voltage v[n] "phase voltages";
    input SI.Current i[n] "phase currents";
    output SI.Power p[n] "phase powers";
  algorithm
    p := {v*i};
  end phasePowers_vi;


  redeclare replaceable function systemVoltage
  "Return system voltage as function of phase voltages"
    extends Modelica.Icons.Function;
    input SI.Voltage v[n];
    output SI.Voltage V;
  algorithm
    V := v[1];
  end systemVoltage;


  redeclare function systemCurrent
  "Return system current as function of phase currents"
    extends Modelica.Icons.Function;
    input SI.Current i[n];
    output SI.Current I;
  algorithm
    I := i[1];
  end systemCurrent;


  redeclare function activePower
  "Return total power as function of phase powers"
    extends Modelica.Icons.Function;
    input SI.Voltage v[n] "phase voltages";
    input SI.Current i[n] "phase currents";
    output SI.ActivePower P "active system power";
  algorithm
    P := v*i;
  end activePower;


  annotation (Icon(graphics={Line(
          points={{-70,-10},{50,-10}},
          color={95,95,95},
          smooth=Smooth.None)}));
end DirectCurrent;
