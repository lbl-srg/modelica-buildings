within Buildings.Fluid.Sensors.Examples;
model ExtraProperty
  extends Modelica.Icons.Example;
  import Buildings;
 package Medium = Buildings.Media.GasesPTDecoupled.SimpleAir(extraPropertiesNames={"CO2"});

  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    V=2*3*3,
    nPorts=4) "Mixing volume"
                          annotation (Placement(transformation(extent={{74,50},
            {94,70}}, rotation=0)));
  inner Modelica.Fluid.System system   annotation (Placement(transformation(
          extent={{-100,-100},{-80,-80}}, rotation=0)));
  Sources.PrescribedExtraPropertyFlowRate sou(redeclare package Medium = Medium,
    nPorts=3,
    use_m_flow_in=true)
    annotation (Placement(transformation(extent={{-2,30},{18,50}}, rotation=0)));
  Modelica.Blocks.Sources.Constant step(k=8.18E-6)
    annotation (Placement(transformation(extent={{-80,30},{-60,50}}, rotation=0)));
  Buildings.Fluid.Sensors.TraceSubstances senVol(
                    redeclare package Medium = Medium) "Sensor at volume"
    annotation (Placement(transformation(extent={{100,50},{120,70}}, rotation=0)));
  Buildings.Fluid.Sensors.TraceSubstances senSou(
                    redeclare package Medium = Medium, substanceName="CO2")
    "Sensor at source"
    annotation (Placement(transformation(extent={{100,90},{120,110}}, rotation=
            0)));
  Modelica.Blocks.Sources.Constant m_flow(k=15*1.2/3600) "Fresh air flow rate"
    annotation (Placement(transformation(extent={{-80,-14},{-60,6}}, rotation=0)));
  Buildings.Fluid.Sources.MassFlowSource_T mSou(
                                          redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=2)   annotation (Placement(transformation(extent={{0,-22},{20,-2}},
          rotation=0)));
  Modelica.Blocks.Math.Gain gain(k=-1) annotation (Placement(transformation(
          extent={{-40,-54},{-20,-34}}, rotation=0)));
  Buildings.Fluid.Sources.MassFlowSource_T mSin(
                                          redeclare package Medium = Medium,
    use_m_flow_in=true,
    nPorts=2)   annotation (Placement(transformation(extent={{0,-62},{20,-42}},
          rotation=0)));
  Buildings.Fluid.Sensors.Conversions.To_VolumeFraction masFraSou(
                                                   MMMea=Modelica.Media.
        IdealGases.Common.SingleGasesData.CO2.MM)
    annotation (Placement(transformation(extent={{140,90},{160,110}},  rotation=
           0)));
  Buildings.Fluid.Sensors.Conversions.To_VolumeFraction masFraVol(
                                                   MMMea=Modelica.Media.
        IdealGases.Common.SingleGasesData.CO2.MM)
    annotation (Placement(transformation(extent={{140,50},{160,70}}, rotation=0)));
  Buildings.Fluid.Sensors.RelativePressure dp(
                      redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{100,-20},{120,0}},   rotation=
           0)));
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality(startTime=0,
      threShold=1E-8)
    annotation (Placement(transformation(extent={{136,-88},{156,-68}}, rotation=
           0)));
  Modelica.Blocks.Sources.Constant zer(k=0) "Zero signal"
    annotation (Placement(transformation(extent={{78,-94},{98,-74}}, rotation=0)));
  Buildings.Fluid.Sensors.Pressure preSen(  redeclare package Medium = Medium)
    "Pressure sensor" annotation (Placement(transformation(extent={{20,120},{40,
            140}}, rotation=0)));
equation
  connect(m_flow.y, mSou.m_flow_in) annotation (Line(points={{-59,-4},{
          -5.55112e-16,-4},{-5.55112e-16,-4}},                color={0,0,127}));
  connect(m_flow.y, gain.u) annotation (Line(points={{-59,-4},{-50,-4},{-50,-44},
          {-42,-44}}, color={0,0,127}));
  connect(gain.y, mSin.m_flow_in) annotation (Line(points={{-19,-44},{
          -5.55112e-16,-44},{-5.55112e-16,-44}},
        color={0,0,127}));
  connect(senSou.C, masFraSou.m) annotation (Line(points={{121,100},{121,100},{
          139,100}},             color={0,0,127}));
  connect(senVol.C, masFraVol.m) annotation (Line(points={{121,60},{139,60}},
        color={0,0,127}));
  connect(dp.p_rel, assertEquality.u1) annotation (Line(points={{110,-19},{110,
          -19},{110,-72},{134,-72}}, color={0,0,127}));
  connect(zer.y, assertEquality.u2)
    annotation (Line(points={{99,-84},{134,-84}}, color={0,0,127}));
  connect(mSou.ports[1], dp.port_a) annotation (Line(
      points={{20,-10},{100,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mSin.ports[1], dp.port_b) annotation (Line(
      points={{20,-50},{134,-50},{134,-10},{120,-10}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mSou.ports[2], vol.ports[1]) annotation (Line(
      points={{20,-14},{50,-14},{50,50},{81,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mSin.ports[2], vol.ports[2]) annotation (Line(
      points={{20,-54},{48,-54},{48,-30},{83,-30},{83,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[4], senVol.port) annotation (Line(
      points={{87,50},{87,40},{110,40},{110,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[1], vol.ports[3]) annotation (Line(
      points={{18,42.6667},{85,42.6667},{85,50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], preSen.port) annotation (Line(
      points={{18,40},{30,40},{30,120}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[3], senSou.port) annotation (Line(
      points={{18,37.3333},{34,37.3333},{34,90},{110,90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(step.y, sou.m_flow_in) annotation (Line(
      points={{-59,40},{-4.1,40}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (Commands(file=
            "ExtraProperty.mos" "run"),
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,-100},{180,
            180}})));
end ExtraProperty;
