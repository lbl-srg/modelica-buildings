within Buildings.DHC.Examples.Combined.ETSHeatRecoveryHeatPump_BuildingTimeSeries.BaseClasses;
model BuildingTimeSeries
  "Building load with time series and control valve for supply water temperature to the coils"
  extends Buildings.DHC.Loads.BaseClasses.BuildingTimeSeries(
    disFloHea(have_val=true),
    disFloCoo(have_val=true));

  Modelica.Blocks.Interfaces.RealInput THeaSupSet(
    final unit="K",
    displayUnit="degC")
    "Supply temperature set point for heating" annotation (Placement(
        transformation(extent={{-340,100},{-300,140}}),   iconTransformation(
          extent={{-340,180},{-300,220}})));
  Modelica.Blocks.Interfaces.RealInput TCooSupSet(
    final unit="K",
    displayUnit="degC")
    "Supply temperature set point for cooling" annotation (Placement(
        transformation(extent={{-340,40},{-300,80}}),     iconTransformation(
          extent={{-340,80},{-300,120}})));
equation
  connect(disFloHea.TSupSet, THeaSupSet) annotation (Line(points={{119,-68},{
          -220,-68},{-220,120},{-320,120}},
                                         color={0,0,127}));
  connect(disFloCoo.TSupSet, TCooSupSet) annotation (Line(points={{119,-268},{
          -240,-268},{-240,60},{-320,60}},color={0,0,127}));
  annotation (
  defaultComponentName="bui",
    Documentation(info="<html>
<p>
Model of a building heating and cooling load based on time series data.
</p>
<p>
This model is identical to
<a href=\"modelica://Buildings.DHC.Loads.BaseClasses.BuildingTimeSeries\">
Buildings.DHC.Loads.BaseClasses.BuildingTimeSeries</a>,
but it adds input signals for the heating and cooling supply water temperature,
and configures the above model to use a three-way control valve to mix the
heating and cooling supply water to the temperature described by these two
input signals.
</p>
</html>", revisions="<html>
<ul>
<li>
November 14, 2025, by Michael Wetter:<br/>
First implementation.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4354\">#4354</a>.
</li>
</ul>
</html>"));
end BuildingTimeSeries;
