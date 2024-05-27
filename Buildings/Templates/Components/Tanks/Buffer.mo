within Buildings.Templates.Components.Tanks;
model Buffer "Buffer tank"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  parameter Boolean have_tan=true
    "Set to true for tank, false for direct pass through"
    annotation (Evaluate=true, Dialog(group="Configuration"));
  parameter Modelica.Units.SI.Volume V(start=0)
    "Volume"
    annotation (Dialog(enable=have_tan));
  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));
  parameter Buildings.Templates.Components.Types.IntegrationPoint icon_pipe=
      Buildings.Templates.Components.Types.IntegrationPoint.None "Pipe symbol"
    annotation (Dialog(tab="Graphics", enable=false));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare final package Medium=Medium,
    final V=V,
    final m_flow_nominal=m_flow_nominal,
    final m_flow_small=m_flow_small,
    final energyDynamics=energyDynamics,
    final massDynamics=energyDynamics,
    final mSenFac=1,
    final allowFlowReversal=allowFlowReversal,
    nPorts=2)
    if have_tan
    "Tank"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
  Buildings.Templates.Components.Routing.PassThroughFluid pas(
    redeclare final package Medium=Medium,
    final allowFlowReversal=allowFlowReversal)
    if not have_tan
    "Direct pass through"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
equation
  connect(port_a, vol.ports[1])
    annotation (Line(points={{-100,0},{-1,0}}, color={0,127,255}));
  connect(vol.ports[2], port_b)
    annotation (Line(points={{1,0},{100,0}}, color={0,127,255}));
  connect(port_a, pas.port_a) annotation (Line(points={{-100,0},{-20,0},{-20,-20},
          {-10,-20}}, color={0,127,255}));
  connect(pas.port_b, port_b) annotation (Line(points={{10,-20},{20,-20},{20,0},
          {100,0}}, color={0,127,255}));
  annotation (
  defaultComponentName="tan",
  Icon(graphics={
        Line(
          points={{-100,0},{100,0}},
          color={0,0,0},
          thickness=4,
          visible=not have_tan and icon_pipe == Buildings.Templates.Components.Types.IntegrationPoint.Supply),
        Line(
          points={{-100,0},{100,0}},
          color={0,0,0},
          thickness=4,
          visible=not have_tan and icon_pipe == Buildings.Templates.Components.Types.IntegrationPoint.Return,
          pattern=LinePattern.Dash),
        Line(
          points={{-100,0},{100,0}},
          color={0,127,255},
          visible=not have_tan and icon_pipe == Buildings.Templates.Components.Types.IntegrationPoint.None),
        Rectangle(
          extent={{-100,160},{100,-100}},
          lineColor={0,0,0},
          lineThickness=1,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          visible=have_tan)}),
    Documentation(info="<html>
<p>
Model of a buffer tank based on the instantaneously mixed volume model
<a href=\"modelica://Buildings.Fluid.MixingVolumes.MixingVolume\">
Buildings.Fluid.MixingVolumes.MixingVolume</a>.
Manufacturers recommend tank designs that promote mixing (e.g., with
inside baffle plates) because a fully mixed tank yields an effective 
buffer time greater than a stratified tank.
The validation model 
<a href=\"modelica://Buildings.Templates.Components.Validation.Tanks\">
Buildings.Templates.Components.Validation.Tanks</a>
shows that achieving the supply temperature at the tank outlet requires 
circulating a fluid volume several times greater than the tank's actual 
volume.
</p>
</html>"));
end Buffer;
