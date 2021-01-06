within Buildings.Electrical.PhaseSystems;
package ThreePhase_dq "AC system, symmetrically loaded three-phase"
  extends PartialPhaseSystem(phaseSystemName="ThreePhase_dq", n=2, m=1);


  redeclare function extends j "Return vector rotated by 90 degrees"
  algorithm
    y := {-x[2], x[1]};
    annotation(Inline=true);
  end j;


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
    v := {V*cos(phi), V*sin(phi)}/sqrt(3);
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
    p := {v*i, -j(v)*i};
    annotation(Inline=true);
  end phasePowers_vi;


  redeclare function extends systemVoltage
  "Return system voltage as function of phase voltages"
  algorithm
    V := Modelica.Fluid.Utilities.regRoot(3*v*v, delta = 1e-5);
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
          smooth=Smooth.None)}), Documentation(info="<html>
<p>
This package declares the functions that are used to implement
the AC three-phase balanced models using the DQ representation.
</p>
</html>"));
end ThreePhase_dq;
