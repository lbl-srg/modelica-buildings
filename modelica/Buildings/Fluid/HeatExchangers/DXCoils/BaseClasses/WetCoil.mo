within Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses;
model WetCoil "Calculates wet coil condition "
  extends
    Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.PartialCoilCondition;
  Modelica.Blocks.Interfaces.RealOutput TADP(
    quantity="Temperature",
    unit="K",
    min=273.15,
    max=373.15) "Dry bulb temperature of air at ADP"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

public
  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBul(
    redeclare package Medium = Medium) "Calculates wet-bulb temperature"
    annotation (Placement(transformation(extent={{-60,20},{-48,32}})));
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDewPoint appDewPt(
    redeclare package Medium = Medium,
    datCoi=datCoi)
    "Calculates air properties at apparatus dew point (ADP) at existing air-flow conditions"
    annotation (Placement(transformation(extent={{-20,-60},{0,-40}})));
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.SensibleHeatRatio shr(
    redeclare package Medium = Medium) "Calculates sensible heat ratio"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Condensation conRat(
      redeclare package Medium = Medium) "Calculates rate of condensation"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
protected
  Modelica.Blocks.Math.IntegerToBoolean onSwi(final threshold=1)
    "On/off switch"
    annotation (Placement(transformation(extent={{-20,0},{-8,12}})));
equation

  connect(appDewPt.TADP, TADP)
                          annotation (Line(
      points={{1,-55},{30,-55},{30,-40},{110,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wetBul.TWetBul, repTIn.u) annotation (Line(
      points={{-47.4,26},{-41.2,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XIn, appDewPt.XIn) annotation (Line(
      points={{-110,-50},{-86,-50},{-86,-55},{-21,-55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p, appDewPt.p) annotation (Line(
      points={{-110,-24},{-82,-24},{-82,-52},{-21,-52}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(m_flow, appDewPt.m_flow) annotation (Line(
      points={{-110,24},{-78,24},{-78,-49},{-21,-49}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p, wetBul.p) annotation (Line(
      points={{-110,-24},{-82,-24},{-82,21.2},{-60.6,21.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XIn, wetBul.Xi[1]) annotation (Line(
      points={{-110,-50},{-86,-50},{-86,26},{-60.6,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, appDewPt.speRat) annotation (Line(
      points={{-110,76},{-74,76},{-74,-43},{-21,-43}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(appDewPt.XADP, shr.XADP) annotation (Line(
      points={{1,-45},{6,-45},{6,-14},{19,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(appDewPt.hADP, shr.hADP) annotation (Line(
      points={{1,-50},{10,-50},{10,-18},{19,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shr.SHR, SHR) annotation (Line(
      points={{41,-10},{46,-10},{46,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p, shr.p) annotation (Line(
      points={{-110,-24},{-82,-24},{-82,-10},{19,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TIn, wetBul.TDryBul) annotation (Line(
      points={{-110,5.55112e-16},{-90,5.55112e-16},{-90,30.8},{-60.6,30.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TIn, shr.TIn) annotation (Line(
      points={{-110,5.55112e-16},{-90,5.55112e-16},{-90,-2.8},{19,-2.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hIn, shr.hIn) annotation (Line(
      points={{-110,-77},{-90,-77},{-90,-6.7},{19,-6.7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hIn, appDewPt.hIn) annotation (Line(
      points={{-110,-77},{-90,-77},{-90,-58},{-21,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(appDewPt.TADP, conRat.TDewPoi)       annotation (Line(
      points={{1,-55},{29.5,-55},{29.5,-86},{59,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conRat.mWat_flow, mWat_flow)       annotation (Line(
      points={{81,-80},{110,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shr.SHR, conRat.SHR) annotation (Line(
      points={{41,-10},{46,-10},{46,-80},{59,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speShiQ_flow.y, conRat.Q_flow) annotation (Line(
      points={{46.7,51},{40,51},{40,40},{54,40},{54,-74},{59,-74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speShiQ_flow.y, appDewPt.Q_flow) annotation (Line(
      points={{46.7,51},{40,51},{40,16},{-40,16},{-40,-46.1},{-21,-46.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onSwi.y, shr.on) annotation (Line(
      points={{-7.4,6},{6,6},{6,5.55112e-16},{19,5.55112e-16}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(onSwi.u, stage) annotation (Line(
      points={{-21.2,6},{-68,6},{-68,100},{-110,100}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (defaultComponentName="wetCoi", Diagram(graphics), Documentation(info="<html>
<p>
This block encompasses 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDewPoint\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.ApparatusDewPoint</a>, 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Condensation\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Condensation</a> and 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.SensibleHeatRatio\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.SensibleHeatRatio</a>. 
The cooling capacity is determined assuming he surface of the coil is wet. 
Using this cooling capacity, air properties at apparatus dew point are determined. 
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Fluid/HeatExchangers/DXCoils/BaseClasses/ApparatusDewPoint.png\" border=\"1\" width=\"350\" height=\"330\">
</p>
<p>
Sensible heat ratio is calculated using the known air inlet conditions, 
ADP conditions and similarity of triangles in the above figure.
The value of the SHR is then used to determine the latent heat component of 
the cooling capacity. 
This latent heat component is then divided by the enthalpy of vaporization at 
the coil surface temperature (i.e. T<sub>ADP</sub>) to calculate 
the mass of water condensed at the coil.</p>
</html>",
revisions="<html>
<ul>
<li>
April 12, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>

</html>"),
    Icon(graphics={
        Rectangle(
          extent={{-54,36},{68,20}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Ellipse(
          extent={{-20,-8},{-16,-14}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{58,4},{62,-2}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,6},{34,0}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-40,20},{-36,16}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{48,24},{52,20}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-62,-18},{80,-54}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          textString="Wet Coil"),
        Ellipse(
          extent={{2,14},{6,8}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-50,8},{-46,2}},
          lineColor={0,0,255},
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-36,46},{-4,46}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{0,46},{-4,48},{-4,44},{0,46}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{22,46},{54,46}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{56,46},{52,48},{52,44},{56,46}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}));
end WetCoil;
