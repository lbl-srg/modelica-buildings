within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
model WetCoil "Calculates wet coil condition "

  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.PartialCoilCondition(
      speShiEIR(speSet=datHP.cooSta.spe,
                nSta=datHP.nCooSta,
                variableSpeedCoil=true),
      speShiQ_flow(speSet=datHP.cooSta.spe, nSta=datHP.nCooSta,
                variableSpeedCoil=true));

  extends Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.PartialWetCoil(
    appDewPt(
      variableSpeedCoil=true,
      redeclare package Medium = Medium,
      datHP=datHP),
    shr(redeclare package Medium = Medium),
    conRat(redeclare package Medium = Medium));

  replaceable parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData datHP
    "Performance data"
    annotation (Placement(transformation(extent={{-62,-98},{-42,-78}})));

  constant Boolean calRecoverableWasteHeat
    "Flag, set to true if recoverable waste heat is calculated";
//   constant Boolean isMedium2Water "Set to true if Medium2 mass flow rate affects the capacity of heat pump; set true for
//     water to water heatpump";
  replaceable
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.CoolingCapacity
      cooCap(
        cooSta=datHP.cooSta) constrainedby
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.CoolingCapacity(
          m1_flow_small=datHP.m1_flow_small,
          nSta=datHP.nCooSta)
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

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

  Buildings.Utilities.Psychrometrics.TWetBul_TDryBulXi wetBul(
    redeclare package Medium = Medium) "Calculates wet-bulb temperature"
    annotation (Placement(transformation(extent={{-60,20},{-48,32}})));
  Modelica.Blocks.Interfaces.RealOutput QRecWas_flow(each min=0) if calRecoverableWasteHeat
    "Recoverable waste heat, positive value "
     annotation (Placement(transformation(extent={{100,50},{120,70}})));

  DXCoils.BaseClasses.SpeedShift speShiRecWasQ_flow(
    nSta=datHP.nCooSta,
    speSet=datHP.cooSta.spe,
    variableSpeedCoil=true) if calRecoverableWasteHeat
    "Interpolates recoverable waste heat flow"
    annotation (Placement(transformation(extent={{44,52},{60,68}})));
equation

  connect(p, wetBul.p) annotation (Line(
      points={{-110,-24},{-82,-24},{-82,21.2},{-60.6,21.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XIn, wetBul.Xi[1]) annotation (Line(
      points={{-110,-50},{-88,-50},{-88,26},{-60.6,26}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T[1], wetBul.TDryBul) annotation (Line(
      points={{-110,45},{-86,45},{-86,30.8},{-60.6,30.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T[1], shr.TEvaIn) annotation (Line(
      points={{-110,45},{-86,45},{-86,-2.8},{17,-2.8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mode, onSwi.u) annotation (Line(
      points={{-110,100},{-68,100},{-68,6},{-21.2,6}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(mode, appDewPt.mode) annotation (Line(
      points={{-110,100},{-68,100},{-68,-40},{-41,-40}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(speRat, appDewPt.speRat) annotation (Line(
      points={{-110,76},{-72,76},{-72,-43},{-41,-43}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speShiQ_flow.y, appDewPt.Q_flow) annotation (Line(
      points={{60.8,40},{80,40},{80,20},{-46,20},{-46,-46.1},{-41,-46.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XIn, appDewPt.m_flow) annotation (Line(
      points={{-110,-50},{-75.5,-50},{-75.5,-49},{-41,-49}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wetBul.TWetBul, cooCap.T1In) annotation (Line(
      points={{-47.4,26},{-24,26},{-24,66},{-1,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T[2], cooCap.T2In) annotation (Line(
      points={{-110,55},{-56,55},{-56,58},{-1,58}},
      color={0,0,127},
      smooth=Smooth.None));
//   connect(m_flow[1], cooCap.m1_flow) annotation (Line(
//       points={{-110,19},{-94,19},{-94,62},{-1,62}},
//       color={0,0,127},
//       smooth=Smooth.None), Dialog(enable = if isMedium2Water then true else false));
//   connect(m_flow[2], cooCap.m2_flow) annotation (Line(
//       points={{-110,29},{-94,29},{-94,54},{-1,54}},
//       color={0,0,127},
//       smooth=Smooth.None), Dialog(enable = if isMedium2Water then true else false));
//   connect(m1_flow, cooCap.m1_flow) annotation (Line(
//       points={{-110,5.55112e-16},{-94,5.55112e-16},{-94,62},{-1,62}},
//       color={0,0,127},
//       smooth=Smooth.None), Dialog(enable = if not (isMedium2Water) then true else false));
  connect(m_flow[1], cooCap.m1_flow) annotation (Line(
      points={{-110,19},{-94,19},{-94,62},{-1,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow[2], cooCap.m2_flow) annotation (Line(
      points={{-110,29},{-94,29},{-94,54},{-1,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mode, speShiQ_flow.stage) annotation (Line(
      points={{-110,100},{32,100},{32,46.4},{42.4,46.4}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(mode, speShiEIR.stage) annotation (Line(
      points={{-110,100},{32,100},{32,86.4},{42.4,86.4}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(speRat, speShiEIR.speRat) annotation (Line(
      points={{-110,76},{28,76},{28,80},{42.4,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, speShiQ_flow.speRat) annotation (Line(
      points={{-110,76},{28,76},{28,40},{42.4,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooCap.Q_flow, speShiQ_flow.u) annotation (Line(
      points={{21,56},{24,56},{24,33.6},{42.4,33.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooCap.EIR, speShiEIR.u) annotation (Line(
      points={{21,64},{24,64},{24,73.6},{42.4,73.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mode, cooCap.mode) annotation (Line(
      points={{-110,100},{-68,100},{-68,70},{-1,70}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(speShiQ_flow.y, conRat.Q_flow) annotation (Line(
      points={{60.8,40},{80,40},{80,20},{54,20},{54,-74},{59,-74}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooCap.QRecWas_flow, speShiRecWasQ_flow.u) annotation (Line(
      points={{21,60},{26,60},{26,54},{34,54},{42.4,53.6}},
      color={0,0,127},
      smooth=Smooth.None), Dialog(enable = if calRecoverableWasteHeat then true else false));
  connect(speRat, speShiRecWasQ_flow.speRat) annotation (Line(
      points={{-110,76},{28,76},{28,60},{42.4,60}},
      color={0,0,127},
      smooth=Smooth.None), Dialog(enable = if calRecoverableWasteHeat then true else false));
  connect(mode, speShiRecWasQ_flow.stage) annotation (Line(
      points={{-110,100},{32,100},{32,66.4},{42.4,66.4}},
      color={255,127,0},
      smooth=Smooth.None), Dialog(enable = if calRecoverableWasteHeat then true else false));
  connect(speShiRecWasQ_flow.y, QRecWas_flow) annotation (Line(
      points={{60.8,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None), Dialog(enable = if calRecoverableWasteHeat then true else false));
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
end WetCoil;
