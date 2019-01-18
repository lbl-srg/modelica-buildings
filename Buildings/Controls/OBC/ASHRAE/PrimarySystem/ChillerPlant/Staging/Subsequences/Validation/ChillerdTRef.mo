within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model ChillerdTRef "Validate model of calculate chiller LIFT"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.ChillerdTRef
    chillerdTRef_Sim(
    APPROACH_nominal=5,
    cooTowEff=21,
    dTRefMin=5,
    TWetBul_nominal=298.15,
    TConWatRet_nominal=303.15,
    TChiWatSup_nominal=280.15,
    plaCap_nominal=2600000)
    "Calculate current chiller lift, with simple algorithm"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatSupTem(
    amplitude=2,
    freqHz=1/1800,
    offset=279.15) "Chilled water supply temperature"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiWatRetTem(
    amplitude=2,
    freqHz=1/1800,
    offset=286.15) "Chilled water return temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp chiWatFloRat(
    duration=3600,
    height=0.05,
    offset=0.01) "Chilled water flow rate"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.ChillerdTRef
    chillerdTRef(
    APPROACH_nominal=5,
    cooTowEff=21,
    dTRefMin=5,
    use_simCoe=false,
    TWetBul_nominal=298.15,
    TConWatRet_nominal=303.15,
    TChiWatSup_nominal=280.15,
    plaCap_nominal=2600000) "Calculate current chiller lift"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));

equation
  connect(chiWatSupTem.y, chillerdTRef_Sim.TChiWatSup)
          annotation (Line(points={{-39,40},{-10,40},{-10,36},{18,36}}, color={0,0,127}));
  connect(chiWatRetTem.y, chillerdTRef_Sim.TChiWatRet)
          annotation (Line(points={{-39,0},{-10,0},{-10,30},{18,30}},
          color={0,0,127}));
  connect(chiWatFloRat.y, chillerdTRef_Sim.VEva_flow)
          annotation (Line(points={{-39,-40},{0,-40},{0,24},{18,24}},
          color={0,0,127}));
  connect(chiWatSupTem.y, chillerdTRef.TChiWatSup)
          annotation (Line(points={{-39,40},{-20,40},{-20,-4},{18,-4}},
          color={0,0,127}));
  connect(chiWatRetTem.y, chillerdTRef.TChiWatRet)
          annotation (Line(points={{-39,0},{-10,0},{-10,-10},{18,-10}},
          color={0,0,127}));
  connect(chiWatFloRat.y, chillerdTRef.VEva_flow)
          annotation (Line(points={{-39,-40},{0,-40},{0,-16},{18,-16}},
          color={0,0,127}));

annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/ChillerdTRef.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChilledTRef\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.ChilledTRef</a>.
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
end ChillerdTRef;
