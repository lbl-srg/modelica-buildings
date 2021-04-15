within Buildings.Airflow.Multizone.Examples;
model Orifice "Model with an orifice"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;
  Buildings.Airflow.Multizone.Orifice ori(redeclare package Medium = Medium, A=
        0.2) "Orifice"
             annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Fluid.Sources.Boundary_pT roo1(
    redeclare package Medium = Medium,
    use_p_in=true,
    nPorts=1,
    T=278.15) "Pressure boundary condition"
              annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Fluid.Sources.Boundary_pT roo2(
    redeclare package Medium = Medium,
    use_p_in=true,
    nPorts=1,
    T=293.15) "Pressure boundary condition"
              annotation (Placement(transformation(
        origin={70,30},
        extent={{-10,-10},{10,10}},
        rotation=180)));
  Modelica.Blocks.Sources.Ramp ram(
    duration=0.5,
    height=2,
    offset=-1,
    startTime=0.25) "Ramp signal for pressure boundary condition"
    annotation (Placement(transformation(extent={{0,-48},{20,-28}})));
  Modelica.Blocks.Sources.Constant preBou(k=100000)
    "Constant pressure boundary condition"
    annotation (Placement(transformation(extent={{-92,-20},{-72,0}})));
  Modelica.Blocks.Math.Add add "Adder for pressure boundary condition"
    annotation (Placement(transformation(extent={{44,-30},{64,-10}})));
  Buildings.Fluid.Sensors.DensityTwoPort den1(
    redeclare package Medium = Medium,
    m_flow_nominal=0.1,
    initType=Modelica.Blocks.Types.Init.InitialState) "Density sensor"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));
  Buildings.Fluid.Sensors.DensityTwoPort den2(
    redeclare package Medium = Medium,
    m_flow_nominal=0.1,
    initType=Modelica.Blocks.Types.Init.InitialState) "Density sensor"
    annotation (Placement(transformation(extent={{30,20},{50,40}})));
equation
  connect(preBou.y, add.u1) annotation (Line(points={{-71,-10},{-42,-10},{-42,
          -14},{42,-14}}, color={0,0,255}));
  connect(ram.y, add.u2) annotation (Line(points={{21,-38},{26,-38},{26,-26},{
          42,-26}}, color={0,0,255}));
  connect(preBou.y, roo1.p_in) annotation (Line(points={{-71,-10},{-68,-10},{
          -68,38},{-62,38}}, color={0,0,127}));
  connect(add.y, roo2.p_in) annotation (Line(points={{65,-20},{90,-20},{90,22},
          {82,22}}, color={0,0,127}));
  connect(roo1.ports[1], den1.port_a) annotation (Line(
      points={{-40,30},{-30,30}},
      color={0,127,255}));
  connect(den1.port_b, ori.port_a) annotation (Line(
      points={{-10,30},{-5.55112e-16,30}},
      color={0,127,255}));
  connect(ori.port_b, den2.port_a) annotation (Line(
      points={{20,30},{30,30}},
      color={0,127,255}));
  connect(den2.port_b, roo2.ports[1]) annotation (Line(
      points={{50,30},{60,30}},
      color={0,127,255}));
  annotation (
experiment(Tolerance=1e-06, StopTime=1),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/Orifice.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model demonstrates the use of the orifice model.
The pressure difference across the orifice model changes
between <i>-1</i> Pascal and <i>+1</i> Pascal, which
causes air to flow through the orifice.
</p>
</html>", revisions="<html>
<ul>
<li>
March 26, 2021 by Michael Wetter:<br/>
Updated comments for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/515\">IBPSA, #515</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
November 10, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end Orifice;
