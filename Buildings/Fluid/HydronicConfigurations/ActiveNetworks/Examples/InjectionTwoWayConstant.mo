within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model InjectionTwoWayConstant
  "Model illustrating the operation of an inversion circuit with two-way valve and constant secondary"
  extends
    Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.PartialInjectionTwoWay(
    del2(nPorts=3),
    dp2_nominal=dpPip_nominal + loa1.dpTer_nominal + loa1.dpValve_nominal,
    con(typCtl=Buildings.Fluid.HydronicConfigurations.Types.ControlVariable.ReturnTemperature));

  parameter Boolean have_resT2 = false
    "Set to true for consumer circuit temperature reset, false for constant set point"
    annotation(Dialog(group="Configuration"), Evaluate=true);

  parameter Modelica.Units.SI.Temperature T2Set_nominal=
    if con.typCtl==Buildings.Fluid.HydronicConfigurations.Types.ControlVariable.SupplyTemperature
      then TLiqEnt_nominal else TLiqLvg_nominal
    "Consumer circuit design temperature set point"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TAirEnt_nominal=293.15
    "Air entering temperature at design conditions"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFraction phiAirEnt_nominal=0.5
    "Air entering relative humidity at design conditions"
    annotation (Dialog(group="Nominal condition"));

  replaceable BaseClasses.LoadThreeWayValveControl loa
    constrainedby BaseClasses.PartialLoadValveControl(
      redeclare final package MediumLiq = MediumLiq,
      final energyDynamics=energyDynamics,
      final mLiq_flow_nominal=mTer_flow_nominal,
      final TAirEnt_nominal=TAirEnt_nominal,
      final phiAirEnt_nominal=phiAirEnt_nominal,
      final TLiqEnt_nominal=TLiqEnt_nominal,
      final TLiqLvg_nominal=TLiqLvg_nominal,
      dpBal1_nominal=dp2_nominal-loa.dpTer_nominal-loa.dpValve_nominal)
    "Load"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  replaceable BaseClasses.LoadThreeWayValveControl loa1
    constrainedby BaseClasses.PartialLoadValveControl(
      redeclare final package MediumLiq = MediumLiq,
      final energyDynamics=energyDynamics,
      final mLiq_flow_nominal=mTer_flow_nominal,
      final TAirEnt_nominal=TAirEnt_nominal,
      final phiAirEnt_nominal=phiAirEnt_nominal,
      final TLiqEnt_nominal=TLiqEnt_nominal,
      final TLiqLvg_nominal=TLiqLvg_nominal,
      dpBal1_nominal=0)
    "Load"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));
  FixedResistances.PressureDrop res2(
    redeclare final package Medium = MediumLiq,
    m_flow_nominal=mTer_flow_nominal,
    dp_nominal=dpPip_nominal)
    "Pipe pressure drop"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T2SetLim1(
    final k=T2Set_nominal,
    y(final unit="K", displayUnit="degC"))
    "Consumer circuit temperature design set point " annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,50})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable fraLoa(table=[0,0,0; 6,
        0,0; 6.1,1,1; 8,1,1; 9,1,0; 14,0.5,0; 14.5,0,0; 16,0,0; 17,0,1; 21,0,1;
        22,0,0; 24,0,0], timeScale=3600) "Load modulating signal"
    annotation (Placement(transformation(extent={{-140,150},{-120,170}})));
  Controls.PIDWithOperatingMode resT2(
    k=1,
    Ti=60,
    reverseActing=false,
    y_reset=1) "PI controller for consumer circuit temperature reset"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Line T2SetVar(
    y(final unit="K", displayUnit="degC")) if have_resT2
    "Consumer circuit temperature set point (reset)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,90})));
  Buildings.Controls.OBC.CDL.Continuous.Max yValMax(
    y(final unit="1"))
    "Maximum valve opening"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,130})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yValSet(
    k=0.9,
    y(final unit="1"))
    "Valve opening set point"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,130})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(
    final k=1,
    y(final unit="1"))
    "One"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-60,130})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0,
    y(final unit="1"))
    "Zero"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,130})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T2SetLim0(
    k=T2Set_nominal + (if con.typFun == Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Heating
         then -10 else +5),
    y(final unit="K", displayUnit="degC"))
    "Consumer circuit temperature limiting set point " annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,90})));
  Modelica.Blocks.Routing.RealPassThrough T2SetCst(
   y(final unit="K", displayUnit="degC")) if not have_resT2
    "Consumer circuit temperature set point (constant)"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Blocks.Routing.RealPassThrough T2Set(
    y(final unit="K", displayUnit="degC"))
    "Consumer circuit temperature set point"
    annotation (Placement(transformation(extent={{-28,40},{-8,60}})));
