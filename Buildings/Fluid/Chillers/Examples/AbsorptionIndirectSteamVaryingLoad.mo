within Buildings.Fluid.Chillers.Examples;
model AbsorptionIndirectSteamVaryingLoad
  "Absorption chiller with varying cooling load"
  package Medium = Buildings.Media.Water "Medium model";

  parameter Data.AbsorptionIndirectSteam.Generic per(
    QEva_flow_nominal=-10000,
    P_nominal=150,
    PLRMax=1,
    PLRMin=0.15,
    mEva_flow_nominal=0.247,
    mCon_flow_nominal=1.1,
    dpEva_nominal=0,
    dpCon_nominal=0,
    capFunEva={0.690571,0.065571,-0.00289,0},
    capFunCon={0.245507,0.023614,0.0000278,0.000013},
    genHIR={0.18892,0.968044,1.119202,-0.5034},
    EIRP={1,0,0},
    genConT={0.712019,-0.00478,0.000864,-0.000013},
    genEvaT={0.995571,0.046821,-0.01099,0.000608})
     "Chiller performance data"
    annotation (Placement(transformation(extent={{-22,62},{-2,82}})));

  Buildings.Fluid.Chillers.AbsorptionIndirectSteam chi(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    per=per,
    show_T=true,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    T1_start=25 + 273.15,
    T2_start=10 + 273.15) "Absorption indirect chiller"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Fluid.Sources.MassFlowSource_T conPum(
    redeclare package Medium = Medium,
    m_flow=per.mCon_flow_nominal,
    T=273.15 + 30,
    nPorts=1)
    "Condenser water pump"
      annotation (
      Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=180,
        origin={-60,42})));

  Buildings.Fluid.Sources.Boundary_pT bouCoo(
    redeclare package Medium = Medium, nPorts=1)
    "Boundary condition for cooling loop"
       annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));

  Buildings.Fluid.Sources.Boundary_pT heaBou(
    redeclare package Medium = Medium,
    nPorts=1) "Boundary condition for heating"
       annotation (Placement(transformation(extent={{20,30},{0,50}})));

  Controls.OBC.CDL.Logical.Sources.Constant on(k=true) "On signal"
    annotation (Placement(transformation(extent={{-130,20},{-110,40}})));

  Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=per.mEva_flow_nominal,
    inputType=Buildings.Fluid.Types.InputType.Continuous,
    nominalValuesDefineDefaultPressureCurve=true,
    use_riseTime=false) "Chilled water pump"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Sources.PropertySource_T proSou(
    redeclare package Medium = Medium,
    use_T_in=true) "Cooling load"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
  Controls.OBC.CDL.Reals.Sources.Constant TSet(k=273.15 + 10) "Set point"
    annotation (Placement(transformation(extent={{-130,-12},{-110,8}})));
  Controls.OBC.CDL.Reals.Sources.Ramp mPum_flow(
    height=per.mEva_flow_nominal,
    duration=86400,
    offset=0) "Pump flow rate"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Controls.OBC.CDL.Reals.Divide QEva_QGen
    "Ratio of cooling provided over required steam"
    annotation (Placement(transformation(extent={{90,0},{110,20}})));
  Controls.OBC.CDL.Reals.Divide QEva_P
    "Ratio of cooling provided over pump energy"
    annotation (Placement(transformation(extent={{90,-30},{110,-10}})));
  Controls.OBC.CDL.Reals.MultiplyByParameter gai(k=-1)
    "Gain to switch sign"
    annotation (Placement(transformation(extent={{52,-50},{72,-30}})));
  Controls.OBC.CDL.Reals.Sources.Constant TEnt(k=273.15 + 15)
    "Entering evaporator temperature"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));
equation
  connect(chi.on, on.y) annotation (Line(points={{-41,2},{-100,2},{-100,30},{-108,
          30}},
        color={255,0,255}));
  connect(conPum.ports[1], chi.port_a1) annotation (Line(points={{-50,42},{-42,42},
          {-42,6},{-40,6}}, color={0,127,255}));
  connect(chi.port_b1, heaBou.ports[1])
    annotation (Line(points={{-20,6},{-10,6},{-10,40},{0,40}},
                                             color={0,127,255}));
  connect(bouCoo.ports[1], pum.port_a)
    annotation (Line(points={{-90,-60},{-60,-60}}, color={0,127,255}));
  connect(proSou.port_a, pum.port_b)
    annotation (Line(points={{-20,-60},{-40,-60}},color={0,127,255}));
  connect(proSou.port_b, chi.port_a2) annotation (Line(points={{0,-60},{10,-60},
          {10,-6},{-20,-6}},color={0,127,255}));
  connect(pum.port_a, chi.port_b2) annotation (Line(points={{-60,-60},{-70,-60},
          {-70,-6},{-40,-6}}, color={0,127,255}));
  connect(TSet.y, chi.TSet)
    annotation (Line(points={{-108,-2},{-41,-2}},color={0,0,127}));
  connect(chi.QEva_flow, gai.u) annotation (Line(points={{-19,-8.6},{34,-8.6},{34,
          -40},{50,-40}},    color={0,0,127}));
  connect(QEva_P.u2, chi.P) annotation (Line(points={{88,-26},{74,-26},{74,-2},{
          -19,-2}}, color={0,0,127}));
  connect(QEva_QGen.u2, chi.QGen_flow)
    annotation (Line(points={{88,4},{34,4},{34,2},{-19,2}}, color={0,0,127}));
  connect(gai.y, QEva_P.u1) annotation (Line(points={{74,-40},{80,-40},{80,-14},
          {88,-14}}, color={0,0,127}));
  connect(gai.y, QEva_QGen.u1) annotation (Line(points={{74,-40},{80,-40},{80,16},
          {88,16}}, color={0,0,127}));
  connect(mPum_flow.y, pum.m_flow_in)
    annotation (Line(points={{-78,-30},{-50,-30},{-50,-48}}, color={0,0,127}));
  connect(TEnt.y, proSou.T_in)
    annotation (Line(points={{-18,-30},{-14,-30},{-14,-48}}, color={0,0,127}));
   annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-100,-102},{100,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-30,64},{70,4},{-30,-56},{-30,64}})}),
   Diagram(coordinateSystem(extent={{-140,-100},{120,100}})),
  __Dymola_Commands(file= "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/Examples/AbsorptionIndirectSteamVaryingLoad.mos"
        "Simulate and plot"),
    experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-06),
  Documentation(info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.Fluid.Chillers.AbsorptionIndirectSteam\">
Buildings.Fluid.Chillers.AbsorptionIndirectSteam</a>.
for the case with varying cooling load.
</p>
<p>
The model is constructed in a way that the temperatures which determine the performance of
the absorption chiller are kept constant in order to monitor the effects of the part load
behavior on the ratio of the provided cooling to the required steam.
</p>
</html>", revisions="<html>
<ul>
<li>
December 13, 2019, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end AbsorptionIndirectSteamVaryingLoad;
