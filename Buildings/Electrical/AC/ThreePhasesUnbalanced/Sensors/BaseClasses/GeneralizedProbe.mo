within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.BaseClasses;
partial model GeneralizedProbe
  "Partial model of a generalized three-phase probe"
  extends Icons.GeneralizedProbe;
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start=480)
    "RMS Nominal voltage (V_nominal >= 0)";
  parameter Boolean perUnit = true "This flag display voltage in p.u.";
  Modelica.Blocks.Interfaces.RealOutput V[3](each unit="1")
    "Voltage in per unit"                                                         annotation (Placement(
        transformation(extent={{60,20},{80,40}}), iconTransformation(extent={{60,
            20},{80,40}})));
  Modelica.Blocks.Interfaces.RealOutput theta[3](each unit="rad", each displayUnit="deg") "Angle" annotation (Placement(
        transformation(extent={{60,-40},{80,-20}}), iconTransformation(extent={{60,
            -40},{80,-20}})));
  annotation (Icon(graphics={      Text(
          extent={{40,60},{100,40}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fillColor={0,120,120},
          fillPattern=FillPattern.Solid,
          textString="V"), Text(
          extent={{18,-40},{140,-60}},
          lineColor={0,0,0},
          pattern=LinePattern.Dash,
          fillColor={0,120,120},
          fillPattern=FillPattern.Solid,
          textString="theta")}), Documentation(revisions="<html>
<ul>
<li>
September 24, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
<li>
June 6, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model contains the parameters and connectors that are used by
probe models such as <a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeWye</a> and
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeDelta\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.ProbeDelta</a>.
The output connectors are for the RMS voltage and the angle of the voltage phasors.
</p>
</html>"));
end GeneralizedProbe;
