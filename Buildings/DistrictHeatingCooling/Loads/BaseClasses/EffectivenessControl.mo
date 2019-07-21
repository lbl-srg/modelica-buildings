within Buildings.DistrictHeatingCooling.Loads.BaseClasses;
model EffectivenessControl
  "Model computing the mass flow rate required to transfer a given heat flow rate, based on the effectiveness"
  extends Modelica.Blocks.Icons.Block;
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(min=0)
    "Thermal power at nominal conditions (>0)"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal(min=0)
    "Mass flow rate at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Boolean reverseAction=false
    "Set to true for tracking a cooling heat flow rate";
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1(k=-1/Q_flow_nominal)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=270,
        origin={-40,28})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2(k=1/Q_flow_nominal)
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
  Buildings.Controls.OBC.CDL.Continuous.Gain mFloReq(k=m_flow_nominal)
    annotation (Placement(transformation(extent={{-8,50},{12,70}})));
  Buildings.DistrictHeatingCooling.Loads.BaseClasses.EffectivenessDirect effDir(final m_flow_nominal=m_flow_nominal)
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TInl(quantity="ThermodynamicTemperature", displayUnit="degC")
    "Fluid inlet temperature"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,10}),  iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,0})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput cpInl(quantity="SpecificHeatCapacity")
    "Fluid inlet specific heat capacity"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-30}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TLoad(quantity="ThermodynamicTemperature", displayUnit="degC")
    "Temperature of the load"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-70}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,-80})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput Q_flowReq(quantity="HeatFlowRate")
    "Heat flow rate"
    annotation (Placement(
        transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,50}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,40})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput m_flow(quantity="MassFlowRate")
    "Mass flow rate"
    annotation (Placement(transformation(extent={{100,30},{120,50}}), iconTransformation(extent={{100,40},{120,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flow(quantity="HeatFlowRate")
    "Heat flow rate"
    annotation (Placement(
      transformation(extent={{100,-50},{120,-30}}), iconTransformation(extent={{100,-60},{120,-40}})));
equation
  connect(conPID.y, mFloReq.u) annotation (Line(points={{-29,60},{-24,60},{-20,60},{-10,60}},
                                                                            color={0,0,127}));
  connect(gai2.y, conPID.u_s) annotation (Line(points={{-63,60},{-52,60}}, color={0,0,127}));
  connect(conPID.u_m, gai1.y) annotation (Line(points={{-40,48},{-40,39}}, color={0,0,127}));
  connect(UA, effDir.UA) annotation (Line(points={{-120,90},{46,90},{46,64},{62,64}}, color={0,0,127}));
  connect(effDir.Q_flow, gai1.u) annotation (Line(points={{85,56},{88,56},{88,0},{-40,0},{-40,16}}, color={0,0,127}));
  connect(Q_flowReq, gai2.u) annotation (Line(points={{-120,50},{-94,50},{-94,60},{-86,60}}, color={0,0,127}));
  connect(mFloReq.y, effDir.m_flow) annotation (Line(points={{13,60},{26,60},{38,60},{62,60}}, color={0,0,127}));
  connect(mFloReq.y, m_flow) annotation (Line(points={{13,60},{40,60},{40,40},{110,40}}, color={0,0,127}));
  connect(cpInl, effDir.cpInl) annotation (Line(points={{-120,-30},{52,-30},{52,52},{62,52}}, color={0,0,127}));
  connect(TLoad, effDir.TLoad) annotation (Line(points={{-120,-70},{56,-70},{56,48},{62,48}}, color={0,0,127}));
  connect(effDir.Q_flow, Q_flow) annotation (Line(points={{85,56},{88,56},{88,-40},{110,-40}}, color={0,0,127}));
  connect(TInl, effDir.TInl)
  annotation (Line(points={{-120,10},{-86,10},{-86,-10},{46,-10},{46,56},{62,56}}, color={0,0,127}));
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
end EffectivenessControl;
