within Buildings.HeatTransfer;
model Convection "Model for a convective heat transfer"
  extends Buildings.BaseClasses.BaseIcon;
  import c = Buildings.HeatTransfer.Functions.ConvectiveHeatFlux;
  replaceable function qCon_flow =
      Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.constantCoefficient
                                                 constrainedby
    Buildings.HeatTransfer.Functions.ConvectiveHeatFlux.BaseClasses.PartialConvectiveHeatFlux(
      dT=dT) "Function for convective heat transfer coefficient"
   annotation(choicesAllMatching=true);
  parameter Modelica.SIunits.Area A "Heat transfer area";
  Modelica.SIunits.HeatFlowRate Q_flow "Heat flow rate from solid -> fluid";
  Modelica.SIunits.TemperatureDifference dT(start=0) "= solid.T - fluid.T";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a solid
                              annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}},      rotation=0)));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b fluid
                              annotation (Placement(transformation(extent={{90,-10},
            {110,10}},         rotation=0)));
equation
  dT = solid.T - fluid.T;
  solid.Q_flow = Q_flow;
  fluid.Q_flow = -Q_flow;
  // Even if hCon is a step function with a step at zero,
  // the product hCon*dT is differentiable at zero with
  // a continuous first derivative
  Q_flow = A*qCon_flow();

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-90,80},{-60,-80}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Line(points={{100,0},{100,0}}, color={0,127,255}),
        Text(
          extent={{-35,42},{-5,20}},
          lineColor={255,0,0},
          textString="Q_flow"),
        Line(points={{-60,20},{76,20}}, color={191,0,0}),
        Line(points={{-60,-20},{76,-20}}, color={191,0,0}),
        Line(points={{-34,80},{-34,-80}}, color={0,127,255}),
        Line(points={{6,80},{6,-80}}, color={0,127,255}),
        Line(points={{40,80},{40,-80}}, color={0,127,255}),
        Line(points={{76,80},{76,-80}}, color={0,127,255}),
        Line(points={{-34,-80},{-44,-60}}, color={0,127,255}),
        Line(points={{-34,-80},{-24,-60}}, color={0,127,255}),
        Line(points={{6,-80},{-4,-60}}, color={0,127,255}),
        Line(points={{6,-80},{16,-60}}, color={0,127,255}),
        Line(points={{40,-80},{30,-60}}, color={0,127,255}),
        Line(points={{40,-80},{50,-60}}, color={0,127,255}),
        Line(points={{76,-80},{66,-60}}, color={0,127,255}),
        Line(points={{76,-80},{86,-60}}, color={0,127,255}),
        Line(points={{56,-30},{76,-20}}, color={191,0,0}),
        Line(points={{56,-10},{76,-20}}, color={191,0,0}),
        Line(points={{56,10},{76,20}}, color={191,0,0}),
        Line(points={{56,30},{76,20}}, color={191,0,0})}),
    Documentation(info="<html>
This is a model for a convective heat transfer.
The model can be configured to use various functions
from the package
<a href=\"modelica://Buildings.HeatTransfer.Functions.ConvectiveHeatFlux\">
Buildings.HeatTransfer.Functions.ConvectiveHeatFlux</a>
to compute the convective heat transfer.
</html>", revisions="<html>
<ul>
<li>
March 10 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Convection;
