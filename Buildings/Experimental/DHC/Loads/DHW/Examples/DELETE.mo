within Buildings.Experimental.DHC.Loads.DHW.Examples;
package DELETE "These models are outdated"

  model DistrictETSIntegration
    "Example implementation of connecting district ETS to building DHW model"
    extends Modelica.Icons.Example;
    replaceable package Medium = Buildings.Media.Water "Water media model";
    parameter Modelica.Units.SI.Temperature TSetHw = 273.15+50 "Temperature setpoint of hot water supply from heater";
    parameter Modelica.Units.SI.Temperature TDHw = 273.15+45 "Temperature setpoint of hot water supply from district";
    parameter Modelica.Units.SI.Temperature TSetTw = 273.15+43 "Temperature setpoint of tempered water supply at fixture";
    parameter Modelica.Units.SI.Temperature TDcw = 273.15+10 "Temperature setpoint of domestic cold water supply";
    parameter Modelica.Units.SI.MassFlowRate mHw_flow_nominal = 0.1 "Nominal mass flow rate of hot water supply";
    parameter Modelica.Units.SI.MassFlowRate mDH_flow_nominal = 1 "Nominal mass flow rate of district heating water";
    parameter Modelica.Units.SI.MassFlowRate mDhw_flow_nominal = mHw_flow_nominal "Nominal mass flow rate of tempered water";
    parameter Modelica.Units.SI.PressureDifference dpValve_nominal(min=0, displayUnit="Pa") "Pressure difference";
    parameter Real k(min=0) = 2 "Gain of controller";
    parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small) = 15 "Time constant of Integrator block" annotation (Dialog(enable=
            controllerType == Modelica.Blocks.Types.SimpleController.PI or
            controllerType == Modelica.Blocks.Types.SimpleController.PID));
    parameter Boolean haveER = true "Flag that specifies whether electric resistance booster is present";

    Buildings.Fluid.Sources.Boundary_pT souDcw(
      redeclare package Medium = Medium,
      T(displayUnit = "degC") = TDcw,
      nPorts=2) "Source of domestic cold water"
      annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
    Modelica.Blocks.Math.Gain gaiDhw(k=-0.3234)
      "Gain for multiplying domestic hot water schedule"
      annotation (Placement(transformation(extent={{82,74},{70,86}})));
    BaseClasses.DELETE.DirectHeatExchangerWaterHeaterWithAuxHeatOLD
      disHXAuxHea(
      redeclare package Medium = Medium,
      TSetHw(displayUnit="degC") = TSetHw,
      mHw_flow_nominal=mHw_flow_nominal,
      mDH_flow_nominal=mDH_flow_nominal,
      haveER=haveER)
      "Direct district heat exchanger with auxiliary electric heating"
      annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
    Buildings.Fluid.Sources.MassFlowSource_T sinDhw(
      redeclare package Medium = Medium,
      use_m_flow_in=true,
      nPorts=1) "Sink for domestic hot water supply"
      annotation (Placement(transformation(extent={{48,38},{28,58}})));
    DomesticWaterMixer tmv(
      redeclare package Medium = Medium,
      TSet(displayUnit="degC") = TSetTw,
      mDhw_flow_nominal=mDhw_flow_nominal,
      dpValve_nominal=dpValve_nominal,
      k=k,
      Ti=Ti) "Ideal thermostatic mixing valve"
      annotation (Placement(transformation(extent={{0,40},{20,60}})));
    Modelica.Blocks.Sources.Sine sine(f=0.001,
      offset=1)
      annotation (Placement(transformation(extent={{120,70},{100,90}})));
    Modelica.Blocks.Continuous.Integrator watCon(k=-1)
      "Integrated hot water consumption"
      annotation (Placement(transformation(extent={{80,38},{100,58}})));
    Modelica.Blocks.Interfaces.RealOutput PEleAuxHea(displayUnit="W") if haveER ==
      true
      "Thermal energy added to water with electric resistance"
      annotation (Placement(transformation(extent={{120,110},{140,130}})));
    Modelica.Blocks.Interfaces.RealOutput TTw(final unit="K",displayUnit = "degC") "Temperature of the outlet tempered water"
      annotation (Placement(transformation(extent={{120,90},{140,110}})));
    Modelica.Blocks.Interfaces.RealOutput mDhw(displayUnit="kg") "Total hot water consumption"
      annotation (Placement(transformation(extent={{120,38},{140,58}}),
          iconTransformation(extent={{100,18},{140,58}})));
    Modelica.Blocks.Sources.Constant const(k=1)
      annotation (Placement(transformation(extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-60,150})));
    EnergyTransferStations.Combined.HeatPumpHeatExchanger_Current ets(
      nPorts_aHeaWat=1,
      nPorts_aChiWat=1,
      nPorts_bChiWat=1,
      nPorts_bHeaWat=1)
      annotation (Placement(transformation(extent={{-30,-30},{30,30}})));
    Fluid.Sensors.TemperatureTwoPort           senTHeaWatRet(redeclare final
        package Medium =       Medium, m_flow_nominal=datChi.mCon_flow_nominal)
      "Heating water return temperature" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-106,40})));
    Fluid.Sensors.TemperatureTwoPort           senTChiWatRet(redeclare final
        package Medium =       Medium, m_flow_nominal=datChi.mEva_flow_nominal)
      "Chilled water return temperature" annotation (Placement(transformation(
          extent={{10,10},{-10,-10}},
          rotation=0,
          origin={-108,0})));
    Fluid.Sensors.TemperatureTwoPort           senTChiWatSup(redeclare package
        Medium =         Medium, m_flow_nominal=datChi.mEva_flow_nominal)
      "Chilled water supply temperature" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={80,-40})));
    EnergyTransferStations.BaseClasses.Pump_m_flow     pumHeaWat(
      redeclare package Medium = Medium,
      final m_flow_nominal=mHeaWat_flow_nominal,
      dp_nominal=100E3) "Heating water distribution pump"
      annotation (Placement(transformation(extent={{-10,122},{-30,142}})));
    Fluid.Sensors.TemperatureTwoPort           senTHeaWatSup(redeclare package
        Medium =         Medium, m_flow_nominal=datChi.mCon_flow_nominal)
      "Heating water supply temperature" annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          rotation=90,
          origin={-34,98})));
    Fluid.MixingVolumes.MixingVolume           volChiWat(
      energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
      T_start=7 + 273.15,
      final prescribedHeatFlowRate=true,
      redeclare package Medium = Medium,
      V=10,
      final mSenFac=1,
      final m_flow_nominal=mChiWat_flow_nominal,
      nPorts=2) "Volume for chilled water distribution circuit" annotation (
        Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={151,-90})));
    EnergyTransferStations.BaseClasses.Pump_m_flow     pumChiWat(
      redeclare package Medium = Medium,
      final m_flow_nominal=mChiWat_flow_nominal,
      dp_nominal=100E3) "Chilled water distribution pump"
      annotation (Placement(transformation(extent={{100,-50},{120,-30}})));
    Modelica.Blocks.Continuous.Integrator EDisHP(y(unit="J"))
      "District heat pump electricity use"
      annotation (Placement(transformation(extent={{100,-2},{120,18}})));
    Controls.OBC.CDL.Continuous.GreaterThreshold           uHea(final t=
          0.01, final h=0.005)
      "Enable heating"
      annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
    Controls.OBC.CDL.Continuous.GreaterThreshold           uCoo(final t=
          0.01, final h=0.005)
      "Enable cooling"
      annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
    Controls.OBC.CDL.Continuous.Sources.Constant           THeaWatSupSet(k=45 +
          273.15, y(final unit="K", displayUnit="degC"))
      "Heating water supply temperature set point"
      annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
    Controls.OBC.CDL.Continuous.Sources.Constant           TChiWatSupSet(k=7 +
          273.15, y(final unit="K", displayUnit="degC"))
      "Chilled water supply temperature set point"
      annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
    Fluid.Sensors.TemperatureTwoPort           senTDisWatSup(redeclare final
        package Medium =       Medium, final m_flow_nominal=ets.hex.m1_flow_nominal)
      "District water supply temperature" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={-40,-60})));
    Fluid.Sensors.TemperatureTwoPort senTDisWatRet(redeclare final package
        Medium = Medium, final m_flow_nominal=ets.hex.m1_flow_nominal)
      "District water return temperature" annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=-90,
          origin={40,-60})));
    Fluid.Sources.Boundary_pT           disWat(
      redeclare package Medium = Medium,
      use_T_in=true,
      nPorts=2) "District water boundary conditions" annotation (Placement(
          transformation(
          extent={{-10,-10},{10,10}},
          rotation=90,
          origin={0,-90})));
    Modelica.Blocks.Sources.CombiTimeTable TDisWatSup(
      table=[0,11; 1,12; 2,13; 3,14; 4,15; 5,16; 6,17; 7,18; 8,20; 9,18; 10,
          16; 11,13; 12,11],
      timeScale=2592000,
      tableName="tab1",
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
      offset={273.15},
      columns={2},
      smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
      "District water supply temperature"
      annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  equation
    connect(tmv.port_tw, sinDhw.ports[1])
      annotation (Line(points={{20,50},{24,50},{24,48},{28,48}},
                                              color={0,127,255}));
    connect(gaiDhw.y, sinDhw.m_flow_in) annotation (Line(points={{69.4,80},
            {60,80},{60,56},{50,56}},
                            color={0,0,127}));
    connect(sine.y, gaiDhw.u)
      annotation (Line(points={{99,80},{83.2,80}},
                                                 color={0,0,127}));
    connect(watCon.u, sinDhw.m_flow_in) annotation (Line(points={{78,48},{
            60,48},{60,56},{50,56}},
                            color={0,0,127}));
    connect(disHXAuxHea.port_hw, tmv.port_hw) annotation (Line(points={{-20,60},
            {-10,60},{-10,56},{0,56}},
                                  color={0,127,255}));
    connect(souDcw.ports[1], disHXAuxHea.port_cw) annotation (Line(points={{-60,49},
            {-60,60},{-40,60}},                 color={0,127,255}));
    connect(souDcw.ports[2], tmv.port_cw) annotation (Line(points={{-60,51},
            {-60,40},{-10,40},{-10,44},{0,44}},              color={0,127,255}));
    connect(disHXAuxHea.PEle, PEleAuxHea) annotation (Line(points={{-19.4,
            64},{0,64},{0,120},{130,120}},
                                         color={0,0,127}));
    connect(tmv.TTw, TTw)
      annotation (Line(points={{21,56},{28,56},{28,100},{130,100}},
                                                               color={0,0,127}));
    connect(watCon.y, mDhw)
      annotation (Line(points={{101,48},{130,48}},  color={0,0,127}));
    connect(ets.ports_aHeaWat[1], senTHeaWatRet.port_b) annotation (Line(
          points={{-30,26},{-80,26},{-80,40},{-96,40}}, color={0,127,255}));
    connect(senTChiWatRet.port_a, ets.ports_aChiWat[1]) annotation (Line(
          points={{-98,0},{-80,0},{-80,16},{-30,16}}, color={0,127,255}));
    connect(ets.ports_bChiWat[1], senTChiWatSup.port_a) annotation (Line(
          points={{30,16},{60,16},{60,-40},{70,-40}}, color={0,127,255}));
    connect(ets.ports_bHeaWat[1], pumHeaWat.port_a) annotation (Line(points=
           {{30,26},{140,26},{140,132},{-10,132}}, color={0,127,255}));
    connect(senTHeaWatSup.port_a, pumHeaWat.port_b) annotation (Line(points=
           {{-34,108},{-34,132},{-30,132}}, color={0,127,255}));
    connect(senTHeaWatSup.port_b, disHXAuxHea.port_dhs)
      annotation (Line(points={{-34,88},{-34,70}}, color={0,127,255}));
    connect(const.y, pumHeaWat.m_flow_in) annotation (Line(points={{-49,150},
            {-20,150},{-20,144}}, color={0,0,127}));
    connect(senTChiWatSup.port_b, pumChiWat.port_a)
      annotation (Line(points={{90,-40},{100,-40}}, color={0,127,255}));
    connect(pumChiWat.port_b, volChiWat.ports[1]) annotation (Line(points={{120,-40},
            {140,-40},{140,-89},{141,-89}},           color={0,127,255}));
    connect(volChiWat.ports[2], senTChiWatRet.port_b) annotation (Line(
          points={{141,-91},{140,-91},{140,-140},{-140,-140},{-140,0},{-118,
            0}}, color={0,127,255}));
    connect(disHXAuxHea.port_dhr, senTHeaWatRet.port_a) annotation (Line(
          points={{-38,70},{-38,78},{-140,78},{-140,40},{-116,40}}, color={
            0,127,255}));
    connect(ets.PHea, EDisHP.u)
      annotation (Line(points={{34,8},{98,8}}, color={0,0,127}));
    connect(uHea.y, ets.uHea) annotation (Line(points={{-98,-40},{-74,-40},
            {-74,10},{-34,10}}, color={255,0,255}));
    connect(uCoo.y, ets.uCoo) annotation (Line(points={{-98,-70},{-70,-70},
            {-70,6},{-34,6}}, color={255,0,255}));
    connect(THeaWatSupSet.y, ets.THeaWatSupSet) annotation (Line(points={{
            -118,140},{-86,140},{-86,-2},{-34,-2}}, color={0,0,127}));
    connect(TChiWatSupSet.y, ets.TChiWatSupSet) annotation (Line(points={{
            -118,100},{-90,100},{-90,-6},{-34,-6}}, color={0,0,127}));
    connect(senTDisWatSup.port_b, ets.port_aSerAmb) annotation (Line(points=
           {{-40,-50},{-40,-20},{-30,-20}}, color={0,127,255}));
    connect(senTDisWatRet.port_a, ets.port_bSerAmb) annotation (Line(points=
           {{40,-50},{40,-20},{30,-20}}, color={0,127,255}));
    connect(disWat.ports[1], senTDisWatRet.port_b) annotation (Line(points={{1,-80},
            {40,-80},{40,-70}},           color={0,127,255}));
    connect(disWat.ports[2], senTDisWatSup.port_a) annotation (Line(points={{-1,-80},
            {-40,-80},{-40,-70}},          color={0,127,255}));
    connect(TDisWatSup.y[1], disWat.T_in) annotation (Line(points={{-99,
            -110},{-4,-110},{-4,-102}}, color={0,0,127}));
    connect(PEleAuxHea, PEleAuxHea)
      annotation (Line(points={{130,120},{130,120}}, color={0,0,127}));
    annotation (experiment(StopTime=3600, Interval=1),
      Diagram(coordinateSystem(extent={{-160,-160},{160,160}})),
      Icon(coordinateSystem(extent={{-160,-160},{160,160}})));
  end DistrictETSIntegration;
end DELETE;
