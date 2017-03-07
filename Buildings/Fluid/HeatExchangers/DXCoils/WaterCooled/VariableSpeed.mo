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

  connect(speRat, eva.speRat) annotation (Line(points={{-112,80},{-90,80},{-90,68},
          {-11,68}}, color={0,0,127}));
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
February 16, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end VariableSpeed;
