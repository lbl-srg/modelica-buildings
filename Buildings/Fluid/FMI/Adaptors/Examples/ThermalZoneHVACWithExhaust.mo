within Buildings.Fluid.FMI.Adaptors.Examples;
model ThermalZoneHVACWithExhaust
  "Example of a thermal zone and an HVAC system both exposed using the FMI adaptor"
  extends Buildings.Fluid.FMI.Adaptors.Examples.ThermalZoneHVACNoExhaust(
    hvacAda(nPorts=3),
    out(nPorts=3),
    con(nPorts=3),
    vol(nPorts=3));

  Movers.FlowControlled_m_flow exh(
    redeclare package Medium = MediumA,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    dp_nominal=1200,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    use_inputFilter=false,
    m_flow_nominal=0.1*m_flow_nominal) "Constant air exhaust"
    annotation (Placement(transformation(extent={{-70,-70},{-90,-50}})));
equation
  connect(hvacAda.ports[3], exh.port_a) annotation (Line(points={{20,10},{10,10},
          {10,8},{0,8},{0,-60},{-70,-60}}, color={0,127,255}));
  connect(exh.port_b, out.ports[3]) annotation (Line(points={{-90,-60},{-126,
          -60},{-126,-60},{-126,-20},{-140,-20}},
                                             color={0,127,255}));
  connect(con.ports[3], vol.ports[3])
    annotation (Line(points={{100,10},{150,10},{150,20}}, color={0,127,255}));

 annotation (
    Documentation(info="<html>
<p>
This example demonstrates how to
use the adaptors
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.HVAC\">
Buildings.Fluid.FMI.Adaptors.HVAC</a>
and
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.ThermalZone\">
Buildings.Fluid.FMI.Adaptors.ThermalZone</a>
</p>
<p>
It is identical to
<a href=\"modelica://Buildings.Fluid.FMI.Adaptors.Examples.ThermalZoneHVACNoExhaust\">
Buildings.Fluid.FMI.Adaptors.Examples.ThermalZoneHVACNoExhaust</a>
except that it adds a forced exhaust air stream.
</p>
</html>", revisions="<html>
<ul>
<li>
June 29, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Adaptors/Examples/ThermalZoneHVACWithExhaust.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=172800));
end ThermalZoneHVACWithExhaust;
