within Buildings.Fluid.HeatExchangers.DXCoils;
model VariableSpeed "Variable speed DX cooling coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil(
  dxCoo(final variableSpeedCoil=true));
  parameter Real minSpeRat(min=0,max=1) "Minimum speed ratio";
  parameter Real speRatDeaBan= 0.05 "Deadband for minimum speed ratio";
  Modelica.Blocks.Interfaces.RealInput speRat "Speed ratio"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
protected
  Modelica.Blocks.Logical.Hysteresis deaBan(
     uLow=minSpeRat - speRatDeaBan/2,
     uHigh=minSpeRat + speRatDeaBan/2) "Speed ratio deadband"
    annotation (Placement(transformation(extent={{-64,64},{-52,76}})));
  Modelica.Blocks.Math.BooleanToInteger onSwi(
    final integerTrue=1,
    final integerFalse=0) "On/off switch"
    annotation (Placement(transformation(extent={{-42,64},{-30,76}})));
equation
  connect(speRat, dxCoo.speRat) annotation (Line(
      points={{-110,80},{-90,80},{-90,57.6},{-21,57.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, deaBan.u)
                         annotation (Line(
      points={{-110,80},{-90,80},{-90,70},{-65.2,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deaBan.y, eva.on) annotation (Line(
      points={{-51.4,70},{-48,70},{-48,62},{-92,62},{-92,-62},{-10,-62}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(onSwi.y, dxCoo.stage) annotation (Line(
      points={{-29.4,70},{-26,70},{-26,60},{-21,60}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(deaBan.y, onSwi.u) annotation (Line(
      points={{-51.4,70},{-43.2,70}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (defaultComponentName="mulStaDX", Documentation(info="<html>
<p>
This model can be used to simulate a DX cooling coil with continuously variable speed compressors.
The control input is the speed ratio.
The coil will switch off if the speed ratio is below a minimum value.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">
Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide</a>
for an explanation of the model.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 28, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>

</html>"),
    Icon(graphics={Text(
          extent={{-96,96},{-38,78}},
          lineColor={0,0,127},
          textString="speRat")}));
end VariableSpeed;
