within Buildings.Controls.OBC.ASHRAE.G36.AHU.SetPoints.Validation;
model OutdoorAirFlowSetpointSingleZone
  "Validate the model of calculating minimum outdoor airflow setpoint"
  extends Modelica.Icons.Example;

  Buildings.Controls.OBC.ASHRAE.G36.AHU.SetPoints.OutdoorAirFlowSetpointSingleZone
    outAirSet_SinZon(zonAre=40)
    "Block to output minimum outdoor airflow rate for system with single zone "
    annotation (Placement(transformation(extent={{20,-20},{60,20}})));
  CDL.Continuous.Sources.Ramp numOfOcc(
    height=4,
    duration=3600)
    "Number of occupant detected in zone"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  CDL.Logical.Sources.Constant winSta(k=false) "Window status"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  CDL.Logical.Sources.Constant supFan(k=true) "Supply fan status"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  CDL.Continuous.Sources.Ramp TZon(
    height=6,
    offset=273.15 + 17,
    duration=3600) "Measured zone temperature"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  CDL.Continuous.Sources.Ramp TSup(
    height=4,
    duration=3600,
    offset=273.15 + 18) "Supply air temperature"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(numOfOcc.y, outAirSet_SinZon.nOcc)
    annotation (Line(points={{-39,50},{0,50},{0,16},{18,16}},
      color={0,0,127}));
  connect(winSta.y, outAirSet_SinZon.uWin) annotation (Line(points={{-39,-40},{-9.75,
          -40},{-9.75,-8},{18,-8}}, color={255,0,255}));
  connect(supFan.y, outAirSet_SinZon.uSupFan)
    annotation (Line(points={{-39,-70}, {0,-70},{0,-16},{18,-16}},
      color={255,0,255}));
  connect(TZon.y, outAirSet_SinZon.TZon)
    annotation (Line(points={{-39,20},{-39,20},{-10,20},{-10,10},{18,10}},
      color={0,0,127}));
  connect(TSup.y, outAirSet_SinZon.TSup)
    annotation (Line(points={{-39,-10},{-20,-10},{-20,4},{18,4}},
      color={0,0,127}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHU/SetPoints/Validation/OutdoorAirFlowSetpointSingleZone.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHU.SetPoints.OutdoorAirFlowSetpointSingleZone\">
Buildings.Controls.OBC.ASHRAE.G36.AHU.SetPoints.OutdoorAirFlowSetpointSingleZone</a>.
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
end OutdoorAirFlowSetpointSingleZone;
