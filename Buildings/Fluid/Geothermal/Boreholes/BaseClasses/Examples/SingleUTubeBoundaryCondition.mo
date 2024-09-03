within Buildings.Fluid.Geothermal.Boreholes.BaseClasses.Examples;
model SingleUTubeBoundaryCondition
  "Test model the temperature boundary condition of a single U tube heat exchanger"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.HeatFlowRate Q_flow=-50
    "Heat flow rate extracted at center of cylinder";
  Buildings.Fluid.Geothermal.Boreholes.BaseClasses.SingleUTubeBoundaryCondition
      TBouSte(
      final rExt=3,
      final samplePeriod=604800,
      hSeg=1,
      redeclare final Buildings.HeatTransfer.Data.Soil.Sandstone matSoi,
      TExt_start=293.15) "Boundary condition"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));
 Modelica.Blocks.Sources.Step step(
    height=Q_flow,
    offset=0,
    startTime=0)
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Fluid.Geothermal.Boreholes.BaseClasses.SingleUTubeBoundaryCondition
    TBouCon(
    final rExt=3,
    final samplePeriod=604800,
    hSeg=1,
    redeclare final Buildings.HeatTransfer.Data.Soil.Sandstone matSoi,
    TExt_start=293.15) "Boundary condition"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));
 Modelica.Blocks.Sources.Constant con(k=Q_flow)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Fluid.Geothermal.Boreholes.BaseClasses.SingleUTubeBoundaryCondition
    TBouPul(
    final rExt=3,
    final samplePeriod=604800,
    hSeg=1,
    redeclare final Buildings.HeatTransfer.Data.Soil.Sandstone matSoi,
    TExt_start=293.15) "Boundary condition"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
 Modelica.Blocks.Sources.Pulse pulse(
    offset=0,
    startTime=0,
    amplitude=2*Q_flow,
    period=7200)
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
equation
  connect(con.y, TBouCon.Q_flow) annotation (Line(
      points={{-39,70},{-30,70},{-30,62},{-20,62}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(step.y, TBouSte.Q_flow) annotation (Line(
      points={{-39,30},{-30,30},{-30,22},{-20,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pulse.y, TBouPul.Q_flow) annotation (Line(
      points={{-39,-10},{-30,-10},{-30,-18},{-20,-18}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (
experiment(Tolerance=1e-6, StopTime=1.5768e+08),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Boreholes/BaseClasses/Examples/SingleUTubeBoundaryCondition.mos"
        "Simulate and plot"),
    Documentation(info="<html>
This example tests the temperature boundary condition at the external part of a cylinder.

</html>", revisions="<html>
<ul>
<li>
April 14 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end SingleUTubeBoundaryCondition;
