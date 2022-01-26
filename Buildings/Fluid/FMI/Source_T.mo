within Buildings.Fluid.FMI;
model Source_T
  "Model of a boundary with mass flow rate, pressure and temperature as an input that can be exported as an FMU"
  extends Modelica.Blocks.Icons.Block;
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air")));

  parameter Boolean allowFlowReversal = true
    "= true to allow flow reversal, false restricts to design direction (inlet -> outlet)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean use_p_in = true
    "= true to use a pressure from connector, false to output Medium.p_default"
    annotation(Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput m_flow_in(unit="kg/s")
    "Prescribed mass flow source"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
        iconTransformation(extent={{-140,80},{-100,120}})));

  Buildings.Fluid.FMI.Interfaces.PressureInput p_in
    if use_p_in "Prescribed boundary pressure"
    annotation (Placement(transformation(extent={{-140,28},{-100,68}}),
        iconTransformation(extent={{-140,28},{-100,68}})));
  Modelica.Blocks.Interfaces.RealInput T_in(unit="K",
                                            displayUnit="degC",
                                            min=0)
    "Prescribed boundary temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput X_w_in(unit="1")
    if Medium.nXi > 0 "Prescribed boundary composition"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  Modelica.Blocks.Interfaces.RealInput C_in[Medium.nC]
    "Prescribed boundary composition"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}}),
        iconTransformation(extent={{-140,-120},{-100,-80}})));

  Interfaces.Outlet outlet(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_p_in=use_p_in) "Fluid port"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
protected
  Buildings.Fluid.FMI.Interfaces.PressureOutput p_in_internal
    "Internal connector for pressure";
  Buildings.Fluid.FMI.Interfaces.MassFractionConnector X_w_in_internal
    "Internal connector for mass fraction of forward flow properties";
initial equation
   assert(Medium.nXi < 2,
   "The medium must have zero or one independent mass fraction Medium.nXi.");
equation
   // Conditional connect statements for pressure
   if use_p_in then
     connect(p_in, p_in_internal);
   else
     p_in_internal = Medium.p_default;
   end if;
   connect(outlet.p, p_in_internal);

  // Conditional connectors for mass fraction
  if Medium.nXi > 0 then
    connect(X_w_in_internal, X_w_in);
  else
    X_w_in_internal = 0;
  end if;
  connect(outlet.forward.X_w, X_w_in_internal);

  outlet.m_flow = m_flow_in;

  outlet.forward.T  = T_in;
  outlet.forward.C  = C_in;

  annotation ( Icon(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-100},{100,100}}), graphics={
                                   Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Solid,
          fillColor={255,255,255}), Text(
          extent={{-94,60},{94,-58}},
          textColor={0,0,255},
          textString="m_flow
p")}),
    Documentation(info="<html>
<p>
Model of a source that takes as an input the mass flow rate,
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
January 18, 2019, by Jianjun Hu:<br/>
Limited the media choice to moist air only.
See <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1050\">#1050</a>.
</li>
<li>
October 15, 2016, by Michael Wetter:<br/>
Removed redundant connection.
</li>
<li>
April 29, 2015, by Michael Wetter:<br/>
Redesigned to conditionally remove the pressure connector
if <code>use_p_in=false</code>.
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
end Source_T;
