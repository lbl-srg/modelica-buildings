within Buildings.Fluid.MixingVolumes.Examples;
model MixingVolumeDryAir
  import Buildings;

 package Medium = Modelica.Media.Air.SimpleAir(T_min=Modelica.SIunits.Conversions.from_degC(-50))
    "Medium in the component";

    Modelica.Blocks.Sources.Ramp P(
    height=-10,
    offset=101330,
    duration=300,
    startTime=150)
                 annotation (Placement(transformation(extent={{-100,16},{-80,36}},
          rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou(             redeclare package Medium
      = Medium,
    nPorts=2,
    use_p_in=true,
    p=Medium.p_default,
    T=293.15)                                       annotation (Placement(
        transformation(extent={{-70,8},{-50,28}},  rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin(             redeclare package Medium
      = Medium,
    use_p_in=false,
    p=101325,
    T=283.15,
    nPorts=2)                                       annotation (Placement(
        transformation(extent={{134,8},{114,28}},  rotation=0)));
  MixingVolumes.MixingVolume vol1(
    redeclare package Medium = Medium,
    V=0.1,
    nPorts=2)
          annotation (Placement(transformation(extent={{0,20},{20,40}},
          rotation=0)));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res11(
    redeclare each package Medium = Medium,
    dp_nominal=5,
    from_dp=true,
    m_flow_nominal=2)
             annotation (Placement(transformation(extent={{-40,10},{-20,30}},
          rotation=0)));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res12(
    redeclare each package Medium = Medium,
    dp_nominal=5,
    from_dp=true,
    m_flow_nominal=2)
             annotation (Placement(transformation(extent={{80,10},{100,30}},
          rotation=0)));
  Buildings.Fluid.Sensors.EnthalpyFlowRate entFloRat1(redeclare package Medium
      = Medium, m_flow_nominal=2) "Enthalpy flow rate"
                                     annotation (Placement(transformation(
          extent={{40,10},{60,30}}, rotation=0)));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res21(
    redeclare each package Medium = Medium,
    dp_nominal=5,
    from_dp=true,
    m_flow_nominal=2)
             annotation (Placement(transformation(extent={{-40,-90},{-20,-70}},
          rotation=0)));
    Buildings.Fluid.FixedResistances.FixedResistanceDpM res22(
    redeclare each package Medium = Medium,
    dp_nominal=5,
    from_dp=true,
    m_flow_nominal=2)
             annotation (Placement(transformation(extent={{80,-90},{100,-70}},
          rotation=0)));
  Buildings.Utilities.Diagnostics.AssertEquality assertEquality1(startTime=0)
    annotation (Placement(transformation(extent={{152,40},{172,60}},   rotation=
           0)));
  Buildings.Fluid.Sensors.EnthalpyFlowRate entFloRat2(redeclare package Medium
      = Medium, m_flow_nominal=2) "Enthalpy flow rate"
                                     annotation (Placement(transformation(
          extent={{40,-90},{60,-70}}, rotation=0)));
    Modelica.Blocks.Sources.Constant zero(k=0)
      annotation (Placement(transformation(extent={{-40,-20},{-20,0}},
          rotation=0)));
    Modelica.Blocks.Sources.Constant TLiq(k=283.15)
      annotation (Placement(transformation(extent={{-40,-52},{-20,-32}},
          rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Buildings.Fluid.MixingVolumes.MixingVolumeDryAir vol2(
    redeclare package Medium = Medium,
    V=0.1,
    nPorts=2)
          annotation (Placement(transformation(extent={{0,-80},{20,-60}},
          rotation=0)));
equation
  connect(res12.port_a, entFloRat1.port_b) annotation (Line(points={{80,20},{60,
          20}}, color={0,127,255}));
  connect(res22.port_a, entFloRat2.port_b) annotation (Line(points={{80,-80},{
          74,-80},{68,-80},{60,-80}},
                    color={0,127,255}));
  connect(entFloRat2.H_flow, assertEquality1.u2) annotation (Line(points={{50,-69},
          {50,-40},{140,-40},{140,44},{150,44}},
                                    color={0,0,127}));
  connect(res11.port_b, vol1.ports[1]) annotation (Line(
      points={{-20,20},{8,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(entFloRat1.port_a, vol1.ports[2]) annotation (Line(
      points={{40,20},{12,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res21.port_b, vol2.ports[1]) annotation (Line(
      points={{-20,-80},{8,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol2.ports[2], entFloRat2.port_a) annotation (Line(
      points={{12,-80},{40,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(zero.y, vol2.mWat_flow) annotation (Line(
      points={{-19,-10},{-10,-10},{-10,-62},{-2,-62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TLiq.y, vol2.TWat) annotation (Line(
      points={{-19,-42},{-12,-42},{-12,-65.2},{-2,-65.2}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(entFloRat1.H_flow, assertEquality1.u1) annotation (Line(
      points={{50,31},{50,56},{150,56}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(sou.ports[1], res11.port_a) annotation (Line(
      points={{-50,20},{-40,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou.ports[2], res21.port_a) annotation (Line(
      points={{-50,16},{-46,16},{-46,-80},{-40,-80}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res12.port_b, sin.ports[1]) annotation (Line(
      points={{100,20},{114,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(res22.port_b, sin.ports[2]) annotation (Line(
      points={{100,-80},{108,-80},{108,16},{114,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(P.y, sou.p_in) annotation (Line(
      points={{-79,26},{-72,26}},
      color={0,0,127},
      smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=true,  extent={{-100,
            -100},{180,100}}),      graphics),
                         Commands(file=
            "MixingVolumeDryAir.mos" "run"));
end MixingVolumeDryAir;
