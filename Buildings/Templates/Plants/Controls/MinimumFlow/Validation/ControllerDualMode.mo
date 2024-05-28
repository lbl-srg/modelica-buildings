within Buildings.Templates.Plants.Controls.MinimumFlow.Validation;
model ControllerDualMode
  "Validation model for the dual mode minimum flow bypass valve controller"
  Buildings.Templates.Plants.Controls.MinimumFlow.ControllerDualMode ctlFloMinPumCoo(
    have_heaWat=false,
    have_chiWat=true,
    have_valInlIso=false,
    have_valOutIso=false,
    VChiWat_flow_nominal={0.02,0.05},
    VChiWat_flow_min={0.01,0.03},
    nEqu=2,
    nEnaChiWat=2)
    "Valve controller enabled by primary pump status – Cooling-only application"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Templates.Plants.Controls.MinimumFlow.ControllerDualMode ctlFloMinValCoo(
    have_heaWat=false,
    have_chiWat=true,
    have_valInlIso=true,
    have_valOutIso=false,
    VChiWat_flow_nominal={0.02,0.05},
    VChiWat_flow_min={0.01,0.03},
    nEqu=2,
    nEnaChiWat=2)
    "Valve controller enabled by isolation valve command – Cooling-only application"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1EquValPum(
    table=[0,0,0; 1,1,0; 2,1,1; 3,0,1; 4,0,0],
    timeScale=200,
    period=900) "Source signal for equipment or valve command or pump status"
    annotation (Placement(transformation(extent={{-190,50},{-170,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin dVPri_flow(amplitude=sum(
        ctlFloMinValCoo.VChiWat_flow_min)/2, freqHz=3/1000)
    "Source signal for primary flow rate variation around setpoint"
    annotation (Placement(transformation(extent={{-190,-30},{-170,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Add VPriCoo_flow1 "Primary flow rate"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Add VPriCoo_flow "Primary flow rate"
    annotation (Placement(transformation(extent={{-140,-10},{-120,10}})));
  Buildings.Templates.Plants.Controls.MinimumFlow.ControllerDualMode ctlFloMinPumHea(
    have_heaWat=true,
    have_chiWat=false,
    have_valInlIso=false,
    have_valOutIso=false,
    VHeaWat_flow_nominal={0.02,0.05},
    VHeaWat_flow_min={0.01,0.03},
    nEqu=2,
    nEnaChiWat=2,
    nEnaHeaWat=2)
    "Valve controller enabled by primary pump status – Heating-only application"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));
  Buildings.Templates.Plants.Controls.MinimumFlow.ControllerDualMode ctlFloMinValHea(
    have_heaWat=true,
    have_chiWat=false,
    have_valInlIso=true,
    have_valOutIso=false,
    VHeaWat_flow_nominal={0.02,0.05},
    VHeaWat_flow_min={0.01,0.03},
    nEqu=2,
    nEnaChiWat=2,
    nEnaHeaWat=2)
    "Valve controller enabled by isolation valve command – Heating-only application"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Reals.Add VPriHea_flow1 "Primary flow rate"
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Add VPriHea_flow "Primary flow rate"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Templates.Plants.Controls.MinimumFlow.ControllerDualMode ctlFloMinPumHeaCoo(
    have_heaWat=true,
    have_chiWat=true,
    have_pumChiWatPri=false,
    have_valInlIso=false,
    have_valOutIso=false,
    VHeaWat_flow_nominal={0.02,0.05},
    VHeaWat_flow_min={0.01,0.03},
    VChiWat_flow_nominal={0.02,0.05},
    VChiWat_flow_min={0.01,0.03},
    nEqu=2,
    nEnaChiWat=2,
    nEnaHeaWat=2)
    "Valve controller enabled by primary pump status – Heating and cooling application"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Templates.Plants.Controls.MinimumFlow.ControllerDualMode ctlFloMinValHeaCoo(
    have_heaWat=true,
    have_chiWat=true,
    have_pumChiWatPri=false,
    have_valInlIso=true,
    have_valOutIso=false,
    VHeaWat_flow_nominal={0.02,0.05},
    VHeaWat_flow_min={0.01,0.03},
    VChiWat_flow_nominal={0.02,0.05},
    VChiWat_flow_min={0.01,0.03},
    nEqu=2,
    nEnaChiWat=2,
    nEnaHeaWat=2)
    "Valve controller enabled by isolation valve command – Heating and cooling application"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));
  Buildings.Controls.OBC.CDL.Reals.Add VPriHeaCoo_flow1 "Primary flow rate"
    annotation (Placement(transformation(extent={{50,-70},{70,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Add VPriHeaCoo_flow "Primary flow rate"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable u1HeaEqu(
    table=[0,0,0; 1.5,1,0; 2.5,0,1],
    timeScale=200,
    period=900)
    "Source signal for equipment heating/cooling mode command or pump status"
    annotation (Placement(transformation(extent={{190,-30},{170,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And u1ValChiWat[2]
    "Source signal for CHW isolation valves"
    annotation (Placement(transformation(extent={{150,-10},{130,10}})));
  Buildings.Controls.OBC.CDL.Logical.And u1ValHeaWat[2]
    "Source signal for HW isolation valves"
    annotation (Placement(transformation(extent={{150,-50},{130,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Not u1CooEqu[2]
    "True if equipment is commanded in cooling mode"
    annotation (Placement(transformation(extent={{190,10},{170,30}})));
equation
  connect(u1EquValPum.y[1:2], ctlFloMinValCoo.u1Equ[1:2]) annotation (Line(
        points={{-168,60},{-110,60},{-110,28.75},{-92,28.75}}, color={255,0,255}));
  connect(u1EquValPum.y[1:2], ctlFloMinPumCoo.u1Equ[1:2]) annotation (Line(
        points={{-168,60},{-110,60},{-110,-51.25},{-92,-51.25}}, color={255,0,255}));
  connect(dVPri_flow.y, VPriCoo_flow1.u2) annotation (Line(points={{-168,-20},{
          -150,-20},{-150,-66},{-142,-66}},
                                     color={0,0,127}));
  connect(dVPri_flow.y, VPriCoo_flow.u2) annotation (Line(points={{-168,-20},{
          -150,-20},{-150,-6},{-142,-6}},
                                   color={0,0,127}));
  connect(ctlFloMinPumCoo.VChiWatPriSet_flow, VPriCoo_flow1.u1) annotation (
      Line(points={{-68,-55},{-64,-55},{-64,-40},{-146,-40},{-146,-54},{-142,
          -54}},
        color={0,0,127}));
  connect(ctlFloMinValCoo.VChiWatPriSet_flow, VPriCoo_flow.u1) annotation (Line(
        points={{-68,25},{-66,25},{-66,40},{-150,40},{-150,6},{-142,6}},
        color={0,0,127}));
  connect(VPriCoo_flow.y, ctlFloMinValCoo.VChiWatPri_flow) annotation (Line(
        points={{-118,0},{-100,0},{-100,13.3333},{-92,13.3333}},   color={0,0,127}));
  connect(VPriCoo_flow1.y, ctlFloMinPumCoo.VChiWatPri_flow) annotation (Line(
        points={{-118,-60},{-100,-60},{-100,-66.6667},{-92,-66.6667}}, color={0,
          0,127}));
  connect(u1EquValPum.y[1:2], ctlFloMinValCoo.u1ValChiWatInlIso[1:2])
    annotation (Line(points={{-168,60},{-110,60},{-110,22.0833},{-92,22.0833}},
        color={255,0,255}));
  connect(u1EquValPum.y[1:2], ctlFloMinPumCoo.u1PumChiWatPri_actual[1:2])
    annotation (Line(points={{-168,60},{-110,60},{-110,-62.9167},{-92,-62.9167}},
        color={255,0,255}));
  connect(u1EquValPum.y[1:2], ctlFloMinValHea.u1Equ[1:2]) annotation (Line(
        points={{-168,60},{-20,60},{-20,28.75},{-2,28.75}}, color={255,0,255}));
  connect(u1EquValPum.y[1:2], ctlFloMinPumHea.u1Equ[1:2]) annotation (Line(
        points={{-168,60},{-20,60},{-20,-51.25},{-2,-51.25}}, color={255,0,255}));
  connect(dVPri_flow.y, VPriHea_flow.u2) annotation (Line(points={{-168,-20},{
          -60,-20},{-60,-6},{-52,-6}},
                                 color={0,0,127}));
  connect(dVPri_flow.y, VPriHea_flow1.u2) annotation (Line(points={{-168,-20},{
          -60,-20},{-60,-66},{-52,-66}},
                                   color={0,0,127}));
  connect(ctlFloMinPumHea.VHeaWatPriSet_flow, VPriHea_flow1.u1) annotation (
      Line(points={{22,-51.6667},{24,-51.6667},{24,-40},{-56,-40},{-56,-54},{
          -52,-54}},
                 color={0,0,127}));
  connect(ctlFloMinValHea.VHeaWatPriSet_flow, VPriHea_flow.u1) annotation (Line(
        points={{22,28.3333},{24,28.3333},{24,40},{-60,40},{-60,6},{-52,6}},
        color={0,0,127}));
  connect(VPriHea_flow1.y, ctlFloMinPumHea.VHeaWatPri_flow) annotation (Line(
        points={{-28,-60},{-10,-60},{-10,-65},{-2,-65}}, color={0,0,127}));
  connect(VPriHea_flow.y, ctlFloMinValHea.VHeaWatPri_flow) annotation (Line(
        points={{-28,0},{-10,0},{-10,15},{-2,15}},   color={0,0,127}));
  connect(u1EquValPum.y[1:2], ctlFloMinValHea.u1ValHeaWatInlIso[1:2])
    annotation (Line(points={{-168,60},{-20,60},{-20,25.4167},{-2,25.4167}},
        color={255,0,255}));
  connect(u1EquValPum.y[1:2], ctlFloMinPumHea.u1PumHeaWatPri_actual[1:2])
    annotation (Line(points={{-168,60},{-20,60},{-20,-61.25},{-2,-61.25}},
        color={255,0,255}));
  connect(u1EquValPum.y[1:2], ctlFloMinPumHeaCoo.u1Equ[1:2]) annotation (Line(
        points={{-168,60},{80,60},{80,-51.25},{98,-51.25}}, color={255,0,255}));
  connect(ctlFloMinPumHeaCoo.VHeaWatPriSet_flow, VPriHeaCoo_flow1.u1)
    annotation (Line(points={{122,-51.6667},{124,-51.6667},{124,-44},{44,-44},{
          44,-54},{48,-54}},
                          color={0,0,127}));
  connect(ctlFloMinValHeaCoo.VHeaWatPriSet_flow, VPriHeaCoo_flow.u1)
    annotation (Line(points={{122,28.3333},{124,28.3333},{124,40},{40,40},{40,6},
          {48,6}},  color={0,0,127}));
  connect(VPriHeaCoo_flow1.y, ctlFloMinPumHeaCoo.VHeaWatPri_flow) annotation (
      Line(points={{72,-60},{90,-60},{90,-65},{98,-65}}, color={0,0,127}));
  connect(VPriHeaCoo_flow.y, ctlFloMinValHeaCoo.VHeaWatPri_flow) annotation (
      Line(points={{72,0},{90,0},{90,15},{98,15}},   color={0,0,127}));
  connect(u1EquValPum.y[1:2], ctlFloMinValHeaCoo.u1Equ) annotation (Line(points={{-168,60},
          {80,60},{80,28.3333},{98,28.3333}},           color={255,0,255}));
  connect(u1EquValPum.y[1:2], ctlFloMinPumHeaCoo.u1PumHeaWatPri_actual[1:2])
    annotation (Line(points={{-168,60},{80,60},{80,-61.25},{98,-61.25}}, color={
          255,0,255}));
  connect(dVPri_flow.y, VPriHeaCoo_flow.u2) annotation (Line(points={{-168,-20},
          {40,-20},{40,-6},{48,-6}},
                               color={0,0,127}));
  connect(dVPri_flow.y, VPriHeaCoo_flow1.u2) annotation (Line(points={{-168,-20},
          {40,-20},{40,-66},{48,-66}},
                                    color={0,0,127}));
  connect(VPriHeaCoo_flow.y, ctlFloMinValHeaCoo.VChiWatPri_flow) annotation (
      Line(points={{72,0},{90,0},{90,13.3333},{98,13.3333}},   color={0,0,127}));
  connect(VPriHeaCoo_flow1.y, ctlFloMinPumHeaCoo.VChiWatPri_flow) annotation (
      Line(points={{72,-60},{90,-60},{90,-66.6667},{98,-66.6667}}, color={0,0,127}));
  connect(u1HeaEqu.y[1:2], ctlFloMinValHeaCoo.u1HeaEqu[1:2]) annotation (Line(
        points={{168,-20},{90,-20},{90,27.0833},{98,27.0833}},
                                                            color={255,0,255}));
  connect(u1HeaEqu.y[1:2], ctlFloMinPumHeaCoo.u1HeaEqu[1:2]) annotation (Line(
        points={{168,-20},{90,-20},{90,-52.9167},{98,-52.9167}},
                                                              color={255,0,255}));
  connect(u1EquValPum.y[1:2], u1ValChiWat[1:2].u1) annotation (Line(points={{-168,60},
          {160,60},{160,0},{152,0}},            color={255,0,255}));
  connect(u1EquValPum.y[1:2], u1ValHeaWat[1:2].u1) annotation (Line(points={{-168,60},
          {160,60},{160,-40},{152,-40}},          color={255,0,255}));
  connect(u1HeaEqu.y[1:2], u1ValHeaWat[1:2].u2) annotation (Line(points={{168,-20},
          {164,-20},{164,-48},{152,-48}},
                                        color={255,0,255}));
  connect(u1HeaEqu.y[1:2], u1CooEqu.u) annotation (Line(points={{168,-20},{164,
          -20},{164,0},{196,0},{196,20},{192,20}},
                                                color={255,0,255}));
  connect(u1CooEqu.y, u1ValChiWat.u2) annotation (Line(points={{168,20},{156,20},
          {156,-8},{152,-8}}, color={255,0,255}));
  connect(u1ValChiWat.y, ctlFloMinValHeaCoo.u1ValChiWatInlIso) annotation (Line(
        points={{128,0},{92,0},{92,21.6667},{98,21.6667}},   color={255,0,255}));
  connect(u1ValHeaWat.y, ctlFloMinValHeaCoo.u1ValHeaWatInlIso) annotation (Line(
        points={{128,-40},{94,-40},{94,25},{98,25}}, color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file=
        "modelica://Buildings/Resources/Scripts/Dymola/Templates/Plants/Controls/MinimumFlow/Validation/ControllerDualMode.mos"
        "Simulate and plot"),
    experiment(
      StopTime=1000.0,
      Tolerance=1e-06),
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
    Documentation(
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Templates.Plants.Controls.MinimumFlow.ControllerDualMode\">
Buildings.Templates.Plants.Controls.MinimumFlow.ControllerDualMode</a>
for cooling-only (components <code>*Coo</code>), heating-only (components <code>*Hea</code>) 
and heating and cooling applications (components <code>*HeaCoo</code>), 
and for two plant configurations: one where the bypass valve controller is enabled
with the isolation valve command (components <code>ctlFloMinVal*</code>), and 
another where it is enabled with the primary pump status (components <code>ctlFloMinPum*</code>).
</p>
</html>", revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-200,-100},{200,100}})));
end ControllerDualMode;
