within Buildings.ThermalZones.EnergyPlus_24_1_0.Validation.ThermalZone;
model InternalGain
  "Validation model for one zone with and without internal heat gain"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Air
    "Medium model";
  OneZoneWithGainExposed noGai(
    qRad_flow=0,
    qSen_flow=0,
    qLat_flow=0)
    "Zone with no internal heat gains from Modelica"
    annotation (Placement(transformation(extent={{-10,60},{10,80}})));
  OneZoneWithGainExposed radOnl(
    qRad_flow=5,
    qSen_flow=0,
    qLat_flow=0)
    "Zone with only radiative heat gains from Modelica"
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  OneZoneWithGainExposed conOnl(
    qRad_flow=0,
    qSen_flow=5,
    qLat_flow=0)
    "Zone with only convective heat gains from Modelica"
    annotation (Placement(transformation(extent={{-10,-20},{10,0}})));
  OneZoneWithGainExposed latOnl(
    qRad_flow=0,
    qSen_flow=0,
    qLat_flow=5)
    "Zone with only latent heat gains from Modelica"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));

protected
  model OneZoneWithGainExposed
    "Internal model for building with one thermal zone"
    extends Modelica.Blocks.Icons.Block;
    parameter Modelica.Units.SI.HeatFlux qRad_flow
      "Radiative internal heat gain";
    parameter Modelica.Units.SI.HeatFlux qSen_flow
      "Convective sensible internal heat gain";
    parameter Modelica.Units.SI.HeatFlux qLat_flow "Latent internal heat gain";
    Buildings.ThermalZones.EnergyPlus_24_1_0.Examples.SingleFamilyHouse.Unconditioned bui(
      m_flow_nominal=bui.VRoo*10*0.3/3600,
      qIntGai(
        final k={qRad_flow,qSen_flow,qLat_flow}),
      bou(
        m_flow=bui.zon.V*1.2*10/3600))
      "Building model"
      annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
    annotation (
      Icon(
        graphics={
          Text(
            extent={{-76,60},{64,38}},
            textColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.None,
            horizontalAlignment=TextAlignment.Left,
            textString="qRad_flow = %qRad_flow"),
          Text(
            extent={{-74,14},{66,-8}},
            textColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.None,
            horizontalAlignment=TextAlignment.Left,
            textString="qSen_flow = %qSen_flow"),
          Text(
            extent={{-74,-30},{66,-52}},
            textColor={0,0,255},
            fillColor={255,255,255},
            fillPattern=FillPattern.None,
            horizontalAlignment=TextAlignment.Left,
            textString="qLat_flow = %qLat_flow")}));
  end OneZoneWithGainExposed;
  annotation (
    Documentation(
      info="<html>
<p>
Simple test case for one building with one thermal zone with different inputs for the internal heat gains.
</p>
</html>",
      revisions="<html>
<ul>
<li>
October 30, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_1_0/Validation/ThermalZone/InternalGain.mos" "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06));
end InternalGain;
