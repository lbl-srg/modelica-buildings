within Buildings.HeatTransfer.Convection;
model Interior
  "Model for a interior (room-side) convective heat transfer"
  extends Buildings.HeatTransfer.Convection.BaseClasses.PartialConvection;

  parameter Buildings.HeatTransfer.Types.InteriorConvection conMod=
    Buildings.HeatTransfer.Types.InteriorConvection.Fixed
    "Convective heat transfer model"
  annotation(Evaluate=true);

equation
  if (conMod == Buildings.HeatTransfer.Types.InteriorConvection.Fixed) then
    q_flow = hFixed * dT;
  else
    // Even if hCon is a step function with a step at zero,
    // the product hCon*dT is differentiable at zero with
    // a continuous first derivative
    if isCeiling then
       q_flow = Buildings.HeatTransfer.Convection.Functions.ConvectiveHeatFlux.ceiling(dT=dT);
    elseif isFloor then
       q_flow = Buildings.HeatTransfer.Convection.Functions.ConvectiveHeatFlux.floor(dT=dT);
    else
       q_flow = Buildings.HeatTransfer.Convection.Functions.ConvectiveHeatFlux.wall(dT=dT);
    end if;
  end if;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},
            {100,100}}),       graphics), Icon(coordinateSystem(
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
    defaultComponentName="con",
    Documentation(info="<html>
This is a model for a convective heat transfer for interior, room-facing surfaces.
The parameter <code>conMod</code> determines the model that is used to compute
the heat transfer coefficient:
</p>
<p>
<ol>
<li><p>If <code>conMod=<a href=\"modelica://Buildings.HeatTransfer.Types.InteriorConvection\">
Buildings.HeatTransfer.Types.InteriorConvection.Fixed</a></code>, then
the convective heat transfer coefficient is set to the value specified by the parameter
<code>hFixed</code>.
</p>
</li>
</li>
<p>
If <code>conMod=<a href=\"modelica://Buildings.HeatTransfer.Types.InteriorConvection\">
Buildings.HeatTransfer.Types.InteriorConvection.Temperature</a></code>, then
the convective heat tranfer coefficient is a function of the temperature difference.
The convective heat flux is computed using
</p>
<ol>
<li>
for floors the function 
<a href=\"modelica://Buildings.HeatTransfer.Convection.Functions.ConvectiveHeatFlux.floor\">
Buildings.HeatTransfer.Functions.Convection.ConvectiveHeatFlux.floor</a>
</li>
<li>
for ceilings the function
<a href=\"modelica://Buildings.HeatTransfer.Functions.Convection.ConvectiveHeatFlux.ceiling\">
Buildings.HeatTransfer.Functions.Convection.ConvectiveHeatFlux.ceiling</a>
</li>
<li>
for walls the function
<a href=\"modelica://Buildings.HeatTransfer.Functions.Convection.ConvectiveHeatFlux.wall\">
Buildings.HeatTransfer.Functions.Convection.ConvectiveHeatFlux.wall</a>
</li>
</ol>
</li>
</html>", revisions="<html>
<ul>
<li>
March 10 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Interior;
