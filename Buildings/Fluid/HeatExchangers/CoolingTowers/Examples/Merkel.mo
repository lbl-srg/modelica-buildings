within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples;
model Merkel "Test model for cooling tower using the Merkel theory"
  extends Modelica.Icons.Example;
  extends BaseClasses.PartialStaticTwoPortCoolingTower(
    redeclare Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel tow(
      ratWatAir_nominal=ratWatAir_nominal,
      TAirInWB_nominal=273.15 + 25.55,
      TWatIn_nominal=273.15 + 35,
      TWatOut_nominal=273.15 + 35 - 5.56,
      PFan_nominal=4800),
    weaDat(final computeWetBulbTemperature=true));

  parameter Real ratWatAir_nominal = 0.625
    "Design water-to-air ratio"
    annotation (Dialog(group="Nominal condition"));

  Modelica.Blocks.Sources.Constant TSetLea(k=273.15 + 18)
    "Setpoint for leaving temperature"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));

  Buildings.Controls.OBC.CDL.Reals.PID conFan(
    k=1,
    Ti=60,
    Td=10,
    reverseActing=false,
    u_s(unit="K", displayUnit="degC"),
    u_m(unit="K", displayUnit="degC")) "Controller for tower fan"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));

equation
  connect(TSetLea.y, conFan.u_s)
    annotation (Line(
      points={{-59,10},{-42,10}},
      color={0,0,127}));
  connect(conFan.y, tow.y)
    annotation (Line(
      points={{-18,10},{10,10},{10,-42},{20,-42}},
      color={0,0,127}));
  connect(tow.TLvg, conFan.u_m)
    annotation (Line(
      points={{43,-56},{50,-56},{50,-20},{-30,-20},{-30,-2}},
      color={0,0,127}));
  connect(weaBus.TWetBul, tow.TAir) annotation (Line(
      points={{-59.95,50.05},{0,50.05},{0,-46},{20,-46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true,
      extent={{-140,-260},{140,100}})),
experiment(StartTime=15552000, Tolerance=1e-06, StopTime=15724800),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/CoolingTowers/Examples/Merkel.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=true,
        extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This example illustrates the use of the cooling tower model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel</a>.
Heat is injected into the volume <code>vol</code>. An on/off controller
switches the cooling loop water pump on or off based on the temperature of
this volume.
The cooling tower outlet temperature is controlled to track a fixed temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
October 22, 2019, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Merkel;
