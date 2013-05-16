within Buildings.Fluid.HeatExchangers.BaseClasses;
model MassExchangeDummy
  "Dummy block to replace the computation of the latent heat transfer for dry coils"
  import Buildings;
  extends Buildings.BaseClasses.BaseIcon;

  Modelica.Blocks.Interfaces.RealInput XInf "Water mass fraction of medium"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealInput TSur(final quantity="Temperature",
                                            final unit = "K", displayUnit = "degC", min=0)
    "Surface temperature"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}},
          rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput mWat_flow(final unit = "kg/s")
    "Water flow rate"
    annotation (Placement(transformation(extent={{100,10},{120,30}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput TLiq(final quantity="Temperature",
                                             final unit = "K", displayUnit = "degC", min=0)
    "Temperature at which condensate drains from system"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}}, rotation=
           0)));
  Modelica.Blocks.Interfaces.RealInput Gc
    "Signal representing the convective (sensible) thermal conductance in [W/K]"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}},
          rotation=0)));
protected
  Modelica.Blocks.Sources.Constant zero(k=0) "Constant for zero"
    annotation (Placement(transformation(extent={{40,10},{60,30}},   rotation=0)));
equation
  connect(TSur, TLiq) annotation (Line(points={{-120,80},{80,80},{80,-40},{110,
          -40}}, color={0,0,127}));
  connect(zero.y, mWat_flow) annotation (Line(
      points={{61,20},{110,20}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-92,96},{-48,54}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="TSur"),
        Text(
          extent={{-96,22},{-48,-26}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="XMed"),
        Text(
          extent={{-90,-66},{-58,-98}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="Gc"),
        Text(
          extent={{54,-20},{92,-58}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="TLiq"),
        Text(
          extent={{56,28},{96,12}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="m"),
        Ellipse(
          extent={{72,38},{76,34}},
          lineColor={0,0,127},
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-30,66},{-36,46},{-38,32},{-36,26},{-30,22},{-20,22},{-12,28},
              {-10,36},{-14,52},{-24,84},{-30,66}},
          lineColor={0,0,255}),
        Polygon(
          points={{10,26},{4,6},{2,-8},{4,-14},{10,-18},{20,-18},{28,-12},{30,-4},
              {26,12},{16,44},{10,26}},
          lineColor={0,0,255}),
        Polygon(
          points={{-38,-18},{-44,-38},{-46,-52},{-44,-58},{-38,-62},{-28,-62},{
              -20,-56},{-18,-48},{-22,-32},{-32,0},{-38,-18}},
          lineColor={0,0,255}),
        Polygon(
          points={{14,-46},{8,-66},{6,-80},{8,-86},{14,-90},{24,-90},{32,-84},{
              34,-76},{30,-60},{20,-28},{14,-46}},
          lineColor={0,0,255}),
        Polygon(
          points={{38,100},{32,80},{30,66},{32,60},{38,56},{48,56},{56,62},{58,
              70},{54,86},{50,100},{38,100}},
          lineColor={0,0,255})}),
                            Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This is a dummy model used to replace the model 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.MassExchange\">
Buildings.Fluid.HeatExchangers.BaseClasses.MassExchange</a>
in a dry coil heat exchanger.
The model is used because 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.HexElement\">
Buildings.Fluid.HeatExchangers.BaseClasses.HexElement</a>
connects the input signals of <code>vol2</code>.
If the instance of <a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.MassExchange\">
Buildings.Fluid.HeatExchangers.BaseClasses.MassExchange</a>
where removed, then a warning occurs during translation because 
connector variables are not used.
</p>
</html>", revisions="<html>
<ul>
<li>
April 19, 2013 by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end MassExchangeDummy;
