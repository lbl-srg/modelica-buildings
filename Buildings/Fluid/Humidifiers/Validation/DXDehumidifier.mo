within Buildings.Fluid.Humidifiers.Validation;
model DXDehumidifier
  "Validation model for DX dehumidifier"
  extends Modelica.Icons.Example;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.13545
    "Nominal mass flow rate";

  parameter Modelica.Units.SI.Time tStepAve = 3600
    "Time-step used to average out Modelica results for comparison with EPlus 
    results.";

  package Medium = Buildings.Media.Air
    "Fluid medium";

  Buildings.Fluid.Humidifiers.DXDehumidifier dxDeh(
    redeclare package Medium = Medium,
    final VWat_flow_nominal=5.805556e-7,
    final addPowerToMedium=true,
    final mAir_flow_nominal=m_flow_nominal,
    final dp_nominal=100,
    final eneFac_nominal=3.412,
    final per=per)
    "DX dehumidifier"
    annotation (Placement(transformation(extent={{30,-42},{50,-22}})));

  inner ThermalZones.EnergyPlus_9_6_0.Building building(
    idfName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/Humidifiers/DXDehumidifier/DXDehumidifier.idf"),
    epwName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    weaName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Building instance for thermal zone"
    annotation (Placement(transformation(extent={{-108,60},{-88,80}})));

  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zon(
    zoneName="West Zone",
    redeclare package Medium = Medium,
    T_start=301.33,
    X_start={0.01093901449,1 - 0.01093901449},
    nPorts=2)
    "Thermal zone model"
    annotation (Placement(transformation(extent={{14,20},{-26,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[3](
    final k=fill(0,3))
    "Zero signal for internal thermal loads"
    annotation (Placement(transformation(extent={{50,60},{30,80}})));

  Modelica.Blocks.Sources.CombiTimeTable datRea(
    final tableOnFile=true,
    final fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Fluid/Humidifiers/DXDehumidifier/DXDehumidifier.dat"),
    final columns=2:7,
    final tableName="EnergyPlus",
    final smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    final shiftTime(displayUnit="d") = 12700800)
    "Reader for energy plus reference results"
    annotation (Placement(transformation(extent={{-140,60},{-120,80}})));

  Modelica.Blocks.Sources.Constant phiSet(
    final k=0.45)
    "Set point for relative humidity"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));

  Buildings.Fluid.Humidifiers.Examples.Data.DXDehumidifier per
    "Zone air DX dehumidifier curve"
    annotation (Placement(transformation(extent={{-70,60},{-50,80}})));

  Buildings.Fluid.Movers.Preconfigured.FlowControlled_m_flow fan(
    redeclare package Medium = Medium,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=100)
    "Supply fan"
    annotation (Placement(transformation(extent={{-2,-42},{18,-22}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToReaFanEna
    "Convert fan enable signal to real value"
    annotation (Placement(transformation(extent={{-70,-20},{-50,0}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysPhi(
    final uLow=-0.01,
    final uHigh=0.01)
    "Enable the dehumidifier when zone relative humidity is not at setpoint"
    annotation (Placement(transformation(extent={{-100,-70},{-80,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract phiSub
    "Find difference between zone RH and setpoint"
    annotation (Placement(transformation(extent={{-130,-70},{-110,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai(
    final k=m_flow_nominal)
    "Gain factor"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

  Modelica.Blocks.Sources.RealExpression realExpression1(
    final y=fan.m_flow)
    "Fan mass flow rate (Modelica)"
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
    final y=datRea.y[6])
    "Fan mass flow rate (EnergyPlus)"
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

  Modelica.Blocks.Sources.RealExpression realExpression5(
    final y=zon.TAir - 273.15)
    "Zone air temperature (Modelica)"
    annotation (Placement(transformation(extent={{66,-70},{86,-50}})));

  Modelica.Blocks.Math.Mean TZonAirMod(
    final f=1/tStepAve,
    final x0=28.18)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));

  Modelica.Blocks.Math.Mean TZonAirEP(
    final f=1/tStepAve)
    "Average out EnergyPlus results over time"
    annotation (Placement(transformation(extent={{180,-70},{200,-50}})));

  Modelica.Blocks.Sources.RealExpression realExpression11(
    final y=datRea.y[1])
    "Zone air temperature (EnergyPlus)"
    annotation (Placement(transformation(extent={{144,-70},{164,-50}})));

  Modelica.Blocks.Sources.RealExpression realExpression6(
    final y=zon.phi*100)
    "Zone air humidity ratio (Modelica)"
    annotation (Placement(transformation(extent={{66,-100},{86,-80}})));

  Modelica.Blocks.Math.Mean phiZonAirMod(
    final f=1/tStepAve,
    final x0=44.95)
    "Average out Modelica results over time"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}})));

  Modelica.Blocks.Math.Mean phiZonAirEP(
    final f=1/tStepAve)
    "Average out EnergyPlus results over time"
    annotation (Placement(transformation(extent={{180,-100},{200,-80}})));

  Modelica.Blocks.Sources.RealExpression realExpression12(
    final y=datRea.y[2])
    "Zone air humidity ratio (EnergyPlus)"
    annotation (Placement(transformation(extent={{144,-100},{164,-80}})));

equation
  connect(con.y, zon.qGai_flow)
    annotation (Line(points={{28,70},{20,70},{20,50},{16,50}},
                                                 color={0,0,127}));
  connect(phiSub.y, hysPhi.u)
    annotation (Line(points={{-108,-60},{-102,-60}}, color={0,0,127}));
  connect(hysPhi.y, dxDeh.uEna) annotation (Line(points={{-78,-60},{20,-60},{20,
          -37},{29,-37}},   color={255,0,255}));
  connect(hysPhi.y, booToReaFanEna.u) annotation (Line(points={{-78,-60},{-76,-60},
          {-76,-10},{-72,-10}},
                            color={255,0,255}));
  connect(phiSet.y, phiSub.u2)
    annotation (Line(points={{-139,-80},{-136,-80},{-136,-66},{-132,-66}},
                                                     color={0,0,127}));
  connect(zon.phi, phiSub.u1) annotation (Line(points={{-27,50},{-136,50},{-136,
          -54},{-132,-54}},                  color={0,0,127}));
  connect(fan.port_b, dxDeh.port_a) annotation (Line(points={{18,-32},{30,-32}},
                             color={0,127,255}));
  connect(dxDeh.port_b, zon.ports[1]) annotation (Line(points={{50,-32},{54,-32},
          {54,12},{-4,12},{-4,20.9}},color={0,127,255}));
  connect(booToReaFanEna.y, gai.u)
    annotation (Line(points={{-48,-10},{-42,-10}},   color={0,0,127}));
  connect(gai.y, fan.m_flow_in)
    annotation (Line(points={{-18,-10},{8,-10},{8,-20}},    color={0,0,127}));
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
  connect(realExpression5.y, TZonAirMod.u)
    annotation (Line(points={{87,-60},{98,-60}}, color={0,0,127}));
  connect(realExpression11.y, TZonAirEP.u)
    annotation (Line(points={{165,-60},{178,-60}}, color={0,0,127}));
  connect(realExpression6.y, phiZonAirMod.u)
    annotation (Line(points={{87,-90},{98,-90}}, color={0,0,127}));
  connect(realExpression12.y, phiZonAirEP.u)
    annotation (Line(points={{165,-90},{178,-90}}, color={0,0,127}));
  connect(fan.port_a, zon.ports[2]) annotation (Line(points={{-2,-32},{-8,-32},{
          -8,20.9}},   color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}})), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-120},{220,100}})),
    experiment(
      StartTime=12960000,
      StopTime=15120000,
      Tolerance=1e-6),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/Validation/DXDehumidifier.mos"
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
end DXDehumidifier;
