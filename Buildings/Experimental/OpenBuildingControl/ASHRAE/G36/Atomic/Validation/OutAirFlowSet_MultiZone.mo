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
    annotation (Placement(transformation(extent={{20,-20},{60,20}})));
  CDL.Continuous.Sources.Constant numOfOcc[numOfZon](k=fill(2, numOfZon))
    "Number of occupant detected in each zone"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  CDL.Logical.Sources.Constant winSta[numOfZon](k=fill(false,numOfZon))
    "Status of windows in each zone"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  CDL.Logical.Sources.Constant supFan(k=true) "Status of supply fan"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  CDL.Continuous.Sources.Constant zonPriFloRat[numOfZon](k={0.1,0.12,0.2,0.09,0.1})
    "Measured primary flow rate in each zone at VAV box"
    annotation (Placement(transformation(extent={{-60,-90},{-40,-70}})));
  CDL.Continuous.Sources.Ramp TZon[numOfZon](
    each height=6,
    each offset=273.15 + 17,
    each duration=3600) "Zone space temperature"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  CDL.Continuous.Sources.Ramp TSup[numOfZon](
    each height=4,
    each duration=3600,
    each offset=273.15 + 18) "Supply air temperature"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
equation
  for i in 1:numOfZon loop
    connect(numOfOcc[i].y, outAirSet_MulZon.nOcc[i])
      annotation (Line(points={{-39,70}, {0,70},{0,16},{18,16}},
        color={0,0,127}));
    connect(winSta[i].y, outAirSet_MulZon.uWindow[i])
      annotation (Line(points={{-39,-20}, {-19.75,-20},{-19.75,-4},{18,-4}},
        color={255,0,255}));
    connect(supFan.y, outAirSet_MulZon.uSupFan)
      annotation (Line(points={{-39,-50}, {-10,-50},{-10,-10},{18,-10}},
        color={255,0,255}));
    connect(zonPriFloRat[i].y, outAirSet_MulZon.priAirflow[i])
      annotation (Line(points={{-39,-80},{0,-80},{0,-16},{18,-16}},
        color={0,0, 127}));
    connect(TZon[i].y, outAirSet_MulZon.TZon[i])
      annotation (Line(points={{-39,40},{-10,40},{-10,10},{18,10}},
        color={0,0,127}));
    connect(TSup[i].y, outAirSet_MulZon.TSup[i])
      annotation (Line(points={{-39,10},{-20,10},{-20,4},{18,4}},
        color={0,0,127}));
  end for;

  annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
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
July 6, 2017, by Jianjun Hu:<br/>
Revised implementation.
</li>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OutAirFlowSet_MultiZone;
