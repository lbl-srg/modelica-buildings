within Buildings.Experimental.DHC.Plants.Cooling.Examples;
model StoragePlantDualSource
  "Idealised district system model with two sources and three users"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water "Medium model for CHW";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate, slightly larger than needed by one user load";
  parameter Modelica.Units.SI.MassFlowRate mTan_flow_nominal=1
    "Nominal mass flow rate for CHW tank branch"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.MassFlowRate mChi_flow_nominal=1
    "Nominal mass flow rate for CHW chiller branch"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    final displayUnit="Pa")=
     300000
    "Nominal pressure difference";
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal(
    final displayUnit="degC")=
     12+273.15
    "Nominal temperature of CHW return";
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal(
    final displayUnit="degC")=
     7+273.15
    "Nominal temperature of CHW supply";

// First plant: chiller only
  Buildings.Fluid.Sources.PropertySource_T chi1(
    redeclare final package Medium = Medium,
    final use_T_in=true) "Chiller 1 represented by an ideal temperature source"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-128,70})));
  Modelica.Blocks.Sources.Constant TSet1(k=T_CHWS_nominal)
    "Constant CHW leaving temperature"
    annotation (Placement(transformation(extent={{-178,56},{-158,76}})));
  Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y pumSup1(
    redeclare final package Medium = Medium,
    final addPowerToMedium=false,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal) "CHW supply pump for chi1"
    annotation (Placement(transformation(extent={{-110,82},{-90,102}})));
  Buildings.Controls.Continuous.LimPID conPI_pumChi1(
    final controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=0.2,
    Ti=10,
    final reverseActing=true) "PI controller" annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={-130,150})));
  Buildings.Experimental.DHC.Plants.Cooling.Controls.SelectMin selMin_dp(nin=3)
    "Min of pressure heads with the signal from storage plant optionally used"
    annotation (Placement(transformation(extent={{-180,100},{-160,120}})));

// Second plant: chiller and tank
  Buildings.Experimental.DHC.Plants.Cooling.StoragePlant stoPla(redeclare
      final package Medium = Medium,
    mTan_flow_nominal=mTan_flow_nominal,
    mChi_flow_nominal=mChi_flow_nominal,
    dpPum_nominal=dp_nominal,
    dpVal_nominal=0.5*dp_nominal,
    T_CHWS_nominal=T_CHWS_nominal,
    T_CHWR_nominal=T_CHWR_nominal)                  "Storage plant" annotation (
     Placement(transformation(rotation=0, extent={{-98,-100},{-78,-80}})));
  Buildings.Fluid.Sources.Boundary_pT bou(
    p(final displayUnit="Pa") = 101325 + dp_nominal,
    redeclare final package Medium = Medium,
    nPorts=1) "Pressure boundary" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-88,-130})));
  Buildings.Fluid.Sources.PropertySource_T chi2(
    redeclare final package Medium = Medium,
    final use_T_in=true) "Chiller represented by an ideal temperature source"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-128,-90})));
  Modelica.Blocks.Sources.Constant TSet2(final k=T_CHWS_nominal)
    "Constant CHW leaving temperature"
    annotation (Placement(transformation(extent={{-180,-104},{-160,-84}})));
  Modelica.Blocks.Math.Gain gaiStoPla(final k=1/stoPla.dpVal_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-222,110})));

