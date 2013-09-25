within Districts.BuildingLoads;
model TimeSeries "Whole building load model based on a time series"
extends Modelica.Blocks.Interfaces.BlockIcon;
  parameter String fileName="NoName"
    "File where matrix with regression coefficients is stored"
    annotation(Dialog(group="table data definition", enable = tableOnFile,
                         __Dymola_loadSelector(filter=".txt files (*.txt);;All files (*.*)",
                         caption="Open file in which table is present")));
  parameter Real pf=0.8 "Power factor";
  parameter Boolean linear_AC=false
    "If =true introduce a linearization in the AC load";
  parameter Boolean linear_DC=false
    "If =true introduce a linearization in the DC load";

  parameter Modelica.SIunits.Voltage VACDis_nominal
    "AC voltage of the distribution grid";
  parameter Modelica.SIunits.Voltage VACBui_nominal
    "AC voltage of the distribution grid";

  parameter Modelica.SIunits.Voltage VDCDis_nominal
    "DC voltage of distribution";
  parameter Modelica.SIunits.Voltage VDCBui_nominal "DC voltage in buildings";
                               BoundaryConditions.WeatherData.Bus
      weaBus "Weather Data Bus" annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}}),     iconTransformation(extent={{-110,-10},{-90,10}})));
  BaseClasses.TimeSeries loa(final fileName=fileName) "Building load"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Electrical.AC.ThreePhasesBalanced.Loads.CapacitiveLoadP loaAC(
    mode=Districts.Electrical.Types.Assumption.VariableZ_P_input,
    linear=linear_AC,
    V_nominal=VACBui_nominal,
    pf=pf) "Resistive and capacitive building load"
    annotation (Placement(transformation(extent={{40,-10},{20,10}})));
  Electrical.AC.ThreePhasesBalanced.Interfaces.Terminal_n terminal
    "Electrical connector"
    annotation (Placement(transformation(extent={{94,-10},{114,10}})));
  Electrical.DC.Loads.Conductor loaDC(
    mode=Districts.Electrical.Types.Assumption.VariableZ_P_input,
    linear=linear_DC,
    V_nominal=VDCBui_nominal) "Conductor for DC load"
    annotation (Placement(transformation(extent={{42,-70},{22,-50}})));
  Districts.Electrical.DC.Interfaces.Terminal_p terminal_dc(redeclare package
      PhaseSystem = Districts.Electrical.PhaseSystems.TwoConductor)
    "Generalised terminal"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Modelica.Blocks.Math.Add add(k1=-1, k2=1)
    annotation (Placement(transformation(extent={{-10,-32},{10,-12}})));
  Modelica.Blocks.Continuous.Integrator ETot(y(unit="J")) "Total energy"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Math.Gain gain(k=-1)
    annotation (Placement(transformation(extent={{-8,-70},{12,-50}})));
  Electrical.AC.ThreePhasesBalanced.Conversion.ACACConverter acac(
    conversionFactor=VACDis_nominal/VACBui_nominal,
    eta=0.9,
    ground_1=true,
    ground_2=false) "AC/AC converter"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Electrical.DC.Conversion.DCDCConverter dcdc(
    eta=0.9,
    conversionFactor=VDCDis_nominal/VDCBui_nominal,
    ground_2=false) "DC/DC converter"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
equation
  connect(loa.PTot, add.u1)    annotation (Line(
      points={{-39,-5},{-19.5,-5},{-19.5,-16},{-12,-16}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(add.y, loaAC.Pow)  annotation (Line(
      points={{11,-22},{16,-22},{16,0},{20,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loa.PLigInd, add.u2)    annotation (Line(
      points={{-39,5},{-30,5},{-30,-28},{-12,-28}},
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
      points={{13,-60},{22,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loa.PLigInd, gain.u) annotation (Line(
      points={{-39,5},{-30,5},{-30,-60},{-10,-60}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(loaAC.terminal, acac.terminal_n) annotation (Line(
      points={{40,0},{60,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(acac.terminal_p, terminal) annotation (Line(
      points={{80,0},{104,0}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(loaDC.terminal, dcdc.terminal_n) annotation (Line(
      points={{42,-60},{60,-60}},
      color={0,0,255},
      smooth=Smooth.None));
  connect(dcdc.terminal_p, terminal_dc) annotation (Line(
      points={{80,-60},{100,-60}},
      color={0,0,255},
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
August 23, 2013, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}}),
                    graphics));
end TimeSeries;
