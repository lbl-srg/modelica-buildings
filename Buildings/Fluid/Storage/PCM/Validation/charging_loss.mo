within Buildings.Fluid.Storage.PCM.Validation;
model charging_loss
  extends charging58(
    break connect(m3s_kgs.y, HPCPum.m_flow_in),
    break connect(m3s_kgs1.y, LPCPum.m_flow_in),
    HPCdata(fileName="C:/drive/pcm/PCM-Validation/58_pcm_single_all_runs/58_single_3lpm_12C_65C_Run2_all.txt"),
    LPCdata(fileName="C:/drive/pcm/PCM-Validation/58_pcm_single_all_runs/58_single_3lpm_12C_65C_Run2_all.txt"),
    break connect(TOutLPC.T, TOutLPCMod),
    break connect(TOutHPC.T, TOutHPCMod),
    TOutHPCMod = pcmFourPort.eleHex.vol1.T,
    TOutLPCMod = pcmFourPort.eleHex.vol2.T);

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor(G=0.4)
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature(T=293.15)
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor thermalConductor1(G
      =0.8)
    annotation (Placement(transformation(extent={{-40,-110},{-20,-90}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature fixedTemperature1(T=293.15)
    annotation (Placement(transformation(extent={{-80,-110},{-60,-90}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold(threshold
      =0.0001)
    annotation (Placement(transformation(extent={{-202,40},{-182,60}})));
  Modelica.Blocks.Logical.Switch switch1
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Modelica.Blocks.Sources.RealExpression realExpression
    annotation (Placement(transformation(extent={{-200,10},{-180,30}})));
  Modelica.Blocks.Logical.Switch switch2
    annotation (Placement(transformation(extent={{180,-32},{160,-12}})));
  Modelica.Blocks.Logical.GreaterEqualThreshold greaterEqualThreshold1(
      threshold=0.0001)
    annotation (Placement(transformation(extent={{220,-32},{200,-12}})));
  Modelica.Blocks.Sources.RealExpression realExpression1
    annotation (Placement(transformation(extent={{220,-50},{200,-30}})));
equation


  connect(fixedTemperature.port, thermalConductor.port_a)
    annotation (Line(points={{-40,100},{-20,100}}, color={191,0,0}));
  connect(fixedTemperature1.port, thermalConductor1.port_a)
    annotation (Line(points={{-60,-100},{-40,-100}}, color={191,0,0}));
  connect(greaterEqualThreshold.y, switch1.u2)
    annotation (Line(points={{-181,50},{-162,50}}, color={255,0,255}));
  connect(switch1.y, HPCPum.m_flow_in) annotation (Line(points={{-139,50},{-100,
          50},{-100,18},{-78,18}}, color={0,0,127}));
  connect(m3s_kgs.y, switch1.u1) annotation (Line(points={{-67,50},{-80,50},{-80,
          66},{-168,66},{-168,58},{-162,58}}, color={0,0,127}));
  connect(m3s_kgs.y, greaterEqualThreshold.u) annotation (Line(points={{-67,50},
          {-80,50},{-80,66},{-212,66},{-212,50},{-204,50}}, color={0,0,127}));
  connect(realExpression.y, switch1.u3) annotation (Line(points={{-179,20},{-170,
          20},{-170,42},{-162,42}}, color={0,0,127}));
  connect(switch2.u2, greaterEqualThreshold1.y)
    annotation (Line(points={{182,-22},{199,-22}}, color={255,0,255}));
  connect(m3s_kgs1.y, greaterEqualThreshold1.u) annotation (Line(points={{111,-50},
          {240,-50},{240,-22},{222,-22}}, color={0,0,127}));
  connect(m3s_kgs1.y, switch2.u1) annotation (Line(points={{111,-50},{240,-50},{
          240,-4},{190,-4},{190,-14},{182,-14}}, color={0,0,127}));
  connect(realExpression1.y, switch2.u3) annotation (Line(points={{199,-40},{190,
          -40},{190,-30},{182,-30}}, color={0,0,127}));
  connect(switch2.y, LPCPum.m_flow_in)
    annotation (Line(points={{159,-22},{132,-22}}, color={0,0,127}));
  connect(thermalConductor.port_b, pcmFourPort.heaPorDom)
    annotation (Line(points={{0,100},{20,100},{20,2}}, color={191,0,0}));
  connect(thermalConductor1.port_b, pcmFourPort.heaPorPro)
    annotation (Line(points={{-20,-100},{20,-100},{20,-22}}, color={191,0,0}));
  annotation (experiment(
      StopTime=33000,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"));
end charging_loss;
