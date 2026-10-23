within Buildings.Templates.Plants.Controls.Pumps.Primary.Validation;
model VariableSpeedWithHeatPumps
  "Validation model for the control logic of variable speed primary pumps in heat pump plants"
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeedWithHeatPumps ctlPumPriHdrHea(
    have_heaWat=true,
    have_chiWat=false,
    nHp=2,
    nPhp=0,
    have_pumPriCtlDp=false,
    have_pumPriHdr=true,
    nPumHeaWatPri=2,
    nPumChiWatPri=0,
    yPumHeaWatPriHdrSet=1,
    yPumHeaWatPriDedHpSet=0.8)
    "Headered primary pumps without Δp control – Heating-only plant"
    annotation(Placement(transformation(extent={{0,52},{20,96}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1(
    table=[
      0, 0, 0;
      0.1, 1, 0;
      0.5, 1, 1;
      1, 1, 1;
      1.5, 1, 1;
      2, 0, 1;
      2.5, 0, 0;
      3, 0, 0
    ],
    timeScale=800,
    period=3500)
    "Command signal – Plant, equipment or isolation valve depending on tested configuration"
    annotation(Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeedWithHeatPumps ctlPumPriHdr(
    have_heaWat=true,
    have_chiWat=true,
    nHp=2,
    nPhp=0,
    have_pumPriCtlDp=false,
    have_pumPriHdr=true,
    yPumHeaWatPriHdrSet=1,
    yPumChiWatPriHdrSet=1,
    yPumHeaWatPriDedHpSet=0.8,
    yPumChiWatPriDedHpSet=0.9,
    nPumHeaWatPri=2,
    nPumChiWatPri=2)
    "Headered primary pumps without Δp control – Heating and cooling plant"
    annotation(Placement(transformation(extent={{0,-14},{20,30}})));
  Buildings.Controls.OBC.CDL.Logical.Not u1Coo[2]
    "Opposite signal to generate cooling system commands"
    annotation(Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeedWithHeatPumps ctlPumPriDedCom(
    have_heaWat=true,
    have_chiWat=true,
    have_pumPriCtlDp=false,
    have_pumChiWatPriDedHp=false,
    have_pumPriHdr=false,
    nHp=2,
    nPhp=0,
    nPumHeaWatPri=2,
    yPumHeaWatPriDedHpSet=0.8,
    yPumChiWatPriDedHpSet=0.9)
    "Common dedicated primary pumps without Δp control – Heating and cooling plant"
    annotation(Placement(transformation(extent={{0,-74},{20,-30}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeedWithHeatPumps ctlPumPriDedSep(
    have_heaWat=true,
    have_chiWat=true,
    have_pumPriCtlDp=false,
    have_pumChiWatPriDedHp=true,
    have_pumPriHdr=false,
    nHp=2,
    nPhp=0,
    nPumHeaWatPri=2,
    nPumChiWatPri=2,
    yPumHeaWatPriDedHpSet=0.8,
    yPumChiWatPriDedHpSet=0.9)
    "Separate dedicated primary pumps without Δp control – Heating and cooling plant"
    annotation(Placement(transformation(extent={{0,-136},{20,-92}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeedWithHeatPumps ctlPumPriHdrHeaDp(
    have_heaWat=true,
    have_chiWat=false,
    nHp=2,
    nPhp=0,
    have_pumPriCtlDp=true,
    have_pumPriHdr=true,
    nPumHeaWatPri=2,
    nPumChiWatPri=0,
    have_senDpHeaWatRemWir=false,
    nSenDpHeaWatRem=2)
    "Headered primary pumps with Δp control – Heating-only plant"
    annotation(Placement(transformation(extent={{70,52},{90,96}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratDp(
    table=[0, 0.1, 0.5; 1, 1, 0.5; 1.5, 1, 0.2; 2, 0.1, 0.1],
    timeScale=3600)
    "Differential pressure ratio to design value"
    annotation(Placement(transformation(extent={{-100,130},{-80,150}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter dpSet[2](k={3E4, 2E4})
    "Differential pressure setpoint"
    annotation(Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin[2](
    amplitude=0.1 * dpSet.k,
    freqHz={2 / 8000, 4 / 8000},
    each phase=3.1415926535898)
    "Source signal used to generate measurement values"
    annotation(Placement(transformation(extent={{-100,70},{-80,90}})));
  Buildings.Controls.OBC.CDL.Reals.Add dp[2]
    "Differential pressure"
    annotation(Placement(transformation(extent={{-10,110},{10,130}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeedWithHeatPumps ctlPumPriHdrDp(
    have_heaWat=true,
    have_chiWat=true,
    nHp=2,
    nPhp=0,
    have_pumPriCtlDp=true,
    have_pumPriHdr=true,
    nPumHeaWatPri=2,
    nPumChiWatPri=2,
    have_senDpHeaWatRemWir=true,
    nSenDpHeaWatRem=2,
    have_senDpChiWatRemWir=true,
    nSenDpChiWatRem=2)
    "Headered primary pumps with Δp control – Heating and cooling plant"
    annotation(Placement(transformation(extent={{70,-14},{90,30}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeedWithHeatPumps ctlPumPriDedComDp(
    have_heaWat=true,
    have_chiWat=true,
    have_pumChiWatPriDedHp=false,
    nHp=2,
    nPhp=0,
    have_pumPriCtlDp=true,
    have_pumPriHdr=false,
    nPumHeaWatPri=2,
    have_senDpHeaWatRemWir=false,
    nSenDpHeaWatRem=2,
    have_senDpChiWatRemWir=false,
    nSenDpChiWatRem=2)
    "Common dedicated primary pumps with Δp control – Heating and cooling plant"
    annotation(Placement(transformation(extent={{70,-74},{90,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1Hea(
    table=[
      0, 0, 0;
      0.1, 1, 0;
      0.5, 1, 0;
      1, 0, 0;
      1.5, 0, 1;
      2, 0, 1;
      2.5, 0, 0;
      3, 0, 0
    ],
    timeScale=600,
    period=5000)
    "Heating mode command signal"
    annotation(Placement(transformation(extent={{-100,-150},{-80,-130}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeedWithHeatPumps ctlPumPriDedSepDp(
    have_heaWat=true,
    have_chiWat=true,
    have_pumPriCtlDp=true,
    have_pumChiWatPriDedHp=true,
    have_pumPriHdr=false,
    nHp=2,
    nPhp=0,
    nPumHeaWatPri=2,
    nPumChiWatPri=2,
    yPumHeaWatPriDedHpSet=0.8,
    yPumChiWatPriDedHpSet=0.9,
    have_senDpHeaWatRemWir=false,
    nSenDpHeaWatRem=2,
    have_senDpChiWatRemWir=false,
    nSenDpChiWatRem=2)
    "Separate dedicated primary pumps with Δp control – Heating and cooling plant"
    annotation(Placement(transformation(extent={{70,-136},{90,-92}})));
equation
  connect(u1.y, u1Coo.u)
    annotation(Line(points={{-78,0},{-52,0}},
      color={255,0,255}));
  connect(u1Coo.y, ctlPumPriHdr.u1PumChiWatPriHdr)
    annotation(Line(points={{-28,0},{-20,0},{-20,6},{-2,6}},
      color={255,0,255}));
  connect(u1.y, ctlPumPriHdr.u1PumHeaWatPriHdr)
    annotation(Line(points={{-78,0},{-60,0},{-60,28},{-2,28}},
      color={255,0,255}));
  connect(u1.y, ctlPumPriHdrHea.u1PumHeaWatPriHdr)
    annotation(Line(points={{-78,0},{-60,0},{-60,94},{-2,94}},
      color={255,0,255}));
  connect(u1.y, ctlPumPriHdrHeaDp.u1PumHeaWatPriHdr)
    annotation(Line(points={{-78,0},{-60,0},{-60,90},{40,90},{40,94},{68,94}},
      color={255,0,255}));
  connect(u1.y, ctlPumPriHdrHeaDp.u1PumHeaWatPriHdr_actual)
    annotation(Line(points={{-78,0},{-60,0},{-60,90},{40,90},{40,88},{68,88}},
      color={255,0,255}));
  connect(ratDp.y, dpSet.u)
    annotation(Line(points={{-78,140},{-62,140}},
      color={0,0,127}));
  connect(sin.y, dp.u2)
    annotation(Line(points={{-78,80},{-70,80},{-70,114},{-12,114}},
      color={0,0,127}));
  connect(dpSet.y, dp.u1)
    annotation(Line(points={{-38,140},{-30,140},{-30,126},{-12,126}},
      color={0,0,127}));
  connect(dpSet[1:2].y, ctlPumPriHdrHeaDp.dpHeaWatLocSet)
    annotation(Line(points={{-38,140},{60,140},{60,78},{68,78}},
      color={0,0,127}));
  connect(dp[1].y, ctlPumPriHdrHeaDp.dpHeaWatLoc)
    annotation(Line(points={{12,120},{58,120},{58,76},{68,76}},
      color={0,0,127}));
  connect(u1.y, ctlPumPriHdrDp.u1PumHeaWatPriHdr)
    annotation(Line(points={{-78,0},{-60,0},{-60,40},{40,40},{40,28},{68,28}},
      color={255,0,255}));
  connect(u1.y, ctlPumPriHdrDp.u1PumHeaWatPriHdr_actual)
    annotation(Line(points={{-78,0},{-60,0},{-60,40},{40,40},{40,22},{68,22}},
      color={255,0,255}));
  connect(u1Coo.y, ctlPumPriHdrDp.u1PumChiWatPriHdr)
    annotation(Line(points={{-28,0},{-20,0},{-20,-18},{48,-18},{48,6},{68,6}},
      color={255,0,255}));
  connect(u1Coo.y, ctlPumPriHdrDp.u1PumChiWatPriHdr_actual)
    annotation(Line(points={{-28,0},{-20,0},{-20,-18},{48,-18},{48,0},{68,0}},
      color={255,0,255}));
  connect(dpSet.y, ctlPumPriHdrDp.dpHeaWatRemSet)
    annotation(Line(points={{-38,140},{60,140},{60,16},{68,16}},
      color={0,0,127}));
  connect(dp.y, ctlPumPriHdrDp.dpHeaWatRem)
    annotation(Line(points={{12,120},{58,120},{58,14},{68,14}},
      color={0,0,127}));
  connect(dp.y, ctlPumPriHdrDp.dpChiWatRem)
    annotation(Line(points={{12,120},{58,120},{58,-8},{68,-8}},
      color={0,0,127}));
  connect(dpSet.y, ctlPumPriHdrDp.dpChiWatRemSet)
    annotation(Line(points={{-38,140},{60,140},{60,-6},{68,-6}},
      color={0,0,127}));
  connect(dp[1].y, ctlPumPriDedComDp.dpHeaWatLoc)
    annotation(Line(points={{12,120},{58,120},{58,-50},{68,-50}},
      color={0,0,127}));
  connect(dp[2].y, ctlPumPriDedComDp.dpChiWatLoc)
    annotation(Line(points={{12,120},{58,120},{58,-72},{68,-72}},
      color={0,0,127}));
  connect(dpSet.y, ctlPumPriDedComDp.dpHeaWatLocSet)
    annotation(Line(points={{-38,140},{60,140},{60,-48},{68,-48}},
      color={0,0,127}));
  connect(dpSet.y, ctlPumPriDedComDp.dpChiWatLocSet)
    annotation(Line(points={{-38,140},{60,140},{60,-70},{68,-70}},
      color={0,0,127}));
  connect(u1Hea.y, ctlPumPriDedComDp.u1HeaHp)
    annotation(Line(points={{-78,-140},{42,-140},{42,-52},{68,-52}},
      color={255,0,255}));
  connect(dpSet.y, ctlPumPriDedSepDp.dpHeaWatLocSet)
    annotation(Line(points={{-38,140},{60,140},{60,-110},{68,-110}},
      color={0,0,127}));
  connect(dpSet.y, ctlPumPriDedSepDp.dpChiWatLocSet)
    annotation(Line(points={{-38,140},{60,140},{60,-132},{68,-132}},
      color={0,0,127}));
  connect(dp[2].y, ctlPumPriDedSepDp.dpChiWatLoc)
    annotation(Line(points={{12,120},{58,120},{58,-134},{68,-134}},
      color={0,0,127}));
  connect(dp[1].y, ctlPumPriDedSepDp.dpHeaWatLoc)
    annotation(Line(points={{12,120},{57.8788,120},{57.8788,-112},{68,-112}},
      color={0,0,127}));
  connect(u1Hea.y, ctlPumPriDedCom.u1HeaHp)
    annotation(Line(points={{-78,-140},{-10,-140},{-10,-52},{-2,-52}},
      color={255,0,255}));
  connect(u1.y, ctlPumPriDedSepDp.u1PumHeaWatPriDedHp)
    annotation(Line(points={{-78,0},{-60,0},{-60,40},{40,40},{40,-96},{68,-96}},
      color={255,0,255}));
  connect(u1.y, ctlPumPriDedSepDp.u1PumHeaWatPriDedHp_actual)
    annotation(Line(
      points={{-78,0},{-60,0},{-60,40},{40,40},{40,-102},{68,-102}},
      color={255,0,255}));
  connect(u1.y, ctlPumPriDedCom.u1PumHeaWatPriDedHp)
    annotation(Line(points={{-78,0},{-60,0},{-60,-34},{-2,-34}},
      color={255,0,255}));
  connect(u1Coo.y, ctlPumPriDedSepDp.u1PumChiWatPriDedHp)
    annotation(Line(
      points={{-28,0},{-20,0},{-20,-80},{38,-80},{38,-118},{68,-118}},
      color={255,0,255}));
  connect(u1.y, ctlPumPriDedSep.u1PumHeaWatPriDedHp)
    annotation(Line(points={{-78,0},{-60,0},{-60,-96},{-2,-96}},
      color={255,0,255}));
  connect(u1Coo.y, ctlPumPriDedSep.u1PumChiWatPriDedHp)
    annotation(Line(points={{-28,0},{-20,0},{-20,-118},{-2,-118}},
      color={255,0,255}));
  connect(u1Coo.y, ctlPumPriDedSepDp.u1PumChiWatPriDedHp_actual)
    annotation(Line(
      points={{-28,0},{-20,0},{-20,-80},{38,-80},{38,-124},{68,-124}},
      color={255,0,255}));
  connect(u1.y, ctlPumPriDedComDp.u1PumHeaWatPriDedHp)
    annotation(Line(points={{-78,0},{-60,0},{-60,40},{40,40},{40,-34},{68,-34}},
      color={255,0,255}));
  connect(u1.y, ctlPumPriDedComDp.u1PumHeaWatPriDedHp_actual)
    annotation(Line(points={{-78,0},{-60,0},{-60,40},{40,40},{40,-40},{68,-40}},
      color={255,0,255}));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/Pumps/Primary/Validation/VariableSpeedWithHeatPumps.mos"
    "Simulate and plot"),
  experiment(StopTime=5000.0,
    Tolerance=1e-06),
  Documentation(
    info="<html>
<p>
  This model validates
  <a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeedWithHeatPumps\">
    Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeedWithHeatPumps</a>
  with two plant equipment and two primary pumps and for the following
  configurations.
</p>
<ul>
  <li>
    Heating-only plant with headered primary pumps (components
    <code>ctlPumPriHdrHea*</code>)
  </li>
  <li>
    Heating and cooling plant with headered primary pumps (components
    <code>ctlPumPriHdr*</code>)
  </li>
  <li>
    Heating and cooling plant with common dedicated primary pumps (components
    <code>ctlPumPriDedCom*</code>)
  </li>
  <li>
    Heating and cooling plant with separate dedicated primary pumps
    (components <code>ctlPumPriDedSep*</code>)
  </li>
  <li>
    Primary pumps commanded at fixed speed (component names as listed above,
    without a suffix) or Δp-controlled (components <code>*Dp</code>)
  </li>
</ul>
</html>",
    revisions="<html>
<ul>
  <li>
    May 31, 2024, by Antoine Gautier:<br />
    Added test for ∆p-controlled primary pumps.
  </li>
  <li>
    March 29, 2024, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"),
  Icon(graphics={Ellipse(lineColor={75,138,73},
    fillColor={255,255,255},
    fillPattern=FillPattern.Solid,
    extent={{-100,-100},{100,100}}),
  Polygon(lineColor={0,0,255},
    fillColor={75,138,73},
    pattern=LinePattern.None,
    fillPattern=FillPattern.Solid,
    points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Diagram(coordinateSystem(extent={{-120,-160},{120,160}},
    grid={2,2}),
    graphics={Polygon(points={{214,66},{214,66}},
      lineColor={28,108,200})}));
end VariableSpeedWithHeatPumps;
