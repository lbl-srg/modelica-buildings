within Buildings.Utilities.Plotters.Examples;
model SingleZoneVAV
  "Various plots for a single zone VAV system"
  import Buildings;
  extends
    Buildings.Air.Systems.SingleZone.VAV.Examples.ChillerDXHeatingEconomizer;

  Plotters plo "Block with plotters"
               annotation (Placement(transformation(rotation=0, extent={{120,40},
            {140,60}})));

  model Plotters
    extends Modelica.Blocks.Icons.Block;

    Modelica.Blocks.Interfaces.BooleanInput activate
      "Set to true to enable plotting of time series after activationDelay elapsed"
      annotation (Placement(transformation(extent={{-140,70},{-100,110}}),
          iconTransformation(extent={{-120,80},{-100,100}})));
    Modelica.Blocks.Interfaces.RealInput TOutDryBul "Outdoor drybulb temperature"
      annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
          iconTransformation(extent={{-120,50},{-100,70}})));
    Modelica.Blocks.Interfaces.RealInput TOutDew "Outdoor dewpoint temperature"
      annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
          iconTransformation(extent={{-120,20},{-100,40}})));
    Modelica.Blocks.Interfaces.RealInput TRoo "Room temperature" annotation (
        Placement(transformation(extent={{-140,-20},{-100,20}}),
          iconTransformation(extent={{-120,-10},{-100,10}})));
    Modelica.Blocks.Interfaces.RealInput uEco "Economizer control signal"
      annotation (Placement(transformation(extent={{-140,-50},{-100,-10}}),
          iconTransformation(extent={{-120,-40},{-100,-20}})));
    Modelica.Blocks.Interfaces.RealInput PFan "Fan power consumption" annotation (
       Placement(transformation(extent={{-140,-80},{-100,-40}}),
          iconTransformation(extent={{-120,-70},{-100,-50}})));
    Modelica.Blocks.Interfaces.RealInput yFan "Fan control signal" annotation (
        Placement(transformation(extent={{-140,-110},{-100,-70}}),
          iconTransformation(extent={{-120,-100},{-100,-80}})));

    inner Buildings.Utilities.Plotters.Configuration plotConfiguration(
      samplePeriod(displayUnit="min") = 900,
      timeUnit=Buildings.Utilities.Plotters.Types.TimeUnit.days,
      activation=Buildings.Utilities.Plotters.Types.GlobalActivation.use_input,
      activationDelay(displayUnit="min") = 600)
      "Plot configuration"
      annotation (Placement(transformation(extent={{0,72},{20,92}})));

    Buildings.Utilities.Plotters.TimeSeries ploTOut(
      title="Outdoor drybulb and dew point temperatures",
      legend={"TOutDryBul","TOutDewPoi","TRoo"},
      activation=Buildings.Utilities.Plotters.Types.LocalActivation.always,
      introduction="Outside conditions.",
      n=3)                                "Temperatures"
      annotation (Placement(transformation(extent={{40,50},{60,70}})));
    Buildings.Utilities.Plotters.Scatter scaEco(
      title="Economizer control signal",
      legend={"uEco"},
      xlabel="TOut [degC]",
      n=1,
      introduction="Economizer control signal while the system is operating for at least 10 minutes.")
      "Scatter plot for economizer"
      annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
    Buildings.Utilities.Plotters.Scatter scaPFan(
      title="Fan power",
      xlabel="yFan [1]",
      legend={"PFan in [W]"},
      n=1,
      activation=Buildings.Utilities.Plotters.Types.LocalActivation.always)
      "Scatter plot for fan power"
      annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
    Buildings.Utilities.Plotters.Scatter scaTRoo(
      xlabel="TOut [degC]",
      title="Room air temperature",
      legend={"TRoo [degC]"},
      introduction="Room air temperatures while the system is operating for at least 10 minutes.",
      n=1)
      "Scatter plot for room air temperature"
      annotation (Placement(transformation(extent={{40,0},{60,20}})));

    Modelica.Blocks.Math.UnitConversions.To_degC TRooAir_degC
      "Room air temperature in degC"
      annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
    Modelica.Blocks.Math.UnitConversions.To_degC TDewPoi_degC
      "Outdoor dewpoint temperature in degC"
      annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
    Modelica.Blocks.Math.UnitConversions.To_degC TOutDryBul_degC
      "Outdoor drybulb in degC"
      annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  equation

    connect(plotConfiguration.activate, activate) annotation (Line(points={{-2,90},
            {-120,90}},                   color={255,0,255}));
    connect(scaEco.y[1], uEco)
      annotation (Line(points={{38,-30},{-120,-30}}, color={0,0,127}));
    connect(scaPFan.x, yFan) annotation (Line(points={{38,-78},{-4,-78},{-4,-90},{
            -120,-90}}, color={0,0,127}));
    connect(PFan, scaPFan.y[1]) annotation (Line(points={{-120,-60},{-4,-60},{-4,-70},
            {38,-70}}, color={0,0,127}));
    connect(scaEco.x, TOutDryBul_degC.y) annotation (Line(points={{38,-38},{-4,-38},
            {-4,60},{-39,60}}, color={0,0,127}));
    connect(TOutDryBul_degC.u, TOutDryBul)
      annotation (Line(points={{-62,60},{-120,60}}, color={0,0,127}));
    connect(TOutDew, TDewPoi_degC.u)
      annotation (Line(points={{-120,30},{-62,30}}, color={0,0,127}));
    connect(TRoo, TRooAir_degC.u)
      annotation (Line(points={{-120,0},{-62,0}}, color={0,0,127}));
    connect(TOutDryBul_degC.y, ploTOut.y[1]) annotation (Line(points={{-39,60},
            {-4,60},{-4,61.3333},{38,61.3333}},
                                            color={0,0,127}));
    connect(TDewPoi_degC.y, ploTOut.y[2]) annotation (Line(points={{-39,30},{-2,
            30},{-2,60},{38,60}},
                              color={0,0,127}));
    connect(TRooAir_degC.y, ploTOut.y[3]) annotation (Line(points={{-39,0},{0,0},
            {0,58.6667},{38,58.6667}},color={0,0,127}));
    connect(TRooAir_degC.y, scaTRoo.y[1])
      annotation (Line(points={{-39,0},{0,0},{0,10},{38,10}}, color={0,0,127}));
    connect(scaTRoo.x, TOutDryBul_degC.y) annotation (Line(points={{38,2},{-4,2},{
            -4,60},{-39,60}}, color={0,0,127}));
    annotation (Icon(graphics={
            Line(
              points={{-80.0,78.0},{-80.0,-90.0}},
              color={192,192,192}),
            Polygon(
              lineColor={192,192,192},
              fillColor={192,192,192},
              fillPattern=FillPattern.Solid,
              points={{-80.0,90.0},{-88.0,68.0},{-72.0,68.0},{-80.0,90.0}}),
      Line(origin = {-1.939,-1.816},
          points = {{81.939,36.056},{65.362,36.056},{14.39,-26.199},{-29.966,113.485},{-65.374,-61.217},{-78.061,-78.184}},
          color = {0,0,127},
          smooth = Smooth.Bezier),
            Polygon(
              lineColor={192,192,192},
              fillColor={192,192,192},
              fillPattern=FillPattern.Solid,
              points={{90.0,-80.0},{68.0,-72.0},{68.0,-88.0},{90.0,-80.0}}),
            Line(
              points={{-90.0,-80.0},{82.0,-80.0}},
              color={192,192,192})}), Documentation(info="<html>
<p>
Block that contains unit conversion, plotter configuration
and various plotters.
</p>
</html>",   revisions="<html>
<ul>
<li>
June 24, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
  end Plotters;

equation

  connect(plo.activate, con.chiOn) annotation (Line(points={{119,59},{-66,59},{
          -66,-4},{-79,-4}}, color={255,0,255}));
  connect(weaBus.TDryBul, plo.TOutDryBul) annotation (Line(
      points={{-36,80},{80,80},{80,56},{119,56}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TDewPoi, plo.TOutDew) annotation (Line(
      points={{-36,80},{80,80},{80,53},{119,53}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(plo.TRoo, zon.TRooAir) annotation (Line(points={{119,50},{90,50},{90,
          0},{81,0}}, color={0,0,127}));
  connect(con.yOutAirFra, plo.uEco) annotation (Line(points={{-79,3},{-70,3},{
          -70,47},{119,47}}, color={0,0,127}));
  connect(hvac.PFan, plo.PFan) annotation (Line(points={{1,18},{24,18},{24,44},
          {119,44}}, color={0,0,127}));
  connect(con.yFan, plo.yFan) annotation (Line(points={{-79,9},{-60,9},{-60,41},
          {119,41}}, color={0,0,127}));
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
