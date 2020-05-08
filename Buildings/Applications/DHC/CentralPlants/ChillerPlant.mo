within Buildings.Applications.DHC.CentralPlants;
model ChillerPlant "District cooling plant model"
  import ChillerPlantSystem = WaterSide.Plant;

  package MediumCHW = Buildings.Media.Water
    "Medium model";
  package MediumCW = Buildings.Media.Water "Medium model";
  parameter Real tWai = 900 "Waiting time";
  parameter Modelica.SIunits.TemperatureDifference dT = 0.5
    "Temperature difference for stage control";
  parameter Modelica.SIunits.Power PChi_nominal = 1442/COP_nominal
    "Nominal chiller power (at y=1)";
  parameter Modelica.SIunits.Power PTow_nominal = 1E3
    "Nominal cooling tower power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTCHW_nominal = 5.56
    "Temperature difference at chilled water side";
  parameter Modelica.SIunits.TemperatureDifference dTCW_nominal = 5.18
    "Temperature difference at condenser water wide";
  parameter Modelica.SIunits.Pressure dPCHW_nominal = 210729
    "Pressure difference at the chilled water side";
  parameter Modelica.SIunits.Pressure dPCW_nominal = 92661
    "Pressure difference at the condenser water wide";
  parameter Modelica.SIunits.Pressure dPTow_nominal = 191300
    "Pressure difference at the condenser water wide";
  parameter Modelica.SIunits.Temperature TCHW_nominal = 273.15 + 5.56
    "Temperature at chilled water side";
  parameter Modelica.SIunits.Temperature TCW_nominal = 273.15 + 23.89
    "Temperature at condenser water wide";
  parameter Modelica.SIunits.TemperatureDifference dTApp_nominal=4.44
    "Nominal approach temperature";
  parameter Modelica.SIunits.TemperatureDifference dTApp=4.44
    "Approach temperature for controlling cooling towers";
  parameter Real COP_nominal = 6.61 "Chiller COP";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal = 1442/4.2/5.56
    "Nominal mass flow rate at chilled water side";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal = mCHW_flow_nominal*(COP_nominal+1)/COP_nominal
    "Nominal mass flow rate at condenser water wide";
  parameter Real Motor_eta = 0.87 "Motor efficiency";
  parameter Real Hydra_eta = 1 "Hydraulic efficiency";
  parameter Modelica.SIunits.Pressure dP_nominal=478250
    "Nominal pressure drop for the secondary chilled water pump ";
  parameter Real v_flow_ratio[:] = {0.4,0.6,0.8,1,1.2};
  parameter Real v_flow_rate[:] = {0.4*mCHW_flow_nominal/996,0.6*mCHW_flow_nominal/996,0.8*mCHW_flow_nominal/996,mCHW_flow_nominal/996,1.2*mCHW_flow_nominal/996};
  parameter Real pressure[:] = {1.28*dP_nominal,1.2*dP_nominal,1.1*dP_nominal,dP_nominal,0.75*dP_nominal};

  parameter Real Motor_eta_Sec[:] = {0.6,0.76,0.87,0.86,0.74}
    "Motor efficiency";
  parameter Real Hydra_eta_Sec[:] = {1,1,1,1,1} "Hydraulic efficiency";
  parameter Modelica.SIunits.Pressure dPByp_nominal=100
    "Pressure difference between the outlet and inlet of the modules ";
  parameter Real vTow_flow_rate[:]={1} "Volume flow rate rate";
  parameter Real eta[:]={1} "Fan efficiency";
  parameter Modelica.SIunits.Temperature TWetBul_nominal=273.15+19.45
    "Nominal wet bulb temperature";
  Subsystems.PumpSystemVariableSpeed pumCHW(
    Motor_eta=Motor_eta,
    Hydra_eta=Hydra_eta,
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal)
    annotation (Placement(transformation(extent={{70,42},{34,78}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWByp(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    allowFlowReversal=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,30})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCHW(
      redeclare package Medium = MediumCHW)
    annotation (Placement(transformation(extent={{30,-60},{50,-40}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFloByp(redeclare package Medium =
                       MediumCHW) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={80,-60})));
  Subsystems.CoolingTowerWithBypass cooTowWitByp(
    redeclare package MediumCW = MediumCW,
    TSet=273.15 + 15.56,
    P_nominal=PTow_nominal,
    dTCW_nominal=dTCW_nominal,
    dP_nominal=dP_nominal,
    mCW_flow_nominal=mCW_flow_nominal,
    GaiPi=0.1,
    tIntPi=60,
    eta=eta,
    dPByp_nominal=dPByp_nominal,
    byp(dPByp_nominal=dPByp_nominal),
    TCW_start=273.15 + 29.44,
    v_flow_rate=vTow_flow_rate,
    dTApp_nominal=dTApp_nominal,
    TWetBul_nominal=TWetBul_nominal)
    annotation (Placement(transformation(extent={{-120,-16},{-80,24}})));
  Subsystems.PumpSystemConstantSpeed pumCW(
    redeclare package Medium = MediumCW,
    m_flow_nominal=mCW_flow_nominal,
    Motor_eta=Motor_eta,
    Hydra_eta=Hydra_eta)
    annotation (Placement(transformation(extent={{-66,-98},{-30,-62}})));
  Buildings.Fluid.Storage.ExpansionVessel expVesCW(
      redeclare package Medium = MediumCW)
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Controls.ChillerStage                      chiStaCon(
    tWai=1800,
    CooCap=-mulChiSys.per.QEva_flow_nominal,
    thehol=0.9)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTCHWSup(
    redeclare package Medium = MediumCHW,
    m_flow_nominal=mCHW_flow_nominal,
    allowFlowReversal=true) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={110,-80})));
  Modelica.Blocks.Interfaces.BooleanInput on "On signal of the plant"
    annotation (Placement(transformation(extent={{-180,40},{-140,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput TWetBul
    "Entering air wet bulb temperature"
    annotation (Placement(transformation(extent={{-180,-80},{-140,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Modelica.Blocks.Interfaces.RealInput QLoa "District cooling load"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{130,50},{150,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{130,-90},{150,-70}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage           valByp(
    redeclare package Medium = MediumCW,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=dPByp_nominal) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={80,-10})));
  Controls.ChillerBypassControl chiBypCon
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Subsystems.MultiChillerSystem mulChiSys
    annotation (Placement(transformation(extent={{-20,-20},{20,20}})));
equation
  connect(senTCHWByp.port_b, pumCHW.port_a) annotation (Line(
      points={{80,40},{80,60},{70,60}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(mulChiSys.port_b_CHW, senMasFloByp.port_a) annotation (Line(
      points={{20,-16},{24,-16},{24,-80},{80,-80},{80,-70}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(expVesCHW.port_a, senMasFloByp.port_a) annotation (Line(
      points={{40,-60},{40,-80},{80,-80},{80,-70}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));
  connect(cooTowWitByp.port_b, pumCW.port_a) annotation (Line(
      points={{-80,-12},{-80,-80},{-66,-80}},
      color={0,127,255},
      smooth=Smooth.None,
      thickness=1));

  connect(chiStaCon.On, on) annotation (Line(
      points={{-102,58},{-132,58},{-132,60},{-160,60}},
      color={255,0,255},
      pattern=LinePattern.Dash));
  connect(chiStaCon.CooLoa, QLoa) annotation (Line(
      points={{-102,50},{-132,50},{-132,0},{-160,0}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(senTCHWSup.port_b, port_b) annotation (Line(
      points={{120,-80},{140,-80}},
      color={0,127,255},
      thickness=1));
  connect(expVesCW.port_a, pumCW.port_a) annotation (Line(
      points={{-110,-60},{-110,-80},{-66,-80}},
      color={0,127,255},
      thickness=1));
  connect(TWetBul, cooTowWitByp.TWetBul) annotation (Line(
      points={{-160,-60},{-132,-60},{-132,-8},{-121.8,-8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(pumCHW.port_a, port_a) annotation (Line(
      points={{70,60},{140,60}},
      color={0,127,255},
      thickness=1));
  connect(chiStaCon.y,mulChiSys.on)  annotation (Line(
      points={{-79,50},{-60,50},{-60,0},{-22,0}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(chiStaCon.y, pumCW.On) annotation (Line(
      points={{-79,50},{-74,50},{-74,-69.2},{-67.62,-69.2}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(chiStaCon.y, cooTowWitByp.On) annotation (Line(
      points={{-79,50},{-74,50},{-74,24},{-128,24},{-128,16},{-121.8,16}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(senMasFloByp.port_b, valByp.port_a) annotation (Line(
      points={{80,-50},{80,-20}},
      color={0,127,255},
      thickness=1));
  connect(valByp.port_b, senTCHWByp.port_a) annotation (Line(
      points={{80,0},{80,20}},
      color={0,127,255},
      thickness=1));
  connect(chiStaCon.y[1], chiBypCon.T) annotation (Line(
      points={{-79,49.3333},{-50,49.3333},{-50,50},{-22,50}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(chiBypCon.y, valByp.y) annotation (Line(
      points={{1,50},{40,50},{40,-10},{68,-10}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(pumCW.port_b, mulChiSys.port_a_CW) annotation (Line(
      points={{-30,-80},{-26,-80},{-26,-16},{-20,-16}},
      color={0,127,255},
      thickness=1));
  connect(cooTowWitByp.port_a, mulChiSys.port_b_CW) annotation (Line(
      points={{-80,16},{-20,16}},
      color={0,127,255},
      thickness=1));
  connect(pumCHW.port_b, mulChiSys.port_a_CHW) annotation (Line(
      points={{34,60},{26,60},{26,16},{20,16}},
      color={0,127,255},
      thickness=1));
  connect(mulChiSys.port_b_CHW, senTCHWSup.port_a) annotation (Line(
      points={{20,-16},{24,-16},{24,-80},{100,-80}},
      color={0,127,255},
      thickness=1));
  connect(mulChiSys.rat, chiStaCon.Status) annotation (Line(
      points={{22,-8},{32,-8},{32,34},{-112,34},{-112,42},{-102,42}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(chiStaCon.y, pumCHW.Spe) annotation (Line(
      points={{-79,50},{-74,50},{-74,80},{80,80},{80,70.8},{71.62,70.8}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  annotation (__Dymola_Commands(file=
          "modelica://ChillerPlantSystem/Resources/Scripts/Dymola/LejeunePlant/ChillerPlantSystem.mos"
        "Simulate and plot"),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-100},{140,100}})),
    experiment(
      StartTime=1.728e+007,
      StopTime=1.73664e+007,
      __Dymola_NumberOfIntervals=1440,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    Documentation(info="<html>
<p>The schematic drawing of the Lejeune plant is shown as folowing.</p>
<p><img src=\"Resources/Images/lejeunePlant/lejeune_schematic_drawing.jpg\" alt=\"image\"/> </p>
<p>In addition, the parameters are listed as below.</p>
<p>The parameters for the chiller plant.</p>
<p><img src=\"Resources/Images/lejeunePlant/Chiller.png\" alt=\"image\"/> </p>
<p>The parameters for the primary chilled water pump.</p>
<p><img src=\"Resources/Images/lejeunePlant/PriCHWPum.png\" alt=\"image\"/> </p>
<p>The parameters for the secondary chilled water pump.</p>
<p><img src=\"Resources/Images/lejeunePlant/SecCHWPum1.png\" alt=\"image\"/> </p>
<p><img src=\"Resources/Images/lejeunePlant/SecCHWPum2.png\" alt=\"image\"/> </p>
<p>The parameters for the condenser water pump.</p>
<p><img src=\"Resources/Images/lejeunePlant/CWPum.png\" alt=\"image\"/> </p>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Polygon(
          points={{-62,-14},{-62,-14}},
          lineColor={238,46,47},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{80,-60},{-80,-60},{-80,60},{-60,60},{-60,0},{-40,0},{-40,20},
              {0,0},{0,20},{40,0},{40,20},{80,0},{80,-60}},
          lineColor={95,95,95},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{46,-38},{58,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{62,-38},{74,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{62,-54},{74,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{46,-54},{58,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{22,-54},{34,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{6,-54},{18,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{6,-38},{18,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{22,-38},{34,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-18,-54},{-6,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-34,-54},{-22,-42}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-34,-38},{-22,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Rectangle(
        extent={{-18,-38},{-6,-26}},
        lineColor={255,255,255},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid)}));
end ChillerPlant;
