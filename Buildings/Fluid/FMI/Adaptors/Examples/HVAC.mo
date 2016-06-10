within Buildings.Fluid.FMI.Adaptors.Examples;
model HVAC "Example of an HVAC model"
  extends Modelica.Icons.Example;
  Buildings.Fluid.FMI.Adaptors.ThermalZone theHvaAda(
    redeclare final package Medium = MediumA,
    nFluPor=1)
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
    annotation (Placement(transformation(extent={{82,0},{62,20}})));
  Outlet bouOut(
    redeclare package Medium = MediumA,
    final allowFlowReversal=false,
    final use_p_in=false)
    annotation (Placement(transformation(extent={{44,0},{24,20}})));
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
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-10,-70})));

equation
  connect(radTem.y, TRad.T)
    annotation (Line(points={{-91,-6},{-91,-6},{-84,-6}}, color={0,0,127}));
  connect(TRad.port, theHvaAda.heaPorRad) annotation (Line(points={{-62,-6},{-40,
          -6},{-40,3.75},{-20,3.75}}, color={191,0,0}));
  connect(heaGai.y, theHvaAda.QGaiRad_flow) annotation (Line(points={{-10,-59},
          {-10,-10},{-14,-10},{-14.2857,-10},{-14.2857,-1.25}},
                                                     color={0,0,127}));
  connect(heaGai.y, theHvaAda.QGaiCon_flow)
    annotation (Line(points={{-10,-59},{-10,-1.25}}, color={0,0,127}));
  connect(heaGai.y, theHvaAda.QGaiLat_flow) annotation (Line(points={{-10,-59},
          {-10,-59},{-10,-10},{-6,-10},{-5.71429,-10},{-5.71429,-1.25}},
                                                               color={0,0,127}));
  connect(bouOut.port_a, hva.ports[1])
    annotation (Line(points={{44,10},{54,10},{62,10}}, color={0,127,255}));
  connect(theHvaAda.fluPor[1], bouOut.outlet) annotation (Line(points={{
          0.714286,17.5},{16,17.5},{16,10},{23,10}},
                                            color={0,0,255}));
  connect(TOut.port, theCon.port_a) annotation (Line(
      points={{-92,40},{-82,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theCon.port_b, vol.heatPort) annotation (Line(
      points={{-62,40},{-48,40}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(theHvaAda.heaPorAir, vol.heatPort) annotation (Line(points={{-20,17.5},
          {-40,17.5},{-40,18},{-56,18},{-56,40},{-48,40}}, color={191,0,0}));
  connect(vol.ports[1], theHvaAda.ports[1]) annotation (Line(points={{-38,30},{
          -38,10},{-19.8571,10}},
                              color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(extent={{-120,-100},{100,100}},
          preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-116,88},{-26,-88}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{8,88},{98,-88}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{10,90},{60,76}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          textString="Simplified model of"),
        Text(
          extent={{10,80},{56,68}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          textString="an HVAC system"),
        Text(
          extent={{-114,80},{-74,70}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          textString="a thermal zone"),
        Text(
          extent={{-114,90},{-64,76}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          textString="Simplified model of")}),
    Icon(coordinateSystem(extent={{-120,-100},{100,100}})),
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
