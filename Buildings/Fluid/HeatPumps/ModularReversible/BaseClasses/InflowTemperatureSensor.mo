within Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses;
block InflowTemperatureSensor "Custom block to measure instream fluid temperature"

  Modelica.Blocks.Interfaces.RealOutput y(
    final unit="K",
    displayUnit="degC")=0.0
    "Inflow temperature"
    annotation (Dialog(group="Time varying output signal"), Placement(
        transformation(extent={{100,-10},{120,10}})));

  annotation (Icon(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,40},{100,-40}},
          fillColor={235,235,235},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-96,15},{96,-15}},
          textString="%y"),
        Text(
          extent={{-150,90},{150,50}},
          textString="%name",
          textColor={0,0,255})}), Documentation(info="<html>
<p>
  This model extends
  <a href=\"modelica://Modelica.Blocks.Sources.RealExpression\">
  Modelica.Blocks.Sources.RealExpression</a>
  and adds the unit \"Kelvin\" to the output.
</p>
<p>
  It is used to output a temperature measurement by
  evaluating the port temperature directly.
</p>
</html>", revisions="<html><ul>
  <li>
    <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
  </li>
</ul>
</html>"));

end InflowTemperatureSensor;
