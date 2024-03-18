within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.Validation;
model ChilledWaterPlantReset
  "Validate model of generating chilled water plant reset"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterPlantReset
    plaRes "Chilled water plant reset"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterPlantReset
    devRes "Validate chilled water plant reset affected by device status"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uChiWatPum[2](
    final k={true,false}) "Plant status"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final period=2700,
    final width=0.3)
    "Generate pulse signal of type Boolean"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch between two Real signals"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(final k=0)
    "Zero request when device is OFF"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));

  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(nout=2)
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable timTabLin1(
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final table=[0,0;150,1; 300,2; 450,3; 600,4; 750,5; 900,6;
                 1050,5; 1200,4; 1350,3; 1500,2; 1650,1; 1800,0])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable timTabLin2(
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final table=[0,0;150,1; 300,2; 450,3; 600,4; 750,5; 900,6;
                 1050,5; 1200,4; 1350,3; 1500,2; 1650,1; 1800,0])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(final period=3600)
    "Generate pulse signal of type Boolean"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

equation
  connect(uChiWatPum.y, plaRes.uChiWatPum)
    annotation (Line(points={{-58,80},{40,80},{40,76},{58,76}}, color={255,0,255}));
  connect(con1.y,swi. u1)
    annotation (Line(points={{-58,-50},{-52,-50},{-52,-42},{-42,-42}},
      color={0,0,127}));
  connect(booPul.y,swi. u2)
    annotation (Line(points={{-58,-20},{-48,-20},{-48,-50},{-42,-50}},
      color={255,0,255}));
  connect(booPul.y,not1. u)
    annotation (Line(points={{-58,-20},{-42,-20}},color={255,0,255}));
  connect(not1.y, booRep.u)
    annotation (Line(points={{-18,-20},{-2,-20}}, color={255,0,255}));
  connect(booRep.y, devRes.uChiWatPum)
    annotation (Line(points={{22,-20},{40,-20},{40,-24},{58,-24}}, color={255,0,255}));
  connect(reaToInt1.y, plaRes.TChiWatSupResReq)
    annotation (Line(points={{22,50},{40,50},{40,70},{58,70}}, color={255,127,0}));
  connect(reaToInt3.y, devRes.TChiWatSupResReq)
    annotation (Line(points={{22,-50},{40,-50},{40,-30},{58,-30}}, color={255,127,0}));
  connect(timTabLin1.y[1], reaToInt1.u)
    annotation (Line(points={{-18,50},{-2,50}}, color={0,0,127}));
  connect(timTabLin2.y[1], swi.u3)
    annotation (Line(points={{-58,-80},{-52,-80},{-52,-58},{-42,-58}},
      color={0,0,127}));
  connect(swi.y, reaToInt3.u)
     annotation (Line(points={{-18,-50},{-2,-50}}, color={0,0,127}));
  connect(booPul1.y, plaRes.chaPro)
    annotation (Line(points={{22,20},{50,20},{50,64},{58,64}}, color={255,0,255}));
  connect(booPul1.y, devRes.chaPro)
    annotation (Line(points={{22,20},{50,20},{50,-36},{58,-36}}, color={255,0,255}));

annotation (
  experiment(StopTime=9000.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/SetPoints/Validation/ChilledWaterPlantReset.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterPlantReset\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterPlantReset</a>.
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
