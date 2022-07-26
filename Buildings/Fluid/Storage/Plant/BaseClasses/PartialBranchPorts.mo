within Buildings.Fluid.Storage.Plant.BaseClasses;
model PartialBranchPorts
  "Common port configuration used by plant branches"

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium package";

  parameter Buildings.Fluid.Storage.Plant.Data.NominalValues nom
    "Nominal values";

  Modelica.Fluid.Interfaces.FluidPort_a port_aFroNet(
    redeclare final package Medium = Medium,
    p(displayUnit="Pa"))
    "Port whose nominal flow direction is from the district network"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{90,-70},{110,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bToNet(
    redeclare final package Medium = Medium,
    p(displayUnit="Pa"))
    "Port whose nominal flow direction is to the district network" annotation (
      Placement(transformation(extent={{90,50},{110,70}}), iconTransformation(
          extent={{90,50},{110,70}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_bToChi(
    redeclare final package Medium = Medium,
    p(displayUnit="Pa"))
    "Port whose nominal flow direction is to the chiller" annotation (Placement(
        transformation(extent={{-110,-70},{-90,-50}}), iconTransformation(
          extent={{-110,-70},{-90,-50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aFroChi(
    redeclare final package Medium = Medium,
    p(displayUnit="Pa"))
    "Port whose nominal flow direction is from the chiller" annotation (
      Placement(transformation(extent={{-110,50},{-90,70}}), iconTransformation(
          extent={{-110,50},{-90,70}})));

equation

  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),       graphics={
        Text(
          extent={{-149,-114},{151,-154}},
          textColor={0,0,255},
          textString="%name"), Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This partial model declares the medium model, the nominal values, and the ports
commonly used by branches of the storage plant model.
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
