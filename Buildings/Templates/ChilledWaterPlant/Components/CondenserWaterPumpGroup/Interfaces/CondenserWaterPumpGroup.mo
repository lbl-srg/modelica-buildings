within Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces;
partial model CondenserWaterPumpGroup
  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  parameter Integer nChi = 1 "Number of chillers";
  parameter Integer nPumPri = 1 "Number of primary pumps";

  parameter Boolean has_wse "= true if pump supply waterside economizer";

  Bus busCon "Control bus" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={0,100}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={0,100})));

  parameter Buildings.Types.CondenserWaterPumpGroup typ "Type of pump"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Pump group inlet" annotation (Placement(transformation(extent={{-110,-10},{
            -90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b[nChi](
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Pump group outlets" annotation (Placement(transformation(extent={{108,-32},
            {92,32}}), iconTransformation(extent={{108,-32},{92,32}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_wse(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) if has_wse
    "Waterside economizer outlet" annotation (Placement(transformation(extent={{
            90,-70},{110,-50}})));
equation
  connect(ports_b, ports_b)
    annotation (Line(points={{100,0},{100,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false),
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
end CondenserWaterPumpGroup;
