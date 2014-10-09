within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
model PartialWetCoil "Partial wet coil block"
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
      annotation (choicesAllMatching=true);

  Modelica.Blocks.Interfaces.RealInput XIn "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput p "Pressure at inlet of coil"
    annotation (Placement(transformation(extent={{-120,-34},{-100,-14}})));
  Modelica.Blocks.Interfaces.RealInput hIn
    "Specific enthalpy of air entering the coil"
            annotation (Placement(transformation(extent={{-120,-87},{-100,-67}})));

  Modelica.Blocks.Interfaces.RealOutput TADP(
    quantity="ThermodynamicTemperature",
    unit="K",
    min=273.15,
    max=373.15) "Dry bulb temperature of air at ADP"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput SHR(
    min=0,
    max=1.0)
    "Sensible Heat Ratio: Ratio of sensible heat load to total heat load"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealOutput mWat_flow(
    quantity="MassFlowRate",
    unit="kg/s") "Mass flow rate of water condensed at cooling coil"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ApparatusDewPoint appDewPt
    "Calculates air properties at apparatus dew point (ADP) at existing air-flow conditions"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.SensibleHeatRatio shr
    "Calculates sensible heat ratio"
    annotation (Placement(transformation(extent={{18,-20},{38,0}})));
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.Condensation conRat
    "Calculates rate of condensation"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
protected
  Modelica.Blocks.Math.IntegerToBoolean onSwi(final threshold=1)
    "On/off switch"
    annotation (Placement(transformation(extent={{-20,0},{-8,12}})));
public
  Modelica.Blocks.Interfaces.RealOutput XADP
    "Humidity mass fraction of air at  apparatus dew point" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-110})));
equation

  connect(appDewPt.TADP, TADP)
                          annotation (Line(
      points={{-19,-55},{30,-55},{30,-40},{110,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XIn, appDewPt.XIn) annotation (Line(
      points={{-110,-50},{-88,-50},{-88,-55},{-41,-55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p, appDewPt.p) annotation (Line(
      points={{-110,-24},{-82,-24},{-82,-52},{-41,-52}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(appDewPt.XADP, shr.XADP) annotation (Line(
      points={{-19,-45},{6,-45},{6,-14},{17,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(appDewPt.hADP, shr.hADP) annotation (Line(
      points={{-19,-50},{10,-50},{10,-18},{17,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shr.SHR, SHR) annotation (Line(
      points={{39,-10},{46,-10},{46,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p, shr.p) annotation (Line(
      points={{-110,-24},{-82,-24},{-82,-10},{17,-10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hIn, shr.hEvaIn) annotation (Line(
      points={{-110,-77},{-84,-77},{-84,-6.7},{17,-6.7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hIn, appDewPt.hIn) annotation (Line(
      points={{-110,-77},{-84,-77},{-84,-58},{-41,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(appDewPt.TADP, conRat.TDewPoi)       annotation (Line(
      points={{-19,-55},{29.5,-55},{29.5,-86},{59,-86}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conRat.mWat_flow, mWat_flow)       annotation (Line(
      points={{81,-80},{110,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shr.SHR, conRat.SHR) annotation (Line(
      points={{39,-10},{46,-10},{46,-80},{59,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(onSwi.y, shr.on) annotation (Line(
      points={{-7.4,6},{6,6},{6,5.55112e-16},{17,5.55112e-16}},
      color={255,0,255},
      smooth=Smooth.None));
  connect(appDewPt.XADP, XADP)  annotation (Line(
      points={{-19,-45},{0,-45},{0,-110},{5.55112e-16,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (defaultComponentName="wetCoi", Diagram(graphics), Documentation(info="<html>
<p>
This block calculates the rate of cooling and the coil surface condition
under the assumption that the coil is wet.
</p>
<p>
The dry coil conditions are computed in
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil\">
Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryCoil</a>.
See 
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide\">
Buildings.Fluid.HeatExchangers.DXCoils.UsersGuide</a>
for an explanation of the model.
</p>
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
end PartialWetCoil;
