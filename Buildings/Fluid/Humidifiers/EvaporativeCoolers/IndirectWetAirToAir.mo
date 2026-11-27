within Buildings.Fluid.Humidifiers.EvaporativeCoolers;
model IndirectWetAirToAir
  "Indirect wet evaporative cooler for air to air heat exchange"
  annotation (defaultComponentName="dirEvaCoo",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    grid={2,2})),
    Documentation(revisions="<html>
<ul>
<li>
November 20, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Model for an indirect wet evaporative cooler for air to air heat exchange.
It contains a wet coil with a basin, as well as a fan.
</p>
<p>
A diagram for this model is shown below:
</p>
<p align=\"center\">
<img alt=\"image\" src=\"modelica://Buildings/Resources/Images/Fluid/Humidifiers/EvaporativeCoolers/IndirectWetAirToAirEvaporativeCooler.png\"/>
</p>
</html>"));
end IndirectWetAirToAir;
