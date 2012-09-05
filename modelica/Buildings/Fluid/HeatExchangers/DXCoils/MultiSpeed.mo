within Buildings.Fluid.HeatExchangers.DXCoils;
model MultiSpeed "Multispeed DX cooling coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil;
  parameter Real minSpeRat( min=0,max=1) "Minimum speed ratio";
  parameter Real speRatDeaBan= 0.05 "Deadband for minimum speed ratio";
  Modelica.Blocks.Interfaces.RealInput speRat "Speed ratio"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}}),
        iconTransformation(extent={{-120,60},{-100,80}})));
  Modelica.Blocks.Continuous.CriticalDamping criDam(
    f=1) "Smooths the step change in speed ratio. fixme: why is this needed?"
    annotation (Placement(transformation(extent={{-60,60},{-48,72}})));
  Modelica.Blocks.Logical.Hysteresis deaBan(
    uLow=minSpeRat - speRatDeaBan/2, uHigh=minSpeRat + speRatDeaBan/2)
    "Speed ratio deadband"
    annotation (Placement(transformation(extent={{-66,80},{-54,92}})));
  BaseClasses.SpeedSelect speSel(nSpe=datCoi.nSpe, speSet=datCoi.per.spe)
    annotation (Placement(transformation(extent={{-80,60},{-68,72}})));
equation
  connect(criDam.y, dxCoo.speRat)          annotation (Line(
      points={{-47.4,66},{-44,66},{-44,57.6},{-21,57.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, deaBan.u)
                         annotation (Line(
      points={{-110,70},{-92,70},{-92,86},{-67.2,86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, speSel.speRatIn) annotation (Line(
      points={{-110,70},{-92,70},{-92,66},{-81.2,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speSel.speRat, criDam.u) annotation (Line(
      points={{-67.4,66},{-61.2,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deaBan.y, eva.on) annotation (Line(
      points={{-53.4,86},{-32,86},{-32,-60},{-10,-60}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(deaBan.y, dxCoo.on) annotation (Line(
      points={{-53.4,86},{-32,86},{-32,60},{-21,60}},
      color={255,0,255},
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
          extent={{-160,96},{-102,78}},
          lineColor={0,0,255},
          textString="speRat")}),
    Diagram(graphics));
end MultiSpeed;
