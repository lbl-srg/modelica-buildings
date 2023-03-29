within Buildings.Fluid.HeatExchangers.DXCoils.AirSource;
model SingleSpeed "Single speed DX cooling coil"
  extends Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoil(
      dxCoo(final variableSpeedCoil=false,
            wetCoi(redeclare Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacityAirCooled cooCap),
            dryCoi(redeclare Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoolingCapacityAirCooled cooCap)),
      redeclare Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.DXCoil datCoi,
      use_mCon_flow=false);
  Modelica.Blocks.Sources.Constant speRat(final k=1) "Speed ratio"
    annotation (Placement(transformation(extent={{-56,58},{-44,70}})));
  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));
protected
  Modelica.Blocks.Math.BooleanToInteger onSwi(
    final integerTrue=1,
    final integerFalse=0) "On/off switch"
    annotation (Placement(transformation(extent={{-56,74},{-44,86}})));
initial equation
  assert(datCoi.nSta == 1, "Must have one stage only for single speed performance data");
equation
  connect(speRat.y, dxCoo.speRat) annotation (Line(
      points={{-43.4,64},{-40,64},{-40,57.6},{-21,57.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(eva.on, on) annotation (Line(
      points={{-10,-62},{-92,-62},{-92,80},{-110,80}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(on, onSwi.u) annotation (Line(
      points={{-110,80},{-57.2,80}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(onSwi.y, dxCoo.stage) annotation (Line(
      points={{-43.4,80},{-34,80},{-34,60},{-21,60}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (defaultComponentName="sinSpeDX", Documentation(info="<html>
<p>
This model can be used to simulate an air source DX cooling coil with single speed compressor.
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
April 12, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Text(
          extent={{-140,132},{-96,112}},
          textColor={0,0,255},
          textString="on")}));
end SingleSpeed;
