within Buildings.Obsolete.Controls.OBC.CDL.Continuous.Validation;
model LimPIDWithReset
  "Test model for LimPID controller with reset trigger"

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal setPoi "Set point"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.CivilTime modTim
    "Standard time"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Buildings.Obsolete.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
      threshold=1) "Outputs true after t=1"
    annotation (Placement(transformation(extent={{-52,-70},{-32,-50}})));

  Buildings.Obsolete.Controls.OBC.CDL.Continuous.LimPID limPIDPar(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    k=1,
    Ti=1,
    Td=1,
    yMin=-1,
    reset=Buildings.Obsolete.Controls.OBC.CDL.Types.Reset.Parameter,
    y_reset=0.5) "Controller, reset to parameter value"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes1
    "Integrator whose output should be brought to the set point"
    annotation (Placement(transformation(extent={{60,60},{80,80}})));
  Buildings.Obsolete.Controls.OBC.CDL.Continuous.LimPID limPIDInp(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    k=1,
    Ti=1,
    Td=1,
    yMin=-1,
    reset=Buildings.Obsolete.Controls.OBC.CDL.Types.Reset.Input,
    y_reset=0.5) "Controller, reset to input value"
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes2
    "Integrator whose output should be brought to the set point"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant resVal(k=0.75)
    "Reset value"
    annotation (Placement(transformation(extent={{-40,12},{-20,32}})));
  Buildings.Obsolete.Controls.OBC.CDL.Continuous.LimPID limPIPar(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=1,
    Ti=1,
    Td=1,
    yMin=-1,
    reset=Buildings.Obsolete.Controls.OBC.CDL.Types.Reset.Parameter,
    y_reset=0.5) "Controller, reset to parameter value"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes3
    "Integrator whose output should be brought to the set point"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  Buildings.Obsolete.Controls.OBC.CDL.Continuous.LimPID limPIInp(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=1,
    Ti=1,
    Td=1,
    yMin=-1,
    reset=Buildings.Obsolete.Controls.OBC.CDL.Types.Reset.Input,
    y_reset=0.5) "Controller, reset to input value"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes4
    "Integrator whose output should be brought to the set point"
    annotation (Placement(transformation(extent={{60,-80},{80,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer(final k=0)
    "Reset input to integrator when the reset is disabled"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant noTri(final k=false)
    "No trigger when reset is disabled"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

equation
  connect(limPIDPar.u_s, setPoi.y) annotation (Line(points={{18,70},{6,70},{6,-40},
          {2,-40}}, color={0,0,127}));
  connect(intWitRes1.u, limPIDPar.y)
    annotation (Line(points={{58,70},{42,70}}, color={0,0,127}));
  connect(intWitRes1.y, limPIDPar.u_m) annotation (Line(points={{82,70},{90,70},
          {90,54},{30,54},{30,58}}, color={0,0,127}));
  connect(modTim.y, greEquThr.u)
    annotation (Line(points={{-68,-60},{-54,-60}},   color={0,0,127}));
  connect(greEquThr.y, setPoi.u) annotation (Line(points={{-30,-60},{-26,-60},{-26,
          -40},{-22,-40}}, color={255,0,255}));
  connect(greEquThr.y, limPIDPar.trigger) annotation (Line(points={{-30,-60},{8,
          -60},{8,54},{24,54},{24,58}},  color={255,0,255}));
  connect(intWitRes2.u, limPIDInp.y)
    annotation (Line(points={{58,30},{42,30}}, color={0,0,127}));
  connect(intWitRes2.y, limPIDInp.u_m) annotation (Line(points={{82,30},{90,30},
          {90,10},{30,10},{30,18}}, color={0,0,127}));
  connect(limPIDInp.u_s, setPoi.y) annotation (Line(points={{18,30},{6,30},{6,-40},
          {2,-40}},  color={0,0,127}));
  connect(limPIDInp.y_reset_in, resVal.y)
    annotation (Line(points={{18,22},{-18,22}}, color={0,0,127}));
  connect(limPIPar.u_s, setPoi.y) annotation (Line(points={{18,-30},{12,-30},{12,
          -40},{2,-40}}, color={0,0,127}));
  connect(intWitRes3.u, limPIPar.y)
    annotation (Line(points={{58,-30},{42,-30}}, color={0,0,127}));
  connect(intWitRes3.y, limPIPar.u_m) annotation (Line(points={{82,-30},{90,-30},
          {90,-50},{30,-50},{30,-42}}, color={0,0,127}));
  connect(greEquThr.y, limPIPar.trigger) annotation (Line(points={{-30,-60},{8,-60},
          {8,-48},{24,-48},{24,-42}}, color={255,0,255}));
  connect(intWitRes4.u, limPIInp.y)
    annotation (Line(points={{58,-70},{42,-70}}, color={0,0,127}));
  connect(intWitRes4.y, limPIInp.u_m) annotation (Line(points={{82,-70},{90,-70},
          {90,-90},{30,-90},{30,-82}}, color={0,0,127}));
  connect(limPIInp.u_s, setPoi.y) annotation (Line(points={{18,-70},{6,-70},{6,-40},
          {2,-40}},  color={0,0,127}));
  connect(limPIInp.y_reset_in, resVal.y) annotation (Line(points={{18,-78},{14,
          -78},{14,22},{-18,22}}, color={0,0,127}));
  connect(greEquThr.y, limPIInp.trigger) annotation (Line(points={{-30,-60},{8,-60},
          {8,-90},{24,-90},{24,-82}}, color={255,0,255}));
  connect(limPIDInp.trigger, greEquThr.y) annotation (Line(points={{24,18},{24,10},
          {8,10},{8,-60},{-30,-60}}, color={255,0,255}));
  connect(zer.y, intWitRes1.y_reset_in) annotation (Line(points={{-38,50},{50,50},
          {50,62},{58,62}}, color={0,0,127}));
  connect(zer.y, intWitRes2.y_reset_in) annotation (Line(points={{-38,50},{50,50},
          {50,22},{58,22}}, color={0,0,127}));
  connect(zer.y, intWitRes3.y_reset_in) annotation (Line(points={{-38,50},{50,50},
          {50,-38},{58,-38}}, color={0,0,127}));
  connect(zer.y, intWitRes4.y_reset_in) annotation (Line(points={{-38,50},{50,50},
          {50,-78},{58,-78}}, color={0,0,127}));
  connect(noTri.y, intWitRes1.trigger) annotation (Line(points={{-38,-10},{54,-10},
          {54,50},{70,50},{70,58}}, color={255,0,255}));
  connect(noTri.y, intWitRes2.trigger)
    annotation (Line(points={{-38,-10},{70,-10},{70,18}}, color={255,0,255}));
  connect(noTri.y, intWitRes3.trigger) annotation (Line(points={{-38,-10},{54,-10},
          {54,-46},{70,-46},{70,-42}}, color={255,0,255}));
  connect(noTri.y, intWitRes4.trigger) annotation (Line(points={{-38,-10},{54,-10},
          {54,-86},{70,-86},{70,-82}}, color={255,0,255}));
 annotation (
 experiment(
      StopTime=10,
      Tolerance=1e-06),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/Controls/OBC/CDL/Continuous/Validation/LimPIDWithReset.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Obsolete.Controls.OBC.CDL.Continuous.LimPID\">
Buildings.Obsolete.Controls.OBC.CDL.Continuous.LimPID</a>.
</p>
<p>
This model validates the controller for different settings of the control output reset.
</p>
</html>", revisions="<html>
<ul>
<li>
April 7, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end LimPIDWithReset;
