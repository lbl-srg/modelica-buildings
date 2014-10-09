within Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.BaseClasses;
model DXCooling1 "This block performs cooling operation "
  import Buildings;
  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.PartialHPInterface;

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
     annotation (choicesAllMatching=true);

  constant Boolean variableSpeedCoil
    "Flag, set to true for coil with variable speed";
  constant Boolean calRecoverableWasteHeat
    "Flag, set to true if recoverable waste heat is calculated";
  replaceable parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.Data.HPData   datHP
    "Performance data";

  Modelica.Blocks.Interfaces.RealOutput TCoiSur(
    quantity="ThermodynamicTemperature",
    unit="K",
    min=240,
    max=400) "Coil surface temperature"
          annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.WetCoil wetCoi(
    redeclare final package Medium = Medium,
    redeclare Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.Data.HPData datHP=datHP,
    redeclare
      Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.BaseClasses.CoolingCapacity
                                                                                            cooCap(
      nSta=datHP.nCooSta,
      cooSta=datHP.cooSta,
      m1_flow_small=datHP.m1_flow_small),
    calRecoverableWasteHeat=calRecoverableWasteHeat,
        appDewPt(
      variableSpeedCoil=true,
      redeclare package Medium = Medium,
      redeclare Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.Data.HPData datHP=datHP),
    shr(redeclare package Medium = Medium),
    conRat(redeclare package Medium = Medium)) "Wet coil condition"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));

  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.DryCoil dryCoi(
    redeclare final package Medium = Medium,
    redeclare Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.Data.HPData datHP=datHP,
    redeclare
      Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.BaseClasses.CoolingCapacity
                                                                                            cooCap(
      nSta=datHP.nCooSta,
      cooSta=datHP.cooSta,
      m1_flow_small=datHP.m1_flow_small),
    calRecoverableWasteHeat=calRecoverableWasteHeat,
          appDryPt(
      redeclare package Medium = Medium,
      redeclare Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.Data.HPData datHP=datHP,
      variableSpeedCoil=true)) "Dry coil condition"
    annotation (Placement(transformation(extent={{-50,-60},{-30,-40}})));
//    final variableSpeedCoil=variableSpeedCoil
  Buildings.Fluid.HeatExchangers.DXCoils.BaseClasses.DryWetSelector dryWet
    "Actual coil condition"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Interfaces.RealOutput mWat_flow(
    quantity="MassFlowRate",
    unit="kg/s") "Mass flow rate of water condensed at cooling coil"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Interfaces.RealOutput SHR(
    min=0,
    max=1.0)
    "Sensible Heat Ratio: Ratio of sensible heat load to total heat load"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput X1In "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput p "Pressure at inlet of coil"
    annotation (Placement(transformation(extent={{-120,-34},{-100,-14}})));
  Modelica.Blocks.Interfaces.RealInput h1In
    "Specific enthalpy of air entering the coil"
            annotation (Placement(transformation(extent={{-120,-87},{-100,-67}})));
  Buildings.Utilities.Math.Splice spl(deltax=0.0001) if
                                         calRecoverableWasteHeat
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

protected
  Modelica.Blocks.Sources.RealExpression dX(final y=(wetCoi.XADP - X1In) + 0.0001) if calRecoverableWasteHeat
    "Difference is mass fraction"
    annotation (Placement(transformation(extent={{-20,66},{0,86}})));
public
  Modelica.Blocks.Interfaces.RealOutput QRecWas_flow(each min=0) if calRecoverableWasteHeat
    "Recoverable waste heat, positive value "
     annotation (Placement(transformation(extent={{100,50},{120,70}})));

