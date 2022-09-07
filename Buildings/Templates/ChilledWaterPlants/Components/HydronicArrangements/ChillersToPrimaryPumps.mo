within Buildings.Templates.ChilledWaterPlants.Components.HydronicArrangements;
model ChillersToPrimaryPumps
  "Hydronic interface between chillers (and optional WSE) and primary pumps"

  replaceable package Medium = Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium";

  outer parameter Integer nChi
    "Number of chillers";
  outer parameter Boolean have_dedChiWatPum
    "Set to true if parallel chillers are connected to dedicated pumps on chilled water side";
  outer parameter Boolean have_eco
    "Set to true if plant has waterside economizer";
  outer parameter Boolean have_parChi
    "Set to true if plant chillers are in parallel";

  final parameter Integer nPorts = nChi + (if have_eco then 1 else 0)
    "Size of vectorized fluid connectors"
    annotation (Evaluate=true, Dialog(group="Configuration"));

  parameter Buildings.Templates.ChilledWaterPlants.Components.Types.HydronicArrangement
    typ "Type of hydronic arrangement"
    annotation (Dialog(group="Configuration"), Evaluate=true);

  parameter Boolean allowFlowReversal=true
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"), Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_aRet(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "CHW return from CHW distribution"
    annotation (Placement(transformation(extent={{190,-110},{210,-90}}),
    iconTransformation(extent={{190,-310},{208,-292}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bRet[nPorts](
    redeclare each final package Medium = Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "CHW return to chillers and WSE"
    annotation (Placement(transformation(
          extent={{-210,-140},{-190,-60}}),iconTransformation(extent={{-210,-340},
            {-190,-260}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_bSup[nChi](
    redeclare each final package Medium = Medium,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "CHW supply to CHW distribution"
    annotation (Placement(
        transformation(extent={{190,80},{210,160}}),iconTransformation(extent={{188,260},
            {208,340}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_aByp(
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "CHW supply from minimum flow bypass or common leg"    annotation (
      Placement(transformation(extent={{190,-10},{210,10}}),iconTransformation(
          extent={{190,-10},{210,10}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_aSup[nPorts](
    redeclare each final package Medium = Medium,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "CHW supply from chillers and WSE"
    annotation (Placement(transformation(
          extent={{-210,80},{-190,160}}), iconTransformation(extent={{-210,260},
            {-190,340}})));

  Buildings.Templates.Components.HydronicArrangements.MultipleToMultiple manSup(
    redeclare final package Medium = Medium,
    final nPorts_a=nPorts,
    final nPorts_b=nChi,
    final typ=if have_dedChiWatPum then
      Buildings.Templates.Components.Types.HydronicArrangement.Dedicated else
      Buildings.Templates.Components.Types.HydronicArrangement.Headered)
    "Hydronic routing"
    annotation (Placement(transformation(extent={{-10,110},{10,130}})));
  Buildings.Templates.Components.HydronicArrangements.SingleToMultiple manRet(
    redeclare final package Medium = Medium,
    final nPorts=nPorts)
    "Hydronic routing"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}})));
equation
  connect(ports_aSup, manSup.ports_a)
    annotation (Line(points={{-200,120},{-10,120}}, color={0,127,255}));
  connect(manSup.ports_b, ports_bSup)
    annotation (Line(points={{10,120},{200,120}}, color={0,127,255}));
  connect(manRet.port_a, port_aRet)
    annotation (Line(points={{10,-100},{200,-100}}, color={0,127,255}));
  connect(manRet.ports_b, ports_bRet)
    annotation (Line(points={{-10,-100},{-200,-100}}, color={0,127,255}));
annotation (
  defaultComponentName="con",
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-200,-600},{200,600}}), graphics={
        Text(
          extent={{-149,-614},{151,-654}},
          textColor={0,0,255},
          textString="%name")}),
 Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-200,-200},{200,200}})));
end ChillersToPrimaryPumps;
