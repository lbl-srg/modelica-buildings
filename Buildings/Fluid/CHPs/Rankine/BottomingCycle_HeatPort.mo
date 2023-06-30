within Buildings.Fluid.CHPs.Rankine;
model BottomingCycle_HeatPort
  "Model for the Rankine cycle as a bottoming cycle using a heat port"
  extends BaseClasses.PartialBottomingCycle;

  // Input properties

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    "Working fluid connector a (corresponding to the evaporator)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}}),
      iconTransformation(extent={{-10,90},{10,110}})));

  Buildings.HeatTransfer.Sources.FixedTemperature preTemEva(final T=TEva)
    "Working fluid temperature on the evaporator side"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSenEva
    "Heat flow on the evaporator side"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

equation
  connect(preTemEva.port, heaFloSenEva.port_a)
    annotation (Line(points={{-60,70},{-40,70}}, color={191,0,0}));
  connect(heaFloSenEva.port_b, port_a)
    annotation (Line(points={{-20,70},{0,70},{0,100}}, color={191,0,0}));
  connect(heaFloSenEva.Q_flow, mulExp.u1)
    annotation (Line(points={{-30,59},{-30,-24},{18,-24}},
                                                         color={0,0,127}));
  connect(mulCon.u2, heaFloSenEva.Q_flow)
    annotation (Line(points={{18,-86},{-30,-86},{-30,59}}, color={0,0,127}));
annotation (defaultComponentName="ran",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-149,-100},{151,-140}},
          textColor={0,0,255},
          textString="%name")}),                               Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
[fixme: draft implementation.]<br/>
This model uses the Rankine cycle as a bottoming cycle.
<a href=\"modelica://Buildings.Fluid.CHPs.Rankine.Examples.ORC_HeatPort\">
Buildings.Fluid.CHPs.Rankine.Examples.ORCWithHeatExchangers</a>
demonstrates how this model can be connected with heat exchangers.
</html>", revisions="<html>
<ul>
<li>
June 13, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end BottomingCycle_HeatPort;
