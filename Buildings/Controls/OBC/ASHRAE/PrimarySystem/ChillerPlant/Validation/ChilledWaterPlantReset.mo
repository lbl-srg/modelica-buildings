within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Validation;
model ChilledWaterPlantReset
  "Validate model of generating chilled water plant reset"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChilledWaterPlantReset
    chiWatPlaRes "Chilled water plant reset"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uChiWatPum[2](
    k={true,false}) "Plant status"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real to integer"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    period=3600,
    width=0.18333333) "Generate pulse signal of type Boolean"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Switch between two Real signals"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con1(k=0)
    "Zero request when device is OFF"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real to integer"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChilledWaterPlantReset
    chiWatPlaRes1 "Chilled water plant reset"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanReplicator booRep(nout=2)
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTabLin(
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments, table=[0,
        0; 720,1; 1440,2; 2160,3; 2880,4; 3600,0])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTabLin1(
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    table=[0,0;150,1; 300,2; 450,3; 600,4; 750,5; 900,6;
           1050,5; 1200,4; 1350,3; 1500,2; 1650,1; 1800,0])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTabLin2(
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    table=[0,0;150,1; 300,2; 450,3; 600,4; 750,5; 900,6;
           1050,5; 1200,4; 1350,3; 1500,2; 1650,1; 1800,0])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));

equation
  connect(uChiWatPum.y, chiWatPlaRes.uChiWatPum)
          annotation (Line(points={{-59,80},{60,80},{60,76},{78,76}},
          color={255,0,255}));
  connect(con1.y,swi. u1)
          annotation (Line(points={{-59,-50},{-50,-50},{-50,-42},{-22,-42}},
          color={0,0,127}));
  connect(booPul.y,swi. u2)
          annotation (Line(points={{-59,-20},{-40,-20},{-40,-50},{-22,-50}},
          color={255,0,255}));
  connect(booPul.y,not1. u)
          annotation (Line(points={{-59,-20},{-22,-20}},color={255,0,255}));
  connect(not1.y, booRep.u)
          annotation (Line(points={{1,-20},{18,-20}}, color={255,0,255}));
  connect(booRep.y, chiWatPlaRes1.uChiWatPum)
          annotation (Line(points={{41,-20},{60,-20},{60,-24},{78,-24}},
          color={255,0,255}));
  connect(reaToInt1.y, chiWatPlaRes.TChiWatSupResReq)
          annotation (Line(points={{41,50},{60,50},{60,70},{78,70}},
          color={255,127,0}));
  connect(reaToInt2.y, chiWatPlaRes.uChiSta)
          annotation (Line(points={{41,20},{66,20},{66,64},{78,64}},
          color={255,127,0}));
  connect(reaToInt3.y, chiWatPlaRes1.TChiWatSupResReq)
          annotation (Line(points={{41,-50},{60,-50},{60,-30},{78,-30}},
          color={255,127,0}));
  connect(reaToInt2.y, chiWatPlaRes1.uChiSta)
          annotation (Line(points={{41,20},{66,20},{66,-36},{78,-36}},
          color={255,127,0}));
  connect(timTabLin.y[1], reaToInt2.u)
          annotation (Line(points={{1,20},{18,20}}, color={0,0,127}));
  connect(timTabLin1.y[1], reaToInt1.u)
          annotation (Line(points={{1,50},{18,50}}, color={0,0,127}));
  connect(timTabLin2.y[1], swi.u3)
          annotation (Line(points={{-59,-80},{-40,-80},{-40,-58},{-22,-58}},
          color={0,0,127}));
  connect(swi.y, reaToInt3.u)
          annotation (Line(points={{1,-50},{18,-50}}, color={0,0,127}));

annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Validation/ChilledWaterPlantReset.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChilledWaterPlantReset\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChilledWaterPump</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 14, 2018, by Jianjun Hu:<br/>
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
end ChilledWaterPlantReset;
