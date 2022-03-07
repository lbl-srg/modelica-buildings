within Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces;
partial model PartialCondenserWaterPumpGroup

  parameter Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces.Data dat "Condenser water group data";

  replaceable package Medium = Buildings.Media.Water "Medium in the component";

  outer parameter Integer nChi "Number of chillers";
  outer parameter Integer nCooTow "Number of cooling towers";

  parameter Boolean have_WSE "= true if pump supply waterside economizer";

  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusChilledWater busCon(
    final nChi=nChi, final nCooTow=nCooTow)
    "Control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = Medium,
    m_flow(min=0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Pump group inlet" annotation (Placement(transformation(extent={{-110,-10},{
            -90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b[nChi](
    redeclare each final package Medium = Medium,
    each m_flow(max=0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Pump group outlets" annotation (Placement(transformation(extent={{108,-32},
            {92,32}}), iconTransformation(extent={{108,-32},{92,32}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_wse(
    redeclare final package Medium = Medium,
    m_flow(min=0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) if have_WSE
    "Waterside economizer outlet" annotation (Placement(transformation(extent={{
            90,-70},{110,-50}})));
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-88,-88},{-68,-68}})),
              Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
      Text(
          extent={{-100,-100},{100,-140}},
          lineColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),            Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialCondenserWaterPumpGroup;
