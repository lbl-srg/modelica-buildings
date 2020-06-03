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
  parameter Integer nPorts_aHeaWat = 0
    "Number of heating water return ports"
     annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter Integer nPorts_bHeaWat = 0
    "Number of heating water supply ports"
     annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter Integer nPorts_aChiWat = 0
    "Number of chilled water return ports"
     annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter Integer nPorts_bChiWat = 0
    "Number of chilled water supply ports"
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
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversalDis = false
    "Set to true to allow flow reversal on district side"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
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
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aHeaWat[nPorts_aHeaWat](
    redeclare each package Medium = MediumBui,
    each m_flow(min=if allowFlowReversalBui then -Modelica.Constants.inf else 0),
    each h_outflow(start=MediumBui.h_default, nominal=MediumBui.h_default)) if have_heaWat
    "Fluid connectors for heating water return (from building)"
    annotation (Placement(transformation(extent={{-310,220},{-290,300}}),
      iconTransformation(extent={{-310,220},{-290,300}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bHeaWat[nPorts_bHeaWat](
    redeclare each package Medium = MediumBui,
    each m_flow(max=if allowFlowReversalBui then +Modelica.Constants.inf else 0),
    each h_outflow(start=MediumBui.h_default, nominal=MediumBui.h_default)) if have_heaWat
    "Fluid connectors for heating water supply (to building)"
    annotation (Placement(transformation(extent={{290,220},{310,300}}),
      iconTransformation(extent={{290,220},{310,300}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiWat[nPorts_aChiWat](
    redeclare each package Medium = MediumBui,
    each m_flow(min=if allowFlowReversalBui then -Modelica.Constants.inf else 0),
    each h_outflow(start=MediumBui.h_default, nominal=MediumBui.h_default)) if have_chiWat
    "Fluid connectors for chilled water return (from building)"
    annotation (Placement(transformation(extent={{-310,160},{-290,240}}),
      iconTransformation(extent={{-310,120},{-290,200}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiWat[nPorts_bChiWat](
    redeclare each package Medium = MediumBui,
    each m_flow(max=if allowFlowReversalBui then +Modelica.Constants.inf else 0),
    each h_outflow(start=MediumBui.h_default, nominal=MediumBui.h_default)) if have_chiWat
    "Fluid connectors for chilled water supply (to building)"
    annotation (Placement(transformation(extent={{290,160},{310,240}}),
      iconTransformation(extent={{290,120},{310,200}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aDis(
    redeclare package Medium = MediumDis,
    m_flow(min=if allowFlowReversalDis then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumDis.h_default, nominal=MediumDis.h_default))
    "Fluid connector for district water supply"
    annotation (Placement(transformation(extent={{-310,-270},{-290,-250}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bDis(
    redeclare package Medium = MediumDis,
    m_flow(max=if allowFlowReversalDis then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumDis.h_default, nominal=MediumDis.h_default))
    "Fluid connector for district water return"
    annotation (Placement(transformation(extent={{290,-270},{310,-250}}),
      iconTransformation(extent={{290,-270},{310,-250}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-16,250},{18,282}}),
      iconTransformation(extent={{-16,250},{18,282}})));
  Modelica.Blocks.Interfaces.RealOutput PHea(
    final unit="W") if have_eleHea
    "Power drawn by heating equipment"
    annotation (Placement(transformation(
      extent={{300,40},{340,80}}),
      iconTransformation(extent={{300,40},{340,80}})));
  Modelica.Blocks.Interfaces.RealOutput PCoo(
    final unit="W") if have_eleCoo
    "Power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{300,0},{340,40}}),
      iconTransformation(extent={{300,0},{340,40}})));
  Modelica.Blocks.Interfaces.RealOutput PFan(
    final unit="W") if have_fan
    "Power drawn by fan motors"
    annotation (Placement(transformation(extent={{300,-40},{340,0}}),
      iconTransformation(extent={{300,-40},{340,0}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(
    final unit="W") if have_pum
    "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{300,-80},{340,-40}}),
      iconTransformation(extent={{300,-80},{340,-40}})));
initial equation
  assert(nPorts_aHeaWat == nPorts_bHeaWat,
    "In " + getInstanceName() +
    ": The numbers of heating water supply ports (" + String(nPorts_bHeaWat) +
    ") and return ports (" + String(nPorts_aHeaWat) + ") must be equal.");
  assert(nPorts_aChiWat == nPorts_bChiWat,
    "In " + getInstanceName() +
    ": The numbers of chilled water supply ports (" + String(nPorts_bChiWat) +
    ") and return ports (" + String(nPorts_aChiWat) + ") must be equal.");
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
