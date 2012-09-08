within Buildings.Fluid.HeatExchangers.DXCoils;
model SingleSpeed "Single speed DX cooling coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil(
    dxCoo(final variableSpeedCoil=false),
    final nSpe=1);
  Modelica.Blocks.Sources.Constant speRat(final k=1) "Speed ratio"
    annotation (Placement(transformation(extent={{-72,58},{-60,70}})));
  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
protected
  Modelica.Blocks.Math.BooleanToInteger onSwi(
    final integerTrue=1,
    final integerFalse=0) "On/off switch"
    annotation (Placement(transformation(extent={{-72,74},{-60,86}})));
equation
  connect(speRat.y, dxCoo.speRat) annotation (Line(
      points={{-59.4,64},{-40,64},{-40,57.6},{-21,57.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eva.on, on) annotation (Line(
      points={{-10,-62},{-92,-62},{-92,80},{-110,80}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(on, onSwi.u) annotation (Line(
      points={{-110,80},{-73.2,80}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(onSwi.y, dxCoo.stage) annotation (Line(
      points={{-59.4,80},{-34,80},{-34,60},{-21,60}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (defaultComponentName="sinSpeDX", Diagram(graphics), Documentation(info="<html>
<p>
This model can be used to simulate DX cooling coil with single speed compressors. 
It uses an on/off control signal and should be controlled based on space 
temperature (not the temperature at the outlet of the coil). For a detailed 
description of cooling operation please refer to the documentation at
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil\"> 
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil</a>
</p>
</html>",
revisions="<html>
<ul>
<li>
April 12, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"),
    Icon(graphics={Text(
          extent={{-140,132},{-96,112}},
          lineColor={0,0,255},
          textString="on")}));
end SingleSpeed;
