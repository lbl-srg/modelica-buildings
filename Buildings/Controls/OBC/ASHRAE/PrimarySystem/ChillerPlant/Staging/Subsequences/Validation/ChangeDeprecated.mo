within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model ChangeDeprecated
  "Validates stage change for fixed speed chillers"

  parameter Modelica.SIunits.Temperature TChiWatSupSet = 285.15
  "Chilled water supply set temperature";

  parameter Modelica.SIunits.Temperature aveTChiWatRet = 288.15
  "Average measured chilled water return temperature";

  parameter Real aveVChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") = 0.05
    "Average measured chilled water flow rate";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios
    staChaPosDis "Determines if the stage should go up, down or stay constant"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios
    staChaPosDis1 "Determines if the stage should go up, down or stay constant"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));

  .Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios
    staChaPosDis2 "Determines if the stage should go up, down or stay constant"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));

  .Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios
    staChaPosDis3 "Determines if the stage should go up, down or stay constant"
    annotation (Placement(transformation(extent={{100,-20},{120,0}})));

  .Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios
    staChaPosDis4 "Determines if the stage should go up, down or stay constant"
    annotation (Placement(transformation(extent={{-20,-80},{0,-60}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stageMax(k=2) "Last stage"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage0(k=0) "0th stage"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant stage1(k=1) "0th stage"
    annotation (Placement(transformation(extent={{-120,100},{-100,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capReq0(k=0.05*500000)
    "Capacity requirement below first stage "
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capReq1(k=300000)
    "Capacity requirement for stage 1"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant NomStaCap2(k=1000000)
    "Nominal stage 2 capacity "
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capReq2(k=700000)
    "Capacity requirement for stage 2"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capReq3(k=1200000)
    "Capacity requirement above maximal available stage"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant NomSta1LowCap(k=0.1*500000)
    "Minimal capacity at stage 1"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant NomSta1Cap(k=500000)
    "Nominal stage 1 capacity "
    annotation (Placement(transformation(extent={{-80,100},{-60,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant sta0Cap(k=0.000001)
                                               "Nominal stage 0 capacity "
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  CDL.Continuous.Sources.Constant                        sta0Cap1(k=0.000001)
                                               "Nominal stage 0 capacity "
    annotation (Placement(transformation(extent={{-180,100},{-160,120}})));
  CDL.Continuous.Sources.Constant                        sta0Cap2(k=0.000001)
                                               "Nominal stage 0 capacity "
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  CDL.Continuous.Sources.Constant                        sta0Cap3(k=0.000001)
                                               "Nominal stage 0 capacity "
    annotation (Placement(transformation(extent={{-180,20},{-160,40}})));
  CDL.Continuous.Sources.Constant                        sta0Cap4(k=0.000001)
                                               "Nominal stage 0 capacity "
    annotation (Placement(transformation(extent={{-180,-20},{-160,0}})));
  CDL.Continuous.Sources.Constant                        sta0Cap5(k=0.000001)
                                               "Nominal stage 0 capacity "
    annotation (Placement(transformation(extent={{-180,-60},{-160,-40}})));
  CDL.Continuous.Sources.Constant                        sta0Cap6(k=0.000001)
                                               "Nominal stage 0 capacity "
    annotation (Placement(transformation(extent={{-180,-100},{-160,-80}})));
equation

  connect(stage0.y, staChaPosDis.uChiSta) annotation (Line(points={{41,110},{50,
          110},{50,130},{90,130},{90,120},{99,120}}, color={255,127,0}));
  connect(capReq1.y, staChaPosDis.uCapReq) annotation (Line(points={{41,70},{90,
          70},{90,117},{99,117}}, color={0,0,127}));
  connect(stage1.y, staChaPosDis1.uChiSta) annotation (Line(points={{-99,110},{-90,
          110},{-90,128},{-30,128},{-30,120},{-21,120}}, color={255,127,0}));
  connect(capReq2.y, staChaPosDis1.uCapReq) annotation (Line(points={{-59,50},{
          -30,50},{-30,117},{-21,117}},
                                    color={0,0,127}));
  connect(NomSta1LowCap.y, staChaPosDis1.uStaLowCap) annotation (Line(points={{
          -59,80},{-40,80},{-40,108},{-21,108}}, color={0,0,127}));
  connect(NomSta1Cap.y, staChaPosDis1.uStaCap) annotation (Line(points={{-59,
          110},{-40,110},{-40,110},{-21,110}}, color={0,0,127}));
  connect(sta0Cap.y, staChaPosDis.uStaCap) annotation (Line(points={{81,110},{
          90,110},{90,110},{99,110}}, color={0,0,127}));
  connect(sta0Cap.y, staChaPosDis.uStaLowCap) annotation (Line(points={{81,110},
          {90,110},{90,108},{99,108}}, color={0,0,127}));
  connect(stageMax.y, staChaPosDis2.uChiSta) annotation (Line(points={{-99,-10},
          {-80,-10},{-80,0},{-21,0}}, color={255,127,0}));
  connect(NomStaCap2.y, staChaPosDis2.uStaCap) annotation (Line(points={{-59,-30},
          {-40,-30},{-40,-10},{-21,-10}}, color={0,0,127}));
  connect(NomSta1Cap.y, staChaPosDis2.uStaLowCap) annotation (Line(points={{-59,
          110},{-42,110},{-42,-12},{-21,-12}}, color={0,0,127}));
  connect(capReq1.y, staChaPosDis2.uCapReq) annotation (Line(points={{41,70},{
          60,70},{60,30},{-32,30},{-32,-3},{-21,-3}},color={0,0,127}));
  connect(stageMax.y, staChaPosDis4.uChiSta) annotation (Line(points={{-99,-10},
          {-90,-10},{-90,-60},{-21,-60}}, color={255,127,0}));
  connect(capReq3.y, staChaPosDis4.uCapReq) annotation (Line(points={{-59,-90},
          {-40,-90},{-40,-63},{-21,-63}},color={0,0,127}));
  connect(NomStaCap2.y, staChaPosDis4.uStaCap) annotation (Line(points={{-59,-30},
          {-40,-30},{-40,-70},{-21,-70}}, color={0,0,127}));
  connect(NomSta1Cap.y, staChaPosDis4.uStaLowCap) annotation (Line(points={{-59,
          110},{-40,110},{-40,-72},{-21,-72}}, color={0,0,127}));
  connect(stageMax.y, staChaPosDis3.uChiSta) annotation (Line(points={{-99,-10},
          {-90,-10},{-90,12},{80,12},{80,0},{99,0}}, color={255,127,0}));
  connect(staChaPosDis3.uCapReq, capReq0.y) annotation (Line(points={{99,-3},{
          80.5,-3},{80.5,-50},{61,-50}},
                                     color={0,0,127}));
  connect(NomStaCap2.y, staChaPosDis3.uStaCap) annotation (Line(points={{-59,-30},
          {20,-30},{20,-10},{99,-10}}, color={0,0,127}));
  connect(NomSta1Cap.y, staChaPosDis3.uStaLowCap) annotation (Line(points={{-59,
          110},{-44,110},{-44,-28},{22,-28},{22,-12},{99,-12}}, color={0,0,127}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/ChangeDeprecated.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PositiveDisplacement\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PositiveDisplacement</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, by Milica Grahovac:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-240},{140,140}})));
end ChangeDeprecated;
