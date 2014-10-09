within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
model ATWOperation "Air to water heat flow operation"
//   extends
//     Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.PartialHPInterface;
  extends Modelica.Blocks.Interfaces.BlockIcon;

  Modelica.Blocks.Interfaces.IntegerInput mode "Mode of operation"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Modelica.Blocks.Interfaces.RealInput speRat "Speed ratio"
    annotation (Placement(transformation(extent={{-120,66},{-100,86}})));
  Modelica.Blocks.Interfaces.RealInput m_flow[2] "Air mass flow rate"
     annotation (Placement(transformation(extent={{-120,14},{-100,34}})));

  Modelica.Blocks.Interfaces.RealInput T[2](unit="K")
    "Outside air dry bulb temperature for an air cooled condenser or wetbulb temperature for an evaporative cooled condenser"
   annotation (Placement(transformation(extent={{-120,40},{-100,60}},  rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput Q1_flow(unit="W") "Total capacity"
     annotation (Placement(transformation(extent={{100,30},{120,50}})));

  replaceable package Medium =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
     annotation (choicesAllMatching=true);

  constant Boolean variableSpeedCoil
    "Flag, set to true for coil with variable speed";

  replaceable parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData   datHP
    "Performance data";

  Modelica.Blocks.Interfaces.RealOutput T1CoiSur(
    quantity="ThermodynamicTemperature",
    unit="K",
    min=240,
    max=400) "Coil surface temperature"
          annotation (Placement(transformation(extent={{100,10},{120,30}})));
//    final variableSpeedCoil=variableSpeedCoil
//    final variableSpeedCoil=variableSpeedCoil
  Modelica.Blocks.Interfaces.RealOutput m1Wat_flow(quantity="MassFlowRate",
      unit="kg/s") "Mass flow rate of water condensed at cooling coil"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Modelica.Blocks.Interfaces.RealInput X1In "Inlet air mass fraction"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput p "Pressure at inlet of coil"
    annotation (Placement(transformation(extent={{-120,-34},{-100,-14}})));
  Modelica.Blocks.Interfaces.RealInput h1In
    "Specific enthalpy of air entering the coil"
            annotation (Placement(transformation(extent={{-120,-87},{-100,-67}})));
  DXCooling dxCoo(
    redeclare package Medium = Medium,
    variableSpeedCoil=true,
    datHP=datHP)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  DXHeating dxHea(
    redeclare package Medium = Medium,
    datHP=datHP,
    variableSpeedCoil=true)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  ModeOnOff modOnOff "Turns on and off respective modes"
    annotation (Placement(transformation(extent={{-76,82},{-64,94}})));
  ModeValueSelector modValSel
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Interfaces.RealOutput Q2_flow(unit="W") "Total capacity"
     annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  DXCoils.BaseClasses.InputPower pwr
    annotation (Placement(transformation(extent={{48,48},{60,60}})));
  Modelica.Blocks.Interfaces.RealOutput Q1Sen_flow(quantity="Power", unit="W")
    "Sensible heat flow rate"
    annotation (Placement(transformation(extent={{100,50},{120,70}}, rotation=
            0)));
  Modelica.Blocks.Interfaces.RealOutput P(
    quantity="Power",
    unit="W") "Electrical power consumed by the unit"
    annotation (Placement(transformation(extent={{100,70},{120,90}}, rotation=
            0)));
  Modelica.Blocks.Math.Add add(k1=-1)
    annotation (Placement(transformation(extent={{-22,-6},{-10,6}})));
equation

  connect(mode, modOnOff.mode) annotation (Line(
      points={{-110,100},{-90,100},{-90,88},{-77.2,88}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(modOnOff.heaOn, dxHea.mode) annotation (Line(
      points={{-63.4,90.4},{-50,90.4},{-50,80},{-41,80}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(modOnOff.cooOn, dxCoo.mode) annotation (Line(
      points={{-63.4,85.6},{-54,85.6},{-54,40},{-41,40}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(speRat, dxHea.speRat) annotation (Line(
      points={{-110,76},{-78,76},{-78,77.6},{-41,77.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T, dxHea.T) annotation (Line(
      points={{-110,50},{-74,50},{-74,75},{-41,75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow, dxHea.m_flow) annotation (Line(
      points={{-110,24},{-70,24},{-70,72.4},{-41,72.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T, dxCoo.T) annotation (Line(
      points={{-110,50},{-74,50},{-74,35},{-41,35}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, dxCoo.speRat) annotation (Line(
      points={{-110,76},{-78,76},{-78,37.6},{-41,37.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow, dxCoo.m_flow) annotation (Line(
      points={{-110,24},{-70,24},{-70,32.4},{-41,32.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p, dxCoo.p) annotation (Line(
      points={{-110,-24},{-66,-24},{-66,27.6},{-41,27.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(X1In, dxCoo.X1In) annotation (Line(
      points={{-110,-50},{-62,-50},{-62,25},{-41,25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(h1In, dxCoo.h1In) annotation (Line(
      points={{-110,-77},{-58,-77},{-58,22.3},{-41,22.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p, dxHea.p) annotation (Line(
      points={{-110,-24},{-66,-24},{-66,67.6},{-41,67.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(X1In, dxHea.XIn) annotation (Line(
      points={{-110,-50},{-62,-50},{-62,65},{-41,65}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(h1In, dxHea.hIn) annotation (Line(
      points={{-110,-77},{-58,-77},{-58,62.3},{-41,62.3}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxHea.EIR, modValSel.EIRHea) annotation (Line(
      points={{-19,78},{18,78},{18,61}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxHea.Q_flow, modValSel.QHea_flow) annotation (Line(
      points={{-19,74},{14,74},{14,61}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxHea.TDry, modValSel.THeaCoiSur) annotation (Line(
      points={{-19,64},{6,64},{6,61}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxCoo.EIR, modValSel.EIRCoo) annotation (Line(
      points={{-19,38},{-6,38},{-6,36},{18,36},{18,39}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxCoo.Q_flow, modValSel.QCoo_flow) annotation (Line(
      points={{-19,34},{14,34},{14,39}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxCoo.SHR, modValSel.SHRCoo) annotation (Line(
      points={{-19,30},{10,30},{10,39}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxCoo.TCoiSur, modValSel.TADPCoo) annotation (Line(
      points={{-19,26},{6,26},{6,39}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(dxCoo.mWat_flow, modValSel.mCooWat_flow) annotation (Line(
      points={{-19,22},{2,22},{2,39}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mode, modValSel.mode) annotation (Line(
      points={{-110,100},{-10,100},{-10,50},{-1,50}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(modValSel.EIR, pwr.EIR) annotation (Line(
      points={{21,58},{36,58},{36,57.6},{46.8,57.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(modValSel.Q_flow, pwr.Q_flow) annotation (Line(
      points={{21,54},{46.8,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(modValSel.SHR, pwr.SHR) annotation (Line(
      points={{21,50},{32,50},{32,50.4},{46.8,50.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pwr.P, P) annotation (Line(
      points={{60.6,57.6},{86,57.6},{86,80},{110,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pwr.QSen_flow, Q1Sen_flow) annotation (Line(
      points={{60.6,54},{92,54},{92,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(modValSel.Q_flow, Q1_flow) annotation (Line(
      points={{21,54},{34,54},{34,40},{110,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pwr.P, add.u2) annotation (Line(
      points={{60.6,57.6},{68,57.6},{68,-12},{-46,-12},{-46,-4},{-34,-4},{-34,
          -3.6},{-23.2,-3.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(modValSel.Q_flow, add.u1) annotation (Line(
      points={{21,54},{34,54},{34,14},{-46,14},{-46,3.6},{-23.2,3.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, Q2_flow) annotation (Line(
      points={{-9.4,-1.88738e-16},{20,-1.88738e-16},{20,-80},{110,-80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(modValSel.TCoiSur, T1CoiSur) annotation (Line(
      points={{21,46},{28,46},{28,20},{110,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(modValSel.mWat_flow, m1Wat_flow) annotation (Line(
      points={{21,42},{26,42},{26,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
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
end ATWOperation;
