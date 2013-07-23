within Districts.Electrical.AC.AC3ph.Sources;
model FixedVoltage "Fixed 1 phase AC voltage source"
  extends Districts.Electrical.Interfaces.PartialSource(redeclare package
      PhaseSystem = Districts.Electrical.PhaseSystems.ThreePhase_dq, redeclare
      Interfaces.Terminal_p terminal);
  parameter Modelica.SIunits.Frequency f(start=50) "Frequency of the source";
  parameter Modelica.SIunits.Voltage V(start=380) "RMS voltage of the source";
  parameter Modelica.SIunits.Angle Phi(start=0) "Phase shift of the source";
  Modelica.SIunits.Angle thetaRel;
equation
  if isRoot(terminal.theta) then
    PhaseSystem.thetaRef(terminal.theta) =  2*Modelica.Constants.pi*f*time;
  end if;
  thetaRel = PhaseSystem.thetaRel(terminal.theta);
  //terminal.v = PhaseSystem.phaseVoltages(V, thetaRel + Phi);
  terminal.v = {V*cos(thetaRel + Phi), V*sin(thetaRel + Phi)};

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                   graphics={
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Line(
          points={{-56,0},{-36,40},{-16,0},{4,-40},{24,0}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Text(
          extent={{-120,100},{120,60}},
          lineColor={0,120,120},
          textString="%name = %V"),
        Line(
          points={{60,0},{90,0}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-20,-100},{20,-100}},
          color=DynamicSelect({0,120,120}, if definiteReference then {0,120,120} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{0,-100},{0,-60}},
          color=DynamicSelect({0,0,120}, if definiteReference then {0,120,120} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{-12,-106},{12,-106}},
          color=DynamicSelect({0,120,120}, if definiteReference then {0,120,120} else {255,255,
              255}),
          smooth=Smooth.None),
        Line(
          points={{-6,-112},{8,-112}},
          color=DynamicSelect({0,120,120}, if definiteReference then {0,120,120} else {255,255,
              255}),
          smooth=Smooth.None),            Line(
          points={{-40,0},{-20,40},{0,0},{20,-40},{40,0}},
          color={120,120,120},
          smooth=Smooth.Bezier),          Line(
          points={{-24,0},{-4,40},{16,0},{36,-40},{56,0}},
          color={215,215,215},
          smooth=Smooth.Bezier)}),
      Documentation(info="<html>

<p>
This is a constant voltage source, specifying the complex voltage by the RMS voltage and the phase shift.
</p>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics));
end FixedVoltage;
