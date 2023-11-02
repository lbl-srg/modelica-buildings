within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.Validation;
model SupplySignals
  "Validate model for controlling coil valve postion of multi zone VAV AHU"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplySignals supSig
    "Output valve position and supply air temperature control loop signal"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFanSta(period=7200)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Pulse TSup(
    final amplitude=14,
    final period=7200,
    final offset=10 + 273.15)
    "Supply air temperature"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSupSet(
    final height=3,
    final duration=7200,
    final offset=15 + 273.15)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplySignals supSig1
    "Output valve position and supply air temperature control loop signal"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanOn(
    final k=true) "Fan on"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

equation
  connect(TSupSet.y, supSig.TAirSupSet) annotation (Line(points={{-58,80},{-40,
          80},{-40,70},{18,70}}, color={0,0,127}));
  connect(TSup.y, supSig.TAirSup) annotation (Line(points={{-58,40},{-30,40},{-30,
          64},{18,64}}, color={0,0,127}));
  connect(supFanSta.y, supSig.u1SupFan) annotation (Line(points={{-58,0},{-20,0},
          {-20,76},{18,76}}, color={255,0,255}));
  connect(TSupSet.y, supSig1.TAirSupSet) annotation (Line(points={{-58,80},{-40,
          80},{-40,10},{18,10}}, color={0,0,127}));
  connect(TSup.y, supSig1.TAirSup) annotation (Line(points={{-58,40},{-30,40},{
          -30,4},{18,4}}, color={0,0,127}));
  connect(fanOn.y, supSig1.u1SupFan) annotation (Line(points={{-58,-40},{0,-40},
          {0,16},{18,16}}, color={255,0,255}));

annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/SetPoints/Validation/SupplySignals.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplySignals\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.SupplySignals</a>
for a change of the supply air temperature setpoint, measured supply air temperature and
the supply fan status, to specify coil valve positions, and generate control
loop signal.
</p>
</html>", revisions="<html>
<ul>
<li>
November 1, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}));
end SupplySignals;
