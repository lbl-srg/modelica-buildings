within Buildings.Experimental.DHC.CentralPlants.BaseClasses;
partial model PartialPlant
  "Partial class for modeling a central plant"
  import TypDisSys=Buildings.Experimental.DHC.Types.DistrictSystemType
    "District system type enumeration";
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Service side medium";
  replaceable package MediumHea_b=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Service side medium at heating supply"
    annotation(Dialog(enable=
      typ == TypDisSys.CombinedGeneration1 or
      typ == TypDisSys.HeatingGeneration1));
  parameter TypDisSys typ=TypDisSys.CombinedGeneration2to4
    "Type of district system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_fan=false
    "Set to true if fan power is computed"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_pum=false
    "Set to true if pump power is computed"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_eleHea=false
    "Set to true if the plant has electric heating system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Integer nFue=0
    "Number of fuel types (0 means no combustion system)"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_eleCoo=false
    "Set to true if the plant has electric cooling system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_weaBus=false
    "Set to true to use a weather bus"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean allowFlowReversal=false
    "Set to true to allow flow reversal in service lines"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  parameter Buildings.Fluid.Data.Fuels.Generic fue[nFue]
    "Fuel type"
     annotation (choicesAllMatching = true, Dialog(enable=nFue>0));
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerAmb(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) if
    typ == TypDisSys.CombinedGeneration5
    "Fluid connector for ambient water service supply line"
    annotation (
      Placement(transformation(extent={{-310,30},{-290,50}}),
        iconTransformation(extent={{-310,30},{-290,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerAmb(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) if
    typ == TypDisSys.CombinedGeneration5
    "Fluid connector for ambient water service return line"
    annotation (
      Placement(transformation(extent={{290,30},{310,50}}),
        iconTransformation(extent={{290,30},{310,50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerHea(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) if
    typ <> TypDisSys.Cooling and
    typ <> TypDisSys.CombinedGeneration5
    "Fluid connector for heating service supply line"
    annotation (Placement(
      transformation(extent={{-310,-10},{-290,10}}),    iconTransformation(
        extent={{-310,-10},{-290,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerHea(
    redeclare package Medium = MediumHea_b,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumHea_b.h_default, nominal=MediumHea_b.h_default)) if
    typ <> TypDisSys.Cooling and
    typ <> TypDisSys.CombinedGeneration5
    "Fluid connector for heating service return line"
    annotation (Placement(
        transformation(extent={{290,-10},{310,10}}),    iconTransformation(
          extent={{290,-10},{310,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerCoo(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) if
    typ == TypDisSys.CombinedGeneration1 or
    typ == TypDisSys.CombinedGeneration2to4 or
    typ == TypDisSys.Cooling
    "Fluid connector for cooling service supply line"
    annotation (Placement(transformation(extent={{-310,-50},{-290,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerCoo(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) if
    typ == TypDisSys.CombinedGeneration1 or
    typ == TypDisSys.CombinedGeneration2to4 or
    typ == TypDisSys.Cooling
    "Fluid connector for cooling service return line"
    annotation (Placement(
      transformation(extent={{290,-50},{310,-30}}),   iconTransformation(
        extent={{290,-50},{310,-30}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-16,250},{18,282}}),
      iconTransformation(extent={{-16,250},{18,282}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PHea(
    final unit="W") if have_eleHea
    "Power drawn by heating system"
    annotation (Placement(transformation(extent={{300,260},{340,300}}),
      iconTransformation(extent={{300,240},{380,320}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PCoo(
    final unit="W") if have_eleCoo
    "Power drawn by cooling system"
    annotation (Placement(transformation(extent={{300,220},{340,260}}),
      iconTransformation(extent={{300,200},{380,280}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PFan(
    final unit="W") if have_fan
    "Power drawn by fan motors"
    annotation (Placement(transformation(extent={{300,180},{340,220}}),
      iconTransformation(extent={{300,160},{380,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(
    final unit="W") if have_pum
    "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{300,140},{340,180}}),
      iconTransformation(extent={{300,120},{380,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QFue_flow[nFue](
    each final unit="W") if nFue>0
    "Fuel energy input rate"
    annotation (
      Placement(transformation(extent={{300,100},{340,140}}),
        iconTransformation(extent={{300,80},{380,160}})));
  annotation (
    defaultComponentName="plan",
    Documentation(
      info="<html>
<p>
Partial class to be used for modeling a central plant.
</p>
<p>
The connectors to the service lines are configured based on an enumeration
defining the type of district system, see
<a href=\"modelica://Buildings.Experimental.DHC.Types.DistrictSystemType\">
Buildings.Experimental.DHC.Types.DistrictSystemType</a>.
In case of a heating service line, the model allows for using two
different media at the supply port <code>port_bSerHea</code> and at the return
<code>port_aSerHea</code> to represent a steam supply and condensate
return.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 21, 2020, by Antoine Gautier:<br/>
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
          extent={{-300,-8},{-140,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          visible=typ <> TypDisSys.Cooling and typ <> TypDisSys.CombinedGeneration5),
        Rectangle(
          extent={{140,-48},{300,-32}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration1 or typ == TypDisSys.CombinedGeneration2to4
               or typ == TypDisSys.Cooling),
        Rectangle(
          extent={{-300,32},{-140,48}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5),
        Rectangle(
          extent={{140,32},{300,48}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration5),
        Rectangle(
          extent={{-140,140},{140,-142}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{140,-8},{300,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          visible=typ <> TypDisSys.Cooling and typ <> TypDisSys.CombinedGeneration5),
        Rectangle(
          extent={{-300,-48},{-140,-32}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid,
          visible=typ == TypDisSys.CombinedGeneration1 or typ == TypDisSys.CombinedGeneration2to4
               or typ == TypDisSys.Cooling)}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-300,-300},{300,300}})));
end PartialPlant;
