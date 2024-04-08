within Buildings.Fluid.Chillers.ModularReversible.Examples;
model Modular
  "Example for modular reversible chiller"
  extends Modelica.Icons.Example;
  package MediumCon = Buildings.Media.Air "Medium model for condenser";
  package MediumEva = Buildings.Media.Water "Medium model for evaporator";

  Buildings.Fluid.Chillers.ModularReversible.Modular chi(
    redeclare package MediumCon = MediumCon,
    redeclare package MediumEva = MediumEva,
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
    redeclare model RefrigerantCycleChillerCooling =
        Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.ConstantCarnotEffectiveness
        (etaCarnot_nominal=0.35),
    redeclare model RefrigerantCycleChillerHeating =
        Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.TableData2D (
          redeclare
          Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal, datTab=
            Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08()))
                 "Modular reversible chiller instance"
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
  Modelica.Blocks.Sources.BooleanStep chiCoo(startTime=2100, startValue=true)
    "Chilling mode on"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(souCon.ports[1], chi.port_a1) annotation (Line(
      points={{-40,16},{0,16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(souEva.ports[1], chi.port_a2) annotation (Line(
      points={{40,4},{20,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(chi.port_b1, sinCon.ports[1]) annotation (Line(
      points={{20,16},{30,16},{30,40},{60,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sinEva.ports[1], chi.port_b2) annotation (Line(
      points={{-40,-20},{-10,-20},{-10,4},{0,4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TConIn.y, souCon.T_in) annotation (Line(
      points={{-69,20},{-62,20}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TEvaIn.y, souEva.T_in) annotation (Line(
      points={{75,-30},{80,-30},{80,8},{62,8}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(ySet.y, chi.ySet) annotation (Line(points={{-39,60},{-16,60},{-16,12},{
          -1.2,12}},                color={0,0,127}));
  connect(chiCoo.y, chi.coo) annotation (Line(points={{-39,-50},{-22,-50},{-22,
          7.9},{-1.1,7.9}}, color={255,0,255}));
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
</html>"));
end Modular;
