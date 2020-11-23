within Buildings.Applications.DHC.Examples.Combined.Generation5.Unidirectional.Distribution.BaseClasses;
partial model PartialDistributionSystem
  "Partial model for distribution system"
  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium model"
    annotation (__Dymola_choicesAllMatching=true);
  parameter Integer nCon
    "Number of connections"
    annotation(Evaluate=true);
  parameter Boolean allowFlowReversal = false
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);
  // IO CONNECTORS
  Modelica.Fluid.Interfaces.FluidPorts_a ports_conRet[nCon](
    redeclare each package Medium = Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Connection return port" annotation (Placement(transformation(
        extent={{-10,-40},{10,40}},
        rotation=90,
        origin={80,100}), iconTransformation(
        extent={{-20,-80},{20,80}},
        rotation=90,
        origin={120,100})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_conSup[nCon](
    redeclare each package Medium = Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Connection supply port" annotation (Placement(transformation(
        extent={{-10,-40},{10,40}},
        rotation=90,
        origin={-80,100}), iconTransformation(
        extent={{-20,-80},{20,80}},
        rotation=90,
        origin={-120,100})));
  Modelica.Fluid.Interfaces.FluidPort_a port_disSupInl(
    redeclare package Medium=Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Distribution supply inlet port"
    annotation (Placement(
        transformation(extent={{-110,-10},{-90,10}}), iconTransformation(extent=
           {{-220,-20},{-180,20}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_disSupOut(
    redeclare final package Medium=Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Distribution supply outlet port"
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),
      iconTransformation(extent={{180,-20},{220,20}})));
  annotation (
  Icon(coordinateSystem(preserveAspectRatio=false,
   extent={{-200,-100},{200,100}}),
   graphics={
    Text(
      extent={{-149,-104},{151,-144}},
      lineColor={0,0,255},
      textString="%name"),
      Rectangle(extent={{-200,-100},{200,100}},
        lineColor={0,0,0})}),
      Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})));
end PartialDistributionSystem;
