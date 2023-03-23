within Buildings.Fluid.HeatExchangers.DXCoils.AirSource;
model MultiStage "Multi-stage DX cooling coil"

  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil(
      dxCoo(final variableSpeedCoil=false,
          wetCoi(redeclare Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacityAirCooled cooCap),
          dryCoi(redeclare Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacityAirCooled cooCap)),
      redeclare Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.DXCoil datCoi,
      use_mCon_flow=false);

  Modelica.Blocks.Interfaces.IntegerInput stage
    "Stage of cooling coil (0: off, 1: first stage, 2: second stage...)"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}}),
        iconTransformation(extent={{-120,70},{-100,90}})));
  BaseClasses.SpeedSelect speSel(nSta=datCoi.nSta, speSet=datCoi.sta.spe)
    annotation (Placement(transformation(extent={{-80,60},{-68,72}})));
  Modelica.Blocks.Math.IntegerToBoolean onSwi(final threshold=1)
    "On/off switch"
    annotation (Placement(transformation(extent={{-56,-68},{-44,-56}})));
equation
  connect(onSwi.y, eva.on) annotation (Line(
      points={{-43.4,-62},{-26,-62},{-26,-64},{-10,-64}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(onSwi.u, stage) annotation (Line(
      points={{-57.2,-62},{-92,-62},{-92,80},{-110,80}},
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
  connect(stage, dxCoo.stage) annotation (Line(
      points={{-110,80},{-30,80},{-30,60},{-21,60}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (defaultComponentName="mulStaDX", Documentation(info="<html>
<p>
This model can be used to simulate an air source DX cooling coil with multiple
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
</html>",
revisions="<html>
<ul>
<li>
March 7, 2022, by Michael Wetter:<br/>
Set <code>final massDynamics=energyDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">#1542</a>.
</li>
<li>
September 6, 2012 by Michael Wetter:<br/>
Changed control signal from a real number to an integer that is equal to the stage of
the coil.
Removed filter at the control input signal because there is anyway an
event when the signal changes, and because the filter led in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Examples.SpaceCooling\">
Buildings.Fluid.HeatExchangers.DXCoils.Examples.SpaceCooling</a>
to a higher computing time.
</li>
<li>
July 28, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Text(
          extent={{-102,94},{-44,76}},
          textColor={0,0,127},
          textString="stage")}));
end MultiStage;
