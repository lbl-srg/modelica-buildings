within Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.BaseClasses;
block DXHeating "Heating operation"
  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.PartialCoilCondition(    speShiEIR(speSet=datHP.heaSta.spe, nSta=datHP.nHeaSta,
      variableSpeedCoil=variableSpeedCoil),
      speShiQ_flow(speSet=datHP.heaSta.spe, nSta=datHP.nHeaSta,
      variableSpeedCoil=variableSpeedCoil));
  replaceable parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.Data.HPData                       datHP
    "Heat pump performance data";
  constant Boolean variableSpeedCoil
    "Flag, set to true for coil with variable speed";

//  replaceable
    Buildings.Fluid.HeatExchangers.HeatPumps.AirToAir.BaseClasses.HeatingCapacity
                                                                                  heaCap(
    heaSta=datHP.heaSta,
    m1_flow_small=datHP.m1_flow_small,
    nSta=datHP.nHeaSta)
    annotation (Placement(transformation(extent={{0,50},{20,70}})));
//     m2_flow_small=datHP.m2_flow_small,
  Modelica.Blocks.Interfaces.RealOutput TCoiSur(
    quantity="Temperature",
    unit="K") = 273.15+30 "Coil surface temperature"
     annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
//   constant Boolean calRecoverableWasteHeat
//     "Flag, set to true if recoverable waste heat is calculated";
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
  annotation (defaultComponentName="dxHea",Diagram(graphics));
end DXHeating;
