within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples;
model FixedApproachWetBulb
  "Test model for cooling tower with fixed approach temperature using the wet-bulb temperature"
  extends Modelica.Icons.Example;
  extends BaseClasses.PartialStaticTwoPortCoolingTower(
    redeclare CoolingTowers.FixedApproach tow(
      m_flow_nominal=m_flow_nominal),
    weaDat(
      final computeWetBulbTemperature=true));
equation
  connect(weaBus.TWetBul, tow.TAir) annotation (Line(
      points={{-59.95,50.05},{0,50.05},{0,-46},{20,-46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-140,-260},
            {140,100}})),
experiment(StartTime=15552000, Tolerance=1e-06, StopTime=15984000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/CoolingTowers/Examples/FixedApproachWetBulb.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
            Documentation(info="<html>
<p>
This example illustrates the use of the cooling tower model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach\">
Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach</a>, using
the outdoor wet-bulb temperature as the potential for heat transfer.
Heat is injected into the volume <code>vol</code>. An on/off controller
switches the cooling loop water pump on or off based on the temperature of
this volume.
The cooling tower outlet temperature has a fixed approach temperature to the
outdoor wet-bulb temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
July 12, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FixedApproachWetBulb;
