within Buildings.Fluid.HeatPumps.ModularReversible.Examples;
model ReversibleCarnotWithLosses_OneRoomRadiator
  "Reversible heat pump with Carnot approach connected to a simple room model with radiator"
  extends Examples.BaseClasses.PartialOneRoomRadiator(
    mEva_flow_nominal=heaPum.mEva_flow_nominal,
    mCon_flow_nominal=heaPum.mCon_flow_nominal,
    sin(nPorts=1),
    booToReaPumEva(realTrue=heaPum.mEva_flow_nominal));
  extends Modelica.Icons.Example;

  parameter Real perHeaLos=0.1
    "Percentage of heat losses in the heat exchangers to the nominal heating output";
  Buildings.Fluid.HeatPumps.ModularReversible.ReversibleCarnotWithLosses heaPum(
    redeclare package MediumCon = MediumWat,
    redeclare package MediumEva = MediumWat,
    QHea_flow_nominal=Q_flow_nominal,
    use_rev=true,
    use_intSafCtr=true,
    TCon_nominal=TRadSup_nominal,
    dTCon_nominal=TRadSup_nominal - TRadRet_nominal,
    dpCon_nominal(displayUnit="Pa") = 2000,
    CCon=5000,
    GConOut=perHeaLos*Q_flow_nominal/(TRadSup_nominal - temAmbBas.k),
    GConIns=20000,
    TEva_nominal=sou.T,
    dTEva_nominal=5,
    dpEva_nominal(displayUnit="Pa") = 2000,
    CEva=5000,
    GEvaOut=perHeaLos*Q_flow_nominal/(temAmbBas.k - sou.T),
    GEvaIns=20000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
      safCtrPar,
    QCoo_flow_nominal=-Q_flow_nominal,
    etaCarnot_nominal=0.4)
              "Reversible heat pump with losses and Carnot approach"
    annotation (Placement(transformation(extent={{20,-160},{0,-140}})));
  Modelica.Blocks.Sources.Constant temAmbBas(final k=273.15 + 18)
    "Ambient temperature in basement of building" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={10,-190})));
equation
  connect(heaPum.port_b2, sin.ports[1]) annotation (Line(points={{20,-156},{38,
          -156},{38,-200},{60,-200}},           color={0,127,255}));
  connect(heaPum.port_a2, pumHeaPumSou.port_b) annotation (Line(
        points={{0,-156},{-30,-156},{-30,-170}}, color={0,127,255}));
  connect(heaPum.port_b1, pumHeaPum.port_a) annotation (Line(points={{0,-144},{
          -70,-144},{-70,-120}},           color={0,127,255}));
  connect(heaPum.port_a1, temRet.port_b) annotation (Line(points={{20,-144},{60,
          -144},{60,-30}},           color={0,127,255}));
  connect(temAmbBas.y, heaPum.TEvaAmb) annotation (Line(points={{10,-179},{10,
          -166},{28,-166},{28,-159},{21.2,-159}},         color={0,0,127}));
  connect(temAmbBas.y, heaPum.TConAmb) annotation (Line(points={{10,-179},{10,
          -166},{28,-166},{28,-141},{21.2,-141}},         color={0,0,127}));

  connect(oneRooRadHeaPumCtr.hea, heaPum.hea) annotation (Line(
        points={{-139,-76},{-94,-76},{-94,-166},{28,-166},{28,-151.9},{21.1,
          -151.9}},
        color={255,0,255}));
  connect(oneRooRadHeaPumCtr.ySet, heaPum.ySet) annotation (Line(
        points={{-139,-66},{28,-66},{28,-148},{21.2,-148}}, color={0,0,127}));
  annotation (
   __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Examples/ReversibleCarnotWithLosses_OneRoomRadiator.mos"
        "Simulate and plot"),
  experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-08),
    Documentation(info="<html>
<p>
  This example demonstrates how to use the
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.ReversibleCarnotWithLosses\">
  Buildings.Fluid.HeatPumps.ModularReversible.ReversibleCarnotWithLosses</a>
  heat pump model. Please check the associated documentation for
  further information.
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
</html>"));
end ReversibleCarnotWithLosses_OneRoomRadiator;
