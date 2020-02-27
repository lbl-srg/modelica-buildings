within Buildings.Utilities.IO.SignalExchange.Examples.BaseClasses;
model OriginalModel "Original model"
  extends Modelica.Blocks.Icons.Block;

  Modelica.Blocks.Sources.Constant TSet(k=1) "Set point"
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));

  Modelica.Blocks.Continuous.LimPID conPI(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    yMax=10) "Controller"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));

  Modelica.Blocks.Continuous.FirstOrder firOrd(
    T=1,
    initType=Modelica.Blocks.Types.Init.InitialOutput)
    "First order element"
    annotation (Placement(transformation(extent={{50,20},{70,40}})));

  Overwrite oveWriSet(
    description="First order system control setpoint",
    u(min=-10,
      max=10,
      unit="1")) "Overwrite block for setpoint"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));

  Overwrite oveWriAct(description="First order system input",
    u(min=-10,
      max=10,
      unit="1")) "Overwrite block for actuator signal"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));

  Read rea(
    description="First order system output",
    KPIs=Buildings.Utilities.IO.SignalExchange.SignalTypes.SignalsForKPIs.None)
    "Measured state variable"
    annotation (Placement(transformation(extent={{50,-30},{30,-10}})));

equation
  connect(TSet.y, oveWriSet.u)
    annotation (Line(points={{-49,30},{-42,30}}, color={0,0,127}));
  connect(oveWriSet.y, conPI.u_s)
    annotation (Line(points={{-19,30},{-12,30}}, color={0,0,127}));
  connect(conPI.y, oveWriAct.u)
    annotation (Line(points={{11,30},{18,30}}, color={0,0,127}));
  connect(oveWriAct.y, firOrd.u)
    annotation (Line(points={{41,30},{48,30}}, color={0,0,127}));
  connect(firOrd.y, rea.u) annotation (Line(points={{71,30},{80,30},{80,-20},{52,
          -20}}, color={0,0,127}));
  connect(rea.y, conPI.u_m)
    annotation (Line(points={{29,-20},{0,-20},{0,18}}, color={0,0,127}));

  annotation (Documentation(info="<html>
<p>
This is a model of a first order dynamic system with feedback control.
Signal exchange blocks are implemented to overwrite either the setpoint or
actuator control signals as well as read the output of the first order
system.
</p>
</html>", revisions="<html>
<ul>
<li>
December 17, 2018, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end OriginalModel;
