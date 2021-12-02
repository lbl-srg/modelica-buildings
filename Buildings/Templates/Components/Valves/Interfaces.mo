within Buildings.Templates.Components.Valves;
package Interfaces "Classes defining the component interfaces"
  extends Modelica.Icons.InterfacesPackage;

  partial model PartialValve
    replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
      constrainedby Modelica.Media.Interfaces.PartialMedium
      "Medium";

    parameter Buildings.Templates.Components.Types.Valve typ
      "Equipment type"
      annotation (Evaluate=true, Dialog(group="Configuration"));

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
      annotation (Placement(transformation(extent={{30,-110},{50,-90}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_bRet(
      redeclare final package Medium = Medium)
      "Fluid connector b (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{-30,-110},{-50,-90}})));
    Modelica.Fluid.Interfaces.FluidPort_a port_aRet(
      redeclare final package Medium = Medium)
      "Fluid connector a (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{-50,90},{-30,110}})));
    Modelica.Fluid.Interfaces.FluidPort_b port_bSup(
      redeclare final package Medium = Medium)
      "Fluid connector b (positive design flow direction is from port_a to port_b)"
      annotation (Placement(transformation(extent={{50,90},{30,110}})));
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
          Text(
            extent={{-145,-116},{155,-156}},
            lineColor={0,0,255},
            textString="%name"),
      Bitmap(
        visible=typ==Buildings.Templates.Components.Types.Valve.TwoWay or
          typ==Buildings.Templates.Components.Types.Valve.ThreeWay,
        extent={{-180,-40},{-100,40}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Actuators/Modulated.svg"),
      Bitmap(
        visible=typ==Buildings.Templates.Components.Types.Valve.TwoWay,
        extent={{-100,-100},{40,100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/TwoWay.svg"),
      Bitmap(
        visible=typ==Buildings.Templates.Components.Types.Valve.ThreeWay,
        extent={{-100,-100},{40,100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/ThreeWay.svg"),
      Bitmap(
        visible=typ==Buildings.Templates.Components.Types.Valve.None,
        extent={{-70,-100},{70,100}},
        fileName="modelica://Buildings/Resources/Images/Templates/Components/Valves/None.svg")}),
      Diagram(
          coordinateSystem(preserveAspectRatio=false)));
  end PartialValve;
end Interfaces;
