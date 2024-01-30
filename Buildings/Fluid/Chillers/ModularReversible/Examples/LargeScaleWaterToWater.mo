within Buildings.Fluid.Chillers.ModularReversible.Examples;
model LargeScaleWaterToWater
  "Example for large scale water to water chiller"
  extends Modelica.Icons.Example;
  package MediumCon = Buildings.Media.Water "Medium model for condenser";
  package MediumEva = Buildings.Media.Water "Medium model for evaporator";

  Buildings.Fluid.Chillers.ModularReversible.LargeScaleWaterToWater chi(
    redeclare
      Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.EN14511.Carrier30XWP1012_1MW
      datTab,
    redeclare Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
      safCtrParEurNor,
    redeclare package MediumCon = MediumCon,
    redeclare package MediumEva = MediumEva,
    QCoo_flow_nominal=-1000000,
    TCon_nominal=313.15,
    dpCon_nominal(displayUnit="Pa") = 6000,
    TEva_nominal=278.15,
    dpEva_nominal(displayUnit="Pa") = 6000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Large scale water to water chiller"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T souCon(
    nPorts=1,
    redeclare package Medium = MediumCon,
    use_T_in=true,
    m_flow=chi.mCon_flow_nominal,
    T=298.15) "Condenser source"
    annotation (Placement(transformation(extent={{-60,6},{-40,26}})));
  Buildings.Fluid.Sources.MassFlowSource_T souEva(
    nPorts=1,
    redeclare package Medium = MediumEva,
    use_T_in=true,
    m_flow=chi.mEva_flow_nominal,
    T=291.15) "Evaporator source"
    annotation (Placement(transformation(extent={{60,-6},{40,14}})));
  Buildings.Fluid.Sources.Boundary_pT sinCon(nPorts=1, redeclare package Medium =
        MediumCon) "Condenser sink" annotation (Placement(transformation(extent={{
            10,-10},{-10,10}}, origin={70,40})));
  Buildings.Fluid.Sources.Boundary_pT sinEva(nPorts=1, redeclare package Medium =
        MediumEva) "Evaporator sink" annotation (Placement(transformation(extent={
            {-10,-10},{10,10}}, origin={-50,-20})));
  Modelica.Blocks.Sources.Ramp ySet(
    height=-1,
    duration=900,
    offset=1,
    startTime=1800) "Compressor control signal"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Modelica.Blocks.Sources.Ramp TConIn(
    height=10,
    duration=60,
    offset=273.15 + 30,
    startTime=60) "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-90,10},{-70,30}})));
  Modelica.Blocks.Sources.Ramp TEvaIn(
    height=10,
    duration=60,
    startTime=900,
    offset=273.15 + 15) "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{52,-40},{72,-20}})));
equation
  connect(souCon.ports[1], chi.port_a1) annotation (Line(
      points={{-40,16},{-20,16},{-20,15},{-5.55112e-16,15}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(souEva.ports[1], chi.port_a2) annotation (Line(
      points={{40,4},{30,4},{30,5},{20,5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.port_b1, sinCon.ports[1]) annotation (Line(
      points={{20,15},{30,15},{30,40},{60,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sinEva.ports[1], chi.port_b2) annotation (Line(
      points={{-40,-20},{-10,-20},{-10,5},{-5.55112e-16,5}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TConIn.y, souCon.T_in) annotation (Line(
      points={{-69,20},{-62,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEvaIn.y, souEva.T_in) annotation (Line(
      points={{73,-30},{80,-30},{80,8},{62,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ySet.y, chi.ySet) annotation (Line(points={{-39,60},{-16,60},{-16,
          11.6667},{-1.6,11.6667}},          color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/ModularReversible/Examples/LargeScaleWaterToWater.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
</ul>
</html>", info="<html>
<p>
  Example that simulates a chiller based on the modular reversible approach
  using the
  <a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.LargeScaleWaterToWater\">
  Buildings.Fluid.Chillers.ModularReversible.LargeScaleWaterToWater</a>.
  model directly.
  The chiller control signal is the compressor speed
  <code>ySet</code> and the mode <code>coo</code>.
</p>
<p>
  As the model contains internal safety controls, the
  compressor set speed <code>ySet</code> and actually applied
  speed <code>yOut</code> are plotted to show the influence of
  the safety control.
</p>

</html>"));
end LargeScaleWaterToWater;
