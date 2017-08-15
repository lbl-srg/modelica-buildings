within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.Validation;
model OperationMode "Validate block OperationModeSelector"
  extends Modelica.Icons.Example;
  Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.OperationModeSelector
    opeModSel(numOfZon=1) "Block that outputs the operation mode"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Ramp ramp1(
    offset=0,
    height=6.2831852,
    duration=24*3600) "Block that generates ramp signal"
    annotation (Placement(transformation(extent={{-96,-10},{-76,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sin sin1
    "Block that outputs the sine of the input"
    annotation (Placement(transformation(extent={{-52,-10},{-32,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.AddParameter addPar(
      p=22.5, k=12.5)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Constant unoHeaSet(
      k=12) "Unoccupied heating setpoint"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Constant unoCooSet(
      k=30) "Unoccupied cooling setpoint"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Constant occHeaSet(
      k=20) "Occupied heating setpoint"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Constant occCooSet(
      k=24) "Occupied cooling setpoint"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Constant warUpTim(k=
       1800) "Warm-up time"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Continuous.Sources.Constant cooDowTim(
      k=1800) "Cooling down time"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Experimental.OpenBuildingControl.CDL.Logical.Sources.Constant uWinSta(k=false)
    "Window on/off status" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={70,-40})));
  Controls.SetPoints.OccupancySchedule occSch
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
equation
  connect(ramp1.y, sin1.u)
    annotation (Line(points={{-75,0},{-64,0},{-54,0}}, color={0,0,127}));
  connect(sin1.y, addPar.u)
    annotation (Line(points={{-31,0},{-2,0}}, color={0,0,127}));
  connect(addPar.y, opeModSel.TZon[1])
    annotation (Line(points={{21,0},{59,0}}, color={0,0,127}));
  connect(occHeaSet.y, opeModSel.THeaSet) annotation (Line(points={{-39,-30},{-20,
          -30},{-20,-12},{34,-12},{34,-2.2},{59,-2.2}}, color={0,0,127}));
  connect(occCooSet.y, opeModSel.TCooSet) annotation (Line(points={{21,-30},{28,
          -30},{36,-30},{36,-4.6},{59,-4.6}}, color={0,0,127}));
  connect(unoHeaSet.y, opeModSel.TUnoHeaSet) annotation (Line(points={{-39,-70},
          {-20,-70},{-20,-48},{38,-48},{38,-6.8},{59,-6.8}}, color={0,0,127}));
  connect(unoCooSet.y, opeModSel.TUnoCooSet) annotation (Line(points={{21,-70},{
          30,-70},{40,-70},{40,-9},{59,-9}}, color={0,0,127}));
  connect(warUpTim.y, opeModSel.warUpTim[1]) annotation (Line(points={{-39,40},{
          -20,40},{-20,20},{34,20},{34,2},{46,2},{46,2.2},{59,2.2}}, color={0,0,
          127}));
  connect(cooDowTim.y, opeModSel.cooDowTim[1]) annotation (Line(points={{21,40},
          {36,40},{36,4},{48,4},{48,4.4},{59,4.4}}, color={0,0,127}));
  connect(uWinSta.y, opeModSel.uWinSta[1])
    annotation (Line(points={{70,-29},{70,-20},{70,-11}}, color={255,0,255}));
  connect(occSch.tNexOcc, opeModSel.tNexOcc) annotation (Line(points={{21,76},{38,
          76},{38,6.6},{59,6.6}}, color={0,0,127}));
  connect(occSch.occupied, opeModSel.uOcc) annotation (Line(points={{21,64},{40,
          64},{40,9},{59,9}}, color={255,0,255}));
  annotation (
  experiment(StopTime=86400, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/OperationMode.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.OperationModeSelector\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.OperationModeSelector</a>
for a change of zone temperature and occupancy schedule.
</p>
</html>", revisions="<html>
<ul>
<li>
June 19, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OperationMode;
