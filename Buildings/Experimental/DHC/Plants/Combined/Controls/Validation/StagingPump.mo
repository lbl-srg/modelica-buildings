within Buildings.Experimental.DHC.Plants.Combined.Controls.Validation;
model StagingPump "Validation of pump staging block"
  extends Modelica.Icons.Example;

  parameter Integer nPum(
    final min=1,
    start=1)=3
    "Number of pumps"
    annotation(Evaluate=true);
  parameter Integer nChi(
    final min=1,
    start=1)=1
    "Number of chillers served by the pumps"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.MassFlowRate mPum_flow_nominal=1
    "Design mass flow rate (each pump)"
    annotation(Dialog(group="Nominal condition"));

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable floSpe(table=[
    0,0,0;
    1,0,0;
    5,nPum*mPum_flow_nominal,1;
    10,0.5,0.1],
    timeScale=500)
    "Source signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  BaseClasses.StagingPumpDetailed staPum(
    final nPum=nPum,
    final nChi=nChi,
    final mPum_flow_nominal=mPum_flow_nominal)
    "Pump staging block"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant yVal(k=1)
    "Source signal"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Pre pre[nPum]
    annotation (Placement(transformation(extent={{10,70},{-10,90}})));
  BaseClasses.StagingPump staPum1(
    final nPum=nPum,
    final nChi=nChi,
    final mPum_flow_nominal=mPum_flow_nominal) "Pump staging block"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
equation
  connect(floSpe.y[1], staPum.m_flow) annotation (Line(points={{-58,40},{-40,40},
          {-40,44},{-12,44}}, color={0,0,127}));
  connect(floSpe.y[2], staPum.y)
    annotation (Line(points={{-58,40},{-12,40}}, color={0,0,127}));
  connect(yVal.y, staPum.yVal[1]) annotation (Line(points={{-58,0},{-20,0},{-20,
          36},{-12,36}}, color={0,0,127}));
  connect(staPum.y1, pre.u) annotation (Line(points={{12,40},{20,40},{20,80},{12,
          80}}, color={255,0,255}));
  connect(pre.y, staPum.y1_actual) annotation (Line(points={{-12,80},{-20,80},{-20,
          48},{-12,48}}, color={255,0,255}));
  connect(floSpe.y[1], staPum1.m_flow) annotation (Line(points={{-58,40},{-40,40},
          {-40,14},{-12,14}}, color={0,0,127}));
  connect(yVal.y, staPum1.yVal[1]) annotation (Line(points={{-58,0},{-20,0},{-20,
          6},{-12,6}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Plants/Combined/Controls/Validation/StagingPump.mos"
      "Simulate and plot"),
    experiment(
      StopTime=5000,
      Tolerance=1e-06),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end StagingPump;
