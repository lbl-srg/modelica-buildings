within Buildings.Experimental.DHC.Plants.BaseClasses;
partial model PartialPlant
  "Partial class for modeling a plant"
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Service side medium";
  replaceable package MediumHea_b=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Service side medium at heating supply"
    annotation(Dialog(enable=
      typ == TypDisSys.CombinedGeneration1 or
      typ == TypDisSys.HeatingGeneration1));
  parameter Buildings.Experimental.DHC.Types.DistrictSystemType
  typ=Buildings.Experimental.DHC.Types.DistrictSystemType.CombinedGeneration2to4
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
  final parameter Boolean have_fue=nFue>0
    "Set to true if the plant has fuel use";
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
     annotation (choicesAllMatching = true, Dialog(enable=have_fue));
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerAmb(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
 if have_serAmb
    "Fluid connector for ambient water service supply line"
    annotation (
      Placement(transformation(extent={{-390,30},{-370,50}}),
        iconTransformation(extent={{-310,30},{-290,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerAmb(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
 if have_serAmb
    "Fluid connector for ambient water service return line"
    annotation (
      Placement(transformation(extent={{370,30},{390,50}}),
        iconTransformation(extent={{290,30},{310,50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerHea(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) if have_hea
    "Fluid connector for heating service supply line"
    annotation (Placement(
      transformation(extent={{-390,-10},{-370,10}}),    iconTransformation(
        extent={{-310,-10},{-290,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerHea(
    redeclare package Medium = MediumHea_b,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumHea_b.h_default, nominal=MediumHea_b.h_default)) if have_hea
    "Fluid connector for heating service return line"
    annotation (Placement(
        transformation(extent={{370,-10},{390,10}}),    iconTransformation(
          extent={{290,-10},{310,10}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSerCoo(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
 if have_coo
    "Fluid connector for cooling service supply line"
    annotation (Placement(transformation(extent={{-390,-50},{-370,-30}}),
        iconTransformation(extent={{-310,-50},{-290,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSerCoo(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
 if have_coo
    "Fluid connector for cooling service return line"
    annotation (Placement(
      transformation(extent={{370,-50},{390,-30}}),   iconTransformation(
        extent={{290,-50},{310,-30}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-20,360},{20,400}}),
      iconTransformation(extent={{-10,290},{10,310}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PHea(
    final unit="W") if have_eleHea
    "Power drawn by heating system"
    annotation (Placement(transformation(extent={{380,260},{420,300}}),
      iconTransformation(extent={{300,240},{380,320}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PCoo(
    final unit="W") if have_eleCoo
    "Power drawn by cooling system"
    annotation (Placement(transformation(extent={{380,220},{420,260}}),
      iconTransformation(extent={{300,200},{380,280}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PFan(
    final unit="W") if have_fan
    "Power drawn by fan motors"
    annotation (Placement(transformation(extent={{380,180},{420,220}}),
      iconTransformation(extent={{300,160},{380,240}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(
    final unit="W") if have_pum
    "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{380,140},{420,180}}),
      iconTransformation(extent={{300,120},{380,200}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput QFue_flow(
    final unit="W") if have_fue
    "Fuel energy input rate"
    annotation (
      Placement(transformation(extent={{380,100},{420,140}}),
        iconTransformation(extent={{300,80},{380,160}})));
protected
  final parameter Boolean have_hea=typ <> Buildings.Experimental.DHC.Types.DistrictSystemType.Cooling and
  typ <> Buildings.Experimental.DHC.Types.DistrictSystemType.CombinedGeneration5
  "Boolean flag to enable fluid connectors for heating service line";
  final parameter Boolean have_coo=typ == Buildings.Experimental.DHC.Types.DistrictSystemType.CombinedGeneration1 or
  typ == Buildings.Experimental.DHC.Types.DistrictSystemType.CombinedGeneration2to4 or
  typ == Buildings.Experimental.DHC.Types.DistrictSystemType.Cooling
  "Boolean flag to enable fluid connectors for cooling service line";
  final parameter Boolean have_serAmb=typ == Buildings.Experimental.DHC.Types.DistrictSystemType.CombinedGeneration5
  "Boolean flag to enable fluid connector for ambient water service line";
  annotation (
    defaultComponentName="pla",
    Documentation(
      info="<html>
<p>
Partial class to be used for modeling a plant.
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
September 20, 2021, by Mingzhe Liu:<br/>
Refactored <code>if</code> statement to correctly enable and 
disable the fluid connector under different system types.
</li>
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
          textColor={0,0,255},
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
          extent={{-300,-48},{300,-32}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          visible=have_coo),
        Rectangle(
          extent={{-300,32},{-140,48}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=have_serAmb),
        Rectangle(
          extent={{140,32},{300,48}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,255,255},
          fillPattern=FillPattern.Solid,
          visible=have_serAmb),
        Rectangle(
          extent={{-300,-8},{300,8}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          visible=have_hea),
        Rectangle(
          extent={{-140,140},{140,-142}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-380,-380},{380,380}})));
end PartialPlant;
