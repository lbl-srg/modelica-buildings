within Buildings.Experimental.DHC.EnergyTransferStations.BaseClasses;
partial model PartialETS
  "Partial class for modeling an energy transfer station"
  import TypDisSys=Buildings.Experimental.DHC.Types.DistrictSystemType
    "District system type enumeration";
  replaceable package MediumSer=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Service side medium";
  replaceable package MediumSerHea_a=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Service side medium at heating inlet"
    annotation(Dialog(enable=
      typ == TypDisSys.CombinedGeneration1 or
      typ == TypDisSys.HeatingGeneration1));
  replaceable package MediumBui=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Building side medium";
  parameter TypDisSys typ = TypDisSys.CombinedGeneration2to4
    "Type of district system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nPorts_aHeaWat=0
    "Number of heating water return ports"
    annotation (Evaluate=true,Dialog(group="Configuration", connectorSizing=true));
  parameter Integer nPorts_bHeaWat=0
    "Number of heating water supply ports"
    annotation (Evaluate=true,Dialog(group="Configuration", connectorSizing=true));
  parameter Integer nPorts_aChiWat=0
    "Number of chilled water return ports"
    annotation (Evaluate=true,Dialog(group="Configuration", connectorSizing=true));
  parameter Integer nPorts_bChiWat=0
    "Number of chilled water supply ports"
    annotation (Evaluate=true,Dialog(group="Configuration", connectorSizing=true));
  parameter Boolean have_heaWat=false
    "Set to true if the ETS supplies heating water"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_hotWat=false
    "Set to true if the ETS supplies hot water"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_chiWat=false
    "Set to true if the ETS supplies chilled water"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_fan=false
    "Set to true if fan power is computed"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_pum=false
    "Set to true if pump power is computed"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_eleHea=false
    "Set to true if the ETS has electric heating system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nFue=0
    "Number of fuel types (0 means no combustion system)"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_eleCoo=false
    "Set to true if the ETS has electric cooling system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_weaBus=false
    "Set to true to use a weather bus"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean allowFlowReversalSer=false
    "Set to true to allow flow reversal on service side"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Boolean allowFlowReversalBui=false
    "Set to true to allow flow reversal on building side"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Modelica.SIunits.HeatFlowRate QHeaWat_flow_nominal(min=0)=0
    "Nominal capacity of heating system (>=0)"
    annotation (Dialog(group="Nominal condition", enable=have_heaWat));
  parameter Modelica.SIunits.HeatFlowRate QHotWat_flow_nominal(min=0)=0
    "Nominal capacity of hot water production system (>=0)"
    annotation (Dialog(group="Nominal condition", enable=have_hotWat));
  parameter Modelica.SIunits.HeatFlowRate QChiWat_flow_nominal(max=0)=0
    "Nominal capacity of cooling system (<=0)"
    annotation (Dialog(group="Nominal condition", enable=have_chiWat));
  parameter Buildings.Fluid.Data.Fuels.Generic fue[nFue]
    "Fuel type"
     annotation (choicesAllMatching = true, Dialog(enable=nFue>0));
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aHeaWat[nPorts_aHeaWat](
    redeclare each package Medium=MediumBui,
    each m_flow(
      min=
        if allowFlowReversalBui then
          -Modelica.Constants.inf
        else
          0),
    each h_outflow(
      start=MediumBui.h_default,
      nominal=MediumBui.h_default)) if have_heaWat
    "Fluid connectors for heating water return (from building)"
    annotation (Placement(transformation(extent={{-310,220},{-290,300}}),
      iconTransformation(extent={{-310,220},{-290,300}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bHeaWat[nPorts_bHeaWat](
    redeclare each package Medium=MediumBui,
    each m_flow(
      max=
        if allowFlowReversalBui then
          +Modelica.Constants.inf
        else
          0),
    each h_outflow(
      start=MediumBui.h_default,
      nominal=MediumBui.h_default)) if have_heaWat
    "Fluid connectors for heating water supply (to building)"
    annotation (Placement(transformation(extent={{290,220},{310,300}}),
      iconTransformation(extent={{290,220},{310,300}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiWat[nPorts_aChiWat](
    redeclare each package Medium=MediumBui,
    each m_flow(
      min=
        if allowFlowReversalBui then
          -Modelica.Constants.inf
        else
          0),
    each h_outflow(
      start=MediumBui.h_default,
      nominal=MediumBui.h_default)) if have_chiWat
    "Fluid connectors for chilled water return (from building)"
    annotation (Placement(transformation(extent={{-310,160},{-290,240}}),
      iconTransformation(extent={{-310,120},{-290,200}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiWat[nPorts_bChiWat](
    redeclare each package Medium=MediumBui,
    each m_flow(
      max=
        if allowFlowReversalBui then
          +Modelica.Constants.inf
        else
          0),
    each h_outflow(
      start=MediumBui.h_default,
      nominal=MediumBui.h_default)) if have_chiWat
    "Fluid connectors for chilled water supply (to building)"
    annotation (Placement(transformation(extent={{290,160},{310,240}}),
      iconTransformation(extent={{290,120},{310,200}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerAmb(
    redeclare package Medium = MediumSer,
    m_flow(min=if allowFlowReversalSer then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default)) if
    typ == TypDisSys.CombinedGeneration5
    "Fluid connector for ambient water service supply line"
    annotation (
      Placement(transformation(extent={{-310,-210},{-290,-190}}),
        iconTransformation(extent={{-310,-210},{-290,-190}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerAmb(
    redeclare package Medium = MediumSer,
    m_flow(max=if allowFlowReversalSer then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default)) if
    typ == TypDisSys.CombinedGeneration5
    "Fluid connector for ambient water service return line"
    annotation (
      Placement(transformation(extent={{290,-210},{310,-190}}),
        iconTransformation(extent={{290,-210},{310,-190}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerHea(
    redeclare package Medium = MediumSerHea_a,
    m_flow(min=if allowFlowReversalSer then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumSerHea_a.h_default, nominal=MediumSerHea_a.h_default)) if
    typ <> TypDisSys.Cooling and
    typ <> TypDisSys.CombinedGeneration5
    "Fluid connector for heating service supply line"
    annotation (Placement(
      transformation(extent={{-310,-250},{-290,-230}}), iconTransformation(
        extent={{-310,-250},{-290,-230}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerHea(
    redeclare package Medium = MediumSer,
    m_flow(max=if allowFlowReversalSer then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default)) if
    typ <> TypDisSys.Cooling and
    typ <> TypDisSys.CombinedGeneration5
    "Fluid connector for heating service return line"
    annotation (Placement(
        transformation(extent={{290,-250},{310,-230}}), iconTransformation(
          extent={{290,-250},{310,-230}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerCoo(
    redeclare package Medium = MediumSer,
    m_flow(min=if allowFlowReversalSer then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default)) if
    typ == TypDisSys.CombinedGeneration1 or
    typ == TypDisSys.CombinedGeneration2to4 or
    typ == TypDisSys.Cooling
    "Fluid connector for cooling service supply line"
    annotation (Placement(transformation(extent={{-310,-290},{-290,-270}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerCoo(
    redeclare package Medium = MediumSer,
    m_flow(max=if allowFlowReversalSer then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumSer.h_default, nominal=MediumSer.h_default)) if
    typ == TypDisSys.CombinedGeneration1 or
    typ == TypDisSys.CombinedGeneration2to4 or
    typ == TypDisSys.Cooling
    "Fluid connector for cooling service return line"
    annotation (Placement(
      transformation(extent={{290,-290},{310,-270}}), iconTransformation(
        extent={{290,-290},{310,-270}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PHea(
    final unit="W") if have_eleHea
    "Power drawn by heating system"
    annotation (Placement(transformation(extent={{300,60},{340,100}}),
      iconTransformation(extent={{300,40},{380,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PCoo(
    final unit="W") if have_eleCoo
    "Power drawn by cooling system"
    annotation (Placement(transformation(extent={{300,20},{340,60}}),
      iconTransformation(extent={{300,0},{380,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PFan(
    final unit="W") if have_fan
    "Power drawn by fan motors"
    annotation (Placement(transformation(extent={{300,-20},{340,20}}),
      iconTransformation(extent={{300,-40},{380,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(
    final unit="W") if have_pum
    "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{300,-60},{340,-20}}),
      iconTransformation(extent={{300,-80},{380,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QFue_flow[nFue](
    each final unit="W") if nFue>0
    "Fuel energy input rate"
    annotation (
      Placement(transformation(extent={{300,-100},{340,-60}}),
        iconTransformation(extent={{300,-120},{380,-40}})));
  BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-20,260},{20,300}}),
      iconTransformation(extent={{-18,284},{18,318}})));
initial equation
  assert(
    nPorts_aHeaWat == nPorts_bHeaWat,
    "In "+getInstanceName()+": The numbers of heating water supply ports ("+String(
      nPorts_bHeaWat)+") and return ports ("+String(
      nPorts_aHeaWat)+") must be equal.");
  assert(
    nPorts_aChiWat == nPorts_bChiWat,
    "In "+getInstanceName()+": The numbers of chilled water supply ports ("+String(
      nPorts_bChiWat)+") and return ports ("+String(
      nPorts_aChiWat)+") must be equal.");
  if have_chiWat then
    assert(
      QChiWat_flow_nominal <-Modelica.Constants.eps,
      "In "+getInstanceName()+": Design heat flow rate for chilled water production must be strictly
      negative. Obtained QChiWat_flow_nominal = "+String(
        QChiWat_flow_nominal));
  end if;
  if have_heaWat then
    assert(
      QHeaWat_flow_nominal > Modelica.Constants.eps,
      "In "+getInstanceName()+": Design heat flow rate for heating water production must be strictly
      positive. Obtained QHeaWat_flow_nominal = "+String(
        QHeaWat_flow_nominal));
  end if;
  if have_hotWat then
    assert(
      QHotWat_flow_nominal > Modelica.Constants.eps,
      "In "+getInstanceName()+": Design heat flow rate for heating water production must be strictly
      positive. Obtained QHotWat_flow_nominal = "+String(
        QHotWat_flow_nominal));
  end if;
  annotation (
    defaultComponentName="ets",
    Documentation(
      info="<html>
<p>
Partial class to be used for modeling an energy transfer station
and optional in-building primary systems.
</p>
<p>
The connectors to the service lines are configured based on an enumeration
defining the type of district system (<code>CombinedGeneration2to4</code>
by default), see
<a href=\"modelica://Buildings.Experimental.DHC.Types.DistrictSystemType\">
Buildings.Experimental.DHC.Types.DistrictSystemType</a>.
In case of a heating service line, the model allows for using two
different media at the inlet port <code>port_aSerHea</code> and at the oulet
port <code>port_bSerHea</code> to represent a steam supply and condensate
return.
</p>
<p>
The connectors to the building distribution systems are configured based
on the Boolean parameters <code>have_heaWat</code> and <code>have_chiWat</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 21, 2020, by Antoine Gautier:<br/>
Refactored to support all DHC system types.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2291\">issue 2291</a>.
</li>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        extent={{-300,-300},{300,300}},
        preserveAspectRatio=false),
      graphics={
        Rectangle(
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
        Line(
          points={{-142,300},{-140,372}},
          color={0,0,255},
          pattern=LinePattern.None),
        Line(
          points={{-142,354},{-138,274}},
          color={0,0,255},
          pattern=LinePattern.None),
        Rectangle(
          extent={{-300,-248},{-58,-232}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          visible=typ <> TypDisSys.Cooling and typ <> TypDisSys.CombinedGeneration5),
        Rectangle(
          extent={{20,-288},{300,-272}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration1 or typ == TypDisSys.CombinedGeneration2to4
               or typ == TypDisSys.Cooling),
        Rectangle(
          extent={{-300,-208},{-100,-192}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5),
        Rectangle(
          extent={{100,-208},{300,-192}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5),
        Rectangle(
          extent={{-25,-8},{25,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5,
          origin={108,-167},
          rotation=90),
        Rectangle(
          extent={{-25,-8},{25,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5,
          origin={-108,-167},
          rotation=90),
        Rectangle(
          extent={{-140,140},{140,-142}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{58,-248},{300,-232}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          visible=typ <> TypDisSys.Cooling and typ <> TypDisSys.CombinedGeneration5),
        Rectangle(
          extent={{-45,-9},{45,9}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          visible=typ <> TypDisSys.Cooling and typ <> TypDisSys.CombinedGeneration5,
          origin={67,-187},
          rotation=90),
        Rectangle(
          extent={{-45,-8},{45,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          visible=typ <> TypDisSys.Cooling and typ <> TypDisSys.CombinedGeneration5,
          origin={-66,-187},
          rotation=90),
        Rectangle(
          extent={{-66,-8},{66,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration1 or typ == TypDisSys.CombinedGeneration2to4
               or typ == TypDisSys.Cooling,
          origin={28,-208},
          rotation=90),
        Rectangle(
          extent={{-302,-288},{-22,-272}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration1 or typ == TypDisSys.CombinedGeneration2to4
               or typ == TypDisSys.Cooling),
        Rectangle(
          extent={{-65,-8},{65,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration1 or typ == TypDisSys.CombinedGeneration2to4
               or typ == TypDisSys.Cooling,
          origin={-30,-207},
          rotation=90),
        Rectangle(
          extent={{-6,-8},{6,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          visible=have_chiWat,
          origin={104,146},
          rotation=90),
        Rectangle(
          extent={{-102,-8},{102,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          visible=have_chiWat,
          origin={198,160},
          rotation=0),
        Rectangle(
          extent={{-130,-8},{130,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          visible=have_heaWat,
          origin={-170,260},
          rotation=0),
        Rectangle(
          extent={{-102,-8},{102,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={-198,160},
          rotation=0,
          visible=have_chiWat),
        Rectangle(
          extent={{-6,-8},{6,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={-104,146},
          rotation=90,
          visible=have_chiWat),
        Rectangle(
          extent={{-130,-8},{130,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={170,260},
          rotation=0,
          visible=have_heaWat),
        Rectangle(
          extent={{-56,-9},{56,9}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          origin={49,196},
          rotation=90,
          visible=have_heaWat),
        Rectangle(
          extent={{-56,-9},{56,9}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          origin={-49,196},
          rotation=90,
          visible=have_heaWat)}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-300,-300},{300,300}})));
end PartialETS;
