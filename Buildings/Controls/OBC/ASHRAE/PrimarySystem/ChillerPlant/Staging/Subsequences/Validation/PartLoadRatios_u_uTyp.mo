within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Validation;
model PartLoadRatios_u_uTyp
  "Validates the operating and stage part load ratios calculation for chiller stage and stage type inputs"

  parameter Modelica.SIunits.Temperature TChiWatSupSet = 285.15
  "Chilled water supply set temperature";

  parameter Modelica.SIunits.Temperature aveTChiWatRet = 288.15
  "Average measured chilled water return temperature";

  parameter Real aveVChiWat_flow(
    final quantity="VolumeFlowRate",
    final unit="m3/s") = 0.05
    "Average measured chilled water flow rate";

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs1(
    final nPosDis=2)
    "Stage and operating part load ratios"
    annotation (Placement(transformation(extent={{140,120},{160,140}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs2(
    final nPosDis=2)
    "Stage and operating part load ratios"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios
    PLRsNoWSE(
    final nPosDis=1,
    final nConCen=1)
    "Stage and operating part load ratios"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}})));

  CDL.Logical.Sources.Constant con[2](k={true, true})
    annotation (Placement(transformation(extent={{-160,-160},{-140,-140}})));

  PartLoadRatios PLRs0(final nPosDis=2)
    "Stage and operating part load ratios"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap(
    final staNomCap={10,20},
    final minStaUnlCap={2,4},
    final nSta=2)
    "Returns all capacities needed to decide on staging up or down from current stage"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staSig1(final k=1)
    "Chiller stage"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capReq(final k=5) "Capacity requirement"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap1(
    final staNomCap={10,20},
    final minStaUnlCap={2,4},
    nSta=2)
    "Returns all capacities needed to decide on staging up or down from current stage"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staSig2(final k=2)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-160,-60},{-140,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capReq1(final k=20) "Capacity requirement"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap2(
    final staNomCap={10,20},
    final minStaUnlCap={2,4},
    final nSta=2)
    "Returns all capacities needed to decide on staging up or down from current stage"
    annotation (Placement(transformation(extent={{80,-130},{100,-110}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staSig3(
    final k=1) "Chiller stage"
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capReq2(
    final k=5) "Capacity requirement"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));

  Capacities staCap3(
    final staNomCap={10,20},
    final minStaUnlCap={2,4},
    final nSta=2)
    "Returns all capacities needed to decide on staging up or down from current stage"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));

  CDL.Integers.Sources.Constant staSig0(final k=0) "Chiller stage"
    annotation (Placement(transformation(extent={{-160,120},{-140,140}})));

  CDL.Continuous.Sources.Constant capReq3(final k=5)
    "Capacity requirement"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));

