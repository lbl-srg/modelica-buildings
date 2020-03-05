within Buildings.Applications.DHC.EnergyTransferStations.Validation;
model HydraulicHeader "Validation of hydraulic header model"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water
    "Source side medium";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 1
    "Nominal mass flow rate";
  Fluid.Movers.FlowControlled_m_flow sou1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=273.15 + 40,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true) "Primary supply"
    annotation (Placement(transformation(extent={{-110,10},{-90,30}})));
  DHC.EnergyTransferStations.BaseClasses.HydraulicHeader hydHea(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    nPorts_a=3,
    nPorts_b=3)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-2})));
  Fluid.Movers.FlowControlled_m_flow sou2_1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=273.15 + 30,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true) "Primary supply"
    annotation (Placement(transformation(extent={{170,-30},{150,-10}})));
  Fluid.Sources.Boundary_pT bou1(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=2) "Boundary pressure" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,0})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp m1(
    height=1.1,
    duration=1000,
    startTime=0)
    "Primary flow"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T1(k=273.15 + 40)
    "Primary supply temperature"
    annotation (Placement(transformation(extent={{-180,-60},{-160,-40}})));
  Fluid.Sensors.TemperatureTwoPort senT2_1Sup(redeclare final package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Secondary supply temperature (sensed)" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,20})));
  Fluid.Sensors.TemperatureTwoPort senT1Sup(redeclare final package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Primary supply temperature (sensed)" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-40,20})));
  Fluid.Sensors.TemperatureTwoPort senT1Ret(redeclare final package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Primary return temperature (sensed)" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-40,-20})));
  Fluid.Sensors.TemperatureTwoPort senT2_1Ret(redeclare final package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Secondary return temperature (sensed)" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,-20})));
  Fluid.Sensors.MassFlowRate senMasFlo1(redeclare final package Medium = Medium)
    "Primary mass flow rate (sensed)"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Fluid.Sensors.MassFlowRate senMasFlo2_1(redeclare final package Medium =
        Medium) "Secondary mass flow rate (sensed)"
    annotation (Placement(transformation(extent={{110,10},{130,30}})));
  Fluid.MixingVolumes.MixingVolume vol2_1(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 30,
    final prescribedHeatFlowRate=true,
    redeclare final package Medium = Medium,
    V=1,
    final mSenFac=1,
    final m_flow_nominal=m_flow_nominal,
    nPorts=2) "Volume for fluid stream"
    annotation (Placement(transformation(extent={{189,-20},{209,-40}})));
  Fluid.HeatExchangers.HeaterCooler_u coo(
    redeclare final package Medium = Medium,
    dp_nominal=1,
    m_flow_nominal=m_flow_nominal,
    Q_flow_nominal=-1E5) "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{80,-30},{60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T2_1Ret(k=273.15 + 30)
    "First secondary return temperature"
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTChiWat1(
    k=0.1,
    Ti=10,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMin=0,
    reverseAction=true)
                 "PI controller for chilled water supply"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Ramp m2_1(
    height=0.5,
    duration=1000,
    offset=0.5,
    startTime=2000) "First secondary flow signal"
    annotation (Placement(transformation(extent={{200,50},{180,70}})));
  Fluid.Movers.FlowControlled_m_flow sou3(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T_start=273.15 + 30,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true) "Primary supply"
    annotation (Placement(transformation(extent={{170,-170},{150,-150}})));
  Fluid.Sensors.TemperatureTwoPort senT2_2Sup(redeclare final package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Secondary supply temperature (sensed)" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,-120})));
  Fluid.Sensors.TemperatureTwoPort senT2_2Ret(redeclare final package Medium =
        Medium, m_flow_nominal=m_flow_nominal)
    "Secondary return temperature (sensed)" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={40,-160})));
  Fluid.Sensors.MassFlowRate senMasFlo2_2(redeclare final package Medium =
        Medium) "Secondary mass flow rate (sensed)"
    annotation (Placement(transformation(extent={{110,-130},{130,-110}})));
  Fluid.MixingVolumes.MixingVolume vol2(
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 30,
    final prescribedHeatFlowRate=true,
    redeclare final package Medium = Medium,
    V=1,
    final mSenFac=1,
    final m_flow_nominal=m_flow_nominal,
    nPorts=2) "Volume for fluid stream"
    annotation (Placement(transformation(extent={{189,-160},{209,-180}})));
  Fluid.HeatExchangers.HeaterCooler_u coo1(
    redeclare final package Medium = Medium,
    dp_nominal=1,
    m_flow_nominal=m_flow_nominal,
    Q_flow_nominal=-1E5) "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{80,-170},{60,-150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T2_2Ret(k=273.15 + 35)
    "Second secondary return temperature"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conTChiWat2(
    k=0.1,
    Ti=10,
    yMax=1,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    yMin=0,
    reverseAction=true)
                 "PI controller for chilled water supply"
    annotation (Placement(transformation(extent={{70,-90},{90,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant m2_2(k=0.5)
    "Second secondary mass flow rate signal"
    annotation (Placement(transformation(extent={{200,-90},{180,-70}})));
equation
  connect(m1.y, sou1.m_flow_in) annotation (Line(points={{-158,60},{-100,60},{
          -100,32}},       color={0,0,127}));
  connect(senMasFlo1.port_b, senT1Sup.port_a)
    annotation (Line(points={{-60,20},{-50,20}}, color={0,127,255}));
  connect(senT2_1Sup.port_b, senMasFlo2_1.port_a)
    annotation (Line(points={{50,20},{110,20}}, color={0,127,255}));
  connect(sou1.port_b, senMasFlo1.port_a)
    annotation (Line(points={{-90,20},{-80,20}}, color={0,127,255}));
  connect(coo.port_b, senT2_1Ret.port_a)
    annotation (Line(points={{60,-20},{50,-20}}, color={0,127,255}));
  connect(T2_1Ret.y, conTChiWat1.u_s) annotation (Line(points={{62,60},{54,60},{
          54,64},{56,64},{56,60},{68,60}}, color={0,0,127}));
  connect(conTChiWat1.y, coo.u) annotation (Line(points={{92,60},{100,60},{100,
          -14},{82,-14}}, color={0,0,127}));
  connect(senT2_1Ret.T, conTChiWat1.u_m)
    annotation (Line(points={{40,-9},{40,0},{80,0},{80,48}}, color={0,0,127}));
  connect(vol2_1.ports[1], sou2_1.port_a)
    annotation (Line(points={{197,-20},{170,-20}}, color={0,127,255}));
  connect(senMasFlo2_1.port_b, vol2_1.ports[2])
    annotation (Line(points={{130,20},{201,20},{201,-20}}, color={0,127,255}));
  connect(m2_1.y, sou2_1.m_flow_in)
    annotation (Line(points={{178,60},{160,60},{160,-8}}, color={0,0,127}));
  connect(bou1.ports[1], sou1.port_a) annotation (Line(points={{-120,2},{-120,20},
          {-110,20}},     color={0,127,255}));
  connect(T1.y, bou1.T_in) annotation (Line(points={{-158,-50},{-152,-50},{-152,
          4},{-142,4}}, color={0,0,127}));
  connect(senT1Sup.port_b, hydHea.ports_a[1]) annotation (Line(points={{-30,20},
          {0,20},{0,1.33333},{4.44089e-16,1.33333}},
                                 color={0,127,255}));
  connect(hydHea.ports_b[1], senT1Ret.port_a) annotation (Line(points={{
          -1.77636e-15,-10.6667},{0,-10.6667},{0,-20},{-30,-20}},
                                  color={0,127,255}));
  connect(senT2_1Ret.port_b, hydHea.ports_b[2]) annotation (Line(points={{30,-20},
          {16,-20},{16,-6},{0,-6},{0,-8},{-1.77636e-15,-8}},
                                                 color={0,127,255}));
  connect(hydHea.ports_a[2], senT2_1Sup.port_a) annotation (Line(points={{
          1.77636e-15,4},{20,4},{20,20},{30,20}},
                                      color={0,127,255}));
  connect(senT2_2Sup.port_b, senMasFlo2_2.port_a)
    annotation (Line(points={{50,-120},{110,-120}}, color={0,127,255}));
  connect(coo1.port_b, senT2_2Ret.port_a)
    annotation (Line(points={{60,-160},{50,-160}}, color={0,127,255}));
  connect(T2_2Ret.y, conTChiWat2.u_s) annotation (Line(points={{62,-80},{58,-80},
          {58,-76},{60,-76},{60,-80},{68,-80}}, color={0,0,127}));
  connect(conTChiWat2.y, coo1.u) annotation (Line(points={{92,-80},{100,-80},{
          100,-154},{82,-154}}, color={0,0,127}));
  connect(senT2_2Ret.T, conTChiWat2.u_m) annotation (Line(points={{40,-149},{40,
          -140},{80,-140},{80,-92}}, color={0,0,127}));
  connect(vol2.ports[1],sou3. port_a)
    annotation (Line(points={{197,-160},{170,-160}},
                                                   color={0,127,255}));
  connect(senMasFlo2_2.port_b, vol2.ports[2]) annotation (Line(points={{130,
          -120},{201,-120},{201,-160}},
                                  color={0,127,255}));
  connect(hydHea.ports_a[3], senT2_2Sup.port_a) annotation (Line(points={{
          1.77636e-15,6.66667},{0,6.66667},{0,0},{20,0},{20,-120},{30,-120}},
                                          color={0,127,255}));
  connect(hydHea.ports_b[3], senT2_2Ret.port_b) annotation (Line(points={{
          -4.44089e-16,-5.33333},{-4.44089e-16,-6},{0,-6},{0,-10},{12,-10},{12,
          -160},{30,-160}},                   color={0,127,255}));
  connect(sou3.port_b, coo1.port_a)
    annotation (Line(points={{150,-160},{80,-160}}, color={0,127,255}));
  connect(senT1Ret.port_b, bou1.ports[2]) annotation (Line(points={{-50,-20},{-120,
          -20},{-120,-2}}, color={0,127,255}));
  connect(sou2_1.port_b, coo.port_a)
    annotation (Line(points={{150,-20},{80,-20}}, color={0,127,255}));
  connect(m2_2.y, sou3.m_flow_in) annotation (Line(points={{178,-80},{160,-80},{
          160,-148}}, color={0,0,127}));
  annotation (
  Documentation(info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HydraulicHeader\">
Buildings.Applications.DHC.EnergyTransferStations.BaseClasses.HydraulicHeader</a>
in a configuration where the model is used as a decoupler between: 
</p>
<ol>
<li>
a primary circuit which flow rate varies from zero to 1.1 times the
sum of all secondary initial flow rates,
</li>
<li>
a first secondary circuit which flow rate varies from 0.5 to 1 times the
primary flow rate,
</li>
<li>
a second secondary circuit which flow rate is constant, equal to 0.5 times the
primary flow rate.
</li>
</ol>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{
            240,120}})),
   experiment(
      StopTime=5000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
    __Dymola_Commands(file="Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Validation/HydraulicHeader.mos"
        "Simulate and plot"));
end HydraulicHeader;
