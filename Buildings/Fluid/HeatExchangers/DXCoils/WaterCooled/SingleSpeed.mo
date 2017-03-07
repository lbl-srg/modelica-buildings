within Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled;
model SingleSpeed "Single speed water-cooled DX coils"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialWaterCooledDXCoil(
    redeclare Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.SingleSpeed eva);

  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-124,68},{-100,92}}),
        iconTransformation(extent={{-120,72},{-100,92}})));
equation
  connect(eva.on, on) annotation (Line(points={{-11,8},{-11,68},{-88,68},{-88,
          80},{-106,80},{-112,80}},
                                color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This model can be used to simulate a water-cooled DX cooling coil with single speed compressor.
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
end SingleSpeed;
