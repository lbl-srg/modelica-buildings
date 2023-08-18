within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Validation;
model PIDWithFirstOrderAMIGO "Test model for an autotuning PID controller"
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant SetPoint(k=0.8)
    "Setpoint value"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.FirstOrderAMIGO PIDWitTun(
      controllerType=Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Types.SimpleController.PID)
    "PID controller with an autotuning feature"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset PID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    k=1,
    Ti=0.5,
    Td=0.1) "PID controller with constant gains"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant resSig(k=false)
    "Reset signal"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel2(samplePeriod=240)
    "A delay process for control process 2"
    annotation (Placement(transformation(extent={{10,-30},{30,-10}})));
  Buildings.Controls.OBC.CDL.Discrete.UnitDelay uniDel1(samplePeriod=240)
    "A delay process for control process 1"
    annotation (Placement(transformation(extent={{10,50},{30,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant k(k=1)
    "Gain of the first order process"
    annotation (Placement(transformation(extent={{180,20},{160,40}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant T(k=10)
    "Time constant of the first order process"
    annotation (Placement(transformation(extent={{180,-20},{160,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "A subtract block that is used to mimic the first order process 1"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "A subtract block that is used to mimic the first order process 2"
    annotation (Placement(transformation(extent={{60,-20},{80,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Derivative derivative1
    "A derivative block that is used to mimic the first order process 1"
    annotation (Placement(transformation(extent={{78,26},{58,46}})));
  Buildings.Controls.OBC.CDL.Continuous.Derivative derivative2
    "A derivative block that is used to mimic the first order process 2"
    annotation (Placement(transformation(extent={{80,-60},{60,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse autTunSig(
    width=0.9,
    period=10000,
    shift=-9000) "Signal for enabling the autotuning"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  connect(resSig.y, PID.trigger) annotation (Line(points={{-58,70},{-30,70},{-30,
          40},{-16,40},{-16,48}}, color={255,0,255}));
  connect(PIDWitTun.triRes, PID.trigger) annotation (Line(points={{-16,-32},{-16,
          -38},{-30,-38},{-30,40},{-16,40},{-16,48}}, color={255,0,255}));
  connect(PIDWitTun.u_s, PID.u_s) annotation (Line(points={{-22,-20},{-48,-20},
          {-48,60},{-22,60}}, color={0,0,127}));
  connect(SetPoint.y, PID.u_s) annotation (Line(points={{-58,10},{-48,10},{-48,60},
          {-22,60}}, color={0,0,127}));
  connect(PIDWitTun.y, uniDel2.u)
    annotation (Line(points={{2,-20},{8,-20}}, color={0,0,127}));
  connect(uniDel1.u, PID.y)
    annotation (Line(points={{8,60},{2,60}}, color={0,0,127}));
  connect(uniDel1.y, sub1.u1) annotation (Line(points={{32,60},{40,60},{40,86},{
          58,86}}, color={0,0,127}));
  connect(k.y, derivative1.k) annotation (Line(points={{158,30},{148,30},{148,44},
          {80,44}}, color={0,0,127}));
  connect(derivative1.T, T.y) annotation (Line(points={{80,40},{112,40},{112,-46},
          {148,-46},{148,-10},{158,-10}}, color={0,0,127}));
  connect(derivative1.y, sub1.u2) annotation (Line(points={{56,36},{50,36},{50,74},
          {58,74}}, color={0,0,127}));
  connect(sub1.y, PID.u_m) annotation (Line(points={{82,80},{88,80},{88,54},{46,54},
          {46,42},{-10,42},{-10,48}}, color={0,0,127}));
  connect(sub2.u1, uniDel2.y) annotation (Line(points={{58,-4},{40,-4},{40,-20},
          {32,-20}}, color={0,0,127}));
  connect(derivative2.y,sub2. u2) annotation (Line(points={{58,-50},{52,-50},{
          52,-16},{58,-16}}, color={0,0,127}));
  connect(sub2.y, PIDWitTun.u_m) annotation (Line(points={{82,-10},{88,-10},
          {88,-26},{46,-26},{46,-38},{-10,-38},{-10,-32}}, color={0,0,127}));
  connect(derivative2.k, derivative1.k) annotation (Line(points={{82,-42},{92,-42},
          {92,44},{80,44}}, color={0,0,127}));
  connect(derivative2.T, T.y) annotation (Line(points={{82,-46},{148,-46},{148,
          -10},{158,-10}}, color={0,0,127}));
  connect(derivative1.u, sub1.u1) annotation (Line(points={{80,36},{88,36},{88,20},
          {40,20},{40,86},{58,86}}, color={0,0,127}));
  connect(derivative2.u, uniDel2.y) annotation (Line(points={{82,-50},{92,-50},
          {92,-66},{40,-66},{40,-20},{32,-20}}, color={0,0,127}));
  connect(autTunSig.y, PIDWitTun.triTun)
    annotation (Line(points={{-58,-50},{-4,-50},{-4,-32}}, color={255,0,255}));
  annotation (
    experiment(
      StopTime=10000,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/Validation/PIDWithFirstOrderAMIGO.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.FirstOrderAMIGO\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.FirstOrderAMIGO</a>.
</p>
<p>
This example compares the output of an autotuning PID controller (<code>PIDWitTun</code>)
to that of a normal PID controller (<code>PID</code>) with prescribed gains.
</p>
<p>
Both PID controllers are connected with a first-order control process.
At the beginning (<i>0</i>s-<i>1000</i>s), the outputs from those two PID controllers 
are identical as their prescribed gains are the same.
</p>
<p>
Once the autotuning starts at <i>1000</i>s, the outputs of the two PID controllers become different.
After the tuning completes, under the control of <code>PIDWitTun</code>, the value of the controlled variable
is close to the setpoint after the tuning period ends (<code>PIDWitTun.resPro.triEnd = true</code>). 
On the contrary, <code>PID</code> has a poor control performance,
i.e., the value of the controlled variable oscillates.
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(
          lineColor={0,0,255},
          fillColor={75,138,73},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-80},{200,100}})));
end PIDWithFirstOrderAMIGO;
