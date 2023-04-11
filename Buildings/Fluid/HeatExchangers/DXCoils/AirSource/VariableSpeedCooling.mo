within Buildings.Fluid.HeatExchangers.DXCoils.AirSource;
model VariableSpeedCooling "Variable speed DX cooling coil"
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialDXCoolingCoil(
    dxCoi(
      final variableSpeedCoil=true,
      wetCoi(redeclare
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilCapacityAirSource
          coiCap),
      dryCoi(redeclare
          Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.CoilCapacityAirSource
          coiCap)),
    redeclare
      Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.Generic.CoolingCoil
      datCoi,
    use_mCon_flow=false);

  parameter Real minSpeRat(
    final min=0,
    final max=1)
    "Minimum speed ratio";

  parameter Real speRatDeaBan= 0.05
    "Deadband for minimum speed ratio";

  Modelica.Blocks.Interfaces.RealInput speRat(
    final unit="1",
    displayUnit="1")
    "Speed ratio"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}}),
      iconTransformation(extent={{-120,70},{-100,90}})));

protected
  Modelica.Blocks.Logical.Hysteresis deaBan(
    final uLow=minSpeRat - speRatDeaBan/2,
    final uHigh=minSpeRat + speRatDeaBan/2)
    "Speed ratio deadband"
    annotation (Placement(transformation(extent={{-64,64},{-52,76}})));

  Modelica.Blocks.Math.BooleanToInteger onSwi(
    final integerTrue=1,
    final integerFalse=0)
    "On/off switch"
    annotation (Placement(transformation(extent={{-42,64},{-30,76}})));

equation
  connect(speRat,dxCoi.speRat)  annotation (Line(
      points={{-110,80},{-90,80},{-90,59.6},{-21,59.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, deaBan.u)
                         annotation (Line(
      points={{-110,80},{-90,80},{-90,70},{-65.2,70}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(deaBan.y, eva.on) annotation (Line(
      points={{-51.4,70},{-48,70},{-48,62},{-92,62},{-92,-54},{-12,-54}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(onSwi.y,dxCoi.stage)  annotation (Line(
      points={{-29.4,70},{-26,70},{-26,62},{-21,62}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(deaBan.y, onSwi.u) annotation (Line(
      points={{-51.4,70},{-43.2,70}},
      color={255,0,255},
      smooth=Smooth.None));
  annotation (defaultComponentName="varSpeDXCoo", Documentation(info="<html>
<p>
This model can be used to simulate an air source DX cooling coil with continuously 
variable speed compressors.
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
March 19, 2023 by Xing Lu and Karthik Devaprasad:<br/>
Renamed class to <code>VariableSpeedDXCooling</code> to differentiate it from DX heating coils.<br/>
Updated connect statement to reflect name change of instance from <code>dxCoo</code>
to <code>dxCoi</code>.<br/>
Updated formatting. 
</li>
<li>
March 7, 2022, by Michael Wetter:<br/>
Set <code>final massDynamics=energyDynamics</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">#1542</a>.
</li>
<li>
July 28, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>

</html>"),
    Icon(graphics={Text(
          extent={{-96,96},{-38,78}},
          textColor={0,0,127},
          textString="speRat")}));
end VariableSpeedCooling;