equation

  connect(staSig1.y, PLRs1.u) annotation (Line(points={{61,130},{90,130},{90,
          120},{139,120}}, color={255,127,0}));
  connect(capReq.y,PLRs1. uCapReq) annotation (Line(points={{101,100},{110,100},
          {110,143},{139,143}}, color={0,0,127}));
  connect(staCap.yStaNom,PLRs1. uStaCapNom) annotation (Line(points={{101,67},{
          112,67},{112,135},{139,135}}, color={0,0,127}));
  connect(staCap.yStaUpNom,PLRs1. uStaUpCapNom) annotation (Line(points={{101,63},
          {114,63},{114,133},{139,133}},     color={0,0,127}));
  connect(staCap.yStaDowNom,PLRs1. uStaDowCapNom) annotation (Line(points={{101,59},
          {116,59},{116,131},{139,131}},     color={0,0,127}));
  connect(staCap.yStaUpMin,PLRs1. uStaUpCapMin) annotation (Line(points={{101,54},
          {118,54},{118,129},{139,129}},     color={0,0,127}));
  connect(staCap.yStaMin,PLRs1. uStaCapMin) annotation (Line(points={{101,52},{
          120,52},{120,127},{139,127}}, color={0,0,127}));
  connect(staSig1.y, staCap.u) annotation (Line(points={{61,130},{70,130},{70,
          63},{79,63}},          color={255,127,0}));
  connect(staSig2.y, PLRs2.u) annotation (Line(points={{-139,-50},{-110,-50},{
          -110,-60},{-61,-60}},
                            color={255,127,0}));
  connect(capReq1.y,PLRs2. uCapReq) annotation (Line(points={{-99,-80},{-90,-80},
          {-90,-37},{-61,-37}},
                           color={0,0,127}));
  connect(staCap1.yStaNom,PLRs2. uStaCapNom) annotation (Line(points={{-99,-113},
          {-88,-113},{-88,-45},{-61,-45}},
                                    color={0,0,127}));
  connect(staCap1.yStaUpNom,PLRs2. uStaUpCapNom) annotation (Line(points={{-99,
          -117},{-86,-117},{-86,-47},{-61,-47}},
                                         color={0,0,127}));
  connect(staCap1.yStaDowNom,PLRs2. uStaDowCapNom) annotation (Line(points={{-99,
          -121},{-84,-121},{-84,-49},{-61,-49}},
                                         color={0,0,127}));
  connect(staCap1.yStaUpMin,PLRs2. uStaUpCapMin) annotation (Line(points={{-99,
          -126},{-82,-126},{-82,-51},{-61,-51}},
                                         color={0,0,127}));
  connect(staCap1.yStaMin,PLRs2. uStaCapMin) annotation (Line(points={{-99,-128},
          {-80,-128},{-80,-53},{-61,-53}},
                                    color={0,0,127}));
  connect(staSig2.y, staCap1.u) annotation (Line(points={{-139,-50},{-130,-50},
          {-130,-117},{-121,-117}},
                                color={255,127,0}));
  connect(staSig3.y, PLRsNoWSE.u) annotation (Line(points={{61,-50},{90,-50},{
          90,-60},{139,-60}},   color={255,127,0}));
  connect(capReq2.y, PLRsNoWSE.uCapReq) annotation (Line(points={{101,-80},{110,
          -80},{110,-37},{139,-37}}, color={0,0,127}));
  connect(staCap2.yStaNom, PLRsNoWSE.uStaCapNom) annotation (Line(points={{101,
          -113},{112,-113},{112,-45},{139,-45}},
                                         color={0,0,127}));
  connect(staCap2.yStaUpNom, PLRsNoWSE.uStaUpCapNom) annotation (Line(points={{101,
          -117},{114,-117},{114,-47},{139,-47}},
                                             color={0,0,127}));
  connect(staCap2.yStaDowNom, PLRsNoWSE.uStaDowCapNom) annotation (Line(points={{101,
          -121},{116,-121},{116,-49},{139,-49}},  color={0,0,127}));
  connect(staCap2.yStaUpMin, PLRsNoWSE.uStaUpCapMin) annotation (Line(points={{101,
          -126},{118,-126},{118,-51},{139,-51}},
                                             color={0,0,127}));
  connect(staCap2.yStaMin, PLRsNoWSE.uStaCapMin) annotation (Line(points={{101,
          -128},{120,-128},{120,-53},{139,-53}},
                                         color={0,0,127}));
  connect(staSig3.y, staCap2.u) annotation (Line(points={{61,-50},{70,-50},{70,
          -117},{79,-117}},     color={255,127,0}));
  connect(con.y, staCap.uStaAva) annotation (Line(points={{-139,-150},{0,-150},
          {0,54},{78,54}},     color={255,0,255}));
  connect(con.y, staCap1.uStaAva) annotation (Line(points={{-139,-150},{-130,
          -150},{-130,-126},{-122,-126}},
                              color={255,0,255}));
  connect(con.y, staCap2.uStaAva) annotation (Line(points={{-139,-150},{70,-150},
          {70,-126},{78,-126}},     color={255,0,255}));
  connect(staSig0.y, PLRs0.u) annotation (Line(points={{-139,130},{-110,130},{
          -110,120},{-61,120}},
                            color={255,127,0}));
  connect(capReq3.y, PLRs0.uCapReq) annotation (Line(points={{-99,100},{-90,100},
          {-90,143},{-61,143}},   color={0,0,127}));
  connect(staCap3.yStaNom, PLRs0.uStaCapNom) annotation (Line(points={{-99,67},
          {-88,67},{-88,135},{-61,135}},     color={0,0,127}));
  connect(staCap3.yStaUpNom, PLRs0.uStaUpCapNom) annotation (Line(points={{-99,63},
          {-86,63},{-86,133},{-61,133}},          color={0,0,127}));
  connect(staCap3.yStaDowNom, PLRs0.uStaDowCapNom) annotation (Line(points={{-99,59},
          {-84,59},{-84,131},{-61,131}},          color={0,0,127}));
  connect(staCap3.yStaUpMin, PLRs0.uStaUpCapMin) annotation (Line(points={{-99,54},
          {-82,54},{-82,129},{-61,129}},          color={0,0,127}));
  connect(staCap3.yStaMin, PLRs0.uStaCapMin) annotation (Line(points={{-99,52},
          {-80,52},{-80,127},{-61,127}},     color={0,0,127}));
  connect(staSig0.y, staCap3.u) annotation (Line(points={{-139,130},{-130,130},
          {-130,63},{-121,63}},   color={255,127,0}));
  connect(con.y, staCap3.uStaAva) annotation (Line(points={{-139,-150},{-132,
          -150},{-132,54},{-122,54}},
                                 color={255,0,255}));
annotation (
 experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Staging/Subsequences/Validation/PartLoadRatios_u_uTyp.mos"
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
        coordinateSystem(preserveAspectRatio=false, extent={{-360,-340},{360,340}})));
end PartLoadRatios_u_uTyp;
