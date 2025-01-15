within Buildings.DHC.Plants.Cooling.Subsystems.Examples;
model CoolingTowersWithBypass
  "Example model for parallel cooling towers with bypass valve"
  extends Modelica.Icons.Example;
  extends Buildings.DHC.Plants.Cooling.Subsystems.Examples.BaseClasses.PartialCoolingTowersSubsystem(
    redeclare Buildings.DHC.Plants.Cooling.Subsystems.CoolingTowersWithBypass tow(
      dpValve_nominal = 6000,
      dp_nominal(displayUnit="Pa") = 6000,
      TAirInWB_nominal=273.15 + 25.55,
      TWatIn_nominal=273.15 + 35,
      dT_nominal=5.56,
      PFan_nominal=4800,
      TMin=TMin,
      controllerType=Modelica.Blocks.Types.SimpleController.PI),
    weaDat(final computeWetBulbTemperature=true));
  parameter Modelica.Units.SI.Temperature TMin=273.15 + 10
    "Minimum allowed water temperature entering chiller";
equation
  connect(weaBus.TWetBul, tow.TWetBul)
   annotation (Line( points={{-59.95,50.05},{-8,50.05},{-8,-52},{20,-52}},
    color={255,204,51},thickness=0.5),
     Text(string="%first",index=-1,extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(hys.y, tow.on[1]) annotation (Line(points={{42,-190},{50,-190},{50,
          -130},{0,-130},{0,-46},{20,-46}}, color={255,0,255}));
  connect(hys.y, tow.on[2]) annotation (Line(points={{42,-190},{50,-190},{50,
          -130},{0,-130},{0,-46},{20,-46}}, color={255,0,255}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-140,-260},{140,100}})),
    experiment(
      StartTime=10368000,
      StopTime=10540800,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Plants/Cooling/Subsystems/Examples/CoolingTowersWithBypass.mos"
      "Simulate and Plot"),
    Documentation(
      revisions="<html>
<ul>
<li>
August 6, 2020 by Jing Wang:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>This model validates the parallel connected cooling tower subsystem in
<a href=\"modelica://Buildings.DHC.Plants.Cooling.Subsystems.CoolingTowersWithBypass\">
Buildings.DHC.Plants.Cooling.Subsystems.CoolingTowerWithBypass</a>.</p>
</html>"));
end CoolingTowersWithBypass;
