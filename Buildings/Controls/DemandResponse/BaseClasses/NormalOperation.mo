within Buildings.Controls.DemandResponse.BaseClasses;
block NormalOperation "Normal operation"
  extends Modelica.StateGraph.StepWithSignal(nIn=1, nOut=1);
  Modelica.Blocks.Interfaces.RealInput PCon(unit="W")
    "Consumed electrical power"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput PPre(unit="W")
    "Predicted power consumption for current hour"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

equation
 PPre = PCon;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-70,64},{74,-54}},
          textColor={0,0,255},
          textString="N")}),    Documentation(info="<html>
<p>
Block that outputs the currently consumed electrical power,
which is equal to its input signal.
</p>
</html>", revisions="<html>
<ul>
<li>
March 29, 2024, by Michael Wetter:<br/>
Due to the refactoring for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3754\">3754</a>,
this model is no longer used. It is left in the library for backward compatibility,
and will be removed for release 11.
</li>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end NormalOperation;
