within Buildings.Fluid.Storage.Plant.BaseClasses;
model PartialBranchPorts
  "(Draft) Common port configuration used by plant branches"

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium package";

  parameter Buildings.Fluid.Storage.Plant.BaseClasses.NominalValues nom
    "Nominal values";

  Modelica.Fluid.Interfaces.FluidPort_a port_CHWR(
    redeclare final package Medium = Medium,
    p(displayUnit="Pa"))
    "Port that connects CHW return line to the warmer side of the tank"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_CHWS(
    redeclare final package Medium = Medium,
    p(displayUnit="Pa"))
    "Port that connects the cooler side of the tank to the CHW supply line"
    annotation (Placement(transformation(extent={{90,50},{110,70}}),
        iconTransformation(extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_chiInl(
    redeclare final package Medium = Medium,
    p(displayUnit="Pa"))
    "Port that connects the warmer side of the tank to the chiller inlet"
    annotation (Placement(transformation(extent={{-110,-70},{-90,-50}}),
        iconTransformation(extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_chiOut(
    redeclare final package Medium = Medium,
    p(displayUnit="Pa"))
    "Port that connects the chiller outlet to the warmer side of the tank"
    annotation (Placement(transformation(extent={{-110,50},{-90,70}}),
        iconTransformation(extent={{-110,50},{-90,70}})));

equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={
        Text(
          extent={{-62,-122},{62,-98}},
          textColor={0,0,127},
          textString="%name"), Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
Documentation pending.
</p>
</html>", revisions="<html>
<ul>
<li>
April 11, 2022 by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2859\">#2859</a>.
</li>
</ul>
</html>"));
end PartialBranchPorts;
