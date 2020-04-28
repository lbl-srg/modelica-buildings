within Buildings.Applications.DHC.EnergyTransferStations.BaseClasses;
partial model PartialETS "Partial class for energy transfer station model"
  replaceable package MediumBui = Modelica.Media.Interfaces.PartialMedium
    "Building side medium"
    annotation(choices(
      choice(redeclare package Medium = Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40) "Propylene glycol water, 40% mass fraction")));
  replaceable package MediumDis = Modelica.Media.Interfaces.PartialMedium
    "District side medium"
    annotation(choices(
      choice(redeclare package Medium = Buildings.Media.Water "Water"),
      choice(redeclare package Medium =
        Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15, X_a=0.40) "Propylene glycol water, 40% mass fraction")));
  parameter Integer nPorts_aBui = 0
    "Number of building services return ports"
     annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter Integer nPorts_bBui = 0
    "Number of building services supply ports"
     annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter Boolean have_heaWat = true
    "Set to true if the ETS supplies heating water"
    annotation(Evaluate=true);
  parameter Boolean have_hotWat = true
    "Set to true if the ETS supplies domestic hot water"
    annotation(Evaluate=true);
  parameter Boolean have_chiWat = true
    "Set to true if the ETS supplies chilled water"
    annotation(Evaluate=true);
  parameter Boolean have_fan = true
    "Set to true if fans drawn power is computed"
    annotation(Evaluate=true);
  parameter Boolean have_pum = true
    "Set to true if pumps drawn power is computed"
    annotation(Evaluate=true);
  parameter Boolean have_eleHea = true
    "Set to true if the ETS has electric heating"
    annotation(Evaluate=true);
  parameter Boolean have_eleCoo = true
    "Set to true if the ETS has electric cooling"
    annotation(Evaluate=true);
  parameter Boolean have_weaBus = true
    "Set to true for weather bus"
    annotation(Evaluate=true);
  parameter Boolean allowFlowReversalBui = false
    "Set to true to allow flow reversal on building side"
    annotation(Evaluate=true);
  parameter Boolean allowFlowReversalDis = false
    "Set to true to allow flow reversal on district side"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.HeatFlowRate QChiWat_flow_nominal = 0
    "Design heat flow rate for chilled water production (<0)"
    annotation (Dialog(group="Nominal conditions", enable=have_chiWat));
  parameter Modelica.SIunits.HeatFlowRate QHeaWat_flow_nominal = 0
    "Design heat flow rate for heating water production (>0)"
    annotation (Dialog(group="Nominal conditions", enable=have_heaWat));
  parameter Modelica.SIunits.HeatFlowRate QHotWat_flow_nominal = 0
    "Design heat flow rate for hot water production (>0)"
    annotation (Dialog(group="Nominal conditions", enable=have_hotWat));
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aBui[nPorts_aBui](
    redeclare each package Medium = MediumBui,
    each m_flow(min=if allowFlowReversalBui then -Modelica.Constants.inf else 0),
    each h_outflow(start=MediumBui.h_default, nominal=MediumBui.h_default))
    "Building services return water"
    annotation (Placement(transformation(extent={{-310,220},{-290,300}}),
      iconTransformation(extent={{-310,220}, {-290,300}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bBui[nPorts_bBui](
    redeclare each package Medium = MediumBui,
    each m_flow(max=if allowFlowReversalBui then +Modelica.Constants.inf else 0),
    each h_outflow(start=MediumBui.h_default, nominal=MediumBui.h_default))
    "Building services supply water"
    annotation (Placement(transformation(extent={{290,220},{310,300}}),
      iconTransformation(extent={{290,220},{310,300}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aDis(
    redeclare package Medium = MediumDis,
    m_flow(max=if allowFlowReversalDis then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumDis.h_default, nominal=MediumDis.h_default))
    "District water supply"
    annotation (Placement(transformation(extent={{-310,-270},{-290,-250}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bDis(
    redeclare package Medium = MediumDis,
    m_flow(max=if allowFlowReversalDis then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumDis.h_default, nominal=MediumDis.h_default))
    "District water return"
    annotation (Placement(transformation(extent={{290,-270},{310,-250}}),
        iconTransformation(extent={{290,-270},{310,-250}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-16,250},{18,282}}),
      iconTransformation(extent={{-16,250},{18,282}})));
  Modelica.Blocks.Interfaces.RealOutput QHeaWat_flow(
    final quantity="HeatFlowRate", final unit="W") if have_heaWat
    "Heat flow rate for heating water production (>=0)"
    annotation (Placement(transformation(extent={{300,180},{340,220}}),
      iconTransformation(extent={{300,180},{340,220}})));
  Modelica.Blocks.Interfaces.RealOutput QHotWat_flow(
    final quantity="HeatFlowRate", final unit="W") if have_hotWat
    "Heat flow rate for domestic hot water production (>=0)"
    annotation (Placement(transformation(extent={{300,140},{340,180}}),
      iconTransformation(extent={{300,140},{340,180}})));
  Modelica.Blocks.Interfaces.RealOutput QChiWat_flow(
    final quantity="HeatFlowRate", final unit="W") if have_chiWat
    "Heat flow rate for chilled water production (<=0)"
    annotation (Placement(transformation(extent={{300,100},{340,140}}),
      iconTransformation(extent={{300,100},{340,140}})));
  Modelica.Blocks.Interfaces.RealOutput PHea(
    final quantity="Power", final unit="W") if have_eleHea
    "Power drawn by heating equipment"
    annotation (Placement(transformation(
      extent={{300,60},{340,100}}),
      iconTransformation(extent={{300,60},{340,100}})));
  Modelica.Blocks.Interfaces.RealOutput PCoo(
    quantity="Power", final unit="W") if have_eleCoo
    "Power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{300,20},{340,60}}),
      iconTransformation(extent={{300,20},{340,60}})));
  Modelica.Blocks.Interfaces.RealOutput PFan(
    final quantity="Power", final unit="W") if have_fan
    "Power drawn by fan motors"
    annotation (Placement(transformation(extent={{300,-20},{340,20}}),
      iconTransformation(extent={{300,-20},{340,20}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(
    final quantity="Power", final unit="W") if have_pum
    "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{300,-60},{340,-20}}),
      iconTransformation(extent={{300,-60},{340,-20}})));
initial equation
  assert(nPorts_aBui == nPorts_bBui,
    "In " + getInstanceName() +
    ": The numbers of building services supply ports (" + String(nPorts_bBui) +
    ") and return ports (" + String(nPorts_aBui) + ") must be equal.");
  if have_chiWat then
    assert(QChiWat_flow_nominal < -Modelica.Constants.eps,
      "In " + getInstanceName() +
      ": Design heat flow rate for chilled water production must be strictly
      negative. Obtained QChiWat_flow_nominal = " +
      String(QChiWat_flow_nominal));
  end if;
  if have_heaWat then
    assert(QHeaWat_flow_nominal > Modelica.Constants.eps,
      "In " + getInstanceName() +
      ": Design heat flow rate for heating water production must be strictly 
      positive. Obtained QHeaWat_flow_nominal = " +
      String(QHeaWat_flow_nominal));
  end if;
  if have_hotWat then
    assert(QHotWat_flow_nominal > Modelica.Constants.eps,
      "In " + getInstanceName() +
      ": Design heat flow rate for heating water production must be strictly
      positive. Obtained QHotWat_flow_nominal = " +
      String(QHotWat_flow_nominal));
  end if;
annotation (
  defaultComponentName="ets",
  Documentation(info="<html>
<p>
Partial model to be used for modeling an energy transfer station.
</p>
</html>",
revisions=
"<html>
<ul>
<li>
XXX, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
  Icon(
  coordinateSystem(extent={{-300,-300},{300,300}}, preserveAspectRatio=false),
  graphics={Rectangle(
        extent={{-300,-300},{300,300}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{18,-38},{46,-10}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-148,-326},{152,-366}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-298,-268},{300,-250}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid)}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-300,-300},{300,300}})));
end PartialETS;
