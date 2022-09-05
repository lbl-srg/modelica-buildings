within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Title24.Validation;
model OutdoorAirFlow
  "Validate the sequences of setting AHU level minimum outdoor airflow rate"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Title24.AHU
    ahu(
    final minOADes=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow,
    final have_CO2Sen=have_CO2Sen,
    final VAbsOutAir_flow=0.5,
    final VDesOutAir_flow=1) "AHU level minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Title24.SumZone zonToAhu(
    final nZon=nZon,
    final nGro=nGro,
    final zonGroMat=zonGroMat,
    final have_CO2Sen=have_CO2Sen) "From zone level to AHU level"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  parameter Boolean have_CO2Sen=true
    "True: there are zones have CO2 sensor";
  parameter Integer nZon=4
    "Total number of zones";
  parameter Integer nGro=2
    "Total number of groups";
  parameter Integer zonGroMat[nGro,nZon]={{1,1,0,0},{0,0,1,1}}
    "Zone matrix with zone group as row index and zone as column index. It flags which zone is grouped in which zone group";
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod[nGro](
    final k={Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied,
             Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied})
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonAbsMinFlo[nZon](
      final k={0.1,0.12,0.2,0.15}) "Zone absolute minimum flow"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zonDesMinFlo[nZon](
      final k={0.15,0.2,0.25,0.3}) "Adjusted area component flow"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant co2Loo[nZon](
    final k={0.3,0.25,0.4,0.5}) "Zone CO2 loop signal"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outAirFlo(final k=1)
    "Adjusted area component flow"
    annotation (Placement(transformation(extent={{20,-60},{40,-40}})));
equation
  connect(opeMod.y, zonToAhu.uOpeMod) annotation (Line(points={{-58,60},{0,60},{
          0,8},{18,8}}, color={255,127,0}));
  connect(zonAbsMinFlo.y, zonToAhu.VZonAbsMin_flow) annotation (Line(points={{-58,
          20},{-6,20},{-6,3},{18,3}}, color={0,0,127}));
  connect(zonDesMinFlo.y, zonToAhu.VZonDesMin_flow) annotation (Line(points={{-58,
          -20},{-6,-20},{-6,-3},{18,-3}}, color={0,0,127}));
  connect(co2Loo.y, zonToAhu.uCO2) annotation (Line(points={{-58,-60},{0,-60},{0,
          -8},{18,-8}}, color={0,0,127}));
  connect(zonToAhu.VSumZonAbsMin_flow, ahu.VSumZonAbsMin_flow)
    annotation (Line(points={{42,6},{50,6},{50,8},{58,8}}, color={0,0,127}));
  connect(zonToAhu.VSumZonDesMin_flow, ahu.VSumZonDesMin_flow)
    annotation (Line(points={{42,0},{50,0},{50,3},{58,3}},   color={0,0,127}));
  connect(zonToAhu.yMaxCO2, ahu.uCO2Loo_max) annotation (Line(points={{42,-5},{50,
          -5},{50,-3},{58,-3}},    color={0,0,127}));
  connect(outAirFlo.y, ahu.VAirOut_flow) annotation (Line(points={{42,-50},{54,
          -50},{54,-8},{58,-8}}, color={0,0,127}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/SetPoints/OutdoorAirFlow/Title24/Validation/OutdoorAirFlow.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This model shows how to compose the subsequences to find the minimum outdoor
airflow setpoint of an AHU unit that serves three zones.
</p>
<ul>
<li>
The block <code>zonToAhu</code> which instantiates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Title24.SumZone\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Title24.SumZone</a>,
finds the sum and maximum of the zone level setpoints.
</li>
<li>
The AHU level minimum outdoor airflow setpoint is then specified by block <code>ahu</code>.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Title24.AHU\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.Title24.AHU</a>.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
March 14, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
         graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent = {{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points = {{-36,60},{64,0},{-36,-60},{-36,60}})}),
    Diagram(coordinateSystem(extent={{-100,-100},{100,100}})));
end OutdoorAirFlow;
