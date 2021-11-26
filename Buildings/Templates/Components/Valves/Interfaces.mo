within Buildings.Templates.Components.Valves;
package Interfaces "Classes defining the component interfaces"
  extends Modelica.Icons.InterfacesPackage;

  partial model PartialValve
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
      constrainedby Modelica.Media.Interfaces.PartialMedium
      "Medium";

    parameter Buildings.Templates.Components.Types.Actuator typ
      "Equipment type" annotation (Evaluate=true, Dialog(group="Configuration"));

    outer parameter String funStr
      "String used to identify the coil function";
    outer parameter String id
      "System identifier";
    outer parameter ExternData.JSONFile dat
      "External parameter file";

    outer parameter Modelica.SIunits.MassFlowRate mWat_flow_nominal
      "Liquid mass flow rate"
      annotation(Dialog(group = "Nominal condition"));
    outer parameter Modelica.SIunits.PressureDifference dpWat_nominal
      "Liquid pressure drop"
      annotation(Dialog(group = "Nominal condition"));

    Modelica.Fluid.Interfaces.FluidPort_a port_aSup(
      redeclare final package Medium = Medium)
      "Fluid connector a (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{-50,-110},{-30,-90}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_bRet(
      redeclare final package Medium = Medium)
      "Fluid connector b (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{50,-110},{30,-90}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_aRet(
      redeclare final package Medium = Medium)
      "Fluid connector a (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{30,90},{50,110}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_bSup(
      redeclare final package Medium = Medium)
      "Fluid connector b (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{-30,90},{-50,110}})));
    Modelica.Blocks.Interfaces.RealInput y(min=0, max=1)
      if typ <> Buildings.Templates.Components.Types.Actuator.None
      "Actuator control signal"
      annotation (Placement(
        transformation(extent={{-20,-20},{20,20}}, rotation=0,   origin={-120,0}),
        iconTransformation(
          extent={{-10,-10},{10,10}},
          rotation=0,
          origin={-110,0})));
    annotation (
    Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={
          Text(
            extent={{-145,-116},{155,-156}},
            lineColor={0,0,255},
            textString="%name"),                                Rectangle(
            extent={{-100,100},{100,-100}},
            lineColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid)}), Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end PartialValve;
end Interfaces;
