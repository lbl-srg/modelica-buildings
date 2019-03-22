within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.Validation;
model PlantEnable "Validation sequence for enabling and disabling chiller plant"

  parameter Modelica.SIunits.Temperature aveTWetBul = 288.15
    "Chilled water supply set temperature";
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable enaPlaWse0(
    final schTab=[0,0; 6*3600,1; 19*3600,0; 24*3600,0])
    "Enabling control of plant with waterside economizer, stage up from zero"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable enaPlaWse1(
    final schTab=[0,0; 6*3600,1; 19*3600,1; 24*3600,0])
    "Enabling control of plant with waterside economizer, stage up from one"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable disPlaSch(
    final haveWSE=false,
    final schTab=[0,0; 6*3600,1; 19*3600,0; 24*3600,0])
    "Disable plant without waterside economizer, due to schedule"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable disPlaReq(
    final haveWSE=false,
    final schTab=[0,0; 6*3600,1; 19*3600,0; 24*3600,0])
    "Disable plant without waterside economizer, due to lack of request"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable disPlaOutTem(
    final haveWSE=false,
    final schTab=[0,0; 6*3600,1; 19*3600,0; 24*3600,0])
    "Disable plant without waterside economizer, due to low outdoor temperature"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable chiPlaReq(
    final table=[0,0; 6.5*3600,1; 9*3600,2; 14*3600,3; 19*3600,3; 24*3600,0],
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Number of chiller plant request"
    annotation (Placement(transformation(extent={{-180,70},{-160,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine outTem(
    final amplitude=7.5,
    final freqHz=1/(24*3600),
    final offset=282.15) "Outdoor temperature"
    annotation (Placement(transformation(extent={{-180,30},{-160,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiSupTemSet(
    final amplitude=2,
    final freqHz=1/(24*3600),
    final offset=279.15) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-130},{-160,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-140,70},{-120,90}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1 "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable chiPlaReq1(
    final table=[0,1; 6.5*3600,1; 9*3600,2;14*3600,3; 19*3600,3; 24*3600,1],
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Number of chiller plant request"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOutTem(
    final k=282.15)
    "Constant outdoor temperature"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre2 "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable chiPlaReq2(
    final table=[0,1; 6.5*3600,1; 9*3600,2;14*3600,0; 19*3600,0; 24*3600,1],
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Number of chiller plant request"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOutTem1(
    final k=282.15)
    "Constant outdoor temperature"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre3 "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable chiPlaReq3(
    final table=[0,1; 6.5*3600,1; 9*3600,2;14*3600,3; 19*3600,3; 24*3600,1],
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Number of chiller plant request"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre4 "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine outTem1(
    final amplitude=7.5,
    final freqHz=1/(24*3600),
    final offset=280.15) "Outdoor temperature"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOutWetSig(
    final amplitude=2,
    final freqHz=1/28800,
    final offset=aveTWetBul)
    "Measured outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-180,-50},{-160,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp ram(
    final offset=-0.2,
    final height=0.7,
    final duration=86400) "Ramp output"
    annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));
  Buildings.Controls.OBC.CDL.Discrete.Sampler sam1(final samplePeriod=800)
    "Ideal sampler of a continuous signal"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine TOutWetSig1(
    final amplitude=2,
    final freqHz=1/28800,
    final offset=aveTWetBul - 10)
    "Measured outdoor air wet bulb temperature"
    annotation (Placement(transformation(extent={{-180,-10},{-160,10}})));

equation
  connect(chiPlaReq.y[1], reaToInt.u)
    annotation (Line(points={{-159,80},{-142,80}}, color={0,0,127}));
  connect(reaToInt.y, enaPlaWse0.chiWatSupResReq)
    annotation (Line(points={{-119,80},{-100,80},{-100,106},{-62,106}}, color={255,127,0}));
  connect(outTem.y, enaPlaWse0.TOut)
    annotation (Line(points={{-159,40},{-96,40},{-96,102},{-62,102}}, color={0,0,127}));
  connect(chiSupTemSet.y, enaPlaWse0.TChiWatSupSet)
    annotation (Line(points={{-159,-120},{-84,-120},{-84,90},{-62,90}},
      color={0,0,127}));
  connect(reaToInt.y, enaPlaWse1.chiWatSupResReq)
    annotation (Line(points={{-119,80},{-100,80},{-100,6},{-62,6}}, color={255,127,0}));
  connect(outTem.y, enaPlaWse1.TOut)
    annotation (Line(points={{-159,40},{-96,40},{-96,2},{-62,2}}, color={0,0,127}));
  connect(chiSupTemSet.y, enaPlaWse1.TChiWatSupSet)
    annotation (Line(points={{-159,-120},{-84,-120},{-84,-10},{-62,-10}},
      color={0,0,127}));
  connect(enaPlaWse0.yPla, pre.u)
    annotation (Line(points={{-39,100},{-20,100},{-20,134},{-150,134},{-150,120},
      {-142,120}}, color={255,0,255}));
  connect(pre.y, enaPlaWse0.uPla)
    annotation (Line(points={{-119,120},{-104,120},{-104,110},{-62,110}}, color={255,0,255}));
  connect(enaPlaWse1.yPla, pre1.u)
    annotation (Line(points={{-39,0},{-20,0},{-20,34},{-150,34},{-150,20},
      {-142,20}},   color={255,0,255}));
  connect(pre1.y, enaPlaWse1.uPla)
    annotation (Line(points={{-119,20},{-90,20},{-90,10},{-62,10}}, color={255,0,255}));
  connect(chiPlaReq1.y[1], reaToInt1.u)
    annotation (Line(points={{41,90},{58,90}}, color={0,0,127}));
  connect(reaToInt1.y, disPlaSch.chiWatSupResReq)
    annotation (Line(points={{81,90},{100,90},{100,96},{118,96}}, color={255,127,0}));
  connect(disPlaSch.yPla, pre2.u)
    annotation (Line(points={{141,90},{160,90},{160,134},{50,134},{50,120},
      {58,120}}, color={255,0,255}));
  connect(pre2.y, disPlaSch.uPla)
    annotation (Line(points={{81,120},{100,120},{100,100},{118,100}}, color={255,0,255}));
  connect(conOutTem.y, disPlaSch.TOut)
    annotation (Line(points={{81,60},{104,60},{104,92},{118,92}}, color={0,0,127}));
  connect(chiPlaReq2.y[1], reaToInt2.u)
    annotation (Line(points={{41,0},{58,0}}, color={0,0,127}));
  connect(reaToInt2.y, disPlaReq.chiWatSupResReq)
    annotation (Line(points={{81,0},{100,0},{100,6},{118,6}}, color={255,127,0}));
  connect(disPlaReq.yPla, pre3.u)
    annotation (Line(points={{141,0},{160,0},{160,44},{50,44},{50,30},{58,30}},
      color={255,0,255}));
  connect(pre3.y, disPlaReq.uPla)
    annotation (Line(points={{81,30},{100,30},{100,10},{118,10}}, color={255,0,255}));
  connect(conOutTem1.y, disPlaReq.TOut)
    annotation (Line(points={{81,-30},{104,-30},{104,2},{118,2}}, color={0,0,127}));
  connect(chiPlaReq3.y[1], reaToInt3.u)
    annotation (Line(points={{41,-90},{58,-90}}, color={0,0,127}));
  connect(reaToInt3.y, disPlaOutTem.chiWatSupResReq)
    annotation (Line(points={{81,-90},{100,-90},{100,-84},{118,-84}}, color={255,127,0}));
  connect(disPlaOutTem.yPla, pre4.u)
    annotation (Line(points={{141,-90},{160,-90},{160,-46},{50,-46},{50,-60},
      {58,-60}}, color={255,0,255}));
  connect(pre4.y, disPlaOutTem.uPla)
    annotation (Line(points={{81,-60},{100,-60},{100,-80},{118,-80}}, color={255,0,255}));
  connect(outTem1.y, disPlaOutTem.TOut)
    annotation (Line(points={{81,-120},{104,-120},{104,-88},{118,-88}}, color={0,0,127}));
  connect(ram.y, sam1.u)
    annotation (Line(points={{-159,-80},{-142,-80}}, color={0,0,127}));
  connect(TOutWetSig.y, enaPlaWse1.TOutWet)
    annotation (Line(points={{-159,-40},{-92,-40},{-92,-2},{-62,-2}}, color={0,0,127}));
  connect(sam1.y, enaPlaWse0.uTunPar)
    annotation (Line(points={{-119,-80},{-88,-80},{-88,94},{-62,94}}, color={0,0,127}));
  connect(sam1.y, enaPlaWse1.uTunPar)
    annotation (Line(points={{-119,-80},{-88,-80},{-88,-6},{-62,-6}}, color={0,0,127}));
  connect(TOutWetSig1.y, enaPlaWse0.TOutWet)
    annotation (Line(points={{-159,0},{-92,0},{-92,98},{-62,98}}, color={0,0,127}));

annotation (
  experiment(StopTime=86400.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Generic/Validation/PlantEnable.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 20, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
  graphics={Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-140},{200,140}}),
        graphics={
        Text(
          extent={{-60,90},{18,74}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Enabe plant with WSE, 
begin from 0 stage",
          horizontalAlignment=TextAlignment.Left),
        Text(
          extent={{-64,-10},{14,-26}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Enabe plant with WSE, 
begin from 1 stage,"),
        Text(
          extent={{-64,-26},{44,-38}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="due to high predicted heat
exchanger leaving temperature"),
        Text(
          extent={{120,82},{196,64}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Disable plant 
due to inactive schedule"),
        Text(
          extent={{120,-10},{184,-26}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Disable plant 
due to zero request"),
        Text(
          extent={{120,-102},{206,-116}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Disable plant 
due to low outdoor temperature")}));
end PlantEnable;
