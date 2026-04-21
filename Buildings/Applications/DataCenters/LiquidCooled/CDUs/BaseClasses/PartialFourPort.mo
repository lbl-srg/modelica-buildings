within Buildings.Applications.DataCenters.LiquidCooled.CDUs.BaseClasses;
partial model PartialFourPort "Partial model with four ports"

  replaceable package MediumPla =
    Modelica.Media.Interfaces.PartialMedium "Medium in the plant-side component"
      annotation (choices(
        choice(redeclare package MediumPla = Buildings.Media.Water "Water"),
        choice(redeclare package MediumPla =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  replaceable package MediumRac =
    Modelica.Media.Interfaces.PartialMedium "Medium in the rack-side component"
      annotation (choices(
        choice(redeclare package MediumRac = Buildings.Media.Water "Water"),
        choice(redeclare package MediumRac =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));

  parameter Boolean allowFlowReversalPla = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for plant-side medium"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversalRac = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for rack-side medium"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_aPla(
                     redeclare final package Medium = MediumPla,
                     m_flow(min=if allowFlowReversalPla then -Modelica.Constants.inf else 0),
                     h_outflow(start = MediumPla.h_default, nominal = MediumPla.h_default))
    "Fluid connector aPla (positive design flow direction is from port_aPla to port_bPla)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bPla(
                     redeclare final package Medium = MediumPla,
                     m_flow(max=if allowFlowReversalPla then +Modelica.Constants.inf else 0),
                     h_outflow(start = MediumPla.h_default, nominal = MediumPla.h_default))
    "Fluid connector bPla (positive design flow direction is from port_aPla to port_bPla)"
    annotation (Placement(transformation(extent={{110,50},{90,70}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_aRac(
                     redeclare final package Medium = MediumRac,
                     m_flow(min=if allowFlowReversalRac then -Modelica.Constants.inf else 0),
                     h_outflow(start = MediumRac.h_default, nominal = MediumRac.h_default))
    "Fluid connector aRac (positive design flow direction is from port_aRac to port_bRac)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bRac(
                     redeclare final package Medium = MediumRac,
                     m_flow(max=if allowFlowReversalRac then +Modelica.Constants.inf else 0),
                     h_outflow(start = MediumRac.h_default, nominal = MediumRac.h_default))
    "Fluid connector bRac (positive design flow direction is from port_aRac to port_bRac)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}})));

  annotation (
    preferredView="info",
    Documentation(info="<html>
<p>
This model defines an interface for components with four ports.
The parameters <code>allowFlowReversalPla</code> and
<code>allowFlowReversalRac</code> may be used by models that extend
this model to treat flow reversal.
</p>
<p>
This model is identical to
<a href=\"modelica://Buildings.Fluid.Interfaces.PartialFourPort\">
Buildings.Fluid.Interfaces.PartialFourPort</a>, except that instances
have been renamed for use with CDUs.
</html>", revisions="<html>
<ul>
<li>
April 21, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(
          preserveAspectRatio=true,
          extent={{-100,-100},{100,100}},
          grid={1,1}), graphics={
      Text(
          extent={{-151,147},{149,107}},
          textColor={0,0,255},
          textString="%name"),
      Polygon(
          points={{-5,10},{25,10},{-5,-10},{-5,10}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=not allowFlowReversalPla,
          origin={75,50},
          rotation=360),
      Polygon(
          points={{10,10},{-20,-10},{10,-10},{10,10}},
          lineColor={0,128,255},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          visible=not allowFlowReversalRac,
          origin={-79,-50},
          rotation=360)}));
end PartialFourPort;
