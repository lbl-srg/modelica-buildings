within Buildings.Applications.DataCenters.LiquidCooled.CDUs.BaseClasses;
partial model PartialFourPortInterface
  "Partial model with four ports and declaration of quantities that are used by many models"
  extends Buildings.Fluid.Interfaces.PartialFourPort;
  parameter Modelica.Units.SI.MassFlowRate mPla_flow_nominal(min=0)
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mRac_flow_nominal(min=0)
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));
  parameter MediumPla.MassFlowRate mPla_flow_small(min=0) = 1E-4*abs(mPla_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  parameter MediumRac.MassFlowRate mRac_flow_small(min=0) = 1E-4*abs(mRac_flow_nominal)
    "Small mass flow rate for regularization of zero flow"
    annotation(Dialog(tab = "Advanced"));
  // Diagnostics
  parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation (
      Dialog(tab="Advanced", group="Diagnostics"),
      HideResult=true);

  MediumPla.MassFlowRate mPla_flow = port_aPla.m_flow
    "Mass flow rate from port_aPla to port_bPla (mPla_flow > 0 is design flow direction)";
  Modelica.Units.SI.PressureDifference dpPla(displayUnit="Pa") = port_aPla.p - port_bPla.p
    "Pressure difference between port_aPla and port_bPla";

  MediumRac.MassFlowRate mRac_flow = port_aRac.m_flow
    "Mass flow rate from port_aRac to port_bRac (mRac_flow > 0 is design flow direction)";
  Modelica.Units.SI.PressureDifference dpRac(displayUnit="Pa") = port_aRac.p - port_bRac.p
    "Pressure difference between port_aRac and port_bRac";

  MediumPla.ThermodynamicState sta_aPla=
    if allowFlowReversalPla then
      MediumPla.setState_phX(port_aPla.p,
                          noEvent(actualStream(port_aPla.h_outflow)),
                          noEvent(actualStream(port_aPla.Xi_outflow)))
    else
      MediumPla.setState_phX(port_aPla.p,
                          inStream(port_aPla.h_outflow),
                          inStream(port_aPla.Xi_outflow))
      if show_T "Medium properties in port_aPla";
  MediumPla.ThermodynamicState sta_bPla=
    if allowFlowReversalPla then
      MediumPla.setState_phX(port_bPla.p,
                          noEvent(actualStream(port_bPla.h_outflow)),
                          noEvent(actualStream(port_bPla.Xi_outflow)))
    else
      MediumPla.setState_phX(port_bPla.p,
                          port_bPla.h_outflow,
                          port_bPla.Xi_outflow)
       if show_T "Medium properties in port_bPla";

  MediumRac.ThermodynamicState sta_aRac=
    if allowFlowReversalRac then
      MediumRac.setState_phX(port_aRac.p,
                          noEvent(actualStream(port_aRac.h_outflow)),
                          noEvent(actualStream(port_aRac.Xi_outflow)))
    else
      MediumRac.setState_phX(port_aRac.p,
                          inStream(port_aRac.h_outflow),
                          inStream(port_aRac.Xi_outflow))
      if show_T "Medium properties in port_aRac";
  MediumRac.ThermodynamicState sta_bRac=
    if allowFlowReversalRac then
      MediumRac.setState_phX(port_bRac.p,
                          noEvent(actualStream(port_bRac.h_outflow)),
                          noEvent(actualStream(port_bRac.Xi_outflow)))
    else
      MediumRac.setState_phX(port_bRac.p,
                          port_bRac.h_outflow,
                          port_bRac.Xi_outflow)
       if show_T "Medium properties in port_bRac";

protected
  MediumPla.ThermodynamicState state_aPla_inflow=
    MediumPla.setState_phX(port_aPla.p, inStream(port_aPla.h_outflow), inStream(port_aPla.Xi_outflow))
    "state for medium inflowing through port_aPla";
  MediumPla.ThermodynamicState state_bPla_inflow=
    MediumPla.setState_phX(port_bPla.p, inStream(port_bPla.h_outflow), inStream(port_bPla.Xi_outflow))
    "state for medium inflowing through port_bPla";
  MediumRac.ThermodynamicState state_aRac_inflow=
    MediumRac.setState_phX(port_aRac.p, inStream(port_aRac.h_outflow), inStream(port_aRac.Xi_outflow))
    "state for medium inflowing through port_aRac";
  MediumRac.ThermodynamicState state_bRac_inflow=
    MediumRac.setState_phX(port_bRac.p, inStream(port_bRac.h_outflow), inStream(port_bRac.Xi_outflow))
    "state for medium inflowing through port_bRac";

  annotation (
  preferredView="info",
    Documentation(info="<html>
<p>
This component defines the interface for models with four fluid ports
and two fluid streams.
It is similar to
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialTwoPortInterface\">
Buildings.Fluid.Interfaces.PartialTwoPortInterface</a>,
but it has four ports instead of two.
</p>
<p>
The model is used by other models in this package that add heat transfer,
mass transfer and pressure drop equations.
</p>
</html>", revisions="<html>
<ul>
<li>
April 21, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialFourPortInterface;
