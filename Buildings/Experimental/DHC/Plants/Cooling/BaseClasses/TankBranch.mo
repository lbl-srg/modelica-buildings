within Buildings.Experimental.DHC.Plants.Cooling.BaseClasses;
model TankBranch "Model of the tank branch of a storage plant"

  extends Buildings.Fluid.Interfaces.PartialFourPort(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium);

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium package";

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal(min=0)
    "Nominal mass flow rate"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.MassFlowRate mTan_flow_nominal(min=0)
    "Nominal mass flow rate for CHW tank branch"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.MassFlowRate mChi_flow_nominal(min=0)
    "Nominal mass flow rate for CHW chiller branch"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.Temperature T_CHWS_nominal(displayUnit="degC")=
    7+273.15 "Nominal temperature of CHW supply"
    annotation(Dialog(group="Nominal values"));
  parameter Modelica.Units.SI.Temperature T_CHWR_nominal(displayUnit="degC")=
    12+273.15
    "Nominal temperature of CHW return"
    annotation(Dialog(group="Nominal values"));

  // Storage tank parameters
  parameter Modelica.Units.SI.Volume VTan "Tank volume"
    annotation(Dialog(group="Tank"));
  parameter Modelica.Units.SI.Length hTan
    "Height of tank (without insulation)"
    annotation(Dialog(group="Tank"));
  parameter Modelica.Units.SI.Length dIns "Thickness of insulation"
    annotation(Dialog(group="Tank"));
  parameter Modelica.Units.SI.ThermalConductivity kIns=0.04
    "Specific heat conductivity of insulation"
    annotation(Dialog(group="Tank"));
  parameter Integer nSeg(min=2) = 5 "Number of volume segments"
    annotation(Dialog(group="Tank"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.Temperature T_start=T_CHWR_nominal
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Modelica.Units.SI.Temperature TFlu_start[nSeg]=T_start*ones(nSeg)
    "Initial temperature of the tank segments, with TFlu_start[1] being the top segment"
    annotation (Dialog(tab="Initialization"));
  parameter Modelica.Units.SI.Time tau=1 "Time constant for mixing"
    annotation(Dialog(group="Tank"));

  Buildings.Fluid.Storage.Stratified tan(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true,
    final VTan=VTan,
    final hTan=hTan,
    final dIns=dIns,
    final kIns=kIns,
    final nSeg=nSeg,
    final energyDynamics=energyDynamics,
    final p_start=p_start,
    final T_start=T_start,
    final TFlu_start=TFlu_start,
    final tau=tau,
    final m_flow_nominal=mTan_flow_nominal,
    show_T=true) "Tank"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sensors.MassFlowRate senFlo(
    redeclare final package Medium = Medium,
    final allowFlowReversal=true) "Flow rate sensor for the tank,"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-50,-30})));
  Modelica.Blocks.Interfaces.RealOutput mTan_flow(
    final quantity="MassFlowRate",
    final unit="kg/s") "Mass flow rate of the tank"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,90}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,100})));
  Modelica.Blocks.Interfaces.RealOutput Ql_flow(
    final quantity="HeatFlowRate",
    final unit="W")
    "Heat loss of tank (positive if heat flows from tank to ambient)"
    annotation (Placement(transformation(extent={{100,0},{120,20}}),
        iconTransformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,0})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorTop
    "Heat port tank top (outside insulation)"
    annotation (Placement(transformation(extent={{-16,34},{-4,46}}),
        iconTransformation(extent={{14,34},{26,46}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorSid
    "Heat port tank side (outside insulation)"
    annotation (Placement(transformation(extent={{4,-26},{16,-14}}),
        iconTransformation(extent={{26,-6},{38,6}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorBot
    "Heat port tank bottom (outside insulation). Leave unconnected for adiabatic condition"
    annotation (Placement(transformation(extent={{-16,-46},{-4,-34}}),
        iconTransformation(extent={{14,-46},{26,-34}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a[tan.nSeg] heaPorVol
    "Heat port that connects to the control volumes of the tank"
    annotation (Placement(transformation(extent={{-26,-26},{-14,-14}}),
        iconTransformation(extent={{-6,-6},{6,6}})));
  Modelica.Blocks.Interfaces.RealOutput TTan[2](
    each unit="K",
    each final quantity="Temperature",
    each displayUnit="degC") "Temperatures at the tank 1: top and 2: bottom"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-90}), iconTransformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={110,-100})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemTop
    "Temperature sensor for tank top"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemBot
    "Temperature sensor for tank bottom"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

protected
  Buildings.Fluid.FixedResistances.Junction junSup(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=T_CHWS_nominal,
    tau=30,
    m_flow_nominal={-mChi_flow_nominal,mTan_flow_nominal,m_flow_nominal},
    dp_nominal={0,0,0}) "Junction on the supply side"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Fluid.FixedResistances.Junction junRet(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=T_CHWR_nominal,
    tau=30,
    m_flow_nominal={-m_flow_nominal,mChi_flow_nominal,mTan_flow_nominal},
    dp_nominal={0,0,0}) "Junction on the return side" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-50,-60})));

equation
  connect(senFlo.m_flow, mTan_flow) annotation (Line(points={{-61,-30},{-66,-30},
          {-66,90},{110,90}},         color={0,0,127}));
  connect(tan.Ql_flow, Ql_flow)
    annotation (Line(points={{11,7.2},{11,10},{110,10}},
                                                       color={0,0,127}));
  connect(tan.heaPorTop, heaPorTop) annotation (Line(points={{2,7.4},{2,30},{-10,
          30},{-10,40}},color={191,0,0}));
  connect(tan.heaPorSid, heaPorSid) annotation (Line(points={{5.6,0},{5.6,-4},{10,
          -4},{10,-20}},    color={191,0,0}));
  connect(tan.heaPorBot, heaPorBot)
    annotation (Line(points={{2,-7.4},{2,-30},{-10,-30},{-10,-40}},
                                                         color={191,0,0}));
  connect(heaPorVol, tan.heaPorVol) annotation (Line(points={{-20,-20},{-20,-4},
          {0,-4},{0,0}},         color={191,0,0}));
  connect(junRet.port_3, senFlo.port_a)
    annotation (Line(points={{-50,-50},{-50,-40}}, color={0,127,255}));
  connect(senFlo.port_b, tan.port_a)
    annotation (Line(points={{-50,-20},{-50,10},{0,10}}, color={0,127,255}));
  connect(tan.port_b, junSup.port_3)
    annotation (Line(points={{0,-10},{50,-10},{50,50}},
                                                     color={0,127,255}));
  connect(tan.heaPorTop, senTemTop.port)
    annotation (Line(points={{2,7.4},{2,30},{20,30}}, color={191,0,0}));
  connect(tan.heaPorBot, senTemBot.port)
    annotation (Line(points={{2,-7.4},{2,-30},{20,-30}}, color={191,0,0}));
  connect(senTemTop.T, TTan[1]) annotation (Line(points={{41,30},{70,30},{70,-90},
          {110,-90},{110,-92.5}}, color={0,0,127}));
  connect(senTemBot.T, TTan[2]) annotation (Line(points={{41,-30},{70,-30},{70,-87.5},
          {110,-87.5}}, color={0,0,127}));
  connect(port_b2, junRet.port_2)
    annotation (Line(points={{-100,-60},{-60,-60}}, color={0,127,255}));
  connect(junRet.port_1, port_a2)
    annotation (Line(points={{-40,-60},{100,-60}}, color={0,127,255}));
  connect(junSup.port_2, port_b1)
    annotation (Line(points={{60,60},{100,60}}, color={0,127,255}));
  connect(junSup.port_1, port_a1)
    annotation (Line(points={{40,60},{-100,60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={
                               Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-100,-60},{100,-60}}, color={28,108,200}),
        Line(points={{-100,60},{100,60}}, color={28,108,200}),
        Line(points={{-42,-60}}, color={28,108,200}),
        Line(points={{-60,-58},{-60,50},{0,50},{0,-52},{60,-52},{60,60}}, color
            ={28,108,200}),
        Rectangle(
          extent={{-28,40},{32,-40}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{38,0},{80,0},{100,0}},
          color={127,0,0},
          pattern=LinePattern.Dot),
        Line(
          points={{26,-44},{52,-44},{52,0}},
          color={127,0,0},
          pattern=LinePattern.Dot),
        Line(
          points={{26,44},{52,44},{52,-2}},
          color={127,0,0},
          pattern=LinePattern.Dot)}),                            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    defaultComponentName = "tanBra",
    Documentation(info="<html>
<p>
This model is part of a storage plant. This branch has a stratified tank.
This tank can potentially be charged remotely by a chiller from the district
CHW network, or by a chiller that is local to the energy transfer station that contains this tank.
</p>
</html>", revisions="<html>
<ul>
<li>
March 5, 2024, by Michael Wetter:<br/>
Corrected wrong use of <code>displayUnit</code>.
</li>
<li>
October 4, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end TankBranch;
