within Buildings.Fluid.Dehumidifiers.Desiccant.Examples;
model SpaceCooling "Space cooling system"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air "Medium for air";
  replaceable package MediumW = Buildings.Media.Water "Medium for water";

  parameter Modelica.Units.SI.Volume V=6*10*3 "Room volume";
  // Heat recovery effectiveness
  parameter Buildings.Fluid.Dehumidifiers.Desiccant.Data.EnergyPlus per(
    have_varSpe=true,
    uSpe_min=0.1,
    mPro_flow_nominal=mA_flow_nominal,
    mReg_flow_nominal=mA_flow_nominal,
    dpPro_nominal=200,
    dpReg_nominal=200,
    TRegEnt_nominal(displayUnit="K"),
    TProEnt_max(displayUnit="K"),
    TProEnt_min(displayUnit="K"))
    "Performance record for the dehumidifier"
    annotation (Placement(transformation(extent={{-144,74},{-124,94}})));

/////////////////////////////////////////////////////////
  // Design air conditions
  parameter Modelica.Units.SI.Temperature TASup_nominal=291.15
    "Nominal air temperature supplied to room";
  parameter Modelica.Units.SI.DimensionlessRatio wASup_nominal=0.012
    "Nominal air humidity ratio supplied to room [kg/kg] assuming 90% relative humidity";
  parameter Modelica.Units.SI.Temperature TRooSet=297.15
    "Nominal room air temperature";
  parameter Modelica.Units.SI.Temperature TMixSet=298.15
    "Nominal mixed air temperature";
  parameter Modelica.Units.SI.Temperature TOut_nominal=303.15
    "Design outlet air temperature";
  parameter Modelica.Units.SI.Temperature THeaRecLvg=TOut_nominal - 0.8
      *(TOut_nominal - TRooSet) "Air temperature leaving the heat recovery";
  parameter Modelica.Units.SI.DimensionlessRatio wHeaRecLvg=0.0135
    "Air humidity ratio leaving the heat recovery [kg/kg]";

/////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=1000
    "Internal heat gains of the room";
  parameter Modelica.Units.SI.HeatFlowRate QRooC_flow_nominal=
    -QRooInt_flow -10E3/30*(TOut_nominal - TRooSet)
    "Nominal cooling load of the room";
  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=
    1.3*QRooC_flow_nominal/1006/(TASup_nominal - TRooSet)
    "Nominal air mass flow rate, increased by factor 1.3 to allow for recovery after temperature setback";
  parameter Modelica.Units.SI.TemperatureDifference dTFan=2
    "Estimated temperature raise across fan that needs to be made up by the cooling coil";
  parameter Modelica.Units.SI.HeatFlowRate QCoiC_flow_nominal=mA_flow_nominal*(
      TASup_nominal - THeaRecLvg - dTFan)*1006 + mA_flow_nominal*(wASup_nominal
       - wHeaRecLvg)*2458.3e3
    "Cooling load of coil, taking into account outside air sensible and latent heat removal";

