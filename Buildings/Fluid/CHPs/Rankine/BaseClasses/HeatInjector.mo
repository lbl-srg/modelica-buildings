within Buildings.Fluid.CHPs.Rankine.BaseClasses;
model HeatInjector
  "Heater or cooler with prescribed heat flow rate through a heat port"
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol(
    final prescribedHeatFlowRate=true));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(unit="W")
    "Heat added to the fluid"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPor "External port"
    annotation (Placement(transformation(extent={{-5,-55},{5,-65}}),
        iconTransformation(extent={{-5,-55},{5,-65}})));
  Modelica.Blocks.Sources.RealExpression realExpression(y=heaPor.Q_flow)
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
protected
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea(
    final alpha=0)
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
equation
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{-20,60},{-9,60},{-9,-10}},
      color={191,0,0}));
  connect(realExpression.y, preHea.Q_flow)
    annotation (Line(points={{-59,60},{-40,60}}, color={0,0,127}));
  connect(realExpression.y, Q_flow) annotation (Line(points={{-59,60},{-48,60},{
          -48,76},{96,76},{96,60},{110,60}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,8},{101,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-70,-60},{70,60},{-70,60},{-70,-60}},
          fillColor={127,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Polygon(
          points={{-70,-60},{70,60},{70,-60},{-70,-60}},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-56,-12},{54,-72}},
          textColor={255,255,255},
          textString="Q_flow")}),
defaultComponentName="hea",
Documentation(info="<html>
<p>
Model for an ideal heater or cooler with prescribed heat flow rate to the medium
through a heat port.
The temperature of the medium passing through this component and
the temperature of the external port are disconnected.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 26, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end HeatInjector;
