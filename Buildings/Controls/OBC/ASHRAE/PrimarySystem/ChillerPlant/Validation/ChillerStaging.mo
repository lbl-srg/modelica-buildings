within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Validation;
model ChillerStaging "Validate model of controlling chiller stage"

  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine outTem(
    amplitude=6,
    freqHz=1/(24*3600),
    offset=293.15) "Outdoor temperature"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChillerStaging
    chiStaCon(
    chiOnHou=5,
    chiOffHou=22,
    TLocChi=288.71)
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp PLR(
    height=1,
    offset=0,
    duration=18000,
    startTime=18000) "Actual partial load ratio"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine conWatRetTem(
    amplitude=5,
    offset=303.15,
    freqHz=1/14400) "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatSupTem(
    amplitude=2,
    offset=280.15,
    freqHz=1/14400) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp chiWatPlaRes(
    height=1,
    offset=0,
    duration=28800,
    startTime=18000) "Chilled water plant reset"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp plaResReq(
    height=10,
    offset=0,
    duration=36000,
    startTime=18000) "Plant reset requests"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp plaResReq1(
    height=10,
    offset=0,
    duration=36000,
    startTime=18000) "Plant reset requests"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    threshold=2)
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr1(
    threshold=5)
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

equation
  connect(plaResReq.y, reaToInt.u)
    annotation (Line(points={{-59,-30},{-42,-30}}, color={0,0,127}));
  connect(plaResReq1.y, greEquThr.u)
    annotation (Line(points={{-59,-60},{-42,-60}}, color={0,0,127}));
  connect(outTem.y, chiStaCon.TOut)
    annotation (Line(points={{-59,80},{44,80},{44,9},{59,9}},
      color={0,0,127}));
  connect(PLR.y, chiStaCon.uPLR)
    annotation (Line(points={{-19,60},{40,60},{40,6},{59,6}},
      color={0,0,127}));
  connect(conWatRetTem.y, chiStaCon.TConWatRet)
    annotation (Line(points={{-59,40},{36,40},{36,3},{59,3}},
      color={0,0,127}));
  connect(chiWatSupTem.y, chiStaCon.TChiWatSup)
    annotation (Line(points={{-19,20},{32,20},{32,0},{59,0}},
      color={0,0,127}));
  connect(chiWatPlaRes.y, chiStaCon.uChiWatPlaRes)
    annotation (Line(points={{-59,0},{28,0},{28,-3},{59,-3}},
      color={0,0,127}));
  connect(reaToInt.y, chiStaCon.TChiWatSupResReq)
    annotation (Line(points={{-19,-30},{36,-30},{36,-6},{59,-6}},
      color={255,127,0}));
  connect(greEquThr.y, chiStaCon.uChi[1])
    annotation (Line(points={{-19,-60},{40,-60},{40,-9},{59,-9}},
      color={255,0,255}));
  connect(greEquThr1.y, chiStaCon.uChi[2])
    annotation (Line(points={{-19,-90},{40,-90},{40,-9},{59,-9}},
      color={255,0,255}));
  connect(plaResReq1.y, greEquThr1.u)
    annotation (Line(points={{-59,-60},{-50,-60},{-50,-90},{-42,-90}},
      color={0,0,127}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Validation/ChillerStaging.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChillerStaging\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChillerStaging</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 19, 2018, by Jianjun Hu:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChillerStaging;
