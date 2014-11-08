within Buildings.Fluid.FMI;
model Source_T
  "FMI model for a boundary with mass flow rate, pressure and temperature as an input"
  extends Buildings.BaseClasses.BaseIcon;
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choicesAllMatching = true);

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput m_flow_in(unit="kg/s")
    "Prescribed mass flow source"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));

  Modelica.Blocks.Interfaces.RealInput p_in(unit="Pa")
    "Prescribed boundary pressure"
    annotation (Placement(transformation(extent={{-140,28},{-100,68}}),
        iconTransformation(extent={{-140,28},{-100,68}})));
  Modelica.Blocks.Interfaces.RealInput T_in(unit="K",
                                            displayUnit="degC",
                                            min=0)
    "Prescribed boundary temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput X_in[Medium.nX](each unit="1")
    "Prescribed boundary composition"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  Modelica.Blocks.Interfaces.RealInput C_in[Medium.nC]
    "Prescribed boundary composition"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));

  Interfaces.Outlet outlet(redeclare final package Medium = Medium, final
      allowFlowReversal=allowFlowReversal) "Fluid port"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
equation
  outlet.m_flow = m_flow_in;
  outlet.p = p_in;
  outlet.forward.h  = Medium.specificEnthalpy_pTX(p=p_in, T=T_in, X=X_in);
  outlet.forward.Xi = X_in[1:Medium.nXi];
  outlet.forward.C  = C_in;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics), Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                   Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}), Text(
          extent={{-94,60},{94,-58}},
          lineColor={0,0,255},
          textString="m_flow
p")}),
    Documentation(info="<html>
<p>
Model for a source that takes as an input the mass flow rate,
pressure and the medium properties
temperature, mass fractions (if <code>Medium.nXi &gt; 0</code>)
and trace substances (if <code>Medium.nC &gt; 0</code>).
</p>
<p>
For a system of components with the connectors of the
<a href=\"modelica://Buildings.Fluid.FMI\">
Buildings.Fluid.FMI</a>
package, this component is required to set the pressure
and the mass flow rate of the system.
</p>
</html>", revisions="<html>
<ul>
<li>
November 8, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Source_T;
