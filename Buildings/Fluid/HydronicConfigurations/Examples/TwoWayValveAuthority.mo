within Buildings.Fluid.HydronicConfigurations.Examples;
model TwoWayValveAuthority
  "Model illustrating the concept of the authority for two-way valves"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water;
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 1
    "Circuit mass flow rate at design conditions";
  parameter Modelica.Units.SI.Pressure pMin_nominal = 2E5
    "Circuit minimum pressure at design conditions";
  parameter Modelica.Units.SI.Pressure dpTot_nominal = 1E5
    "Circuit total pressure drop at design conditions";

  Sources.Boundary_pT sup(
    redeclare final package Medium = Medium,
    final p=pMin_nominal + dpTot_nominal,
    nPorts=6)
    "Pressure boundary condition at supply"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Sources.Boundary_pT ret(
    redeclare final package Medium = Medium,
    final p=pMin_nominal,
    nPorts=7)
    "Pressure boundary condition at return"
    annotation (Placement(transformation(extent={{-160,-90},{-140,-70}})));
  Actuators.Valves.TwoWayEqualPercentage valAut100(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=dpTot_nominal,
    use_inputFilter=false) "Control valve with 100% authority"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-120,-20})));
  Controls.OBC.CDL.Continuous.Sources.Ramp      ope(duration=100)
                   "Valve opening signal"
    annotation (Placement(transformation(extent={{-160,90},{-140,110}})));
  Actuators.Valves.TwoWayEqualPercentage valAut50Bal(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=0.5 * dpTot_nominal,
    use_inputFilter=false)
    "Control valve with 50% authority and balancing valve" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-20})));
  FixedResistances.PressureDrop ter50(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=0.5 * dpTot_nominal)
    "Terminal unit as a fixed resistance destroying 50% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,20})));
  FixedResistances.PressureDrop ter25Bal(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    dp_nominal=0.25*dpTot_nominal)
    "Terminal unit as a fixed resistance destroying 25% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,20})));
  Actuators.Valves.TwoWayEqualPercentage valAut50(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal= 0.5 * dpTot_nominal,
    use_inputFilter=false) "Control valve with 50% authority" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-40,-20})));
  FixedResistances.PressureDrop bal(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    dp_nominal=0.25 * dpTot_nominal)
    "Balancing valve as a fixed resistance destroying 25% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={40,-60})));
  Actuators.Valves.TwoWayEqualPercentage valAut67Ove(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=0.5*dpTot_nominal,
    use_inputFilter=false) "Control valve with 67% authority and overflow"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,-20})));
  FixedResistances.PressureDrop ter25Ove(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    dp_nominal=0.25*dpTot_nominal)
    "Terminal unit as a fixed resistance destroying 25% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={80,20})));
  Sources.Boundary_pT supLow(
    redeclare final package Medium = Medium,
    final p=pMin_nominal + 0.75*dpTot_nominal,
    nPorts=1) "Lower pressure boundary condition at supply"
    annotation (Placement(transformation(extent={{160,50},{140,70}})));
  FixedResistances.PressureDrop ter25Low(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    dp_nominal=0.25*dpTot_nominal)
    "Terminal unit as a fixed resistance destroying 25% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={120,20})));
  Actuators.Valves.TwoWayEqualPercentage valAut67Low(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=0.5*dpTot_nominal,
    use_inputFilter=false) "Control valve with 67% authority and design flow"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={120,-20})));
  FixedResistances.PressureDrop ter75(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=0.75*dpTot_nominal)
    "Terminal unit as a fixed resistance destroying 75% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,20})));
  Actuators.Valves.TwoWayEqualPercentage valAut25(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=0.25*dpTot_nominal,
    use_inputFilter=false) "Control valve with 25% authority" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={0,-20})));
  FixedResistances.PressureDrop ter25(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    dp_nominal=0.25*dpTot_nominal)
    "Terminal unit as a fixed resistance destroying 25% of design pressure difference"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,20})));
  Actuators.Valves.TwoWayEqualPercentage valAut75(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dpValve_nominal=0.75*dpTot_nominal,
    use_inputFilter=false) "Control valve with 75% authority" annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-80,-20})));