equation
  connect(fraLoa.y[1], loa.u) annotation (Line(points={{-118,160},{20,160},{20,106},
          {38,106}}, color={0,0,127}));
  connect(fraLoa.y[2], loa1.u) annotation (Line(points={{-118,160},{80,160},{80,
          106},{98,106}},
                     color={0,0,127}));
  connect(con.port_b2, loa.port_a) annotation (Line(points={{24,0},{24,80},{40,80},
          {40,100}}, color={0,127,255}));
  connect(del2.ports[2], loa1.port_b)
    annotation (Line(points={{60,0},{120,0},{120,100}}, color={0,127,255}));
  connect(loa.port_b, del2.ports[3])
    annotation (Line(points={{60,100},{60,0},{60,0}}, color={0,127,255}));
  connect(con.port_b2, res2.port_a)
    annotation (Line(points={{24,0},{24,60},{70,60}},  color={0,127,255}));
  connect(res2.port_b, loa1.port_a)
    annotation (Line(points={{90,60},{100,60},{100,100}}, color={0,127,255}));
  connect(resT2.y, T2SetVar.u)
    annotation (Line(points={{-78,90},{-62,90}}, color={0,0,127}));
  connect(loa.yVal_actual, yValMax.u2) annotation (Line(points={{62,104},{70,104},
          {70,124},{62,124}}, color={0,0,127}));
  connect(loa1.yVal_actual, yValMax.u1) annotation (Line(points={{122,104},{130,
          104},{130,136},{62,136}}, color={0,0,127}));
  connect(yValMax.y, resT2.u_m) annotation (Line(points={{38,130},{10,130},{10,76},
          {-90,76},{-90,78}}, color={0,0,127}));
  connect(mod1.y[1], resT2.mod)
    annotation (Line(points={{-118,-20},{-96,-20},{-96,78}},
                                                          color={255,127,0}));
  connect(yValSet.y, resT2.u_s)
    annotation (Line(points={{-118,130},{-110,130},{-110,90},{-102,90}},
                                                   color={0,0,127}));
  connect(zer.y, T2SetVar.x1)
    annotation (Line(points={{-78,130},{-78,98},{-62,98}}, color={0,0,127}));
  connect(one.y, T2SetVar.x2) annotation (Line(points={{-48,130},{-48,110},{-66,
          110},{-66,86},{-62,86}}, color={0,0,127}));
  connect(T2SetLim1.y, T2SetVar.f2) annotation (Line(points={{-118,50},{-66,50},
          {-66,82},{-62,82}}, color={0,0,127}));
  connect(T2SetLim0.y, T2SetVar.f1) annotation (Line(points={{-118,90},{-114,90},
          {-114,70},{-70,70},{-70,94},{-62,94}}, color={0,0,127}));
  connect(T2SetLim1.y, T2SetCst.u)
    annotation (Line(points={{-118,50},{-62,50}}, color={0,0,127}));
  connect(T2SetCst.y, T2Set.u)
    annotation (Line(points={{-39,50},{-30,50}}, color={0,0,127}));
  connect(T2SetVar.y, T2Set.u) annotation (Line(points={{-38,90},{-36,90},{-36,
          50},{-30,50}},
                     color={0,0,127}));
  connect(T2Set.y, con.set) annotation (Line(points={{-7,50},{0,50},{0,-14},{18,
          -14}}, color={0,0,127}));
   annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/InjectionTwoWayConstant.mos"
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
The pump dissipated heat is not added to the fluid.

</li>
</ul>

<p>
Without temperature reset (<code>have_resT2 = false</code>), 
the primary flow varies marginally with the load (see plot #8).
The flow reduction is enhanced when using a reset based on the maximum
valve demand (note the setting of the controller <code>resT2</code> ensuring
a reset at design value when the control loop is enabled). 
The flow reduction is further enhanced when using a control based on the 
return temperature
(<code>con(typCtl=Types.ControlVariable.ReturnTemperature)</code>).
However, there is additional constraints on the sizing of the terminal unit
that should account for the load diversity.
When tracking the return temperature of a constant flow consumer circuit, 
the supply temperature will vary with the aggregated load. 
In our example, the actual value of the secondary supply temperature 
is lower than its design value at partial load, which yields unmet loads
(see plot #4). The terminal units should be sized accordingly,
based on the lowest possible &Delta;T when one terminal unit may still be at peak load.
Additional caveats speak against the use of return temperature control 
with this hydronic configuration in the case of variable flow consumer circuits,
see 
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.InjectionTwoWayVariableReturn\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.InjectionTwoWayVariableReturn</a>.
</p>
</html>"));
end InjectionTwoWayConstant;
