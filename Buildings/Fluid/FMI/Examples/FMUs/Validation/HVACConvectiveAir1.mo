within Buildings.Fluid.FMI.Examples.FMUs.Validation;
block HVACConvectiveAir1 "Validation model for the convective HVAC system"
  extends Buildings.Fluid.FMI.HVACConvective(
    redeclare package Medium = Buildings.Media.Air,
    use_p_in = true,
    allowFlowReversal = true);
protected
  Sources.Boundary_pT bou(redeclare package Medium = Medium, nPorts=2)
    "Boundary condition"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  FixedResistances.FixedResistanceDpM sup(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=0.1,
    final dp_nominal=200) "Supply air duct"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  FixedResistances.FixedResistanceDpM ret(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=0.1,
    final dp_nominal=200) "Return air duct"
    annotation (Placement(transformation(extent={{40,60},{20,80}})));
equation
  connect(bou.ports[1], sup.port_a) annotation (Line(points={{-20,92},{-16,92},{
          -16,110},{20,110}}, color={0,127,255}));
  connect(bou.ports[2], ret.port_b) annotation (Line(points={{-20,88},{-16,88},{
          -16,70},{20,70}}, color={0,127,255}));
  connect(sup.port_b, theZonAda.sup) annotation (Line(points={{40,110},{80,110},
          {80,96},{120,96}}, color={0,127,255}));
  connect(ret.port_a, theZonAda.ret) annotation (Line(points={{40,70},{80,70},{80,
          86},{120,86}}, color={0,127,255}));
annotation (
    Documentation(info="<html>
<p>
This example validates that
<a href=\"modelica://Buildings.Fluid.FMI.HVACConvective\">
Buildings.Fluid.FMI.HVACConvective</a>
exports correctly as an FMU.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14, 2016 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Examples/FMUs/Validation/HVACConvectiveAir1.mos"
        "Export FMU"));
end HVACConvectiveAir1;
