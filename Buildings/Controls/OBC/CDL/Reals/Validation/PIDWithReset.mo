within Buildings.Controls.OBC.CDL.Reals.Validation;
model PIDWithReset
  "Test model for LimPID controller with reset trigger"
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal setPoi
    "Set point"
    annotation (Placement(transformation(extent={{-20,-40},{0,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.CivilTime modTim
    "Civil time"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greEquThr(
    t=1)
    "Outputs true after t=1"
    annotation (Placement(transformation(extent={{-52,-70},{-32,-50}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset limPIDPar(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    k=1,
    Ti=1,
    Td=1,
    yMin=-1,
    y_reset=0.5)
    "Controller, reset to parameter value"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes1
    "Integrator whose output should be brought to the set point"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset limPIDInp(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    k=1,
    Ti=1,
    Td=1,
    yMin=-1,
    y_reset=0.75)
    "Controller, reset to input value"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes2
    "Integrator whose output should be brought to the set point"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant resVal(
    k=0)
    "Reset value"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset limPIPar(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=1,
    Ti=1,
    Td=1,
    yMin=-1,
    y_reset=0.5)
    "Controller, reset to parameter value"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes3
    "Integrator whose output should be brought to the set point"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset limPIInp(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=1,
    Ti=1,
    Td=1,
    yMin=-1,
    y_reset=0.75)
    "Controller, reset to input value"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes4
    "Integrator whose output should be brought to the set point"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

equation
  connect(limPIDPar.u_s,setPoi.y)
    annotation (Line(points={{18,70},{6,70},{6,-30},{2,-30}},color={0,0,127}));
  connect(intWitRes1.u,limPIDPar.y)
    annotation (Line(points={{58,70},{42,70}},color={0,0,127}));
  connect(intWitRes1.y,limPIDPar.u_m)
    annotation (Line(points={{82,70},{90,70},{90,50},{30,50},{30,58}},color={0,0,127}));
  connect(modTim.y,greEquThr.u)
    annotation (Line(points={{-58,-60},{-54,-60}},color={0,0,127}));
  connect(greEquThr.y,setPoi.u)
    annotation (Line(points={{-30,-60},{-26,-60},{-26,-30},{-22,-30}},color={255,0,255}));
  connect(greEquThr.y,limPIDPar.trigger)
    annotation (Line(points={{-30,-60},{12,-60},{12,50},{24,50},{24,58}},color={255,0,255}));
  connect(intWitRes2.u,limPIDInp.y)
    annotation (Line(points={{58,30},{42,30}},color={0,0,127}));
  connect(intWitRes2.y,limPIDInp.u_m)
    annotation (Line(points={{82,30},{90,30},{90,10},{30,10},{30,18}},color={0,0,127}));
  connect(limPIDInp.u_s,setPoi.y)
    annotation (Line(points={{18,30},{6,30},{6,-30},{2,-30}},color={0,0,127}));
  connect(limPIPar.u_s,setPoi.y)
    annotation (Line(points={{18,-30},{2,-30}},color={0,0,127}));
  connect(intWitRes3.u,limPIPar.y)
    annotation (Line(points={{58,-30},{42,-30}},color={0,0,127}));
  connect(intWitRes3.y,limPIPar.u_m)
    annotation (Line(points={{82,-30},{90,-30},{90,-50},{30,-50},{30,-42}},color={0,0,127}));
  connect(greEquThr.y,limPIPar.trigger)
    annotation (Line(points={{-30,-60},{12,-60},{12,-50},{24,-50},{24,-42}},color={255,0,255}));
  connect(intWitRes4.u,limPIInp.y)
    annotation (Line(points={{58,-70},{42,-70}},color={0,0,127}));
  connect(intWitRes4.y,limPIInp.u_m)
    annotation (Line(points={{82,-70},{90,-70},{90,-90},{30,-90},{30,-82}},color={0,0,127}));
  connect(limPIInp.u_s,setPoi.y)
    annotation (Line(points={{18,-70},{6,-70},{6,-30},{2,-30}},color={0,0,127}));
  connect(greEquThr.y,limPIInp.trigger)
    annotation (Line(points={{-30,-60},{12,-60},{12,-90},{24,-90},{24,-82}},color={255,0,255}));
  connect(limPIDInp.trigger,greEquThr.y)
    annotation (Line(points={{24,18},{24,10},{12,10},{12,-60},{-30,-60}},color={255,0,255}));
  connect(resVal.y,intWitRes1.y_reset_in)
    annotation (Line(points={{-58,0},{48,0},{48,62},{58,62}},color={0,0,127}));
  connect(resVal.y,intWitRes2.y_reset_in)
    annotation (Line(points={{-58,0},{48,0},{48,22},{58,22}},color={0,0,127}));
  connect(resVal.y,intWitRes3.y_reset_in)
    annotation (Line(points={{-58,0},{48,0},{48,-38},{58,-38}},color={0,0,127}));
  connect(resVal.y,intWitRes4.y_reset_in)
    annotation (Line(points={{-58,0},{48,0},{48,-78},{58,-78}},color={0,0,127}));
  connect(con.y,intWitRes1.trigger)
    annotation (Line(points={{-58,40},{-20,40},{-20,-6},{54,-6},{54,54},{70,54},{70,58}},color={255,0,255}));
  connect(con.y,intWitRes2.trigger)
    annotation (Line(points={{-58,40},{-20,40},{-20,-6},{70,-6},{70,18}},color={255,0,255}));
  connect(con.y,intWitRes3.trigger)
    annotation (Line(points={{-58,40},{-20,40},{-20,-6},{54,-6},{54,-46},{70,-46},{70,-42}},color={255,0,255}));
  connect(con.y,intWitRes4.trigger)
    annotation (Line(points={{-58,40},{-20,40},{-20,-6},{54,-6},{54,-86},{70,-86},{70,-82}},color={255,0,255}));
  annotation (
    experiment(
      StopTime=10,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/CDL/Reals/Validation/PIDWithReset.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.CDL.Reals.PID\">
Buildings.Controls.OBC.CDL.Reals.PID</a>.
</p>
<p>
This model validates the controller for different settings of the control output reset.
</p>
</html>",
      revisions="<html>
<ul>
<li>
April 7, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}}),
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
    Diagram(
      coordinateSystem(
        extent={{-100,-100},{100,100}})));
end PIDWithReset;
