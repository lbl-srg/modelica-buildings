within Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled;
model VariableSpeed "Variable speed water-cooled DX coils"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialWaterCooledDXCoil(
      redeclare final Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.VariableSpeed eva(
        final minSpeRat = minSpeRat,
        final speRatDeaBan = speRatDeaBan));

  parameter Real minSpeRat(min=0,max=1) "Minimum speed ratio";
  parameter Real speRatDeaBan= 0.05 "Deadband for minimum speed ratio";

  Modelica.Blocks.Interfaces.RealInput speRat "Speed ratio"
    annotation (Placement(transformation(extent={{-124,68},{-100,92}})));

equation

  connect(speRat, eva.speRat) annotation (Line(points={{-112,80},{-90,80},{-90,
          8},{-11,8}},
                     color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model can be used to simulate a water-cooled DX cooling coil with variable speed compressor.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">
Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide</a>
for an explanation of the model.
</p>
</html>", revisions="<html>
<ul>
<li>
March 7, 2017, by Michael Wetter:<br/>
Refactored implementation to avoid code duplication and to propagate parameters.
</li>
<li>
February 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end VariableSpeed;
