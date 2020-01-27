within Buildings.Applications.DHC.Loads.BaseClasses;
partial model PartialBuilding "Partial class for building model"
  replaceable package Medium1 =
    Buildings.Media.Water
    "Source side medium"
    annotation(choices(
      choice(redeclare package Medium1 = Buildings.Media.Water "Water"),
      choice(redeclare package Medium1 =
        Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T=293.15, X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  parameter Integer nPorts_a1 = 0
    "Number of inlet fluid ports on source side"
     annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter Integer nPorts_b1 = 0
    "Number of outlet fluid ports on source side"
     annotation(Evaluate=true, Dialog(connectorSizing=true));
  parameter Boolean have_heaLoa = true
    "Set to true if the building has heating loads"
    annotation(Evaluate=true);
  parameter Boolean have_cooLoa = true
    "Set to true if the building has cooling loads"
    annotation(Evaluate=true);
  parameter Boolean have_fan = true
    "Set to true if fans drawn power is computed"
    annotation(Evaluate=true);
  parameter Boolean have_pum = true
    "Set to true if pumps drawn power is computed"
    annotation(Evaluate=true);
  parameter Boolean have_eleHea = true
    "Set to true if the building has electric heating"
    annotation(Evaluate=true);
  parameter Boolean have_eleCoo = true
    "Set to true if the building has electric cooling"
    annotation(Evaluate=true);
  parameter Boolean have_weaBus = true
    "Set to true for weather bus"
    annotation(Evaluate=true);
  final parameter Boolean allowFlowReversal=false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Evaluate=true);
  // IO CONNECTORS
  Buildings.BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
    "Weather data bus"
    annotation (Placement(
    transformation(extent={{-16,284},{18,316}}),
    iconTransformation(extent={{-16,198},{18,230}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_a1[nPorts_a1](
    redeclare each package Medium = Medium1,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium1.h_default, nominal=Medium1.h_default))
    "Fluid connectors b (positive design flow direction is from port_a to ports_b)"
    annotation (Placement(transformation(extent={{-310,-40},{-290,40}}),
      iconTransformation(extent={{-310,-220},{-290,-140}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b1[nPorts_b1](
    redeclare each package Medium = Medium1,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium1.h_default, nominal=Medium1.h_default))
    "Fluid connectors b (positive design flow direction is from port_a to ports_b)"
    annotation (Placement(transformation(extent={{290,-40},{310,40}}),
      iconTransformation(extent={{290,-220},{310,-140}})));
  Modelica.Blocks.Interfaces.RealOutput QHea_flow(
    final quantity="HeatFlowRate", final unit="W") if have_heaLoa
    "Total heating heat flow rate transferred to the loads (>=0)"
    annotation (Placement(transformation(
      extent={{300,260},{340,300}}), iconTransformation(extent={{300,240},{340,280}})));
  Modelica.Blocks.Interfaces.RealOutput QCoo_flow(
    final quantity="HeatFlowRate", final unit="W") if have_cooLoa
    "Total cooling heat flow rate transferred to the loads (<=0)"
    annotation (Placement(transformation(
      extent={{300,220},{340,260}}),
      iconTransformation(extent={{300,200},{340, 240}})));
  Modelica.Blocks.Interfaces.RealOutput PHea(
    final quantity="Power", final unit="W") if have_eleHea
    "Power drawn by heating equipment"
    annotation (Placement(transformation(
      extent={{300,180},{340,220}}),
      iconTransformation(extent={{300,160},{340, 200}})));
  Modelica.Blocks.Interfaces.RealOutput PCoo(
    quantity="Power", final unit="W") if have_eleCoo
    "Power drawn by cooling equipment"
    annotation (Placement(transformation(extent={{300,140},{340,180}}),
      iconTransformation(extent={{300,120},{340,160}})));
  Modelica.Blocks.Interfaces.RealOutput PFan(
    final quantity="Power", final unit="W") if have_fan
    "Power drawn by fans motors"
    annotation (Placement(transformation(extent={{300,100},{340,140}}),
      iconTransformation(extent={{300,80},{340,120}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(
    final quantity="Power", final unit="W") if have_pum
    "Power drawn by pumps motors"
    annotation (Placement(transformation(extent={{300,60},{340,100}}),
      iconTransformation(extent={{300,40},{340,80}})));
initial equation
  assert(nPorts_a1 == nPorts_b1,
    "In " + getInstanceName() +
    ": The numbers of source side inlet ports (" + String(nPorts_a1) +
    ") and outlet ports (" + String(nPorts_b1) + ") must be equal.");
annotation (
  defaultComponentName="bui",
  Documentation(info="<html>
<p>
Partial model to be used for modeling the building loads served by an energy
transfer station or a dedicated plant.
The fluid ports represent the connection between that production system and
the building distribution system.
</p>
</html>"),
  Icon(
  coordinateSystem(extent={{-300,-300},{300,300}}, preserveAspectRatio=false),
  graphics={Rectangle(
        extent={{-300,-300},{300,300}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-172},{290,-188}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-290,-188},{-10,-172}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-214},{290,-198}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-290,-198},{-10,-214}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{18,-38},{46,-10}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,-328},{150,-368}},
          lineColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{10,-146},{290,-162}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-290,-162},{-10,-146}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
      Rectangle(
          extent={{-180,180},{174,-220}},
          lineColor={150,150,150},
          fillPattern=FillPattern.Sphere,
          fillColor={255,255,255}),
      Rectangle(
        extent={{36,42},{108,114}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-124,42},{-52,114}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-126,-122},{-54,-50}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{40,-122},{112,-50}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{0,264},{-218,164},{220,164},{0,264}},
        lineColor={95,95,95},
        smooth=Smooth.None,
        fillPattern=FillPattern.Solid,
        fillColor={95,95,95})}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-300,-300},{300,300}})));
end PartialBuilding;
