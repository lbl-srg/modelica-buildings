within Buildings.Fluid.HeatExchangers.DXCoils;
model MultiStage "Multi-stage DX cooling coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil;

  Modelica.Blocks.Interfaces.IntegerInput stage
    "Stage of cooling coil (0: off, 1: first stage, 2: second stage...)"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  BaseClasses.SpeedSelect speSel(nSpe=datCoi.nSpe, speSet=datCoi.per.spe)
    annotation (Placement(transformation(extent={{-80,60},{-68,72}})));
  Modelica.Blocks.Math.IntegerToBoolean onSwi(final threshold=1)
    "On/off switch"
    annotation (Placement(transformation(extent={{-60,80},{-48,92}})));
equation
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
  connect(speSel.speRat, dxCoo.speRat) annotation (Line(
      points={{-67.4,66},{-40,66},{-40,57.6},{-21,57.6}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="mulStaDX", Documentation(info="<html>
<p>
This DX cooling coil model can be used to simulate coils with multiple
operating stages. Depending on the used performance curves, each
stage could be a different compressor speed, or a different mode 
of operation, such as with or without hot gas reheat.
</p>
<p>
The model uses the operating stage as an input control signal.
For a detailed description of cooling operation 
please refer to the documentation at 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil\"> 
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 6, 2012 by Michael Wetter:<br>
Changed control signal from a real number to an integer that is equal to the stage of
the coil.
Removed filter at the control input signal because there is anyway an 
event when the signal changes, and because the filter led in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Examples.SpaceCooling\">
Buildings.Fluid.HeatExchangers.DXCoils.Examples.SpaceCooling</a>
to a higher computing time.
</li>
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
end MultiStage;
