within Buildings.Fluid.FMI.ExportContainers.Examples.FMUs;
block ResistanceVolume
  "Declaration of an FMU that exports a flow resistance and control volume"
  extends Buildings.Fluid.FMI.ExportContainers.PartialTwoPort(
    redeclare package Medium = Buildings.Media.Air);

  parameter Modelica.Units.SI.Volume V=1 "Volume";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.01
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.PressureDifference dp_nominal=100
    "Nominal pressure drop";

  Modelica.Blocks.Sources.RealExpression dpCom(y=res.port_a.p - res.port_b.p)
    if use_p_in "Pressure drop of the component"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));

protected
  Buildings.Fluid.FMI.Adaptors.Inlet bouIn(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_p_in=use_p_in) "Boundary model for inlet"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.FMI.Adaptors.Outlet bouOut(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_p_in=use_p_in) "Boundary component for outlet"
    annotation (Placement(transformation(extent={{68,-10},{88,10}})));

  Modelica.Blocks.Math.Feedback pOut if use_p_in "Pressure at component outlet"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));

  FixedResistances.PressureDrop res(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=if use_p_in then dp_nominal else 0,
    final allowFlowReversal=allowFlowReversal) "Flow resistance"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    nPorts=2,
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final allowFlowReversal=allowFlowReversal,
    final V=V,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Control volume"
    annotation (Placement(transformation(extent={{10,0},{30,20}})));

equation
  connect(inlet, bouIn.inlet) annotation (Line(
      points={{-110,0},{-81,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(bouOut.outlet, outlet) annotation (Line(
      points={{89,0},{110,0}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(pOut.u1, bouIn.p) annotation (Line(
      points={{12,-60},{-70,-60},{-70,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pOut.y, bouOut.p) annotation (Line(
      points={{29,-60},{78,-60},{78,-12}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(res.port_b, vol.ports[1]) annotation (Line(
      points={{-20,0},{18,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(bouIn.port_b, res.port_a) annotation (Line(
      points={{-60,0},{-40,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpCom.y, pOut.u2) annotation (Line(
      points={{-19,-80},{20,-80},{20,-68}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(vol.ports[2], bouOut.port_a) annotation (Line(
      points={{22,0},{68,0}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Documentation(info="<html>
<p>
This example demonstrates how to export an FMU with a
flow resistance and a control volume.
The FMU has an instance of
<a href=\"modelica://Buildings.Fluid.FixedResistances.PressureDrop\">
Buildings.Fluid.FixedResistances.PressureDrop</a> and
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>.
</p>
<p>
The mass dynamics has been set to
<code>massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState</code>.
See the
<a href=\"modelica://Buildings.Fluid.FMI.UsersGuide\">user's guide</a>
for the rationale.
</p>
</html>", revisions="<html>
<ul>
<li>
January 22, 2016, by Michael Wetter:<br/>
Corrected type declaration of pressure difference.
This is
for <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/404\">#404</a>.
</li>
<li>
November 8, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Examples/FMUs/ResistanceVolume.mos"
        "Export FMU"),
    Icon(graphics={
        Rectangle(
          extent={{-64,24},{-6,-26}},
          lineColor={0,0,0},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={192,192,192}),
        Rectangle(
          extent={{-100,14},{100,-16}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
                              Ellipse(
          extent={{18,32},{84,-34}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={170,213,255})}));
end ResistanceVolume;
