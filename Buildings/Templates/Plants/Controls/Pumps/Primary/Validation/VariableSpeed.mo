within Buildings.Templates.Plants.Controls.Pumps.Primary.Validation;
model VariableSpeed
  "Validation model for the control logic of variable speed primary pumps"
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeed ctlPumPriHdrHea(
    have_heaWat=true,
    have_chiWat=false,
    have_pumPriCtlDp=false,
    have_pumPriHdr=true,
    nPumHeaWatPri=2,
    yPumHeaWatPriSet=0.8)
    "Headered primary pumps without Δp control – Heating-only plant"
    annotation (Placement(transformation(extent={{0,32},{20,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1(
    table=[
      0, 0, 0;
      0.1, 1, 0;
      0.5, 1, 1;
      1, 1, 1;
      1.5, 1, 1;
      2, 0, 1;
      2.5, 0, 0;
      3, 0, 0],
    timeScale=800,
    period=3500)
    "Command signal – Plant, equipment or isolation valve depending on tested configuration"
    annotation (Placement(transformation(extent={{-100,-30},{-80,-10}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeed ctlPumPriHdr(
    have_heaWat=true,
    have_chiWat=true,
    have_pumPriCtlDp=false,
    have_pumPriHdr=true,
    nEqu=2,
    nPumHeaWatPri=2,
    nPumChiWatPri=2,
    yPumHeaWatPriSet=0.8,
    yPumChiWatPriSet=0.9)
    "Headered primary pumps without Δp control – Heating and cooling plant"
    annotation (Placement(transformation(extent={{0,-8},{20,20}})));
  Buildings.Controls.OBC.CDL.Logical.Not u1Coo[2]
    "Opposite signal to generate cooling system commands"
    annotation (Placement(transformation(extent={{-50,-30},{-30,-10}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeed ctlPumPriDedCom(
    have_heaWat=true,
    have_chiWat=true,
    have_pumPriCtlDp=false,
    have_pumChiWatPriDed=false,
    have_pumPriHdr=false,
    nEqu=2,
    nPumHeaWatPri=2,
    yPumHeaWatPriSet=0.8,
    yPumChiWatPriSet=0.9)
    "Common dedicated primary pumps without Δp control – Heating and cooling plant"
    annotation (Placement(transformation(extent={{0,-60},{20,-32}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeed ctlPumPriDedSep(
    have_heaWat=true,
    have_chiWat=true,
    have_pumPriCtlDp=false,
    have_pumChiWatPriDed=true,
    have_pumPriHdr=false,
    nEqu=2,
    nPumHeaWatPri=2,
    nPumChiWatPri=2,
    yPumHeaWatPriSet=0.8,
    yPumChiWatPriSet=0.9)
    "Separate dedicated primary pumps without Δp control – Heating and cooling plant"
    annotation (Placement(transformation(extent={{0,-108},{20,-80}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeed ctlPumPriHdrHeaDp(
    have_heaWat=true,
    have_chiWat=false,
    have_pumPriCtlDp=true,
    have_pumPriHdr=true,
    nPumHeaWatPri=2,
    yPumHeaWatPriSet=0.8,
    have_senDpHeaWatRemWir=false,
    nSenDpHeaWatRem=2)
    "Headered primary pumps with Δp control – Heating-only plant"
    annotation (Placement(transformation(extent={{70,32},{90,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratDp(
    table=[
      0, 0.1, 0.5;
      1, 1, 0.5;
      1.5, 1, 0.2;
      2, 0.1, 0.1],
    timeScale=3600)
    "Differential pressure ratio to design value"
    annotation (Placement(transformation(extent={{-100,110},{-80,130}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter dpSet[2](
    k={3E4, 2E4})
    "Differential pressure setpoint"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin[2](
    amplitude=0.1 * dpSet.k,
    freqHz={2 / 8000, 4 / 8000},
    each phase=3.1415926535898)
    "Source signal used to generate measurement values"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Reals.Add dp[2]
    "Differential pressure"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeed ctlPumPriHdrDp(
    have_heaWat=true,
    have_chiWat=true,
    have_pumPriCtlDp=true,
    have_pumPriHdr=true,
    nEqu=2,
    nPumHeaWatPri=2,
    nPumChiWatPri=2,
    yPumHeaWatPriSet=0.8,
    yPumChiWatPriSet=0.9,
    have_senDpHeaWatRemWir=true,
    nSenDpHeaWatRem=2,
    have_senDpChiWatRemWir=true,
    nSenDpChiWatRem=2)
    "Headered primary pumps with Δp control – Heating and cooling plant"
    annotation (Placement(transformation(extent={{70,-8},{90,20}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeed ctlPumPriDedComDp(
    have_heaWat=true,
    have_chiWat=true,
    have_pumPriCtlDp=true,
    have_pumChiWatPriDed=false,
    have_pumPriHdr=false,
    nEqu=2,
    nPumHeaWatPri=2,
    yPumHeaWatPriSet=0.8,
    yPumChiWatPriSet=0.9,
    have_senDpHeaWatRemWir=false,
    nSenDpHeaWatRem=2,
    have_senDpChiWatRemWir=false,
    nSenDpChiWatRem=2)
    "Common dedicated primary pumps with Δp control – Heating and cooling plant"
    annotation (Placement(transformation(extent={{70,-60},{90,-32}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1Hea(
    table=[
      0, 0, 0;
      0.1, 1, 0;
      0.5, 1, 0;
      1, 0, 0;
      1.5, 0, 1;
      2, 0, 1;
      2.5, 0, 0;
      3, 0, 0],
    timeScale=600,
    period=5000)
    "Heating mode command signal"
    annotation (Placement(transformation(extent={{-100,-130},{-80,-110}})));
  Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeed ctlPumPriDedSepDp(
    have_heaWat=true,
    have_chiWat=true,
    have_pumPriCtlDp=true,
    have_pumChiWatPriDed=true,
    have_pumPriHdr=false,
    nEqu=2,
    nPumHeaWatPri=2,
    nPumChiWatPri=2,
    yPumHeaWatPriSet=0.8,
    yPumChiWatPriSet=0.9,
    have_senDpHeaWatRemWir=false,
    nSenDpHeaWatRem=2,
    have_senDpChiWatRemWir=false,
    nSenDpChiWatRem=2)
    "Separate dedicated primary pumps with Δp control – Heating and cooling plant"
    annotation (Placement(transformation(extent={{70,-108},{90,-80}})));
equation
  connect(u1.y, u1Coo.u)
    annotation (Line(points={{-78,-20},{-52,-20}},color={255,0,255}));
  connect(u1Coo.y, ctlPumPriHdr.u1PumChiWatPri)
    annotation (Line(points={{-28,-20},{-20,-20},{-20,4},{-2,4}},color={255,0,255}));
  connect(u1.y, ctlPumPriHdr.u1PumHeaWatPri)
    annotation (Line(points={{-78,-20},{-60,-20},{-60,18},{-2,18}},color={255,0,255}));
  connect(u1.y, ctlPumPriDedCom.u1PumHeaWatPri)
    annotation (Line(points={{-78,-20},{-60,-20},{-60,-34},{-2,-34}},color={255,0,255}));
  connect(u1Coo.y, ctlPumPriDedCom.u1Hea)
    annotation (Line(points={{-28,-20},{-20,-20},{-20,-46},{-2,-46}},color={255,0,255}));
  connect(u1.y, ctlPumPriDedSep.u1PumHeaWatPri)
    annotation (Line(points={{-78,-20},{-60,-20},{-60,-82},{-2,-82}},color={255,0,255}));
  connect(u1Coo.y, ctlPumPriDedSep.u1PumChiWatPri)
    annotation (Line(points={{-28,-20},{-20,-20},{-20,-96},{-2,-96}},color={255,0,255}));
  connect(u1.y, ctlPumPriHdrHea.u1PumHeaWatPri)
    annotation (Line(points={{-78,-20},{-60,-20},{-60,58},{-2,58}},color={255,0,255}));
  connect(u1.y, ctlPumPriHdrHeaDp.u1PumHeaWatPri)
    annotation (Line(points={{-78,-20},{-60,-20},{-60,66},{40,66},{40,58},{68,58}},
      color={255,0,255}));
  connect(u1.y, ctlPumPriHdrHeaDp.u1PumHeaWatPri_actual)
    annotation (Line(points={{-78,-20},{-60,-20},{-60,66},{40,66},{40,56},{68,56}},
      color={255,0,255}));
  connect(ratDp.y, dpSet.u)
    annotation (Line(points={{-78,120},{-62,120}},color={0,0,127}));
  connect(sin.y, dp.u2)
    annotation (Line(points={{-78,60},{-70,60},{-70,74},{-62,74}},color={0,0,127}));
  connect(dpSet.y, dp.u1)
    annotation (Line(points={{-38,120},{-30,120},{-30,100},{-70,100},{-70,86},{-62,86}},
      color={0,0,127}));
  connect(dpSet[1:2].y, ctlPumPriHdrHeaDp.dpHeaWatLocSet)
    annotation (Line(points={{-38,120},{60,120},{60,50},{68,50}},color={0,0,127}));
  connect(dp[1].y, ctlPumPriHdrHeaDp.dpHeaWatLoc)
    annotation (Line(points={{-38,80},{58,80},{58,48},{68,48}},color={0,0,127}));
  connect(u1.y, ctlPumPriHdrDp.u1PumHeaWatPri)
    annotation (Line(points={{-78,-20},{-60,-20},{-60,26},{40,26},{40,18},{68,18}},
      color={255,0,255}));
  connect(u1.y, ctlPumPriHdrDp.u1PumHeaWatPri_actual)
    annotation (Line(points={{-78,-20},{-60,-20},{-60,26},{40,26},{40,16},{68,16}},
      color={255,0,255}));
  connect(u1Coo.y, ctlPumPriHdrDp.u1PumChiWatPri)
    annotation (Line(points={{-28,-20},{40,-20},{40,4},{68,4}},color={255,0,255}));
  connect(u1Coo.y, ctlPumPriHdrDp.u1PumChiWatPri_actual)
    annotation (Line(points={{-28,-20},{40,-20},{40,2},{68,2}},color={255,0,255}));
  connect(dpSet.y, ctlPumPriHdrDp.dpHeaWatRemSet)
    annotation (Line(points={{-38,120},{60,120},{60,14},{68,14}},color={0,0,127}));
  connect(dp.y, ctlPumPriHdrDp.dpHeaWatRem)
    annotation (Line(points={{-38,80},{58,80},{58,12},{68,12}},color={0,0,127}));
  connect(dp.y, ctlPumPriHdrDp.dpChiWatRem)
    annotation (Line(points={{-38,80},{58,80},{58,-2},{68,-2}},color={0,0,127}));
  connect(dpSet.y, ctlPumPriHdrDp.dpChiWatRemSet)
    annotation (Line(points={{-38,120},{60,120},{60,0},{68,0}},color={0,0,127}));
  connect(u1.y, ctlPumPriDedComDp.u1PumHeaWatPri)
    annotation (Line(points={{-78,-20},{-60,-20},{-60,-70},{40,-70},{40,-34},{68,-34}},
      color={255,0,255}));
  connect(u1.y, ctlPumPriDedComDp.u1PumHeaWatPri_actual)
    annotation (Line(points={{-78,-20},{-60,-20},{-60,-70},{40,-70},{40,-36},{68,-36}},
      color={255,0,255}));
  connect(dp[1].y, ctlPumPriDedComDp.dpHeaWatLoc)
    annotation (Line(points={{-38,80},{58,80},{58,-44},{68,-44}},color={0,0,127}));
  connect(dp[2].y, ctlPumPriDedComDp.dpChiWatLoc)
    annotation (Line(points={{-38,80},{58,80},{58,-58},{68,-58}},color={0,0,127}));
  connect(dpSet.y, ctlPumPriDedComDp.dpHeaWatLocSet)
    annotation (Line(points={{-38,120},{60,120},{60,-42},{68,-42}},color={0,0,127}));
  connect(dpSet.y, ctlPumPriDedComDp.dpChiWatLocSet)
    annotation (Line(points={{-38,120},{60,120},{60,-56},{68,-56}},color={0,0,127}));
  connect(u1Hea.y, ctlPumPriDedComDp.u1Hea)
    annotation (Line(points={{-78,-120},{42,-120},{42,-46},{68,-46}},color={255,0,255}));
  connect(dpSet.y, ctlPumPriDedSepDp.dpHeaWatLocSet)
    annotation (Line(points={{-38,120},{60,120},{60,-90},{68,-90}},color={0,0,127}));
  connect(dpSet.y, ctlPumPriDedSepDp.dpChiWatLocSet)
    annotation (Line(points={{-38,120},{60,120},{60,-104},{68,-104}},color={0,0,127}));
  connect(dp[2].y, ctlPumPriDedSepDp.dpChiWatLoc)
    annotation (Line(points={{-38,80},{58,80},{58,-106},{68,-106}},color={0,0,127}));
  connect(dp[1].y, ctlPumPriDedSepDp.dpHeaWatLoc)
    annotation (Line(points={{-38,80},{57.8788,80},{57.8788,-92},{68,-92}},color={0,0,127}));
  connect(u1.y, ctlPumPriDedSepDp.u1PumHeaWatPri)
    annotation (Line(points={{-78,-20},{-60,-20},{-60,-70},{40,-70},{40,-82},{68,-82}},
      color={255,0,255}));
  connect(u1.y, ctlPumPriDedSepDp.u1PumHeaWatPri_actual)
    annotation (Line(points={{-78,-20},{-60,-20},{-60,-70},{40,-70},{40,-84},{68,-84}},
      color={255,0,255}));
  connect(u1Coo.y, ctlPumPriDedSepDp.u1PumChiWatPri)
    annotation (Line(points={{-28,-20},{-20,-20},{-20,-72},{38,-72},{38,-96},{68,-96}},
      color={255,0,255}));
  connect(u1Coo.y, ctlPumPriDedSepDp.u1PumChiWatPri_actual)
    annotation (Line(points={{-28,-20},{-20,-20},{-20,-72},{38,-72},{38,-98},{68,-98}},
      color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/Pumps/Primary/Validation/VariableSpeed.mos"
        "Simulate and plot"),
    experiment(
      StopTime=5000.0,
      Tolerance=1e-06),
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeed\">
Buildings.Templates.Plants.Controls.Pumps.Primary.VariableSpeed</a>
with two plant equipment and two primary pumps and for the following configurations.
</p>
<ul>
<li>
Heating-only plant with headered primary pumps (components <code>ctlPumPriHdrHea*</code>)
</li>
<li>
Heating and cooling plant with headered primary pumps (components <code>ctlPumPriHdr*</code>)
</li>
<li>
Heating and cooling plant with common dedicated primary pumps (components <code>ctlPumPriDedCom*</code>)
</li>
<li>
Heating and cooling plant with separate dedicated primary pumps (components <code>ctlPumPriDedSep*</code>)
</li>
<li>
Primary pumps commanded at fixed speed (component names as listed above, without a suffix) or Δp-controlled (components <code>*Dp</code>)
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
Added test for ∆p-controlled primary pumps.
</li>
<li>
March 29, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(
      coordinateSystem(
        extent={{-120,-140},{120,140}}),
      graphics={
        Polygon(
          points={{214,66},{214,66}},
          lineColor={28,108,200})}));
end VariableSpeed;
