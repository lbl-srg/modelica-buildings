within Buildings.Electrical.AC.OnePhase.Sources;
model FixedVoltage "Fixed single phase AC voltage source"
  extends Buildings.Electrical.Interfaces.Source(
    redeclare package PhaseSystem = PhaseSystems.OnePhase,
    redeclare Interfaces.Terminal_p terminal);
  parameter Modelica.SIunits.Frequency f(start=60) = 60
    "Frequency of the source";
  parameter Modelica.SIunits.Voltage V(start=120) = 120
    "RMS voltage of the source";
  parameter Modelica.SIunits.Angle Phi(start=0) = 0
    "fixme: phi must be lower case as it is a variable, not a class. Phase shift of the source";
protected
  Modelica.SIunits.Angle thetaRel
    "Absolute angle of rotating system as offset to thetaRef";
equation
  if Connections.isRoot(terminal.theta) then
    PhaseSystem.thetaRef(terminal.theta) =  2*Modelica.Constants.pi*f*time;
  end if;
  thetaRel = PhaseSystem.thetaRel(terminal.theta);
  terminal.v = PhaseSystem.phaseVoltages(V, thetaRel + Phi);

  annotation (
    defaultComponentName="fixVol",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                   graphics={
        Ellipse(
          extent={{-60,60},{60,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Line(
          points={{-44,0},{-24,40},{-4,0},{16,-40},{36,0}},
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
          points=DynamicSelect({{-20,-90},{20,-90}}, if definiteReference then {{-20,-90},{20,-90}}
               else {{-20,-90},{-20,-90}}),
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points=DynamicSelect({{-20,-90},{6,-64}}, if definiteReference then {{-20,-90},{6,-64}}
               else {{-20,-90},{-20,-90}}),
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5),
        Line(
          points=DynamicSelect({{2,-66},{14,-74},{18,-92}}, if definiteReference then {{2,-66},{14,-74},{18,-92}}
               else {{2,-66},{2,-66}}),
          color={0,120,120},
          smooth=Smooth.Bezier)}),
      Documentation(info="<html>
<p>
This is a constant voltage source. The complex voltage is specified by the RMS voltage and the phase shift.
</p>
</html>",
 revisions="<html>
 <ul>
<li>
September 4, 2014, by Michael Wetter:<br/>
Revised documentation.
</li>
<li>
August 5, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics));
end FixedVoltage;
