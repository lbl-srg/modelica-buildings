within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.ASHRAE62_1.Validation;
model OutdoorAirFlow
  "Validate the sequences of setting AHU level minimum outdoor airflow rate"

  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.ASHRAE62_1.AHU
    ahu(
    final minOADes=Buildings.Controls.OBC.ASHRAE.G36.Types.OutdoorAirSection.DedicatedDampersAirflow,
    final VUncDesOutAir_flow=1.2,
    final VDesTotOutAir_flow=1) "AHU level minimum outdoor airflow setpoint"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.ASHRAE62_1.SumZone zonToAhu(
    final nZon=nZon,
    final nGro=nGro,
    final zonGroMat=zonGroMat,
    final zonGroMatTra=zonGroMatTra) "From zone level to AHU level"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

protected
  parameter Integer nZon=4
    "Total number of zones";
  parameter Integer nGro=2
    "Total number of groups";
  parameter Integer zonGroMat[nGro,nZon]={{1,1,0,0},{0,0,1,1}}
    "Zone matrix with zone group as row index and zone as column index. It flags which zone is grouped in which zone group";
  parameter Integer zonGroMatTra[nZon,nGro]={{1,0},{1,0},{0,1},{0,1}}
    "Transpose of the zone matrix";
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant opeMod[nGro](
    final k={Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied,
             Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.unoccupied})
    "AHU operation mode is Occupied"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant adjPopFlo[nZon](
    final k={0.1,0.12,0.2,0.15})
    "Adjusted population component flow"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant adjAreFlo[nZon](
    final k={0.08,0.1,0.15,0.1})
    "Adjusted area component flow"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant priFlo[nZon](
    final k={0.3,0.25,0.4,0.5})
    "Measured zone primary airflow"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minOAFlo[nZon](
    final k={0.2,0.21,0.35,0.25})
    "Minimum outdoor airflow"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant outAirFlo(final k=1)
    "Adjusted area component flow"
    annotation (Placement(transformation(extent={{20,-80},{40,-60}})));
equation
  connect(adjPopFlo.y, zonToAhu.VAdjPopBreZon_flow) annotation (Line(points={{-58,
          40},{-10,40},{-10,4},{18,4}}, color={0,0,127}));
  connect(adjAreFlo.y, zonToAhu.VAdjAreBreZon_flow)
    annotation (Line(points={{-58,0},{18,0}}, color={0,0,127}));
  connect(priFlo.y, zonToAhu.VZonPri_flow) annotation (Line(points={{-58,-40},{-10,
          -40},{-10,-4},{18,-4}}, color={0,0,127}));
  connect(opeMod.y, zonToAhu.uOpeMod) annotation (Line(points={{-58,80},{0,80},{
          0,9},{18,9}}, color={255,127,0}));
  connect(minOAFlo.y, zonToAhu.VMinOA_flow) annotation (Line(points={{-58,-80},{
          0,-80},{0,-8},{18,-8}}, color={0,0,127}));
  connect(zonToAhu.VSumAdjPopBreZon_flow, ahu.VSumAdjPopBreZon_flow)
    annotation (Line(points={{42,8},{50,8},{50,8},{58,8}}, color={0,0,127}));
  connect(zonToAhu.VSumAdjAreBreZon_flow, ahu.VSumAdjAreBreZon_flow)
    annotation (Line(points={{42,4},{50,4},{50,4},{58,4}}, color={0,0,127}));
  connect(zonToAhu.VSumZonPri_flow, ahu.VSumZonPri_flow) annotation (Line(
        points={{42,-4},{50,-4},{50,0},{58,0}},   color={0,0,127}));
  connect(zonToAhu.uOutAirFra_max, ahu.uOutAirFra_max)
    annotation (Line(points={{42,-8},{50,-8},{50,-4},{58,-4}}, color={0,0,127}));
  connect(outAirFlo.y, ahu.VAirOut_flow) annotation (Line(points={{42,-70},{54,
          -70},{54,-8},{58,-8}}, color={0,0,127}));
annotation (
  experiment(StopTime=3600.0, Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Controls/OBC/ASHRAE/G36/AHUs/MultiZone/VAV/SetPoints/OutdoorAirFlow/ASHRAE62_1/Validation/OutdoorAirFlow.mos"
    "Simulate and plot"),
  Documentation(info="<html>
<p>
This model shows how to compose the subsequences to find the minimum outdoor
airflow setpoint of an AHU unit that serves three zones.
</p>
<ul>
<li>
The block <code>zonToAhu</code> which instantiates
<a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.ASHRAE62_1.SumZone\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.ASHRAE62_1.SumZone</a>,
finds the sum and maximum of the zone level setpoints.
</li>
<li>
The AHU level minimum outdoor airflow setpoint is then specified by block <code>ahu</code>.
See <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.ASHRAE62_1.AHU\">
Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints.OutdoorAirFlow.ASHRAE62_1.AHU</a>.
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
