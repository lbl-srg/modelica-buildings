within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model InjectionTwoWayVariable
  "Model illustrating the operation of an inversion circuit with two-way valve and variable secondary"
  extends Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.PartialInjectionTwoWay(
    del2(nPorts=4),
    dp2_nominal=dpPip_nominal + loa1.dpTer_nominal + loa1.dpValve_nominal,
    con(typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleVariable));

  Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.LoadTwoWayValveControl
    loa(
    redeclare final package MediumLiq = MediumLiq,
    k=0.1,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final TAirEnt_nominal=TAirEnt_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal)
    "Load"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.LoadTwoWayValveControl
    loa1(
    redeclare final package MediumLiq = MediumLiq,
    k=0.1,
    final energyDynamics=energyDynamics,
    final mLiq_flow_nominal=mTer_flow_nominal,
    final TAirEnt_nominal=TAirEnt_nominal,
    final TLiqEnt_nominal=TLiqEnt_nominal,
    final TLiqLvg_nominal=TLiqLvg_nominal)
    "Load"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));
  FixedResistances.PressureDrop res2(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mTer_flow_nominal,
    final dp_nominal=dpPip_nominal)
    "Pipe pressure drop"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant set(
    k=TLiqEnt_nominal,
    y(final unit="K", displayUnit="degC"))
    "Compute supply temperature set point"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,100})));
  Sensors.RelativePressure dp2(redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  FixedResistances.PressureDrop resEnd2(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=0.1*m2_flow_nominal,
    final dp_nominal=dp2SetVal.k) "Pipe pressure drop" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={140,40})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dp2SetVal(
    final k=loa1.dpTer_nominal + loa1.dpValve_nominal)
    "Pressure differential set point"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Controls.PIDWithOperatingMode ctl2(
    k=1,
    Ti=60,
    r=MediumLiq.p_default,
    y_reset=1)
    "Pump controller"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable fraLoa(table=[0,0,0; 6,
        0,0; 6.1,1,1; 8,1,1; 9,1,0; 14,0.5,0; 14.5,0,0; 16,0,0; 17,0,1; 21,0,1;
        22,0,0; 24,0,0], timeScale=3600) "Load modulating signal"
    annotation (Placement(transformation(extent={{-120,130},{-100,150}})));
equation
  connect(dp2SetVal.y, ctl2.u_s)
    annotation (Line(points={{-98,60},{-72,60}},   color={0,0,127}));
  connect(dp2.p_rel, ctl2.u_m) annotation (Line(points={{110,61},{110,40},{-60,40},
          {-60,48}},  color={0,0,127}));
  connect(set.y, con.set) annotation (Line(points={{-98,100},{0,100},{0,6},{18,6}},
        color={0,0,127}));
  connect(con.port_b2, loa.port_a) annotation (Line(points={{24,20},{24,60},{40,
          60},{40,100}}, color={0,127,255}));
  connect(loa.port_b, del2.ports[2])
    annotation (Line(points={{60,100},{60,20},{60,20}}, color={0,127,255}));
  connect(resEnd2.port_b, del2.ports[3])
    annotation (Line(points={{140,30},{140,20},{60,20}}, color={0,127,255}));
  connect(mod1.y[1], ctl2.mod)
    annotation (Line(points={{-98,20},{-66,20},{-66,48}}, color={255,127,0}));
  connect(ctl2.y, con.yPum) annotation (Line(points={{-48,60},{4,60},{4,14},{18,
          14}}, color={0,0,127}));
  connect(fraLoa.y[1], loa.u) annotation (Line(points={{-98,140},{20,140},{20,106},
          {38,106}}, color={0,0,127}));
  connect(fraLoa.y[2], loa1.u) annotation (Line(points={{-98,140},{80,140},{80,106},
          {98,106}}, color={0,0,127}));
  connect(con.port_b2, res2.port_a)
    annotation (Line(points={{24,20},{24,60},{70,60}}, color={0,127,255}));
  connect(res2.port_b, loa1.port_a)
    annotation (Line(points={{90,60},{100,60},{100,100}}, color={0,127,255}));
  connect(dp2.port_a, loa1.port_a) annotation (Line(points={{100,70},{100,100},{
          100,100}}, color={0,127,255}));
  connect(loa1.port_b, del2.ports[4])
    annotation (Line(points={{120,100},{120,20},{60,20}}, color={0,127,255}));
  connect(res2.port_b, resEnd2.port_a)
    annotation (Line(points={{90,60},{140,60},{140,50}}, color={0,127,255}));
  connect(loa1.port_b, dp2.port_b)
    annotation (Line(points={{120,100},{120,70}}, color={0,127,255}));
   annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/InjectionTwoWayVariable.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates the use of an injection circuit with a two-way valve
that serves as the interface between a variable flow primary circuit at constant
supply temperature and a constant flow secondary circuit at variable supply
temperature.
Two identical terminal units circuits are served by the secondary circuit.
Each terminal unit has its own hourly load profile.
The main assumptions are enumerated below.
</p>
<ul>
<li>
The design conditions are defined without
considering any load diversity.
</li>
<li>
Each circuit is balanced at design conditions.
</li>
<li>
No heat is added by the pump to the medium:...
</li>
<li>
Setting of PI for dp set point tracking: reset at max is important,
so is the scaling.
</li>
</ul>

</html>"),
    Diagram(coordinateSystem(extent={{-160,-160},{160,160}})));
end InjectionTwoWayVariable;
