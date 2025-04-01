within Buildings.Fluid.HeatPumps.ModularReversible.Examples;
model Modular4PipeExample
  "Example for modular reversible 4-pipe heat pump"
  extends Modelica.Icons.Example;
  package MediumCon = Buildings.Media.Water "Medium model for condenser";
  package MediumEva = Buildings.Media.Water "Medium model for evaporator";
  package MediumAir = Buildings.Media.Air "Medium model for Air";

  Buildings.Fluid.HeatPumps.ModularReversible.Modular4Pipe hp(
    redeclare package MediumCon = MediumCon,
    redeclare package MediumCon1 = MediumAir,
    redeclare package MediumEva = MediumEva,
    use_rev=true,
    allowDifferentDeviceIdentifiers=true,
    dTCon1_nominal=5,
    dpCon1_nominal=6000,
    use_con1Cap=false,
    QCoo_flow_nominal=-30000,
    redeclare model RefrigerantCycleInertia =
        Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.VariableOrder
        (
        refIneFreConst=1/300,
        nthOrd=1,
        initType=Modelica.Blocks.Types.Init.InitialState),
    redeclare
      Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
      safCtrPar(minOffTime=100, use_opeEnv=false),
    TConCoo_nominal=313.15,
    dpCon_nominal(displayUnit="Pa") = 6000,
    use_conCap=false,
    CCon=0,
    GConOut=0,
    GConIns=0,
    TEvaCoo_nominal=278.15,
    dTEva_nominal=5,
    dTCon_nominal=5,
    dpEva_nominal(displayUnit="Pa") = 6000,
    use_evaCap=false,
    CEva=0,
    GEvaOut=0,
    GEvaIns=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    show_T=true,
    QHea_flow_nominal=30000,
    TEvaHea_nominal=303.15,
    TConHea_nominal=298.15) "Modular reversible 4pipe heat pump instance"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Fluid.Sources.MassFlowSource_T souCon(
    nPorts=1,
    redeclare package Medium = MediumCon,
    use_T_in=true,
    m_flow=hp.mCon_flow_nominal,
    T=298.15) "Condenser source"
    annotation (Placement(transformation(extent={{-60,6},{-40,26}})));
  Buildings.Fluid.Sources.MassFlowSource_T souEva(
    nPorts=1,
    redeclare package Medium = MediumEva,
    use_T_in=true,
    m_flow=hp.mEva_flow_nominal,
    T=291.15) "Evaporator source"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Buildings.Fluid.Sources.Boundary_pT sinCon(nPorts=1, redeclare package Medium =
        MediumCon) "Condenser sink" annotation (Placement(transformation(extent={{
            10,-10},{-10,10}}, origin={70,40})));
  Buildings.Fluid.Sources.Boundary_pT sinEva(nPorts=1, redeclare package Medium =
        MediumEva) "Evaporator sink" annotation (Placement(transformation(extent={
            {-10,-10},{10,10}}, origin={-50,-20})));
  Modelica.Blocks.Sources.SawTooth ySet(
    amplitude=-1,
    period=500,
    offset=1,
    startTime=500)  "Compressor control signal"
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
    annotation (Placement(transformation(extent={{54,-40},{74,-20}})));
  Modelica.Blocks.Sources.IntegerTable hpMod(startTime=2100) "Mode on"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Fluid.Sources.Boundary_pT sinAir(nPorts=1, redeclare package Medium
      = MediumAir) "Air sink" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        origin={10,-48},
        rotation=90)));
  Buildings.Fluid.Sources.MassFlowSource_T souAir(
    nPorts=1,
    redeclare package Medium = MediumAir,
    use_T_in=true,
    m_flow=hp.mEva_flow_nominal,
    T=291.15) "Air source"
    annotation (Placement(transformation(extent={{40,62},{20,82}})));
  Modelica.Blocks.Sources.Ramp TAirIn(
    height=10,
    duration=60,
    startTime=900,
    offset=273.15 + 15) "Air inlet temperature"
    annotation (Placement(transformation(extent={{74,66},{54,86}})));
equation
  connect(souCon.ports[1], hp.port_a1) annotation (Line(
      points={{-40,16},{-20,16},{-20,20},{0,20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(souEva.ports[1], hp.port_a2) annotation (Line(
      points={{40,0},{20,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(hp.port_b1, sinCon.ports[1]) annotation (Line(
      points={{20,20},{30,20},{30,40},{60,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sinEva.ports[1], hp.port_b2) annotation (Line(
      points={{-40,-20},{-10,-20},{-10,0},{0,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TConIn.y, souCon.T_in) annotation (Line(
      points={{-69,20},{-62,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEvaIn.y, souEva.T_in) annotation (Line(
      points={{75,-30},{80,-30},{80,4},{62,4}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ySet.y, hp.ySet) annotation (Line(points={{-39,60},{-16,60},{-16,11.9},
          {-1.1,11.9}}, color={0,0,127}));
  connect(souAir.ports[1], hp.port_a3)
    annotation (Line(points={{20,72},{10,72},{10,22}}, color={0,127,255}));
  connect(sinAir.ports[1], hp.port_b3)
    annotation (Line(points={{10,-38},{10,-2.1}}, color={0,127,255}));
  connect(TAirIn.y, souAir.T_in)
    annotation (Line(points={{53,76},{42,76}}, color={0,0,127}));
  connect(hpMod.y, hp.mod) annotation (Line(points={{-39,-50},{-20,-50},{-20,
          7.9},{-1.1,7.9}}, color={255,127,0}));
  annotation (experiment(Tolerance=1e-6, StopTime=3600),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Chillers/ModularReversible/Examples/Modular.mos"
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
  Example that simulates a chiller based on the modular reversible approach.
  The chiller control signal is the compressor speed
  <code>ySet</code> and the mode <code>coo</code>.
</p>
<p>
  As the model contains internal safety controls, the
  compressor set speed <code>ySet</code> and actually applied
  speed <code>yMea</code> are plotted to show the influence of
  the safety control.
</p>
<p>
  The example further demonstrates how to redeclare the replaceable options
  in the model approach
  <a href=\"modelica://Buildings.Fluid.Chillers.ModularReversible.Modular\">
  Buildings.Fluid.Chillers.ModularReversible.Modular</a>.
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-80},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-80},{100,100}})));
end Modular4PipeExample;
