within Buildings.Fluid.HeatExchangers;
model HeaterCoolerHumidifier_u
  "A heating and humidifcation block"
  extends MassExchangers.Humidifier_u;
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal
    "Heat flow rate at u=1, positive for heating";
  Modelica.Blocks.Interfaces.RealInput u1
    "Control input for heat flow"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}})));
  Modelica.Blocks.Math.Gain gai1(k=Q_flow_nominal)
    "Gain for heat flow"
    annotation (Placement(transformation(extent={{-78,-64},{-58,-44}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea(
    final alpha=0)
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{-46,-64},{-26,-44}})));
equation
  connect(u1, gai1.u)
    annotation (Line(points={{-120,-90},{-90,-90},{-90,-54},{-80,-54}},
                     color={0,0,127}));
  connect(gai1.y, preHea.Q_flow)
    annotation (Line(points={{-57,-54},{-46,-54}}, color={0,0,127}));
  connect(preHea.port, vol.heatPort)
  annotation (Line(points={{-26,-54},{-16,-54},{-16,-10},{-9,-10}},
                   color={191,0,0}));
  annotation (Icon(graphics={
        Rectangle(
          extent={{-100,-89},{-78,-92}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-16.75,1.25},{16.75,-1.25}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid,
          origin={-79.25,-74.75},
          rotation=90),
        Rectangle(
          extent={{-80,-57},{-70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-56,72},{54,12}},
          lineColor={0,0,255},
          textString="q=%Q_flow_nominal")}), Documentation(revisions="<html>
<ul>
<li>
March 17, 2017, by Michael O'Keefe:<br/>
First implementation. See
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/622\">
issue 622</a> for more information.
</li>
</ul>
</html>"));
end HeaterCoolerHumidifier_u;
