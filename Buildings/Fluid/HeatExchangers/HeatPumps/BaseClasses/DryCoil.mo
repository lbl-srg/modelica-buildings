within Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses;
block DryCoil "Calculates dry coil condition"

  extends
    Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.PartialCoilCondition(    speShiEIR(speSet=datHP.cooSta.spe,
        nSta=datHP.nCooSta,
      variableSpeedCoil=true),
                             speShiQ_flow(speSet=datHP.cooSta.spe, nSta=datHP.nCooSta,
      variableSpeedCoil=true));

  extends Buildings.Fluid.HeatExchangers.HeatPumps.BaseClasses.PartialDryCoil(
      appDryPt(datHP=datHP,
      redeclare package Medium = Medium,
      variableSpeedCoil=true));

  replaceable parameter
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.Data.HPData   datHP
    "Performance data";

  constant Boolean calRecoverableWasteHeat
    "Flag, set to true if recoverable waste heat is calculated";

  Modelica.Blocks.Interfaces.RealOutput QRecWas_flow(each min=0) if calRecoverableWasteHeat
    "Recoverable waste heat, positive value "
     annotation (Placement(transformation(extent={{100,50},{120,70}})));
//protected
  DXCoils.BaseClasses.SpeedShift speShiRecWasQ_flow(
    nSta=datHP.nCooSta,
    speSet=datHP.cooSta.spe,
    variableSpeedCoil=true) if calRecoverableWasteHeat
    "Interpolates recoverable waste heat flow"
    annotation (Placement(transformation(extent={{44,52},{60,68}})));
  replaceable
    Buildings.Fluid.HeatExchangers.HeatPumps.WaterToAir.BaseClasses.CoolingCapacity
                                                       cooCap(
    cooSta=datHP.cooSta,
    m1_flow_small=datHP.m1_flow_small,
    nSta=datHP.nCooSta)
    annotation (Placement(transformation(extent={{0,50},{20,70}})));

  Modelica.Blocks.Interfaces.RealOutput TDry(
    quantity="Temperature",
    unit="K",
    min=233.15,
    max=373.15) "Dry bulb temperature of air at ADP"
     annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
equation
  connect(mode, cooCap.mode) annotation (Line(
      points={{-110,100},{-56,100},{-56,70},{-1,70}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(speRat, speShiEIR.speRat) annotation (Line(
      points={{-110,76},{32,76},{32,80},{42.4,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, speShiQ_flow.speRat) annotation (Line(
      points={{-110,76},{32,76},{32,40},{42.4,40}},
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
  connect(cooCap.EIR, speShiEIR.u) annotation (Line(
      points={{21,64},{28,64},{28,73.6},{42.4,73.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooCap.Q_flow, speShiQ_flow.u) annotation (Line(
      points={{21,56},{26,56},{26,33.6},{42.4,33.6}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T[1], cooCap.T1In) annotation (Line(
      points={{-110,45},{-52,45},{-52,66},{-1,66}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(T[2], cooCap.T2In) annotation (Line(
      points={{-110,55},{-50,55},{-50,58},{-1,58}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow[1], cooCap.m1_flow) annotation (Line(
      points={{-110,19},{-44,19},{-44,62},{-1,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow[2], cooCap.m2_flow) annotation (Line(
      points={{-110,29},{-44,29},{-44,54},{-1,54}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speRat, appDryPt.speRat) annotation (Line(
      points={{-110,76},{-36,76},{-36,-53},{39,-53}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(speShiQ_flow.y, appDryPt.Q_flow) annotation (Line(
      points={{60.8,40},{64,40},{64,-20},{20,-20},{20,-56.1},{39,-56.1}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(m_flow[1], appDryPt.m_flow) annotation (Line(
      points={{-110,19},{-44,19},{-44,-59},{39,-59}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(mode, appDryPt.mode) annotation (Line(
      points={{-110,100},{-56,100},{-56,-50},{39,-50}},
      color={255,127,0},
      smooth=Smooth.None));
  connect(cooCap.QRecWas_flow, speShiRecWasQ_flow.u) annotation (Line(
      points={{21,60},{28,60},{28,54},{42.4,54},{42.4,53.6}},
      color={0,0,127},
      smooth=Smooth.None), Dialog(enable = if calRecoverableWasteHeat then true else false));
  connect(speRat, speShiRecWasQ_flow.speRat) annotation (Line(
      points={{-110,76},{32,76},{32,60},{42.4,60}},
      color={0,0,127},
      smooth=Smooth.None), Dialog(enable = if calRecoverableWasteHeat then true else false));
  connect(mode, speShiRecWasQ_flow.stage) annotation (Line(
      points={{-110,100},{36,100},{36,66.4},{42.4,66.4}},
      color={255,127,0},
      smooth=Smooth.None), Dialog(enable = if calRecoverableWasteHeat then true else false));
  connect(speShiRecWasQ_flow.y, QRecWas_flow) annotation (Line(
      points={{60.8,60},{110,60}},
      color={0,0,127},
      smooth=Smooth.None), Dialog(enable = if calRecoverableWasteHeat then true else false));

  annotation (Diagram(graphics));
end DryCoil;
