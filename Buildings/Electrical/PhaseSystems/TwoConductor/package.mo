within Buildings.Electrical.PhaseSystems;
package TwoConductor "Two conductors for DC components"
  extends PartialPhaseSystem(phaseSystemName="TwoConductor", n=2, m=0);


  redeclare function j "Direct current has no complex component"
    extends Modelica.Icons.Function;
    input Real x[n];
    output Real y[n];
  algorithm
    y := zeros(n);
    annotation(Inline=true);
  end j;


  redeclare function rotate
  "Rotate a vector of an angle Theta (anti-counterclock)"
    extends Modelica.Icons.Function;
    input Real x[n];
    input Modelica.SIunits.Angle theta;
    output Real y[n];
  algorithm
    y[n] := x[n];
    annotation(Inline=true);
  end rotate;


  redeclare function thetaRel
  "Return absolute angle of rotating system as offset to thetaRef"
    input SI.Angle theta[m];
    output SI.Angle thetaRel;
  algorithm
    thetaRel := 0;
    annotation(Inline=true);
  end thetaRel;


  redeclare function thetaRef
  "Return absolute angle of rotating reference system"
    input SI.Angle theta[m];
    output SI.Angle thetaRef;
  algorithm
    thetaRef := 0;
    annotation(Inline=true);
  end thetaRef;


  redeclare function phase "Return phase"
    extends Modelica.Icons.Function;
    input Real x[n];
    output SI.Angle phase;
  algorithm
    phase := 0;
    annotation(Inline=true);
  end phase;


  redeclare replaceable function phaseVoltages
  "Return phase to neutral voltages"
    extends Modelica.Icons.Function;
    input SI.Voltage V "system voltage";
    input SI.Angle phi = 0 "phase angle";
    output SI.Voltage v[n] "phase to neutral voltages";
  algorithm
    v := 0.5*{V, -V};
    annotation(Inline=true);
  end phaseVoltages;


  redeclare function phaseCurrents "Return phase currents"
    extends Modelica.Icons.Function;
    input SI.Current I "system current";
    input SI.Angle phi = 0 "phase angle";
    output SI.Current i[n] "phase currents";
  algorithm
    i := {I, -I};
    annotation(Inline=true);
  end phaseCurrents;


  redeclare function phasePowers "Return phase powers"
    extends Modelica.Icons.Function;
    input SI.ActivePower P "active system power";
    input SI.Angle phi = 0 "phase angle";
    output SI.Power p[n] "phase powers";
  algorithm
    p := {P, 0};
    annotation(Inline=true);
  end phasePowers;


  redeclare function phasePowers_vi "Return phase powers"
    extends Modelica.Icons.Function;
    input SI.Voltage v[TwoConductor.n] "phase voltages";
    input SI.Current i[TwoConductor.n] "phase currents";
    output SI.Power p[TwoConductor.n] "phase powers";
  algorithm
    p := v.*i;
    annotation(Inline=true);
  end phasePowers_vi;


  redeclare replaceable function systemVoltage
  "Return system voltage as function of phase voltages"
    extends Modelica.Icons.Function;
    input SI.Voltage v[n];
    output SI.Voltage V;
  algorithm
    V := v[1] - v[2];
    annotation(Inline=true);
  end systemVoltage;


  redeclare function systemCurrent
  "Return system current as function of phase currents"
    extends Modelica.Icons.Function;
    input SI.Current i[n];
    output SI.Current I;
  algorithm
    I := (i[1] - i[2])/2;
    annotation(Inline=true);
  end systemCurrent;


  redeclare function activePower
  "Return total power as function of phase powers"
    extends Modelica.Icons.Function;
    input SI.Voltage v[n] "phase voltages";
    input SI.Current i[n] "phase currents";
    output SI.ActivePower P "active system power";
  algorithm
    P := v*i;
    annotation(Inline=true);
  end activePower;


  annotation (Icon(graphics={Line(
          points={{-70,-28},{50,-28}},
          color={95,95,95},
          smooth=Smooth.None),
                             Line(
          points={{-70,6},{50,6}},
          color={95,95,95},
          smooth=Smooth.None)}));
end TwoConductor;
