within Districts.BuildingLoads;
model TimeSeries "Whole building load model based on a time series"
extends Modelica.Blocks.Interfaces.BlockIcon;
  parameter String fileName="NoName"
    "File where matrix with regression coefficients is stored"
    annotation(Dialog(group="table data definition", enable = tableOnFile,
                         __Dymola_loadSelector(filter=".txt files (*.txt);;All files (*.*)",
                         caption="Open file in which table is present")));
  parameter Real pf=0.8 "Power factor";
  BoundaryConditions.WeatherData.Bus
      weaBus "Weather Data Bus" annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}}),     iconTransformation(extent={{-110,-10},{-90,10}})));
  BaseClasses.TimeSeries loa(final fileName=fileName) "Building load"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Electrical.AC.AC3ph.Loads.CapacitiveLoadP loaAC(mode=Districts.Electrical.Types.Assumption.VariableZ_P_input)
    "Resistive and capacitive building load"
    annotation (Placement(transformation(extent={{60,-10},{40,10}})));
  Electrical.AC.AC3ph.Interfaces.Terminal_n terminal "Electrical connector"
    annotation (Placement(transformation(extent={{94,-10},{114,10}})));
  Electrical.DC.Loads.Conductor loaDC(mode=Districts.Electrical.Types.Assumption.VariableZ_P_input)
    "Conductor for DC load"
    annotation (Placement(transformation(extent={{60,-70},{40,-50}})));
  Districts.Electrical.DC.Interfaces.Terminal_p terminal_dc(redeclare package
      PhaseSystem = Districts.Electrical.PhaseSystems.TwoConductor)
    "Generalised terminal"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Blocks.Math.Add add(k1=-1, k2=1)
    annotation (Placement(transformation(extent={{10,-32},{30,-12}})));
  Modelica.Blocks.Continuous.Integrator ETot(y(unit="J")) "Total energy"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Math.Gain gain(k=-1)
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
equation
  connect(terminal, loaAC.terminal)  annotation (Line(
      points={{104,4.44089e-16},{64,4.44089e-16},{64,0},{60,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(loa.PTot, add.u1)    annotation (Line(
      points={{-39,-5},{-19.5,-5},{-19.5,-16},{8,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, loaAC.Pow)  annotation (Line(
      points={{31,-22},{34,-22},{34,0},{40,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loaDC.terminal, terminal_dc) annotation (Line(
      points={{60,-60},{100,-60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(loa.PLigInd, add.u2)    annotation (Line(
      points={{-39,5},{-30,5},{-30,-28},{8,-28}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loa.TOut, weaBus.TDryBul)           annotation (Line(
      points={{-62,8},{-80,8},{-80,4.44089e-16},{-100,4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loa.TDewPoi, weaBus.TDewPoi)           annotation (Line(
      points={{-62,4},{-80,4},{-80,4.44089e-16},{-100,4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loa.HDirNor, weaBus.HDirNor)           annotation (Line(
      points={{-62,-4},{-80,-4},{-80,4.44089e-16},{-100,4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loa.HDif, weaBus.HDifHor)           annotation (Line(
      points={{-62,-8},{-80,-8},{-80,4.44089e-16},{-100,4.44089e-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loa.PTot, ETot.u) annotation (Line(
      points={{-39,-5},{-20,-5},{-20,50},{-2,50}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(gain.y,loaDC. Pow) annotation (Line(
      points={{31,-60},{40,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loa.PLigInd, gain.u) annotation (Line(
      points={{-39,5},{-30,5},{-30,-60},{8,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}),
                         graphics={
        Rectangle(
          extent={{0,28},{80,-100}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,14},{26,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,14},{48,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,14},{70,4}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,-2},{70,-12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,-2},{48,-12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-2},{26,-12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,-18},{70,-28}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,-18},{48,-28}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-18},{26,-28}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,-34},{70,-44}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,-34},{48,-44}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-34},{26,-44}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,-50},{70,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,-50},{48,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-50},{26,-60}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,-66},{70,-76}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,-66},{48,-76}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-66},{26,-76}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{54,-82},{70,-92}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{32,-82},{48,-92}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{10,-82},{26,-92}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{38,46},{-16,28},{92,28},{38,46}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-80,62},{-54,82},{-34,58},{-12,78}},
          color={0,0,0},
          smooth=Smooth.Bezier),
        Line(
          points={{-84,92},{-84,50},{-4,50}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-86,86},{-84,92},{-82,86}},
          color={0,0,0},
          smooth=Smooth.None),
        Line(
          points={{-10,52},{-4,50},{-10,48}},
          color={0,0,0},
          smooth=Smooth.None)}),
                Documentation(info="<html>
<p>
Model for a building load. This model computes the load of a building
using a time series.
The model takes as a connector the weather data.
This is used to assert that the weather data correspond
to the weather data that were used when creating the time series.
If they differ by more than a threshold, the simulation stops with an error.
</p>
</html>", revisions="<html>
<ul>
<li>
August 23, 2013, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics));
end TimeSeries;
