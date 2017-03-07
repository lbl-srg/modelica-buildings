within Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled;
model SingleSpeed "Single speed water-cooled DX coils"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialWaterCooledDXCoil(
      redeclare final Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.SingleSpeed eva);

  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-124,68},{-100,92}}),
        iconTransformation(extent={{-120,72},{-100,92}})));
equation
  connect(eva.on, on) annotation (Line(points={{-11,68},{-11,68},{-88,68},{-88,80},
          {-106,80},{-112,80}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-78,74},{80,-74}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-107,66},{94,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-6,56},{94,66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
                                Text(
          extent={{54,12},{98,-8}},
          lineColor={0,0,127},
          textString="QEvaLat"),Text(
          extent={{54,50},{98,30}},
          lineColor={0,0,127},
          textString="QEvaSen"),
        Rectangle(
          extent={{6,-66},{106,-56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-95,-56},{106,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-6,-66},{94,-56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
                                Text(
          extent={{54,100},{98,80}},
          lineColor={0,0,127},
          textString="P")}),                                     Diagram(
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
February 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleSpeed;
