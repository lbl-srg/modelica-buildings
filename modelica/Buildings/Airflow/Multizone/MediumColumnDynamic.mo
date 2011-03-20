within Buildings.Airflow.Multizone;
model MediumColumnDynamic
  "Vertical shaft with no friction and storage of heat and mass"
  import Modelica.Constants;
  outer Modelica.Fluid.System system "System wide properties";

  replaceable package Medium = Modelica.Media.Interfaces.PartialMedium
    "Medium in the component" annotation (choicesAllMatching=true);

  parameter Modelica.SIunits.Length h(min=0) = 3 "Height of shaft";
  parameter Boolean allowFlowReversal=system.allowFlowReversal
    "= true to allow flow reversal, false restricts to design direction (port_a -> port_b)"
    annotation (Dialog(tab="Assumptions"),Evaluate=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Constants.inf else 0),
    p(start=Medium.p_default, nominal=Medium.p_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}}, rotation=0),
        iconTransformation(extent={{-10,90},{10,110}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Constants.inf else 0),
    p(start=Medium.p_default, nominal=Medium.p_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}}, rotation=
           0), iconTransformation(extent={{10,-110},{-10,-90}})));

  Fluid.MixingVolumes.MixingVolume vol(
    final nPorts=2,
    redeclare final package Medium = Medium,
    final V=V,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final substanceDynamics=substanceDynamics,
    final traceDynamics=traceDynamics,
    final p_start=p_start,
    final use_T_start=use_T_start,
    final T_start=T_start,
    final h_start=h_start,
    final X_start=X_start,
    final C_start=C_start,
    final use_HeatTransfer=use_HeatTransfer,
    redeclare final model HeatTransfer = HeatTransfer)
    "Air volume in the shaft"                                    annotation (
      Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,0})));

  MediumColumn colTop(
    redeclare final package Medium = Medium,
    final densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom,
    h=h/2,
    final allowFlowReversal=allowFlowReversal)
    "Medium column that connects to top port"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));

  MediumColumn colBot(
    redeclare final package Medium = Medium,
    final densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop,
    h=h/2,
    final allowFlowReversal=allowFlowReversal)
    "Medium colum that connects to bottom port"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));

  parameter Modelica.SIunits.Volume V "Volume in medium shaft";

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=system.energyDynamics
    "Formulation of energy balance"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=system.massDynamics
    "Formulation of mass balance"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics substanceDynamics=energyDynamics
    "Formulation of substance balance"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics traceDynamics=energyDynamics
    "Formulation of trace substance balance"
    annotation(Evaluate=true, Dialog(tab = "Assumptions", group="Dynamics"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Boolean use_T_start = true "= true, use T_start, otherwise h_start"
    annotation(Dialog(tab = "Initialization"), Evaluate=true);
  parameter Medium.Temperature T_start=
    if use_T_start then system.T_start else Medium.temperature_phX(p_start,h_start,X_start)
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization", enable = use_T_start));
  parameter Medium.SpecificEnthalpy h_start=
    if use_T_start then Medium.specificEnthalpy_pTX(p_start, T_start, X_start) else Medium.h_default
    "Start value of specific enthalpy"
    annotation(Dialog(tab = "Initialization", enable = not use_T_start));
  parameter Medium.MassFraction X_start[Medium.nX] = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
       quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));

  // Heat transfer through boundary
  parameter Boolean use_HeatTransfer = false
    "= true to use the HeatTransfer model"
      annotation (Dialog(tab="Assumptions", group="Heat transfer"));
  replaceable model HeatTransfer =
      Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.IdealHeatTransfer
    constrainedby
    Modelica.Fluid.Vessels.BaseClasses.HeatTransfer.PartialVesselHeatTransfer
    "Wall heat transfer"
      annotation (Dialog(tab="Assumptions", group="Heat transfer",enable=use_HeatTransfer),choicesAllMatching=true);
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heatPort if use_HeatTransfer
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

equation
  connect(colBot.port_a, vol.ports[1]) annotation (Line(
      points={{6.10623e-16,-40},{0,-40},{0,-2},{-10,-2}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.ports[2], colTop.port_b) annotation (Line(
      points={{-10,2},{0,2},{0,40},{4.996e-16,40}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(colTop.port_a, port_a) annotation (Line(
      points={{6.10623e-16,60},{6.10623e-16,79},{5.55112e-16,79},{5.55112e-16,
          100}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(colBot.port_b, port_b) annotation (Line(
      points={{4.996e-16,-60},{-5.55112e-16,-60},{-5.55112e-16,-100}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(heatPort, vol.heatPort) annotation (Line(
      points={{-100,5.55112e-16},{-60,5.55112e-16},{-60,-20},{-20,-20},{-20,-10}},
      color={191,0,0},
      smooth=Smooth.None));

  annotation (
    Icon(graphics={
        Line(
          points={{0,100},{0,-100},{0,-98}},
          pattern=LinePattern.None,
          smooth=Smooth.None),
        Text(
          extent={{24,-78},{106,-100}},
          lineColor={0,0,127},
          textString="Bottom"),
        Text(
          extent={{32,104},{98,70}},
          lineColor={0,0,127},
          textString="Top"),
        Text(
          extent={{42,26},{94,-10}},
          lineColor={0,0,127},
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid,
          textString="h=%h"),
        Rectangle(
          visible=densitySelection == Buildings.Airflow.Multizone.Types.densitySelection.fromTop,
          extent={{-16,78},{16,-2}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{-50.5,20.5},{50.5,-20.5}},
          lineColor={0,0,127},
          origin={-72.5,-12.5},
          rotation=90,
          textString="%name"),
        Rectangle(
          visible=densitySelection == Buildings.Airflow.Multizone.Types.densitySelection.actual,
          extent={{-16,80},{16,54}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          visible=densitySelection == Buildings.Airflow.Multizone.Types.densitySelection.fromBottom,
          extent={{-16,0},{16,-82}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Rectangle(
          visible=densitySelection == Buildings.Airflow.Multizone.Types.densitySelection.actual,
          extent={{-16,-55},{16,-80}},
          fillColor={85,170,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Ellipse(
          extent={{-40,40},{40,-40}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,128,255})}),
defaultComponentName="col",
Documentation(info="<html>
<p>
This model contains a completely mixed fluid volume and
models that take into account the pressure difference of 
a medium column that is at the same temperature as the
fluid volume. It can be used to model the pressure difference 
caused by a stack effect.</p>
<p>
Set the parameter <code>use_HeatTransfer=true</code> to expose
a <code>heatPort</code>. This <code>heatPort</code> can be used
to add or subtract heat from the volume. This allows, for example,
to use this model in conjunction with a model for heat transfer through
walls to model a solar chimney that stores heat.
</p>
<p>
For a steady-state model, use
<a href=\"modelica:Buildings.Airflow.Multizone.MediumColumn\">
Buildings.Airflow.Multizone.MediumColumn</a> instead of this model.
</p>
<p>In this model, the parameter <code>h</code> must always be positive, and the port <code>port_a</code> must be
at the top of the column.
</html>",
revisions="<html>
<ul>
<li><i>July 28, 2010</i> by Michael Wetter:<br>
       Released first version.
</ul>
</html>"),
    Diagram(graphics));
end MediumColumnDynamic;
