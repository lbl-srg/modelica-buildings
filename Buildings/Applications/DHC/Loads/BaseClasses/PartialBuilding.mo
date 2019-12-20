within Buildings.Applications.DHC.Loads.BaseClasses;
partial model PartialBuilding "Partial class for building model"
  // Find a way to specify medium for each connected load.
  replaceable package Medium1 =
    Buildings.Media.Water
    "Source side medium"
    annotation(choices(
      choice(redeclare package Medium1 = Buildings.Media.Water "Water"),
      choice(redeclare package Medium1 =
        Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T=293.15, X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  parameter Integer nPorts1 = 0
    "Number of source fluid streams"
     annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter Boolean haveFan
    "Set to true if fans drawn power is computed"
    annotation(Evaluate=true);
  parameter Boolean havePum
    "Set to true if pumps drawn power is computed"
    annotation(Evaluate=true);
  parameter Boolean haveEleHea
    "Set to true if the building has electric heating"
    annotation(Evaluate=true);
  parameter Boolean haveEleCoo
    "Set to true if the building has electric cooling"
    annotation(Evaluate=true);
  final parameter Boolean allowFlowReversal=false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Evaluate=true);
  Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(
    transformation(extent={{-16,284},{18,316}}),
    iconTransformation(extent={{-16,84},{18,116}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_a1[nPorts1](
    redeclare each package Medium = Medium1,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium1.h_default, nominal=Medium1.h_default))
    "Fluid connectors b (positive design flow direction is from port_a to ports_b)"
    annotation (Placement(transformation(extent={{-310,-40},{-290,40}}),
      iconTransformation(extent={{-110,-100},{-90,-20}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b1[nPorts1](
    redeclare each package Medium = Medium1,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium1.h_default, nominal=Medium1.h_default))
    "Fluid connectors b (positive design flow direction is from port_a to ports_b)"
    annotation (Placement(transformation(extent={{290,-40},{310,40}}),
      iconTransformation(extent={{90,-100},{110,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QHea_flow(
    final quantity="HeatFlowRate", final unit="W")
    "Total heating heat flow rate transferred to the loads (>=0)"
    annotation (Placement(transformation(extent={{300,260},{340,300}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QCoo_flow(
    final quantity="HeatFlowRate", final unit="W")
    "Total cooling heat flow rate transferred to the loads (<=0)"
    annotation (Placement(transformation(extent={{300,220},{340,260}}),
        iconTransformation(extent={{100,50},{140,90}})));
  Modelica.Blocks.Interfaces.RealOutput PHea(
    final quantity="Power", final unit="W") if haveEleHea
    "Power drawn by heating equipment"
    annotation (Placement(transformation(
      extent={{300,180},{340,220}}), iconTransformation(extent={{100,40},{120,60}})));
  Modelica.Blocks.Interfaces.RealOutput PCoo(
    quantity="Power", final unit="W") if haveEleCoo
    "Power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{300,140},{340,180}}),
      iconTransformation(extent={{100,20},{120,40}})));
  Modelica.Blocks.Interfaces.RealOutput PFan(
    final quantity="Power", final unit="W") if haveFan
    "Power drawn by fans motors"
    annotation (Placement(transformation(extent={{300,100},{340,140}}),
      iconTransformation(extent={{100,0},{120,20}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(
    final quantity="Power", final unit="W") if havePum
    "Power drawn by pumps motors"
    annotation (Placement(transformation(extent={{300,60},{340,100}}),
      iconTransformation(extent={{100,-20},{120,0}})));
  annotation (
  defaultComponentName="heaFloEps",
  Documentation(info="<html>
<p>
Partial model to be used for modeling the building loads to be served by an energy
transfer station and/or a dedicated plant.
The fluid ports represent the connection between the production system and
the distribution system.
Every mechanical system downstream that connection should be modeled within a
component derived from that partial model.
</p>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100}, {100,100}})),
  Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-300,-300},{300,300}})));
end PartialBuilding;
