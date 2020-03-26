within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model Configurator_uChiAva "Validate chiller staging configurator subsequence"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Configurator conf(
    final nSta=4,
    final nChi=3,
    final staMat={{1,0,0},{1,0,1},{0,1,1},{1,1,1}},
    final chiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal},
    final chiDesCap={1e6,1.5e6,2e6},
    final chiMinCap={2e5,3e5,4e5})
        "Stage configurator"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Configurator conf1(
    final nSta=4,
    final nChi=3,
    final staMat={{1,0,0},{1,0,1},{0,1,1},{1,1,1}},
    final chiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal},
    final chiDesCap={1e6,1.5e6,2e6},
    final chiMinCap={2e5,3e5,4e5})
        "Stage configurator"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Configurator conf3(
    final nSta=4,
    final nChi=3,
    final staMat={{1,0,0},{1,0,1},{0,1,1},{1,1,1}},
    final chiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal},
    final chiDesCap={1e6,1.5e6,2e6},
    final chiMinCap={2e5,3e5,4e5})
        "Stage configurator"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Configurator conf4(
    final nSta=4,
    final nChi=3,
    final staMat={{1,0,0},{1,0,1},{0,1,1},{1,1,1}},
    final chiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal},
    final chiDesCap={1e6,1.5e6,2e6},
    final chiMinCap={2e5,3e5,4e5})
        "Stage configurator"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Configurator conf5(
    final nSta=4,
    final nChi=3,
    final staMat={{1,0,0},{1,0,1},{0,1,1},{1,1,1}},
    final chiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal},
    final chiDesCap={1e6,1.5e6,2e6},
    final chiMinCap={2e5,3e5,4e5})
        "Stage configurator"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Configurator conf2(
    final nSta=4,
    final nChi=3,
    final staMat={{1,0,0},{1,0,1},{0,1,1},{1,1,1}},
    final chiTyp={Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.positiveDisplacement,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.variableSpeedCentrifugal,
        Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Types.ChillerAndStageTypes.constantSpeedCentrifugal},
    final chiDesCap={1e6,1.5e6,2e6},
    final chiMinCap={2e5,3e5,4e5})
        "Stage configurator"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));

protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiAva[3](
    final k={true,true,true})
    "Chiller availability array"
    annotation (Placement(transformation(extent={{-40,90},{-20,110}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiAva1[3](
    final k={false,true,true})
    "Chiller availability array"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiAva3[3](
    final k={true,true,false})
    "Chiller availability array"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiAva4[3](
    final k={true,false,false})
    "Chiller availability array"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiAva5[3](
    final k={false,false,false})
    "Chiller availability array"
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Constant chiAva2[3](
    final k={false,false,true})
    "Chiller availability array"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

equation
  connect(chiAva.y, conf.uChiAva)
    annotation (Line(points={{-18,100},{18,100}},color={255,0,255}));
  connect(chiAva1.y, conf1.uChiAva)
    annotation (Line(points={{-18,60},{18,60}}, color={255,0,255}));
  connect(chiAva3.y, conf3.uChiAva)
    annotation (Line(points={{-18,-20},{18,-20}}, color={255,0,255}));
  connect(chiAva4.y, conf4.uChiAva)
    annotation (Line(points={{-18,-60},{18,-60}}, color={255,0,255}));
  connect(chiAva5.y, conf5.uChiAva)
    annotation (Line(points={{-18,-100},{18,-100}}, color={255,0,255}));
  connect(chiAva2.y, conf2.uChiAva)
    annotation (Line(points={{-18,20},{18,20}}, color={255,0,255}));
annotation (
 experiment(StopTime=10.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/Configurator_uChiAva.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Configurator\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Configurator</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 7, 2019,by Milica Grahovac:<br/>
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
        coordinateSystem(preserveAspectRatio=false, extent={{-60,-120},{60,120}})));
end Configurator_uChiAva;
