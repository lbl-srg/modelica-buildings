within Buildings.Fluid.FMI.ExportContainers.Validation.FMUs;
block HVACThermalZoneAir1 "Validation model for the convective HVAC system"
  extends Buildings.Fluid.FMI.ExportContainers.HVACZone(
    redeclare package Medium = Buildings.Media.Air,
    hvacAda(nPorts=2));

protected
  Sources.Boundary_pT bou(
    redeclare package Medium = Medium,
    nPorts=1) "Boundary condition"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  FixedResistances.PressureDrop sup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=0.1,
    final dp_nominal=200,
    from_dp=true) "Supply air duct"
    annotation (Placement(transformation(extent={{60,130},{80,150}})));
  FixedResistances.PressureDrop ret(
    redeclare final package Medium = Medium,
    final m_flow_nominal=0.1,
    final dp_nominal=200) "Return air duct"
    annotation (Placement(transformation(extent={{80,90},{60,110}})));
  Modelica.Blocks.Sources.Constant zero(k=0) "Zero output signal"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));
protected
  Sources.MassFlowSource_T sou(
    redeclare package Medium = Medium,
    nPorts=1,
    m_flow=0.1) "Mass flow source"
    annotation (Placement(transformation(extent={{20,130},{40,150}})));
equation
  connect(bou.ports[1], ret.port_b) annotation (Line(points={{40,100},{40,100},
          {60,100}},        color={0,127,255}));
  connect(zero.y, QGaiRad_flow) annotation (Line(points={{121,-90},{140,-90},{140,
          -40},{180,-40}}, color={0,0,127}));
  connect(zero.y, QGaiSenCon_flow)
    annotation (Line(points={{121,-90},{142,-90},{180,-90}},
                                                           color={0,0,127}));
  connect(zero.y, QGaiLat_flow) annotation (Line(points={{121,-90},{140,-90},{140,
          -140},{180,-140}},
                           color={0,0,127}));
  connect(sup.port_b, hvacAda.ports[1]) annotation (Line(points={{80,140},{100,
          140},{120,140}},          color={0,127,255}));
  connect(ret.port_a, hvacAda.ports[2]) annotation (Line(points={{80,100},{100,
          100},{100,140},{120,140}},
                               color={0,127,255}));
  connect(sou.ports[1], sup.port_a)
    annotation (Line(points={{40,140},{50,140},{60,140}}, color={0,127,255}));
annotation (
    Documentation(info="<html>
<p>
This example validates that
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.HVACZone\">
Buildings.Fluid.FMI.ExportContainers.HVACZone</a>
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
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Validation/FMUs/HVACThermalZoneAir1.mos"
        "Export FMU"));
end HVACThermalZoneAir1;
