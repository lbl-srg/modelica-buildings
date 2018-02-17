within Buildings.Fluid.Sources.BaseClasses;
partial model PartialSource
  "Partial component source with one fluid connector"

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium
      "Medium model within the source"
     annotation (choicesAllMatching=true);

  parameter Integer nPorts=0 "Number of ports" annotation(Dialog(connectorSizing=true));
  parameter Boolean verifyInputs = false
    " = true, to enable verification check of inputs"
    annotation(Dialog(tab="Advanced"));

  Modelica.Fluid.Interfaces.FluidPorts_b ports[nPorts](
    redeclare each package Medium = Medium,
    m_flow(each max=if flowDirection == Modelica.Fluid.Types.PortFlowDirection.Leaving
             then 0 else +Modelica.Constants.inf,
           each min=if flowDirection == Modelica.Fluid.Types.PortFlowDirection.Entering
           then 0 else -Modelica.Constants.inf))
    annotation (Placement(transformation(extent={{90,40},{110,-40}})));

protected
  parameter Modelica.Fluid.Types.PortFlowDirection flowDirection=Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Allowed flow direction" annotation (Evaluate=true, Dialog(tab="Advanced"));
  Modelica.Blocks.Interfaces.RealInput p_in_internal(final unit="Pa")
    "Needed to connect to conditional connector";
  Medium.BaseProperties medium if verifyInputs "Medium in the source";
  Modelica.Blocks.Interfaces.RealInput Xi_in_internal[Medium.nXi](
    each final unit = "kg/kg")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput X_in_internal[Medium.nX](
    each final unit = "kg/kg")
    "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput C_in_internal[Medium.nC](
    final quantity=Medium.extraPropertiesNames)
    "Needed to connect to conditional connector";


initial equation
  // Only one connection allowed to a port to avoid unwanted ideal mixing
  for i in 1:nPorts loop
    assert(cardinality(ports[i]) <= 1,"
Each ports[i] of boundary shall at most be connected to one component.
If two or more connections are present, ideal mixing takes
place in these connections, which is usually not the intention
of the modeller. Increase nPorts to add an additional port.
");
  end for;

equation
  connect(medium.p, p_in_internal);
  annotation (defaultComponentName="boundary",
  Documentation(info="<html>
<p>
Partial model for a fluid source that either prescribes
pressure or mass flow rate.
Extending partials prescribe the outflowing
specific enthalpy, composition and trace substances.
This partial only declares the <code>ports</code>
and ensures that the pressures at all ports are equal.
</p>
</html>", revisions="<html>
<ul>
<li>
February 2nd, 2018 by Filip Jorissen<br/>
Initial version for refactoring inputs of sources.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/882\">#882</a>.
</li>
</ul>
</html>"));
end PartialSource;
