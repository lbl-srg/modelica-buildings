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
    "Heating heat flow rate transferred to the loads (>=0)"
    annotation (Placement(transformation(extent={{300,260},{340,300}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QCoo_flow(
    final quantity="HeatFlowRate", final unit="W")
    "Cooling heat flow rate transferred to the loads (<=0)"
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
  Partial model for connecting loads at uniform temperature with a hot water and a chilled water loop
  by means of two arrays of heat ports: one for heating, the other for cooling.
  It is typically used in conjunction with
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.HeatingOrCooling</a>.
  </p>
  <p>
  Models that extend from this model must:
  </p>
  <ul>
  <li>
  specify a method to compute the temperature of the load. The following predefined types are implemented:
    <ul>
    <li>
    Thermal model with heat port: the derived model provides the system of equations to compute the load
    temperature which is exposed through a heat port. This heat port must be connected to the heat ports of the
    partial model in order to transfer the sensible heat flow rate from the water loop to the load.
    See <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.Examples.CouplingRC\">
    Buildings.DistrictEnergySystem.Loads.Examples.CouplingRC</a> for a typical example.
    </li>
    <li>
    Temperature based on first order ODE: this method is implemented in
    <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE\">
    Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE</a>
    which gets conditionally instantiated and connected as many times as this predefined type is selected.
    See <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.Examples.CouplingTimeSeries\">
    Buildings.DistrictEnergySystem.Loads.Examples.CouplingTimeSeries</a> for a typical example.
    </li>
    <li>
    Prescribed temperature: this method uses
    <a href=\"modelica://Buildings.HeatTransfer.Sources.PrescribedTemperature\">
    Buildings.HeatTransfer.Sources.PrescribedTemperature</a>
    which gets conditionally instantiated and connected as many times as this predefined type is selected.
    See <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.Examples.CouplingTimeSeries\">
    Buildings.DistrictEnergySystem.Loads.Examples.CouplingTimeSeries</a> for a typical example.
    </li>
    </ul>
  </li>
  <li>
  provide the heating and cooling heat flow rate required to maintain the load temperature setpoint. The
  corresponding variables must be connected to the output connectors <code>Q_flowHeaReq</code> and
  <code>Q_flowCooReq</code>.
  </li>
  </ul>
  <p>
  The other output connectors <code>Q_flowHeaAct</code> and <code>Q_flowCooAct</code> correspond to the actual
  heat flow rates exchanged with the water loops.
  They are provided as a simple means of accessing the heat flow rate of each heat port from a higher level of
  composition.
  </p>
  </html>"),
  Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100}, {100,100}})),
  Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-300,-300},{300,300}})));
end PartialBuilding;
