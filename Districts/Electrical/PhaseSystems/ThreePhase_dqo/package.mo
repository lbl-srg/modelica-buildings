within Districts.Electrical.PhaseSystems;
package ThreePhase_dqo "AC system in dqo representation"
  extends PartialPhaseSystem(phaseSystemName="ThreePhase_dqo", n=3, m=2);


  redeclare function j
  "Rotation(pi/2) of vector around {0,0,1} and projection on orth plane"
    extends Modelica.Icons.Function;
    input Real x[:];
    output Real y[size(x,1)];
  algorithm
    y := cat(1, {-x[2], x[1]}, zeros(size(x,1)-2));
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
    y[3] := x[3];
  end rotate;


  redeclare function jj "Vectorized version of j"
    input Real[:,:] xx "array of voltage or current vectors";
    output Real[size(xx,1),size(xx,2)] yy "array of rotated vectors";
  algorithm
    yy := cat(1, {-xx[2,:], xx[1,:]}, zeros(size(xx,1)-2, size(xx,2)));
  end jj;


  redeclare function thetaRel
  "Return absolute angle of rotating system as offset to thetaRef"
    input SI.Angle theta[m];
    output SI.Angle thetaRel;
  algorithm
    thetaRel := theta[1];
  end thetaRel;


  redeclare function thetaRef
  "Return absolute angle of rotating reference system"
    input SI.Angle theta[m];
    output SI.Angle thetaRef;
  algorithm
    thetaRef := theta[2];
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
protected
    Voltage neutral_v = 0;
  algorithm
    v := {V*cos(phi), V*sin(phi), sqrt(3)*neutral_v}/sqrt(3);
  end phaseVoltages;


  redeclare function phaseCurrents "Return phase currents"
    extends Modelica.Icons.Function;
    input Current I "system current";
    input SI.Angle phi = 0 "phase angle";
    output SI.Current i[n] "phase currents";
  algorithm
    i := {I*cos(phi), I*sin(phi), 0};
  end phaseCurrents;


  redeclare function phasePowers "Return phase powers"
    extends Modelica.Icons.Function;
    input SI.ActivePower P "active system power";
    input SI.Angle phi = 0 "phase angle";
    output SI.Power p[n] "phase powers";
  algorithm
    p := {P, P*tan(phi), 0};
  end phasePowers;


  redeclare function phasePowers_vi "Return phase powers"
    extends Modelica.Icons.Function;
    input SI.Voltage v[n] "phase voltages";
    input SI.Current i[n] "phase currents";
    output SI.Power p[n] "phase powers";
  algorithm
    p := {v[1:2]*i[1:2], -j(v[1:2])*i[1:2], v[3]*i[3]};
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
    P := v[1]*i[1];
  end activePower;


  annotation (Icon(graphics={
        Line(
          points={{-70,28},{-58,48},{-38,68},{-22,48},{-10,28},{2,8},{22,-12},
              {40,8},{50,28}},
          color={95,95,95},
          smooth=Smooth.Bezier),
        Line(
          points={{-70,-54},{50,-54}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-70,-78},{50,-78}},
          color={95,95,95},
          smooth=Smooth.None),
        Line(
          points={{-70,-28},{50,-28}},
          color={95,95,95},
          smooth=Smooth.None)}));
end ThreePhase_dqo;
