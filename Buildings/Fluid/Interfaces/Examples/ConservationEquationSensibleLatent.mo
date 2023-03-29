within Buildings.Fluid.Interfaces.Examples;
model ConservationEquationSensibleLatent
  "Model that tests the conservation equation for sensible and latent heat input"
extends Modelica.Icons.Example;
 package Medium = Buildings.Media.Air "Medium model";

  constant Modelica.Units.SI.SpecificEnergy h_fg=
      Buildings.Media.Air.enthalpyOfCondensingGas(273.15 + 37)
    "Latent heat of water vapor";

  Buildings.Fluid.Interfaces.ConservationEquation dynBal(
    simplify_mWat_flow=true,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    fluidVolume=1,
    use_mWat_flow=true,
    nPorts=2) "Dynamic conservation equation"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    use_p_in=false,
    redeclare package Medium = Medium,
    p=101325,
    T=283.15,
    nPorts=1) annotation (Placement(
        transformation(extent={{80,-40},{60,-20}})));
  Buildings.Fluid.Sources.MassFlowSource_T bou(
    redeclare package Medium = Medium,
    m_flow=0.1,
    nPorts=1)    "Boundary condition for mass flow rate"
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));

  Modelica.Blocks.Sources.Step QSen_flow(height=1000,startTime=900)
    "Sensible heat flow rate"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Sources.Step QLat_flow(height=1000, startTime=1800)
    "Latent heat flow rate"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Math.Add QTot_flow "Total heat flow rate"
    annotation (Placement(transformation(extent={{-20,24},{0,44}})));
protected
  Modelica.Blocks.Math.Gain mWat_flow(
    final k(unit="kg/J") = 1/h_fg,
    u(final unit="W"),
    y(final unit="kg/s")) "Water flow rate due to latent heat gain"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
equation

  connect(mWat_flow.y, dynBal.mWat_flow)
    annotation (Line(points={{1,0},{8,0},{8,12},{18,12}},   color={0,0,127}));
  connect(dynBal.Q_flow, QTot_flow.y) annotation (Line(points={{18,16},{8,16},{8,
          34},{1,34}},    color={0,0,127}));
  connect(QTot_flow.u1, QSen_flow.y) annotation (Line(points={{-22,40},{-59,40}},
                              color={0,0,127}));
  connect(QTot_flow.u2, QLat_flow.y) annotation (Line(points={{-22,28},{-40,28},
          {-40,0},{-59,0}},   color={0,0,127}));
  connect(QLat_flow.y, mWat_flow.u)
    annotation (Line(points={{-59,0},{-22,0}},   color={0,0,127}));
  connect(bou.ports[1], dynBal.ports[1])
    annotation (Line(points={{-60,-30},{29,-30},{29,0}}, color={0,127,255}));
  connect(dynBal.ports[2], sin.ports[1]) annotation (Line(points={{31,0},{32,0},
          {32,-30},{60,-30}}, color={0,127,255}));
  annotation (
  experiment(
      StopTime=2700,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Interfaces/Examples/ConservationEquationSensibleLatent.mos"
        "Simulate and plot"),
      Documentation(info="<html>
<p>
Validation model that injects into an air volume first sensible heat and then sensible plus latent heat
</p>
<p>
The air volume has a constant air mass flow rate. When adding the latent heat, its
temperature remains constant, excpet for some small approximation error because
the control volume has its constant set to <code>simplify_mWat_flow</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2023, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3317\">#3317</a>.
</li>
</ul>
</html>"));
end ConservationEquationSensibleLatent;
