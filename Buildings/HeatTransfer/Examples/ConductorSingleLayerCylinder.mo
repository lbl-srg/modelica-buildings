within Buildings.HeatTransfer.Examples;
model ConductorSingleLayerCylinder
  "Test model for heat conduction in a cylinder"
  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.HeatFlowRate Q_flow=50;
  Buildings.HeatTransfer.Conduction.SingleLayerCylinder
                     con( material=concrete,
                     steadyStateInitial=false,
                     final nSta=8,
                     r_a=0.1,
                     r_b=3,
    h=10,
    TInt_start=293.15,
    TExt_start=293.15)
         annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow Qa
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  parameter Buildings.HeatTransfer.Data.Soil.Concrete concrete
    annotation (Placement(transformation(extent={{14,60},{40,86}})));
 Modelica.Blocks.Sources.Step step(
    offset=0,
    height=Q_flow,
    startTime=3600)
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.HeatTransfer.Sources.FixedTemperature TBou(T=293.15)
    "Boundary condition"
    annotation (Placement(transformation(extent={{60,20},{40,40}})));
equation
  connect(Qa.port, con.port_a) annotation (Line(
      points={{-20,30},{-5.55112e-16,30}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(step.y, Qa.Q_flow) annotation (Line(
      points={{-59,30},{-40,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(TBou.port, con.port_b)             annotation (Line(
      points={{40,30},{20,30}},
      color={191,0,0},
      smooth=Smooth.None));
  annotation (
experiment(Tolerance=1e-6, StopTime=36000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/HeatTransfer/Examples/ConductorSingleLayerCylinder.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This example tests a circular conductor with a constant temperature at his boundary.
</p>
</html>", revisions="<html>
<ul>
<li>
April 14 2011, by Pierre Vigouroux:<br/>
First implementation.
</li>
</ul>
</html>"));
end ConductorSingleLayerCylinder;
