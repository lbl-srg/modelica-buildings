within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
model DryCoil "Calculates dry coil condition"
 extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialCoilCondition;
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
      annotation (choicesAllMatching=true);
equation

  connect(TEvaIn, cooCap.TEvaIn) annotation (Line(
      points={{-110,5.55112e-16},{-32,5.55112e-16},{-32,45.2},{-15,45.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mCon_flow, cooCap.mCon_flow) annotation (Line(points={{-110,-100},{
          -92,-100},{-92,40},{-15,40}}, color={0,0,127}));
  annotation (defaultComponentName="dryCoi", Documentation(info="<html>
<p>
This block calculates the rate of cooling and the coil surface condition
under the assumption that the coil is dry.
</p>
<p>
The wet coil conditions are computed in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.WetCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.WetCoil</a>.
See
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">
Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide</a>
for an explanation of the model.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 12, 2012 by Kaustubh Phalak:<br/>
First implementation.
</li>
</ul>

</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-54,36},{68,20}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Text(
          extent={{-62,-18},{80,-54}},
          textColor={0,0,0},
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          textString="Dry Coil"),
        Line(
          points={{-42,48},{-16,48}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{-12,48},{-16,46},{-16,50},{-12,48}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-8,10},{18,10}},
          color={0,0,255},
          smooth=Smooth.None),
        Line(
          points={{14,46},{40,46}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{44,46},{40,44},{40,48},{44,46}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{22,10},{18,8},{18,12},{22,10}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}));
end DryCoil;
