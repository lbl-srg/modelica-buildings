within Buildings.Fluid.HeatExchangers.DXCoils.WaterCooled;
model MultiSpeed "Multi speed water-cooled DX coils"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialWaterCooledDXCoil(
      redeclare final Buildings.Fluid.HeatExchangers.DXCoils.AirCooled.MultiStage eva);

  Modelica.Blocks.Interfaces.IntegerInput stage
    "Stage of cooling coil (0: off, 1: first stage, 2: second stage...)"
    annotation (Placement(transformation(extent={{-124,68},{-100,92}})));


equation
  connect(eva.stage, stage)
   annotation (Line(points={{-11,68},{-90,68},{-90,80}, {-112,80}}, color={255,127,0}));
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
    Documentation(revisions="<html>
<ul>
<li>
February 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This model can be used to simulate a water-cooled DX cooling coil with multiple
operating stages. Depending on the used performance curves, each
stage could be a different compressor speed, or a different mode
of operation, such as with or without hot gas reheat.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">
Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide</a>
for an explanation of the model.
</p>
</html>"));
end MultiSpeed;
