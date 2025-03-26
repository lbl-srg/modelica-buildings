within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model InjectionTwoWayConstant
  "Model illustrating the operation of an inversion circuit with two-way valve and constant secondary"
  extends
    Fluid.HydronicConfigurations.ActiveNetworks.Examples.BaseClasses.PartialInjectionTwoWay(
    del2(nPorts=3),
    dp2_nominal=dpPip_nominal + loa1.dpTer_nominal + loa1.dpValve_nominal,
    con(typVar=Buildings.Fluid.HydronicConfigurations.Types.ControlVariable.SupplyTemperature));

  parameter Boolean have_resT2 = false
    "Set to true for consumer circuit temperature reset, false for constant set point"
    annotation(Dialog(group="Configuration"), Evaluate=true);

  parameter Modelica.Units.SI.Temperature T2Set_nominal=
    if con.typVar==Buildings.Fluid.HydronicConfigurations.Types.ControlVariable.SupplyTemperature
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
      final typ=typ,
      final energyDynamics=energyDynamics,
      final mLiq_flow_nominal=mTer_flow_nominal,
      final TAirEnt_nominal=TAirEnt_nominal,
      final phiAirEnt_nominal=phiAirEnt_nominal,
      final TLiqEnt_nominal=TLiqEnt_nominal,
      final TLiqLvg_nominal=TLiqLvg_nominal,
      dpBal1_nominal=dp2_nominal-loa.dpTer_nominal-loa.dpValve_nominal)
    "Load"
    annotation (Placement(transformation(extent={{40,100},{60,120}})));
  replaceable BaseClasses.LoadThreeWayValveControl loa1
    constrainedby BaseClasses.PartialLoadValveControl(
      redeclare final package MediumLiq = MediumLiq,
      final typ=typ,
      final energyDynamics=energyDynamics,
      final mLiq_flow_nominal=mTer_flow_nominal,
      final TAirEnt_nominal=TAirEnt_nominal,
      final phiAirEnt_nominal=phiAirEnt_nominal,
      final TLiqEnt_nominal=TLiqEnt_nominal,
      final TLiqLvg_nominal=TLiqLvg_nominal,
      dpBal1_nominal=0)
    "Load"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));
  FixedResistances.PressureDrop res2(
    redeclare final package Medium = MediumLiq,
    m_flow_nominal=con.pum.m_flow_nominal - loa.mLiq_flow_nominal,
    dp_nominal=dpPip_nominal)
    "Pipe pressure drop"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant T2SetLim1(
    final k=T2Set_nominal,
    y(final unit="K", displayUnit="degC"))
    "Consumer circuit temperature design set point " annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,70})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable fraLoa(table=[0,0,0; 6,
        0,0; 6.1,1,1; 8,1,1; 9,1,0; 14,0.5,0; 14.5,0,0; 16,0,0; 17,0,1; 21,0,1;
        22,0,0; 24,0,0], timeScale=3600) "Load modulating signal"
    annotation (Placement(transformation(extent={{-140,170},{-120,190}})));
  Controls.PIDWithOperatingMode resT2(
    k=1,
    Ti=60,
    reverseActing=false,
    y_reset=1) "PI controller for consumer circuit temperature reset"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  Buildings.Controls.OBC.CDL.Reals.Line T2SetVar(
    y(final unit="K", displayUnit="degC")) if have_resT2
    "Consumer circuit temperature set point (reset)"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,110})));
  Buildings.Controls.OBC.CDL.Reals.Max yValMax(
    y(final unit="1"))
    "Maximum valve opening"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={50,150})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yValSet(
    k=0.9,
    y(final unit="1"))
    "Valve opening set point"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,150})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one(
    final k=1,
    y(final unit="1"))
    "One"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,150})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(
    final k=0,
    y(final unit="1"))
    "Zero"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,150})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant T2SetLim0(
    k=T2Set_nominal + (if con.typCtl == Buildings.Fluid.HydronicConfigurations.Types.Control.Heating
    then -10 else +5), y(final unit="K", displayUnit="degC"))
    "Consumer circuit temperature limiting set point " annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,110})));
  Modelica.Blocks.Routing.RealPassThrough T2SetCst(
   y(final unit="K", displayUnit="degC")) if not have_resT2
    "Consumer circuit temperature set point (constant)"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Blocks.Routing.RealPassThrough T2Set(
    y(final unit="K", displayUnit="degC"))
    "Consumer circuit temperature set point"
    annotation (Placement(transformation(extent={{-30,60},{-10,80}})));
