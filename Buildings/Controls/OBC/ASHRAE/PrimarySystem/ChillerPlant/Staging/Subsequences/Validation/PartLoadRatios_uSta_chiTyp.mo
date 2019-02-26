within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model PartLoadRatios_uSta_chiTyp
  "Validates the operating and stage part load ratios calculation for chiller stage and stage type inputs"

  parameter Modelica.SIunits.Temperature TChiWatSupSet = 285.15
  "Chilled water supply set temperature";

  parameter Modelica.SIunits.Temperature aveTChiWatRet = 288.15
  "Average measured chilled water return temperature";

  parameter Real aveVChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") = 0.05
    "Average measured chilled water flow rate";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs0(
    final nPosDis=2)
    "Stage and operating part load ratios"
    annotation (Placement(transformation(extent={{-60,140},{-40,160}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs1(
    final nPosDis=2)
    "Stage and operating part load ratios"
    annotation (Placement(transformation(extent={{140,140},{160,160}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs2(
    final nPosDis=1,
    final nConCen=1)
    "Stage and operating part load ratios"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  CDL.Logical.Sources.Constant con[2](k={true, true})
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap(final
      staNomCap={10,20}, final minStaUnlCap={2,4})
    "Returns all capacities needed to decide on staging up or down from current stage"
    annotation (Placement(transformation(extent={{-120,70},{-100,90}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staSig1(final k=1) "Stage 1"
    annotation (Placement(transformation(extent={{-160,140},{-140,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capReq(k=5) "Capacity requirement"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap1(staNomCap=
       {10,20}, minStaUnlCap={2,4})
    "Returns all capacities needed to decide on staging up or down from current stage"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staSig2(final k=2) "Stage 2"
    annotation (Placement(transformation(extent={{40,140},{60,160}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capReq1(k=20) "Capacity requirement"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap2(final
      staNomCap={10,20}, final minStaUnlCap={2,4})
    "Returns all capacities needed to decide on staging up or down from current stage"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staSig3(
    final k=1) "Stage 1"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capReq2(
    final k=5) "Capacity requirement"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));

equation

  connect(staSig1.y, PLRs0.uSta) annotation (Line(points={{-139,150},{-110,150},
          {-110,159},{-61,159}}, color={255,127,0}));
  connect(capReq.y, PLRs0.uCapReq) annotation (Line(points={{-99,120},{-90,120},
          {-90,157},{-61,157}}, color={0,0,127}));
  connect(staCap.yStaNom, PLRs0.uStaCapNom) annotation (Line(points={{-99,87},{-88,
          87},{-88,155},{-61,155}},     color={0,0,127}));
  connect(staCap.yStaUpNom, PLRs0.uStaUpCapNom) annotation (Line(points={{-99,83},
          {-86,83},{-86,153},{-61,153}},     color={0,0,127}));
  connect(staCap.yStaDowNom, PLRs0.uStaDowCapNom) annotation (Line(points={{-99,79},
          {-84,79},{-84,151},{-61,151}},     color={0,0,127}));
  connect(staCap.yStaUpMin, PLRs0.uStaUpCapMin) annotation (Line(points={{-99,74},
          {-82,74},{-82,149},{-61,149}},     color={0,0,127}));
  connect(staCap.yStaMin, PLRs0.uStaCapMin) annotation (Line(points={{-99,72},{-80,
          72},{-80,147},{-61,147}},     color={0,0,127}));
  connect(staSig1.y, staCap.uSta) annotation (Line(points={{-139,150},{-130,150},
          {-130,80},{-122,80}},
                          color={255,127,0}));
  connect(staSig2.y, PLRs1.uSta) annotation (Line(points={{61,150},{90,150},{90,159},
          {139,159}}, color={255,127,0}));
  connect(capReq1.y, PLRs1.uCapReq) annotation (Line(points={{101,120},{110,120},{110,
          157},{139,157}}, color={0,0,127}));
  connect(staCap1.yStaNom, PLRs1.uStaCapNom) annotation (Line(points={{101,87},{
          112,87},{112,155},{139,155}},
                                    color={0,0,127}));
  connect(staCap1.yStaUpNom, PLRs1.uStaUpCapNom) annotation (Line(points={{101,83},
          {114,83},{114,153},{139,153}}, color={0,0,127}));
  connect(staCap1.yStaDowNom, PLRs1.uStaDowCapNom) annotation (Line(points={{101,79},
          {116,79},{116,151},{139,151}}, color={0,0,127}));
  connect(staCap1.yStaUpMin, PLRs1.uStaUpCapMin) annotation (Line(points={{101,74},
          {118,74},{118,149},{139,149}}, color={0,0,127}));
  connect(staCap1.yStaMin, PLRs1.uStaCapMin) annotation (Line(points={{101,72},{
          120,72},{120,147},{139,147}},
                                    color={0,0,127}));
  connect(staSig2.y, staCap1.uSta) annotation (Line(points={{61,150},{70,150},{70,
          80},{78,80}},
                    color={255,127,0}));
  connect(staSig3.y, PLRs2.uSta) annotation (Line(points={{-139,-50},{-110,-50},{-110,
          -41},{-61,-41}}, color={255,127,0}));
  connect(capReq2.y, PLRs2.uCapReq) annotation (Line(points={{-99,-80},{-90,-80},{-90,
          -43},{-61,-43}}, color={0,0,127}));
  connect(staCap2.yStaNom, PLRs2.uStaCapNom) annotation (Line(points={{-99,-113},
          {-88,-113},{-88,-45},{-61,-45}},
                                      color={0,0,127}));
  connect(staCap2.yStaUpNom, PLRs2.uStaUpCapNom) annotation (Line(points={{-99,-117},
          {-86,-117},{-86,-47},{-61,-47}}, color={0,0,127}));
  connect(staCap2.yStaDowNom, PLRs2.uStaDowCapNom) annotation (Line(points={{-99,
          -121},{-84,-121},{-84,-49},{-61,-49}},
                                           color={0,0,127}));
  connect(staCap2.yStaUpMin, PLRs2.uStaUpCapMin) annotation (Line(points={{-99,-126},
          {-82,-126},{-82,-51},{-61,-51}}, color={0,0,127}));
  connect(staCap2.yStaMin, PLRs2.uStaCapMin) annotation (Line(points={{-99,-128},
          {-80,-128},{-80,-53},{-61,-53}},
                                      color={0,0,127}));
  connect(staSig3.y, staCap2.uSta) annotation (Line(points={{-139,-50},{-130,-50},
          {-130,-120},{-122,-120}},color={255,127,0}));
  connect(con.y, staCap.u) annotation (Line(points={{-139,50},{-132,50},{-132,74},
          {-122,74}}, color={255,0,255}));
  connect(con.y, staCap1.u) annotation (Line(points={{-139,50},{-30,50},{-30,74},
          {78,74}}, color={255,0,255}));
  connect(con.y, staCap2.u) annotation (Line(points={{-139,50},{-132,50},{-132,-126},
          {-122,-126}}, color={255,0,255}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/PartLoadRatios_uSta_ChiTyp.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.CapacityRequirement\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Generic.CapacityRequirement</a>.
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
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-180},{200,200}}),
        graphics={
        Text(
          extent={{62,-76},{178,-96}},
          lineColor={0,0,127},
          textString="fixme: Add tests that include VSD contrifugal
 upon receiving confirmation that equations are 
ok")}));
end PartLoadRatios_uSta_chiTyp;
