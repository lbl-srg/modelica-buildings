within Buildings.Templates.Components.Pumps.Interfaces;
partial model PartialPump "Interface class for pumps"
  // Duplicate PartialTwoPortInterface but with conditional vector/scalar ports
  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component"
      annotation (choices(
        choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
        choice(redeclare package Medium = Buildings.Media.Water "Water"),
        choice(redeclare package Medium =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));

  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal"
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  parameter Boolean has_singlePort_a = true
    "= true if single fluid connector a, = false if vectorized fluid connector a";
  parameter Boolean has_singlePort_b = true
    "= true if single fluid connector a, = false if vectorized fluid connector a";

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = Medium,
     m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
     h_outflow(start = Medium.h_default, nominal = Medium.h_default),
     p(start=Medium.p_default)) if has_singlePort_a
    "Fluid connector a (positive design flow direction is from port(s)_a to port(s)_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
     h_outflow(start = Medium.h_default, nominal = Medium.h_default),
     p(start=Medium.p_default)) if has_singlePort_b
    "Fluid connector b (positive design flow direction is from port(s)_a to port(s)_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));

  Modelica.Fluid.Interfaces.FluidPorts_a ports_a[nPum](
    redeclare each final package Medium = Medium,
     each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
     each h_outflow(start = Medium.h_default, nominal = Medium.h_default),
    each p(start=Medium.p_default)) if not has_singlePort_a
     "Vectorized fluid connector a (positive design flow direction is from port(s)_a to port(s)_b)"
     annotation (Placement(
        transformation(extent={{-108,-30},{-92,30}}), iconTransformation(extent=
           {{-108,-30},{-92,30}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b[nPum](
    redeclare each final package Medium = Medium,
     each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
     each h_outflow(start = Medium.h_default, nominal = Medium.h_default),
    each p(start=Medium.p_default)) if not has_singlePort_b
     "Vectorized fluid connector b (positive design flow direction is from port(s)_a to port(s)_b)"
     annotation (Placement(
        transformation(extent={{92,-30},{108,30}}), iconTransformation(extent={{
            92,-30},{108,30}})));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Nominal mass flow rate" annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_small(min=0) = 1E-4*abs(
    m_flow_nominal) "Small mass flow rate for regularization of zero flow"
    annotation (Dialog(tab="Advanced"));
  // Diagnostics
   parameter Boolean show_T = false
    "= true, if actual temperature at port is computed"
    annotation (
      Dialog(tab="Advanced", group="Diagnostics"),
      HideResult=true);

  parameter Buildings.Templates.Components.Types.Pump typ
    "Equipment type"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Integer text_rotation = 0
    "Text rotation angle in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));
  parameter Boolean text_flip = false
    "True to flip text horizontally in icon layer"
    annotation(Dialog(tab="Graphics", enable=false));

  parameter Integer nPum(final min=1) = 1
    "Number of pumps"
    annotation(Evaluate=true,
      Dialog(group="Configuration"));

  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Total pressure rise"
    annotation (Dialog(group="Nominal condition",
      enable=typ <> Buildings.Templates.Components.Types.Pump.None));
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal = 4000
    "Nominal pressure drop of check valve"
    annotation (Dialog(group="Nominal condition",
      enable=typ <> Buildings.Templates.Components.Types.Pump.None));

  replaceable parameter Buildings.Fluid.Movers.Data.Generic per(
    pressure(
      V_flow={0, 1, 2} * m_flow_nominal / 1000 / nPum,
      dp={1.5, 1, 0} * dp_nominal))
    constrainedby Buildings.Fluid.Movers.Data.Generic(
      motorCooledByFluid=false)
    "Performance data"
    annotation (
      choicesAllMatching=true,
      Dialog(enable=typ <> Buildings.Templates.Components.Types.Pum.None),
      Placement(transformation(extent={{-90,-88},{-70,-68}})));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  Buildings.Templates.Components.Interfaces.Bus bus
    "Control bus"
    annotation (
      Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=true), graphics={
    Bitmap(
      visible=(typ==Buildings.Templates.Components.Types.Pump.SingleVariable or
        typ==Buildings.Templates.Components.Types.Pump.SingleConstant),
        extent={{-100,-100},{100,100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Pumps/Inline.svg"),
    Bitmap(
      visible=typ==Buildings.Templates.Components.Types.Pump.SingleVariable,
      extent=if text_flip then {{100,-380},{-100,-180}} else {{-100,-380},{100,-180}},
      rotation=text_rotation,
      fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/VFD.svg"),
    Line(
      visible=typ==Buildings.Templates.Components.Types.Pump.SingleVariable,
      points={{0,-180},{0,-100}},
      color={0,0,0},
      thickness=1)}),
   Diagram(coordinateSystem(preserveAspectRatio=false)));

end PartialPump;
