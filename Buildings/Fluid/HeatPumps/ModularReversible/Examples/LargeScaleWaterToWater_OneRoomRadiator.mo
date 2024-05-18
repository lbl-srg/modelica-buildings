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
    pumHeaPumSou(dp_nominal=150000),
    pumHeaPum(dp_nominal=150000),
    sou(use_T_in=true));
    pumHeaPumSou(dp_nominal=150000),
    pumHeaPum(dp_nominal=150000),
    sou(use_T_in=true));

  Buildings.Fluid.HeatPumps.ModularReversible.LargeScaleWaterToWater heaPum(
    allowDifferentDeviceIdentifiers=true,
    QHea_flow_nominal=Q_flow_nominal,
    use_intSafCtr=true,
    QCoo_flow_nominal=-Q_flow_nominal/2,
    QCoo_flow_nominal=-Q_flow_nominal/2,
    TConHea_nominal=TRadSup_nominal,
    dpCon_nominal(displayUnit="Pa"),
    TEvaHea_nominal=sou.T,
    dpEva_nominal(displayUnit="Pa"),
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    redeclare Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.Data.Wuellhorst2021
      safCtrPar,
    TConCoo_nominal=oneRooRadHeaPumCtr.TRadMinSup,
    TEvaCoo_nominal=sou.T + 30,
    TEvaCoo_nominal=sou.T + 30,
    redeclare
      Buildings.Fluid.HeatPumps.ModularReversible.Data.TableData2D.EN14511.WAMAK_WaterToWater_220kW
      datTabHea,
    redeclare
      Buildings.Fluid.Chillers.ModularReversible.Data.TableData2D.EN14511.Carrier30XWP1012_1MW
      datTabCoo)
    "Large scale water to water heat pump"
    annotation (Placement(transformation(extent={{20,-160},{0,-140}})));
  Modelica.Blocks.Sources.Pulse TAirSouSte(
    amplitude=20,
    width=10,
    period=86400,
    offset=283.15,
    startTime=86400/2) if witCoo "Air source temperature step for cooling phase"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,-200})));
  Modelica.Blocks.Sources.Pulse TAirSouSte(
    amplitude=20,
    width=10,
    period=86400,
    offset=283.15,
    startTime=86400/2) if witCoo "Air source temperature step for cooling phase"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-150,-200})));
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
        points={{-139.167,-66.6667},{26,-66.6667},{26,-148.1},{21.1,-148.1}},
        points={{-139.167,-66.6667},{26,-66.6667},{26,-148.1},{21.1,-148.1}},
                                                                        color={
          0,0,127}));
  connect(oneRooRadHeaPumCtr.hea, heaPum.hea) annotation (Line(points={{
          -139.167,-75},{32,-75},{32,-152.1},{21.1,-152.1}}, color={255,0,255}));
  connect(TAirSouSte.y, sou.T_in) annotation (Line(points={{-139,-200},{-92,-200},
          {-92,-196},{-82,-196}}, color={0,0,127}));
          -139.167,-75},{32,-75},{32,-152.1},{21.1,-152.1}}, color={255,0,255}));
  connect(TAirSouSte.y, sou.T_in) annotation (Line(points={{-139,-200},{-92,-200},
          {-92,-196},{-82,-196}}, color={0,0,127}));
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
  are raised if two devices are combined with different sizes, leading
  to different scaling factors for heating and cooling operation.
  If the default <code>QCoo_flow_nominal</code> is used (leading to 
  the same scaling factors), the mass flow rates will differ.
  Setting the parameter <code>allowDifferentDeviceIdentifiers</code> to false,
  an additional warning is raised, indicating that the table data for cooling and 
  heating operation do not originate from the same real device.
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
    Diagram(coordinateSystem(extent={{-240,-220},{100,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end LargeScaleWaterToWater_OneRoomRadiator;
