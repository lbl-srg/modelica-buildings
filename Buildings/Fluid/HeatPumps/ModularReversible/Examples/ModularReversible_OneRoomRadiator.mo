within Buildings.Fluid.HeatPumps.ModularReversible.Examples;
model ModularReversible_OneRoomRadiator
  "Modular reversible heat pump connected to a simple room model with radiator"
  extends
    Buildings.Fluid.HeatPumps.ModularReversible.Examples.BaseClasses.PartialOneRoomRadiator(
    mEva_flow_nominal=heaPum.mEva_flow_nominal,
    sin(nPorts=1, redeclare package Medium = MediumAir),
    pumHeaPumSou(redeclare package Medium = MediumAir),
    sou(redeclare package Medium = MediumAir),
    booToReaPumEva(realTrue=heaPum.mEva_flow_nominal));
  extends Modelica.Icons.Example;

  Buildings.Fluid.HeatPumps.ModularReversible.ModularReversible heaPum(
    redeclare package MediumCon = MediumWat,
    redeclare package MediumEva = MediumAir,
    QHea_flow_nominal=Q_flow_nominal,
    redeclare model RefrigerantCycleInertia =
        Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Inertias.NoInertia,
    use_intSafCtr=true,
    TCon_nominal=TRadSup_nominal,
    dTCon_nominal=TRadSup_nominal - TRadRet_nominal,
    dpCon_nominal(displayUnit="Pa") = 2000,
    use_conCap=true,
    CCon=3000,
    GConOut=100,
    GConIns=1000,
    TEva_nominal=sou.T,
    dTEva_nominal=2,
    dpEva_nominal(displayUnit="Pa") = 200,
    use_evaCap=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare model RefrigerantCycleHeatPumpHeating =
        Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.ConstantCarnotEffectiveness
        (
        redeclare
          Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting
          iceFacCal,
        TAppCon_nominal=0,
        TAppEva_nominal=0),
    redeclare model RefrigerantCycleHeatPumpCooling =
        Buildings.Fluid.Chillers.ModularReversible.RefrigerantCycle.TableData2D (
          redeclare
          Buildings.Fluid.HeatPumps.ModularReversible.RefrigerantCycle.Frosting.NoFrosting iceFacCal,
          datTab=Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.EN14511.Vitocal251A08()),
    redeclare Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
      safCtrPar(
      use_TUseSidOut=true,
      use_TAmbSidOut=false,
      use_antFre=true,
      TAntFre=275.15),
    QCoo_flow_nominal=-Q_flow_nominal*0.5)
                       "Modular reversible heat pump"
    annotation (Placement(transformation(extent={{20,-160},{0,-140}})));

  Modelica.Blocks.Sources.Constant temAmbBas(final k(
      final unit="K",
      displayUnit="degC") = 291.15)
    "Ambient temperature in basement of building" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-90,-148})));
equation
  connect(heaPum.port_b2, sin.ports[1]) annotation (Line(points={{20,-156},{38,-156},
          {38,-200},{60,-200}},           color={0,127,255}));
  connect(heaPum.port_a2, pumHeaPumSou.port_b) annotation (Line(points={{0,-156},{
          -30,-156},{-30,-170}},        color={0,127,255}));
  connect(heaPum.port_b1, pumHeaPum.port_a) annotation (Line(points={{0,-144},{-70,
          -144},{-70,-120}},      color={0,127,255}));
  connect(heaPum.port_a1, temRet.port_b) annotation (Line(points={{20,-144},{60,-144},
          {60,-30}},           color={0,127,255}));
  connect(temAmbBas.y, heaPum.TConAmb) annotation (Line(points={{-79,-148},{-1,-148},
          {-1,-147.6}},                   color={0,0,127}));
  connect(heaPum.hea, oneRooRadHeaPumCtr.hea) annotation (Line(points={{21.1,-151.9},
          {24,-151.9},{24,-152},{26,-152},{26,-92},{-132,-92},{-132,-76},{-139,-76}},
                 color={255,0,255}));
  connect(oneRooRadHeaPumCtr.ySet, heaPum.ySet) annotation (Line(points={{-139,-66},
          {30,-66},{30,-148},{21.2,-148}},            color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
  This example demonstrates how to use the
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.ModularReversible\">
  Buildings.Fluid.HeatPumps.ModularReversible.ModularReversible</a>
  heat pump model directly. Please check the associated documentation for
  further information.
</p>
<p>
  Correct replacement of the replaceable submodels
  and, thus, flexible aggregation to a new model
  approach is demonstrated.
</p>
<p>
  Please check the documentation of
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.Examples.BaseClasses.PartialOneRoomRadiator\">
  Buildings.Fluid.HeatPumps.ModularReversible.Examples.BaseClasses.PartialOneRoomRadiator</a>
  for further information on the example.
</p>
</html>", revisions="<html>
<ul>
<li>
  <i>October 2, 2022</i> by Fabian Wuellhorst:<br/>
  First implementation (see issue <a href=
  \"https://github.com/ibpsa/modelica-ibpsa/issues/1576\">#1576</a>)
</li>
</ul>
</html>"),
   __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Examples/ModularReversible_OneRoomRadiator.mos"
        "Simulate and plot"),
  experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-08));
end ModularReversible_OneRoomRadiator;
