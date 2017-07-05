within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.Validation;
model OutAirFlowSet_MultiZone
  "Validate the model of calculating minimum outdoor airflow setpoint"
  extends Modelica.Icons.Example;
  parameter Integer numOfZon = 5 "Total number of zones that the system serves";
  Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.OutdoorAirFlowSetpoint_MultiZone
    outAirSet_MulZon(numOfZon=numOfZon,
    zonAre=fill(40, numOfZon),
    maxSysPriFlo=1,
    minZonPriFlo=fill(0.08, numOfZon),
    peaSysPop=20)
    "Block to output minimum outdoor airflow rate for system with multiple zones "
    annotation (Placement(transformation(extent={{-14,-12},{28,30}})));
  CDL.Continuous.Constant numOfOcc[numOfZon](k=fill(2, numOfZon))
    "Number of occupant detected in each zone"
    annotation (Placement(transformation(extent={{-90,40},{-80,50}})));
  CDL.Continuous.Constant cooCtr(k=0.5) "Cooling control signal"
    annotation (Placement(transformation(extent={{-90,20},{-80,30}})));
  CDL.Logical.Constant winSta[numOfZon](k=fill(false,numOfZon))
    "Status of windows in each zone"
    annotation (Placement(transformation(extent={{-90,-2},{-80,8}})));
  CDL.Logical.Constant supFan(k=true) "Status of supply fan"
    annotation (Placement(transformation(extent={{-90,-26},{-80,-16}})));
  CDL.Continuous.Constant zonPriFloRat[numOfZon](k={0.1,0.12,0.2,0.09,0.1})
    "Measured primary flow rate in each zone at VAV box"
    annotation (Placement(transformation(extent={{-90,-52},{-80,-42}})));
equation
  for i in 1:numOfZon loop
    connect(numOfOcc[i].y, outAirSet_MulZon.nOcc[i]) annotation (Line(points={{
            -79.5,45},{-30,45},{-30,23.7},{-16.1,23.7}}, color={0,0,127}));
    connect(cooCtr.y, outAirSet_MulZon.cooCtrSig) annotation (Line(points={{-79.5,
            25},{-40,25},{-40,17.4},{-16.1,17.4}},   color={0,0,127}));
    connect(winSta[i].y, outAirSet_MulZon.uWindow[i]) annotation (Line(points={{-79.5,3},
            {-51.75,3},{-51.75,9},{-16.1,9}},                 color={255,0,255}));
    connect(supFan.y, outAirSet_MulZon.uSupFan) annotation (Line(points={{-79.5,
            -21},{-40,-21},{-40,1.02},{-16.1,1.02}}, color={255,0,255}));
    connect(zonPriFloRat[i].y, outAirSet_MulZon.priAirflow[i]) annotation (Line(
          points={{-79.5,-47},{-30,-47},{-30,-5.7},{-16.1,-5.7}},   color={0,0,
            127}));
  end for;

   annotation (
  experiment(StopTime=1.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/OutAirFlowSet_MultiZone.mos"
    "Simulate and plot"),
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
end OutAirFlowSet_MultiZone;
