within Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.Validation;
model ControlProcessModel "Test model for ControlProcessModel"
  Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.ControlProcessModel
    conProMod(yLow=0.1, deaBan=0.05)
    "Calculate the parameters of  of a first-order model"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable RefDat(table=[0,1,1,1,
        0.3,1,1; 0.1,1,1,1,0.3,1,1; 0.1,0.5,1,1,0.5,1,1; 0.298,0.5,1,1,0.5,1,1;
        0.3,0.5,1,1,0.5,1,1; 0.3,0.5,1,1,0.1,1,1;0.698,0.5,1,1,0.1,1,1; 0.7,0.5,1,1,0.1,1,1;
        0.7,0.5,1,3,0.5,0.762,0.762;0.828,0.5,1,3,0.5,0.762,0.762; 0.83,0.5,1,3,0.5,
        0.762,0.762; 0.83,1,1,3,0.8,0.762,0.762; 0.83,1,1,3,0.8,0.762,0.762;
        0.848,1,1,3,0.8,0.762,0.762; 0.85,1,1,3,0.8, 0.762,0.762; 0.85,1,2,3,0.5,0.762,0.762;
        1,1,2,3,0.5,0.762,0.762],
        extrapolation=Buildings.Controls.OBC.CDL.Types.Extrapolation.HoldLastPoint)
    "Data for validating the controlProcessModel block"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable RefBooDat(table=[0,0,0;
        0.298,0,0; 0.3,0,0; 0.3,1,0; 0.698,1,0; 0.7,1,0; 0.7,1,1; 0.7,1,1;1,1,1], period=1)
    "Boolean Data for validating the controlProcessModel block"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  connect(RefDat.y[1], conProMod.u) annotation (Line(points={{-58,0},{-20,0},{-20,
          8},{-12,8}}, color={0,0,127}));
  connect(conProMod.tOn, RefDat.y[2]) annotation (Line(points={{-12,4},{-18,4},
          {-18,0},{-58,0}}, color={0,0,127}));
  connect(conProMod.tOff, RefDat.y[3]) annotation (Line(points={{-12,-4},{-16,-4},
          {-16,0},{-58,0}}, color={0,0,127}));
  connect(conProMod.tau, RefDat.y[4]) annotation (Line(points={{-12,-8},{-18,-8},
          {-18,0},{-58,0}}, color={0,0,127}));
  connect(RefBooDat.y[1], conProMod.triSta)
    annotation (Line(points={{-58,-50},{-6,-50},{-6,-12}}, color={255,0,255}));
  connect(conProMod.triEnd, RefBooDat.y[2])
    annotation (Line(points={{6,-12},{6,-50},{-58,-50}}, color={255,0,255}));
  annotation (
      experiment(
      StopTime=1.0,
      Tolerance=1e-06),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/Utilities/PIDWithAutotuning/SystemIdentification/FirstOrderTimedelayed/Validation/ControlProcessModel.mos" "Simulate and plot"),
    Icon( coordinateSystem(
        preserveAspectRatio=false,
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
          points={{-36,60},{64,0},{-36,-60},{-36,60}})}),Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 1, 2022, by Sen Huang:<br/>
First implementation<br/>
</li>
</ul>
</html>", info="<html>
<p>
Validation test for the block
<a href=\"modelica://Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.ControlProcessModel\">
Buildings.Controls.OBC.Utilities.PIDWithAutotuning.SystemIdentification.FirstOrderTimedelayed.ControlProcessModel</a>.
</p>
</html>"));
end ControlProcessModel;
