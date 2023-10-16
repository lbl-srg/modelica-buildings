within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Validation;
model Controller
  "Validation sequence of controlling tower fan speed when waterside economizer is enabled"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Controller
    wseOpe "Tower fan speed control when waterside economizer is enabled"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.05,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Logical.Not fanSpeSwi "Two fan speed switch"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin chiSup(
    final amplitude=0.5,
    final freqHz=1/1800,
    final offset=273.15 + 7.1) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-100,-110},{-80,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant chiSupSet(
    final k=273.15 + 7)
    "Chilled water supply water setpoint"
    annotation (Placement(transformation(extent={{0,-150},{20,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(final k=0.1)
    "Minimum fan speed"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram(
    final height=0.2,
    final duration=3600,
    final offset=0.1,
    final startTime=1750) "Tower speed"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ram1(
    final height=3,
    final duration=3600,
    final startTime=1500) "Ramp"
    annotation (Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2 "Add real inputs"
    annotation (Placement(transformation(extent={{-40,-130},{-20,-110}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi1 "Logical switch"
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin(
    final amplitude=0.2*1e4,
    final freqHz=1/1200,
    final offset=1.1*1e4,
    final startTime=180) "Chiller load"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(final width=0.5,
    final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Logical.Not chiSta1 "First chiller status"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiSta2(
    final k=false) "Second chiller status"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    final width=0.95,
    final period=3600)
    "Waterside economizer enabling status"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));

equation
  connect(booPul.y, fanSpeSwi.u)
    annotation (Line(points={{-78,0},{-62,0}}, color={255,0,255}));
  connect(con.y, swi.u3)
    annotation (Line(points={{-78,-70},{-40,-70},{-40,-58},{-2,-58}},
      color={0,0,127}));
  connect(fanSpeSwi.y, swi.u2)
    annotation (Line(points={{-38,0},{-20,0},{-20,-50},{-2,-50}}, color={255,0,255}));
  connect(ram.y, swi.u1)
    annotation (Line(points={{-78,-30},{-40,-30},{-40,-42},{-2,-42}},
      color={0,0,127}));
  connect(chiSup.y, add2.u1)
    annotation (Line(points={{-78,-100},{-60,-100},{-60,-114},{-42,-114}},
      color={0,0,127}));
  connect(ram1.y, add2.u2)
    annotation (Line(points={{-78,-140},{-60,-140},{-60,-126},{-42,-126}},
      color={0,0,127}));
  connect(booPul1.y, chiSta1.u)
    annotation (Line(points={{-78,40},{-62,40}}, color={255,0,255}));
  connect(con1.y, swi1.u3)
    annotation (Line(points={{-78,90},{-60,90},{-60,102},{-2,102}}, color={0,0,127}));
  connect(sin.y, swi1.u1)
    annotation (Line(points={{-78,130},{-60,130},{-60,118},{-2,118}}, color={0,0,127}));
  connect(chiSta1.y, swi1.u2)
    annotation (Line(points={{-38,40},{-20,40},{-20,110},{-2,110}}, color={255,0,255}));
  connect(chiSta2.y, wseOpe.uChi[2])
    annotation (Line(points={{22,70},{50,70},{50,6},{98,6}}, color={255,0,255}));
  connect(chiSta1.y, wseOpe.uChi[1])
    annotation (Line(points={{-38,40},{50,40},{50,6},{98,6}}, color={255,0,255}));
  connect(swi1.y, wseOpe.chiLoa[1])
    annotation (Line(points={{22,110},{60,110},{60,9},{98,9}},   color={0,0,127}));
  connect(con1.y, wseOpe.chiLoa[2])
    annotation (Line(points={{-78,90},{60,90},{60,9},{98,9}},   color={0,0,127}));
  connect(wseSta.y, wseOpe.uWse)
    annotation (Line(points={{22,10},{40,10},{40,2},{98,2}}, color={255,0,255}));
  connect(swi.y,wseOpe.uFanSpe)
    annotation (Line(points={{22,-50},{60,-50},{60,-2},{98,-2}}, color={0,0,127}));
  connect(add2.y, wseOpe.TChiWatSup)
    annotation (Line(points={{-18,-120},{70,-120},{70,-6},{98,-6}}, color={0,0,127}));
  connect(chiSupSet.y, wseOpe.TChiWatSupSet)
    annotation (Line(points={{22,-140},{80,-140},{80,-9},{98,-9}},   color={0,0,127}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Towers/FanSpeed/EnabledWSE/Validation/Controller.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Controller\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Towers.FanSpeed.EnabledWSE.Controller</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 12, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
      graphics={
            Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-160},{140,160}})));
end Controller;
