within Buildings.Templates.ChilledWaterPlant.Components.CondenserWaterPumpGroup.Interfaces;
partial model PartialCondenserWaterPumpGroup

  parameter Buildings.Templates.ChilledWaterPlant.Components.Types.CondenserWaterPumpGroup typ "Type of pump"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  outer parameter String id
    "System identifier";
  outer parameter ExternData.JSONFile dat
    "External parameter file";

  replaceable package Medium = Buildings.Media.Water "Medium in the component";

  final parameter Boolean is_dedicated = typ == Buildings.Templates.ChilledWaterPlant.Components.Types.PrimaryPumpGroup.Dedicated;

  parameter Integer nChi "Number of chillers";
  parameter Integer nPum = nChi "Number of primary pumps";
  outer parameter Integer nCooTow "Number of cooling towers";

  parameter Boolean have_WSE "= true if pump supply waterside economizer";

  parameter Modelica.Units.SI.MassFlowRate mTot_flow_nominal = m_flow_nominal*nPum "Total mass flow rate for pump group";

  // FixMe: Flow and dp should be read from pump curve, but are currently
  // assumed from system flow rate and pressure drop.
  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = mTot_flow_nominal/nPum
    "Nominal mass flow rate per pump";
  parameter Modelica.Units.SI.PressureDifference dp_nominal
    "Nominal pressure drop per pump";

  parameter Modelica.Units.SI.PressureDifference dpValve_nominal=
    dat.getReal(varName=id + ".CondenserPump.dpValve_nominal.value")
    "Check valve pressure drop";

  Buildings.Templates.ChilledWaterPlant.BaseClasses.BusCondenserWater
      busCon(
    final nChi=nChi,
             final nPum=nPum, nCooTow=nCooTow)
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
  replaceable parameter Fluid.Movers.Data.Generic per(pressure(V_flow=
          m_flow_nominal/1000 .* {0,1,2}, dp=dp_nominal .* {1.5,1,0.5}))
    constrainedby Fluid.Movers.Data.Generic
    "Performance data"
    annotation (
      choicesAllMatching=true,
      Placement(transformation(extent={{-88,-88},{-68,-68}})));
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
end PartialCondenserWaterPumpGroup;
