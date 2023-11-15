within Buildings.Experimental.DHC.Loads.HotWater.BaseClasses;
partial model PartialFourPortDHW
  "A partial model for domestic water heating"
  replaceable package MediumDom =
    Modelica.Media.Interfaces.PartialMedium "Medium for domestic water in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  replaceable package MediumHea =
    Modelica.Media.Interfaces.PartialMedium "Medium for heating source in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
          property_T=293.15,
          X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));

  parameter Boolean allowFlowReversalDom=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for domestic water"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  parameter Boolean allowFlowReversalHea=true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal for heating water"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_aDom(
    redeclare final package Medium = MediumDom,
    m_flow(min=if allowFlowReversalDom then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumDom.h_default, nominal=MediumDom.h_default))
    "Fluid connector for cold water (or recirculation water)"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_bDom(
    redeclare final package Medium = MediumDom,
    m_flow(max=if allowFlowReversalDom then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumDom.h_default, nominal=MediumDom.h_default))
    "Fluid connector for heated domestic hot water"
    annotation (Placement(transformation(extent={{110,50},{90,70}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_aHea(
    redeclare final package Medium = MediumHea,
    m_flow(min=if allowFlowReversalHea then -Modelica.Constants.inf else 0),
    h_outflow(start=MediumHea.h_default, nominal=MediumHea.h_default))
    "Fluid connector for heating water (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_bHea(
    redeclare final package Medium = MediumHea,
    m_flow(max=if allowFlowReversalHea then +Modelica.Constants.inf else 0),
    h_outflow(start=MediumHea.h_default, nominal=MediumHea.h_default))
    "Fluid connector b for heating water (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}})));

  Controls.OBC.CDL.Interfaces.RealInput TDomSet(
    final unit="K",
    displayUnit="degC")
    "Temperature setpoint for domestic water source from heater"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));

  annotation (Documentation(info="<html>
<p>
This partial model can be used for different domestic hot water generation methods.
</p>
</html>", revisions="<html>
<ul>
<li>
October 4, 2023, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialFourPortDHW;
