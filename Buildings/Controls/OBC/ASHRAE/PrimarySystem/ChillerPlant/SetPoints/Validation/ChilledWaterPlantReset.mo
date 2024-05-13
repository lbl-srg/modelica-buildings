within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.Validation;
model ChilledWaterPlantReset
  "Validate model of generating chilled water plant reset"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterPlantReset
    plaRes "Chilled water plant reset"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.SetPoints.ChilledWaterPlantReset
    devRes "Validate chilled water plant reset affected by device status"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant uChiWatPum[2](
    final k={true,false}) "Plant status"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real to integer"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final period=9500,
    final width=0.3,
    shift=-2000)
    "Generate pulse signal of type Boolean"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1 "Logical not"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "Switch between two Real signals"
    annotation (Placement(transformation(extent={{-30,-90},{-10,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(final k=0)
    "Zero request when device is OFF"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real to integer"
    annotation (Placement(transformation(extent={{10,-90},{30,-70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booRep(
    nout=2)
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable timTabLin1(
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    table=[0,0;150,1; 300,2; 450,3; 600,4; 750,5; 900,6;
           1050,5; 1200,4; 1350,3; 1500,2; 1650,1; 1800,0])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable timTabLin2(
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    table=[0,0;150,1; 300,2; 450,3; 600,4; 750,5; 900,6;
           1050,5; 1200,4; 1350,3; 1500,2; 1650,1; 1800,0])
    "Time table with smoothness method of constant segments"
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    period=3600)
    "Generate pulse signal of type Boolean"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch staPro "Staging process"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    k=false) "Constant false"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(width=0.4,
    period=4800)
    "Generate pulse signal of type Boolean"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));

equation
  connect(uChiWatPum.y, plaRes.uChiWatPum)
    annotation (Line(points={{-58,100},{40,100},{40,96},{58,96}}, color={255,0,255}));
  connect(con1.y,swi. u1)
    annotation (Line(points={{-58,-70},{-40,-70},{-40,-72},{-32,-72}},
      color={0,0,127}));
  connect(booPul.y,swi. u2)
    annotation (Line(points={{-58,-40},{-50,-40},{-50,-80},{-32,-80}},
      color={255,0,255}));
  connect(booPul.y,not1. u)
    annotation (Line(points={{-58,-40},{-42,-40}},color={255,0,255}));
  connect(not1.y, booRep.u)
    annotation (Line(points={{-18,-40},{8,-40}},  color={255,0,255}));
  connect(booRep.y, devRes.uChiWatPum)
    annotation (Line(points={{32,-40},{40,-40},{40,-44},{58,-44}}, color={255,0,255}));
  connect(reaToInt1.y, plaRes.TChiWatSupResReq)
    annotation (Line(points={{22,80},{40,80},{40,90},{58,90}}, color={255,127,0}));
  connect(reaToInt3.y, devRes.TChiWatSupResReq)
    annotation (Line(points={{32,-80},{40,-80},{40,-50},{58,-50}}, color={255,127,0}));
  connect(timTabLin1.y[1], reaToInt1.u)
    annotation (Line(points={{-18,80},{-2,80}}, color={0,0,127}));
  connect(timTabLin2.y[1], swi.u3)
    annotation (Line(points={{-58,-100},{-40,-100},{-40,-88},{-32,-88}},
      color={0,0,127}));
  connect(swi.y, reaToInt3.u)
     annotation (Line(points={{-8,-80},{8,-80}}, color={0,0,127}));
  connect(booPul1.y, plaRes.chaPro)
    annotation (Line(points={{-58,60},{50,60},{50,84},{58,84}},color={255,0,255}));
  connect(staPro.y, devRes.chaPro) annotation (Line(points={{22,10},{50,10},{50,
          -56},{58,-56}}, color={255,0,255}));
  connect(con.y, staPro.u3) annotation (Line(points={{-58,-10},{-30,-10},{-30,2},
          {-2,2}}, color={255,0,255}));
  connect(not1.y, staPro.u2) annotation (Line(points={{-18,-40},{-10,-40},{-10,10},
          {-2,10}}, color={255,0,255}));
  connect(booPul2.y, staPro.u1) annotation (Line(points={{-38,30},{-10,30},{-10,
          18},{-2,18}}, color={255,0,255}));

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
<p>
The instance <code>plaRes</code> shows the process of calculating the plant reset.
It also shows that when the plant is in staging process, the reset value will be fixed
at the value when the staging process just starts.
</p>
<ul>
<li>
At the initial 1800 seconds, the plant is in the staging process. Thus the chilled
water plant reset equals 0, which is the reset initial value.
</li>
<li>
In the period between 1800 seconds and 3600 seconds, the plant is not in the staging
process. Thus the plant reset equals the trim-respond output.
</li>
<li>
At the 3600 seconds, the staging process starts again and thus the plant reset
holds its value at 3600 seconds.
</li>
</ul>
<p>
The process of calculating the reset value follows the same steps.
For the instance <code>devRes</code>, besides the same process as showing in the
instance <code>plaRes</code>, the <code>devRes</code> also shows that the reset
value will be zero when the device is disabled (<code>uDevSta=false</code>).
</p>
</html>", revisions="<html>
<ul>
<li>
March 14, 2018, by Jianjun Hu:<br/>
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
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-120},{100,120}})));
end ChilledWaterPlantReset;
