within Buildings.DHC.Plants.Combined.Controls.BaseClasses.Validation;
model StagingPlant "Validation of plant staging block"
  extends Modelica.Icons.Example;

  parameter Integer nChi(final min=1, start=1)=2
    "Number of units operating at design conditions"
    annotation (Dialog(group="CHW loop and cooling-only chillers"),
      Evaluate=true);
  parameter Real QChiWatChi_flow_nominal(
    unit="W",
    quantity="HeatFlowRate")=-4.4E6
    "Cooling design heat flow rate of cooling-only chillers (all units)"
    annotation (Dialog(group="CHW loop and cooling-only chillers"));
  parameter Integer nChiHea(final min=1, start=1)=3
    "Number of units operating at design conditions"
    annotation (Dialog(group="HW loop and heat recovery chillers"),
      Evaluate=true);
  parameter Real PLRStaTra(final unit="1", final min=0, final max=1) = 0.85
    "Part load ratio triggering stage transition";
  parameter Real QChiWatCasCoo_flow_nominal(
    unit="W",
    quantity="HeatFlowRate")=-6E6
    "Cooling design heat flow rate of HRC in cascading cooling mode (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  parameter Real QHeaWat_flow_nominal(
    unit="W",
    quantity="HeatFlowRate")=6.4E6
    "Heating design heat flow rate (all units)"
    annotation (Dialog(group="HW loop and heat recovery chillers"));
  final parameter Real mChiWat_flow_nominal(
    unit="W",
    quantity="HeatFlowRate")=abs(QChiWatChi_flow_nominal+QChiWatCasCoo_flow_nominal)/
                             Buildings.Utilities.Psychrometrics.Constants.cpWatLiq / 5
    "CHW design mass flow rate"
    annotation (Dialog(group="CHW loop and cooling-only chillers"));
  final parameter Real mHeaWat_flow_nominal(
    unit="W",
    quantity="HeatFlowRate")=QHeaWat_flow_nominal/
                             Buildings.Utilities.Psychrometrics.Constants.cpWatLiq / 10
    "HW design mass flow rate"
    annotation (Dialog(group="HW loop and heat recovery chillers"));

  Buildings.DHC.Plants.Combined.Controls.BaseClasses.StagingPlant
    staChi(
    final nChi=nChi,
    final nChiHea=nChiHea,
    final QChiWatChi_flow_nominal=QChiWatChi_flow_nominal,
    final QChiWatCasCoo_flow_nominal=QChiWatCasCoo_flow_nominal,
    final QChiWatCasCoo_flow_nominal_approx=QChiWatCasCoo_flow_nominal,
    final QHeaWat_flow_nominal=QHeaWat_flow_nominal) "Chiller staging block"
    annotation (Placement(transformation(extent={{80,-16},{100,16}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.TimeTable ratFlo(table=[0,0,0; 1,
        0,0; 4,0.3,0.1; 5,1,0.1; 10,0.1,0.1; 13,1,0.3; 16,0.3,1;20,0.1,0.1; 24,0.1,0.3; 25,
        0.1,1; 30,0,0],
    timeScale=1000) "Source signal"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(k=7 + 273.15)
    "Source signal"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatPriRet(k=12 + 273.15)
    "Source signal"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupSet(k=60 + 273.15)
    "Source signal"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatPriRet(k=50 + 273.15)
    "Source signal"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter sca(
    final k=mChiWat_flow_nominal) "Scale signal"
    annotation (Placement(transformation(extent={{-20,30},{0,50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter sca1(
    final k=mHeaWat_flow_nominal)
    "Scale signal"
    annotation (Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant dpSet(k=20E4)
    "Source signal"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.CivilTime civTim
    "Model time"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
  Buildings.Controls.OBC.CDL.Reals.GreaterThreshold greThr
    "Enable"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
equation
  connect(TChiWatSupSet.y, staChi.TChiWatSupSet) annotation (Line(points={{-38,-20},
          {30,-20},{30,8},{78,8}}, color={0,0,127}));
  connect(THeaWatPriRet.y, staChi.THeaWatPriRet) annotation (Line(points={{-78,-80},
          {70,-80},{70,-10},{78,-10}}, color={0,0,127}));
  connect(THeaWatSupSet.y, staChi.THeaWatSupSet) annotation (Line(points={{-38,-60},
          {60,-60},{60,-6},{78,-6}}, color={0,0,127}));
  connect(TChiWatPriRet.y, staChi.TChiWatPriRet) annotation (Line(points={{-78,-40},
          {40,-40},{40,4},{78,4}}, color={0,0,127}));
  connect(sca.y, staChi.mChiWatPri_flow)
    annotation (Line(points={{2,40},{60,40},{60,10},{78,10}}, color={0,0,127}));
  connect(sca1.y, staChi.mHeaWatPri_flow) annotation (Line(points={{2,0},{20,0},
          {20,-4},{78,-4}}, color={0,0,127}));
  connect(TChiWatSupSet.y, staChi.TChiWatSup) annotation (Line(points={{-38,-20},
          {30,-20},{30,6},{78,6}}, color={0,0,127}));
  connect(dpSet.y, staChi.dpChiWat) annotation (Line(points={{-38,-100},{50,-100},
          {50,0},{78,0}}, color={0,0,127}));
  connect(dpSet.y, staChi.dpChiWatSet) annotation (Line(points={{-38,-100},{50,-100},
          {50,2},{78,2}}, color={0,0,127}));
  connect(dpSet.y, staChi.dpHeaWatSet) annotation (Line(points={{-38,-100},{50,-100},
          {50,-12},{78,-12}}, color={0,0,127}));
  connect(dpSet.y, staChi.dpHeaWat) annotation (Line(points={{-38,-100},{50,-100},
          {50,-14},{78,-14}}, color={0,0,127}));
  connect(THeaWatSupSet.y, staChi.THeaWatSup) annotation (Line(points={{-38,-60},
          {60,-60},{60,-8},{78,-8}}, color={0,0,127}));
  connect(ratFlo.y[1], sca.u) annotation (Line(points={{-78,20},{-40,20},{-40,40},
          {-22,40}}, color={0,0,127}));
  connect(ratFlo.y[2], sca1.u)
    annotation (Line(points={{-78,20},{-40,20},{-40,0},{-22,0}}, color={0,0,127}));
  connect(civTim.y, greThr.u)
    annotation (Line(points={{-58,80},{-42,80}}, color={0,0,127}));
  connect(greThr.y, staChi.u1Coo) annotation (Line(points={{-18,80},{70,80},{70,
          14.2},{78,14.2}}, color={255,0,255}));
  connect(greThr.y, staChi.u1Hea) annotation (Line(points={{-18,80},{70,80},{70,
          12.2},{78,12.2}}, color={255,0,255}));
annotation (__Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Plants/Combined/Controls/BaseClasses/Validation/StagingPlant.mos"
      "Simulate and plot"),
    experiment(
      StopTime=30000,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-120,-120},{120,120}})),
    Documentation(info="<html>
<p>
This is a validation model for the plant staging logic implemented in
<a href=\"modelica://Buildings.DHC.Plants.Combined.Controls.BaseClasses.StagingPlant\">
Buildings.DHC.Plants.Combined.Controls.BaseClasses.StagingPlant</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end StagingPlant;
