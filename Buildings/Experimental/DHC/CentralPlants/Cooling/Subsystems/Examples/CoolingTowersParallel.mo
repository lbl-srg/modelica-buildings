within Buildings.Experimental.DHC.CentralPlants.Cooling.Subsystems.Examples;
model CoolingTowersParallel
  "Example model for parallel cooling tower model"
  extends Modelica.Icons.Example;
  extends BaseClasses.PartialCoolingTowersSubsystem(
    redeclare Buildings.Experimental.DHC.CentralPlants.Cooling.Subsystems.CoolingTowersParallel tow(
      TAirInWB_nominal=273.15+25.55,
      TWatIn_nominal=273.15+35,
      dT_nominal=5.56,
      dpValve_nominal = 6000,
      dp_nominal = 6000,
      PFan_nominal=4800),
    weaDat(final computeWetBulbTemperature=true));

   Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TSetLea(
    k=273.15+18)
    "Setpoint for leaving temperature"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conFan(
    k=1,
    Ti=60,
    Td=10,
    reverseActing=false,
    u_s(
      unit="K",
      displayUnit="degC"),
    u_m(
      unit="K",
      displayUnit="degC"))
    "Controller for tower fan"
    annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));
equation
  connect(TSetLea.y, conFan.u_s)
    annotation (Line(points={{-38,-10},{-32,-10}},color={0,0,127}));
  connect(tow.TLvg, conFan.u_m)
    annotation (Line(points={{43,-47},{54,-47},{54,-30},{-20,-30},{-20,-22}},
      color={0,0,127}));
  connect(onOffCon.y, tow.on[1])
    annotation (Line(points={{2,-190},{12,-190},{12,-236},{-96,-236},{-96,-34},{
          12,-34},{12,-44},{20,-44}},
                                   color={255,0,255}));
  connect(onOffCon.y, tow.on[2])
    annotation (Line(points={{2,-190},{12,-190},{12,-236},{-96,-236},{-96,-34},{
          12,-34},{12,-44},{20,-44}},        color={255,0,255}));
  connect(conFan.y, tow.uFanSpe)
    annotation (Line(points={{-8,-10},{4,-10},{4,-48},{20,-48}},
      color={0,0,127}));
  connect(weaBus.TWetBul, tow.TWetBul)
   annotation (Line(points={{-60,50},{-4,50},{-4,-56},{20,-56}},
    color={255,204,51},thickness=0.5),
     Text(string="%first",index=-1,extent={{-6,3},{-6,3}},
     horizontalAlignment=TextAlignment.Right));
  connect(conFan.trigger, onOffCon.y) annotation (Line(points={{-26,-22},{-26,-34},
          {-96,-34},{-96,-236},{12,-236},{12,-190},{2,-190}}, color={255,0,255}));
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
      StartTime=15552000,
      StopTime=15724800,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/CentralPlants/Cooling/Subsystems/Examples/CoolingTowersParallel.mos"
      "Simulate and Plot"),
    Documentation(
      info="<html>
<p>This model validates the parallel connected cooling tower subsystem in
<a href=\"modelica://Buildings.Experimental.DHC.CentralPlants.Cooling.Subsystems.CoolingTowersParallel\">
Buildings.Experimental.DHC.CentralPlants.Cooling.Subsystems.CoolingTowersParallel</a>.</p>
</html>",
      revisions="<html>
<ul>
<li>
August 6, 2020 by Jing Wang:<br/>
First implementation.
</li>
</ul>
</html>"));
end CoolingTowersParallel;
