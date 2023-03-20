within Buildings.Fluid.Storage.Plant.BaseClasses;
model IdealTemperatureSource
  "Sets a prescribed temperature at port_b"
  extends Interfaces.PartialTwoPortInterface;

  parameter Modelica.Units.SI.Temperature TSet "Temperature set point";

protected
  Modelica.Units.SI.SpecificEnthalpy hSet =
    Medium.specificEnthalpy_pTX(
      p=port_b.p,
      T=TSet,
      X=cat(1, port_b.Xi_outflow, {1-sum(port_b.Xi_outflow)}));

equation
  dp=0;

  // Set state at port_b
  port_a.h_outflow = Medium.h_default;
  port_b.h_outflow = hSet;

  // Mass balance (no storage)
  port_a.m_flow + port_b.m_flow = 0;

  // Transport of substances
  port_a.Xi_outflow = Medium.X_default[1:Medium.nXi];
  port_b.Xi_outflow = inStream(port_a.Xi_outflow);

  port_a.C_outflow = zeros(Medium.nC);
  port_b.C_outflow = inStream(port_a.C_outflow);
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-1.5,-87.5},{1.5,87.5}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0},
          origin={-11.5,-0.5},
          rotation=90),
        Polygon(
          points={{-6,2},{2.74617e-16,-16},{-12,-16},{-6,2}},
          lineColor={28,108,200},
          lineThickness=1,
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid,
          origin={72,10},
          rotation=-90),
        Line(points={{56,16},{16,16}},   color={0,127,255}),
        Text(
          extent={{-98,56},{12,4}},
          textColor={28,108,200},
          textString=DynamicSelect("T:=", "T:=" + String(TSet-273.15, format=".1f")))}),
defaultComponentName="ideTemSou",
    Documentation(info="<html>
<p>
This model is an ideal temperature source that outputs fluid that passes
through at a fixed temperature, with no flow resistance or transport delay.
It is used in this package to replace chillers or energy consumers as an
efficient simplification. It is similar to
<a href=\"Modelica://Buildings.Fluid.FixedResistances.LosslessPipe\">
Buildings.Fluid.FixedResistances.LosslessPipe</a>,
except that there is heat transfer unless the temperature at
<code>port_a</code> is already equal to <code>TSet</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 8, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end IdealTemperatureSource;
