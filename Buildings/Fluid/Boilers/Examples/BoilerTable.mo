within Buildings.Fluid.Boilers.Examples;
model BoilerTable
 "Boilers with efficiency curves specified by look-up table"
 extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Water "Medium model";
 parameter Modelica.SIunits.Power Q_flow_nominal = 3000 "Nominal power";
 parameter Modelica.SIunits.Temperature dT_nominal = 20
    "Nominal temperature difference";
 parameter Modelica.SIunits.MassFlowRate
 m_flow_nominal = Q_flow_nominal/dT_nominal/4200
    "Nominal mass flow rate";
 parameter Modelica.SIunits.PressureDifference dp_nominal = 3000
    "Pressure drop at m_flow_nominal";
 parameter Real effCur[:,:]=
        [0,   294.3,299.8,305.4,310.9,316.5,322.0,327.6,333.2,338.7,344.3;
         0.05,0.991,0.984,0.974,0.959,0.940,0.920,0.900,0.887,0.881,0.880;
          0.5,0.988,0.981,0.969,0.952,0.932,0.908,0.890,0.883,0.879,0.878;
            1,0.969,0.962,0.951,0.935,0.918,0.897,0.885,0.879,0.875,0.874]
        "Efficiency table: First row = inlet temp(K), First column = firing rates or PLR";

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=3,
    p(displayUnit="Pa") = 300000,
    T=354.15) "Sink"
    annotation (Placement(transformation(extent={{72,-16},{52,4}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    p=300000 + dp_nominal,
    use_T_in=true,
    nPorts=4) "Source"
    annotation (Placement(transformation(extent={{-64,-16},{-44,4}})));
  Buildings.Fluid.Boilers.BoilerTable boi1(
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal=dp_nominal,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    from_dp=true,
    T_start=293.15,
    effCur=effCur,
    smo=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    ext=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    T_inlet_nominal=323.15) "Boiler 1 set at 5% firing rate"
    annotation (Placement(transformation(extent={{10,44},{30,64}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TAmb1(      T=288.15)
    "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{-10,72},{10,92}})));
  Buildings.Fluid.Boilers.BoilerTable boi2(
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal=dp_nominal,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    from_dp=true,
    T_start=293.15,
    effCur=effCur,
    smo=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    ext=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    T_inlet_nominal=323.15) "Boiler 2 set at 50% firing rate"
    annotation (Placement(transformation(extent={{10,-16},{30,4}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TAmb2(      T=288.15)
    "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{-10,12},{10,32}})));
  Buildings.Fluid.Boilers.BoilerTable boi3(
    Q_flow_nominal=Q_flow_nominal,
    m_flow_nominal=m_flow_nominal,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    massDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    dp_nominal=dp_nominal,
    fue=Buildings.Fluid.Data.Fuels.NaturalGasLowerHeatingValue(),
    from_dp=true,
    T_start=293.15,
    effCur=effCur,
    smo=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    ext=Modelica.Blocks.Types.Extrapolation.HoldLastPoint,
    T_inlet_nominal=323.15) "Boiler 3 set at 100% firing rate"
    annotation (Placement(transformation(extent={{10,-76},{30,-56}})));
  HeatTransfer.Sources.FixedTemperature           TAmb3(T=288.15)
    "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{-10,-48},{10,-28}})));
  Sensors.Temperature senTem(
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-54,40},{-34,60}})));
  Modelica.Blocks.Sources.TimeTable y1(table=[0,0.05; 3600,0.05])
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Modelica.Blocks.Sources.TimeTable y2(table=[0,0.5; 3600,0.5])
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Modelica.Blocks.Sources.TimeTable y3(table=[0,1; 3600,1])
    annotation (Placement(transformation(extent={{-90,-68},{-70,-48}})));
  Modelica.Blocks.Sources.TimeTable T_inlet(table=[0,294.3; 3600,344.3])
    annotation (Placement(transformation(extent={{-58,-50},{-38,-30}})));

equation
  connect(TAmb1.port, boi1.heatPort) annotation (Line(
      points={{10,82},{20,82},{20,61.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAmb2.port, boi2.heatPort) annotation (Line(
      points={{10,22},{20,22},{20,1.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(boi2.port_b, sin.ports[2]) annotation (Line(
      points={{30,-6},{52,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi1.port_b, sin.ports[1]) annotation (Line(
      points={{30,54},{36,54},{36,-3.33333},{52,-3.33333}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TAmb3.port, boi3.heatPort)
    annotation (Line(points={{10,-38},{20,-38},{20,-58.8}}, color={191,0,0}));
  connect(boi3.port_b, sin.ports[3]) annotation (Line(points={{30,-66},{36,-66},
          {36,-8.66667},{52,-8.66667}}, color={0,127,255}));
  connect(boi1.port_a, sou.ports[1]) annotation (Line(points={{10,54},{-26,54},
          {-26,-3},{-44,-3}}, color={0,127,255}));
  connect(boi3.port_a, sou.ports[2]) annotation (Line(points={{10,-66},{-26,-66},
          {-26,-10},{-44,-10},{-44,-5}}, color={0,127,255}));
  connect(senTem.port, sou.ports[3])
    annotation (Line(points={{-44,40},{-44,-7}},  color={0,127,255}));
  connect(boi2.T_inlet, senTem.T) annotation (Line(points={{8,-10.4},{-4,-10.4},
          {-4,-10},{-14,-10},{-14,50},{-37,50}},
                                              color={0,0,127}));
  connect(boi3.T_inlet, senTem.T) annotation (Line(points={{8,-70.4},{-14,-70.4},
          {-14,50},{-37,50}}, color={0,0,127}));
  connect(y1.y, boi1.y) annotation (Line(points={{-69,80},{-16,80},{-16,62},{8,
          62}}, color={0,0,127}));
  connect(y2.y, boi2.y) annotation (Line(points={{-69,20},{-20,20},{-20,2},{8,2}},
        color={0,0,127}));
  connect(y3.y, boi3.y)
    annotation (Line(points={{-69,-58},{8,-58}}, color={0,0,127}));
  connect(T_inlet.y, sou.T_in) annotation (Line(points={{-37,-40},{-32,-40},{
          -32,-24},{-72,-24},{-72,-2},{-66,-2}},  color={0,0,127}));
  connect(boi1.T_inlet, senTem.T) annotation (Line(points={{8,49.6},{-4,49.6},{
          -4,50},{-37,50}},   color={0,0,127}));
  connect(boi2.port_a, sou.ports[4])
    annotation (Line(points={{10,-6},{-44,-6}}, color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/Examples/BoilerTable.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=3600),
    Documentation(info="<html>
<p>    
This simple model displays the efficiency curves supplied to it. 
</p>
</html>", revisions="<html>
<ul>
<li>
October 7, 2021, by Hongxiang Fu:<br/>
First implementation. This is for 
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>.
</li>
</ul>
</html>"));
end BoilerTable;
