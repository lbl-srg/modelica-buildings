within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.Validation;
model OutdoorAirFlowSetpoint_MultiZone
  "Validate the model of calculating minimum outdoor airflow setpoint"
  extends Modelica.Icons.Example;
  parameter Integer numOfZon = 5 "Total number of zones that the system serves";
  Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.OutdoorAirFlowSetpoint_MultiZone
    outdoorAirFlowSetpoint(numOfZon=numOfZon)
    annotation (Placement(transformation(extent={{-14,-12},{28,30}})));
  CDL.Continuous.Constant numOfOccupant[numOfZon](k=fill(2, numOfZon))
    "Number of occupant detected in each zone"
    annotation (Placement(transformation(extent={{-90,40},{-80,50}})));
  CDL.Continuous.Constant cooCtrl(k=0.5) "Cooling control signal"
    annotation (Placement(transformation(extent={{-90,20},{-80,30}})));
  CDL.Logical.Constant winSta[numOfZon](k=fill(false,numOfZon))
    "Status of windows in each zone"
    annotation (Placement(transformation(extent={{-90,-2},{-80,8}})));
  CDL.Logical.Constant supFan(k=true) "Status of supply fan"
    annotation (Placement(transformation(extent={{-90,-26},{-80,-16}})));
  CDL.Continuous.Constant zonPriFloRat[numOfZon](k={0.1,0.12,0.2,0.09,0.1})
    "Detected primary flow rate in each zone"
    annotation (Placement(transformation(extent={{-90,-52},{-80,-42}})));
equation
  for i in 1:numOfZon loop
    connect(numOfOccupant[i].y, outdoorAirFlowSetpoint.occCou[i]) annotation (
        Line(points={{-79.5,45},{-30,45},{-30,23.7},{-16.1,23.7}},    color={0,0,
            127}));
    connect(cooCtrl.y, outdoorAirFlowSetpoint.uCoo) annotation (Line(points={{-79.5,
            25},{-40,25},{-40,16.14},{-16.1,16.14}},  color={0,0,127}));
    connect(winSta[i].y, outdoorAirFlowSetpoint.uWindow[i]) annotation (Line(
          points={{-79.5,3},{-51.75,3},{-51.75,8.58},{-16.1,8.58}},  color={255,
            0,255}));
    connect(supFan.y, outdoorAirFlowSetpoint.uSupFan) annotation (Line(points={{-79.5,
            -21},{-40,-21},{-40,1.02},{-16.1,1.02}},          color={255,0,255}));
    connect(zonPriFloRat[i].y, outdoorAirFlowSetpoint.priAirflow[i])
      annotation (Line(points={{-79.5,-47},{-30,-47},{-30,-6.12},{-16.1,-6.12}},
          color={0,0,127}));
  end for;

   annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/OutdoorAirFlowSetpoint_MultiZone.mos"
    "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.OutdoorAirFlowSetpoint_MultiZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.OutdoorAirFlowSetpoint_MultiZone</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OutdoorAirFlowSetpoint_MultiZone;
