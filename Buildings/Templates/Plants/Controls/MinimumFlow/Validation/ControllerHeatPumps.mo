within Buildings.Templates.Plants.Controls.MinimumFlow.Validation;
model ControllerHeatPumps
  "Validation model for the HP plant minimum flow bypass valve controller"
  Buildings.Templates.Plants.Controls.MinimumFlow.ControllerHeatPumps ctlFloMinPumCoo(
    have_heaWat=false,
    have_chiWat=true,
    have_pumPriHdr=false,
    have_pumChiWatPriDedHp=true,
    nHp=2,
    nPhp=0,
    have_valInlIso=false,
    have_valOutIso=false,
    VChiWat_flow_nominal={0.02, 0.05},
    VChiWat_flow_min={0.01, 0.03})
    "Valve controller enabled by primary pump status – Cooling-only application"
    annotation(Placement(transformation(extent={{-90,-80},{-70,-48}})));
  Buildings.Templates.Plants.Controls.MinimumFlow.ControllerHeatPumps ctlFloMinValCoo(
    have_heaWat=false,
    have_chiWat=true,
    have_pumPriHdr=true,
    nHp=2,
    nPhp=0,
    have_valInlIso=true,
    have_valOutIso=false,
    VChiWat_flow_nominal={0.02, 0.05},
    VChiWat_flow_min={0.01, 0.03})
    "Valve controller enabled by isolation valve command – Cooling-only application"
    annotation(Placement(transformation(extent={{-90,0},{-68,32}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1EquValPum(
    table=[0, 0, 0; 1, 1, 0; 2, 1, 1; 3, 0, 1; 4, 0, 0],
    timeScale=200,
    period=900)
    "Source signal for equipment or valve command or pump status"
    annotation(Placement(transformation(extent={{-190,50},{-170,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin dVPri_flow(
    amplitude=sum(ctlFloMinValCoo.VChiWat_flow_min) / 2,
    freqHz=3 / 1000)
    "Source signal for primary flow rate variation around setpoint"
    annotation(Placement(transformation(extent={{-190,-30},{-170,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Add VPriCoo_flow1
    "Primary flow rate"
    annotation(Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Add VPriCoo_flow
    "Primary flow rate"
    annotation(Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Templates.Plants.Controls.MinimumFlow.ControllerHeatPumps ctlFloMinPumHea(
    have_heaWat=true,
    have_chiWat=false,
    have_pumPriHdr=false,
    have_pumChiWatPriDedHp=false,
    nHp=2,
    nPhp=0,
    have_valInlIso=false,
    have_valOutIso=false,
    VHeaWat_flow_nominal={0.02, 0.05},
    VHeaWat_flow_min={0.01, 0.03})
    "Valve controller enabled by primary pump status – Heating-only application"
    annotation(Placement(transformation(extent={{0,-80},{20,-48}})));
  Buildings.Templates.Plants.Controls.MinimumFlow.ControllerHeatPumps ctlFloMinValHea(
    have_heaWat=true,
    have_chiWat=false,
    have_pumPriHdr=true,
    nHp=2,
    nPhp=0,
    have_valInlIso=true,
    have_valOutIso=false,
    VHeaWat_flow_nominal={0.02, 0.05},
    VHeaWat_flow_min={0.01, 0.03})
    "Valve controller enabled by isolation valve command – Heating-only application"
    annotation(Placement(transformation(extent={{0,0},{20,32}})));
  Buildings.Controls.OBC.CDL.Reals.Add VPriHea_flow1
    "Primary flow rate"
    annotation(Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Add VPriHea_flow
    "Primary flow rate"
    annotation(Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Templates.Plants.Controls.MinimumFlow.ControllerHeatPumps ctlFloMinPumHeaCoo(
    have_heaWat=true,
    have_chiWat=true,
    have_pumPriHdr=false,
    have_pumChiWatPriDedHp=false,
    nHp=2,
    nPhp=0,
    have_valInlIso=false,
    have_valOutIso=false,
    VHeaWat_flow_nominal={0.02, 0.05},
    VHeaWat_flow_min={0.01, 0.03},
    VChiWat_flow_nominal={0.02, 0.05},
    VChiWat_flow_min={0.01, 0.03})
    "Valve controller enabled by primary pump status – Heating and cooling application"
    annotation(Placement(transformation(extent={{100,-80},{120,-48}})));
  Buildings.Templates.Plants.Controls.MinimumFlow.ControllerHeatPumps ctlFloMinValHeaCoo(
    have_heaWat=true,
    have_chiWat=true,
    have_pumPriHdr=true,
    nHp=2,
    nPhp=0,
    have_valInlIso=true,
    have_valOutIso=false,
    VHeaWat_flow_nominal={0.02, 0.05},
    VHeaWat_flow_min={0.01, 0.03},
    VChiWat_flow_nominal={0.02, 0.05},
    VChiWat_flow_min={0.01, 0.03})
    "Valve controller enabled by isolation valve command – Heating and cooling application"
    annotation(Placement(transformation(extent={{100,0},{120,32}})));
  Buildings.Controls.OBC.CDL.Reals.Add VPriHeaCoo_flow1
    "Primary flow rate"
    annotation(Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Add VPriHeaCoo_flow
    "Primary flow rate"
    annotation(Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1HeaEqu(
    table=[0, 0, 0; 1.5, 1, 0; 2.5, 0, 1],
    timeScale=200,
    period=900)
    "Source signal for equipment heating/cooling mode command or pump status"
    annotation(Placement(transformation(extent={{190,-30},{170,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And u1ValChiWat[2]
    "Source signal for CHW isolation valves"
    annotation(Placement(transformation(extent={{150,-10},{130,10}})));
  Buildings.Controls.OBC.CDL.Logical.And u1ValHeaWat[2]
    "Source signal for HW isolation valves"
    annotation(Placement(transformation(extent={{150,-50},{130,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not u1CooEqu[2]
    "True if equipment is commanded in cooling mode"
    annotation(Placement(transformation(extent={{190,10},{170,30}})));
equation
  connect(u1EquValPum.y[1:2], ctlFloMinValCoo.u1Hp[1:2])
    annotation(Line(points={{-168,60},{-110,60},{-110,30.2},{-92.2,30.2}},
      color={255,0,255}));
  connect(u1EquValPum.y[1:2], ctlFloMinPumCoo.u1Hp[1:2])
    annotation(Line(points={{-168,60},{-110,60},{-110,-49.8},{-92,-49.8}},
      color={255,0,255}));
  connect(dVPri_flow.y, VPriCoo_flow1.u2)
    annotation(Line(points={{-168,-20},{-150,-20},{-150,-66},{-142,-66}},
      color={0,0,127}));
  connect(dVPri_flow.y, VPriCoo_flow.u2)
    annotation(Line(points={{-168,-20},{-150,-20},{-150,-6},{-142,-6}},
      color={0,0,127}));
  connect(ctlFloMinPumCoo.VChiWatPriSet_flow, VPriCoo_flow1.u1)
    annotation(Line(
      points={{-68,-58},{-64,-58},{-64,-40},{-146,-40},{-146,-54},{-142,-54}},
      color={0,0,127}));
  connect(ctlFloMinValCoo.VChiWatPriSet_flow, VPriCoo_flow.u1)
    annotation(Line(
      points={{-65.8,22},{-66,22},{-66,40},{-150,40},{-150,6},{-142,6}},
      color={0,0,127}));
  connect(VPriCoo_flow.y, ctlFloMinValCoo.VChiWatPri_flow)
    annotation(Line(points={{-118,0},{-100,0},{-100,4.2},{-92.2,4.2}},
      color={0,0,127}));
  connect(VPriCoo_flow1.y, ctlFloMinPumCoo.VChiWatPri_flow)
    annotation(Line(points={{-118,-60},{-100,-60},{-100,-75.8},{-92,-75.8}},
      color={0,0,127}));
  connect(u1EquValPum.y[1:2], ctlFloMinValCoo.u1ValChiWatInlIso[1:2])
    annotation(Line(points={{-168,60},{-110,60},{-110,22.7},{-92.2,22.7}},
      color={255,0,255}));
  connect(u1EquValPum.y[1:2], ctlFloMinPumCoo.u1PumChiWatPriDedHp_actual[1:2])
    annotation(Line(points={{-168,60},{-110,60},{-110,-69.3},{-92,-69.3}},
      color={255,0,255}));
  connect(u1EquValPum.y[1:2], ctlFloMinValHea.u1Hp[1:2])
    annotation(Line(points={{-168,60},{-20,60},{-20,30.2},{-2,30.2}},
      color={255,0,255}));
  connect(u1EquValPum.y[1:2], ctlFloMinPumHea.u1Hp[1:2])
    annotation(Line(points={{-168,60},{-20,60},{-20,-49.8},{-2,-49.8}},
      color={255,0,255}));
  connect(dVPri_flow.y, VPriHea_flow.u2)
    annotation(Line(points={{-168,-20},{-60,-20},{-60,-6},{-52,-6}},
      color={0,0,127}));
  connect(dVPri_flow.y, VPriHea_flow1.u2)
    annotation(Line(points={{-168,-20},{-60,-20},{-60,-66},{-52,-66}},
      color={0,0,127}));
  connect(ctlFloMinPumHea.VHeaWatPriSet_flow, VPriHea_flow1.u1)
    annotation(Line(
      points={{22,-54},{24,-54},{24,-40},{-56,-40},{-56,-54},{-52,-54}},
      color={0,0,127}));
  connect(ctlFloMinValHea.VHeaWatPriSet_flow, VPriHea_flow.u1)
    annotation(Line(points={{22,26},{24,26},{24,40},{-60,40},{-60,6},{-52,6}},
      color={0,0,127}));
  connect(VPriHea_flow1.y, ctlFloMinPumHea.VHeaWatPri_flow)
    annotation(Line(points={{-28,-60},{-10,-60},{-10,-73.8},{-2,-73.8}},
      color={0,0,127}));
  connect(VPriHea_flow.y, ctlFloMinValHea.VHeaWatPri_flow)
    annotation(Line(points={{-28,0},{-10,0},{-10,6.2},{-2,6.2}},
      color={0,0,127}));
  connect(u1EquValPum.y[1:2], ctlFloMinValHea.u1ValHeaWatInlIso[1:2])
    annotation(Line(points={{-168,60},{-20,60},{-20,26.7},{-2,26.7}},
      color={255,0,255}));
  connect(u1EquValPum.y[1:2], ctlFloMinPumHea.u1PumHeaWatPriDedHp_actual[1:2])
    annotation(Line(points={{-168,60},{-20,60},{-20,-63.3},{-2,-63.3}},
      color={255,0,255}));
  connect(u1EquValPum.y[1:2], ctlFloMinPumHeaCoo.u1Hp[1:2])
    annotation(Line(points={{-168,60},{80,60},{80,-49.8},{98,-49.8}},
      color={255,0,255}));
  connect(ctlFloMinPumHeaCoo.VHeaWatPriSet_flow, VPriHeaCoo_flow1.u1)
    annotation(Line(
      points={{122,-54},{124,-54},{124,-44},{44,-44},{44,-54},{48,-54}},
      color={0,0,127}));
  connect(ctlFloMinValHeaCoo.VHeaWatPriSet_flow, VPriHeaCoo_flow.u1)
    annotation(Line(points={{122,26},{124,26},{124,40},{40,40},{40,6},{48,6}},
      color={0,0,127}));
  connect(VPriHeaCoo_flow1.y, ctlFloMinPumHeaCoo.VHeaWatPri_flow)
    annotation(Line(points={{72,-60},{90,-60},{90,-73.8},{98,-73.8}},
      color={0,0,127}));
  connect(VPriHeaCoo_flow.y, ctlFloMinValHeaCoo.VHeaWatPri_flow)
    annotation(Line(points={{72,0},{90,0},{90,6.2},{98,6.2}},
      color={0,0,127}));
  connect(u1EquValPum.y[1:2], ctlFloMinValHeaCoo.u1Hp)
    annotation(Line(points={{-168,60},{80,60},{80,30.2},{98,30.2}},
      color={255,0,255}));
  connect(u1EquValPum.y[1:2], ctlFloMinPumHeaCoo.u1PumHeaWatPriDedHp_actual[1:2])
    annotation(Line(points={{-168,60},{80,60},{80,-63.3},{98,-63.3}},
      color={255,0,255}));
  connect(dVPri_flow.y, VPriHeaCoo_flow.u2)
    annotation(Line(points={{-168,-20},{40,-20},{40,-6},{48,-6}},
      color={0,0,127}));
  connect(dVPri_flow.y, VPriHeaCoo_flow1.u2)
    annotation(Line(points={{-168,-20},{40,-20},{40,-66},{48,-66}},
      color={0,0,127}));
  connect(VPriHeaCoo_flow.y, ctlFloMinValHeaCoo.VChiWatPri_flow)
    annotation(Line(points={{72,0},{90,0},{90,4.2},{98,4.2}},
      color={0,0,127}));
  connect(VPriHeaCoo_flow1.y, ctlFloMinPumHeaCoo.VChiWatPri_flow)
    annotation(Line(points={{72,-60},{90,-60},{90,-75.8},{98,-75.8}},
      color={0,0,127}));
  connect(u1HeaEqu.y[1:2], ctlFloMinValHeaCoo.u1HeaHp[1:2])
    annotation(Line(points={{168,-20},{90,-20},{90,28.2},{98,28.2}},
      color={255,0,255}));
  connect(u1HeaEqu.y[1:2], ctlFloMinPumHeaCoo.u1HeaHp[1:2])
    annotation(Line(points={{168,-20},{90,-20},{90,-51.8},{98,-51.8}},
      color={255,0,255}));
  connect(u1EquValPum.y[1:2], u1ValChiWat[1:2].u1)
    annotation(Line(points={{-168,60},{160,60},{160,0},{152,0}},
      color={255,0,255}));
  connect(u1EquValPum.y[1:2], u1ValHeaWat[1:2].u1)
    annotation(Line(points={{-168,60},{160,60},{160,-40},{152,-40}},
      color={255,0,255}));
  connect(u1HeaEqu.y[1:2], u1ValHeaWat[1:2].u2)
    annotation(Line(points={{168,-20},{164,-20},{164,-48},{152,-48}},
      color={255,0,255}));
  connect(u1HeaEqu.y[1:2], u1CooEqu.u)
    annotation(Line(
      points={{168,-20},{164,-20},{164,0},{196,0},{196,20},{192,20}},
      color={255,0,255}));
  connect(u1CooEqu.y, u1ValChiWat.u2)
    annotation(Line(points={{168,20},{156,20},{156,-8},{152,-8}},
      color={255,0,255}));
  connect(u1ValChiWat.y, ctlFloMinValHeaCoo.u1ValChiWatInlIso)
    annotation(Line(points={{128,0},{92,0},{92,22.2},{98,22.2}},
      color={255,0,255}));
  connect(u1ValHeaWat.y, ctlFloMinValHeaCoo.u1ValHeaWatInlIso)
    annotation(Line(points={{128,-40},{94,-40},{94,26.2},{98,26.2}},
      color={255,0,255}));
annotation(__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/MinimumFlow/Validation/ControllerHeatPumps.mos"
    "Simulate and plot"),
  experiment(StopTime=1000.0,
    Tolerance=1e-06),
  Icon(graphics={Ellipse(lineColor={75,138,73},
    fillColor={255,255,255},
    fillPattern=FillPattern.Solid,
    extent={{-100,-100},{100,100}}),
  Polygon(lineColor={0,0,255},
    fillColor={75,138,73},
    pattern=LinePattern.None,
    fillPattern=FillPattern.Solid,
    points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
  Documentation(
    info="<html>
<p>
  This model validates
  <a href=\"modelica://Buildings.Templates.Plants.Controls.MinimumFlow.ControllerHeatPumps\">
    Buildings.Templates.Plants.Controls.MinimumFlow.ControllerDualMode</a> for
  cooling-only (components <code>*Coo</code>), heating-only (components
  <code>*Hea</code>) and heating and cooling applications (components
  <code>*HeaCoo</code>), and for two plant configurations: one where the
  bypass valve controller is enabled with the isolation valve command
  (components <code>ctlFloMinVal*</code>), and another where it is enabled
  with the primary pump status (components <code>ctlFloMinPum*</code>).
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    May 31, 2024, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"),
  Diagram(coordinateSystem(extent={{-200,-100},{200,100}})));
end ControllerHeatPumps;
