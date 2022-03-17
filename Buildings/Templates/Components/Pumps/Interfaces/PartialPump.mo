within Buildings.Templates.Components.Pumps.Interfaces;
partial model PartialPump "Interface class for pump"
  extends Fluid.Interfaces.PartialTwoPortInterface;

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