// Users
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.IdealUser ideUse1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=0.6*m_flow_nominal,
    dp_nominal=0.2*dp_nominal,
    final T_CHWR_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={130,150})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.IdealUser ideUse2(
    redeclare final package Medium = Medium,
    final m_flow_nominal=0.65*m_flow_nominal,
    dp_nominal=0.2*dp_nominal,
    final T_CHWR_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={130,-10})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.IdealUser ideUse3(
    redeclare final package Medium = Medium,
    final m_flow_nominal=0.65*m_flow_nominal,
    dp_nominal=0.2*dp_nominal,
    final T_CHWR_nominal=T_CHWR_nominal) "Ideal user" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={130,-170})));
  Modelica.Blocks.Sources.Constant set_dpUse(final k=1)
    "Normalized consumer differential pressure setpoint"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-170,150})));
  Modelica.Blocks.Sources.TimeTable mLoa1_flow(table=[0,0; 1800,0; 1800,ideUse1.m_flow_nominal;
        7000,ideUse1.m_flow_nominal; 7000,0; 9000,0])
    "Cooling load of user 1 represented by flow rate"
    annotation (Placement(transformation(extent={{80,180},{100,200}})));
  Modelica.Blocks.Sources.TimeTable mLoa2_flow(table=[0,0; 3500,0; 3500,ideUse2.m_flow_nominal;
        6500,ideUse2.m_flow_nominal; 6500,0; 9000,0])
    "Cooling load of user 2 represented by flow rate"
    annotation (Placement(transformation(extent={{80,20},{100,40}})));
  Modelica.Blocks.Sources.TimeTable mLoa3_flow(table=[0,0; 4500,0; 4500,ideUse3.m_flow_nominal;
        6000,ideUse3.m_flow_nominal; 6000,0; 9000,0])
    "Cooling load of user 3 represented by flow rate"
    annotation (Placement(transformation(extent={{80,-140},{100,-120}})));
  Modelica.Blocks.Math.Gain gaiUse1(final k=1/ideUse1.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={202,154})));
  Modelica.Blocks.Math.Gain gaiUse2(final k=1/ideUse2.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={202,-6})));
  Modelica.Blocks.Math.Gain gaiUse3(final k=1/ideUse3.dp_nominal)
    "Gain to normalise dp measurement" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={202,-166})));

