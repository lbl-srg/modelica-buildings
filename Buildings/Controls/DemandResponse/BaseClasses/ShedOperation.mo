within Buildings.Controls.DemandResponse.BaseClasses;
block ShedOperation "Computes the consumption with the shed taken into account"
  extends Modelica.StateGraph.Step;
  Modelica.Blocks.Interfaces.RealInput PCon(unit="W")
    "Consumed electrical power"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));

  Modelica.Blocks.Interfaces.RealOutput PPre(unit="W")
    "Predicted power consumption for current hour"
    annotation (Placement(transformation(extent={{100,-90},{120,-70}})));

equation
  PPre = 0.5*PCon;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={Text(
          extent={{-70,64},{74,-54}},
          lineColor={0,0,255},
          textString="SH")}), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-100},{100,100}}), graphics));
end ShedOperation;
