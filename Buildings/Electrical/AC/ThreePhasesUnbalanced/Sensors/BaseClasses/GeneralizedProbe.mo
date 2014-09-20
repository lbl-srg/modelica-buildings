within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sensors.BaseClasses;
partial model GeneralizedProbe
  "Partial model of a generalized three phases probe"
  extends Icons.GeneralizedProbe;
  parameter Modelica.SIunits.Voltage V_nominal(min=0, start=480) = 480
    "RMS Nominal voltage (V_nominal >= 0)";
  parameter Boolean perUnit = true "This flag display voltage in p.u.";
  Buildings.Electrical.AC.ThreePhasesUnbalanced.Interfaces.Terminal_n term
    "Electrical connector"                                                                        annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={0,-90})));
  Modelica.Blocks.Interfaces.RealOutput V[3](unit="1") "Voltage in per unit" annotation (Placement(
        transformation(extent={{60,20},{80,40}}), iconTransformation(extent={{60,
            20},{80,40}})));
  Modelica.Blocks.Interfaces.RealOutput theta[3](unit="rad", displayUnit="deg") "Angle" annotation (Placement(
        transformation(extent={{60,-40},{80,-20}}), iconTransformation(extent={{60,
            -40},{80,-20}})));
  annotation (Icon(graphics={      Text(
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
          textString="theta")}), Documentation(revisions="<html>
<ul>
<li>
June 6, 2014, by Marco Bonvini:<br/>
First implementation.
</li>
</ul>
</html>"));
end GeneralizedProbe;
