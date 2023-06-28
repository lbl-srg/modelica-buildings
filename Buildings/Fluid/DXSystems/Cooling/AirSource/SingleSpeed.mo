within Buildings.Fluid.DXSystems.Cooling.AirSource;
model SingleSpeed "Single speed DX cooling coil"
  extends
    Buildings.Fluid.DXSystems.Cooling.BaseClasses.PartialDXCoolingCoil(
    dxCoi(
      final variableSpeedCoil=false,
      wetCoi(redeclare
          Buildings.Fluid.DXSystems.BaseClasses.CapacityAirSource
          coiCap),
      dryCoi(redeclare
          Buildings.Fluid.DXSystems.BaseClasses.CapacityAirSource
          coiCap)),
    use_mCon_flow=false);

  Modelica.Blocks.Sources.Constant speRat(
    final k=1)
    "Speed ratio"
    annotation (Placement(transformation(extent={{-56,58},{-44,70}})));

  Modelica.Blocks.Interfaces.BooleanInput on
    "Set to true to enable compressor, or false to disable compressor"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));

protected
  Modelica.Blocks.Math.BooleanToInteger onSwi(
    final integerTrue=1,
    final integerFalse=0)
    "On/off switch"
    annotation (Placement(transformation(extent={{-56,74},{-44,86}})));

initial equation
  assert(datCoi.nSta == 1, "Must have one stage only for single speed performance data");

equation
  connect(speRat.y,dxCoi.speRat)  annotation (Line(
      points={{-43.4,64},{-40,64},{-40,59.6},{-21,59.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(watVapEva.on, on) annotation (Line(
      points={{-12,-56},{-92,-56},{-92,80},{-110,80}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(on, onSwi.u) annotation (Line(
      points={{-110,80},{-57.2,80}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(onSwi.y,dxCoi.stage)  annotation (Line(
      points={{-43.4,80},{-34,80},{-34,62},{-21,62}},
      color={255,127,0},
      smooth=Smooth.None));
annotation (defaultComponentName="sinSpeDXCoo", Documentation(info="<html>
<p>
This model can be used to simulate an air source DX cooling coil with single speed compressor.
</p>
<p>
See
<a href=\"modelica://Buildings.Fluid.DXSystems.Cooling.UsersGuide\">
Buildings.Fluid.DXSystems.Cooling.UsersGuide</a>
for an explanation of the model.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 19, 2023 by Xing Lu and Karthik Devaprasad:<br/>
Renamed class to <code>SingleSpeedDXCooling</code> to differentiate it from DX
heating coils.<br/>
Updated connection statements to reflect change in instance name from <code>dxCoo</code>
to <code>dxCoi</code>.<br/>
Updated formatting for readability.
</li>
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
          textString="on"),Line(points={{-120,80},{-88,80},{-88,23.8672},{-2,24},
              {-2,2.0215},{10,2}},                                    color={217,
              67,180})}));
end SingleSpeed;
