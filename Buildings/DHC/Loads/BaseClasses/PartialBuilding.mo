within Buildings.DHC.Loads.BaseClasses;
partial model PartialBuilding
  "Partial class for building model"
  replaceable package Medium=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Medium in the building distribution system";
  parameter Integer nPorts_aHeaWat=0
    "Number of heating water inlet ports"
    annotation (Evaluate=true,Dialog(connectorSizing=true));
  parameter Integer nPorts_bHeaWat=0
    "Number of heating water outlet ports"
    annotation (Evaluate=true,Dialog(connectorSizing=true));
  parameter Integer nPorts_aChiWat=0
    "Number of chilled water inlet ports"
    annotation (Evaluate=true,Dialog(connectorSizing=true));
  parameter Integer nPorts_bChiWat=0
    "Number of chilled water outlet ports"
    annotation (Evaluate=true,Dialog(connectorSizing=true));
  parameter Boolean have_heaWat=false
    "Set to true if the building has heating water system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_chiWat=false
    "Set to true if the building has chilled water system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_eleHea=false
    "Set to true if the building has decentralized electric heating system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_eleCoo=false
    "Set to true if the building has decentralized electric cooling system"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_fan=false
    "Set to true if fan power is computed"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_pum=false
    "Set to true if pump power is computed"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Boolean have_weaBus=false
    "Set to true to use a weather bus"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Real facMul(min=Modelica.Constants.eps)=1
    "Multiplier factor"
    annotation (Evaluate=true, Dialog(group="Scaling"));
  parameter Boolean allowFlowReversal=false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);
  final parameter Boolean have_heaLoa=have_heaWat or have_eleHea
    "Set to true if the building has heating loads"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  final parameter Boolean have_cooLoa=have_chiWat or have_eleCoo
    "Set to true if the building has cooling loads"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  // IO CONNECTORS
  Buildings.BoundaryConditions.WeatherData.Bus weaBus if have_weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-16,284},{18,316}}),
      iconTransformation(extent={{-16,198},{18,230}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aHeaWat[nPorts_aHeaWat](
    redeclare each package Medium=Medium,
    each m_flow(
      min=
        if allowFlowReversal then
          -Modelica.Constants.inf
        else
          0),
    each h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default)) if have_heaWat
    "Heating water inlet ports"
    annotation (Placement(transformation(extent={{-310,-100},{-290,-20}}),
      iconTransformation(extent={{-310,-100},{-290,-20}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bHeaWat[nPorts_bHeaWat](
    redeclare each package Medium=Medium,
    each m_flow(
      max=
        if allowFlowReversal then
          +Modelica.Constants.inf
        else
          0),
    each h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default)) if have_heaWat
    "Heating water outlet ports"
    annotation (Placement(transformation(extent={{290,-100},{310,-20}}),
      iconTransformation(extent={{290,-100},{310,-20}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aChiWat[nPorts_aChiWat](
    redeclare each package Medium=Medium,
    each m_flow(
      min=
        if allowFlowReversal then
          -Modelica.Constants.inf
        else
          0),
    each h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default)) if have_chiWat
    "Chilled water inlet ports"
    annotation (Placement(transformation(extent={{-310,-300},{-290,-220}}),
      iconTransformation(extent={{-310,-220},{-290,-140}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bChiWat[nPorts_bChiWat](
    redeclare each package Medium=Medium,
    each m_flow(
      max=
        if allowFlowReversal then
          +Modelica.Constants.inf
        else
          0),
    each h_outflow(
      start=Medium.h_default,
      nominal=Medium.h_default)) if have_chiWat
    "Chilled water outlet ports"
    annotation (Placement(transformation(extent={{290,-300},{310,-220}}),
      iconTransformation(extent={{290,-220},{310,-140}})));
  Modelica.Blocks.Interfaces.RealOutput QHea_flow(
    final unit="W") if have_heaLoa
    "Total heating heat flow rate transferred to the loads (>=0)"
    annotation (Placement(transformation(extent={{300,260},{340,300}}),
      iconTransformation(extent={{300,240},{340,280}})));
  Modelica.Blocks.Interfaces.RealOutput QCoo_flow(
    final unit="W") if have_cooLoa
    "Total cooling heat flow rate transferred to the loads (<=0)"
    annotation (Placement(transformation(extent={{300,220},{340,260}}),
      iconTransformation(extent={{300,200},{340,240}})));
  Modelica.Blocks.Interfaces.RealOutput PHea(
    final unit="W") if have_eleHea
    "Power drawn by decentralized heating system"
    annotation (Placement(transformation(extent={{300,180},{340,220}}),
      iconTransformation(extent={{300,160},{340,200}})));
  Modelica.Blocks.Interfaces.RealOutput PCoo(
    final unit="W") if have_eleCoo
    "Power drawn by decentralized cooling system"
    annotation (Placement(transformation(extent={{300,140},{340,180}}),
      iconTransformation(extent={{300,120},{340,160}})));
  Modelica.Blocks.Interfaces.RealOutput PFan(
    final quantity="Power",
    final unit="W") if have_fan
    "Power drawn by fan motors"
    annotation (Placement(transformation(extent={{300,100},{340,140}}),
      iconTransformation(extent={{300,80},{340,120}})));
  Modelica.Blocks.Interfaces.RealOutput PPum(
    final quantity="Power",
    final unit="W") if have_pum
    "Power drawn by pump motors"
    annotation (Placement(transformation(extent={{300,60},{340,100}}),
      iconTransformation(extent={{300,40},{340,80}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulHeaWatInl[nPorts_aHeaWat](
    redeclare each final package Medium = Medium,
    each final k=1/facMul,
    each final allowFlowReversal=allowFlowReversal) if have_heaWat
    "Mass flow rate multiplier"
    annotation (Placement(transformation(extent={{-280,-70},{-260,-50}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulChiWatInl[nPorts_aChiWat](
    redeclare each final package Medium = Medium,
    each final k=1/facMul,
    each final allowFlowReversal=allowFlowReversal) if have_chiWat
    "Mass flow rate multiplier"
    annotation (Placement(transformation(extent={{-280,-270},{-260,-250}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulHeaWatOut[nPorts_bHeaWat](
    redeclare each final package Medium = Medium,
    each final k=facMul,
    each final allowFlowReversal=allowFlowReversal) if have_heaWat
    "Mass flow rate multiplier"
    annotation (Placement(transformation(extent={{260,-70},{280,-50}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulChiWatOut[nPorts_bChiWat](
    redeclare each final package Medium = Medium,
    each final k=facMul,
    each final allowFlowReversal=allowFlowReversal) if have_chiWat
    "Mass flow rate multiplier"
    annotation (Placement(transformation(extent={{260,-270},{280,-250}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulQHea_flow(u(
        final unit="W"), final k=facMul) if have_heaLoa "Scaling"
    annotation (Placement(transformation(extent={{270,270},{290,290}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulQCoo_flow(u(
        final unit="W"), final k=facMul) if have_cooLoa "Scaling"
    annotation (Placement(transformation(extent={{270,230},{290,250}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulPHea(u(final
        unit="W"), final k=facMul) if have_eleHea "Scaling"
    annotation (Placement(transformation(extent={{270,190},{290,210}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulPCoo(u(final
        unit="W"), final k=facMul) if have_eleCoo "Scaling"
    annotation (Placement(transformation(extent={{270,150},{290,170}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulPFan(u(final
        unit="W"), final k=facMul) if have_fan "Scaling"
    annotation (Placement(transformation(extent={{270,110},{290,130}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter mulPPum(u(final
        unit="W"), final k=facMul) if have_pum "Scaling"
    annotation (Placement(transformation(extent={{270,70},{290,90}})));
protected
  final parameter Modelica.Units.SI.SpecificHeatCapacity cp_default=
      Medium.specificHeatCapacityCp(Medium.setState_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default))
    "Specific heat capacity of medium at default medium state";
initial equation
  assert(
    nPorts_aHeaWat == nPorts_bHeaWat,
    "In "+getInstanceName()+": The numbers of heating water inlet ports ("+String(
      nPorts_aHeaWat)+") and outlet ports ("+String(
      nPorts_bHeaWat)+") must be equal.");
  assert(
    nPorts_aChiWat == nPorts_bChiWat,
    "In "+getInstanceName()+": The numbers of chilled water inlet ports ("+String(
      nPorts_aChiWat)+") and outlet ports ("+String(
      nPorts_bChiWat)+") must be equal.");
equation
  connect(mulQHea_flow.y, QHea_flow)
    annotation (Line(points={{292,280},{320,280}}, color={0,0,127}));
  connect(mulQCoo_flow.y, QCoo_flow)
    annotation (Line(points={{292,240},{320,240}}, color={0,0,127}));
  connect(mulPHea.y, PHea)
    annotation (Line(points={{292,200},{320,200}}, color={0,0,127}));
  connect(mulPCoo.y, PCoo)
    annotation (Line(points={{292,160},{320,160}}, color={0,0,127}));
  connect(mulPFan.y, PFan)
    annotation (Line(points={{292,120},{320,120}}, color={0,0,127}));
  connect(mulPPum.y, PPum)
    annotation (Line(points={{292,80},{320,80}}, color={0,0,127}));
  connect(ports_aChiWat,mulChiWatInl. port_a)
    annotation (Line(points={{-300,-260},{-280,-260}}, color={0,127,255}));
  connect(ports_aHeaWat,mulHeaWatInl. port_a)
    annotation (Line(points={{-300,-60},{-280,-60}}, color={0,127,255}));
  connect(mulHeaWatOut.port_b, ports_bHeaWat)
    annotation (Line(points={{280,-60},{300,-60}}, color={0,127,255}));
  connect(mulChiWatOut.port_b, ports_bChiWat)
    annotation (Line(points={{280,-260},{300,-260}}, color={0,127,255}));
  annotation (
    Documentation(
      info="<html>
<p>
Partial model to be used for modeling the thermal loads on an energy
transfer station or a dedicated plant.
Models extending this class are typically used in conjunction with
<a href=\"modelica://Buildings.DHC.Loads.BaseClasses.FlowDistribution\">
Buildings.DHC.Loads.BaseClasses.FlowDistribution</a>
and models extending
<a href=\"modelica://Buildings.DHC.Loads.BaseClasses.PartialTerminalUnit\">
Buildings.DHC.Loads.BaseClasses.PartialTerminalUnit</a>
as described in the schematics here under.
The fluid ports represent the connection between the production system and
the building distribution system.
</p>
<h4>Scaling</h4>
<p>
Scaling is implemented by means of a multiplier factor <code>facMul</code>.
Each extensive quantity (mass and heat flow rate, electric power)
<i>flowing out</i> through fluid ports, or connected to an
<i>output connector</i> is multiplied by <code>facMul</code>.
Each extensive quantity (mass and heat flow rate, electric power)
<i>flowing in</i> through fluid ports, or connected to an
<i>input connector</i> is multiplied by <code>1/facMul</code>.
This allows modeling, with a single instance,
multiple identical buildings served by the same energy transfer station.
</p>
<h4>Examples</h4>
<p>
See various use cases in
<a href=\"modelica://Buildings.DHC.Loads.BaseClasses.Examples\">
Buildings.DHC.Loads.BaseClasses.Examples</a>.
</p>
<p>
<br/>
<img alt=\"image\"
src=\"modelica://Buildings/Resources/Images/DHC/Loads/PartialBuilding.png\"/>
</p>
</html>",
revisions="<html>
<ul>
<li>
December 21, 2020, by Antoine Gautier:<br/>
Added multiplier factor.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2291\">issue 2291</a>.
</li>
<li>
February 21, 2020, by Antoine Gautier:<br/>
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
          extent={{-300,-172},{300,-188}},
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
          textColor={0,0,255},
          textString="%name"),
        Rectangle(
          extent={{-300,-68},{300,-52}},
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
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-300,-300},{300,300}})));
end PartialBuilding;
