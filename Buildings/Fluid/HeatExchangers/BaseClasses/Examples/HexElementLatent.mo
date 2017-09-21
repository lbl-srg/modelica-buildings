within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model HexElementLatent
  "Model that tests the basic element that is used to built heat exchanger models"
  extends Modelica.Icons.Example;
 package Medium_W = Buildings.Media.Water;
 package Medium_A = Buildings.Media.Air;
  Buildings.Fluid.Sources.Boundary_pT sin_2(
    redeclare package Medium = Medium_A,
    use_p_in=true,
    use_T_in=true,
    T=288.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-60,-80},
            {-40,-60}})));
    Modelica.Blocks.Sources.Ramp PIn(
    height=20,
    duration=300,
    startTime=300,
    offset=101324.95)
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
    nPorts=1)             annotation (Placement(transformation(extent={{40,72},
            {60,92}})));
  Buildings.Fluid.Sources.Boundary_pT sou_1(
    redeclare package Medium = Medium_W,
    use_T_in=true,
    p=101340,
    T=293.15,
    nPorts=1)             annotation (Placement(transformation(extent={{-60,40},
            {-40,60}})));
  Buildings.Fluid.FixedResistances.PressureDrop res_22(
    m_flow_nominal=5,
    dp_nominal=5,
    redeclare package Medium = Medium_A)
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-32,-50})));
  Buildings.Fluid.FixedResistances.PressureDrop res_12(
    m_flow_nominal=5,
    dp_nominal=5,
    redeclare package Medium = Medium_W)
    annotation (Placement(transformation(extent={{72,-4},{92,16}})));
  Buildings.Fluid.HeatExchangers.BaseClasses.HexElementLatent hex(
    m1_flow_nominal=5,
    m2_flow_nominal=5,
    UA_nominal=9999,
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    dp1_nominal=10,
    dp2_nominal=10,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState)
                    annotation (Placement(transformation(extent={{12,-10},{32,
            10}})));
  Modelica.Blocks.Sources.Constant TDb1(k=303.15) "Drybulb temperature"
    annotation (Placement(transformation(extent={{-100,-76},{-80,-56}})));
  Modelica.Blocks.Sources.Constant hACon(k=10000) "Convective heat transfer"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
  Sensors.EnthalpyFlowRate senEntFlo(
    redeclare package Medium = Medium_W,
    m_flow_nominal=5,
    tau=0,
    initType=Modelica.Blocks.Types.Init.SteadyState)
    "Enthalpy flow rate sensor"
    annotation (Placement(transformation(extent={{-30,-4},{-10,16}})));
  Sensors.EnthalpyFlowRate senEntFlo1(
    redeclare package Medium = Medium_W,
    m_flow_nominal=5,
    tau=0,
    initType=Modelica.Blocks.Types.Init.SteadyState)
    "Enthalpy flow rate sensor"
    annotation (Placement(transformation(extent={{40,-4},{60,16}})));
  Sensors.EnthalpyFlowRate senEntFlo2(
    m_flow_nominal=5,
    tau=0,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    redeclare package Medium = Medium_A) "Enthalpy flow rate sensor"
    annotation (Placement(transformation(extent={{-30,-44},{-10,-24}})));
  Sensors.EnthalpyFlowRate senEntFlo3(
    m_flow_nominal=5,
    tau=0,
    initType=Modelica.Blocks.Types.Init.SteadyState,
    redeclare package Medium = Medium_A) "Enthalpy flow rate sensor"
    annotation (Placement(transformation(extent={{40,-44},{60,-24}})));
  Modelica.Blocks.Math.MultiSum netEne(nu=4, k={1,-1,1,-1})
    "Net energy balance (needs to be zero)"
    annotation (Placement(transformation(extent={{76,34},{88,46}})));
