within Buildings.ChillerWSE.BaseClasses;
model TimerSISO "Timer for delayed control with SISO"

  Modelica.Blocks.Continuous.Integrator Int(
    k=1,
    initType=Modelica.Blocks.Types.Init.InitialState)
                                            "integrator for time"
    annotation (Placement(transformation(extent={{-12,-10},{8,10}})));
  Modelica.Blocks.Interfaces.RealInput on "On/off signal" annotation (Placement(
        transformation(extent={{-140,-20},{-100,20}}), iconTransformation(
          extent={{-120,0},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput y "running time"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation

      connect(Int.u,on)
    annotation (Line(points={{-14,0},{-68,0},{-120,0}},
                                                color={0,0,127},
      pattern=LinePattern.Dash));
      connect(Int.y,y) annotation (Line(points={{9,0},{60,0},{110,0}},
                                                             color={0,0,127},
      pattern=LinePattern.Dash));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255}),
        Text(
          extent={{-48,-150},{56,-110}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-44,40},{52,-28}},
          lineColor={0,0,255},
          textString="Timer")}), Diagram(coordinateSystem(preserveAspectRatio=
            false)),
    Documentation(info="<html>
<p>This model calculates runtime. </p>
</html>", revisions="<html>
<ul>
<li>Jul 30, 2016, by Yangyang Fu:<br/>
First Implementation.
</li>
</ul>
</html>"));
end TimerSISO;