// District pipe network
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.ParallelJunctions
    parJunPla1(
    redeclare final package Medium = Medium,
    T1_start=T_CHWS_nominal,
    T2_start=T_CHWR_nominal,
    m_flow_nominal = 2*m_flow_nominal)
    "Parallel junctions for breaking algebraic loops" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={10,70})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.ParallelJunctions
    parJunUse2(
    redeclare final package Medium = Medium,
    T1_start=T_CHWR_nominal,
    T2_start=T_CHWS_nominal,
    m_flow_nominal = 2*m_flow_nominal)
    "Parallel junctions for breaking algebraic loops" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=90,
        origin={10,-10})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.ParallelJunctions
    parJunPla2(
    redeclare final package Medium = Medium,
    T1_start=T_CHWS_nominal,
    T2_start=T_CHWR_nominal,
    m_flow_nominal = 2*m_flow_nominal)
    "Parallel junctions for breaking algebraic loops" annotation (Placement(
        transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={10,-90})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.ParallelPipes
    parPipS1U1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.15*dp_nominal) "Parallel pipes" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={10,110})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.ParallelPipes
    parPipS1U2(
    redeclare package Medium = Medium,
    m_flow_nominal=2*m_flow_nominal,
    dp_nominal=0.15*dp_nominal) "Parallel pipes" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={10,30})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.ParallelPipes
    parPipS2U2(
    redeclare package Medium = Medium,
    m_flow_nominal=2*m_flow_nominal,
    dp_nominal=0.15*dp_nominal) "Parallel pipes" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={10,-50})));
  Buildings.Experimental.DHC.Plants.Cooling.BaseClasses.ParallelPipes
    parPipS2U3(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=0.15*dp_nominal) "Parallel pipes" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={10,-130})));

  Modelica.Blocks.Routing.Multiplex muxDp(n=3) "Multiplexer block for routing"
    annotation (Placement(transformation(extent={{238,140},{258,160}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMax mulMax_yVal_actual(nin=3)
    "Position of the most open user control valve"
    annotation (Placement(transformation(extent={{200,-220},{220,-200}})));
  Modelica.Blocks.Sources.IntegerTable com(table=[0,2; 200,1; 3000,2; 4000,3;
        6000,2; 7500,1])
    "Command: 1 = charge tank, 2 = no command, 3 = discharge from tank"
    annotation (Placement(transformation(extent={{-140,-30},{-120,-10}})));
  Modelica.Blocks.Sources.BooleanTable chiEnaSta(table={0,6000}, startValue=
        false) "Chiller enable status, true if chiller is enabled"
    annotation (Placement(transformation(extent={{-138,-60},{-118,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys_yVal_actual(uLow=0.05,
      uHigh=0.5) "Hysteresis for user control valve position"
    annotation (Placement(transformation(extent={{240,-220},{260,-200}})));

equation
  connect(set_dpUse.y,conPI_pumChi1.u_s)
    annotation (Line(points={{-159,150},{-142,150}},
                                                   color={0,0,127}));
  connect(mLoa1_flow.y, ideUse1.mPre_flow) annotation (Line(points={{101,190},{110,
          190},{110,158},{119,158}},
                                   color={0,0,127}));
  connect(mLoa2_flow.y, ideUse2.mPre_flow) annotation (Line(points={{101,30},{110,
          30},{110,-2},{119,-2}},
                                color={0,0,127}));
  connect(mLoa3_flow.y, ideUse3.mPre_flow) annotation (Line(points={{101,-130},{
          110,-130},{110,-162},{119,-162}},
                                         color={0,0,127}));
  connect(ideUse1.dp, gaiUse1.u) annotation (Line(points={{141,154},{190,154}},
                               color={0,0,127}));
  connect(ideUse2.dp, gaiUse2.u) annotation (Line(points={{141,-6},{190,-6}},
                               color={0,0,127}));
  connect(ideUse3.dp, gaiUse3.u) annotation (Line(points={{141,-166},{190,-166}},
                                  color={0,0,127}));
  connect(parJunUse2.port_c2, ideUse2.port_a) annotation (Line(points={{20,-4},{
          120,-4}},                     color={0,127,255}));
  connect(ideUse2.port_b,parJunUse2.port_c1)  annotation (Line(points={{120,-16},
          {20,-16}},                            color={0,127,255}));
  connect(parPipS1U1.port_b2, parJunPla1.port_a1)
    annotation (Line(points={{4,100},{4,80}},   color={0,127,255}));
  connect(parJunPla1.port_b2, parPipS1U1.port_a1)
    annotation (Line(points={{16,80},{16,100}}, color={0,127,255}));
  connect(parJunPla1.port_b1, parPipS1U2.port_a2)
    annotation (Line(points={{4,60},{4,40}},   color={0,127,255}));
  connect(parPipS1U2.port_b2, parJunUse2.port_a2)
    annotation (Line(points={{4,20},{4,0}},   color={0,127,255}));
  connect(parJunUse2.port_b1, parPipS1U2.port_a1)
    annotation (Line(points={{16,0},{16,20}}, color={0,127,255}));
  connect(parPipS1U2.port_b1, parJunPla1.port_a2)
    annotation (Line(points={{16,40},{16,60}}, color={0,127,255}));
  connect(parJunUse2.port_b2, parPipS2U2.port_a2)
    annotation (Line(points={{4,-20},{4,-40}},   color={0,127,255}));
  connect(parPipS2U2.port_b1, parJunUse2.port_a1)
    annotation (Line(points={{16,-40},{16,-20}}, color={0,127,255}));
  connect(parPipS2U2.port_a1, parJunPla2.port_b2)
    annotation (Line(points={{16,-60},{16,-80}}, color={0,127,255}));
  connect(parJunPla2.port_a1, parPipS2U2.port_b2)
    annotation (Line(points={{4,-80},{4,-60}},   color={0,127,255}));
  connect(parPipS2U3.port_a2, parJunPla2.port_b1)
    annotation (Line(points={{4,-120},{4,-100}},   color={0,127,255}));
  connect(parJunPla2.port_a2, parPipS2U3.port_b1)
    annotation (Line(points={{16,-100},{16,-120}}, color={0,127,255}));
  connect(gaiUse1.y, muxDp.u[1]) annotation (Line(points={{213,154},{220,154},{
          220,147.667},{238,147.667}},
                                   color={0,0,127}));
  connect(gaiUse2.y, muxDp.u[2]) annotation (Line(points={{213,-6},{220,-6},{220,
          150},{238,150}}, color={0,0,127}));
  connect(gaiUse3.y, muxDp.u[3]) annotation (Line(points={{213,-166},{220,-166},
          {220,152.333},{238,152.333}}, color={0,0,127}));
  connect(ideUse1.yVal_actual, mulMax_yVal_actual.u[1]) annotation (Line(points={{141,158},
          {160,158},{160,-210},{180,-210},{180,-210.667},{198,-210.667}},
        color={0,0,127}));
  connect(ideUse2.yVal_actual, mulMax_yVal_actual.u[2]) annotation (Line(points
        ={{141,-2},{160,-2},{160,-210},{198,-210}}, color={0,0,127}));
  connect(ideUse3.yVal_actual, mulMax_yVal_actual.u[3]) annotation (Line(points={{141,
          -162},{160,-162},{160,-210},{180,-210},{180,-209.333},{198,-209.333}},
        color={0,0,127}));
  connect(com.y, stoPla.com) annotation (Line(points={{-119,-20},{-86,-20},{-86,
          -79}},      color={255,127,0}));
  connect(chiEnaSta.y, stoPla.chiEnaSta) annotation (Line(points={{-117,-50},{-90,
          -50},{-90,-79}},           color={255,0,255}));
  connect(hys_yVal_actual.y, stoPla.hasLoa) annotation (Line(points={{262,-210},
          {262,-228},{-186,-228},{-186,-68},{-94,-68},{-94,-79}},
                                           color={255,0,255}));
  connect(pumSup1.port_b, parJunPla1.port_c1) annotation (Line(points={{-90,92},
          {-80,92},{-80,76},{1.77636e-15,76}},
                                color={0,127,255}));
  connect(conPI_pumChi1.y, pumSup1.y)
    annotation (Line(points={{-119,150},{-100,150},{-100,104}},
                                                             color={0,0,127}));
  connect(conPI_pumChi1.y, stoPla.yPum) annotation (Line(points={{-119,150},{-70,
          150},{-70,-70},{-82,-70},{-82,-79}},
                                     color={0,0,127}));
  connect(pumSup1.port_a, chi1.port_b)
    annotation (Line(points={{-110,92},{-128,92},{-128,80}},
                                                          color={0,127,255}));
  connect(chi1.port_a, parJunPla1.port_c2) annotation (Line(points={{-128,60},{-128,
          54},{-80,54},{-80,64},{-1.77636e-15,64}},
                                        color={0,127,255}));
  connect(TSet1.y, chi1.T_in) annotation (Line(points={{-157,66},{-140,66}},
                     color={0,0,127}));
  connect(TSet2.y, chi2.T_in) annotation (Line(points={{-159,-94},{-140,-94}},
                           color={0,0,127}));
  connect(stoPla.port_b1, parJunPla2.port_c1)
    annotation (Line(points={{-78,-84},{1.77636e-15,-84}},
                                                color={0,127,255}));
  connect(parJunPla2.port_c2, stoPla.port_a2)
    annotation (Line(points={{-1.77636e-15,-96},{-78,-96}},
                                                color={0,127,255}));
  connect(stoPla.port_b2, chi2.port_a) annotation (Line(points={{-98,-96},{-112,
          -96},{-112,-106},{-128,-106},{-128,-100}},
                                                  color={0,127,255}));
  connect(chi2.port_b, stoPla.port_a1) annotation (Line(points={{-128,-80},{-128,
          -74},{-112,-74},{-112,-84},{-98,-84}},
                                               color={0,127,255}));
  connect(bou.ports[1], stoPla.port_a2) annotation (Line(points={{-78,-130},{6,-130},
          {6,-96},{-78,-96}},     color={0,127,255}));
  connect(parPipS1U1.port_a2, ideUse1.port_a)
    annotation (Line(points={{4,120},{4,156},{120,156}},  color={0,127,255}));
  connect(ideUse1.port_b, parPipS1U1.port_b1)
    annotation (Line(points={{120,144},{16,144},{16,120}},color={0,127,255}));
  connect(parPipS2U3.port_b2, ideUse3.port_a) annotation (Line(points={{4,-140},
          {4,-164},{120,-164}}, color={0,127,255}));
  connect(parPipS2U3.port_a1, ideUse3.port_b) annotation (Line(points={{16,-140},
          {16,-176},{120,-176}},color={0,127,255}));
  connect(stoPla.dp, gaiStoPla.u) annotation (Line(points={{-76,-88},{-64,-88},{
          -64,0},{-240,0},{-240,110},{-234,110}},
                             color={0,0,127}));
  connect(selMin_dp.y, conPI_pumChi1.u_m)
    annotation (Line(points={{-159,110},{-130,110},{-130,138}},
                                                             color={0,0,127}));
  connect(gaiStoPla.y, selMin_dp.dpStoPla) annotation (Line(points={{-211,110},{
          -182,110}},                      color={0,0,127}));
  connect(stoPla.isChaRem, selMin_dp.isChaRem) annotation (Line(points={{-77,-92},
          {-58,-92},{-58,46},{-184,46},{-184,104},{-181,104}},
                                                             color={255,0,255}));
  connect(muxDp.y, selMin_dp.dpUse[1:3]) annotation (Line(points={{259,150},{
          270,150},{270,208},{-200,208},{-200,116},{-182,116},{-182,116.667}},
                                                                color={0,0,127}));
  connect(mulMax_yVal_actual.y, hys_yVal_actual.u)
    annotation (Line(points={{222,-210},{238,-210}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-06, StopTime=9000),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Cooling/Examples/StoragePlantDualSource.mos"
        "Simulate and plot"),
        Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}})),                                             Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-300,-240},{300,220}})),
        Documentation(info="<html>
<p>
The modelled system is described in the documentation of
<a href=\"Modelica://Buildings.Experimental.DHC.Plants.Cooling.StoragePlant\">
Buildings.Experimental.DHC.Plants.Cooling.StoragePlant</a>.
</p>
<p>
The source blocks give the system the following operation schedule during
simulation:
</p>
<ul>
<li>
At <code>time = 0</code>, the system is all off.
</li>
<li>
At <code>time = 200</code>, the system is commanded to charge the tank.
The chiller is available and charges the tank locally.
After some time, the charging stops when the tank is cooled.
Note that at this point the tank still has capacity.
</li>
<li>
At <code>time = 1800</code>, load appears at the district network.
The storage plant starts producing CHW to the system.
Currently the tank is not commanded to charge or discharge, therefore it
functions like a common pipe and the CHW is supplied by the chiller.
<ul>
<li>
Because the CHW flow needed at the storage plant is lower than that is
produced by the chiller and the constant-speed pump, the tank continues
to be charged by the overflow.
</li>
<li>
After some time, the tank reaches the overcooled status.
It then overrides the production priority of the chiller to produce CHW
for the network instead. This continues until the tank is no longer
overcooled, at which point the production priority is handed back to
the chiller.
</li>
<li>
The chiller and the tank continue to exchange the production priority
based on whether the tank is overcooled.
</li>
</ul>
</li>
<li>
At <code>time = 3500</code>, the load increases and there is no more overflow
to charge the tank.
</li>
<li>
At <code>time = 4000</code>, the system is commanded to have the tank take
priority over CHW production. After some time, the chill in the tank is
depleted and the tank stops producing. Now the chiller takes over.
</li>
<li>
At <code>time = 7000</code>, there is no longer load in the district system.
The system is back to the all-off state.
</li>
<li>
At <code>time = 7500</code>, the system in once again commanded to charge
the tank, but the chiller in the storage plant is not enabled.
The tank is therefore charged remotely by the district.
This stops once the tank is cooled.
</li>
</ul>
<h4>Implementation</h4>
<p>
The chiller is implemented as an ideal temperature source where the outlet
temperature is always at the prescribed value in
<a href=\"Modelica://Buildings.Fluid.Sources.PropertySource_T\">
Buildings.Fluid.Sources.PropertySource_T</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
July 31, 2023, by Michael Wetter:<br/>
Revised implementation, removed unused parameter.
</li>
<li>
January 11, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end StoragePlantDualSource;
