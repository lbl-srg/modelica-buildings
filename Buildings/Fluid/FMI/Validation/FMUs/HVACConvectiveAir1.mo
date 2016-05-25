within Buildings.Fluid.FMI.Validation.FMUs;
block HVACConvectiveAir1 "Validation model for the convective HVAC system"
  extends Buildings.Fluid.FMI.ExportContainers.HVACConvectiveSingleZone(
    redeclare package Medium = Buildings.Media.Air,
    theZonAda(nPorts=2));

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
protected
  Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=2) "Boundary condition"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
  FixedResistances.FixedResistanceDpM sup(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=0.1,
    final dp_nominal=200,
    from_dp=true) "Supply air duct"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));
  FixedResistances.FixedResistanceDpM ret(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=0.1,
    final dp_nominal=200) "Return air duct"
    annotation (Placement(transformation(extent={{40,60},{20,80}})));
  Modelica.Blocks.Sources.Constant zero(k=0) "Zero output signal"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
equation
  connect(bou.ports[1], sup.port_a) annotation (Line(points={{-20,92},{-16,92},{
          -16,110},{20,110}}, color={0,127,255}));
  connect(bou.ports[2], ret.port_b) annotation (Line(points={{-20,88},{-16,88},{
          -16,70},{20,70}}, color={0,127,255}));
  connect(zero.y, QGaiRad_flow) annotation (Line(points={{121,-90},{140,-90},{140,
          -40},{180,-40}}, color={0,0,127}));
  connect(zero.y, QGaiCon_flow)
    annotation (Line(points={{121,-90},{142,-90},{180,-90}},
                                                           color={0,0,127}));
  connect(zero.y, QGaiLat_flow) annotation (Line(points={{121,-90},{140,-90},{140,
          -140},{180,-140}},
                           color={0,0,127}));
  connect(sup.port_b, theZonAda.ports[1]) annotation (Line(points={{40,110},{76,
          110},{76,100},{110,100}}, color={0,127,255}));
  connect(ret.port_a, theZonAda.ports[2]) annotation (Line(points={{40,70},{76,70},
          {76,100},{110,100}}, color={0,127,255}));
annotation (
    Documentation(info="<html>
<p>
This example validates that
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.HVACConvectiveSingleZone\">
Buildings.Fluid.FMI.ExportContainers.HVACConvectiveSingleZone</a>
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
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Validation/FMUs/HVACConvectiveAir1.mos"
        "Export FMU"));
end HVACConvectiveAir1;
