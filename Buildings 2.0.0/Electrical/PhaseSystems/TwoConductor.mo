within Buildings.Electrical.PhaseSystems;
package TwoConductor "Two conductors for DC components"
  extends PartialPhaseSystem(phaseSystemName="TwoConductor", n=2, m=0);


  redeclare function extends j "Direct current has no complex component"
  algorithm
    y := zeros(n);
    annotation(Inline=true);
  end j;


  redeclare function extends rotate
  "Rotate a vector of an angle Theta (anti-counterclock)"
  algorithm
    y[n] := x[n];
    annotation(Inline=true);
  end rotate;


  redeclare function extends thetaRel
  "Return absolute angle of rotating system as offset to thetaRef"
  algorithm
    thetaRel := 0;
    annotation(Inline=true);
  end thetaRel;


  redeclare function extends thetaRef
  "Return absolute angle of rotating reference system"
  algorithm
    thetaRef := 0;
    annotation(Inline=true);
  end thetaRef;


  redeclare function extends phase "Return phase"
  algorithm
    phase := 0;
    annotation(Inline=true);
  end phase;


  redeclare replaceable function extends phaseVoltages
  "Return phase to neutral voltages"
  algorithm
    v := 0.5*{V, -V};
    annotation(Inline=true);
  end phaseVoltages;


  redeclare function extends phaseCurrents "Return phase currents"
  algorithm
    i := {I, -I};
    annotation(Inline=true);
  end phaseCurrents;


  redeclare function extends phasePowers "Return phase powers"
  algorithm
    p := {P, 0};
    annotation(Inline=true);
  end phasePowers;


  redeclare function extends phasePowers_vi "Return phase powers"
  algorithm
    p := v.*i;
    annotation(Inline=true);
  end phasePowers_vi;


  redeclare replaceable function extends systemVoltage
  "Return system voltage as function of phase voltages"
  algorithm
    V := v[1] - v[2];
    annotation(Inline=true);
  end systemVoltage;


  redeclare function extends systemCurrent
  "Return system current as function of phase currents"
  algorithm
    I := (i[1] - i[2])/2;
    annotation(Inline=true);
  end systemCurrent;


  redeclare function extends activePower
  "Return total power as function of phase powers"
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
          smooth=Smooth.None)}), Documentation(info="<html>
<p>
This package declares the functions that are used to implement
the DC models with double conductors.
</p>
</html>"));
end TwoConductor;
