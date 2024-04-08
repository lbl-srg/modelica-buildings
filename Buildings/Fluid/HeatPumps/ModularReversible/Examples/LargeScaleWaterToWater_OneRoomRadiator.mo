within Buildings.Fluid.HeatPumps.ModularReversible.Examples;
model LargeScaleWaterToWater_OneRoomRadiator
  "Large scale water to water heat pump connected to a simple room model with radiator"
  extends Modelica.Icons.Example;
  extends BaseClasses.PartialOneRoomRadiator(
    mEva_flow_nominal=heaPum.mEva_flow_nominal,
    mCon_flow_nominal=heaPum.mCon_flow_nominal,
    V=6*100*3,
    witCoo=true,
    mAirRoo_flow_nominal=V*1.2*6/3600*10,
    Q_flow_nominal=200000,
    sin(nPorts=1),
    booToReaPumEva(realTrue=heaPum.mEva_flow_nominal),
    pumHeaPum(
      redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.VeroLine80slash115dash2comma2slash2 per),
    pumHeaPumSou(
      redeclare Buildings.Fluid.Movers.Data.Pumps.Wilo.VeroLine80slash115dash2comma2slash2 per));

  Buildings.Fluid.HeatPumps.ModularReversible.LargeScaleWaterToWater heaPum(
    QHea_flow_nominal=Q_flow_nominal,
    use_intSafCtr=true,
    TConHea_nominal=TRadSup_nominal,
    dpCon_nominal(displayUnit="Pa"),
    TEvaHea_nominal=sou.T,
    dpEva_nominal(displayUnit="Pa"),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
      safCtrPar,
    TConCoo_nominal=oneRooRadHeaPumCtr.TRadMinSup,
    TEvaCoo_nominal=sou.T + 10,
    redeclare
      Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.WAMAK_WaterToWater_220kW
      datTabHea,
    redeclare
      Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.EN14511.Carrier30XWP1012_1MW
      datTabCoo)
    "Large scale water to water heat pump"
    annotation (Placement(transformation(extent={{20,-160},{0,-140}})));
equation
  connect(heaPum.port_b2, sin.ports[1]) annotation (Line(points={{20,-156},{38,
          -156},{38,-200},{60,-200}},               color={0,127,255}));
  connect(heaPum.port_a2, pumHeaPumSou.port_b) annotation (Line(
        points={{0,-156},{-30,-156},{-30,-170}}, color={0,127,255}));
  connect(heaPum.port_b1, pumHeaPum.port_a) annotation (Line(
        points={{0,-144},{-70,-144},{-70,-120}}, color={0,127,255}));
  connect(heaPum.port_a1, temRet.port_b) annotation (Line(points={{20,-144},{60,
          -144},{60,-30}},                color={0,127,255}));
  connect(oneRooRadHeaPumCtr.ySet, heaPum.ySet) annotation (Line(
        points={{-139.167,-66.6667},{26,-66.6667},{26,-148},{21.2,-148}},
                                                                        color={
          0,0,127}));
  connect(oneRooRadHeaPumCtr.hea, heaPum.hea) annotation (Line(points={{
          -139.167,-75},{32,-75},{32,-151.9},{21.1,-151.9}}, color={255,0,255}));
  annotation (
     __Dymola_Commands(file=
     "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/ModularReversible/Examples/LargeScaleWaterToWater_OneRoomRadiator.mos"
        "Simulate and plot"),
  experiment(
      StartTime=0,
      StopTime=86400,
      Tolerance=1e-08),
  Documentation(
   info="<html>
<p>
  This example demonstrates how to use the
  <a href=\"modelica://Buildings.Fluid.HeatPumps.ModularReversible.LargeScaleWaterToWater\">
  Buildings.Fluid.HeatPumps.ModularReversible.LargeScaleWaterToWater</a>
  heat pump model. Please check the associated documentation for
  further information.
</p>
<p>
  Contrary to the other models, parameters for heat exchanger
  inertia (tau) and mass flow rates are calculated
  automatically based on the heat demand.
</p>
<p>
  Furthermore, this example demonstrates the warnings which
  are raised if the table data boundary conditions
  (e.g. <code>mEva_flow_nominal</code>) deviates from
  the parameter in use.
</p>
<p>
  To fix this issue, the user has to either
</p>
<ol>
<li>
Check the assumption of using a different mass flow rate, or
</li>
<li>
adjust the mass flow rates in the hydraulic system.
If the deviation is too big, the system would also not
work in reality.
</li>
</ol>
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
    Diagram(coordinateSystem(extent={{-240,-220},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end LargeScaleWaterToWater_OneRoomRadiator;
