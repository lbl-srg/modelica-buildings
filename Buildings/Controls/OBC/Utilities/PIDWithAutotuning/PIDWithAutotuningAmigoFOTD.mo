within Buildings.Controls.OBC.Utilities.PIDWithAutotuning;
block PIDWithAutotuningAmigoFOTD
  "A autotuning PID controller with an Amigo tuner and a first order time delayed system model"
  extends
    Buildings.Controls.OBC.Utilities.PIDWithAutotuning.BaseClasses.PIDWithRelay(
      relay(
      yHig=1,
      yLow=0.1,       deaBan=0.1));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.ControlProcessModel
    controlProcessModel(
    yHig=0.2,
    yLow=0.9,
    deaBan=0.1)
    annotation (Placement(transformation(extent={{-20,40},{-40,60}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo.PI piParameters
    if not with_D
    annotation (Placement(transformation(extent={{-60,70},{-80,90}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.AutoTuner.Amigo.PID pidParameters
    if with_D annotation (Placement(transformation(extent={{-60,40},{-80,60}})));
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.Relay.ResponseProcess responseProcess(yHig=0.2,
      yLow=0.9)
    annotation (Placement(transformation(extent={{20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.ModelTime modTim
    "Simulation time"
    annotation (Placement(transformation(extent={{80,60},{60,80}})));
equation
  connect(responseProcess.triggerEnd, swi.u2) annotation (Line(points={{-1,42},{-1,
          10},{48,10},{48,0},{60,0}}, color={255,0,255}));
  connect(samk.trigger, swi.u2) annotation (Line(points={{-30,-8},{-30,10},{48,10},
          {48,0},{60,0}}, color={255,0,255}));
  connect(samTi.trigger, swi.u2) annotation (Line(points={{-70,-36},{-70,10},{48,
          10},{48,0},{60,0}}, color={255,0,255}));
  connect(samTd.trigger, swi.u2) annotation (Line(points={{-30,-58},{-30,-42},{-56,
          -42},{-56,10},{48,10},{48,0},{60,0}}, color={255,0,255}));
  connect(responseProcess.On, relay.On) annotation (Line(points={{22,44},{26,44},
          {26,52},{58,52},{58,22},{43,22}}, color={255,0,255}));
  connect(modTim.y, responseProcess.tim) annotation (Line(points={{58,70},{28,70},
          {28,56},{22,56}}, color={0,0,127}));
  connect(responseProcess.tau, controlProcessModel.tau) annotation (Line(
        points={{-1,50},{-12,50},{-12,42},{-18,42}}, color={0,0,127}));
  connect(controlProcessModel.tOff, responseProcess.tOff) annotation (Line(
        points={{-18,46},{-14,46},{-14,54},{-1,54}}, color={0,0,127}));
  connect(responseProcess.tOn, controlProcessModel.tOn) annotation (Line(points=
         {{-1,58},{-8,58},{-8,56},{-16,56},{-16,54},{-18,54}}, color={0,0,127}));
  connect(relay.yErr, controlProcessModel.u) annotation (Line(points={{43,30},{50,
          30},{50,72},{-10,72},{-10,58},{-18,58}}, color={0,0,127}));
  connect(pidParameters.kp, controlProcessModel.k)
    annotation (Line(points={{-58,56},{-41,56}}, color={0,0,127}));
  connect(pidParameters.T, controlProcessModel.T)
    annotation (Line(points={{-58,50},{-41,50}}, color={0,0,127}));
  connect(pidParameters.L, controlProcessModel.L) annotation (Line(points={{-58,
          44},{-44,44},{-44,42},{-41,42}}, color={0,0,127}));
  connect(pidParameters.k, samk.u) annotation (Line(points={{-81,56},{-94,56},{-94,
          -20},{-42,-20}}, color={0,0,127}));
  connect(pidParameters.Ti, samTi.u) annotation (Line(points={{-81,50},{-88,50},
          {-88,-48},{-82,-48}}, color={0,0,127}));
  connect(samTd.u, pidParameters.Td) annotation (Line(points={{-42,-70},{-48,-70},
          {-48,34},{-82,34},{-82,44},{-81,44}}, color={0,0,127}));
  connect(piParameters.kp, controlProcessModel.k) annotation (Line(points={{-58,
          86},{-50,86},{-50,56},{-41,56}}, color={0,0,127}));
  connect(piParameters.T, controlProcessModel.T) annotation (Line(points={{-58,80},
          {-52,80},{-52,50},{-41,50}}, color={0,0,127}));
  connect(piParameters.L, controlProcessModel.L) annotation (Line(points={{-58,74},
          {-54,74},{-54,44},{-44,44},{-44,42},{-41,42}}, color={0,0,127}));
  connect(piParameters.k, samk.u) annotation (Line(points={{-81,86},{-94,86},{-94,
          -20},{-42,-20}}, color={0,0,127}));
  connect(piParameters.Ti, samTi.u) annotation (Line(points={{-81,76},{-88,76},{
          -88,-48},{-82,-48}}, color={0,0,127}));
  connect(responseProcess.triggerEnd, controlProcessModel.triggerEnd)
    annotation (Line(points={{-1,42},{-8,42},{-8,32},{-36,32},{-36,38}}, color={
          255,0,255}));
  connect(responseProcess.triggerStart, controlProcessModel.triggerStart)
    annotation (Line(points={{-1,46},{-10,46},{-10,34},{-24,34},{-24,38}},
        color={255,0,255}));
end PIDWithAutotuningAmigoFOTD;
