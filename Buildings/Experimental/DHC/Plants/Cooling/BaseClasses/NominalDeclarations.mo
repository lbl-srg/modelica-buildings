within Buildings.Experimental.DHC.Plants.Cooling.BaseClasses;
partial model NominalDeclarations
  "Class that declares the common ports and nominal values"

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium package";

  parameter Buildings.Experimental.DHC.Plants.Cooling.Data.NominalValues nom
    "Nominal values"
    annotation (Placement(transformation(extent={{60,70},{80,90}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_aRetNet(
    redeclare final package Medium = Medium)
    "Port that connects to the return side of the district network"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bSupNet(
    redeclare final package Medium = Medium)
    "Port that connects to the supply side of the district network" annotation (
     Placement(transformation(extent={{90,50},{110,70}}), iconTransformation(
          extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bRetChi(
    redeclare final package Medium = Medium)
    "Port that connects to the return side of the chiller" annotation (
      Placement(transformation(extent={{-110,-70},{-90,-50}}),
        iconTransformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aSupChi(
    redeclare final package Medium = Medium)
    "Port that connects to the supply side of the chiller"  annotation (
      Placement(transformation(extent={{-110,50},{-90,70}}), iconTransformation(
          extent={{-110,50},{-90,70}})));

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={
                               Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-42,-60}}, color={28,108,200}),
        Text(
          extent={{-139,-104},{161,-144}},
          textColor={0,0,255},
          textString="%name")}),                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    defaultComponentName = "tanBra",
    Documentation(info="<html>
<p>
This partial model provides declarations for the medium, the nominal values,
and the common ports.
</p>
</html>", revisions="<html>
<ul>
<li>
May 31, 2023 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end NominalDeclarations;
