within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples;
model YorkCalc
  "Test model for cooling tower using the York performance correlation"
  extends Modelica.Icons.Example;
  extends BaseClasses.PartialStaticTwoPortCoolingTowerWetBulb(
    redeclare CoolingTowers.YorkCalc tow(energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial),
    onOffController(bandwidth=2));

  Modelica.Blocks.Sources.Constant TSetLea(k=273.15 + 18)
    "Setpoint for leaving temperature"
                 annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Controls.Continuous.LimPID conFan(
    k=1,
    Ti=60,
    Td=10,
    reverseAction=true,
    initType=Modelica.Blocks.Types.InitPID.InitialState)
    "Controller for tower fan"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
equation
  connect(wetBulTem.TWetBul, tow.TAir) annotation (Line(
      points={{1,50},{12,50},{12,-46},{22,-46}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TSetLea.y, conFan.u_s) annotation (Line(
      points={{-39,-10},{-22,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conFan.y, tow.y) annotation (Line(
      points={{1,-10},{6,-10},{6,-42},{22,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tow.TLvg, conFan.u_m) annotation (Line(
      points={{45,-56},{54,-56},{54,-32},{-10,-32},{-10,-22}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation(Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-140,-260},
            {140,100}}),
                      graphics),
experiment(StartTime=15552000, StopTime=15724800),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/CoolingTowers/Examples/YorkCalc.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-180},{100,
            100}})),
    Documentation(info="<html>
This example illustrates the use of the cooling tower model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc\">
Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc</a>.
Heat is injected into the volume <code>vol</code>. An on/off controller
switches the cooling loop water pump on or off based on the temperature of
this volume.
The cooling tower outlet temperature is controlled to track a fixed temperature.
</html>", revisions="<html>
<ul>
<li>
July 12, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end YorkCalc;
