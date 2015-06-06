within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model HexElementSensible
  "Model that tests the basic element that is used to built heat exchanger models"
  extends Modelica.Icons.Example;
 package Medium_W = Buildings.Media.Water;
 package Medium_A = Buildings.Media.Air;
  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium_A,
    use_p_in=true,
    use_T_in=true,
    T=288.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-60,-30},
            {-40,-10}})));
    Modelica.Blocks.Sources.Ramp PIn(
    height=20,
    duration=300,
    startTime=300,
    offset=101325)
                 annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.Fluid.Sources.Boundary_pT sou_2(
    redeclare package Medium = Medium_A,
    use_p_in=true,
    use_T_in=true,
    T=283.15,
    nPorts=1)             annotation (Placement(transformation(extent={{40,-80},
            {60,-60}})));
    Modelica.Blocks.Sources.Ramp TWat(
    startTime=1,
    height=4,
    duration=300,
    offset=303.15) "Water temperature"
                 annotation (Placement(transformation(extent={{0,-92},{20,-72}})));
  Modelica.Blocks.Sources.Constant TDb(k=278.15) "Drybulb temperature"
    annotation (Placement(transformation(extent={{-100,44},{-80,64}})));
    Modelica.Blocks.Sources.Constant POut(k=101325)
      annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Buildings.Fluid.Sources.Boundary_pT sin_1(
   redeclare package Medium = Medium_W,
    use_p_in=true,
    T=288.15,
    nPorts=1)             annotation (Placement(transformation(extent={{42,40},
            {62,60}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium_W,
    use_T_in=true,
    nPorts=1,
    p=101340,
    T=293.15)             annotation (Placement(transformation(extent={{-60,40},
            {-40,60}})));
    Fluid.FixedResistances.FixedResistanceDpM res_22(
    m_flow_nominal=5,
    dp_nominal=5,
    redeclare package Medium = Medium_A)
             annotation (Placement(transformation(extent={{-4,-30},{-24,-10}})));
    Fluid.FixedResistances.FixedResistanceDpM res_12(
    m_flow_nominal=5,
    dp_nominal=5,
    redeclare package Medium = Medium_W)
             annotation (Placement(transformation(extent={{48,-4},{68,16}})));
  Buildings.Fluid.HeatExchangers.BaseClasses.HexElementSensible hex(
    m1_flow_nominal=5,
    m2_flow_nominal=5,
    UA_nominal=9999,
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    dp1_nominal=5,
    dp2_nominal=5,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
                    annotation (Placement(transformation(extent={{10,-10},{30,
            10}})));
  Modelica.Blocks.Sources.Constant TDb1(k=303.15) "Drybulb temperature"
    annotation (Placement(transformation(extent={{-100,-26},{-80,-6}})));
    Fluid.FixedResistances.FixedResistanceDpM res_11(
    m_flow_nominal=5,
    dp_nominal=5,
    redeclare package Medium = Medium_W)
             annotation (Placement(transformation(extent={{-24,-4},{-4,16}})));
    Fluid.FixedResistances.FixedResistanceDpM res_21(
    m_flow_nominal=5,
    dp_nominal=5,
    redeclare package Medium = Medium_A)
             annotation (Placement(transformation(extent={{70,-30},{50,-10}})));
  Modelica.Blocks.Sources.Constant hACon(k=10000) "Convective heat transfer"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
equation
  connect(TDb.y, sou_1.T_in) annotation (Line(
      points={{-79,54},{-79,54},{-62,54}},
      color={0,0,127}));
  connect(POut.y, sin_1.p_in) annotation (Line(
      points={{-79,90},{30,90},{30,58},{40,58}},
      color={0,0,127}));
  connect(PIn.y, sou_2.p_in) annotation (Line(
      points={{21,-50},{30,-50},{30,-62},{38,-62}},
      color={0,0,127}));
  connect(TWat.y, sou_2.T_in) annotation (Line(
      points={{21,-82},{30,-82},{30,-66},{38,-66}},
      color={0,0,127}));
  connect(POut.y, sin_2.p_in) annotation (Line(
      points={{-79,90},{-70,90},{-70,-12},{-62,-12}},
      color={0,0,127}));
  connect(hex.port_b1, res_12.port_a)
                                     annotation (Line(points={{30,6},{48,6}},
                        color={0,127,255}));
  connect(res_22.port_a, hex.port_b2)
                                     annotation (Line(points={{-4,-20},{2,-20},
          {2,-6},{10,-6}}, color={0,127,255}));
  connect(TDb1.y, sin_2.T_in) annotation (Line(points={{-79,-16},{-70.5,-16},{
          -62,-16}},
        color={0,0,127}));
  connect(res_11.port_b, hex.port_a1) annotation (Line(points={{-4,6},{0,6},{10,
          6}},            color={0,127,255}));
  connect(hex.port_a2, res_21.port_b) annotation (Line(points={{30,-6},{40,-6},
          {40,-20},{50,-20}}, color={0,127,255}));
  connect(hACon.y, hex.Gc_1) annotation (Line(points={{1,70},{16,70},{16,10}},
        color={0,0,127}));
  connect(hACon.y, hex.Gc_2) annotation (Line(points={{1,70},{8,70},{8,-16},{24,
          -16},{24,-10}}, color={0,0,127}));
  connect(sou_2.ports[1], res_21.port_a) annotation (Line(
      points={{60,-70},{80,-70},{80,-20},{70,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_1.ports[1], res_12.port_b) annotation (Line(
      points={{62,50},{80,50},{80,6},{68,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou_1.ports[1], res_11.port_a) annotation (Line(
      points={{-40,50},{-34,50},{-34,6},{-24,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_2.ports[1], res_22.port_b) annotation (Line(
      points={{-40,-20},{-24,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation(experiment(StopTime=600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/HexElementSensible.mos"
        "Simulate and plot"));
end HexElementSensible;
