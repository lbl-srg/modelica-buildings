within Buildings.Fluid.CHPs.Rankine;
model BottomingCycle_HeatPort
  "Model for the Rankine cycle as a bottoming cycle using a heat port"
  extends BaseClasses.PartialBottomingCycle;

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    "Working fluid connector a (corresponding to the evaporator)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}}),
      iconTransformation(extent={{-10,90},{10,110}})));

protected
  Buildings.HeatTransfer.Sources.FixedTemperature preTem(final T=TEva)
    "Working fluid temperature on the evaporator side"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen
    "Heat flow on the evaporator side"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

equation
  connect(preTem.port, heaFloSen.port_a)
    annotation (Line(points={{-60,70},{-40,70}}, color={191,0,0}));
  connect(heaFloSen.port_b, port_a)
    annotation (Line(points={{-20,70},{0,70},{0,100}}, color={191,0,0}));
  connect(heaFloSen.Q_flow, mulExp.u1)
    annotation (Line(points={{-30,59},{-30,-24},{18,-24}}, color={0,0,127}));
  connect(mulCon.u2, heaFloSen.Q_flow)
    annotation (Line(points={{18,-86},{-30,-86},{-30,59}}, color={0,0,127}));
annotation (defaultComponentName="ORC",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-149,-114},{151,-154}},
          textColor={0,0,255},
          textString="%name")}),                               Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
[fixme: draft implementation.]<br/>
This model uses the Rankine cycle as a bottoming cycle and interfaces with
other components via a heat port. Unlike its sister model
<a href=\"modelica://Buildings.Fluid.CHPs.Rankine.BottomingCycle_FluidPort\">
Buildings.Fluid.CHPs.Rankine.BottomingCycle_FluidPort</a>,
this model does not prevent heat back flow.
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