equation
  connect(fraLoa.y[1], loa.u) annotation (Line(points={{-118,180},{30,180},{30,118},
          {38,118}}, color={0,0,127}));
  connect(fraLoa.y[2], loa1.u) annotation (Line(points={{-118,180},{90,180},{90,
          118},{98,118}},
                     color={0,0,127}));
  connect(con.port_b2, loa.port_a) annotation (Line(points={{24,20},{24,60},{40,
          60},{40,110}},
                     color={0,127,255}));
  connect(del2.ports[2], loa1.port_b)
    annotation (Line(points={{60,20},{120,20},{120,110}},
                                                        color={0,127,255}));
  connect(loa.port_b, del2.ports[3])
    annotation (Line(points={{60,110},{60,20}},       color={0,127,255}));
  connect(con.port_b2, res2.port_a)
    annotation (Line(points={{24,20},{24,60},{70,60}}, color={0,127,255}));
  connect(res2.port_b, loa1.port_a)
    annotation (Line(points={{90,60},{100,60},{100,110}}, color={0,127,255}));
  connect(resT2.y, T2SetVar.u)
    annotation (Line(points={{-78,110},{-62,110}},
                                                 color={0,0,127}));
  connect(loa.yVal_actual, yValMax.u2) annotation (Line(points={{62,118},{70,
          118},{70,144},{62,144}},
                              color={0,0,127}));
  connect(loa1.yVal_actual, yValMax.u1) annotation (Line(points={{122,118},{130,
          118},{130,156},{62,156}}, color={0,0,127}));
  connect(yValMax.y, resT2.u_m) annotation (Line(points={{38,150},{20,150},{20,
          90},{-90,90},{-90,98}},
                              color={0,0,127}));
  connect(mode.y[1], resT2.mode)
    annotation (Line(points={{-118,0},{-96,0},{-96,98}}, color={255,127,0}));
  connect(yValSet.y, resT2.u_s)
    annotation (Line(points={{-118,150},{-106,150},{-106,110},{-102,110}},
                                                   color={0,0,127}));
  connect(zer.y, T2SetVar.x1)
    annotation (Line(points={{-78,150},{-72,150},{-72,118},{-62,118}},
                                                           color={0,0,127}));
  connect(one.y, T2SetVar.x2) annotation (Line(points={{-38,150},{-34,150},{-34,
          130},{-68,130},{-68,106},{-62,106}},
                                   color={0,0,127}));
  connect(T2SetLim1.y, T2SetVar.f2) annotation (Line(points={{-118,70},{-68,70},
          {-68,102},{-62,102}},
                              color={0,0,127}));
  connect(T2SetLim0.y, T2SetVar.f1) annotation (Line(points={{-118,110},{-110,
          110},{-110,126},{-76,126},{-76,114},{-62,114}},
                                                 color={0,0,127}));
  connect(T2SetLim1.y, T2SetCst.u)
    annotation (Line(points={{-118,70},{-68,70},{-68,60},{-62,60}},
                                                  color={0,0,127}));
  connect(T2SetCst.y, T2Set.u)
    annotation (Line(points={{-39,60},{-36,60},{-36,70},{-32,70}},
                                                 color={0,0,127}));
  connect(T2SetVar.y, T2Set.u) annotation (Line(points={{-38,110},{-36,110},{
          -36,70},{-32,70}},
                     color={0,0,127}));
  connect(T2Set.y, con.set) annotation (Line(points={{-9,70},{0,70},{0,6},{18,6}},
                 color={0,0,127}));
  connect(mode.y[1], loa.mode) annotation (Line(points={{-118,0},{10,0},{10,114},
          {38,114}}, color={255,127,0}));
  connect(mode.y[1], loa1.mode) annotation (Line(points={{-118,0},{10,0},{10,80},
          {80,80},{80,114},{98,114}}, color={255,127,0}));
   annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/InjectionTwoWayConstant.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model represents a heating system where the configuration
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay\">
Buildings.Fluid.HydronicConfigurations.ActiveNetworks.InjectionTwoWay</a>
serves as the interface between a variable
flow primary circuit and a constant flow secondary circuit.
Two identical terminal units are served by the secondary circuit.
Each terminal unit has its own hourly load profile.
The main assumptions are enumerated below.
</p>
<ul>
<li>
The design conditions are defined without considering any load diversity.
</li>
<li>
Each circuit is balanced at design conditions.
</li>
<li>
The pump dissipated heat is not added to the fluid.
</li>
<li>
The consumer circuit has either a constant (supply or return)
temperature set point if <code>have_resT2=false</code>
or a temperature reset if <code>have_resT2=true</code>.
The reset logic is based on the terminal valve opening, with the most
open valve being kept <i>90%</i> open.
</li>
</ul>
<p>
Without temperature reset (<code>have_resT2=false</code>),
the primary flow variation with the load is not optimal (see plot #8):
for a load fraction of <i>30%</i> the normalized primary flow rate
is about <i>60%</i>.
</p>
<p>
The flow reduction is enhanced when using a reset based on the maximum
valve demand:
for a load fraction of <i>30%</i> the normalized primary flow rate
is now close to <i>30%</i>.
(Also note the setting of the controller <code>resT2</code> which ensures
a reset at design value when the control loop is enabled).
</p>
<p>
The flow reduction is further enhanced when using a control based on the
return temperature
(<code>have_resT2 = false</code> and
<code>con(typVar=Types.ControlVariable.ReturnTemperature)</code>):
the normalized primary flow rate varies close to linearly with the
load fraction.
This explains why this control strategy is often adopted
as it brings a good flow rate variation with the load at a
first cost lower than the previous reset option based on the valve demand.
However, it also brings some additional constraints on the sizing of
the terminal units.
The load diversity must indeed be accounted for.
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
</html>", revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end InjectionTwoWayConstant;
