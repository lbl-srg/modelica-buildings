within Buildings.Controls.DemandResponse.BaseClasses;
block ShedOperation "Computes the consumption with the shed taken into account"
  extends Modelica.StateGraph.Step(nIn=1, nOut=1);
  Modelica.Blocks.Interfaces.RealInput PCon(unit="W")
    "Consumed electrical power"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}}),
        iconTransformation(extent={{-140,-110},{-100,-70}})));

  Modelica.Blocks.Interfaces.RealInput yShed(min=-1, max=1, unit="1")
    "Amount of load to shed. Set to 0.5 to shed 50% of load"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}}),
        iconTransformation(extent={{-120,-30},{-100,-10}})));

  Modelica.Blocks.Interfaces.RealOutput PPre(unit="W")
    "Predicted power consumption for current hour"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

equation
  PPre = yShed*PCon;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-70,64},{74,-54}},
          textColor={0,0,255},
          textString="SH")}),    Documentation(info="<html>
<p>
This model computes the predicted load as the product of the shed
control signal and the consumed electrical power.
</p>
</html>", revisions="<html>
<ul>
<li>
March 20, 2014 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ShedOperation;
