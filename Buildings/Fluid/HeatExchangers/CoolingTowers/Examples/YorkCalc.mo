within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples;
model YorkCalc
  "Test model for cooling tower using the York performance correlation"
  extends Modelica.Icons.Example;
  extends BaseClasses.PartialStaticTwoPortCoolingTower(
    redeclare CoolingTowers.YorkCalc tow,
    weaDat(
      final computeWetBulbTemperature=true));

  Modelica.Blocks.Sources.Constant TSetLea(k=273.15 + 18)
    "Setpoint for leaving temperature"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Controls.Continuous.LimPID conFan(
    k=1,
    Ti=60,
    Td=10,
    reverseActing=false,
    initType=Modelica.Blocks.Types.Init.InitialState)
    "Controller for tower fan"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
equation
  connect(TSetLea.y, conFan.u_s) annotation (Line(
      points={{-59,10},{-42,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conFan.y, tow.y) annotation (Line(
      points={{-19,10},{10,10},{10,-42},{20,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(tow.TLvg, conFan.u_m) annotation (Line(
      points={{43,-56},{50,-56},{50,-20},{-30,-20},{-30,-2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(weaBus.TWetBul, tow.TAir) annotation (Line(
      points={{-60,50},{0,50},{0,-46},{20,-46}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
annotation(Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-140,-260},
            {140,100}}),
                      graphics),
experiment(StartTime=15552000, Tolerance=1e-06, StopTime=15724800),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/CoolingTowers/Examples/YorkCalc.mos"
        "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,
            100}})),
    Documentation(info="<html>
<p>
This example illustrates the use of the cooling tower model
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc\">
Buildings.Fluid.HeatExchangers.CoolingTowers.YorkCalc</a>.
Heat is injected into the volume <code>vol</code>. An on/off controller
switches the cooling loop water pump on or off based on the temperature of
this volume.
The cooling tower outlet temperature is controlled to track a fixed temperature.
</p>
</html>", revisions="<html>
<ul>
<li>
July 12, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end YorkCalc;
