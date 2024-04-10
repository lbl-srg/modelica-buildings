within Buildings.DHC.Plants.Combined.Controls.BaseClasses.Validation;
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
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    annotation(Dialog(group="Nominal condition"));

  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable floSpe(
    table=[
      0,0,0;
      1,0,0;
      4,(nPum - 1)/nPum*m_flow_nominal,1;
      5,m_flow_nominal,0.9;
      10,0,0.1],
    timeScale=500)
    "Source signal"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.DHC.Plants.Combined.Controls.BaseClasses.StagingPump
    staDet(
    final nPum=nPum,
    final m_flow_nominal=m_flow_nominal)
    "Pump staging block - Detailed version"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yVal(k=1)
    "Source signal"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold isOpe(t=0.1,
    h=5E-2) "Check if valve open"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
equation
  connect(floSpe.y[1],staDet. m_flow) annotation (Line(points={{-58,40},{30,40},
          {30,0},{38,0}},     color={0,0,127}));
  connect(floSpe.y[2],staDet. y)
    annotation (Line(points={{-58,40},{30,40},{30,-6},{38,-6}},
                                                 color={0,0,127}));
  connect(yVal.y, isOpe.u)
    annotation (Line(points={{-58,0},{-42,0}}, color={0,0,127}));
  connect(isOpe.y,staDet.y1Ena)
    annotation (Line(points={{-18,0},{0,0},{0,6},{38,6}}, color={255,0,255}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Plants/Combined/Controls/BaseClasses/Validation/StagingPump.mos"
      "Simulate and plot"),
    experiment(
      StopTime=5000,
      Tolerance=1e-06),
  Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This is a validation model for the pump staging logic implemented in
<a href=\"modelica://Buildings.DHC.Plants.Combined.Controls.BaseClasses.StagingPump\">
Buildings.DHC.Plants.Combined.Controls.BaseClasses.StagingPump</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end StagingPump;
