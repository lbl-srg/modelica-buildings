within Buildings.Fluid.CHPs.OrganicRankine.BaseClasses;
model FixedEvaporating
  "Thermodynamic computations of the ORC with fixed evaporating temperature"
  extends Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.InterpolateStates(
    TEva=TWorEva,
    TCon=TWorCon);

// Evaporator
  parameter Modelica.Units.SI.TemperatureDifference dTPinEva_set(
    final min = 0)
    "Set evaporator pinch point temperature differential"
    annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpHot
    "Constant specific heat capacity"
    annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.ThermodynamicTemperature TWorEva
    "Working fluid evaporator temperature"
    annotation(Dialog(group="Evaporator"));
  Modelica.Blocks.Interfaces.RealInput THotIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Incoming temperature of hot fluid in evaporator"
    annotation (Placement(
        transformation(extent={{-140,60},{-100,100}}),  iconTransformation(
          extent={{-120,70},{-100,90}})));
  Modelica.Blocks.Interfaces.RealInput mHot_flow(
    final quantity="MassFlowRate",
    final unit="kg/s") "Evaporator hot fluid flow rate"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow(
    final quantity="HeatFlowRate",
    final unit="W") "Evaporator heat flow rate"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
                             iconTransformation(extent={{100,70},{120,90}})));
  Modelica.Units.SI.ThermodynamicTemperature THotOut(
    start = TWorEva + dTPinEva_set)
    "Outgoing temperature of the evaporator hot fluid";
  Modelica.Units.SI.ThermodynamicTemperature THotPin(
    start = TWorEva + dTPinEva_set)
    "Hot fluid temperature at pinch point";
  Modelica.Units.SI.TemperatureDifference dTPinEva(start = dTPinEva_set)
    "Pinch point temperature differential of evaporator";

// Condenser
  parameter Modelica.Units.SI.TemperatureDifference dTPinCon
    "Pinch point temperature differential of condenser"
    annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpCol
    "Constant specific heat capacity"
    annotation(Dialog(group="Condenser"));
  Modelica.Blocks.Interfaces.RealInput TColIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Incoming temperature of cold fluid in condenser"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealInput mCol_flow(
    final quantity="MassFlowRate",
    final unit="kg/s") "Condenser cold fluid flow rate" annotation (Placement(
        transformation(extent={{-140,-100},{-100,-60}}), iconTransformation(
          extent={{-120,-90},{-100,-70}})));
  Modelica.Units.SI.ThermodynamicTemperature TWorCon
    "Working fluid condensing temperature";
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(
    final quantity="HeatFlowRate",
    final unit="W") "Condenser heat flow rate" annotation (Placement(
        transformation(extent={{100,-100},{140,-60}}),iconTransformation(extent={{100,-90},
            {120,-70}})));
  Modelica.Units.SI.ThermodynamicTemperature TColOut
    "Fluid temperature out of the condenser, intermediate variable";
  Modelica.Units.SI.ThermodynamicTemperature TColPin(
    start = 300)
    "Cold fluid temperature at pinch point";
  Modelica.Blocks.Interfaces.RealOutput pWorCon(
    final quantity="AbsolutePressure",
    final unit="Pa") = pCon "Working fluid condensing pressure" annotation (
      Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=-90,
        origin={70,-120}),
        iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={70,-110})));

// Expander
  Modelica.Blocks.Interfaces.RealOutput PEle(
    final quantity="Power",
    final unit="W") = mWor_flow * (hExpInl - hExpOut)
    "Electrical power output from the expander" annotation (Placement(
        transformation(extent={{100,20},{140,60}}),  iconTransformation(extent={{100,30},
            {120,50}})));

// Pump
  Modelica.Blocks.Interfaces.RealOutput PPum(
    final quantity="Power",
    final unit="W") = mWor_flow * (hPumOut - hPumInl)
    "Electrical power consumption of the pump" annotation (Placement(
        transformation(extent={{100,-60},{140,-20}}),iconTransformation(extent={
            {100,-50},{120,-30}})));

