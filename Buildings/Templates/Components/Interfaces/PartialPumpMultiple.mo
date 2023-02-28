within Buildings.Templates.Components.Interfaces;
partial model PartialPumpMultiple
  "Interface class for multiple pumps in parallel arrangement"
  extends Buildings.Templates.Components.Interfaces.PartialPump;

  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation(__Linkage(enable=false));

  parameter Integer nPum(
    final min=0,
    start=1)
    "Number of pumps"
    annotation (Dialog(group="Configuration",
    enable=typ<>Buildings.Templates.Components.Types.Pump.None));

  parameter Buildings.Templates.Components.Data.PumpMultiple dat(
    final nPum=nPum,
    final typ=typ)
    "Design and operating parameters"
    annotation(__Linkage(enable=false));

  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal[nPum](
    each final min=0)=dat.m_flow_nominal
    "Nominal mass flow rate"
    annotation (Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.Components.Types.Pump.None));
  final parameter Modelica.Units.SI.PressureDifference dp_nominal[nPum](
    each final min=0,
    each displayUnit="Pa")=dat.dp_nominal
    "Pump head at design conditions"
    annotation (Dialog(group="Nominal condition",
      enable=typ<>Buildings.Templates.Components.Types.Pump.None));

  Modelica.Fluid.Interfaces.FluidPorts_a ports_a[nPum](
    redeclare each final package Medium = Medium,
     each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
     each h_outflow(start = Medium.h_default, nominal = Medium.h_default),
    each p(start=Medium.p_default))
     "Vectorized fluid connector a (positive design flow direction is from port(s)_a to port(s)_b)"
     annotation (Placement(
        transformation(extent={{-110,-40},{-90,40}}), iconTransformation(extent={{-110,
            -40},{-90,40}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b[nPum](
    redeclare each final package Medium = Medium,
     each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
     each h_outflow(start = Medium.h_default, nominal = Medium.h_default),
    each p(start=Medium.p_default))
     "Vectorized fluid connector b (positive design flow direction is from port(s)_a to port(s)_b)"
     annotation (Placement(
        transformation(extent={{90,-40},{110,40}}), iconTransformation(extent={{90,-40},
            {110,40}})));
  annotation (Documentation(info="<html>
<p>
This partial class provides a standard interface for models
of multiple pumps in parallel arrangement.
Note that the inlet and outlet manifolds are not included
in this model. This way, the same interface can be used to model
both headered pumps and dedicated pumps.
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2022, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialPumpMultiple;
