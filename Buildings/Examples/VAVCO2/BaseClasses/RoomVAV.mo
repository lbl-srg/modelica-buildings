within Buildings.Examples.VAVCO2.BaseClasses;
model RoomVAV "Model for CO2 emitted by people"
  replaceable package Medium =
      Modelica.Media.Interfaces.PartialMedium "Medium in the component";

  parameter Modelica.SIunits.Volume VRoo "Volume of room";
  parameter Modelica.SIunits.Volume VPle "Volume of plenum";
  parameter Modelica.SIunits.Area ADam "Damper face area";
  parameter Modelica.SIunits.MassFlowRate m_flow_nominal
    "Nominal mass flow rate";

  Buildings.Fluid.Actuators.Dampers.VAVBoxExponential vav(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=1E2,
    from_dp=false) annotation (Placement(transformation(
     extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,80})));
  Buildings.Fluid.MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    V=VRoo,
    nPorts=5,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_C_flow=true) "Room volume"
    annotation (Placement(
        transformation(extent={{-10,0},{10,20}})));
  Buildings.Fluid.Sensors.TraceSubstances senCO2(
    redeclare package Medium = Medium) "Sensor at volume"
    annotation (Placement(transformation(extent={{16,20}, {36,40}})));
  Buildings.Fluid.MixingVolumes.MixingVolume ple(
    redeclare package Medium = Medium,
    V=VPle,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2)
    "Plenum volume"
    annotation (Placement(
        transformation(extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-60})));
  Modelica.Fluid.Interfaces.FluidPort_a portRoo1(
    redeclare package Medium = Medium) "Fluid port"
    annotation (Placement(transformation(extent=[-170,-10; -150,10])));
  Modelica.Fluid.Interfaces.FluidPort_a portSup(
    redeclare package Medium = Medium) "Fluid port"
    annotation (Placement(transformation(extent={{-10,150},{10,170}})));
  Modelica.Fluid.Interfaces.FluidPort_a portRet(
    redeclare package Medium = Medium) "Fluid port"
    annotation (Placement(transformation(extent={{-10,-170},{10,-150}})));
  Modelica.Fluid.Interfaces.FluidPort_a portRoo2(
    redeclare package Medium = Medium) "Fluid port"
    annotation (Placement(transformation(extent=[150,-10; 170,10])));
  Modelica.Blocks.Interfaces.RealOutput yDam "Damper control signal"
    annotation (Placement(transformation(extent=[160,70; 180,90])));
  Modelica.Blocks.Interfaces.RealInput nPeo "Number of people"
    annotation (Placement(transformation(extent=[-198,-80; -158,-40])));
  Modelica.Blocks.Math.Gain gaiCO2(k=8.18E-6) "CO2 emission per person"
    annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Buildings.Fluid.Sensors.Conversions.To_VolumeFraction volFraCO2(
    MMMea=Modelica.Media.
    IdealGases.Common.SingleGasesData.CO2.MM) "CO2 volume fraction"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  DamperControl con(Kp=1) "Damper controller"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Modelica.Blocks.Math.Gain peoDen(k=2.5/VRoo) "People density per m2"
    annotation (Placement(transformation(extent=[-120,-120; -100,-100])));

  Modelica.Blocks.Sources.RealExpression vavACH(
    y=vav.m_flow*3600/VRoo/1.2)
    "VAV box air change per hour"
    annotation (Placement(transformation(extent=[-124,34; -100,54])));
  Buildings.Fluid.FixedResistances.PressureDrop dpPle(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dp_nominal=20,
    from_dp=true)
    annotation (Placement(transformation(
     extent={{-10,-10},{10,10}},
     rotation=270,
     origin={0,-30})));

equation
  connect(senCO2.C, volFraCO2.m) annotation (Line(
      points={{37,30},{59,30}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(volFraCO2.V, con.u) annotation (Line(
      points={{81,30},{98,30}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(con.y, yDam) annotation (Line(
      points={{121,30},{140,30},{140,80},{170,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(con.y, vav.y) annotation (Line(
      points={{121,30},{140,30},{140,80},{12,80}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(nPeo, gaiCO2.u) annotation (Line(
      points={{-178,-60},{-142,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(nPeo, peoDen.u) annotation (Line(
      points={{-178,-60},{-148,-60},{-148,-110},{-122,-110}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(portSup, vav.port_a) annotation (Line(
      points={{5.55112e-16,160},{5.55112e-16,90},{1.77636e-15,90}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(portRoo1, vol.ports[1]) annotation (Line(
      points={{-160,5.55112e-16},{-120.833,5.55112e-16},{-120.833,4.87687e-22},{
          -81.6667,4.87687e-22},{-81.6667,-5.55112e-16},{-3.2,-5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vav.port_b, vol.ports[2]) annotation (Line(
      points={{-1.77636e-15,70},{0,70},{0,40},{-22,40},{-22,-5.55112e-16},{-1.6,
          -5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senCO2.port, vol.ports[3]) annotation (Line(
      points={{26,20},{26,-5.55112e-16},{0,-5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(portRoo2, vol.ports[4]) annotation (Line(
      points={{160,5.55112e-16},{120.167,5.55112e-16},{120.167,4.87687e-22},{80.3333,
          4.87687e-22},{80.3333,-5.55112e-16},{1.6,-5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpPle.port_a, vol.ports[5]) annotation (Line(
      points={{2.44753e-15,-20},{3.2,-20},{3.2,-5.55112e-16}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(vol.C_flow[1], gaiCO2.y) annotation (Line(points={{-12,4},{-100,4},{-100,
          -60},{-119,-60}}, color={0,0,127}));
  connect(dpPle.port_b, ple.ports[1])
    annotation (Line(points={{0,-40},{0,-62},{0,-62}}, color={0,127,255}));
  connect(ple.ports[2], portRet)
    annotation (Line(points={{0,-58},{0,-160},{0,-160}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-160,-160},{160,
            160}})),
    Icon(
      coordinateSystem(extent={{-160,-160},{160,160}}), graphics={
        Rectangle(
          extent={{-10,162},{10,-160}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-160,10},{160,-10}},
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-108,120},{112,-120}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-92,102},{96,-100}},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None,
          lineColor={0,0,0}),
        Text(
          extent={{-92,-50},{94,-84}},
          pattern=LinePattern.None,
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          textString="%name",
          lineColor={0,0,0}),
        Text(
          extent={{-182,-72},{-112,-102}},
          pattern=LinePattern.None,
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,89},
          textString="nPeo"),
        Text(
          extent={{114,126},{184,96}},
          pattern=LinePattern.None,
          fillColor={0,127,255},
          fillPattern=FillPattern.Solid,
          lineColor={0,0,89},
          textString="yDam")}),
    Documentation(info="<html>
<p>
Model of a room and a plenum. CO2 is injected into the room.
An air damper controls how much air flows into the room to track
the CO2 level.
</p>
</html>", revisions="<html>
<ul>
<li>
January 23, 2017, by Michael Wetter:<br/>
Removed <code>allowFlowReversal=false</code> as
<code>roo.roo49.dpPle.port_a.m_flow</code> and
<code>roo.roo50.dpPle.port_a.m_flow</code>
have negative mass flow rates.
</li>
<li>
January 20, 2017, by Michael Wetter:<br/>
Removed the use of <code>TraceSubstancesFlowSource</code>
and instead used the input connector <code>C_flow</code>
of the volume. This reduces computing time from <i>25</i>
to <i>12</i> seconds.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/628\">#628</a>.
</li>
<li>
July 20, 2007 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end RoomVAV;
