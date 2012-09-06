within Buildings.Fluid.HeatExchangers.DXCoils;
model MultiSpeed "Multi-speed DX cooling coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil;

  Modelica.Blocks.Interfaces.IntegerInput stage
    "Stage of cooling coil (0: off, 1: first stage, 2: second stage...)"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Continuous.CriticalDamping criDam(
    f=1) "Smooths the step change in speed ratio. fixme: why is this needed?"
    annotation (Placement(transformation(extent={{-60,60},{-48,72}})));
  BaseClasses.SpeedSelect speSel(nSpe=datCoi.nSpe, speSet=datCoi.per.spe)
    annotation (Placement(transformation(extent={{-80,60},{-68,72}})));
  Modelica.Blocks.Math.IntegerToBoolean onSwi(final threshold=1)
    "On/off switch"
    annotation (Placement(transformation(extent={{-60,80},{-48,92}})));
equation
  connect(criDam.y, dxCoo.speRat)          annotation (Line(
      points={{-47.4,66},{-44,66},{-44,57.6},{-21,57.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speSel.speRat, criDam.u) annotation (Line(
      points={{-67.4,66},{-61.2,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onSwi.y, eva.on) annotation (Line(
      points={{-47.4,86},{-26,86},{-26,-62},{-10,-62}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(onSwi.y, dxCoo.on) annotation (Line(
      points={{-47.4,86},{-26,86},{-26,60},{-21,60}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(onSwi.u, stage) annotation (Line(
      points={{-61.2,86},{-92,86},{-92,80},{-110,80}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(stage, speSel.stage) annotation (Line(
      points={{-110,80},{-92,80},{-92,66},{-80.6,66}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (defaultComponentName="mulSpeDX", Documentation(info="<html>
<p>
This DX cooling coil model can be used to simulate stepwise multispeed compressor operation. 
It uses speed ratio as the control signal and should be controlled based on 
space temperature. The system will cease operation when conditions require a 
speed ratio below the minimum value. For a detailed description of cooling operation 
please refer to the documentation at 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil\"> 
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 28, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"),
    Icon(graphics={Text(
          extent={{-102,94},{-44,76}},
          lineColor={0,0,127},
          textString="stage")}),
    Diagram(graphics));
end MultiSpeed;
