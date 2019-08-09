within Buildings.Applications.DHC.Loads.BaseClasses;
model HeatFlowControl
  "Model computing the mass flow rate required to transfer a given heat flow rate, based on the effectiveness"
  extends Modelica.Blocks.Icons.Block;
  parameter Buildings.Fluid.Types.HeatExchangerFlowRegime flowRegime
    "Heat exchanger flow regime, see  Buildings.Fluid.Types.HeatExchangerFlowRegime";
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(min=0)
    "Thermal power at nominal conditions (>0)"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow1_nominal(min=0)
    "Source side mass flow rate at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow2_nominal(min=0)
    "Load side mass flow rate at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal
    "Source side specific heat capacity at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal
    "Load side specific heat capacity at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Boolean reverseAction=false
    "Set to true for tracking a cooling heat flow rate";
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(final k=1/Q_flow_nominal)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-40,28})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(final k=1/Q_flow_nominal)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-74,60})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMin=0,
    initType=Buildings.Controls.OBC.CDL.Types.Init.InitialOutput,
    k=1,
    Ti=10,
    reverseAction=reverseAction)
    "PID controller"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain mFloReq(k=m_flow1_nominal)
    annotation (Placement(transformation(extent={{-8,50},{12,70}})));
  Buildings.Applications.DHC.Loads.BaseClasses.HeatFlowEffectiveness heaFloEff(
    final flowRegime=flowRegime,
    final m_flow1_nominal=m_flow1_nominal,
    final m_flow2_nominal=m_flow2_nominal,
    final cp1_nominal=cp1_nominal,
    final cp2_nominal=cp2_nominal)
    annotation (Placement(transformation(extent={{64,46},{84,66}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput UA(
    quantity="ThermalConductance",
    unit="W/K",
    min=0) "Thermal conductance"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,90}),
        iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T1Inl(quantity="ThermodynamicTemperature", displayUnit="degC")
    "Source side temperature at inlet" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,10}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput T2Inl(quantity="ThermodynamicTemperature", displayUnit="degC")
    "Load side temperature at inlet"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-70}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-80})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput Q_flowReq(quantity="HeatFlowRate") "Heat flow rate to the load"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,50}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput m_flow2(quantity="MassFlowRate")
    "Load side mass flow rate"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-30}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput m_flow1(quantity="MassFlowRate")
    "Source side mass flow rate"
    annotation (Placement(transformation(extent={{100,30},{120,50}}), iconTransformation(extent={{100,40},{120,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow(quantity="HeatFlowRate")
    "Heat flow rate"
    annotation (Placement(
      transformation(extent={{100,-50},{120,-30}}), iconTransformation(extent={{100,-60},{120,-40}})));
equation
  connect(conPID.y, mFloReq.u) annotation (Line(points={{-29,60},{-24,60},{-20,60},{-10,60}}, color={0,0,127}));
  connect(gai2.y, conPID.u_s) annotation (Line(points={{-63,60},{-52,60}}, color={0,0,127}));
  connect(conPID.u_m, gai1.y) annotation (Line(points={{-40,48},{-40,39}}, color={0,0,127}));
  connect(UA, heaFloEff.UA) annotation (Line(points={{-120,90},{46,90},{46,64},{62,64}}, color={0,0,127}));
  connect(heaFloEff.Q_flow, gai1.u)
    annotation (Line(points={{85,56},{88,56},{88,0},{-40,0},{-40,16}}, color={0,0,127}));
  connect(Q_flowReq, gai2.u) annotation (Line(points={{-120,50},{-94,50},{-94,60},{-86,60}}, color={0,0,127}));
  connect(mFloReq.y, m_flow1) annotation (Line(points={{13,60},{40,60},{40,40},{110,40}}, color={0,0,127}));
  connect(heaFloEff.Q_flow, Q_flow) annotation (Line(points={{85,56},{88,56},{88,-40},{110,-40}}, color={0,0,127}));
  connect(mFloReq.y, heaFloEff.m_flow1) annotation (Line(points={{13,60},{38,60},{38,60},{62,60}}, color={0,0,127}));
  connect(T1Inl, heaFloEff.T1Inl) annotation (Line(points={{-120,10},{46,10},{46,56},{62,56}}, color={0,0,127}));
  connect(m_flow2, heaFloEff.m_flow2) annotation (Line(points={{-120,-30},{50,-30},{50,52},{62,52}}, color={0,0,127}));
  connect(T2Inl, heaFloEff.T2Inl) annotation (Line(points={{-120,-70},{54,-70},{54,48},{62,48}}, color={0,0,127}));
  annotation (
  defaultComponentName="heaOrCoo",
  Documentation(info="
  <html>
  <p>
  This model approximates the inverse of
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessDirect\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessDirect</a> by means of a control
  loop tracking the heat flow rate and outputing the required mass flow rate.
  </p>
  </html>"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,100}})),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-80},{100,100}})));
end HeatFlowControl;
