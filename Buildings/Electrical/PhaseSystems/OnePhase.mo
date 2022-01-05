within Buildings.Electrical.PhaseSystems;
package OnePhase "Single phase two connectors AC system"
  extends PartialPhaseSystem(phaseSystemName="OnePhase", n=2, m=1);


  redeclare function extends j "Return vector rotated by 90 degrees"
  algorithm
    y := {-x[2], x[1]};
    annotation(Inline=true);
  end j;


  redeclare function extends rotate
  "Rotate a vector of an angle theta (anti-counterclock)"
  algorithm
    y[1] := cos(theta)*x[1] - sin(theta)*x[2];
    y[2] := sin(theta)*x[1] + cos(theta)*x[2];
    annotation(Inline=true);
  end rotate;


  redeclare function extends product
  "Multiply two complex numbers represented by vectors x[2] and y[2]"
  algorithm
    z := {x[1]*y[1] - x[2]*y[2], x[1]*y[2] + x[2]*y[1]};
    annotation(Inline=true);
  end product;


  redeclare function extends divide
  "Divide two complex numbers represented by vectors x[2] and y[2]"
  algorithm
    z := {x[1]*y[1] + x[2]*y[2], x[2]*y[1] - x[1]*y[2]}/(y[1]^2 + y[2]^2);
    annotation(Inline=true);
  end divide;


  redeclare function extends thetaRel
  "Return absolute angle of rotating system as offset to thetaRef"
  algorithm
    thetaRel := 0;
    annotation(Inline=true);
  end thetaRel;


  redeclare function extends thetaRef
  "Return absolute angle of rotating reference system"
  algorithm
    thetaRef := theta[1];
    annotation(Inline=true);
  end thetaRef;


  redeclare function extends phase "Return phase"
  algorithm
    phase := atan2(x[2], x[1]);
    annotation(Inline=true);
  end phase;


  redeclare function extends phaseVoltages "Return phase to neutral voltages"
  algorithm
    v := {V*cos(phi), V*sin(phi)};
    annotation(Inline=true);
  end phaseVoltages;


  redeclare function extends phaseCurrents "Return phase currents"
  algorithm
    i := {I*cos(phi), I*sin(phi)};
    annotation(Inline=true);
  end phaseCurrents;


  redeclare function extends phasePowers "Return phase powers"
  algorithm
    p := {P, P*tan(phi)};
    annotation(Inline=true);
  end phasePowers;


  redeclare function extends phasePowers_vi "Return phase powers"
  algorithm
    p := {v[1]*i[1] + v[2]*i[2], v[2]*i[1] - v[1]*i[2]};
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
    // P = v[1]*i[1] + v[2]*i[2]
    P := v*i;
    annotation(Inline=true);
  end activePower;


  annotation (Icon(graphics={
        Line(
          points={{-70,-10},{-58,10},{-38,30},{-22,10},{-10,-10},{2,-30},{22,-50},
              {40,-30},{50,-10}},
          color={95,95,95},
          smooth=Smooth.Bezier)}), Documentation(info="<html>
<p>
This package declares the functions that are used to implement
the AC single phase models.
</p>
</html>"));
end OnePhase;
