within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
model PartialHeatFlow
  "Partial model for heat flow from Medium1 to Medium2 and vice-versa"

  replaceable package Medium1 =
      Modelica.Media.Interfaces.PartialCondensingGases "Medium model"
     annotation (choicesAllMatching=true);

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

  constant Boolean variableSpeedCoil
    "Flag, set to true for coil with variable speed";

  replaceable parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData   datHP
    "Performance data";

  Modelica.Blocks.Interfaces.RealOutput T1CoiSur(
    quantity="Temperature",
    unit="K",
    min=240,
    max=400) "Coil surface temperature"
          annotation (Placement(transformation(extent={{100,10},{120,30}})));

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
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.DXCooling dxCoo(
    variableSpeedCoil=true,
    datHP=datHP,
    redeclare package Medium = Medium1)
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.DXHeating dxHea(
    datHP=datHP,
    variableSpeedCoil=true,
    redeclare
      Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.HeatingCapacity
                                                                                              heaCap)
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeOnOff modOnOff
    "Turns on and off respective modes"
    annotation (Placement(transformation(extent={{-76,82},{-64,94}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.ModeValueSelector modValSel
    "Selects value as per the mode of operation"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Interfaces.RealOutput Q2_flow(unit="W") "Total capacity"
     annotation (Placement(transformation(extent={{100,-90},{120,-70}})));
  Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.InputPower pwr
    "Calculates power"
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
    annotation (Placement(transformation(extent={{-6,-6},{6,6}})));

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
      points={{-110,76},{-94,76},{-94,77.6},{-41,77.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T, dxHea.T) annotation (Line(
      points={{-110,50},{-90,50},{-90,75},{-41,75}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow, dxHea.m_flow) annotation (Line(
      points={{-110,24},{-86,24},{-86,72.4},{-41,72.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T, dxCoo.T) annotation (Line(
      points={{-110,50},{-90,50},{-90,35},{-41,35}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, dxCoo.speRat) annotation (Line(
      points={{-110,76},{-94,76},{-94,37.6},{-41,37.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow, dxCoo.m_flow) annotation (Line(
      points={{-110,24},{-86,24},{-86,32.4},{-41,32.4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(p, dxCoo.p) annotation (Line(
      points={{-110,-24},{-82,-24},{-82,27.6},{-41,27.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(X1In, dxCoo.X1In) annotation (Line(
      points={{-110,-50},{-78,-50},{-78,25},{-41,25}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(h1In, dxCoo.h1In) annotation (Line(
      points={{-110,-77},{-74,-77},{-74,22.3},{-41,22.3}},
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
  connect(dxHea.TCoiSur, modValSel.THeaCoiSur) annotation (Line(
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
  connect(modValSel.TCoiSur, T1CoiSur) annotation (Line(
      points={{21,46},{28,46},{28,20},{110,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(modValSel.mWat_flow, m1Wat_flow) annotation (Line(
      points={{21,42},{26,42},{26,5.55112e-16},{110,5.55112e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pwr.P, add.u2) annotation (Line(
      points={{60.6,57.6},{68,57.6},{68,-10},{-20,-10},{-20,-3.6},{-7.2,-3.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(modValSel.Q_flow, add.u1) annotation (Line(
      points={{21,54},{34,54},{34,14},{-20,14},{-20,4},{-14,4},{-14,3.6},{-7.2,
          3.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mode, pwr.mode) annotation (Line(
      points={{-110,100},{40,100},{40,60},{46.8,60}},
      color={255,127,0},
      smooth=Smooth.None));
  annotation (defaultComponentName="heaFlo", Diagram(coordinateSystem(
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
    Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{100,100}})));
end PartialHeatFlow;