equation
  connect(m_flow, wetCoi.m_flow)  annotation (Line(
      points={{-110,24},{-72,24},{-72,52.4},{-51,52.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow, dryCoi.m_flow)  annotation (Line(
      points={{-110,24},{-74,24},{-74,-47.6},{-51,-47.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p, wetCoi.p)  annotation (Line(
      points={{-110,-24},{-68,-24},{-68,47.6},{-51,47.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(X1In, wetCoi.XIn)  annotation (Line(
      points={{-110,-50},{-64,-50},{-64,45},{-51,45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(h1In, wetCoi.hIn)  annotation (Line(
      points={{-110,-77},{-60,-77},{-60,42.3},{-51,42.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(h1In, dryCoi.hIn)  annotation (Line(
      points={{-110,-77},{-60,-77},{-60,-57.7},{-51,-57.7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p, dryCoi.p)  annotation (Line(
      points={{-110,-24},{-68,-24},{-68,-52.4},{-51,-52.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(X1In, dryCoi.XIn)  annotation (Line(
      points={{-110,-50},{-64,-50},{-64,-55},{-51,-55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, wetCoi.speRat)  annotation (Line(
      points={{-110,76},{-80,76},{-80,57.6},{-51,57.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, dryCoi.speRat)  annotation (Line(
      points={{-110,76},{-80,76},{-80,-42.4},{-51,-42.4}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(X1In, dryWet.XEvaIn)    annotation (Line(
      points={{-110,-50},{-64,-50},{-64,-4},{39,-4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mode, dryCoi.mode) annotation (Line(
      points={{-110,100},{-56,100},{-56,-40},{-51,-40}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(mode, wetCoi.mode) annotation (Line(
      points={{-110,100},{-56,100},{-56,60},{-51,60}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(dryWet.EIRWet, wetCoi.EIR) annotation (Line(
      points={{58,11},{58,58},{-29,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wetCoi.Q_flow, dryWet.QWet_flow) annotation (Line(
      points={{-29,54},{54,54},{54,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wetCoi.SHR, dryWet.SHRWet) annotation (Line(
      points={{-29,50},{50,50},{50,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wetCoi.mWat_flow, dryWet.mWetWat_flow) annotation (Line(
      points={{-29,42},{42,42},{42,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dryCoi.EIR, dryWet.EIRDry) annotation (Line(
      points={{-29,-42},{58,-42},{58,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dryCoi.Q_flow, dryWet.QDry_flow) annotation (Line(
      points={{-29,-46},{54,-46},{54,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dryCoi.TDry, dryWet.TADPDry) annotation (Line(
      points={{-29,-56},{46,-56},{46,-11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wetCoi.TADP, dryWet.TADPWet) annotation (Line(
      points={{-29,46},{46,46},{46,11}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dryWet.EIR, EIR) annotation (Line(
      points={{61,8},{70,8},{70,80},{110,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dryWet.Q_flow, Q_flow) annotation (Line(
      points={{61,4},{80,4},{80,40},{110,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dryWet.SHR, SHR) annotation (Line(
      points={{61,6.10623e-16},{81.5,6.10623e-16},{81.5,5.55112e-16},{110,
          5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dryWet.TADP, TCoiSur) annotation (Line(
      points={{61,-4},{80,-4},{80,-40},{110,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dryWet.mWat_flow, mWat_flow) annotation (Line(
      points={{61,-8},{70,-8},{70,-80},{110,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(wetCoi.XADP, dryWet.XADP) annotation (Line(
      points={{-40,39},{-40,4},{39,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T, wetCoi.T) annotation (Line(
      points={{-110,50},{-76,50},{-76,55},{-51,55}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T, dryCoi.T) annotation (Line(
      points={{-110,50},{-76,50},{-76,-45},{-51,-45}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dX.y, spl.x) annotation (Line(
      points={{1,76},{8,76},{8,80},{18,80}},
      color={0,0,127},
      smooth=Smooth.None), Dialog(enable = if calRecoverableWasteHeat then true else false));
  connect(spl.y, QRecWas_flow) annotation (Line(
      points={{41,80},{60,80},{60,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None), Dialog(enable = if calRecoverableWasteHeat then true else false));
  connect(wetCoi.QRecWas_flow, spl.u1) annotation (Line(
      points={{-29,56},{-24,56},{-24,86},{18,86}},
      color={0,0,127},
      smooth=Smooth.None), Dialog(enable = if calRecoverableWasteHeat then true else false));
  connect(dryCoi.QRecWas_flow, spl.u2) annotation (Line(
      points={{-29,-44},{8,-44},{8,74},{18,74}},
      color={0,0,127},
      smooth=Smooth.None), Dialog(enable = if calRecoverableWasteHeat then true else false));
  annotation (defaultComponentName="dxCoo", Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
                                                     graphics), Documentation(info="<html>
<p>
This block combines the models for the dry coil and the wet coil.
Output of the block is the coil performance which, depending on the
mass fraction at the apparatus dew point temperature and 
the mass fraction of the coil inlet air,
may be from the dry coil, the wet coil, or a weighted average of the two.
</p>
</html>",
revisions="<html>
<ul>
<li>
September 20, 2012 by Michael Wetter:<br>
Revised implementation.
</li>
<li>
September 4, 2012 by Michael Wetter:<br>
Renamed connector to follow naming convention.
</li>
<li>
April 12, 2012 by Kaustubh Phalak:<br>
First implementation. 
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}}),
         graphics={
        Text(
          extent={{-64,-56},{78,-92}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          textString="DXCool"),
        Line(
          points={{-78,26},{-46,26}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{-44,26},{-48,28},{-48,24},{-44,26}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-78,4},{-46,4}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{-44,4},{-48,6},{-48,2},{-44,4}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{20,32},{26,20}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Line(
          points={{24,32},{-12,48}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{22,20},{-16,38}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{20,8},{-18,26}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{18,-4},{-20,14}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{16,8},{22,-4}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Line(
          points={{14,-32},{-24,-14}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{16,-20},{-22,-2}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{12,-20},{18,-32}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Line(
          points={{-78,-18},{-46,-18}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{-42,-18},{-46,-16},{-46,-20},{-42,-18}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-76,46},{-44,46}},
          color={0,0,255},
          smooth=Smooth.None),
        Polygon(
          points={{-42,46},{-46,48},{-46,44},{-42,46}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{74,32},{38,48}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{72,20},{34,38}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{70,32},{76,20}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Line(
          points={{70,8},{32,26}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{68,-4},{30,14}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{66,8},{72,-4}},
          lineColor={0,0,255},
          lineThickness=0.5),
        Line(
          points={{68,-22},{30,-4}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{66,-34},{28,-16}},
          color={0,0,255},
          thickness=0.5,
          smooth=Smooth.None),
        Ellipse(
          extent={{64,-22},{70,-34}},
          lineColor={0,0,255},
          lineThickness=0.5)}));
end DXCooling1;
