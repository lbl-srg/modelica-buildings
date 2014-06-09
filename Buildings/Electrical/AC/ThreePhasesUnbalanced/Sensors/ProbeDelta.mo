within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors;
model ProbeDelta
  "Model of a probe that measures voltage magnitude and angle (Delta configuration)"
  extends Icons.GeneralizedProbe;
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start=480) = 480
    "RMS Nominal voltage (V_nominal >= 0)";
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Terminal_n term
    "Electrical connector"                                                                        annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-90})));
  Modelica.Blocks.Interfaces.RealOutput V[3](unit="1") "Voltage in per unit" annotation (Placement(
        transformation(extent={{60,20},{80,40}}), iconTransformation(extent={{60,
            20},{80,40}})));
  Modelica.Blocks.Interfaces.RealOutput theta[3](unit="deg") "Angle" annotation (Placement(
        transformation(extent={{60,-40},{80,-20}}), iconTransformation(extent={{60,
            -40},{80,-20}})));
  Interfaces.WyeToDelta     wyeToDelta
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={20,0})));
equation
  for i in 1:3 loop
      theta[i] = (180.0/Modelica.Constants.pi)*Buildings.Electrical.PhaseSystems.OnePhase.phase(wyeToDelta.delta.phase[i].v);
      if PerUnit then
        V[i] = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(wyeToDelta.delta.phase[i].v)/V_nominal;
      else
        V[i] = Buildings.Electrical.PhaseSystems.OnePhase.systemVoltage(wyeToDelta.delta.phase[i].v);
      end if;
  end for;

  connect(term, wyeToDelta.wye) annotation (Line(
      points={{0,-90},{0,4.44089e-16},{10,4.44089e-16}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}), graphics={Text(
          extent={{40,60},{100,40}},
          lineColor={0,120,120},
          pattern=LinePattern.Dash,
          fillColor={0,120,120},
          fillPattern=FillPattern.Solid,
          textString="V"), Text(
          extent={{18,-40},{140,-60}},
          lineColor={0,120,120},
          pattern=LinePattern.Dash,
          fillColor={0,120,120},
          fillPattern=FillPattern.Solid,
          textString="theta"),
        Line(
          points={{-20,-44},{0,-14},{20,-44},{-20,-44}},
          color={0,120,120},
          smooth=Smooth.None,
          thickness=0.5)}),         Documentation(info="<html>
<p>
This model represents a probe that measures the RMS voltage and the angle
of the voltage phasors (in degrees) at a given point. The probes are connected
in Wye (Y) grounded configuration.
</p>
</html>", revisions="<html>
<ul>
<li>
June 6, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics));
end ProbeDelta;
