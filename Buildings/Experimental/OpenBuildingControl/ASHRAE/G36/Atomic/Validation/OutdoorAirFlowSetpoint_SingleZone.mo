within Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.Validation;
model OutdoorAirFlowSetpoint_SingleZone
  "Validate the model of calculating minimum outdoor airflow setpoint"
  extends Modelica.Icons.Example;

  Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.OutdoorAirFlowSetpoint_SingleZone
    outAirSet_SinZon
    "Block to output minimum outdoor airflow rate for system with single zone "
    annotation (Placement(transformation(extent={{-14,-12},{28,30}})));
  CDL.Sources.Ramp numOfOcc(height=4, duration=20)
    "Number of occupant detected in zone"
    annotation (Placement(transformation(extent={{-90,40},{-80,50}})));
  CDL.Continuous.Constant cooCtr(k=0.5) "Cooling control signal"
    annotation (Placement(transformation(extent={{-90,20},{-80,30}})));
  CDL.Logical.Constant winSta(k=false)
    "Status of windows in each zone"
    annotation (Placement(transformation(extent={{-90,-2},{-80,8}})));
  CDL.Logical.Constant supFan(k=true) "Status of supply fan"
    annotation (Placement(transformation(extent={{-90,-26},{-80,-16}})));
equation
  connect(numOfOcc.y, outAirSet_SinZon.occCou) annotation (Line(points={{-79.5,
          45},{-30,45},{-30,21.6},{-16.1,21.6}}, color={0,0,127}));
  connect(cooCtr.y, outAirSet_SinZon.cooCtrSig) annotation (Line(points={{-79.5,
          25},{-40,25},{-40,13.2},{-16.1,13.2}}, color={0,0,127}));
  connect(winSta.y, outAirSet_SinZon.uWindow) annotation (Line(points={{-79.5,3},
          {-51.75,3},{-51.75,4.8},{-16.1,4.8}}, color={255,0,255}));
  connect(supFan.y, outAirSet_SinZon.uSupFan) annotation (Line(points={{-79.5,-21},
          {-40,-21},{-40,-3.6},{-16.1,-3.6}}, color={255,0,255}));

annotation (
  experiment(StopTime=20.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/OpenBuildingControl/ASHRAE/G36/Atomic/Validation/OutdoorAirFlowSetpoint_SingleZone.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.OutdoorAirFlowSetpoint_SingleZone\">
Buildings.Experimental.OpenBuildingControl.ASHRAE.G36.Atomic.OutdoorAirFlowSetpoint_SingleZone</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 12, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end OutdoorAirFlowSetpoint_SingleZone;
