within Buildings.Fluid.Movers.Validation;
model PressureCurve "Displays the pressure curve of the mover"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Air "Medium model";

  parameter Modelica.Units.SI.Density rho_default=
    Medium.density_pTX(
      p=Medium.p_default,
      T=Medium.T_default,
      X=Medium.X_default) "Default medium density";
  parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(V_flow={0.945419103313839, 2.83300844704353, 4.71734892787522},
                 dp={ 3010.50788091068, 2632.22416812609, 830.122591943958}))
    "Performance data"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));

  Buildings.Fluid.Movers.SpeedControlled_y mov(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    per=per,
    addPowerToMedium=false,
    y_start=1) "Mover"
    annotation (Placement(transformation(extent={{0,-20},{20,0}})));
  Modelica.Blocks.Sources.Constant one(final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.Sources.MassFlowSource_T bou1(
    redeclare final package Medium = Medium,
    final use_m_flow_in=true,
    nPorts=1) "Boundary that forces a mass flow rate"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
  Modelica.Blocks.Sources.Ramp ram(
    height=per.V_flow_max*rho_default,
    duration=1,
    offset=0) "Ramp signal"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Fluid.Sources.Boundary_pT bou2(
    redeclare final package Medium = Medium,
    nPorts=1) "Boundary"
    annotation (Placement(transformation(extent={{80,-20},{60,0}})));

equation
  connect(one.y, mov.y)
    annotation (Line(points={{-19,30},{10,30},{10,2}},   color={0,0,127}));
  connect(ram.y, bou1.m_flow_in) annotation (Line(points={{-79,30},{-70,30},{-70,
          -2},{-62,-2}}, color={0,0,127}));
  connect(bou1.ports[1], mov.port_a)
    annotation (Line(points={{-40,-10},{0,-10}}, color={0,127,255}));
  connect(mov.port_b, bou2.ports[1])
    annotation (Line(points={{20,-10},{60,-10}}, color={0,127,255}));
  annotation (experiment(Tolerance=1e-6, StopTime=1),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Movers/Validation/PressureCurve.mos"
        "Simulate and plot"),
        Documentation(info="
<html>
<p>
This model validates the pressure curve that is specified in the instance <code>per</code>
and provided to the mover.
</p>
</html>", revisions="<html>
<ul>
<li>
May 1, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3371\">#3371</a>.
</li>
</ul>
</html>"));
end PressureCurve;
