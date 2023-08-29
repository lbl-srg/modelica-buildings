within Buildings.Experimental.DHC.Loads.DHW.BaseClasses.DELETE;
model HeatPumpWaterHeaterWithTankOLD
  "A model for domestic water heating served by heat pump water heater and local storage tank"
  extends
    Buildings.Experimental.DHC.Loads.DHW.BaseClasses.DELETE.PartialDHWGeneration;

  parameter Modelica.Units.SI.Volume VTan = 0.151416 "Tank volume";
  parameter Modelica.Units.SI.Length hTan = 1.746 "Height of tank (without insulation)";
  parameter Modelica.Units.SI.Length dIns = 0.0762 "Thickness of insulation";
  parameter Modelica.Units.SI.ThermalConductivity kIns=0.04 "Specific heat conductivity of insulation";
  parameter Modelica.Units.SI.PressureDifference dpHex_nominal=2500 "Pressure drop across the heat exchanger at nominal conditions";
  parameter Modelica.Units.SI.MassFlowRate mHex_flow_nominal=0.278 "Mass flow rate of heat exchanger";
  parameter Modelica.Units.SI.HeatFlowRate QCon_flow_nominal(min=0) = 1230.9 "Nominal heating flow rate";

  Buildings.Fluid.Sensors.TemperatureTwoPort senTemTankOut(redeclare package
      Medium = Medium, m_flow_nominal=mHw_flow_nominal)
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.HeatPumps.Carnot_TCon heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=mHw_flow_nominal,
    m2_flow_nominal=mDH_flow_nominal,
    QCon_flow_nominal=QCon_flow_nominal,
    dp1_nominal=0,
    dp2_nominal=0)
              "Domestic hot water heater"
    annotation (Placement(transformation(extent={{-70,58},{-50,38}})));
  Fluid.Storage.StratifiedEnhancedInternalHex tan(
    redeclare package Medium = Medium,
    m_flow_nominal=mHw_flow_nominal,
    VTan=VTan,
    hTan=hTan,
    dIns=dIns,
    kIns=kIns,
    nSeg=5,
    redeclare package MediumHex = Medium,
    CHex=40,
    Q_flow_nominal=0.278*4200*20,
    hHex_a=0.995,
    hHex_b=0.1,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    energyDynamicsHex=Modelica.Fluid.Types.Dynamics.SteadyState,
    allowFlowReversal=false,
    allowFlowReversalHex=false,
    mHex_flow_nominal=mHex_flow_nominal,
    TTan_nominal=293.15,
    THex_nominal=323.15,
    dpHex_nominal=dpHex_nominal)
                                "Hot water tank with heat exchanger configured as steady state"
    annotation (Placement(transformation(extent={{-50,-10},{-70,10}})));
  Fluid.Sensors.TemperatureTwoPort senTemHPOut(redeclare package Medium =
        Medium, m_flow_nominal=mHw_flow_nominal) annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-28,20})));
equation
  connect(senTemTankOut.port_b, port_hw)
    annotation (Line(points={{20,0},{100,0}}, color={0,127,255}));
  connect(port_dhs, heaPum.port_a2)
    annotation (Line(points={{-40,100},{-40,54},{-50,54}}, color={0,127,255}));
  connect(heaPum.port_b2, port_dhr)
    annotation (Line(points={{-70,54},{-80,54},{-80,100}}, color={0,127,255}));
  connect(tan.port_a, senTemTankOut.port_a)
    annotation (Line(points={{-50,0},{0,0}}, color={0,127,255}));
  connect(heaPum.P, PEle) annotation (Line(points={{-49,48},{0,48},{0,40},{106,
          40}}, color={0,0,127}));
  connect(conTSetHw.y, heaPum.TSet) annotation (Line(points={{-83.2,32},{-80,32},
          {-80,39},{-72,39}}, color={0,0,127}));
  connect(port_cw, tan.port_b)
    annotation (Line(points={{-100,0},{-70,0}}, color={0,127,255}));
  connect(tan.portHex_b, heaPum.port_a1) annotation (Line(points={{-50,-8},{-40,
          -8},{-40,-20},{-76,-20},{-76,42},{-70,42}}, color={0,127,255}));
  connect(tan.portHex_a, senTemHPOut.port_b) annotation (Line(points={{-50,-3.8},
          {-28,-3.8},{-28,10}}, color={0,127,255}));
  connect(heaPum.port_b1, senTemHPOut.port_a)
    annotation (Line(points={{-50,42},{-28,42},{-28,30}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end HeatPumpWaterHeaterWithTankOLD;
