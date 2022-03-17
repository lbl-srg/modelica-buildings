within Buildings.Templates.AirHandlersFans.Components.HeatRecovery.Interfaces;
partial model PartialHeatRecovery "Interface class for heat recovery"

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";

  parameter Buildings.Templates.AirHandlersFans.Types.HeatRecovery typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  Buildings.Templates.AirHandlersFans.Interfaces.Bus bus
    if typ <> Buildings.Templates.AirHandlersFans.Types.HeatRecovery.None
    "Control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aOut(
    redeclare final package Medium = MediumAir,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ <> Buildings.Templates.AirHandlersFans.Types.HeatRecovery.None
    "Outdoor air inlet"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bOut(
    redeclare final package Medium = MediumAir,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ <> Buildings.Templates.AirHandlersFans.Types.HeatRecovery.None
    "Outdoor air outlet"
    annotation (Placement(transformation(extent={{110,-70},{90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aRel(
    redeclare final package Medium = MediumAir,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ <> Buildings.Templates.AirHandlersFans.Types.HeatRecovery.None
    "Relief/exhaust air inlet"
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bRel(
    redeclare final package Medium = MediumAir,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumAir.h_default, nominal=MediumAir.h_default))
    if typ <> Buildings.Templates.AirHandlersFans.Types.HeatRecovery.None
    "Relief/exhaust air outlet"
    annotation (Placement(transformation(extent={{-90,50},{-110,70}})));
  annotation (Icon(graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-149,-110},{151,-150}},
          lineColor={0,0,255},
          textString="%name")}));
end PartialHeatRecovery;
