within Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps.Interfaces;
partial model PartialCondenserPump "Partial condenser pump model"

  replaceable package Medium = Buildings.Media.Water "Medium in the component";

  // Structure parameters

  parameter
    Buildings.Templates.ChilledWaterPlant.Components.Types.CondenserPump typ
    "Type of pump arrangement"
    annotation (Evaluate=true, Dialog(group="Configuration", enable=false));
  final parameter Boolean is_dedicated=
    typ ==Buildings.Templates.ChilledWaterPlant.Components.Types.CondenserPump.Dedicated
    "= true if condenser pumps are dedicated";

  parameter Buildings.Templates.Components.Types.Valve typValConWatChi[nChi]
    "Type of chiller condenser water side isolation valve";

  outer parameter Boolean have_eco
    "= true if pump supply waterside economizer";

  parameter Integer nPum "Number of condenser pumps"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  outer parameter Integer nChi "Number of chillers";
  outer parameter Integer nCooTow "Number of cooling towers";

  // Record

  parameter
    Buildings.Templates.ChilledWaterPlant.Components.CondenserPumps.Interfaces.Data
    dat(
      final typ=typ, 
      final nPum=nPum, 
      pum(final typ = pum.typ)) 
    "Condenser pumps data";

  inner replaceable Buildings.Templates.Components.Pumps.MultipleVariable pum
    constrainedby Buildings.Templates.Components.Pumps.Interfaces.PartialPump(
      redeclare final package Medium = Medium,
      final nPum=nPum,
      final have_singlePort_a=true,
      final dat=dat.pum)
    "Condenser pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})),
      choices(
        choice(redeclare Buildings.Templates.Components.Pumps.MultipleVariable
          pum "Variable speed pumps in parallel")));

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
    "Pump group inlet"
    annotation (Placement(transformation(extent={{-110,-10},{
            -90,10}}), iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b[nChi](
    redeclare each final package Medium = Medium,
    each m_flow(max=0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Pump group outlets"
    annotation (Placement(transformation(extent={{108,-32},
            {92,32}}), iconTransformation(extent={{108,-32},{92,32}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_wse(
    redeclare final package Medium = Medium,
    m_flow(min=0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default)) if have_eco
    "Waterside economizer outlet"
    annotation (Placement(transformation(extent={{
            90,-70},{110,-50}})));

equation
  connect(port_a, pum.port_a)
    annotation (Line(points={{-100,0},{-10,0}}, color={0,127,255}));
  connect(busCon.pumCon, pum.bus) annotation (Line(
      points={{0.1,100.1},{0.1,56},{0,56},{0,10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,6},{-3,6}},
      horizontalAlignment=TextAlignment.Right));

    annotation (
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
        textString="%name")}),
      Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end PartialCondenserPump;
