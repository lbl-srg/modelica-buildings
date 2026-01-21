within Buildings.Templates.Components.Loads;
model Load
  "Model of a load on a hydronic circuit"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal);
  replaceable package MediumAir = Buildings.Media.Air "Medium model for air";
  replaceable package MediumLiq = Buildings.Media.Water
    "Medium model for liquid (CHW or HHW)";
  parameter Buildings.Fluid.HydronicConfigurations.Types.Control typ
    "Load type"
    annotation(Evaluate=true,
      choices(
        choice=Buildings.Fluid.HydronicConfigurations.Types.Control.Heating
          "Heating",
        choice=Buildings.Fluid.HydronicConfigurations.Types.Control.Cooling
          "Cooling"));
  parameter Modelica.Units.SI.MassFlowRate mLiq_flow_nominal = 1
    "Liquid mass flow rate at design conditions";
  parameter Modelica.Units.SI.PressureDifference dpLiq_nominal = 0
    "Liquid pressure drop at design conditions";
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal =
    abs(Q_flow_nominal) / 10 / cpAir_nominal
    "Air mass flow rate at design conditions";
  parameter Modelica.Units.SI.Temperature TAirEnt_nominal =
    if typ == Buildings.Fluid.HydronicConfigurations.Types.Control.Heating
    then 20 + 273.15 else 26 + 273.15
    "Air entering temperature at design conditions";
  parameter Modelica.Units.SI.MassFraction phiAirEnt_nominal = 0.5
    "Air entering relative humidity at design conditions"
    annotation(Dialog(enable=typ <>
      Buildings.Fluid.HydronicConfigurations.Types.Control.Heating));
  final parameter Modelica.Units.SI.MassFraction XAirEnt_nominal =
    Buildings.Utilities.Psychrometrics.Functions.X_pTphi(
      MediumAir.p_default,
      TAirEnt_nominal,
      phiAirEnt_nominal)
    "Air entering water mass fraction at design conditions (kg/kg air)";
  final parameter Modelica.Units.SI.MassFraction xAirEnt_nominal =
    XAirEnt_nominal / (1 - XAirEnt_nominal)
    "Air entering humidity ratio at design conditions (kg/kg dry air)";
  parameter Modelica.Units.SI.Temperature TLiqEnt_nominal =
    if typ == Buildings.Fluid.HydronicConfigurations.Types.Control.Heating
    then 60 + 273.15 else 7 + 273.15
    "Liquid entering temperature at design conditions";
  parameter Modelica.Units.SI.Temperature TLiqLvg_nominal =
    TLiqEnt_nominal + (if typ ==
      Buildings.Fluid.HydronicConfigurations.Types.Control.Heating
      then -10 else +5)
    "Liquid leaving temperature at design conditions";
  final parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal =
    (MediumLiq.specificEnthalpy_pTX(
      MediumLiq.p_default,
      TLiqEnt_nominal,
      X=MediumLiq.X_default) - MediumLiq.specificEnthalpy_pTX(
      MediumLiq.p_default,
      TLiqLvg_nominal,
      X=MediumLiq.X_default)) * mLiq_flow_nominal
    "Transmitted heat flow rate at design conditions";
  parameter Real u_min(
    max=1,
    min=0,
    unit="1")=0.1 "Fan minimum speed";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType =
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Valve controller"));
  parameter Real k(min=100*Modelica.Constants.eps)=0.1
    "Gain of controller"
    annotation(Dialog(group="Valve controller"));
  parameter Real Ti(unit="s")=10
    "Time constant of integrator block"
    annotation(Dialog(group="Valve controller",
      enable=controllerType ==
        Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerType ==
          Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(unit="s")=0.1 "Time constant of derivative block"
    annotation(Dialog(group="Valve controller",
      enable=controllerType ==
        Buildings.Controls.OBC.CDL.Types.SimpleController.PD
        or controllerType ==
          Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics =
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true,
      Dialog(tab="Dynamics",
        group="Conservation equations"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u
    "Fraction of design load"
    annotation(Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1
    "System enable"
    annotation(Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yVal(final unit="1")
    "Valve demand signal"
    annotation(Placement(transformation(extent={{100,60},{140,100}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput dTLiq(
    final unit="K",
    displayUnit="K")
    "Liquid deltaT"
    annotation(Placement(transformation(extent={{100,-60},{140,-20}}),
      iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Fluid.Sources.Boundary_pT outAir(
    redeclare final package Medium=MediumAir,
    nPorts=1)
    "Pressure boundary condition at coil outlet"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={-80,20})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TAirLvg(
    redeclare final package Medium=MediumAir,
    final m_flow_nominal=mAir_flow_nominal,
    T_start=TAirEnt_nominal)
    "Leaving air temperature sensor"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=0,
      origin={-30,20})));
  Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU coi(
    redeclare final package Medium1=MediumLiq,
    redeclare final package Medium2=MediumAir,
    final energyDynamics=energyDynamics,
    final m1_flow_nominal=mLiq_flow_nominal,
    final m2_flow_nominal=mAir_flow_nominal,
    final dp1_nominal=dpLiq_nominal,
    dp2_nominal=0,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final use_Q_flow_nominal=true,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=TLiqEnt_nominal,
    final T_a2_nominal=TAirEnt_nominal,
    final w_a2_nominal=xAirEnt_nominal)
    "Coil"
    annotation(Placement(transformation(extent={{10,-10},{-10,10}},
      rotation=180,
      origin={0,6})));
  Buildings.Fluid.Sources.MassFlowSource_T souAir(
    redeclare final package Medium=MediumAir,
    final X={XAirEnt_nominal, 1 - XAirEnt_nominal},
    use_m_flow_in=true,
    final m_flow=mAir_flow_nominal,
    final T=TAirEnt_nominal,
    nPorts=1)
    "Source for entering air"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=180,
      origin={30,20})));
  Buildings.Controls.OBC.Utilities.PIDWithEnable conPID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final reverseActing=true)
    "Controller"
    annotation(Placement(transformation(extent={{-10,70},{10,90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TLiqEnt(
    redeclare final package Medium=MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    T_start=TLiqEnt_nominal)
    "Entering liquid temperature sensor"
    annotation(Placement(transformation(extent={{-10,10},{10,-10}},
      rotation=0,
      origin={-80,0})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TLiqLvg(
    redeclare final package Medium=MediumLiq,
    final m_flow_nominal=mLiq_flow_nominal,
    T_start=TLiqEnt_nominal)
    "Leaving liquid temperature sensor"
    annotation(Placement(transformation(extent={{-10,10},{10,-10}},
      rotation=0,
      origin={60,0})));
  Buildings.Controls.OBC.CDL.Reals.Subtract dT
    "Compute deltaT"
    annotation(Placement(transformation(extent={{70,-50},{90,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow(final unit="W")
    "Total heat flow rate transferred to the load"
    annotation(Placement(transformation(extent={{100,-100},{140,-60}}),
      iconTransformation(extent={{100,-110},{140,-70}})));
  Modelica.Blocks.Sources.RealExpression heaFlo(y=coi.Q2_flow)
    "Access coil heat flow rate"
    annotation(Placement(transformation(extent={{50,-90},{70,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yLoa_actual(final unit="1")
    "Actual load fraction met"
    annotation(Placement(transformation(extent={{100,20},{140,60}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Modelica.Blocks.Sources.RealExpression loaFra(y=Q_flow / Q_flow_nominal)
    "Compute actual load fraction"
    annotation(Placement(transformation(extent={{50,30},{70,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant uMin(final k=u_min)
    "Minimum speed"
    annotation(Placement(transformation(extent={{-90,-90},{-70,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Max max1
    "Maximum of control signal and minimum speed"
    annotation(Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal enaRea
    "Cast enable signal to real"
    annotation(Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    "Zero out control signal if system is disabled"
    annotation(Placement(transformation(extent={{-10,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter modMAir(
    k=mAir_flow_nominal)
    "Scale with design flow"
    annotation(Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=0,
      origin={30,-60})));

protected
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpLiq_nominal =
      MediumLiq.specificHeatCapacityCp(
        MediumLiq.setState_pTX(p=MediumLiq.p_default, T=TLiqEnt_nominal))
      "Liquid specific heat capacity at design conditions";
  final parameter Modelica.Units.SI.SpecificHeatCapacity cpAir_nominal =
      MediumAir.specificHeatCapacityCp(
        MediumAir.setState_pTX(
          p=MediumAir.p_default,
          T=TLiqEnt_nominal,
          X={XAirEnt_nominal, 1 - XAirEnt_nominal}))
      "Air specific heat capacity at design conditions";
initial equation
  assert(
    typ <> Buildings.Fluid.HydronicConfigurations.Types.Control.None
      and typ <>
        Buildings.Fluid.HydronicConfigurations.Types.Control.ChangeOver,
    "In " + getInstanceName() +
      ": The type of built-in controls cannot be None or Change-over: select any other valid option.");
equation
  connect(souAir.ports[1], coi.port_a2)
    annotation(Line(points={{20,20},{16,20},{16,12},{10,12}},
      color={0,127,255}));
  connect(outAir.ports[1], TAirLvg.port_b)
    annotation(Line(points={{-70,20},{-40,20}},
      color={0,127,255}));
  connect(TAirLvg.port_a, coi.port_b2)
    annotation(Line(points={{-20,20},{-16,20},{-16,12},{-10,12}},
      color={0,127,255}));
  connect(conPID.y, yVal)
    annotation(Line(points={{12,80},{120,80}},
      color={0,0,127}));
  connect(port_a, TLiqEnt.port_a)
    annotation(Line(points={{-100,0},{-90,0}},
      color={0,127,255}));
  connect(TLiqEnt.port_b, coi.port_a1)
    annotation(Line(points={{-70,0},{-10,0}},
      color={0,127,255}));
  connect(coi.port_b1, TLiqLvg.port_a)
    annotation(Line(points={{10,0},{50,0}},
      color={0,127,255}));
  connect(TLiqLvg.port_b, port_b)
    annotation(Line(points={{70,0},{100,0}},
      color={0,127,255}));
  connect(dT.y, dTLiq)
    annotation(Line(points={{92,-40},{120,-40}},
      color={0,0,127}));
  connect(TLiqLvg.T, dT.u1)
    annotation(Line(points={{60,-11},{60,-34},{68,-34}},
      color={0,0,127}));
  connect(TLiqEnt.T, dT.u2)
    annotation(Line(points={{-80,-11},{-80,-20},{58,-20},{58,-46},{68,-46}},
      color={0,0,127}));
  connect(heaFlo.y, Q_flow)
    annotation(Line(points={{71,-80},{120,-80}},
      color={0,0,127}));
  connect(yLoa_actual, loaFra.y)
    annotation(Line(points={{120,40},{71,40}},
      color={0,0,127}));
  connect(u, conPID.u_s)
    annotation(Line(points={{-120,80},{-12,80}},
      color={0,0,127}));
  connect(loaFra.y, conPID.u_m)
    annotation(Line(points={{71,40},{80,40},{80,60},{0,60},{0,68}},
      color={0,0,127}));
  connect(u, max1.u1)
    annotation(Line(points={{-120,80},{-60,80},{-60,-74},{-52,-74}},
      color={0,0,127}));
  connect(uMin.y, max1.u2)
    annotation(Line(points={{-68,-80},{-60,-80},{-60,-86},{-52,-86}},
      color={0,0,127}));
  connect(mul.y, modMAir.u)
    annotation(Line(points={{12,-60},{18,-60}},
      color={0,0,127}));
  connect(max1.y, mul.u2)
    annotation(Line(points={{-28,-80},{-20,-80},{-20,-66},{-12,-66}},
      color={0,0,127}));
  connect(enaRea.y, mul.u1)
    annotation(Line(points={{-28,-40},{-20,-40},{-20,-54},{-12,-54}},
      color={0,0,127}));
  connect(modMAir.y, souAir.m_flow_in)
    annotation(Line(points={{42,-60},{46,-60},{46,12},{42,12}},
      color={0,0,127}));
  connect(u1, conPID.uEna)
    annotation(Line(points={{-120,40},{-4,40},{-4,68}},
      color={255,0,255}));
  connect(u1, enaRea.u)
    annotation(Line(points={{-120,40},{-56,40},{-56,-40},{-52,-40}},
      color={255,0,255}));
annotation(defaultComponentName="loa",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
    graphics={Rectangle(extent={{-100,100},{100,-100}},
      lineColor={175,175,175},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Ellipse(extent={{-70,68},{70,-72}},
      lineColor={0,0,0},
      lineThickness=0.5,
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Ellipse(extent={{-52,50},{52,-54}},
      lineColor={0,0,0},
      lineThickness=0.5,
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Line(points={{-36,-40},{36,36}},
      color={0,0,0},
      thickness=0.5),
    Ellipse(extent={{-10,92},{10,72}},
      lineColor={0,0,0},
      lineThickness=0.5),
    Line(points={{-4,86},{4,86}},
      color={0,0,0},
      thickness=1),
    Line(points={{0,78},{0,86}},
      color={0,0,0},
      thickness=1),
    Line(points={{0,68},{0,72}},
      color={0,0,0},
      thickness=0.5),
    Line(points={{40,80},{10,80}},
      color={0,0,0},
      thickness=0.5,
      pattern=LinePattern.Dot),
    Line(points={{40,90},{60,80},{40,70}},
      color={0,0,0},
      thickness=0.5),
    Rectangle(extent={{40,90},{80,70}},
      lineColor={0,0,0},
      lineThickness=0.5),
    Line(points={{-90,0},{-70,0}},
      color={0,0,0},
      thickness=0.5),
    Line(points={{70,0},{90,0}},
      color={0,0,0},
      thickness=0.5),
    Line(points={{100,80},{80,80}},
      color={0,0,0},
      thickness=0.5,
      pattern=LinePattern.Dot)}),
  Documentation(info="<html>
<p>
This model represents a thermal load on a hydronic circuit, typically
a terminal unit with recirculating air such as a fan coil unit. It takes the
fraction of the design load  <code>u</code> as input and returns the control
valve demand signal <code>yVal</code> as output.
</p>
<h4>Modeling assumptions
</h4>
<p>
No pressure drop is considered on the load side. The design pressure
drop on the source side may be specified with the parameter <code>dpLiq_nominal
</code>.
</p>
<p>
The inlet conditions on the load side are constant and equal
to the design conditions. The mass flow rate is modulated based on the input
signal <code>u</code>, considering a minimum speed <code>u_min</code>.
</p>
</html>",
    revisions="<html>
<ul>
<li>
December 8, 2025, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
  Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end Load;
