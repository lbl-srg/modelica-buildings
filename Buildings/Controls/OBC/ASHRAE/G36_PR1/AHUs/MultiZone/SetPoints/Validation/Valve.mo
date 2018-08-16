within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.Validation;
model Valve
  "Validate model for controlling coil valve postion of multi zone VAV AHU"

  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplySignals AHUValve
    "Output valve position and supply air temperature control loop signal"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse supFanSta(period=7200)
    "Supply fan status"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TSup(
    amplitude=2,
    offset=16 + 273.15,
    freqHz=1/7200) "Supply air temperature"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp TSupSet(
    height=3,
    duration=7200,
    offset=15 + 273.15)
    "Supply air temperature setpoint"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplySignals AHUValve1
    "Output valve position and supply air temperature control loop signal"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant fanOn(k=true) "Fan on"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

equation
  connect(TSupSet.y, AHUValve.TSetSup)
    annotation (Line(points={{-59,80},{-40,80},{-40,75},{19,75}},
      color={0,0,127}));
  connect(TSup.y, AHUValve.TSup)
    annotation (Line(points={{-59,40},{-30,40},{-30,70},{19,70}},
      color={0,0,127}));
  connect(supFanSta.y, AHUValve.uSupFan)
    annotation (Line(points={{-59,0},{-20,0},{-20,65},{19,65}},
      color={255,0,255}));
  connect(TSupSet.y, AHUValve1.TSetSup)
    annotation (Line(points={{-59,80},{-40,80},{-40,15},{19,15}},
      color={0,0,127}));
  connect(TSup.y, AHUValve1.TSup)
    annotation (Line(points={{-59,40},{-30,40},{-30,10},{19,10}},
      color={0,0,127}));
  connect(fanOn.y, AHUValve1.uSupFan)
    annotation (Line(points={{-59,-40},{0,-40},{0,5},{19,5}},
      color={255,0,255}));

annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36_PR1/AHUs/MultiZone/SetPoints/Validation/Valve.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplySignals\">
Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplySignals</a>
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
end Valve;
