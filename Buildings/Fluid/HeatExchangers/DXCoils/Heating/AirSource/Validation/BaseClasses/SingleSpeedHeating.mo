within Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Validation.BaseClasses;
model SingleSpeedHeating
  "Baseclass for validation models for single speed DX heating coil"

  package Medium = Buildings.Media.Air
    "Medium model";

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    final p(displayUnit="Pa") = 101325,
    final nPorts=1,
    final T=294.15)
    "Sink"
    annotation (Placement(transformation(extent={{40,-20},{20,0}})));

  Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.SingleSpeed sinSpeDX(
    redeclare package Medium = Medium,
    final dp_nominal=1141,
    final datCoi=datCoi,
    final T_start=datCoi.sta[1].nomVal.TEvaIn_nominal,
    final from_dp=true,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final dTHys=1e-6) "Single speed DX heating coil"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Buildings.Utilities.IO.BCVTB.From_degC TEvaIn_K
    "Converts degC to K"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));

  Buildings.Utilities.IO.BCVTB.From_degC TConIn_K
    "Converts degC to K"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));

  Modelica.Blocks.Math.Mean TOutMea(
    final f=1/3600)
    "Mean of measured outlet air temperature"
    annotation (Placement(transformation(extent={{80,80},{100,100}})));

  Buildings.Utilities.IO.BCVTB.To_degC TOutDegC
    "Convert measured outlet air temperature to deg C"
    annotation (Placement(transformation(extent={{120,80},{140,100}})));

  Modelica.Blocks.Sources.RealExpression TOut(
    final y=sinSpeDX.vol.T)
    "Measured temperature of outlet air"
    annotation (Placement(transformation(extent={{40,80},{60,100}})));

  Modelica.Blocks.Math.Mean XConOutMea(
    final f=1/3600)
    "Mean of measured outlet air humidity ratio per kg total air"
    annotation (Placement(transformation(extent={{80,120},{100,140}})));

  Modelica.Blocks.Sources.RealExpression XConOut(
    final y=sum(sinSpeDX.vol.Xi))
    "Measured humidity ratio of outlet air"
    annotation (Placement(transformation(extent={{40,120},{60,140}})));

  Modelica.Blocks.Math.Mean Q_flowMea(
    final f=1/3600)
    "Mean of cooling rate"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));

  Modelica.Blocks.Math.Mean PMea(
    final f=1/3600)
    "Mean of power"
    annotation (Placement(transformation(extent={{40,10},{60,30}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay PEPlu(
    final samplePeriod=3600)
    "Total power consumption from EnergyPlus"
    annotation (Placement(transformation(extent={{-68,-140},{-48,-120}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay Q_flowEPlu(
    final samplePeriod=3600)
    "Heat transfer to airloop from EnergyPlus"
    annotation (Placement(transformation(extent={{100,-140},{120,-120}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay TOutEPlu(
    final samplePeriod=3600)
    "Outlet temperature from EnergyPlus"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay XConOutEPlu(
    final samplePeriod=3600)
    "Outlet air humidity ratio from EnergyPlus"
    annotation (Placement(transformation(extent={{30,-140},{50,-120}})));

  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirOut
    "Convert humidity ratio per kg dry air to humidity ratio per kg total air for outdoor air"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));

  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirEPlu
    "Convert humidity ratio per kg dry air from EnergyPlus to humidity ratio per kg total air"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay PDefEPlu(
    final samplePeriod=3600)
    "Defrost power from EnergyPlus"
    annotation (Placement(transformation(extent={{100,-50},{120,-30}})));

  Buildings.Controls.OBC.CDL.Discrete.UnitDelay PCraEPlu(
    final samplePeriod=3600)
    "Cranckcase heater power from EnergyPlus"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final tableOnFile=true,
    final columns=2:18,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments)
    "Reader for EnergyPlus example results"
    annotation (Placement(transformation(extent={{-152,110},{-132,130}})));

  Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Validation.BaseClasses.PLRToPulse
    plrToPul(
    final tPer=3600)
    "Convert PLR signal to on-off signal"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));

  Buildings.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    final use_Xi_in=true,
    final use_m_flow_in=true,
    final use_T_in=true,
    final nPorts=1)
    "Mass flow source for coil inlet air"
    annotation (Placement(transformation(extent={{-48,-20},{-28,0}})));

  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirIn
    "Convert humidity ratio per kg dry air to humidity ratio per kg total air for coil inlet air"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));

  parameter Buildings.Fluid.HeatExchangers.DXCoils.Cooling.AirSource.Validation.Data.SingleSpeedHeating datCoi
    "Heating coil data record"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));

equation
  connect(sinSpeDX.port_b, sin.ports[1])
    annotation (Line(
      points={{10,10},{16,10},{16,-10},{20,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TEvaIn_K.Kelvin, sinSpeDX.TOut) annotation (Line(
      points={{-79,49.8},{-70,49.8},{-70,13},{-11,13}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOut.y, TOutMea.u)
                           annotation (Line(
      points={{61,90},{78,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TOutMea.y, TOutDegC.Kelvin)
                                    annotation (Line(
      points={{101,90},{118,90}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(XConOut.y,XConOutMea. u)
                           annotation (Line(
      points={{61,130},{78,130}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sinSpeDX.QSen_flow, Q_flowMea.u) annotation (Line(points={{11,17},{20,
          17},{20,54},{-10,54},{-10,90},{-2,90}}, color={0,0,127}));
  connect(toTotAirOut.XiTotalAir, sinSpeDX.XOut) annotation (Line(points={{-79,80},
          {-40,80},{-40,17},{-11,17}},
                                     color={0,0,127}));
  connect(toTotAirEPlu.XiTotalAir, XConOutEPlu.u)
    annotation (Line(points={{21,-130},{28,-130}}, color={0,0,127}));
  connect(sinSpeDX.P, PMea.u) annotation (Line(points={{11,19},{25.5,19},{25.5,20},
          {38,20}}, color={0,0,127}));
  connect(datRea.y[14], plrToPul.uPLR)
    annotation (Line(points={{-131,120},{-82,120}}, color={0,0,127}));
  connect(plrToPul.yEna, sinSpeDX.on) annotation (Line(points={{-58,120},{-30,120},
          {-30,21},{-11,21}}, color={255,0,255}));
  connect(datRea.y[1], TEvaIn_K.Celsius) annotation (Line(points={{-131,120},{-108,
          120},{-108,49.6},{-102,49.6}}, color={0,0,127}));
  connect(datRea.y[9], toTotAirOut.XiDry) annotation (Line(points={{-131,120},{-108,
          120},{-108,80},{-101,80}}, color={0,0,127}));
  connect(datRea.y[17], boundary.m_flow_in) annotation (Line(points={{-131,120},
          {-108,120},{-108,16},{-74,16},{-74,-2},{-50,-2}},
                                                   color={0,0,127}));
  connect(TConIn_K.Kelvin, boundary.T_in) annotation (Line(points={{-79,-10.2},{
          -60,-10.2},{-60,-6},{-50,-6}}, color={0,0,127}));
  connect(toTotAirIn.XiTotalAir, boundary.Xi_in[1]) annotation (Line(points={{-79,
          -50},{-60,-50},{-60,-14},{-50,-14}}, color={0,0,127}));
  connect(datRea.y[5], TConIn_K.Celsius) annotation (Line(points={{-131,120},{-108,
          120},{-108,-10.4},{-102,-10.4}}, color={0,0,127}));
  connect(datRea.y[6], toTotAirIn.XiDry) annotation (Line(points={{-131,120},{-108,
          120},{-108,-50},{-101,-50}}, color={0,0,127}));
  connect(boundary.ports[1], sinSpeDX.port_a) annotation (Line(points={{-28,-10},
          {-18,-10},{-18,10},{-10,10}}, color={0,127,255}));
  connect(datRea.y[7], TOutEPlu.u) annotation (Line(points={{-131,120},{-108,120},
          {-108,-30},{-10,-30},{-10,-60},{-2,-60}}, color={0,0,127}));
  connect(datRea.y[8], toTotAirEPlu.XiDry) annotation (Line(points={{-131,120},{
          -108,120},{-108,-30},{-10,-30},{-10,-130},{-1,-130}}, color={0,0,127}));
  connect(datRea.y[3], PEPlu.u) annotation (Line(points={{-131,120},{-108,120},{
          -108,-30},{-10,-30},{-10,-108},{-74,-108},{-74,-130},{-70,-130}},
        color={0,0,127}));
  connect(datRea.y[2], Q_flowEPlu.u) annotation (Line(points={{-131,120},{-108,120},
          {-108,-30},{-10,-30},{-10,-108},{90,-108},{90,-130},{98,-130}}, color=
         {0,0,127}));
  connect(datRea.y[15], PDefEPlu.u) annotation (Line(points={{-131,120},{-108,120},
          {-108,-30},{-10,-30},{-10,-40},{98,-40}}, color={0,0,127}));
  connect(datRea.y[16], PCraEPlu.u) annotation (Line(points={{-131,120},{-108,120},
          {-108,-80},{98,-80}}, color={0,0,127}));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-180,-160},
            {180,160}})),
  Documentation(info="<html>
<p>
This is a baseclass component for the following validation models:
</p>
<ul>
<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Validation.SingleSpeed_OnDemandResistiveDefrost\">
Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Validation.SingleSpeed_OnDemandResistiveDefrost</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Validation.SingleSpeed_OnDemandReverseCycleDefrost\">
Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Validation.SingleSpeed_OnDemandReverseCycleDefrost</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Validation.SingleSpeed_TimedResistiveDefrost\">
Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Validation.SingleSpeed_TimedResistiveDefrost</a>
</li>
<li>
<a href=\"modelica://Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Validation.SingleSpeed_TimedReverseCycleDefrost\">
Buildings.Fluid.HeatExchangers.DXCoils.Heating.AirSource.Validation.SingleSpeed_TimedReverseCycleDefrost</a>
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
April 2, 2023, by Karthik Devaprasad and Xing Lu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end SingleSpeedHeating;
