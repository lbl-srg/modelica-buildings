within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.Validation;
model EnableCells
  "Validation sequence of enabling and disabling tower cells"

  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableCells
    enaTowCel "Enable tower cells"
    annotation (Placement(transformation(extent={{20,140},{40,160}})));
  Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableCells
    disTowCel "Disable tower cells"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    final width=0.15, final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-140,80},{-120,100}})));
  Buildings.Controls.OBC.CDL.Logical.Not staUp "Chiller stage up status"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul1(
    final width=0.18, final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-140,40},{-120,60}})));
  Buildings.Controls.OBC.CDL.Logical.Not towStaUp "Tower stage up status"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta(
    final width=0.15,
    final period=3600,
    final startTime=300) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,150},{-80,170}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger chiSta "Chiller stage"
    annotation (Placement(transformation(extent={{-40,170},{-20,190}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaPri[4](
    final k={4,1,2,3})
    "Tower cells enabling priority"
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(
    final k=false) "Stage down"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger chiSta1
    "Chiller stage "
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse wseSta1(
    final width=0.15, final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant enaPri1[4](
    final k={4,1,2,3}) "Tower cells enabling priority"
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con2(
    final k=false) "Stage down"
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse booPul2(
    final width=0.15, final period=3600)  "Boolean pulse"
    annotation (Placement(transformation(extent={{-140,-160},{-120,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Not staDow "Chiller stage down status"
    annotation (Placement(transformation(extent={{-100,-160},{-80,-140}})));
  Buildings.Controls.OBC.CDL.Logical.Not towStaDow "Tower stage down status"
    annotation (Placement(transformation(extent={{-100,-200},{-80,-180}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse  booPul3(
    final width=0.18, final period=3600) "Boolean pulse"
    annotation (Placement(transformation(extent={{-140,-200},{-120,-180}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel1[4](
    delayTime=fill(50, 4)) "Delay true input"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre1[4](
    final pre_u_start=fill(true,4)) "Break algebraic loop"
    annotation (Placement(transformation(extent={{180,-30},{200,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[4] "Logical not"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not not2[4] "Logical not"
    annotation (Placement(transformation(extent={{140,-30},{160,-10}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel[4](
    final samplePeriod=fill(5, 4)) "Delay input"
    annotation (Placement(transformation(extent={{100,170},{120,190}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[4]
    "Convert boolean input to real"
    annotation (Placement(transformation(extent={{60,170},{80,190}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr[4](
    final threshold=fill(0.5, 4)) "Convert real to boolean"
    annotation (Placement(transformation(extent={{140,170},{160,190}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre2[4] "Break algebraic loop"
    annotation (Placement(transformation(extent={{180,170},{200,190}})));

equation
  connect(booPul.y, staUp.u)
    annotation (Line(points={{-118,90},{-102,90}}, color={255,0,255}));
  connect(staUp.y, chiSta.u)
    annotation (Line(points={{-78,90},{-60,90},{-60,180},{-42,180}},
      color={255,0,255}));
  connect(chiSta.y, enaTowCel.uChiSta)
    annotation (Line(points={{-18,180},{0,180},{0,159},{18,159}},
      color={255,127,0}));
  connect(wseSta.y, enaTowCel.uWseSta)
    annotation (Line(points={{-78,160},{-4,160},{-4,157},{18,157}}, color={255,0,255}));
  connect(enaPri.y, enaTowCel.uTowCelPri)
    annotation (Line(points={{-78,130},{0,130},{0,153},{18,153}},
      color={255,127,0}));
  connect(staUp.y, enaTowCel.uStaUp)
    annotation (Line(points={{-78,90},{4,90},{4,147},{18,147}},
      color={255,0,255}));
  connect(booPul1.y, towStaUp.u)
    annotation (Line(points={{-118,50},{-102,50}}, color={255,0,255}));
  connect(towStaUp.y, enaTowCel.uTowStaUp)
    annotation (Line(points={{-78,50},{8,50},{8,145},{18,145}}, color={255,0,255}));
  connect(con1.y, enaTowCel.uStaDow)
    annotation (Line(points={{-78,20},{12,20},{12,143},{18,143}}, color={255,0,255}));
  connect(con1.y, enaTowCel.uTowStaDow)
    annotation (Line(points={{-78,20},{12,20},{12,141},{18,141}}, color={255,0,255}));
  connect(booPul2.y, staDow.u)
    annotation (Line(points={{-118,-150},{-102,-150}}, color={255,0,255}));
  connect(booPul3.y, towStaDow.u)
    annotation (Line(points={{-118,-190},{-102,-190}}, color={255,0,255}));
  connect(chiSta1.y, disTowCel.uChiSta)
    annotation (Line(points={{-18,-20},{4,-20},{4,-41},{18,-41}}, color={255,127,0}));
  connect(wseSta1.y, disTowCel.uWseSta)
    annotation (Line(points={{-78,-40},{0,-40},{0,-43},{18,-43}}, color={255,0,255}));
  connect(enaPri1.y, disTowCel.uTowCelPri)
    annotation (Line(points={{-78,-70},{0,-70},{0,-47},{18,-47}}, color={255,127,0}));
  connect(con2.y, disTowCel.uStaUp)
    annotation (Line(points={{-78,-110},{4,-110},{4,-53},{18,-53}}, color={255,0,255}));
  connect(con2.y, disTowCel.uTowStaUp)
    annotation (Line(points={{-78,-110},{4,-110},{4,-55},{18,-55}}, color={255,0,255}));
  connect(staDow.y, disTowCel.uStaDow)
    annotation (Line(points={{-78,-150},{8,-150},{8,-57},{18,-57}}, color={255,0,255}));
  connect(towStaDow.y, disTowCel.uTowStaDow)
    annotation (Line(points={{-78,-190},{12,-190},{12,-59},{18,-59}}, color={255,0,255}));
  connect(disTowCel.yTarTowSta, not1.u)
    annotation (Line(points={{42,-41},{50,-41},{50,-20},{58,-20}}, color={255,0,255}));
  connect(not1.y, truDel1.u)
    annotation (Line(points={{82,-20},{98,-20}}, color={255,0,255}));
  connect(truDel1.y, not2.u)
    annotation (Line(points={{122,-20},{138,-20}}, color={255,0,255}));
  connect(not2.y, pre1.u)
    annotation (Line(points={{162,-20},{178,-20}}, color={255,0,255}));
  connect(pre1.y, disTowCel.uTowSta)
    annotation (Line(points={{202,-20},{210,-20},{210,-80},{-10,-80},{-10,-45},
      {18,-45}}, color={255,0,255}));
  connect(booPul3.y, chiSta1.u)
    annotation (Line(points={{-118,-190},{-110,-190},{-110,-170},{-60,-170},
      {-60,-20},{-42,-20}}, color={255,0,255}));
  connect(booToRea.y, uniDel.u)
    annotation (Line(points={{82,180},{98,180}}, color={0,0,127}));
  connect(uniDel.y, greEquThr.u)
    annotation (Line(points={{122,180},{138,180}}, color={0,0,127}));
  connect(greEquThr.y, pre2.u)
    annotation (Line(points={{162,180},{178,180}}, color={255,0,255}));
  connect(enaTowCel.yTarTowSta, booToRea.u)
    annotation (Line(points={{42,159},{50,159},{50,180},{58,180}},
      color={255,0,255}));
  connect(pre2.y, enaTowCel.uTowSta)
    annotation (Line(points={{202,180},{210,180},{210,120},{-4,120},
      {-4,155},{18,155}}, color={255,0,255}));

annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/PrimarySystem/ChillerPlant/Tower/Staging/Subsequences/Validation/EnableCells.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableCells\">
Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.Staging.Subsequences.EnableCells</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 12, 2019, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
 Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                   graphics={
            Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-220,-220},{220,
            220}})));
end EnableCells;
