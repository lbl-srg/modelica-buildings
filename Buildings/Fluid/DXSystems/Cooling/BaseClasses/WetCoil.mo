within Buildings.Fluid.DXSystems.Cooling.BaseClasses;
model WetCoil "Calculates wet coil condition "
  extends
    Buildings.Fluid.DXSystems.Cooling.BaseClasses.PartialCoilCondition;
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
      annotation (choicesAllMatching=true);
  Modelica.Blocks.Interfaces.RealOutput TADP(
    quantity="ThermodynamicTemperature",
    unit="K",
    start=288.15,
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

  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBul(
    redeclare package Medium = Medium) "Calculates wet-bulb temperature"
    annotation (Placement(transformation(extent={{-60,20},{-48,32}})));
  Buildings.Fluid.DXSystems.Cooling.BaseClasses.ApparatusDewPoint appDewPt(
    redeclare package Medium = Medium,
    datCoi=datCoi,
    final variableSpeedCoil=variableSpeedCoil)
    "Calculates air properties at apparatus dew point (ADP) at existing air-flow conditions"
    annotation (Placement(transformation(extent={{-30,-60},{-10,-40}})));
  Buildings.Fluid.DXSystems.Cooling.BaseClasses.SensibleHeatRatio shr(
    redeclare package Medium = Medium) "Calculates sensible heat ratio"
    annotation (Placement(transformation(extent={{20,-20},{40,0}})));
  Buildings.Fluid.DXSystems.Cooling.BaseClasses.Condensation conRat
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
  Modelica.Blocks.Interfaces.RealInput XEvaIn "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput p "Pressure at inlet of coil"
    annotation (Placement(transformation(extent={{-120,-34},{-100,-14}})));
  Modelica.Blocks.Interfaces.RealInput hEvaIn
    "Specific enthalpy of air entering the coil"
            annotation (Placement(transformation(extent={{-120,-87},{-100,-67}})));
equation

  connect(appDewPt.TADP, TADP)
                      annotation (Line(
      points={{-9,-55},{30,-55},{30,-40},{110,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XEvaIn, appDewPt.XEvaIn) annotation (Line(
      points={{-110,-50},{-86,-50},{-86,-55},{-31,-55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p, appDewPt.p) annotation (Line(
      points={{-110,-24},{-82,-24},{-82,-52},{-31,-52}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow, appDewPt.m_flow) annotation (Line(
      points={{-110,24},{-78,24},{-78,-49},{-31,-49}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p, wetBul.p) annotation (Line(
      points={{-110,-24},{-82,-24},{-82,21.2},{-60.6,21.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XEvaIn, wetBul.Xi[1]) annotation (Line(
      points={{-110,-50},{-86,-50},{-86,26},{-60.6,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, appDewPt.speRat) annotation (Line(
      points={{-110,76},{-74,76},{-74,-43},{-31,-43}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(appDewPt.XADP, shr.XADP) annotation (Line(
      points={{-9,-45},{6,-45},{6,-14},{19,-14}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(appDewPt.hADP, shr.hADP) annotation (Line(
      points={{-9,-50},{10,-50},{10,-18},{19,-18}},
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
  connect(TEvaIn, wetBul.TDryBul) annotation (Line(
      points={{-110,5.55112e-16},{-90,5.55112e-16},{-90,30.8},{-60.6,30.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEvaIn, shr.TEvaIn) annotation (Line(
      points={{-110,5.55112e-16},{-90,5.55112e-16},{-90,-2.8},{19,-2.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hEvaIn, shr.hEvaIn) annotation (Line(
      points={{-110,-77},{-90,-77},{-90,-6.7},{19,-6.7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(hEvaIn, appDewPt.hEvaIn) annotation (Line(
      points={{-110,-77},{-90,-77},{-90,-58},{-31,-58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(conRat.mWat_flow, mWat_flow)       annotation (Line(
      points={{81,-80},{110,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(shr.SHR, conRat.SHR) annotation (Line(
      points={{41,-10},{46,-10},{46,-84},{59,-84}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speShiQ_flow.y, conRat.Q_flow) annotation (Line(
      points={{46.7,51},{50,51},{50,-76},{59,-76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speShiQ_flow.y, appDewPt.Q_flow) annotation (Line(
      points={{46.7,51},{50,51},{50,20},{-40,20},{-40,-46.1},{-31,-46.1}},
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
  connect(wetBul.TWetBul,coiCap.TEvaIn)  annotation (Line(
      points={{-47.4,26},{-32,26},{-32,45.2},{-15,45.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(appDewPt.XADP, XADP)  annotation (Line(
      points={{-9,-45},{0,-45},{0,-110},{5.55112e-16,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(appDewPt.stage, stage) annotation (Line(
      points={{-31,-40},{-68,-40},{-68,100},{-110,100}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(mCon_flow,coiCap.mCon_flow)  annotation (Line(points={{-110,-100},{-92,
          -100},{-92,40},{-15,40}}, color={0,0,127}));
  annotation (defaultComponentName="wetCoi", Documentation(info="<html>
<p>
This block calculates the rate of cooling and the coil surface condition
under the assumption that the coil is wet.
</p>
<p>
The dry coil conditions are computed in
<a href=\"modelica://Buildings.Fluid.DXSystems.BaseClasses.DryCoil\">
Buildings.Fluid.DXSystems.BaseClasses.DryCoil</a>.
See
<a href=\"modelica://Buildings.Fluid.DXSystems.UsersGuide\">
Buildings.Fluid.DXSystems.UsersGuide</a>
for an explanation of the model.
</p>
</html>",
revisions="<html>
<ul>
<li>
April 5, 2023, by Xing Lu:<br/>
Connect statements with references to <code>cooCap</code> changed to <code>coiCap</code>.
</li>
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
          textColor={0,0,0},
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
