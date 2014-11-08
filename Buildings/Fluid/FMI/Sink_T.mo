within Buildings.Fluid.FMI;
model Sink_T
  "FMI model for a sink with temperature for reverse flow as an input"
  extends Buildings.BaseClasses.BaseIcon;
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput T_in(unit="K",
                                            displayUnit="degC",
                                            min=0)
    "Prescribed boundary temperature"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.Blocks.Interfaces.RealInput X_in[Medium.nX](each unit="1")
    "Prescribed boundary composition"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealInput C_in[Medium.nC]
    "Prescribed boundary composition"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  Interfaces.Inlet inlet(redeclare final package Medium = Medium, final
      allowFlowReversal=allowFlowReversal) "Fluid port"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  inlet.backward.h  = Medium.specificEnthalpy_pTX(p=inlet.p, T=T_in, X=X_in);
  inlet.backward.Xi = X_in[1:Medium.nXi];
  inlet.backward.C  = C_in;

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                   Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255})}),
    Documentation(info="<html>
<p>
Model for a sink that takes as an input the medium properties
temperature, mass fractions (if <code>Medium.nXi &gt; 0</code>)
and trace substances (if <code>Medium.nC &gt; 0</code>).
These properties are used for the reverse flow
</p>
<p>
For a system of components with the connectors of the
<a href=\"modelica://Buildings.Fluid.FMI\">
Buildings.Fluid.FMI</a>
package, this component is required to set the medium properties
for the reverse flow.
</p>
</html>", revisions="<html>
<ul>
<li>
November 8, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Sink_T;
