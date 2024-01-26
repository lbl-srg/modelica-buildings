within Buildings.Fluid.CHPs.OrganicRankine.BaseClasses;
model ComputeCycle "Thermodynamic computations of the ORC"
  extends Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.InterpolateStates(
    TEva=TEvaWor,
    TCon=TConWor);

// Evaporator
  parameter Modelica.Units.SI.TemperatureDifference dTEvaPin_set(
    final min = 0)
    "Set evaporator pinch point temperature differential";
  parameter Modelica.Units.SI.SpecificHeatCapacity cpEva
    "Constant specific heat capacity";
  parameter Modelica.Units.SI.ThermodynamicTemperature TEvaWor
    "Working fluid evaporator temperature"
    annotation(Dialog(group="Evaporator"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TEvaIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Incoming temperature of hot fluid in evaporator"
    annotation (Placement(
        transformation(extent={{-140,60},{-100,100}}),  iconTransformation(
          extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mEva_flow(
    final quantity="MassFlowRate",
    final unit="kg/s") "Evaporator hot fluid flow rate"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QEva_flow(
    final quantity="HeatFlowRate",
    final unit="W")
    = - QEva_flow_internal
                        "Evaporator heat flow rate"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
                             iconTransformation(extent={{100,40},{140,80}})));
  Modelica.Units.SI.ThermodynamicTemperature TEvaOut_internal
    "Fluid temperature out of the evaporator, intermediate variable";
  Modelica.Units.SI.HeatFlowRate QEva_flow_internal
    "Evaporator heat flow rate, intermediate variable";
  Modelica.Units.SI.ThermodynamicTemperature TEvaPin(
    start = TEvaWor + dTEvaPin_set)
    "Pinch point temperature of evaporator";
  Modelica.Units.SI.TemperatureDifference dTEvaPin
    "Pinch point temperature differential of evaporator";

// Condenser
  parameter Modelica.Units.SI.TemperatureDifference dTConPin_set(
    final min = 0)
    "Set condenser pinch point temperature differential"
    annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpCon
    "Constant specific heat capacity";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Incoming temperature of cold fluid in condenser"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mCon_flow(
    final quantity="MassFlowRate",
    final unit="kg/s") "Condenser cold fluid flow rate" annotation (Placement(
        transformation(extent={{-140,-100},{-100,-60}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  Modelica.Units.SI.ThermodynamicTemperature TConWor
    "Working fluid condenser temperature";
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QCon_flow(
    final quantity="HeatFlowRate",
    final unit="W")
    = QCon_flow_internal
                        "Condenser heat flow rate" annotation (Placement(
        transformation(extent={{100,-80},{140,-40}}), iconTransformation(extent
          ={{100,-80},{140,-40}})));
  Modelica.Units.SI.ThermodynamicTemperature TConOut_internal
    "Fluid temperature out of the condenser, intermediate variable";
  Modelica.Units.SI.HeatFlowRate QCon_flow_internal
    "Condenser heat flow rate, intermediate variable";
  Modelica.Units.SI.ThermodynamicTemperature TConPin(
    start = 300)
    "Pinch point temperature of condenser";
  Modelica.Units.SI.TemperatureDifference dTConPin = dTConPin_set
    "Pinch point temperature differential of condenser";

// Expander
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEleOut(
    final quantity="Power",
    final unit="W")
    = - QEva_flow + QCon_flow
    "Electrical power output" annotation (Placement(transformation(
          extent={{100,-20},{140,20}}), iconTransformation(extent={{100,-20},{140,
            20}})));

// Cycle
  parameter Modelica.Units.SI.MassFlowRate mWor_flow_max(
    final min = 0)
    "Upper bound of working fluid flow rate";
  parameter Modelica.Units.SI.MassFlowRate mWor_flow_min(
    final min = 0)
    "Lower bound of working fluid flow rate";
  Buildings.Controls.Continuous.LimPID conPI(
    Td=1,
    k=5,
    Ti=15,
    reverseActing=false)
           annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  Modelica.Blocks.Sources.RealExpression u_s(y=dTEvaPin_set)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Modelica.Blocks.Sources.RealExpression u_m(y=dTEvaPin)
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=mWor_flow_max) "Gain"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Modelica.Units.SI.MassFlowRate mWor_flow = gai.y
    "Mass flow rate of the working fluid";

equation
  // Evaporator
  QEva_flow_internal = mEva_flow * cpEva * (TEvaIn - TEvaOut_internal);
  QEva_flow_internal = mWor_flow * (hExpInl - hPum);
  // Pinch point
  (TEvaPin - TEvaOut_internal) * (hExpInl - hPum)
  = (hEvaPin - hPum) * (TEvaIn - TEvaOut_internal);
  dTEvaPin = TEvaPin - TEvaWor;

  // Condenser
  QCon_flow_internal = mCon_flow * cpCon * (TConOut_internal - TConIn);
  QCon_flow_internal = mWor_flow * (hExpOut - hPum);
  // Pinch point
  (TConPin - TConIn) * (hExpOut - hPum)
  =(hConPin - hPum) * (TConOut_internal - TConIn);
  dTConPin = TConWor - TConPin;

  connect(u_s.y,conPI. u_s)
    annotation (Line(points={{-19,30},{-12,30}},
                                               color={0,0,127}));
  connect(u_m.y,conPI. u_m)
    annotation (Line(points={{-19,-10},{0,-10},{0,18}},  color={0,0,127}));
  connect(gai.u,conPI. y)
    annotation (Line(points={{18,30},{11,30}}, color={0,0,127}));
end ComputeCycle;
