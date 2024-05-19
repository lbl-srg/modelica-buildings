within Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConInletSensor.Subsequences.Validation;
model Dampers
  "Validate model for controlling damper position of dual-duct unit using mixing control with inlet flow sensor"

  Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConInletSensor.Subsequences.Dampers dam1(
    final VCooMax_flow=0.08,
    final VHeaMax_flow=0.06,
    final kDam=1) "Output signal for controlling damper position"
    annotation (Placement(transformation(extent={{80,-90},{100,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uCoo(
    final height=-1,
    final duration=3600,
    final offset=1,
    final startTime=900) "Cooling control signal"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TZon(
    final k=273.15 + 22)
    "Zone temperature"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TCooSup(
    final k=273.15 + 13)
    "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant VActMin_flow(
    final k=0.01)
    "Active minimum airflow setpoint"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant VActCooMax_flow(
    final k=0.075)
    "Active cooling maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin VColDuc(
    final offset=0.015,
    final amplitude=0.002,
    final freqHz=1/3600)
    "Cold-duct airflow rate"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse cooAhu(
    final width=0.75,
    final period=7200)
    "Cold air handling unit status"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaSup(
    final k=273.15 + 25)
    "AHU supply air temperature"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp uHea(
    final height=1,
    final duration=3600,
    final offset=0,
    final startTime=5500)
    "Heating control signal"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant VActHeaMax_flow(
    final k=0.07)
    "Active heating maximum airflow setpoint"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse heaAhu(
    final width=0.75,
    final period=7200,
    final shift=5000)
    "Hot air handling unit status"
    annotation (Placement(transformation(extent={{-60,-80},{-40,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin VHotDuc(
    final offset=0.015,
    final amplitude=0.002,
    final freqHz=1/3600)
    "Hot-duct airflow rate"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));

equation
  connect(VActMin_flow.y, dam1.VActMin_flow) annotation (Line(points={{-78,30},{
          44,30},{44,-68},{78,-68}}, color={0,0,127}));
  connect(TZon.y, dam1.TZon) annotation (Line(points={{-38,10},{40,10},{40,-72},
          {78,-72}}, color={0,0,127}));
  connect(VActCooMax_flow.y, dam1.VActCooMax_flow) annotation (Line(points={{-38,90},
          {56,90},{56,-54},{78,-54}},   color={0,0,127}));
  connect(uCoo.y, dam1.uCoo) annotation (Line(points={{-78,110},{60,110},{60,-51},
          {78,-51}}, color={0,0,127}));
  connect(TCooSup.y, dam1.TColSup) annotation (Line(points={{-78,70},{52,70},{52,
          -57},{78,-57}},    color={0,0,127}));
  connect(cooAhu.y, dam1.u1CooAHU) annotation (Line(points={{-38,50},{48,50},{48,
          -63},{78,-63}}, color={255,0,255}));
  connect(THeaSup.y, dam1.THotSup) annotation (Line(points={{-78,-10},{36,-10},{
          36,-77},{78,-77}},  color={0,0,127}));
  connect(uHea.y, dam1.uHea) annotation (Line(points={{-38,-30},{32,-30},{32,-80},
          {78,-80}},  color={0,0,127}));
  connect(VActHeaMax_flow.y, dam1.VActHeaMax_flow) annotation (Line(points={{-78,-50},
          {28,-50},{28,-83},{78,-83}},      color={0,0,127}));
  connect(heaAhu.y, dam1.u1HeaAHU) annotation (Line(points={{-38,-70},{24,-70},{24,
          -89},{78,-89}}, color={255,0,255}));
  connect(VColDuc.y, dam1.VColDucDis_flow) annotation (Line(points={{-78,-100},{
          56,-100},{56,-60},{78,-60}}, color={0,0,127}));
  connect(VHotDuc.y, dam1.VHotDucDis_flow) annotation (Line(points={{-38,-120},{
          60,-120},{60,-86},{78,-86}},  color={0,0,127}));
annotation (
  experiment(StopTime=7200, Tolerance=1e-6),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/TerminalUnits/DualDuctMixConInletSensor/Subsequences/Validation/Dampers.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConInletSensor.Subsequences.Dampers\">
BBuildings.Controls.OBC.ASHRAE.G36.TerminalUnits.DualDuctMixConInletSensor.Subsequences.Dampers</a>
for damper control of dual-duct unit.
</p>
</html>", revisions="<html>
<ul>
<li>
February 10, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}}),
                   Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}), Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(extent={{-120,-160},{120,160}})));
end Dampers;
