within Buildings.Fluid.HeatExchangers.CoolingTowers.Examples.BaseClasses;
partial model PartialStaticTwoPortCoolingTower
 package Medium_W = Buildings.Media.ConstantPropertyLiquidWater;

  parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal = 0.15
    "Design air flow rate"
      annotation (Dialog(group="Nominal condition"));

  Modelica.Blocks.Sources.Constant TWat(k=273.15 + 35) "Water temperature"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}},
          rotation=0)));
  replaceable
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.PartialStaticTwoPortCoolingTower
    tow(   redeclare package Medium = Medium_W, m_flow_nominal=mWat_flow_nominal,
    dp_nominal=10) "Cooling tower"
    annotation (Placement(transformation(extent={{-18,-60},{2,-40}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sin_1(             T=283.15, redeclare
      package Medium = Medium_W,
    p=101325,
    nPorts=1)             annotation (Placement(transformation(extent={{80,-60},
            {60,-40}}, rotation=0)));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium_W,
    nPorts=1,
    use_p_in=true,
    use_T_in=true,
    p=101335,
    T=293.15)             annotation (Placement(transformation(extent={{-56,-60},
            {-36,-40}}, rotation=0)));
    Modelica.Blocks.Sources.Constant PWatIn(k=101335)
      annotation (Placement(transformation(extent={{-100,-20},{-80,0}},
          rotation=0)));
  Modelica.Blocks.Sources.Sine TOut(amplitude=10, offset=293.15)
    "Outside air temperature" annotation (Placement(transformation(extent={{-60,
            80},{-40,100}}, rotation=0)));
  inner Modelica.Fluid.System system
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
equation
  connect(TWat.y, sou_1.T_in)
                             annotation (Line(
      points={{-79,-50},{-68.5,-50},{-68.5,-46},{-58,-46}},
      color={0,0,127},
      pattern=LinePattern.None));
  connect(PWatIn.y, sou_1.p_in) annotation (Line(points={{-79,-10},{-70,-10},{
          -70,-42},{-58,-42}}, color={0,0,127}));
  connect(sou_1.ports[1], tow.port_a) annotation (Line(
      points={{-36,-50},{-18,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(tow.port_b, sin_1.ports[1]) annotation (Line(
      points={{2,-50},{60,-50}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}),
                      graphics));
end PartialStaticTwoPortCoolingTower;
