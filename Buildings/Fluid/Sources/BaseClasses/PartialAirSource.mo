within Buildings.Fluid.Sources.BaseClasses;
partial model PartialAirSource
  "Partial component air source with one fluid connector"

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air")));

  parameter Integer nPorts=0 "Number of ports" annotation(Dialog(connectorSizing=true));
  parameter Boolean verifyInputs = false
    "Set to true to stop the simulation with an error if the medium temperature is outside its allowable range"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  Modelica.Fluid.Interfaces.FluidPorts_b ports[nPorts](
    redeclare each package Medium = Medium,
    each m_flow(max=if flowDirection == Modelica.Fluid.Types.PortFlowDirection.Leaving
                    then 0 else +Modelica.Constants.inf,
                min=if flowDirection == Modelica.Fluid.Types.PortFlowDirection.Entering
                    then 0 else -Modelica.Constants.inf),
    each h_outflow(nominal=Medium.h_default),
    each Xi_outflow(each nominal=0.01))
    "Fluid ports"
    annotation (Placement(transformation(extent={{90,40},{110,-40}})));

protected
  parameter Modelica.Fluid.Types.PortFlowDirection flowDirection=Modelica.Fluid.Types.PortFlowDirection.Bidirectional
    "Allowed flow direction" annotation (Evaluate=true, Dialog(tab="Advanced"));
  Modelica.Blocks.Interfaces.RealInput p_in_internal(final unit="Pa")
    "Needed to connect to conditional connector";
  Medium.BaseProperties medium(
      T(start=Medium.T_default)
    ) if verifyInputs "Medium in the source";
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

  annotation (defaultComponentName="bou",
  Documentation(info="<html>
<p>
Partial model for a moist air source that either prescribes
pressure or mass flow rate.
Models that extend this partial model need to prescribe the outflowing
specific enthalpy, composition and trace substances.
This partial model only declares the <code>ports</code>
and ensures that the pressures at all ports are equal.
</p>
<h4>Implementation</h4>
<p>
If the parameter <code>verifyInputs</code> is set to <code>true</code>,
then a protected instance of medium base properties is enabled.
This instance verifies that the
medium temperature is within the bounds <code>T_min</code> and <code>T_max</code>,
where <code>T_min</code> and <code>T_max</code> are constants of the <code>Medium</code>.
If the temperature is outside these bounds, the simulation will stop with an error.
</p>
<h4>Usage</h4>
<p>
This partial model provides medium selection for moist air.
For a model that only provides for water, moist air and glycol as a selection, use
<a href=\"modelica://Buildings.Fluid.Sources.BaseClasses.PartialSource\">
Buildings.Fluid.Sources.BaseClasses.PartialSource</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
January 09, 2023, by Jianjun Hu:<br/>
First implementation, specifically for the moist air source.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1681\">IBPSA, #1681</a>.
</li>
</ul>
</html>"));
end PartialAirSource;
