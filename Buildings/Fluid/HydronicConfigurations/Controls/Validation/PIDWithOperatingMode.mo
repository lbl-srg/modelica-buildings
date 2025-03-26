within Buildings.Fluid.HydronicConfigurations.Controls.Validation;
model PIDWithOperatingMode "Test model for PID controller with operating mode"
  Buildings.Fluid.HydronicConfigurations.Controls.PIDWithOperatingMode limPIDPar(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PID,
    k=1,
    Ti=1,
    Td=1,
    yMin=-1,
    y_reset=0.5)
    "Controller, reset to parameter value"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes1
    "Integrator whose output should be brought to the set point"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant resVal(k=1)
         "Reset value"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.HydronicConfigurations.Controls.PIDWithOperatingMode limPIPar(
    k=1,
    Ti=1,
    Td=1,
    yMin=-1,
    y_reset=0.5)
    "Controller, reset to parameter value"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Reals.IntegratorWithReset intWitRes3
    "Integrator whose output should be brought to the set point"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable mode(table=[0,0; 1,0; 1,
        1; 5,1; 5,2; 9,2; 9,0; 10,0], period=10)
                                      "Operating mode"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
equation
  connect(intWitRes1.u,limPIDPar.y)
    annotation (Line(points={{58,40},{42,40}},color={0,0,127}));
  connect(intWitRes1.y,limPIDPar.u_m)
    annotation (Line(points={{82,40},{90,40},{90,20},{30,20},{30,28}},color={0,0,127}));
  connect(intWitRes3.u,limPIPar.y)
    annotation (Line(points={{58,-40},{42,-40}},color={0,0,127}));
  connect(intWitRes3.y,limPIPar.u_m)
    annotation (Line(points={{82,-40},{90,-40},{90,-60},{30,-60},{30,-52}},color={0,0,127}));
  connect(resVal.y,intWitRes1.y_reset_in)
    annotation (Line(points={{-58,0},{48,0},{48,32},{58,32}},color={0,0,127}));
  connect(resVal.y,intWitRes3.y_reset_in)
    annotation (Line(points={{-58,0},{48,0},{48,-48},{58,-48}},color={0,0,127}));
  connect(con.y,intWitRes1.trigger)
    annotation (Line(points={{-58,40},{-20,40},{-20,14},{70,14},{70,28}},                color={255,0,255}));
  connect(con.y,intWitRes3.trigger)
    annotation (Line(points={{-58,40},{-20,40},{-20,-56},{70,-56},{70,-52}},                color={255,0,255}));
  connect(mode.y[1], limPIDPar.mode) annotation (Line(points={{-58,80},{14,80},
          {14,20},{24,20},{24,28}}, color={255,127,0}));
  connect(mode.y[1], limPIPar.mode) annotation (Line(points={{-58,80},{14,80},{
          14,-60},{24,-60},{24,-52}}, color={255,127,0}));
  connect(resVal.y, limPIDPar.u_s)
    annotation (Line(points={{-58,0},{0,0},{0,40},{18,40}}, color={0,0,127}));
  connect(resVal.y, limPIPar.u_s) annotation (Line(points={{-58,0},{-0,0},{-0,
          -40},{18,-40}}, color={0,0,127}));
  annotation (
    experiment(
      StopTime=10,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/Controls/Validation/PIDWithOperatingMode.mos" "Simulate and plot"),
    Documentation(
      info="<html>
<p>
This model validates the block
<a href=\"modelica://Buildings.Fluid.HydronicConfigurations.Controls.PIDWithOperatingMode\">
Buildings.Fluid.HydronicConfigurations.Controls.PIDWithOperatingMode</a>
configured either as a PI or as a PID controller.
</p>
</html>",
      revisions="<html>
<ul>
<li>
June 30, 2022, by Antoine Gautier:<br/>
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
end PIDWithOperatingMode;
