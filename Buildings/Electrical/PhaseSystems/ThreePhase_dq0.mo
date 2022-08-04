within Buildings.Electrical.PhaseSystems;
package ThreePhase_dq0 "AC system in dqo representation"
  extends PartialPhaseSystem(phaseSystemName="ThreePhase_dqo", n=3, m=2);


  redeclare function extends j
  "Rotation(pi/2) of vector around {0,0,1} and projection on North plane"
  algorithm
    y := cat(1, {-x[2], x[1]}, zeros(size(x,1)-2));
    annotation(Inline=true);
  end j;


  redeclare function extends rotate
  "Rotate a vector of an angle theta (anti-counterclock)"
  algorithm
    y[1] := cos(theta)*x[1] - sin(theta)*x[2];
    y[2] := sin(theta)*x[1] + cos(theta)*x[2];
    y[3] := x[3];
    annotation(Inline=true);
  end rotate;


  redeclare function jj "Vectorized version of j"
  extends Modelica.Icons.Function;
    input Real[:,:] xx "array of voltage or current vectors";
    output Real[size(xx,1),size(xx,2)] yy "array of rotated vectors";
  algorithm
    yy := cat(1, {-xx[2,:], xx[1,:]}, zeros(size(xx,1)-2, size(xx,2)));
    annotation(Inline=true);
  end jj;


  redeclare function extends thetaRel
  "Return absolute angle of rotating system as offset to thetaRef"
  algorithm
    thetaRel := theta[1];
    annotation(Inline=true);
  end thetaRel;


  redeclare function extends thetaRef
  "Return absolute angle of rotating reference system"
  algorithm
    thetaRef := theta[2];
    annotation(Inline=true);
  end thetaRef;


  redeclare function extends phase "Return phase"
  algorithm
    phase := atan2(x[2], x[1]);
    annotation(Inline=true);
  end phase;


  redeclare function extends phaseVoltages "Return phase to neutral voltages"
  protected
    Voltage neutral_v = 0;
  algorithm
    v := {V*cos(phi), V*sin(phi), sqrt(3)*neutral_v}/sqrt(3);
    annotation(Inline=true);
  end phaseVoltages;


  redeclare function extends phaseCurrents "Return phase currents"
  algorithm
    i := {I*cos(phi), I*sin(phi), 0};
    annotation(Inline=true);
  end phaseCurrents;


  redeclare function extends phasePowers "Return phase powers"
  algorithm
    p := {P, P*tan(phi), 0};
    annotation(Inline=true);
  end phasePowers;


  redeclare function extends phasePowers_vi "Return phase powers"
  algorithm
    p := {v[1:2]*i[1:2], -j(v[1:2])*i[1:2], v[3]*i[3]};
    annotation(Inline=true);
  end phasePowers_vi;


  redeclare function extends systemVoltage
  "Return system voltage as function of phase voltages"
  algorithm
    V := Modelica.Fluid.Utilities.regRoot(v*v, delta = 1e-5);
    annotation(Inline=true);
  end systemVoltage;


  redeclare function extends systemCurrent
  "Return system current as function of phase currents"
  algorithm
    I := Modelica.Fluid.Utilities.regRoot(i*i, delta = 1e-5);
    annotation(Inline=true);
  end systemCurrent;


  redeclare function extends activePower
  "Return total power as function of phase powers"
  algorithm
    P := v[1]*i[1];
    annotation(Inline=true);
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
          smooth=Smooth.None)}), Documentation(info="<html>
<p>
This package declares the functions that are used to implement
the AC three-phase balanced models using the DQ0 representation.
</p>
</html>"));
end ThreePhase_dq0;
