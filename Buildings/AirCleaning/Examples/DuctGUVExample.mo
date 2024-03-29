within Buildings.AirCleaning.Examples;
model DuctGUVExample
  replaceable package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2", "SARS-CoV-2"}) "Medium model for air";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 6.71
    "Design mass flow rate";
  Buildings.AirCleaning.DuctGUV ducGUV(
    dp_nominal=0,
    kGUV={10e6,0.69},
    kpow=200,
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T flo(
    use_C_in=false,
    C={1,1},
    use_m_flow_in=true,
    redeclare package Medium = Medium,
    nPorts=1)
    annotation (Placement(transformation(extent={{-48,-10},{-28,10}})));
  Modelica.Blocks.Sources.Ramp ramFlo(
    height=0.75*m_flow_nominal,
    duration=3600,
    offset=0.25*m_flow_nominal,
    startTime=120)
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
  Modelica.Blocks.Sources.BooleanConstant onSig
    annotation (Placement(transformation(extent={{-66,-50},{-46,-30}})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    m_flow_nominal=m_flow_nominal,
    V=500,                                       nPorts=1, redeclare package
      Medium =                                                                        Medium)
    annotation (Placement(transformation(extent={{40,10},{60,30}})));

equation
  connect(flo.ports[1], ducGUV.port_a)
    annotation (Line(points={{-28,0},{-10,0}}, color={0,127,255}));
  connect(onSig.y, ducGUV.u) annotation (Line(points={{-45,-40},{-20,-40},{-20,
          -8},{-12,-8}}, color={255,0,255}));
  connect(ramFlo.y, flo.m_flow_in) annotation (Line(points={{-69,30},{-58,30},{-58,
          8},{-50,8}}, color={0,0,127}));
  connect(ducGUV.port_b, vol.ports[1]) annotation (Line(points={{10,0},{50,0},
          {50,10}},                    color={0,127,255}));
  annotation (
    Icon(coordinateSystem(preserveAspectRatio=false)),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    experiment(StopTime=3840, __Dymola_Algorithm="Dassl"));
end DuctGUVExample;