/////////////////////////////////////////////////////////
  // Water temperatures and mass flow rates
  parameter Modelica.Units.SI.Temperature TWSup_nominal=285.15
    "Water supply temperature";
  parameter Modelica.Units.SI.Temperature TWRet_nominal=289.15
    "Water return temperature";
  parameter Modelica.Units.SI.MassFlowRate mW_flow_nominal=
    -QCoiC_flow_nominal/(TWRet_nominal - TWSup_nominal)/4200
    "Nominal water mass flow rate";

  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    V=V,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    mSenFac=3)
    "Indoor room"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(
    G=10000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut
    "Outside temperature"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(
    Q_flow=QRooInt_flow)
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumA,
    per(etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.NotProvided,
        etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.NotProvided),
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mA_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Supply air fan"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Buildings.Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(
    redeclare package Medium1 = MediumW,
    redeclare package Medium2 = MediumA,
    m1_flow_nominal=mW_flow_nominal,
    m2_flow_nominal=mA_flow_nominal,
    dp1_nominal=6000,
    dp2_nominal=200,
    use_Q_flow_nominal=true,
    Q_flow_nominal=QCoiC_flow_nominal,
    T_a1_nominal=TWSup_nominal,
    T_a2_nominal=THeaRecLvg,
    w_a2_nominal=wHeaRecLvg,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Cooling coil"
   annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=180, origin={0,-26})));
  Buildings.Fluid.Sources.Outside out(
    redeclare package Medium = MediumA, nPorts=2)
    "Outdoor"
    annotation (Placement(transformation(extent={{-160,-30},{-140,-10}})));
  Buildings.Fluid.Sources.MassFlowSource_T souWat(
    nPorts=1,
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    T=TWSup_nominal)
    "Source for water flow rate"
    annotation (Placement(transformation(extent={{-20,-110},{0,-90}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    nPorts=1, redeclare package Medium = MediumW)
    "Sink for water circuit"
    annotation (Placement(transformation(extent={{-80,-76},{-60,-56}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=TOut_nominal,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-180,40},{-160,60}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse mAir_flow(
    amplitude=-mA_flow_nominal,
    width=0.5,
    period=87600,
    shift=0.24*87600,
    offset=mA_flow_nominal)
    "Fan air flow rate"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{16,-26},{28,-14}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRooSetPoi(
    k=TRooSet) "Room temperature set point"
    annotation (Placement(transformation(extent={{-162,-132},{-142,-112}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRoo
    "Room temperature sensor"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemRetAir(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for return air"
    annotation (Placement(transformation(extent={{54,-52},{42,-40}})));
  Buildings.Controls.Continuous.LimPID conRoo(
    k=0.1,
    Ti=60,
    yMax=mW_flow_nominal,
    reverseActing=false)
    "Room controller"
    annotation (Placement(transformation(extent={{-90,-132},{-70,-112}})));
  Buildings.Fluid.Dehumidifiers.Desiccant.SpeedControlled deh(
    redeclare package Medium = MediumA,
    per=per) "Dehumidifier"
    annotation (Placement(transformation(extent={{-98,-18},{-78,2}})));
  Buildings.Fluid.Sources.Boundary_pT sou_Reg(
    redeclare package Medium = MediumA,
    p(displayUnit="Pa") = 101325,
    T(displayUnit="K") = 273.15 + 50,
    nPorts=1) "Regeneration air source"
    annotation (Placement(transformation(extent={{-40,10},{-60,30}})));
  Buildings.Fluid.Sources.Boundary_pT sin_Reg(
    redeclare package Medium = MediumA,
    p(displayUnit="Pa") = 101325 - 500,
    nPorts=1) "Regeneration air sink"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Fluid.Sensors.MassFractionTwoPort senX_w_DehOut(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    tau=10) "Humidity sensor of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-70,-30},{-50,-10}})));
  Buildings.Fluid.Sensors.MassFractionTwoPort senX_w_DehIn(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    tau=10) "Humidity sensor of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-130,-30},{-110,-10}})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    tau=10) annotation (Placement(transformation(extent={{-38,-30},{-18,-10}})));
  Buildings.Controls.Continuous.LimPID conDeh(
    k=0.1,
    Ti=60,
    reverseActing=false)
    "Dehumidifier controller"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant phiSetPoi(
    k=0.4)
    "Mixed air humidity set point"
    annotation (Placement(transformation(extent={{-162,-90},{-142,-70}})));
equation
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{40,50},{50,50},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{40,80},{50,80},{50,30},{60,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fan.port_b, vol.ports[1]) annotation (Line(
      points={{60,-20},{69,-20},{69,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(souWat.ports[1], cooCoi.port_a1)   annotation (Line(
      points={{0,-100},{30,-100},{30,-32},{10,-32}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooCoi.port_b1, sinWat.ports[1])    annotation (Line(
      points={{-10,-32},{-14,-32},{-14,-66},{-60,-66}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, out.weaBus) annotation (Line(
      points={{-160,50},{-154,50},{-154,18},{-178,18},{-178,-19.8},{-160,-19.8}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-160,50},{-110,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.TDryBul, TOut.T) annotation (Line(
      points={{-109.95,50.05},{-66,50.05},{-66,50},{-22,50}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(fan.m_flow_in, mAir_flow.y) annotation (Line(
      points={{50,-8},{50,10},{22,10}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooCoi.port_b2, senTemSupAir.port_a) annotation (Line(
      points={{10,-20},{16,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSupAir.port_b, fan.port_a) annotation (Line(
      points={{28,-20},{40,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port, theCon.port_a) annotation (Line(
      points={{5.55112e-16,50},{20,50}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.heatPort, senTemRoo.port) annotation (Line(
      points={{60,30},{50,30},{50,80},{70,80}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.ports[2], senTemRetAir.port_a)
    annotation (Line(points={{71,20},{71,-46},{54,-46}}, color={0,127,255}));
  connect(conRoo.u_m, senTemRoo.T) annotation (Line(points={{-80,-134},{-80,-142},
          {98,-142},{98,80},{91,80}}, color={0,0,127}));
  connect(TRooSetPoi.y, conRoo.u_s)
    annotation (Line(points={{-140,-122},{-92,-122}}, color={0,0,127}));
  connect(conRoo.y, souWat.m_flow_in) annotation (Line(points={{-69,-122},{-30,-122},
          {-30,-92},{-22,-92}}, color={0,0,127}));
  connect(sin_Reg.ports[1], deh.port_b2) annotation (Line(points={{-120,20},{
          -108,20},{-108,0},{-98,0}},color={0,127,255}));
  connect(sou_Reg.ports[1], deh.port_a2) annotation (Line(points={{-60,20},{-70,
          20},{-70,0},{-78,0}}, color={0,127,255}));
  connect(senX_w_DehOut.port_a, deh.port_b1) annotation (Line(points={{-70,-20},
          {-72,-20},{-72,-16},{-78,-16}},
                                color={0,127,255}));
  connect(senX_w_DehIn.port_b, deh.port_a1) annotation (Line(points={{-110,-20},
          {-106,-20},{-106,-16},{-98,-16}},  color={0,127,255}));
  connect(senTemRetAir.port_b, out.ports[1]) annotation (Line(points={{42,-46},
          {-140,-46},{-140,-21}},color={0,127,255}));
  connect(senX_w_DehIn.port_a, out.ports[2]) annotation (Line(points={{-130,-20},
          {-130,-19},{-140,-19}}, color={0,127,255}));
  connect(senX_w_DehOut.port_b, senRelHum.port_a)
    annotation (Line(points={{-50,-20},{-38,-20}}, color={0,127,255}));
  connect(senRelHum.port_b, cooCoi.port_a2)
    annotation (Line(points={{-18,-20},{-10,-20}}, color={0,127,255}));
  connect(phiSetPoi.y, conDeh.u_s)
    annotation (Line(points={{-140,-80},{-122,-80}}, color={0,0,127}));
  connect(conDeh.u_m, senRelHum.phi) annotation (Line(points={{-110,-92},{-110,-102},
          {-44,-102},{-44,0},{-27.9,0},{-27.9,-9}}, color={0,0,127}));
  connect(conDeh.y, deh.uSpe) annotation (Line(points={{-99,-80},{-86,-80},{-86,
          -40},{-100,-40},{-100,-8}},           color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This block is identical to
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>,
except that the heat recovery device is replaced with a dehumidifier
that is modelled with <a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.SpeedControlled\">
Buildings.Fluid.Dehumidifiers.Desiccant.SpeedControlled</a>.
</p>
<p>
The major input signals for the dehumidifier are configured as follows:
</p>
<ul>
<li>
The mixed air humidity ratio setpoint <i>phiSetPoi</i> is constant at 0.4.
</li>
<li>
The supply air flow rate <i>mAir_flow</i> changes from <i>0</i> to <i>0.646</i> at around 5:00
and from <i>0.646</i> to <i>0</i> at around 17:00.
</li>
<li>
The minimum speed ratio of the dehumidifier is 0.1.
</li>
</ul>
<p>
The expected output is:
</p>
<ul>
<li>
The mixed air humidity ratio <code>senRelHum.phi</code> is close to 0.4.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
May 3, 2024, by Sen Huang:<br/>
First implementation based on <a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-180,-160},{120,
            100}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Dehumidifiers/Desiccant/Examples/SpaceCooling.mos"
        "Simulate and plot"),
    experiment(StartTime=15552000, Tolerance=1e-6, StopTime=15638400));
end SpaceCooling;
