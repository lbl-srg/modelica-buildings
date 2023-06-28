within Buildings.Fluid.CHPs.Rankine.BaseClasses;
model HeaterCooler_Q
  "Heater or cooler with prescribed heat flow rate"
  extends Buildings.Fluid.Interfaces.TwoPortHeatMassExchanger(
    redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol(
    final prescribedHeatFlowRate=true));

  Modelica.Blocks.Interfaces.RealInput Q_flow(unit="W")
    "Heat added to the fluid"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
protected
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea(
    final alpha=0)
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
equation
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{-20,60},{-9,60},{-9,-10}},
      color={191,0,0}));
  connect(preHea.Q_flow, Q_flow)
    annotation (Line(points={{-40,60},{-120,60}}, color={0,0,127}));
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
          textString="Q=Q_flow"),
        Rectangle(
          extent={{-100,60},{-70,58}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-122,106},{-78,78}},
          textColor={0,0,127},
          textString="Q_flow")}),
defaultComponentName="hea",
Documentation(info="<html>
<p>
Model for an ideal heater or cooler with prescribed heat flow rate to the medium.
This model is similar to
<a href=\"Modelica://Buildings.Fluid.HeatExchangers.HeaterCooler_u\">
Buildings.Fluid.HeatExchangers.HeaterCooler_u</a>.
The difference is that instead using a control signal <code>u</code>,
this model directly uses <code>Q_flow</code> as input.
</p>
[fixme: note - This model is specifically made for the Rankine cycle model.
Pending review, it can be moved to Buildings.Fluid.HeatExchangers.]
</html>",
revisions="<html>
<ul>
<li>
June 28, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end HeaterCooler_Q;
