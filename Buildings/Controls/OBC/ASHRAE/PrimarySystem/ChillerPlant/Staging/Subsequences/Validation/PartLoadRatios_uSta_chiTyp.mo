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

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs1(
    final nPosDis=2)
    "Stage and operating part load ratios"
    annotation (Placement(transformation(extent={{-40,300},{-20,320}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios PLRs2(
    final nPosDis=2)
    "Stage and operating part load ratios"
    annotation (Placement(transformation(extent={{-240,120},{-220,140}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.PartLoadRatios
    PLRsNoWSE(
    final nPosDis=1,
    final nConCen=1)
    "Stage and operating part load ratios"
    annotation (Placement(transformation(extent={{-40,120},{-20,140}})));

  CDL.Logical.Sources.Constant con[2](k={true, true})
    annotation (Placement(transformation(extent={{-340,20},{-320,40}})));

  PartLoadRatios PLRs0(final nPosDis=2)
    "Stage and operating part load ratios"
    annotation (Placement(transformation(extent={{-240,300},{-220,320}})));

protected
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap(
    final staNomCap={10,20},
    final minStaUnlCap={2,4},
    final nSta=2)
    "Returns all capacities needed to decide on staging up or down from current stage"
    annotation (Placement(transformation(extent={{-100,230},{-80,250}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staSig1(final k=1)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-140,300},{-120,320}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capReq(final k=5) "Capacity requirement"
    annotation (Placement(transformation(extent={{-100,270},{-80,290}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap1(
    final staNomCap={10,20},
    final minStaUnlCap={2,4},
    nSta=2)
    "Returns all capacities needed to decide on staging up or down from current stage"
    annotation (Placement(transformation(extent={{-300,50},{-280,70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staSig2(final k=2)
    "Chiller stage"
    annotation (Placement(transformation(extent={{-340,120},{-320,140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capReq1(final k=20) "Capacity requirement"
    annotation (Placement(transformation(extent={{-300,90},{-280,110}})));

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences.Capacities staCap2(
    final staNomCap={10,20},
    final minStaUnlCap={2,4},
    final nSta=2)
    "Returns all capacities needed to decide on staging up or down from current stage"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant staSig3(
    final k=1) "Chiller stage"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant capReq2(
    final k=5) "Capacity requirement"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));

  Capacities staCap3(
    final staNomCap={10,20},
    final minStaUnlCap={2,4},
    final nSta=2)
    "Returns all capacities needed to decide on staging up or down from current stage"
    annotation (Placement(transformation(extent={{-300,230},{-280,250}})));

  CDL.Integers.Sources.Constant staSig0(final k=0) "Chiller stage"
    annotation (Placement(transformation(extent={{-340,300},{-320,320}})));

  CDL.Continuous.Sources.Constant capReq3(final k=5)
    "Capacity requirement"
    annotation (Placement(transformation(extent={{-300,270},{-280,290}})));

equation

  connect(staSig1.y, PLRs1.u) annotation (Line(points={{-119,310},{-90,310},{-90,
          319},{-41,319}}, color={255,127,0}));
  connect(capReq.y,PLRs1. uCapReq) annotation (Line(points={{-79,280},{-70,280},
          {-70,317},{-41,317}}, color={0,0,127}));
  connect(staCap.yStaNom,PLRs1. uStaCapNom) annotation (Line(points={{-79,247},{
          -68,247},{-68,315},{-41,315}},color={0,0,127}));
  connect(staCap.yStaUpNom,PLRs1. uStaUpCapNom) annotation (Line(points={{-79,243},
          {-66,243},{-66,313},{-41,313}},    color={0,0,127}));
  connect(staCap.yStaDowNom,PLRs1. uStaDowCapNom) annotation (Line(points={{-79,239},
          {-64,239},{-64,311},{-41,311}},    color={0,0,127}));
  connect(staCap.yStaUpMin,PLRs1. uStaUpCapMin) annotation (Line(points={{-79,234},
          {-62,234},{-62,309},{-41,309}},    color={0,0,127}));
  connect(staCap.yStaMin,PLRs1. uStaCapMin) annotation (Line(points={{-79,232},{
          -60,232},{-60,307},{-41,307}},color={0,0,127}));
  connect(staSig1.y, staCap.u) annotation (Line(points={{-119,310},{-110,310},{
          -110,240},{-102,240}}, color={255,127,0}));
  connect(staSig2.y, PLRs2.u) annotation (Line(points={{-319,130},{-290,130},{-290,
          139},{-241,139}}, color={255,127,0}));
  connect(capReq1.y,PLRs2. uCapReq) annotation (Line(points={{-279,100},{-270,100},
          {-270,137},{-241,137}},
                           color={0,0,127}));
  connect(staCap1.yStaNom,PLRs2. uStaCapNom) annotation (Line(points={{-279,67},
          {-268,67},{-268,135},{-241,135}},
                                    color={0,0,127}));
  connect(staCap1.yStaUpNom,PLRs2. uStaUpCapNom) annotation (Line(points={{-279,63},
          {-266,63},{-266,133},{-241,133}},
                                         color={0,0,127}));
  connect(staCap1.yStaDowNom,PLRs2. uStaDowCapNom) annotation (Line(points={{-279,59},
          {-264,59},{-264,131},{-241,131}},
                                         color={0,0,127}));
  connect(staCap1.yStaUpMin,PLRs2. uStaUpCapMin) annotation (Line(points={{-279,54},
          {-262,54},{-262,129},{-241,129}},
                                         color={0,0,127}));
  connect(staCap1.yStaMin,PLRs2. uStaCapMin) annotation (Line(points={{-279,52},
          {-260,52},{-260,127},{-241,127}},
                                    color={0,0,127}));
  connect(staSig2.y, staCap1.u) annotation (Line(points={{-319,130},{-310,130},
          {-310,60},{-302,60}}, color={255,127,0}));
  connect(staSig3.y, PLRsNoWSE.u) annotation (Line(points={{-119,130},{-90,130},
          {-90,139},{-41,139}}, color={255,127,0}));
  connect(capReq2.y, PLRsNoWSE.uCapReq) annotation (Line(points={{-79,100},{-70,
          100},{-70,137},{-41,137}}, color={0,0,127}));
  connect(staCap2.yStaNom, PLRsNoWSE.uStaCapNom) annotation (Line(points={{-79,67},
          {-68,67},{-68,135},{-41,135}}, color={0,0,127}));
  connect(staCap2.yStaUpNom, PLRsNoWSE.uStaUpCapNom) annotation (Line(points={{-79,
          63},{-66,63},{-66,133},{-41,133}}, color={0,0,127}));
  connect(staCap2.yStaDowNom, PLRsNoWSE.uStaDowCapNom) annotation (Line(points={
          {-79,59},{-64,59},{-64,131},{-41,131}}, color={0,0,127}));
  connect(staCap2.yStaUpMin, PLRsNoWSE.uStaUpCapMin) annotation (Line(points={{-79,
          54},{-62,54},{-62,129},{-41,129}}, color={0,0,127}));
  connect(staCap2.yStaMin, PLRsNoWSE.uStaCapMin) annotation (Line(points={{-79,52},
          {-60,52},{-60,127},{-41,127}}, color={0,0,127}));
  connect(staSig3.y, staCap2.u) annotation (Line(points={{-119,130},{-110,130},
          {-110,60},{-102,60}}, color={255,127,0}));
  connect(con.y, staCap.uStaAva) annotation (Line(points={{-319,30},{-180,30},{-180,
          234},{-102,234}},    color={255,0,255}));
  connect(con.y, staCap1.uStaAva) annotation (Line(points={{-319,30},{-310,30},{
          -310,54},{-302,54}},color={255,0,255}));
  connect(con.y, staCap2.uStaAva) annotation (Line(points={{-319,30},{-110,30},{
          -110,54},{-102,54}},      color={255,0,255}));
  connect(staSig0.y, PLRs0.u) annotation (Line(points={{-319,310},{-290,310},{-290,
          319},{-241,319}}, color={255,127,0}));
  connect(capReq3.y, PLRs0.uCapReq) annotation (Line(points={{-279,280},{-270,280},
          {-270,317},{-241,317}}, color={0,0,127}));
  connect(staCap3.yStaNom, PLRs0.uStaCapNom) annotation (Line(points={{-279,247},
          {-268,247},{-268,315},{-241,315}}, color={0,0,127}));
  connect(staCap3.yStaUpNom, PLRs0.uStaUpCapNom) annotation (Line(points={{-279,
          243},{-266,243},{-266,313},{-241,313}}, color={0,0,127}));
  connect(staCap3.yStaDowNom, PLRs0.uStaDowCapNom) annotation (Line(points={{-279,
          239},{-264,239},{-264,311},{-241,311}}, color={0,0,127}));
  connect(staCap3.yStaUpMin, PLRs0.uStaUpCapMin) annotation (Line(points={{-279,
          234},{-262,234},{-262,309},{-241,309}}, color={0,0,127}));
  connect(staCap3.yStaMin, PLRs0.uStaCapMin) annotation (Line(points={{-279,232},
          {-260,232},{-260,307},{-241,307}}, color={0,0,127}));
  connect(staSig0.y, staCap3.u) annotation (Line(points={{-319,310},{-310,310},
          {-310,240},{-302,240}}, color={255,127,0}));
  connect(con.y, staCap3.uStaAva) annotation (Line(points={{-319,30},{-312,30},{
          -312,234},{-302,234}}, color={255,0,255}));
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
        coordinateSystem(preserveAspectRatio=false, extent={{-360,-340},{360,340}})));
end PartLoadRatios_uSta_chiTyp;
