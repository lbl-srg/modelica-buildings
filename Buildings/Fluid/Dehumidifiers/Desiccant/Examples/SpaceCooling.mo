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
    TProEnt_max(displayUnit="K"),
    TProEnt_min(displayUnit="K"))
    "Performance record for the dehumidifier"
    annotation (Placement(transformation(extent={{-144,124},{-124,144}})));

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
    annotation (Placement(transformation(extent={{142,90},{162,110}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(
    G=10000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TOut
    "Outside temperature"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(
    Q_flow=QRooInt_flow)
    "Prescribed heat flow"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium = MediumA,
    per(etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.NotProvided,
        etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.NotProvided),
    nominalValuesDefineDefaultPressureCurve=true,
    m_flow_nominal=mA_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Supply air fan"
    annotation (Placement(transformation(extent={{110,0},{130,20}})));
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
        rotation=180,
        origin={50,4})));
  Buildings.Fluid.Sources.Outside out(
    redeclare package Medium = MediumA, nPorts=2)
    "Outdoor"
    annotation (Placement(transformation(extent={{-160,0},{-140,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T souWat(
    nPorts=1,
    redeclare package Medium = MediumW,
    use_m_flow_in=true,
    T=TWSup_nominal)
    "Source for water flow rate"
    annotation (Placement(transformation(extent={{40,-110},{60,-90}})));
  Buildings.Fluid.Sources.Boundary_pT sinWat(
    nPorts=1, redeclare package Medium = MediumW)
    "Sink for water circuit"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=TOut_nominal,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File)
    "Weather data reader"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Buildings.BoundaryConditions.WeatherData.Bus weaBus
    "Weather data bus"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}}),
        iconTransformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Pulse mAir_flow(
    amplitude=-mA_flow_nominal,
    width=0.5,
    period=87600,
    shift=0.24*87600,
    offset=mA_flow_nominal)
    "Fan air flow rate"
    annotation (Placement(transformation(extent={{80,50},{100,70}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemSupAir(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for supply air"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TRooSetPoi(
    k=TRooSet) "Room temperature set point"
    annotation (Placement(transformation(extent={{-120,-140},{-100,-120}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTemRoo
    "Room temperature sensor"
    annotation (Placement(transformation(extent={{140,120},{160,140}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemRetAir(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal)
    "Temperature sensor for return air"
    annotation (Placement(transformation(extent={{120,-60},{100,-40}})));
  Buildings.Controls.Continuous.LimPID conRoo(
    k=0.1,
    Ti=60,
    yMax=mW_flow_nominal,
    reverseActing=false)
    "Room controller"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));
  Buildings.Fluid.Dehumidifiers.Desiccant.SpeedControlled deh(
    redeclare package Medium = MediumA,
    per=per) "Dehumidifier"
    annotation (Placement(transformation(extent={{-80,8},{-60,28}})));
  Buildings.Fluid.Sources.Boundary_pT sou_Reg(
    redeclare package Medium = MediumA,
    p(displayUnit="Pa") = 101325,
    T(displayUnit="K") = 273.15 + 50,
    nPorts=1) "Regeneration air source"
    annotation (Placement(transformation(extent={{-20,50},{-40,70}})));
  Buildings.Fluid.Sources.Boundary_pT sin_Reg(
    redeclare package Medium = MediumA,
    p(displayUnit="Pa") = 101325 - 500,
    nPorts=1) "Regeneration air sink"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Fluid.Sensors.MassFractionTwoPort senX_w_DehOut(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    tau=10) "Humidity sensor of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-40,0},{-20,20}})));
  Buildings.Fluid.Sensors.MassFractionTwoPort senX_w_DehIn(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    tau=10) "Humidity sensor of the process air entering the dehumidifier"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    tau=10) annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.Continuous.LimPID conDeh(
    k=0.1,
    Ti=60,
    reverseActing=false)
    "Dehumidifier controller"
    annotation (Placement(transformation(extent={{-140,-90},{-120,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant phiSetPoi(
    k=0.4)
    "Mixed air humidity set point"
    annotation (Placement(transformation(extent={{-180,-90},{-160,-70}})));
equation
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{80,100},{142,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(preHea.port, vol.heatPort) annotation (Line(
      points={{40,130},{100,130},{100,100},{142,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(fan.port_b, vol.ports[1]) annotation (Line(
      points={{130,10},{151,10},{151,90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(souWat.ports[1], cooCoi.port_a1)   annotation (Line(
      points={{60,-100},{80,-100},{80,-2},{60,-2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(cooCoi.port_b1, sinWat.ports[1])    annotation (Line(
      points={{40,-2},{30,-2},{30,-30},{20,-30}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(weaDat.weaBus, out.weaBus) annotation (Line(
      points={{-160,100},{-140,100},{-140,80},{-180,80},{-180,10.2},{-160,10.2}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-160,100},{-110,100}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(weaBus.TDryBul, TOut.T) annotation (Line(
      points={{-109.95,100.05},{-66,100.05},{-66,100},{-22,100}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%first",
      index=-1,
      extent={{-6,3},{-6,3}}));
  connect(fan.m_flow_in, mAir_flow.y) annotation (Line(
      points={{120,22},{120,60},{102,60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooCoi.port_b2, senTemSupAir.port_a) annotation (Line(
      points={{60,10},{80,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senTemSupAir.port_b, fan.port_a) annotation (Line(
      points={{100,10},{110,10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TOut.port, theCon.port_a) annotation (Line(
      points={{0,100},{60,100}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.heatPort, senTemRoo.port) annotation (Line(
      points={{142,100},{120,100},{120,130},{140,130}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(vol.ports[2], senTemRetAir.port_a)
    annotation (Line(points={{153,90},{153,-50},{120,-50}}, color={0,127,255}));
  connect(conRoo.u_m, senTemRoo.T) annotation (Line(points={{-30,-142},{-30,-150},
          {180,-150},{180,130},{161,130}}, color={0,0,127}));
  connect(TRooSetPoi.y, conRoo.u_s)
    annotation (Line(points={{-98,-130},{-42,-130}},  color={0,0,127}));
  connect(conRoo.y, souWat.m_flow_in) annotation (Line(points={{-19,-130},{20,-130},
          {20,-92},{38,-92}},   color={0,0,127}));
  connect(sin_Reg.ports[1], deh.port_b2) annotation (Line(points={{-100,60},{-90,
          60},{-90,26},{-80,26}},    color={0,127,255}));
  connect(sou_Reg.ports[1], deh.port_a2) annotation (Line(points={{-40,60},{-50,
          60},{-50,26},{-60,26}}, color={0,127,255}));
  connect(senX_w_DehOut.port_a, deh.port_b1) annotation (Line(points={{-40,10},{
          -60,10}}, color={0,127,255}));
  connect(senX_w_DehIn.port_b, deh.port_a1) annotation (Line(points={{-100,10},{
          -80,10}}, color={0,127,255}));
  connect(senTemRetAir.port_b, out.ports[1]) annotation (Line(points={{100,-50},
          {-140,-50},{-140,9}},  color={0,127,255}));
  connect(senX_w_DehIn.port_a, out.ports[2]) annotation (Line(points={{-120,10},
          {-120,11},{-140,11}},   color={0,127,255}));
  connect(senX_w_DehOut.port_b, senRelHum.port_a)
    annotation (Line(points={{-20,10},{0,10}}, color={0,127,255}));
  connect(senRelHum.port_b, cooCoi.port_a2)
    annotation (Line(points={{20,10},{40,10}}, color={0,127,255}));
  connect(phiSetPoi.y, conDeh.u_s)
    annotation (Line(points={{-158,-80},{-142,-80}}, color={0,0,127}));
  connect(conDeh.u_m, senRelHum.phi) annotation (Line(points={{-130,-92},{-130,-100},
          {-10,-100},{-10,30},{10.1,30},{10.1,21}}, color={0,0,127}));
  connect(conDeh.y, deh.uSpe) annotation (Line(points={{-119,-80},{-90,-80},{-90,
          18},{-82,18}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
This block is identical to
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>,
except that the heat recovery device is replaced with a dehumidifier
that is modelled with
<a href=\"modelica://Buildings.Fluid.Dehumidifiers.Desiccant.SpeedControlled\">
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
First implementation based on
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-160},{200,
            160}})),
    __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Dehumidifiers/Desiccant/Examples/SpaceCooling.mos"
        "Simulate and plot"),
    experiment(StartTime=15552000, Tolerance=1e-6, StopTime=15638400),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end SpaceCooling;
