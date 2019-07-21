within Buildings.DistrictHeatingCooling.Loads.BaseClasses;
model HeatingOrCooling
  "Model for steady-state, sensible heat transfer between a circulating liquid and thermal loads"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal=sum(m_flowLoa_nominal),
    port_a(h_outflow(start=h_outflow_start)),
    port_b(h_outflow(start=h_outflow_start)));
  extends Buildings.Fluid.Interfaces.TwoPortFlowResistanceParameters(
    dp_nominal = 0,
    final computeFlowResistance=true);
  parameter Integer nLoa = 1
    "Number of connected loads";
  parameter Modelica.SIunits.Temperature T_a_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0),
    displayUnit="degC")
    "Water supply temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_b_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0),
    displayUnit="degC")
    "Water return temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate Q_flowLoa_nominal[nLoa](
    each min=0)
    "Thermal power exchanged with the load at nominal conditions (>0)"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature TLoa_nominal[nLoa](
    each min=Modelica.SIunits.Conversions.from_degC(0),
    each displayUnit="degC")
    "Representative temperature of the load at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Boolean reverseAction = false
    "Set to true for tracking a cooling heat flow rate";
  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.SIunits.Time tau = 30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.Temperature T_start = Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.MassFraction X_start[Medium.nX](
    final quantity=Medium.substanceNames) = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
    final quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
  // Advanced
  parameter Boolean homotopyInitialization = true
    "If true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Real ratUAIntToUAExt[nLoa](each min=1) = fill(2, nLoa)
    "Ratio of UA internal to UA external values at nominal conditions"
    annotation(Dialog(tab="Advanced", group="Nominal condition"));
  parameter Real expUA[nLoa] = fill(4/5, nLoa)
    "Exponent of Reynolds number in the flow correlation used for computing UA internal value"
    annotation(Dialog(tab="Advanced"));
  // Computed parameters
  final parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = sum(Q_flowLoa_nominal)
     "Total thermal power exchanged with the loads at nominal conditions (>0)";
  final parameter Modelica.SIunits.MassFlowRate m_flowLoa_nominal[nLoa] = abs(
    Q_flowLoa_nominal / cp_nominal / (T_a_nominal - T_b_nominal))
    "Water mass flow rate at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance UALoa_nominal[nLoa]=
    Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
      eps=Q_flowLoa_nominal ./ abs(cp_nominal * m_flowLoa_nominal .* (T_a_nominal .- TLoa_nominal)),
      Z=0,
      flowRegime=Integer(Buildings.Fluid.Types.HeatExchangerFlowRegime.ConstantTemperaturePhaseChange)) *
    cp_nominal .* m_flowLoa_nominal
    "Thermal conductance at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance UALoaExt_nominal[nLoa]=
    (1 .+ ratUAIntToUAExt) ./ ratUAIntToUAExt .* UALoa_nominal
    "External thermal conductance at nominal conditions";
  final parameter Modelica.SIunits.ThermalConductance UALoaInt_nominal[nLoa]=
    ratUAIntToUAExt .* UALoaExt_nominal
    "Internal thermal conductance at nominal conditions";
  // IO connectors
  Buildings.Controls.OBC.CDL.Interfaces.RealInput Q_flowLoaReq[nLoa](quantity="HeatFlowRate")
    "Heat flow rate required to meet the load temperature setpoint" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,180}),iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput m_flowReq(quantity="MassFlowRate")
    "Total mass flow rate to provide the required heat flow rates"
    annotation (Placement(transformation(extent={{100,100},{120,120}}),
                                                                      iconTransformation(extent={{100,70},{120,90}})));
  // Building blocks
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare final package Medium = Medium,
    V=m_flow_nominal*tau/rho_default,
    final prescribedHeatFlowRate=true,
    final allowFlowReversal=allowFlowReversal,
    final mSenFac=1,
    final m_flow_nominal = m_flow_nominal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    nPorts=2) "Volume for fluid stream"
     annotation (Placement(transformation(extent={{71,0},{51,-20}})));
  Buildings.Fluid.FixedResistances.PressureDrop preDro(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final deltaM=deltaM,
    final allowFlowReversal=allowFlowReversal,
    final show_T=false,
    final from_dp=from_dp,
    final linearized=linearizeFlowResistance,
    final homotopyInitialization=homotopyInitialization,
    final dp_nominal=dp_nominal) "Flow resistance"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.DistrictHeatingCooling.Loads.BaseClasses.EffectivenessControl effCon[nLoa](
    Q_flow_nominal=Q_flowLoa_nominal,
    m_flow_nominal=m_flowLoa_nominal,
    each reverseAction=reverseAction) annotation (Placement(transformation(extent={{-60,168},{-40,186}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum m_flowReqSum(nin=nLoa) "Sum the mass flow rates of all loads"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  Buildings.DistrictHeatingCooling.Loads.BaseClasses.EffectivenessDirect effDir[nLoa](final m_flow_nominal=
        m_flowLoa_nominal) annotation (Placement(transformation(extent={{0,166},{20,186}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort TLiqInlMes(
    redeclare package Medium = Medium,
    final m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sensors.MassFlowRate m_flowLiqMes(redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Modelica.Blocks.Sources.RealExpression UAAct[nLoa](y=1 ./ (1 ./ (UALoaInt_nominal .*
        Buildings.Utilities.Math.Functions.regNonZeroPower(m_flowAct.y ./ m_flowLoa_nominal, expUA)) + 1 ./
        UALoaExt_nominal)) annotation (Placement(transformation(extent={{-100,190},{-80,210}})));
  Modelica.Blocks.Sources.RealExpression cpLiq(y=cp_nominal)
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator cpLiqVec(nout=nLoa) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-70,120})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator TLiqInlVec(nout=nLoa) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-70,50})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorLoa[nLoa]
    "Heat port transfering heat to the load"
    annotation (Placement(transformation(extent={{90,230},{110,250}}),
    conTransformation(extent={{-10,90},{10, 110}}),
      iconTransformation(extent={{-10,90},{10,110}})));
  Modelica.Blocks.Sources.RealExpression m_flowAct[nLoa](
    y=effCon.m_flow / Buildings.Utilities.Math.Functions.smoothMax(
        m_flowReqSum.y,
        m_flow_small,
        m_flow_small)*m_flowLiqMes.m_flow)
    annotation (Placement(transformation(extent={{-100,210},{-80,230}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloToLiq
    "Heat flow rate from load to liquid"
    annotation (Placement(transformation(extent={{-10,-10}, {10,10}}, rotation=-90, origin={86,24})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum Q_flowSum(nin=nLoa)
    "Sum of the heat flow rates for all loads"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai[nLoa](each k=-1)
  annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=90,
        origin={40,210})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloToLoa[nLoa]
    "Heat flow rate from liquid to load"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={70,240})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TLoaMes[nLoa]
    "Temperature sensor"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={70,150})));
  // FOR DEVELOPMENT ONLY
  Real frac_Q_flow "Positive fractional heat flow rate";
  // FOR DEVELOPMENT ONLY
protected
  parameter Modelica.SIunits.SpecificHeatCapacity cp_nominal = Medium.specificHeatCapacityCp(
      Medium.setState_pTX(Medium.p_default, T_a_nominal))
    "Specific heat capacity at nominal conditions";
  parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
      T=Medium.T_default, p=Medium.p_default, X=Medium.X_default);
  parameter Modelica.SIunits.Density rho_default = Medium.density(sta_default)
    "Density, used to compute fluid volume";
  parameter Medium.ThermodynamicState sta_start = Medium.setState_pTX(
      T=T_start, p=p_start, X=X_start);
  parameter Modelica.SIunits.SpecificEnthalpy h_outflow_start = Medium.specificEnthalpy(sta_start)
    "Start value for outflowing enthalpy";
equation
  // FOR DEVELOPMENT ONLY
  frac_Q_flow = abs(heaFloToLiq.Q_flow / Q_flow_nominal);
  // FOR DEVELOPMENT ONLY
  connect(m_flowReqSum.y, m_flowReq) annotation (Line(points={{81,110},{110,110}},
                                                                                 color={0,0,127}));
  connect(port_a,TLiqInlMes. port_a) annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(TLiqInlMes.port_b, m_flowLiqMes.port_a) annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
  connect(preDro.port_a, m_flowLiqMes.port_b) annotation (Line(points={{0,0},{-20,0}}, color={0,127,255}));
  connect(cpLiq.y, cpLiqVec.u) annotation (Line(points={{-79,100},{-70,100},{-70,108}}, color={0,0,127}));
  connect(TLiqInlMes.T, TLiqInlVec.u) annotation (Line(points={{-70,11},{-70,38}}, color={0,0,127}));
  connect(UAAct.y, effDir.UA) annotation (Line(points={{-79,200},{-16,200},{-16,184},{-2,184}}, color={0,0,127}));
  connect(TLiqInlVec.y, effDir.TInl)
    annotation (Line(points={{-70,61},{-70,80},{-20,80},{-20,176},{-2,176}}, color={0,0,127}));
  connect(heaPorLoa,TLoaMes. port) annotation (Line(points={{100,240},{100,150},{80,150}}, color={191,0,0}));
  connect(m_flowAct.y, effDir.m_flow)
    annotation (Line(points={{-79,220},{-20,220},{-20,180},{-2,180}}, color={0,0,127}));
  connect(Q_flowSum.y, heaFloToLiq.Q_flow)
    annotation (Line(points={{81,50},{86,50},{86,34}}, color={0,0,127}));
  connect(effDir.Q_flow, gai.u)
    annotation (Line(points={{21,176},{40,176},{40,198}},          color={0,0,127}));
  connect(heaPorLoa, heaFloToLoa.port)
    annotation (Line(points={{100,240},{80,240}}, color={191,0,0}));
  connect(gai.y, heaFloToLoa.Q_flow)
    annotation (Line(points={{40,221},{40,240},{60,240}},
                                                 color={0,0,127}));
  connect(TLoaMes.T, effCon.TLoad)
    annotation (Line(points={{60,150},{-66,150},{-66,168},{-62,168}}, color={0,0,127}));
  connect(effCon.m_flow, m_flowReqSum.u)
    annotation (Line(points={{-39,181},{-30,181},{-30,110},{58,110}},
                                                                    color={0,0,127}));
  connect(effDir.Q_flow, Q_flowSum.u)
    annotation (Line(points={{21,176},{40,176},{40,50},{58,50}}, color={0,0,127}));
  connect(UAAct.y, effCon.UA)
    annotation (Line(points={{-79,200},{-74,200},{-74,184},{-62,184}}, color={0,0,127}));
  connect(m_flowReq, m_flowReq) annotation (Line(points={{110,110},{110,110}}, color={0,0,127}));
  connect(Q_flowLoaReq, effCon.Q_flowReq) annotation (Line(points={{-120,180},{-62,180}}, color={0,0,127}));
  connect(cpLiqVec.y, effCon.cpInl) annotation (Line(points={{-70,131},{-70,172},{-62,172}}, color={0,0,127}));
  connect(TLoaMes.T, effDir.TLoad)
    annotation (Line(points={{60,150},{-12,150},{-12,168},{-2,168}}, color={0,0,127}));
  connect(heaFloToLiq.port, vol.heatPort) annotation (Line(points={{86,14},{86,-10},{71,-10}}, color={191,0,0}));
  connect(preDro.port_b, vol.ports[1]) annotation (Line(points={{20,0},{63,0}}, color={0,127,255}));
  connect(vol.ports[2], port_b) annotation (Line(points={{59,0},{100,0}}, color={0,127,255}));
  connect(TLiqInlVec.y, effCon.TInl)
    annotation (Line(points={{-70,61},{-70,80},{-48,80},{-48,146},{-74,146},{-74,176},{-62,176}}, color={0,0,127}));
  connect(cpLiqVec.y, effDir.cpInl)
    annotation (Line(points={{-70,131},{-70,140},{-16,140},{-16,172},{-2,172}}, color={0,0,127}));
  annotation (
   Documentation(
info="<html>
<p>
This model computes the steady-state, sensible heat transfer between a circulating liquid and idealized 
thermal loads at uniform temperature.
</p>
<p>
The heat flow rate transferred to each load is computed using the effectiveness method, see 
<a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessDirect\">
Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessDirect</a>.
As the effectiveness depends on the mass flow rate, this requires to assess a representative distribution of 
the main liquid stream between the connected loads. 
This is achieved by:
<ul>
<li> computing the mass flow rate needed to transfer the required heat flow rate to each load, 
see 
<a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessControl\">
Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessControl</a>,
</li>
<li> normalizing this mass flow rate to the actual flow rate of the main liquid stream.</li>
</ul>
</p>
<p>
The nominal UA-value (W/K) is calculated for each load <i>i</i> from the cooling or
heating power and the temperature difference between the liquid and the load, see 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ\">
Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ</a>.
It is split between an internal (liquid side) and an external (load side) UA-value based on the ratio 
<i>UA<sub>int, nom, i</sub> / UA<sub>ext, nom, i</sub> </i> provided as a parameter. The influence of 
the liquid flow rate on the internal UA-value is derived from a forced convection 
correlation, expressing the Nusselt number as a power of the Reynolds number, under the assumption that the 
physical characteristics of the liquid do not vary significantly from their value at nominal conditions.
</p>
<p align=\"center\" style=\"font-style:italic;\">
UA<sub>int, i</sub> = UA<sub>int, nom, i</sub> * (m&#775;<sub>i</sub> / 
m&#775;<sub>nom, i</sub>)<sup>expUAi</sup>
</p>
<p>
where thedefault value of <i>expUA<sub>i</sub></i> stems from the Dittus and Boelter correlation for turbulent 
flow.
</p>

<h4>References</h4>
<p>
Dittus and Boelter. 1930. Heat transfer in automobile radiators of the tubular type. University of California
Engineering Publication 13.443.
</p>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
          extent={{-70,70},{70,-70}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,5},{100,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={95,95,95}),
        Rectangle(
          extent={{0,-4},{100,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{100,240}}), graphics={
        Rectangle(extent={{-104,244},{24,134}}, lineColor={28,108,200}),
        Text(
          extent={{-76,294},{-30,250}},
          lineColor={28,108,200},
          fontSize=10,
          textString="DynamicsSection          	23	6.446	      127.72 (      78.00 to      570.00)	50471
 simulation.nonlinear[8] 	43	1.378	       27.31 (       9.00 to      178.00)	50471
 simulation.nonlinear[7] 	41	1.305	       25.86 (      10.00 to      120.00)	50471
 Dynamics code           	24	0.25	        4.95 (       3.00 to       55.00)	50470
"),
        Text(
          extent={{-76,272},{-30,232}},
          lineColor={28,108,200},
          fontSize=10,
          textString="DynamicsSection          	23	2.635	       77.80 (      55.00 to      468.00)	33873
 Dynamics code           	26	0.213	        6.30 (       4.00 to      191.00)	33873
 Dynamics code           	32	0.168	        4.95 (       3.00 to       47.00)	33873
 Dynamics code           	44	0.167	        4.94 (       3.00 to      155.00)	33873
")}));
end HeatingOrCooling;
