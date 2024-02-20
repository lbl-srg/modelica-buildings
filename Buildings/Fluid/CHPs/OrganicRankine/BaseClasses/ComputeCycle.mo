within Buildings.Fluid.CHPs.OrganicRankine.BaseClasses;
model ComputeCycle "Thermodynamic computations of the ORC"
  extends Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.InterpolateStates(
    TEva=TEvaWor,
    TCon=TConWor);

// Evaporator
  parameter Modelica.Units.SI.TemperatureDifference dTEvaPin_set(
    final min = 0)
    "Set evaporator pinch point temperature differential"
    annotation(Dialog(group="Evaporator"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpEva
    "Constant specific heat capacity"
    annotation(Dialog(group="Evaporator"));
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
    final unit="W") "Evaporator heat flow rate"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
                             iconTransformation(extent={{100,40},{140,80}})));
  Modelica.Units.SI.ThermodynamicTemperature TEvaOut
    "Outgoing temperature of the evaporator hot fluid";
  Modelica.Units.SI.ThermodynamicTemperature TEvaPin(
    start = TEvaWor + dTEvaPin_set)
    "Pinch point temperature of evaporator";
  Modelica.Units.SI.TemperatureDifference dTEvaPin(start = dTEvaPin_set)
    "Pinch point temperature differential of evaporator";

// Condenser
  parameter Modelica.Units.SI.TemperatureDifference dTConPin_set(
    final min = 0)
    "Set condenser pinch point temperature differential"
    annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpCon
    "Constant specific heat capacity"
    annotation(Dialog(group="Condenser"));
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
  Modelica.Units.SI.ThermodynamicTemperature TConWor =
    Buildings.Utilities.Math.Functions.smoothMax(
      x1 = TConWor_internal,
      x2 = TConWor_min,
      deltaX = 1)
    "Working fluid condensing temperature";
  parameter Modelica.Units.SI.ThermodynamicTemperature TConWor_min = 273.15
    "Lower bound of working fluid condensing temperature"
    annotation(Dialog(group="Condenser"));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QCon_flow(
    final quantity="HeatFlowRate",
    final unit="W") "Condenser heat flow rate" annotation (Placement(
        transformation(extent={{100,-80},{140,-40}}), iconTransformation(extent
          ={{100,-80},{140,-40}})));
  Modelica.Units.SI.ThermodynamicTemperature TConOut
    "Fluid temperature out of the condenser, intermediate variable";
  Modelica.Units.SI.ThermodynamicTemperature TConPin(
    start = 300)
    "Pinch point temperature of condenser";
  Modelica.Units.SI.TemperatureDifference dTConPin(start = dTConPin_set)
    "Pinch point temperature differential of condenser";

// Expander
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEleOut(
    final quantity="Power",
    final unit="W")
    = QEva_flow - QCon_flow
    "Electrical power output" annotation (Placement(transformation(
          extent={{100,-20},{140,20}}), iconTransformation(extent={{100,-20},{140,
            20}})));

// Cycle
  Modelica.Units.SI.MassFlowRate mWor_flow
    = if on then
      Buildings.Utilities.Math.Functions.regStep(
        x = mWor_flow_internal - mWor_flow_min,
        y1 = Buildings.Utilities.Math.Functions.smoothMin(
               x1 = mWor_flow_internal,
               x2 = mWor_flow_max,
               deltaX = mWor_flow_small),
        y2 = 0,
        x_small = mWor_flow_small)
    else 0
    "Mass flow rate of the working fluid"
    annotation(Dialog(group="Cycle"));
  parameter Modelica.Units.SI.MassFlowRate mWor_flow_max(
    final min = 0)
    "Upper bound of working fluid flow rate"
    annotation(Dialog(group="Cycle"));
  parameter Modelica.Units.SI.MassFlowRate mWor_flow_min(
    final min = 0)
    "Lower bound of working fluid flow rate"
    annotation(Dialog(group="Cycle"));
  parameter Modelica.Units.SI.MassFlowRate mWor_flow_small
    = mWor_flow_min * 1E-2
    "A small value for regularisation"
    annotation(Dialog(group="Cycle"));
  Modelica.Blocks.Interfaces.BooleanInput on
    "Cycle on; set false to force working fluid flow to zero"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-120,-10},{-100,10}})));

protected
  Modelica.Units.SI.MassFlowRate mWor_flow_internal(
    start = (mWor_flow_max + mWor_flow_min) / 2)
    "Intermediate variable";
  Modelica.Units.SI.ThermodynamicTemperature TEvaPin_internal
    "Intermedaite variable";
  Modelica.Units.SI.ThermodynamicTemperature TEvaOut_internal
    "intermediate variable";
  Modelica.Units.SI.HeatFlowRate QEva_flow_internal
    "Evaporator heat flow rate, intermediate variable";
  Modelica.Units.SI.ThermodynamicTemperature TConWor_internal
    "Intermedaite variable";
  Modelica.Units.SI.ThermodynamicTemperature TConPin_internal
    "Intermedaite variable";
  Modelica.Units.SI.ThermodynamicTemperature TConOut_internal
    "intermediate variable";
  Modelica.Units.SI.HeatFlowRate QCon_flow_internal
    "Condenser heat flow rate, intermediate variable";

equation

  assert(TConWor < TEvaWor - 1,
"*** In " + getInstanceName() +
": Working fluid condensing temperature is too high and close to evaporating temperature.
This is likely is a parameterisation error.");

  // Evaporator
  QEva_flow = mEva_flow * cpEva * (TEvaIn - TEvaOut);
  QEva_flow = mWor_flow * (hExpInl - hPum);
  // Pinch point
  (TEvaPin - TEvaOut) * (hExpInl - hPum)
  = (hEvaPin - hPum) * (TEvaIn - TEvaOut);
  dTEvaPin = TEvaPin - TEvaWor;

  // Evaporator internal computation
  QEva_flow_internal = mEva_flow * cpEva * (TEvaIn - TEvaOut_internal);
  QEva_flow_internal = mWor_flow_internal * (hExpInl - hPum);
  (TEvaPin_internal - TEvaOut_internal) * (hExpInl - hPum)
  = (hEvaPin - hPum) * (TEvaIn - TEvaOut_internal);
  dTEvaPin_set = TEvaPin_internal - TEvaWor;

  // Condenser
  QCon_flow = mCon_flow * cpCon * (TConOut - TConIn);
  QCon_flow = mWor_flow * (hExpOut - hPum);
  // Pinch point
  (TConPin - TConIn) * (hExpOut - hPum)
  = (hConPin - hPum) * (TConOut - TConIn);
  dTConPin = TConWor - TConPin;

  // Condenser internal computation
  QCon_flow_internal = mCon_flow * cpCon * (TConOut_internal - TConIn);
  QCon_flow_internal = mWor_flow_internal * (hExpOut - hPum);
  (TConPin_internal - TConIn) * (hExpOut - hPum)
  = (hConPin - hPum) * (TConOut_internal - TConIn);
  dTConPin_set = TConWor_internal - TConPin_internal;

  annotation(defaultComponentName="comCyc",
  Documentation(info="<html>
<p>
Adding to
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.InterpolateStates\">
Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.InterpolateStates</a>,
this model computes the pinch points, computes the energy exchange,
and interfaces the input and output variables.
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
end ComputeCycle;
