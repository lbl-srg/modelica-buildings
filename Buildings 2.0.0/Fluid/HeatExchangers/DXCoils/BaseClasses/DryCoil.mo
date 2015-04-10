within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
model DryCoil "Calculates dry coil condition"
 extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialCoilCondition;
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
      annotation (choicesAllMatching=true);
  Modelica.Blocks.Interfaces.RealOutput TDry(
    quantity="ThermodynamicTemperature",
    unit="K",
    min=233.15,
    max=373.15) "Dry bulb temperature of air at ADP"
     annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDryPoint appDryPt(
    redeclare package Medium = Medium,
    final datCoi=datCoi,
    final variableSpeedCoil=variableSpeedCoil)
    "Calculates air properties at dry coil condition"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
equation
  connect(appDryPt.TDry, TDry) annotation (Line(
      points={{81,-40},{110,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hEvaIn, appDryPt.hEvaIn) annotation (Line(
      points={{-110,-77},{-80,-77},{-80,-48},{59,-48}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XEvaIn, appDryPt.XEvaIn) annotation (Line(
      points={{-110,-50},{-80,-50},{-80,-45},{59,-45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p, appDryPt.p) annotation (Line(
      points={{-110,-24},{-76,-24},{-76,-42},{59,-42}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow, appDryPt.m_flow) annotation (Line(
      points={{-110,24},{-72,24},{-72,-39},{59,-39}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, appDryPt.speRat) annotation (Line(
      points={{-110,76},{-66,76},{-66,-33},{59,-33}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(speShiQ_flow.y, appDryPt.Q_flow) annotation (Line(
      points={{46.7,51},{52,51},{52,-36.1},{59,-36.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEvaIn, cooCap.TEvaIn) annotation (Line(
      points={{-110,5.55112e-16},{-32,5.55112e-16},{-32,45.2},{-15,45.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(appDryPt.stage, stage) annotation (Line(
      points={{59,-30},{20,-30},{20,100},{-110,100}},
      color={255,127,0},
      smooth=Smooth.None));
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
          lineColor={0,0,0},
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