equation
  connect(sup.ports[1], valAut100.port_a) annotation (Line(points={{-140,
          58.3333},{-120,58.3333},{-120,-10}},
                                  color={0,127,255}));
  connect(ope.y, valAut100.y)
    annotation (Line(points={{-138,100},{-100,100},{-100,-20},{-108,-20}},
                                                          color={0,0,127}));
  connect(valAut100.port_b, ret.ports[1]) annotation (Line(points={{-120,-30},{
          -120,-81.7143},{-140,-81.7143}},
                              color={0,127,255}));
  connect(sup.ports[2], ter50.port_a)
    annotation (Line(points={{-140,59},{-40,59},{-40,30}},
                                                        color={0,127,255}));
  connect(ter50.port_b, valAut50.port_a)
    annotation (Line(points={{-40,10},{-40,-10}},
                                                color={0,127,255}));
  connect(ope.y, valAut50.y) annotation (Line(points={{-138,100},{-20,100},{-20,
          -20},{-28,-20}},
                     color={0,0,127}));
  connect(valAut50Bal.port_b, bal.port_a)
    annotation (Line(points={{40,-30},{40,-50}}, color={0,127,255}));
  connect(ter25Bal.port_b, valAut50Bal.port_a)
    annotation (Line(points={{40,10},{40,-10}}, color={0,127,255}));
  connect(ter25Bal.port_a, sup.ports[3]) annotation (Line(points={{40,30},{40,
          60},{-140,60},{-140,59.6667}},
                                     color={0,127,255}));
  connect(ope.y, valAut50Bal.y) annotation (Line(points={{-138,100},{60,100},{60,
          -20},{52,-20}}, color={0,0,127}));
  connect(sup.ports[4], ter25Ove.port_a) annotation (Line(points={{-140,60.3333},
          {80,60.3333},{80,30}},
                           color={0,127,255}));
  connect(ter25Ove.port_b, valAut67Ove.port_a)
    annotation (Line(points={{80,10},{80,-10}},   color={0,127,255}));
  connect(ope.y, valAut67Ove.y) annotation (Line(points={{-138,100},{100,100},{100,
          -20},{92,-20}},  color={0,0,127}));
  connect(supLow.ports[1], ter25Low.port_a)
    annotation (Line(points={{140,60},{120,60},{120,30}}, color={0,127,255}));
  connect(ter25Low.port_b, valAut67Low.port_a)
    annotation (Line(points={{120,10},{120,-10}}, color={0,127,255}));
  connect(ope.y, valAut67Low.y) annotation (Line(points={{-138,100},{100,100},{100,
          -20},{108,-20}}, color={0,0,127}));
  connect(ter75.port_b, valAut25.port_a)
    annotation (Line(points={{0,10},{0,-10}},   color={0,127,255}));
  connect(ope.y, valAut25.y) annotation (Line(points={{-138,100},{20,100},{20,-20},
          {12,-20}}, color={0,0,127}));
  connect(sup.ports[5], ter75.port_a) annotation (Line(points={{-140,61},{0,61},
          {0,30}},  color={0,127,255}));
  connect(ter25.port_a, sup.ports[6]) annotation (Line(points={{-80,30},{-80,
          61.6667},{-140,61.6667}},
                           color={0,127,255}));
  connect(ter25.port_b, valAut75.port_a)
    annotation (Line(points={{-80,10},{-80,-10}}, color={0,127,255}));
  connect(valAut75.port_b, ret.ports[2]) annotation (Line(points={{-80,-30},{
          -80,-78},{-140,-78},{-140,-81.1429}},
                                            color={0,127,255}));
  connect(valAut50.port_b, ret.ports[3]) annotation (Line(points={{-40,-30},{
          -40,-80.5714},{-140,-80.5714}},
                                      color={0,127,255}));
  connect(valAut25.port_b, ret.ports[4])
    annotation (Line(points={{0,-30},{0,-80},{-140,-80}}, color={0,127,255}));
  connect(bal.port_b, ret.ports[5]) annotation (Line(points={{40,-70},{40,
          -79.4286},{-140,-79.4286}},
                            color={0,127,255}));
  connect(valAut67Ove.port_b, ret.ports[6]) annotation (Line(points={{80,-30},{
          80,-80},{-40,-80},{-40,-78.8571},{-140,-78.8571}},
                                                          color={0,127,255}));
  connect(valAut67Low.port_b, ret.ports[7]) annotation (Line(points={{120,-30},
          {120,-80},{-114,-80},{-114,-78.2857},{-140,-78.2857}},color={0,127,255}));
  connect(ope.y, valAut75.y) annotation (Line(points={{-138,100},{-60,100},{-60,
          -20},{-68,-20}}, color={0,0,127}));
  annotation (Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-120},{180,120}})),
  experiment(
    StopTime=100,
    Tolerance=1e-6));
end TwoWayValveAuthority;
