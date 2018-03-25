within Buildings.Utilities.Plotters.Examples;
model SingleZoneVAV
  "Various plots for a single zone VAV system"
  import Buildings;
  extends
    Buildings.Air.Systems.SingleZone.VAV.Examples.ChillerDXHeatingEconomizer;
  inner Configuration plotConfiguration(
    samplePeriod(displayUnit="min") = 900,
    timeUnit=Buildings.Utilities.Plotters.Types.TimeUnit.days,
    activation=Buildings.Utilities.Plotters.Types.GlobalActivation.use_input,
    activationDelay(displayUnit="min") = 600)
    "Plot configuration"
    annotation (Placement(transformation(extent={{-140,100},{-120,120}})));

  Modelica.Blocks.Math.UnitConversions.To_degC TOutDryBul_degC
    "Outdoor drybulb in degC"
    annotation (Placement(transformation(extent={{20,110},{40,130}})));
  Modelica.Blocks.Math.UnitConversions.To_degC TDewPoi_degC
    "Outdoor dewpoint temperature in degC"
    annotation (Placement(transformation(extent={{20,82},{40,102}})));
  Buildings.Utilities.Plotters.TimeSeries ploTOut(
    title="Outdoor drybulb and dew point temperatures",
    n=3,
    legend={"TOutDryBul","TOutDewPoi","TRoo"},
    activation=Buildings.Utilities.Plotters.Types.LocalActivation.always)
    "Temperatures"
    annotation (Placement(transformation(extent={{140,100},{160,120}})));
  Buildings.Utilities.Plotters.Scatter scaEco(
    title="Economizer control signal",
    legend={"uEco"},
    xlabel="TOut [degC]",
    n=1)                  "Scatter plot for economizer"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Utilities.Plotters.Scatter scaPFan(
    title="Fan power",
    xlabel="yFan [1]",
    legend={"PFan in [W]"},
    n=1) "Scatter plot for fan power"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  Modelica.Blocks.Math.UnitConversions.To_degC TRooAir_degC
    "Room air temperature in degC"
    annotation (Placement(transformation(extent={{100,80},{120,100}})));
  Buildings.Utilities.Plotters.Scatter scaTRoo(
    xlabel="TOut [degC]",
    title="Room air temperature",
    legend={"TRoo [degC]"},
    n=1) "Scatter plot for room air temperature"
    annotation (Placement(transformation(extent={{140,60},{160,80}})));
equation
  connect(TOutDryBul_degC.u, weaBus.TDryBul) annotation (Line(points={{18,120},
          {-36,120},{-36,80}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TDewPoi_degC.u, weaBus.TDewPoi) annotation (Line(points={{18,92},{10,
          92},{10,94},{-36,94},{-36,80}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TOutDryBul_degC.y, scaEco.x) annotation (Line(points={{41,120},{50,120},
          {50,52},{58,52}},              color={0,0,127}));
  connect(con.yFan, scaPFan.x) annotation (Line(points={{-79,9},{-80,9},{-80,10},
          {-74,10},{-74,-78},{-42,-78}},           color={0,0,127}));
  connect(hvac.PFan, scaPFan.y[1]) annotation (Line(points={{1,18},{24,18},{24,
          -50},{-50,-50},{-50,-70},{-42,-70}}, color={0,0,127}));
  connect(zon.TRooAir, TRooAir_degC.u)
    annotation (Line(points={{81,0},{90,0},{90,90},{98,90}}, color={0,0,127}));
  connect(scaTRoo.x, TOutDryBul_degC.y) annotation (Line(points={{138,62},{126,62},
          {126,120},{41,120}},              color={0,0,127}));
  connect(scaTRoo.y[1], TRooAir_degC.y) annotation (Line(points={{138,70},{130,
          70},{130,90},{121,90}}, color={0,0,127}));
  connect(con.chiOn, plotConfiguration.activate) annotation (Line(points={{-79,-4},
          {-60,-4},{-60,50},{-152,50},{-152,118},{-142,118}},     color={255,0,
          255}));
  connect(TOutDryBul_degC.y, ploTOut.y[1]) annotation (Line(points={{41,120},{
          126,120},{126,111.333},{138,111.333}},
                                             color={0,0,127}));
  connect(TDewPoi_degC.y, ploTOut.y[2]) annotation (Line(points={{41,92},{80,92},
          {80,110},{138,110}}, color={0,0,127}));
  connect(TRooAir_degC.y, ploTOut.y[3]) annotation (Line(points={{121,90},{130,
          90},{130,108.667},{138,108.667}},
                                        color={0,0,127}));
  connect(con.yOutAirFra, scaEco.y[1]) annotation (Line(points={{-79,3},{-68,3},
          {-68,60},{58,60}}, color={0,0,127}));
  annotation ( experiment(Tolerance=1e-6, StartTime=15552000, StopTime=15984000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Plotters/Examples/SingleZoneVAV.mos"
        "Simulate and plot"),
  Documentation(info="<html>
<p>
This example demonstrates the use of a time plot and a scatter plot
for a single zone VAV system.
The plots are configured to plot every <i>15</i> minutes.
The plots will be in the file specified
in the plot configuration <code>plotConfiguration</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
March 23, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-160,-160},{180,140}})));
end SingleZoneVAV;
