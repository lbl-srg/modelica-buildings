within Buildings.Fluid.Humidifiers.Validation;
model DXDehumidifierOpenLoop "Validation model for DX dehumidifier"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.13545
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.Time tStepAve = 3600
    "Time-step used to average out Modelica results for comparison with EPlus results";

  package Medium = Buildings.Media.Air
    "Fluid medium";

  parameter Buildings.Fluid.Humidifiers.Examples.Data.DXDehumidifier per
    "Zone air DX dehumidifier curve"
    annotation (Placement(transformation(extent={{0,66},{20,86}})));

  Buildings.Fluid.DXSystems.Heating.AirSource.Validation.BaseClasses.PLRToPulse plrToPul(
    final tPer=3600)
    "Convert PLR signal to on-off signal"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(
    redeclare package Medium = Medium,
    final use_Xi_in=true,
    final use_m_flow_in=true,
    final use_T_in=true,
    nPorts=1)
    "Mass flow source for coil inlet air"
    annotation (Placement(transformation(extent={{-76,-28},{-56,-8}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    final p(displayUnit="Pa") = 101325,
    final T=294.15,
    nPorts=1)       "Sink"
    annotation (Placement(transformation(extent={{66,-28},{46,-8}})));
  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirIn
    "Convert humidity ratio per kg dry air to humidity ratio per kg total air for coil inlet air"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));
  Buildings.Utilities.IO.BCVTB.From_degC TIn_K "Converts degC to K"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaFanEna
    "Convert fan enable signal to real value"
    annotation (Placement(transformation(extent={{-160,-20},{-140,0}})));

  Buildings.Fluid.Humidifiers.DXDehumidifier dxDeh(
    redeclare package Medium = Medium,
    final VWat_flow_nominal=5.805556e-7,
    final addPowerToMedium=false,
    final mAir_flow_nominal=m_flow_nominal,
    final dp_nominal=100,
    final eneFac_nominal=3.412,
    final per=per,
    senTIn(T_start=302.05),
    deHum(T_start=302.05, X_start={0.0110173,0.9889827}))
    "DX dehumidifier"
    annotation (Placement(transformation(extent={{-34,-28},{-14,-8}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=m_flow_nominal)
    "Gain factor"
    annotation (Placement(transformation(extent={{-120,-20},{-100,0}})));

  Modelica.Blocks.Sources.RealExpression realExpression1(final y=dxDeh.port_a.m_flow)
    "DX dehumidifier air mass flow rate (Modelica)"
    annotation (Placement(transformation(extent={{66,60},{86,80}})));

  Modelica.Blocks.Math.Mean m_flowFan(
    final f=1/tStepAve)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));

  Modelica.Blocks.Math.Mean m_flowFanEP(
    final f=1/tStepAve)
    "Average out EnergyPlus results over time"
    annotation (Placement(transformation(extent={{180,60},{200,80}})));

  Modelica.Blocks.Sources.RealExpression realExpression7(
    final y=datRea.y[6]) "DX dehumidifier air mass flow rate (EnergyPlus)"
    annotation (Placement(transformation(extent={{144,60},{164,80}})));

  Modelica.Blocks.Sources.RealExpression realExpression2(
    final y=-dxDeh.deHum.mWat_flow)
    "Water removal mass flow rate (Modelica)"
    annotation (Placement(transformation(extent={{66,26},{86,46}})));

  Modelica.Blocks.Math.Mean mWatMod(
    final f=1/tStepAve)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{100,26},{120,46}})));

  Modelica.Blocks.Math.Mean mWatEP(
    final f=1/tStepAve)
    "Average out EnergyPlus results over time"
    annotation (Placement(transformation(extent={{180,26},{200,46}})));

  Modelica.Blocks.Sources.RealExpression realExpression8(
    final y=datRea.y[4])
    "Water removal mass flow rate (EnergyPlus)"
    annotation (Placement(transformation(extent={{144,26},{164,46}})));

  Modelica.Blocks.Sources.RealExpression realExpression3(
    final y=dxDeh.QHea.y)
    "Air heating rate (Modelica)"
    annotation (Placement(transformation(extent={{66,-10},{86,10}})));

  Modelica.Blocks.Math.Mean QHeaMod(
    final f=1/tStepAve)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Modelica.Blocks.Math.Mean QHeaEP(
    final f=1/tStepAve)
    "Average out EnergyPlus results over time"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));

  Modelica.Blocks.Sources.RealExpression realExpression9(
    final y=datRea.y[3])
    "Air heating rate (EnergyPlus)"
    annotation (Placement(transformation(extent={{144,-10},{164,10}})));

  Modelica.Blocks.Sources.RealExpression realExpression4(
    final y=dxDeh.P)
    "Air heating rate (Modelica)"
    annotation (Placement(transformation(extent={{66,-40},{86,-20}})));

  Modelica.Blocks.Math.Mean PMod(
    final f=1/tStepAve)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{100,-40},{120,-20}})));

  Modelica.Blocks.Math.Mean PEP(
    final f=1/tStepAve)
    "Average out EnergyPlus results over time"
    annotation (Placement(transformation(extent={{180,-40},{200,-20}})));

  Modelica.Blocks.Sources.RealExpression realExpression10(
    final y=datRea.y[5])
    "DX dehumidifier power rate (EnergyPlus)"
    annotation (Placement(transformation(extent={{144,-40},{164,-20}})));

  Modelica.Blocks.Sources.RealExpression realExpression5(final y=senTem.T)
    "DX dehumidifier outlet temperature (Modelica)"
    annotation (Placement(transformation(extent={{66,-70},{86,-50}})));

  Modelica.Blocks.Math.Mean TOutAirMod(
    final f=1/tStepAve)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

  Modelica.Blocks.Math.Mean TOutAirEP(
    final f=1/tStepAve)
    "Average out EnergyPlus results over time"
    annotation (Placement(transformation(extent={{180,-70},{200,-50}})));

  Modelica.Blocks.Sources.RealExpression realExpression11(final y=datRea.y[14])
    "DX dehumidifier outlet temperature (EnergyPlus)"
    annotation (Placement(transformation(extent={{144,-70},{164,-50}})));

  Modelica.Blocks.Sources.RealExpression realExpression6(final y=senMasFra.X)
    "DX dehumidifier outlet air humidity ratio (Modelica)"
    annotation (Placement(transformation(extent={{66,-100},{86,-80}})));

  Modelica.Blocks.Math.Mean XOutAirMod(final f=1/tStepAve)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));

  Modelica.Blocks.Math.Mean XOutAirEP(final f=1/tStepAve)
    "Average out EnergyPlus results over time"
    annotation (Placement(transformation(extent={{180,-100},{200,-80}})));

  Modelica.Blocks.Sources.RealExpression realExpression12(final y=datRea.y[13])
    "DX dehumidifier outlet air humidity ratio (EnergyPlus)"
    annotation (Placement(transformation(extent={{126,-100},{146,-80}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final tableOnFile=true,
    final fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/Humidifiers/DXDehumidifierOpenLoop/DXDehumidifier.dat"),
    final columns=2:15,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    final shiftTime(displayUnit="d"))
    "Reader for energy plus reference results"
    annotation (Placement(transformation(extent={{-160,60},{-140,80}})));

  Sensors.MassFractionTwoPort senMasFra(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    X_start=0.0110173)
    annotation (Placement(transformation(extent={{-10,-28},{10,-8}})));
  Sensors.TemperatureTwoPort senTem(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    T_start=301.44)
    annotation (Placement(transformation(extent={{18,-28},{38,-8}})));
  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirIn1
    "Convert humidity ratio per kg dry air to humidity ratio per kg total air for coil inlet air"
    annotation (Placement(transformation(extent={{152,-100},{172,-80}})));
  Sensors.MassFractionTwoPort senMasFra_in(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    X_start=0.0110173)
    annotation (Placement(transformation(extent={{-58,-62},{-38,-42}})));
  Sensors.RelativeHumidityTwoPort                 senRelHum(redeclare package
      Medium = Medium, final m_flow_nominal=m_flow_nominal)
    "Inlet air relative humidity sensor"
    annotation (Placement(transformation(extent={{-24,-62},{-4,-42}})));
equation
  connect(realExpression1.y, m_flowFan.u)
    annotation (Line(points={{87,70},{98,70}}, color={0,0,127}));
  connect(realExpression7.y, m_flowFanEP.u)
    annotation (Line(points={{165,70},{178,70}}, color={0,0,127}));
  connect(realExpression2.y, mWatMod.u)
    annotation (Line(points={{87,36},{98,36}},  color={0,0,127}));
  connect(realExpression8.y, mWatEP.u)
    annotation (Line(points={{165,36},{178,36}}, color={0,0,127}));
  connect(realExpression3.y, QHeaMod.u)
    annotation (Line(points={{87,0},{98,0}}, color={0,0,127}));
  connect(realExpression9.y, QHeaEP.u)
    annotation (Line(points={{165,0},{178,0}}, color={0,0,127}));
  connect(realExpression4.y, PMod.u)
    annotation (Line(points={{87,-30},{98,-30}},  color={0,0,127}));
  connect(realExpression10.y, PEP.u)
    annotation (Line(points={{165,-30},{178,-30}}, color={0,0,127}));
  connect(realExpression5.y,TOutAirMod. u)
    annotation (Line(points={{87,-60},{98,-60}}, color={0,0,127}));
  connect(realExpression11.y,TOutAirEP. u)
    annotation (Line(points={{165,-60},{178,-60}}, color={0,0,127}));

  connect(plrToPul.yEna, dxDeh.uEna) annotation (Line(points={{-98,70},{-50,70},
          {-50,-22},{-35,-22}}, color={255,0,255}));
  connect(toTotAirIn.XiTotalAir, boundary.Xi_in[1]) annotation (Line(points={{-99,-50},
          {-90,-50},{-90,-22},{-78,-22}},      color={0,0,127}));
  connect(TIn_K.Kelvin, boundary.T_in) annotation (Line(points={{-99,19.8},{-90,
          19.8},{-90,-14},{-78,-14}}, color={0,0,127}));
  connect(booToReaFanEna.y, gai.u)
    annotation (Line(points={{-138,-10},{-122,-10}}, color={0,0,127}));
  connect(plrToPul.yEna, booToReaFanEna.u) annotation (Line(points={{-98,70},{-80,
          70},{-80,40},{-170,40},{-170,-10},{-162,-10}}, color={255,0,255}));
  connect(datRea.y[8], plrToPul.uPLR)
    annotation (Line(points={{-139,70},{-122,70}}, color={0,0,127}));
  connect(datRea.y[11], TIn_K.Celsius) annotation (Line(points={{-139,70},{-130,
          70},{-130,19.6},{-122,19.6}}, color={0,0,127}));
  connect(datRea.y[10], toTotAirIn.XiDry) annotation (Line(points={{-139,70},{
          -130,70},{-130,-50},{-121,-50}},
                                      color={0,0,127}));
  connect(gai.y, boundary.m_flow_in)
    annotation (Line(points={{-98,-10},{-78,-10}}, color={0,0,127}));
  connect(senMasFra.port_a, dxDeh.port_b)
    annotation (Line(points={{-10,-18},{-14,-18}}, color={0,127,255}));
  connect(senMasFra.port_b, senTem.port_a)
    annotation (Line(points={{10,-18},{18,-18}}, color={0,127,255}));
  connect(senTem.port_b, sin.ports[1])
    annotation (Line(points={{38,-18},{46,-18}}, color={0,127,255}));
  connect(realExpression6.y, XOutAirMod.u)
    annotation (Line(points={{87,-90},{98,-90}}, color={0,0,127}));
  connect(XOutAirEP.u, toTotAirIn1.XiTotalAir)
    annotation (Line(points={{178,-90},{173,-90}}, color={0,0,127}));
  connect(toTotAirIn1.XiDry, realExpression12.y)
    annotation (Line(points={{151,-90},{147,-90}}, color={0,0,127}));
  connect(senMasFra_in.port_a, boundary.ports[1]) annotation (Line(points={{-58,
          -52},{-58,-18},{-56,-18}}, color={0,127,255}));
  connect(senMasFra_in.port_b, senRelHum.port_a)
    annotation (Line(points={{-38,-52},{-24,-52}}, color={0,127,255}));
  connect(senRelHum.port_b, dxDeh.port_a) annotation (Line(points={{-4,-52},{12,
          -52},{12,-38},{-44,-38},{-44,-18},{-34,-18}}, color={0,127,255}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-120},{220,100}})),
experiment(
      StartTime=12960000,
      StopTime=15120000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
__Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/Validation/Debug.mos"
        "Simulate and Plot"),
Documentation(info="<html>
<p>
This is a validation model for the zone air DX dehumidifier model
<a href=\"modelica://Buildings.Fluid.Humidifiers.DXDehumidifier\">
Buildings.Fluid.Humidifiers.DXDehumidifier</a> with an 
on-off controller to maintain the zone relative humidity. It consists of: 
</p>
<ul>
<li>
an instance of the zone air DX dehumidifier model <code>dxDeh</code>. 
</li>
<li>
thermal zone model <code>zon</code> of class 
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone\">
Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone</a>. 
</li>
<li>
on-off controller <code>hysPhi</code>. 
</li>
<li>
zone air relative humidity setpoint controller <code>phiSet</code>. 
</li>
</ul>
<p>
The control loop in the simulation model operates <code>dxDeh</code> to 
regulate the relative humidity in <code>zon</code> at the setpoint generated 
by <code>phiSet</code>.
</p>
<p>
The generated plots show that <code>dxDeh</code> removes an amount of water 
that is similar to the reference EnergyPlus results, while consuming a similar 
amount of power. There is a mismatch in the zone temperature the longer the
dehumidifier operates, which may be attributed to how the EnergyPlus component 
operates at part-load averaged over a timestep, whereas the Modelica model 
cycles between a disabled state and full capacity.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 20, 2023, by Xing Lu and Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end DXDehumidifierOpenLoop;
