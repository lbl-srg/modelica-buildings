within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples;
model FixedApproachWetBulb
  "Test model for cooling tower with fixed approach temperature using the wet-bulb temperature"
  extends Modelica.Icons.Example;
  extends BaseClasses.PartialStaticTwoPortCoolingTowerWetBulb(
    redeclare CoolingTowers.FixedApproach tow);
equation
  connect(wetBulTem.TWetBul, tow.TAir) annotation (Line(
      points={{1,50},{10,50},{10,-46},{22,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-140,-260},
            {140,100}}),
                      graphics),
experiment(StartTime=15552000, StopTime=15984000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/CoolingTowers/Examples/FixedApproachWetBulb.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-180},{100,
            100}})),
            Documentation(info="<html>
This example illustrates the use of the cooling tower model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach\">
Buildings.Fluid.HeatExchangers.CoolingTowers.FixedApproach</a>, using
the outdoor wet-bulb temperature as the potential for heat transfer.
Heat is injected into the volume <code>vol</code>. An on/off controller
switches the cooling loop water pump on or off based on the temperature of
this volume.
The cooling tower outlet temperature has a fixed approach temperature to the
outdoor wet-bulb temperature.
</html>", revisions="<html>
<ul>
<li>
July 12, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end FixedApproachWetBulb;
