within Districts.Electrical.PhaseSystems;
package OnePhase "Single phase two connectors AC system"
  extends PartialPhaseSystem(phaseSystemName="OnePhase", n=2, m=1);


  redeclare function j "Return vector rotated by 90 degrees"
    extends Modelica.Icons.Function;
    input Real x[n];
    output Real y[n];
  algorithm
    y := {-x[2], x[1]};
  end j;


  redeclare function rotate
  "Rotate a vector of an angle Theta (anti-counterclock)"
    extends Modelica.Icons.Function;
    input Real x[n];
    input Modelica.SIunits.Angle theta;
    output Real y[n];
  algorithm
    y[1] := cos(theta)*x[1] - sin(theta)*x[2];
    y[2] := sin(theta)*x[1] + cos(theta)*x[2];
  end rotate;


  redeclare function product
  "Multiply two complex numbers represented by vectors x[2] and y[2]"
    extends Modelica.Icons.Function;
    input Real x[2];
    input Real y[2];
    output Real z[2];
  algorithm
    z := {x[1]*y[1] - x[2]*y[2], x[1]*y[2] + x[2]*y[1]};
  end product;


  redeclare function divide
  "Multiply two complex numbers represented by vectors x[2] and y[2]"
    extends Modelica.Icons.Function;
    input Real x[2];
    input Real y[2];
    output Real z[2];
  algorithm
    z := {x[1]*y[1] + x[2]*y[2], x[2]*y[1] - x[1]*y[2]}/(y[1]^2 + y[2]^2);
  end divide;


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
    v := {V*cos(phi), V*sin(phi)};
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
    p := {v[1]*i[1] + v[2]*i[2], v[2]*i[1] - v[1]*i[2]};
  end phasePowers_vi;


  redeclare function systemVoltage
  "Return system voltage as function of phase voltages"
    extends Modelica.Icons.Function;
    input SI.Voltage v[n];
    output SI.Voltage V;
  algorithm
    V := sqrt(v*v);
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
    // P = v[1]*i[1] + v[2]*i[2]
    P := v*i;
  end activePower;


  annotation (Icon(graphics={
        Line(
          points={{-70,-10},{-58,10},{-38,30},{-22,10},{-10,-10},{2,-30},{22,-50},
              {40,-30},{50,-10}},
          color={95,95,95},
          smooth=Smooth.Bezier)}));
end OnePhase;
