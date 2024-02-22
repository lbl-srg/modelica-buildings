within Buildings.Fluid.CHPs.OrganicRankine.BaseClasses;
model ComputeCycle "Thermodynamic computations of the ORC"
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
  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Incoming temperature of hot fluid in evaporator"
    annotation (Placement(
        transformation(extent={{-140,60},{-100,100}}),  iconTransformation(
          extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mHot_flow(
    final quantity="MassFlowRate",
    final unit="kg/s") "Evaporator hot fluid flow rate"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QEva_flow(
    final quantity="HeatFlowRate",
    final unit="W") "Evaporator heat flow rate"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
                             iconTransformation(extent={{100,40},{140,80}})));
  Modelica.Units.SI.ThermodynamicTemperature THotOut
    "Outgoing temperature of the evaporator hot fluid";
  Modelica.Units.SI.ThermodynamicTemperature TPinEva(
    start = TWorEva + dTPinEva_set)
    "Pinch point temperature of evaporator";
  Modelica.Units.SI.TemperatureDifference dTPinEva(start = dTPinEva_set)
    "Pinch point temperature differential of evaporator";

// Condenser
  parameter Modelica.Units.SI.TemperatureDifference dTPinCon_set(
    final min = 0)
    "Set condenser pinch point temperature differential"
    annotation(Dialog(group="Condenser"));
  parameter Modelica.Units.SI.SpecificHeatCapacity cpCol
    "Constant specific heat capacity"
    annotation(Dialog(group="Condenser"));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TColIn(
    final quantity="ThermodynamicTemperature",
    final unit="K",
    displayUnit="degC") "Incoming temperature of cold fluid in condenser"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mCol_flow(
    final quantity="MassFlowRate",
    final unit="kg/s") "Condenser cold fluid flow rate" annotation (Placement(
        transformation(extent={{-140,-100},{-100,-60}}), iconTransformation(
          extent={{-140,-100},{-100,-60}})));
  Modelica.Units.SI.ThermodynamicTemperature TWorCon =
    Buildings.Utilities.Math.Functions.smoothMax(
      x1 = TWorCon_internal,
      x2 = TWorCon_min,
      deltaX = 1)
    "Working fluid condensing temperature";
  parameter Modelica.Units.SI.ThermodynamicTemperature TWorCon_min = 273.15
    "Lower bound of working fluid condensing temperature"
    annotation(Dialog(group="Condenser"));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QCon_flow(
    final quantity="HeatFlowRate",
    final unit="W") "Condenser heat flow rate" annotation (Placement(
        transformation(extent={{100,-80},{140,-40}}), iconTransformation(extent
          ={{100,-80},{140,-40}})));
  Modelica.Units.SI.ThermodynamicTemperature TColOut
    "Fluid temperature out of the condenser, intermediate variable";
  Modelica.Units.SI.ThermodynamicTemperature TPinCon(
    start = 300)
    "Pinch point temperature of condenser";
  Modelica.Units.SI.TemperatureDifference dTPinCon(start = dTPinCon_set)
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
  Modelica.Units.SI.ThermodynamicTemperature TPinEva_internal
    "Intermedaite variable";
  Modelica.Units.SI.ThermodynamicTemperature THotOut_internal
    "intermediate variable";
  Modelica.Units.SI.HeatFlowRate QEva_flow_internal
    "Evaporator heat flow rate, intermediate variable";
  Modelica.Units.SI.ThermodynamicTemperature TWorCon_internal
    "Intermedaite variable";
  Modelica.Units.SI.ThermodynamicTemperature TPinCon_internal
    "Intermedaite variable";
  Modelica.Units.SI.ThermodynamicTemperature TColOut_internal
    "intermediate variable";
  Modelica.Units.SI.HeatFlowRate QCon_flow_internal
    "Condenser heat flow rate, intermediate variable";

equation

  assert(TWorCon < TWorEva - 1,
"*** In " + getInstanceName() +
": Working fluid condensing temperature is too high and close to evaporating temperature.
This is likely caused by the flow rate of cooling fluid in the condenser being too low.");

  // Evaporator
  QEva_flow = mHot_flow * cpHot * (THotIn - THotOut);
  QEva_flow = mWor_flow * (hExpInl - hPum);
  // Pinch point
  (TPinEva - THotOut) * (hExpInl - hPum)
  = (hEvaPin - hPum) * (THotIn - THotOut);
  dTPinEva = TPinEva - TWorEva;

  // Evaporator internal computation
  QEva_flow_internal = mHot_flow * cpHot * (THotIn - THotOut_internal);
  QEva_flow_internal = mWor_flow_internal * (hExpInl - hPum);
  (TPinEva_internal - THotOut_internal) * (hExpInl - hPum)
  = (hEvaPin - hPum) * (THotIn - THotOut_internal);
  dTPinEva_set = TPinEva_internal - TWorEva;

  // Condenser
  QCon_flow = mCol_flow * cpCol * (TColOut - TColIn);
  QCon_flow = mWor_flow * (hExpOut - hPum);
  // Pinch point
  (TPinCon - TColIn) * (hExpOut - hPum)
  = (hConPin - hPum) * (TColOut - TColIn);
  dTPinCon = TWorCon - TPinCon;

  // Condenser internal computation
  QCon_flow_internal = mCol_flow * cpCol * (TColOut_internal - TColIn);
  QCon_flow_internal = mWor_flow_internal * (hExpOut - hPum);
  (TPinCon_internal - TColIn) * (hExpOut - hPum)
  = (hConPin - hPum) * (TColOut_internal - TColIn);
  dTPinCon_set = TWorCon_internal - TPinCon_internal;

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
