within Buildings.Fluid.Storage.Ice.Examples.BaseClasses.Validation;
model ControlDemandLevel
  "Model that validates the controller that outputs the demand level"
  extends Modelica.Icons.Example;


  Buildings.Fluid.Storage.Ice.Examples.BaseClasses.ControlDemandLevel ctrDemLev(Ti=10)
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSet(
    k=283.15,
    y(final unit="K",
      displayUnit="degC"))
      "Set point"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Controls.OBC.CDL.Continuous.Sources.Sine TMea(
    amplitude=5,
    freqHz=1/3600,
    offset=283.15,
    y(final unit="K",
      displayUnit="degC")) "Measured temperature"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
equation
  connect(TSet.y, ctrDemLev.u_s) annotation (Line(points={{-38,40},{-10,40},{-10,
          5},{18,5}}, color={0,0,127}));
  connect(TMea.y, ctrDemLev.u_m) annotation (Line(points={{-38,-30},{-10,-30},{-10,
          -5},{18,-5}}, color={0,0,127}));
  annotation (
      experiment(
      StopTime=7200,
      __Dymola_NumberOfIntervals=5000,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Storage/Ice/Examples/BaseClasses/Validation/ControlDemandLevel.mos"
        "Simulate and Plot"),
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-154,152},{146,112}},
          textString="%name",
          textColor={0,0,255}),
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{52,14},{96,-12}},
          textColor={0,0,0},
          textString=DynamicSelect("",String(y,
            leftJustified=false,
            significantDigits=1)))}),                            Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Model that validates the demand level controller.
Input to the controller is a set point and a time varying measured temperature,
which should switch the output across the different levels.
</p>
</html>", revisions="<html>
<ul>
<li>
September 21, 2022, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ControlDemandLevel;