// Cycle
  Modelica.Units.SI.MassFlowRate mWor_flow =
    if ena and hys.y
    then
      Buildings.Utilities.Math.Functions.smoothMin(
      x1=mWor_flow_internal,
      x2=mWor_flow_max,
      deltaX=mWor_flow_min*1E-2)
    else 0 "Mass flow rate of the working fluid"
    annotation (Dialog(group="Cycle"));
  parameter Modelica.Units.SI.MassFlowRate mWor_flow_max(
    final min = 0)
    "Upper bound of working fluid flow rate"
    annotation(Dialog(group="Cycle"));
  parameter Modelica.Units.SI.MassFlowRate mWor_flow_min(
    final min = 0)
    "Lower bound of working fluid flow rate"
    annotation(Dialog(group="Cycle"));
  parameter Modelica.Units.SI.MassFlowRate mWor_flow_hysteresis(
    final min = 0)
    "Hysteresis for turning off the cycle when flow too low"
    annotation(Dialog(group="Cycle"));
  Modelica.Blocks.Interfaces.BooleanInput ena
    "Enable cycle; set false to force working fluid flow to zero"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Logical.Hysteresis hys(
    uLow = mWor_flow_min,
    uHigh = mWor_flow_min + mWor_flow_hysteresis,
    u = mWor_flow_internal)
    "Hysteresis for turning off cycle when working fluid flow too low";
  Modelica.Blocks.Interfaces.BooleanOutput on_actual = ena and hys.y
    "Actual on off status of the cycle" annotation (Placement(transformation(
          extent={{100,-20},{140,20}}), iconTransformation(extent={{100,-10},{120,
            10}})));

protected
  Modelica.Units.SI.MassFlowRate mWor_flow_internal(
    start = (mWor_flow_max + mWor_flow_min) / 2)
    "Working fluid flow rate, intermediate variable";
  Modelica.Units.SI.ThermodynamicTemperature THotPin_internal
    "Hot fluid temperature at pinch point, intermedaite variable";
  Modelica.Units.SI.ThermodynamicTemperature THotOut_internal
    "Hot fluid outgoing temperature, intermediate variable";
  Modelica.Units.SI.HeatFlowRate QEva_flow_internal
    "Evaporator heat flow rate, intermediate variable";

equation

  assert(TWorCon < TWorEva - 1,
"*** In " + getInstanceName() +
": Working fluid condensing temperature is too high and close to evaporating temperature.
This is likely caused by the flow rate of cooling fluid in the condenser being too low.");

  // Evaporator
  QEva_flow = mHot_flow * cpHot * (THotIn - THotOut);
  QEva_flow = mWor_flow * (hExpInl - hPumOut);
  // Pinch point
  (THotPin - THotOut) * (hExpInl - hPumOut)
  = (hPinEva - hPumOut) * (THotIn - THotOut);
  dTPinEva = THotPin - TWorEva;

  // Evaporator internal computation
  QEva_flow_internal = mHot_flow * cpHot * (THotIn - THotOut_internal);
  QEva_flow_internal = mWor_flow_internal * (hExpInl - hPumOut);
  (THotPin_internal - THotOut_internal) * (hExpInl - hPumOut)
  = (hPinEva - hPumOut) * (THotIn - THotOut_internal);
  dTPinEva_set = THotPin_internal - TWorEva;

  // Condenser
  QCon_flow = mCol_flow * cpCol * (TColOut - TColIn);
  QCon_flow = mWor_flow * (hExpOut - hPumInl);
  // Pinch point
  (TColPin - TColIn) * (hExpOut - hPumInl)
  = (hPinCon - hPumInl) * (TColOut - TColIn);
  dTPinCon = TWorCon - TColPin;

  annotation(defaultComponentName="cyc",
  Documentation(info="<html>
<p>
Adding to
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.InterpolateStates\">
Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.InterpolateStates</a>,
this model computes the pinch points, computes the energy exchange,
and interfaces the input and output variables.
The evaporating temperature is fixed as a parameter at this level.
See the documentation of
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.Cycle\">
Buildings.Fluid.CHPs.OrganicRankine.Cycle</a>
for more details.
</html>", revisions="<html>
<ul>
<li>
January 29, 2024, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"),
    Icon(graphics={Line(
          points={{-28,20},{66,50}},
          color={238,46,47},
          thickness=1), Line(
          points={{-30,-54},{64,-24}},
          color={28,108,200},
          thickness=1)}));
end FixedEvaporating;