equation
  connect(TDb.y, sou_1.T_in) annotation (Line(
      points={{-79,54},{-79,54},{-62,54}},
      color={0,0,127}));
  connect(POut.y, sin_1.p_in) annotation (Line(
      points={{-79,90},{30,90},{38,90}},
      color={0,0,127}));
  connect(PIn.y, sou_2.p_in) annotation (Line(
      points={{21,-50},{30,-50},{30,-62},{38,-62}},
      color={0,0,127}));
  connect(TWat.y, sou_2.T_in) annotation (Line(
      points={{21,-82},{30,-82},{30,-66},{38,-66}},
      color={0,0,127}));
  connect(POut.y, sin_2.p_in) annotation (Line(
      points={{-79,90},{-70,90},{-70,-62},{-62,-62}},
      color={0,0,127}));
  connect(TDb1.y, sin_2.T_in) annotation (Line(points={{-79,-66},{-70.5,-66},{
          -62,-66}},
        color={0,0,127}));
  connect(hACon.y, hex.Gc_1) annotation (Line(points={{1,70},{18,70},{18,10}},
        color={0,0,127}));
  connect(hACon.y, hex.Gc_2) annotation (Line(points={{1,70},{8,70},{8,-16},{26,
          -16},{26,-10}}, color={0,0,127}));
  connect(sin_1.ports[1], res_12.port_b) annotation (Line(
      points={{60,82},{96,82},{96,6},{92,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_2.ports[1], res_22.port_b) annotation (Line(
      points={{-40,-70},{-32,-70},{-32,-60}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senEntFlo.port_b, hex.port_a1)
    annotation (Line(points={{-10,6},{12,6}}, color={0,127,255}));
  connect(senEntFlo.port_a, sou_1.ports[1]) annotation (Line(points={{-30,6},{
          -34,6},{-34,50},{-40,50}}, color={0,127,255}));
  connect(res_12.port_a, senEntFlo1.port_b)
    annotation (Line(points={{72,6},{72,6},{60,6}}, color={0,127,255}));
  connect(hex.port_b1, senEntFlo1.port_a)
    annotation (Line(points={{32,6},{36,6},{40,6}}, color={0,127,255}));
  connect(res_22.port_a, senEntFlo2.port_a) annotation (Line(points={{-32,-40},
          {-32,-40},{-32,-34},{-30,-34}}, color={0,127,255}));
  connect(senEntFlo2.port_b, hex.port_b2) annotation (Line(points={{-10,-34},{0,
          -34},{0,-6},{12,-6}}, color={0,127,255}));
  connect(hex.port_a2, senEntFlo3.port_a) annotation (Line(points={{32,-6},{36,
          -6},{36,-34},{40,-34}}, color={0,127,255}));
  connect(senEntFlo3.port_b, sou_2.ports[1]) annotation (Line(points={{60,-34},
          {70,-34},{70,-70},{60,-70}}, color={0,127,255}));
  connect(netEne.u[1], senEntFlo.H_flow) annotation (Line(points={{76,43.15},{
          -20,43.15},{-20,17}}, color={0,0,127}));
  connect(senEntFlo1.H_flow, netEne.u[2])
    annotation (Line(points={{50,17},{50,41.05},{76,41.05}}, color={0,0,127}));
  connect(senEntFlo2.H_flow, netEne.u[3]) annotation (Line(points={{-20,-23},{
          -20,-14},{-2,-14},{-2,38.95},{76,38.95}}, color={0,0,127}));
  connect(senEntFlo3.H_flow, netEne.u[4]) annotation (Line(points={{50,-23},{50,
          -14},{68,-14},{68,38},{76,38},{76,36.85}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-6, StopTime=600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/HexElementLatent.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model verifies that the energy among the two fluid streams is conserved.
This energy is measured by the quantity <code>netEne.y</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
September 21, 2017, by Michael Wetter:<br/>
Changed pressure so that there is a small flow during the initialization.
Otherwise, the outlet conditions are not defined for this steady state model,
and in Dymola 2018FD01, a check on the mass fraction would be violated.
</li>
<li>
April 12, 2017, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HexElementLatent;
