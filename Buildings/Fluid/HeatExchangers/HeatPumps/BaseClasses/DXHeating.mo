within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
block DXHeating "Heating operation"
  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.PartialCoilCondition(    speShiEIR(speSet=datHP.heaSta.spe, nSta=datHP.nHeaSta,
      variableSpeedCoil=variableSpeedCoil),
      speShiQ_flow(speSet=datHP.heaSta.spe, nSta=datHP.nHeaSta,
      variableSpeedCoil=variableSpeedCoil));
  replaceable parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData                       datHP
    "Heat pump performance data";
  constant Boolean variableSpeedCoil
    "Flag, set to true for coil with variable speed";

  replaceable
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.HeatingCapacity
                                                                                                heaCap(
    heaSta=datHP.heaSta,
    m1_flow_small=datHP.m1_flow_small,
    m2_flow_small=datHP.m2_flow_small,
    nSta=datHP.nHeaSta)
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
  Modelica.Blocks.Interfaces.RealOutput TCoiSur(
    quantity="ThermodynamicTemperature",
    unit="K") = 273.15+30 "Coil surface temperature"
     annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  DXCoils.BaseClasses.SpeedShift speShiRecWasQ_flow(
    variableSpeedCoil=true,
    nSta=datHP.nHeaSta,
    speSet=datHP.heaSta.spe) if
                               calRecoverableWasteHeat
    "Interpolates recoverable waste heat flow"
    annotation (Placement(transformation(extent={{44,52},{60,68}})));
  Modelica.Blocks.Interfaces.RealOutput QRecWas_flow(each min=0) if calRecoverableWasteHeat
    "Recoverable waste heat, positive value "
     annotation (Placement(transformation(extent={{100,50},{120,70}})));
  constant Boolean calRecoverableWasteHeat
    "Flag, set to true if recoverable waste heat is calculated";
equation
  connect(mode, heaCap.mode) annotation (Line(
      points={{-110,100},{-66,100},{-66,70},{-1,70}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(speRat, speShiEIR.speRat) annotation (Line(
      points={{-110,76},{-36,76},{-36,80},{42.4,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, speShiQ_flow.speRat) annotation (Line(
      points={{-110,76},{-36,76},{-36,80},{32,80},{32,40},{42.4,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mode, speShiQ_flow.stage) annotation (Line(
      points={{-110,100},{36,100},{36,46.4},{42.4,46.4}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(mode, speShiEIR.stage) annotation (Line(
      points={{-110,100},{36,100},{36,86.4},{42.4,86.4}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(heaCap.EIR, speShiEIR.u) annotation (Line(
      points={{21,64},{28,64},{28,73.6},{42.4,73.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(heaCap.Q_flow, speShiQ_flow.u) annotation (Line(
      points={{21,56},{24,56},{24,33.6},{42.4,33.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T[1], heaCap.T1In) annotation (Line(
      points={{-110,45},{-56,45},{-56,66},{-1,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T[2], heaCap.T2In) annotation (Line(
      points={{-110,55},{-56,55},{-56,58},{-1,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow[1], heaCap.m1_flow) annotation (Line(
      points={{-110,19},{-30,19},{-30,62},{-1,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow[2], heaCap.m2_flow) annotation (Line(
      points={{-110,29},{-30,29},{-30,54},{-1,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speShiRecWasQ_flow.y, QRecWas_flow) annotation (Line(
      points={{60.8,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None), Dialog(enable = if calRecoverableWasteHeat then true else false));
  connect(mode, speShiRecWasQ_flow.stage) annotation (Line(
      points={{-110,100},{36,100},{36,66.4},{42.4,66.4}},
      color={255,127,0},
      smooth=Smooth.None), Dialog(enable = if calRecoverableWasteHeat then true else false));
  connect(heaCap.QRecWas_flow, speShiRecWasQ_flow.u) annotation (Line(
      points={{21,60},{28,60},{28,53.6},{42.4,53.6}},
      color={0,0,127},
      smooth=Smooth.None), Dialog(enable = if calRecoverableWasteHeat then true else false));
  connect(speRat, speShiRecWasQ_flow.speRat) annotation (Line(
      points={{-110,76},{-36,76},{-36,80},{32,80},{32,60},{42.4,60}},
      color={0,0,127},
      smooth=Smooth.None), Dialog(enable = if calRecoverableWasteHeat then true else false));
  annotation (defaultComponentName="dxHea",Diagram(graphics));
end DXHeating;
