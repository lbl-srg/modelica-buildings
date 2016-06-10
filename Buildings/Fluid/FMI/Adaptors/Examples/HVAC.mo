within Buildings.Fluid.FMI.Adaptors.Examples;
model HVAC "Example of an HVAC model"
  extends Modelica.Icons.Example;
  Buildings.Fluid.FMI.Adaptors.ThermalZone theZonAda(
    redeclare final package Medium = MediumA,
    nFluPor=1)
    "Adaptor for a thermal zone in Modelica that is exposed through an FMI interface"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));

  replaceable package MediumA = Buildings.Media.Air "Medium for air";

  parameter Integer nFluPorts=1 "Number of fluid ports.";

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal=V*6/3600
    "Nominal mass flow rate";

  parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";

  Sources.MassFlowSource_T hva(
    nPorts=1,
    redeclare package Medium = MediumA,
    m_flow=m_flow_nominal,
    T=297.15) "Mass flow source"
    annotation (Placement(transformation(extent={{82,8},{62,28}})));
  Outlet bouOut(
    redeclare package Medium = MediumA,
    final allowFlowReversal=false,
    final use_p_in=false)
    annotation (Placement(transformation(extent={{44,8},{24,28}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = MediumA,
    V=V,
    mSenFac=3,
    nPorts=1,
    m_flow_nominal=m_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
              annotation (Placement(transformation(extent={{-48,30},{-28,50}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{-82,30},{-62,50}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedTemperature TOut(T=263.15)
    "Outside temperature"
    annotation (Placement(transformation(extent={{-112,30},{-92,50}})));
  Modelica.Blocks.Sources.Constant radTem(k=298.13)
    annotation (Placement(transformation(extent={{-112,-16},{-92,4}})));
  Modelica.Thermal.HeatTransfer.Sources.PrescribedTemperature TRad
    "Radiative temperature"
    annotation (Placement(transformation(extent={{-82,-16},{-62,4}})));
protected
  Modelica.Blocks.Sources.Constant heaGai(k=0) "Zero output signal" annotation (
     Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={34,-20})));

equation
  connect(radTem.y, TRad.T)
    annotation (Line(points={{-91,-6},{-91,-6},{-84,-6}}, color={0,0,127}));
  connect(TRad.port,theZonAda. heaPorRad) annotation (Line(points={{-62,-6},{-40,
          -6},{-40,3.75},{-20,3.75}}, color={191,0,0}));
  connect(heaGai.y,theZonAda. QGaiRad_flow) annotation (Line(points={{23,-20},{
          23,-20},{10,-20},{10,-20},{-14.2857,-20},{-14.2857,-1.25}},
                                                     color={0,0,127}));
  connect(heaGai.y,theZonAda. QGaiCon_flow)
    annotation (Line(points={{23,-20},{23,-20},{6,-20},{6,-20},{-10,-20},{-10,
          -1.25}},                                   color={0,0,127}));
  connect(heaGai.y,theZonAda. QGaiLat_flow) annotation (Line(points={{23,-20},{
          16,-20},{-5.71429,-20},{-5.71429,-1.25}},            color={0,0,127}));
  connect(bouOut.port_a, hva.ports[1])
    annotation (Line(points={{44,18},{54,18},{62,18}}, color={0,127,255}));
  connect(theZonAda.fluPor[1], bouOut.outlet) annotation (Line(points={{
          0.714286,17.5},{16,17.5},{16,18},{23,18}},
                                            color={0,0,255}));
  connect(TOut.port, theCon.port_a) annotation (Line(
      points={{-92,40},{-82,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{-62,40},{-48,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theZonAda.heaPorAir, vol.heatPort) annotation (Line(points={{-20,17.5},
          {-40,17.5},{-40,18},{-56,18},{-56,40},{-48,40}}, color={191,0,0}));
  connect(vol.ports[1],theZonAda. ports[1]) annotation (Line(points={{-38,30},{
          -38,10},{-19.8571,10}},
                              color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(extent={{-120,-100},{100,100}},
          preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-116,88},{4,-88}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{10,88},{96,-88}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{14,84},{52,60}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Simplified model of
an HVAC system that
may be in an FMU
(but is here for simplicity
also implemented in Modelica)"),
        Text(
          extent={{-112,88},{-74,64}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Simplified model of
a thermal zone
in Modelica that could
be exposed as an FMU"),
        Text(
          extent={{-64,92},{66,96}},
          lineColor={28,108,200},
          textString="fixme: This would be clearer if a HVAC with supply and return were used")}),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
<p>
This example demonstrates how to 
use the <a href=\"modelica://Buildings.Fluid.FMI.HVACAdaptor\">
Buildings.Fluid.FMI.HVACAdaptor
</a>. 
On the left of the adaptor is a simplified thermal zone model modeled
with a volume of air, and a heat conductor for steady-state
heat conduction to the outside. On the right of the adaptor is 
a simplified HVAC system modeled with an ideal flow source 
with fixed mass flow rate and fixed temperature.
The HVAC system on the right hand side also sets internal heat gains
for the zone. While this is strictly not a physical process of the
HVAC system, such a connection is useful and may be set to zero,
as in this example, if no heat gain should be set.
</p>
</html>", revisions="<html>
<ul>
<li>
April 28, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/Adaptors/Examples/HVAC.mos"
        "Simulate and plot"),
    experiment(StopTime=1));
end HVAC;
