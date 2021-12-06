within Buildings.Templates.Components.Valves;
package Interfaces "Classes defining the component interfaces"
  extends Modelica.Icons.InterfacesPackage;

  partial model PartialValve
    extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;

    parameter Buildings.Templates.Components.Types.Valve typ
      "Equipment type"
      annotation (Evaluate=true, Dialog(group="Configuration"));

    parameter Modelica.SIunits.PressureDifference dpValve_nominal(
       displayUnit="Pa",
       min=0)=0
      "Nominal pressure drop of fully open valve"
      annotation(Dialog(group="Nominal condition",
        enable=typ<>Buildings.Templates.Components.Types.Valve.None));
    parameter Modelica.SIunits.PressureDifference dpFixed_nominal(
      displayUnit="Pa",
      min=0)=0
      "Nominal pressure drop of pipes and other equipment in flow leg"
      annotation(Dialog(group="Nominal condition",
        enable=typ<>Buildings.Templates.Components.Types.Valve.None));
    parameter Modelica.SIunits.PressureDifference dpFixedByp_nominal(
      displayUnit="Pa",
      min=0)=dpFixed_nominal
      "Nominal pressure drop in the bypass line"
      annotation(Dialog(group="Nominal condition",
        enable=typ==Buildings.Templates.Components.Types.Valve.ThreeWay));

    Modelica.Fluid.Interfaces.FluidPort_a portByp_a(
      redeclare final package Medium = Medium,
      p(start=Medium.p_default),
      m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
      h_outflow(start=Medium.h_default, nominal=Medium.h_default))
      if typ==Buildings.Templates.Components.Types.Valve.ThreeWay
      "Fluid connector with bypass line"
      annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
    Buildings.Controls.OBC.CDL.Interfaces.RealInput y(min=0, max=1)
      if typ <> Buildings.Templates.Components.Types.Valve.None
      "Valve control signal"
      annotation (Placement(
        visible=false,
        transformation(extent={{-20,-20},{20,20}}, rotation=0,   origin={-120,0}),
        iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,0})));
    annotation (
    Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={
      Bitmap(
        visible=typ==Buildings.Templates.Components.Types.Valve.TwoWay or
          typ==Buildings.Templates.Components.Types.Valve.ThreeWay,
        extent={{-40,60},{40,140}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulated.svg"),
      Bitmap(
        visible=typ==Buildings.Templates.Components.Types.Valve.TwoWay,
        extent={{-100,-100},{100,100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg",
            rotation=-90),
      Bitmap(
        visible=typ==Buildings.Templates.Components.Types.Valve.ThreeWay,
        extent={{-100,-100},{100,100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/ThreeWay.svg",
            rotation=-90),
      Bitmap(
        visible=typ==Buildings.Templates.Components.Types.Valve.None,
        extent={{-100,100},{100,-100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/None.svg",
            rotation=-90)}),
      Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end PartialValve;
end Interfaces;
