within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.Validation;
model PlantEnable "Validation sequence for enabling and disabling chiller plant"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable enaPlaWse0(
    schTab=[0,0; 6*3600,1; 19*3600,0; 24*3600,0])
    "Enabling control of plant with waterside economizer, stage up from zero"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable enaPlaWse1(
    schTab=[0,0; 6*3600,1; 19*3600,1; 24*3600,0])
    "Enabling control of plant with waterside economizer, stage up from one"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable disPlaSch(
    haveWSE=false,
    schTab=[0,0; 6*3600,1; 19*3600,0; 24*3600,0])
    "Disable plant without waterside economizer, due to schedule"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable disPlaReq(
    haveWSE=false,
    schTab=[0,0; 6*3600,1; 19*3600,0; 24*3600,0])
    "Disable plant without waterside economizer, due to lack of request"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable disPlaOutTem(
    haveWSE=false,
    schTab=[0,0; 6*3600,1; 19*3600,0; 24*3600,0])
    "Disable plant without waterside economizer, due to low outdoor temperature"
    annotation (Placement(transformation(extent={{120,-100},{140,-80}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable chiPlaReq(
    table=[0,0; 6.5*3600,1; 9*3600,2; 14*3600,3; 19*3600,3; 24*3600,0],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Number of chiller plant request"
    annotation (Placement(transformation(extent={{-180,80},{-160,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine outTem(
    amplitude=7.5,
    freqHz=1/(24*3600),
    offset=282.15) "Outdoor temperature"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine chiSupTemSet(
    amplitude=2,
    freqHz=1/(24*3600),
    offset=279.15) "Chilled water supply temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(k=1) "Constant one"
    annotation (Placement(transformation(extent={{-180,-120},{-160,-100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine preHeaExcLeaTem(
    amplitude=2,
    freqHz=1/(24*3600),
    offset=277.15) "Predicted heat exchanger leaving water temperature"
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine preHeaExcLeaTem1(
    amplitude=2,
    freqHz=1/(24*3600),
    offset=280.15) "Predicted heat exchanger leaving water temperature"
    annotation (Placement(transformation(extent={{-180,-40},{-160,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{-140,110},{-120,130}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1 "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable chiPlaReq1(
    table=[0,1; 6.5*3600,1; 9*3600,2;14*3600,3; 19*3600,3; 24*3600,1],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Number of chiller plant request"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt1
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOutTem(k=282.15)
    "Constant outdoor temperature"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre2 "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{60,110},{80,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable chiPlaReq2(
    table=[0,1; 6.5*3600,1; 9*3600,2;14*3600,0; 19*3600,0; 24*3600,1],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Number of chiller plant request"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt2
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant conOutTem1(k=282.15)
    "Constant outdoor temperature"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre3 "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable chiPlaReq3(
    table=[0,1; 6.5*3600,1; 9*3600,2;14*3600,3; 19*3600,3; 24*3600,1],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments)
    "Number of chiller plant request"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt3
    "Convert real input to integer output"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre4 "Breaks algebraic loops"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine outTem1(
    amplitude=7.5,
    freqHz=1/(24*3600),
    offset=280.15) "Outdoor temperature"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));

equation
  connect(chiPlaReq.y[1], reaToInt.u)
    annotation (Line(points={{-159,90},{-142,90}}, color={0,0,127}));
  connect(reaToInt.y, enaPlaWse0.chiWatSupResReq)
    annotation (Line(points={{-119,90},{-100,90},{-100,106},{-62,106}}, color={255,127,0}));
  connect(outTem.y, enaPlaWse0.TOut)
    annotation (Line(points={{-159,50},{-96,50},{-96,102},{-62,102}}, color={0,0,127}));
  connect(preHeaExcLeaTem.y, enaPlaWse0.TPreHeaChaLea)
    annotation (Line(points={{-159,10},{-92,10},{-92,98},{-62,98}}, color={0,0,127}));
  connect(chiSupTemSet.y, enaPlaWse0.TChiWatSupSet)
    annotation (Line(points={{-159,-70},{-88,-70},{-88,94},{-62,94}}, color={0,0,127}));
  connect(con.y, enaPlaWse0.PLRHeaExc)
    annotation (Line(points={{-159,-110},{-84,-110},{-84,90},{-62,90}}, color={0,0,127}));
  connect(reaToInt.y, enaPlaWse1.chiWatSupResReq)
    annotation (Line(points={{-119,90},{-100,90},{-100,16},{-62,16}}, color={255,127,0}));
  connect(outTem.y, enaPlaWse1.TOut)
    annotation (Line(points={{-159,50},{-96,50},{-96,12},{-62,12}}, color={0,0,127}));
  connect(preHeaExcLeaTem1.y, enaPlaWse1.TPreHeaChaLea)
    annotation (Line(points={{-159,-30},{-92,-30},{-92,8},{-62,8}}, color={0,0,127}));
  connect(chiSupTemSet.y, enaPlaWse1.TChiWatSupSet)
    annotation (Line(points={{-159,-70},{-88,-70},{-88,4},{-62,4}}, color={0,0,127}));
  connect(con.y, enaPlaWse1.PLRHeaExc)
    annotation (Line(points={{-159,-110},{-84,-110},{-84,0},{-62,0}}, color={0,0,127}));
  connect(enaPlaWse0.yPla, pre.u)
    annotation (Line(points={{-39,100},{-20,100},{-20,134},{-150,134},{-150,120},
      {-142,120}}, color={255,0,255}));
  connect(pre.y, enaPlaWse0.uPla)
    annotation (Line(points={{-119,120},{-104,120},{-104,110},{-62,110}}, color={255,0,255}));
  connect(enaPlaWse1.yPla, pre1.u)
    annotation (Line(points={{-39,10},{-20,10},{-20,44},{-150,44},{-150,30},
      {-142,30}}, color={255,0,255}));
  connect(pre1.y, enaPlaWse1.uPla)
    annotation (Line(points={{-119,30},{-104,30},{-104,20},{-62,20}}, color={255,0,255}));
  connect(chiPlaReq1.y[1], reaToInt1.u)
    annotation (Line(points={{41,90},{58,90}}, color={0,0,127}));
  connect(reaToInt1.y, disPlaSch.chiWatSupResReq)
    annotation (Line(points={{81,90},{100,90},{100,96},{118,96}}, color={255,127,0}));
  connect(disPlaSch.yPla, pre2.u)
    annotation (Line(points={{141,90},{160,90},{160,134},{50,134},{50,120},
      {58,120}}, color={255,0,255}));
  connect(pre2.y, disPlaSch.uPla)
    annotation (Line(points={{81,120},{100,120},{100,100},{118,100}},  color={255,0,255}));
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
          extent={{-64,-2},{14,-18}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Enabe plant with WSE, 
begin from 1 stage,"),
        Text(
          extent={{-64,-16},{44,-28}},
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
