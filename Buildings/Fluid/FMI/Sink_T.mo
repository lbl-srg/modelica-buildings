within Buildings.Fluid.FMI;
model Sink_T
  "Model of a sink with temperature for reverse flow as an input that can be exported as an FMU"
  extends Modelica.Blocks.Icons.Block;
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air")));

  parameter Boolean use_p_in = true
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput T_in(unit="K",
                                            displayUnit="degC",
                                            min=0)
    "Prescribed boundary temperature"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput X_w_in(unit="1")
    if Medium.nXi > 0 "Prescribed boundary composition"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
        iconTransformation(extent={{-140,10},{-100,50}})));

  Modelica.Blocks.Interfaces.RealInput C_in[Medium.nC]
    "Prescribed boundary composition"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
        iconTransformation(extent={{-140,-40},{-100,0}})));

  Interfaces.Inlet inlet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_p_in=use_p_in) "Fluid port"
    annotation (Placement(transformation(extent={{120,-10},{100,10}})));
  Buildings.Fluid.FMI.Interfaces.PressureOutput p
  if use_p_in "Pressure"
  annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={-110,-80}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=180,
        origin={-120,-80})));
protected
  input Buildings.Fluid.FMI.Interfaces.FluidProperties bacPro_internal(
    redeclare final package Medium = Medium)
    "Internal connector for fluid properties for back flow";
  Buildings.Fluid.FMI.Interfaces.PressureOutput p_in_internal
    "Internal connector for pressure";
  output Buildings.Fluid.FMI.Interfaces.MassFractionConnector X_w_in_internal
    "Internal connector for mass fraction of forward flow properties";

equation
 // Conditional connector for flow reversal
  connect(inlet.backward, bacPro_internal);
  connect(bacPro_internal.X_w, X_w_in_internal);
  if allowFlowReversal and Medium.nXi > 0 then
    connect(X_w_in_internal, X_w_in);
  else
    X_w_in_internal = 0;
  end if;

  if allowFlowReversal then
    bacPro_internal.T  = T_in;
    bacPro_internal.C  = C_in;
  else
    bacPro_internal.T = Medium.T_default;
    bacPro_internal.C  = fill(0, Medium.nC);
  end if;

  // Propagate pressure to output signal connector
  // using conditional connectors
  if use_p_in then
    connect(inlet.p, p_in_internal);
  else
    p_in_internal = Medium.p_default;
  end if;
  connect(p, p_in_internal);

  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                   Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}), Text(
          extent={{-98,-90},{-62,-72}},
          textColor={0,0,255},
          textString="P",
          visible=use_p_in)}),
    Documentation(info="<html>
<p>
Model of a sink that takes as an input the medium properties
temperature, mass fractions (if <code>Medium.nXi &gt; 0</code>)
and trace substances (if <code>Medium.nC &gt; 0</code>).
These properties are used during reverse flow.
</p>
<p>
For a system of components with the connectors of the
<a href=\"modelica://Buildings.Fluid.FMI\">
Buildings.Fluid.FMI</a>
package, this component is required to set the medium properties
for the reverse flow.
</p>
<p>
If the parameter <code>use_p_in</code> is set to <code>true</code>,
then the model has an output connector <code>p</code>.
This can be used to obtain the pressure of the sink, which
may be needed to iteratively solve for the mass flow rate.
</p>
</html>", revisions="<html>
<ul>
<li>
March 18, 2024, by Michael Wetter:<br/>
Added causality.<br/>
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1853\">IBPSA, #1853</a>.
</li>
<li>
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice to moist air and water.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
April 29, 2015, by Michael Wetter:<br/>
Redesigned to conditionally remove the pressure connector
if <code>use_p_in=false</code>.
</li>
<li>
April 29, 2015, by Michael Wetter:<br/>
Added pressure output signal which is needed to solve for algebraic loops.
</li>
<li>
April 15, 2015 by Michael Wetter:<br/>
Changed connector variable to be temperature instead of
specific enthalpy.
</li>
<li>
November 8, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Sink_T;
