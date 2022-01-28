within Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Validation;
model Setpoints
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints
    noSenZon(
    AZon=30,
    desZonPop=2,
    VZonMin_flow=0.018) "Setpoints of zone without any sensors"
    annotation (Placement(transformation(extent={{-280,160},{-260,180}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints
    winSenZon(
    have_winSen=true,
    AZon=30,
    desZonPop=2,
    VZonMin_flow=0.018) "Setpoints of a zone with window sensor"
    annotation (Placement(transformation(extent={{-280,80},{-260,100}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints
    occSenZon(
    have_occSen=true,
    AZon=30,
    desZonPop=2,
    VZonMin_flow=0.018) "Setpoints of a zone with occupancy sensor"
    annotation (Placement(transformation(extent={{-280,0},{-260,20}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints
    co2SenZon(
    have_CO2Sen=true,
    AZon=30,
    desZonPop=2,
    VZonMin_flow=0.018,
    VCooZonMax_flow=0.025)
    "Setpoints of a zone with  CO2 sensor and typical terminal unit"
    annotation (Placement(transformation(extent={{-280,-60},{-260,-40}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints
    co2SenZonParFan(
    have_CO2Sen=true,
    is_typTerUni=false,
    is_parFanPow=true,
    AZon=30,
    desZonPop=2,
    VZonMin_flow=0.018,
    VCooZonMax_flow=0.025)
    "Setpoints of a zone with  CO2 sensor and parallel fan-powered terminal unit"
    annotation (Placement(transformation(extent={{-40,160},{-20,180}})));
  Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints
    co2SenSZVAV(
    have_CO2Sen=true,
    is_typTerUni=false,
    is_parFanPow=false,
    is_SZVAV=true,
    AZon=30,
    desZonPop=2,
    VZonMin_flow=0.018,
    VCooZonMax_flow=0.025)
    "Setpoints of a zone with  CO2 sensor and single zone VAV AHU"
    annotation (Placement(transformation(extent={{-40,80},{-20,100}})));
annotation (experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/VentilationZones/ASHRAE62_1/Validation/Setpoints.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints\">
Buildings.Controls.OBC.ASHRAE.G36.VentilationZones.ASHRAE62_1.Setpoints</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 13, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-360,-320},{360,320}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}}),
        Ellipse(lineColor={75,138,73},
                fillColor={255,255,255},
                fillPattern=FillPattern.Solid,
                extent={{-100,-100},{100,100}}),
        Polygon(lineColor={0,0,255},
                fillColor={75,138,73},
                pattern=LinePattern.None,
                fillPattern=FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}),
    Diagram(coordinateSystem(extent={{-360,-320},{360,320}})));
end Setpoints;
