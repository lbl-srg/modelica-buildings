within Buildings.DHC.Examples.Combined;
model SeriesConstantFlow
  "Example of series connection with constant district water mass flow rate"
  extends Buildings.DHC.Examples.Combined.BaseClasses.PartialSeries(redeclare
      Buildings.DHC.Loads.Combined.BuildingTimeSeriesWithETS bui[nBui](final filNam=filNam),
      datDes(
      mPumDis_flow_nominal=95,
      mPipDis_flow_nominal=95,
      dp_length_nominal=69.3,
      epsPla=0.935),
    pumSto(dp_nominal=30000));
  parameter String filNam[nBui]={
    "modelica://Buildings/Resources/Data/DHC/Loads/Examples/SwissOffice_20190916.mos",
    "modelica://Buildings/Resources/Data/DHC/Loads/Examples/SwissResidential_20190916.mos",
    "modelica://Buildings/Resources/Data/DHC/Loads/Examples/SwissHospital_20190916.mos"}
    "Library paths of the files with thermal loads as time series";
  Modelica.Blocks.Sources.Constant masFloMaiPum(
    k=datDes.mPumDis_flow_nominal)
    "Distribution pump mass flow rate"
    annotation (Placement(transformation(extent={{-280,-70},{-260,-50}})));
  Modelica.Blocks.Sources.Constant masFloDisPla(
    k=datDes.mPla_flow_nominal)
    "District water flow rate to plant"
    annotation (Placement(transformation(extent={{-250,10},{-230,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THotWatSupSet[nBui](
    k=fill(63 + 273.15, nBui))
    "Hot water supply temperature set point"
    annotation (Placement(transformation(extent={{-336,172},{-316,192}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TColWat[nBui](
    k=fill(15 + 273.15, nBui))
    "Cold water temperature"
    annotation (Placement(transformation(extent={{-298,150},{-278,170}})));
  Networks.Distribution1Pipe_R dis(
    redeclare final package Medium = Medium,
    final nCon=nBui,
    show_TOut=true,
    final mDis_flow_nominal=datDes.mPipDis_flow_nominal,
    final mCon_flow_nominal=datDes.mCon_flow_nominal,
    final dp_length_nominal=datDes.dp_length_nominal,
    final lDis=datDes.lDis,
    final lEnd=datDes.lEnd,
    final allowFlowReversal=allowFlowReversalSer) "Distribution network"
    annotation (Placement(transformation(extent={{-20,130},{20,150}})));
  Modelica.Blocks.Sources.Constant TSewWat(k=273.15 + 17)
    "Sewage water temperature"
    annotation (Placement(transformation(extent={{-312,30},{-292,50}})));
equation
  connect(masFloMaiPum.y, pumDis.m_flow_in) annotation (Line(points={{-259,-60},
          {60,-60},{60,-60},{68,-60}}, color={0,0,127}));
  connect(pumSto.m_flow_in, masFloMaiPum.y) annotation (Line(points={{-180,-68},
          {-180,-60},{-259,-60}}, color={0,0,127}));
  connect(masFloDisPla.y, pla.mPum_flow) annotation (Line(points={{-229,20},{
          -184,20},{-184,4.66667},{-161.333,4.66667}},
                                  color={0,0,127}));
  connect(THotWatSupSet.y, bui.THotWatSupSet) annotation (Line(points={{-314,
          182},{-14,182},{-14,183},{-12,183}}, color={0,0,127}));
  connect(TColWat.y, bui.TColWat) annotation (Line(points={{-276,160},{-8,160},
          {-8,168}},                    color={0,0,127}));
  connect(TDisWatSup.port_b, dis.port_aDisSup) annotation (Line(points={{-80,30},
          {-80,140},{-20,140}},                    color={0,127,255}));
  connect(dis.port_bDisSup, TDisWatRet.port_a)
    annotation (Line(points={{20,140},{80,140},{80,10}}, color={0,127,255}));
  connect(TSewWat.y, pla.TSewWat) annotation (Line(points={{-291,40},{-174,40},
          {-174,7.33333},{-161.333,7.33333}},                     color={0,0,
          127}));
  connect(bui.port_bSerAmb, dis.ports_aCon) annotation (Line(points={{10,180},{
          20,180},{20,150},{12,150}}, color={0,127,255}));
  connect(dis.ports_bCon, bui.port_aSerAmb) annotation (Line(points={{-12,150},
          {-20,150},{-20,180},{-10,180}}, color={0,127,255}));
  annotation (
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{360,260}})),
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Examples/Combined/SeriesConstantFlow.mos"
  "Simulate and plot"),
  experiment(
      StopTime=604800,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This is a model of a so-called \"reservoir network\" (Sommer 2020), i.e., a fifth
generation district system with unidirectional mass flow rate in the
district loop, and energy transfer stations connected in series.
In this model, the temperature of the district loop is stabilized through
the operation of the plant and the borefield.
The main circulation pump has a constant mass flow rate.
Each substation takes water from the main district loop and feeds its return water back
into the main district loop downstream from the intake.
The pipes of the main loop are designed for a pressure drop of
<code>dpDis_length_nominal=250</code> Pa/m at the design flow rate.
</p>
<h4>References</h4>
<p>
Sommer T., Sulzer M., Wetter M., Sotnikov A., Mennel S., Stettler C.
<i>The reservoir network: A new network topology for district heating
and cooling.</i>
Energy, Volume 199, 15 May 2020, 117418.
</p>
</html>", revisions="<html>
<ul>
<li>
December 12, 2023, by Ettore Zanetti:<br/>
Updated partial class, this is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3431\">issue 3431</a>.
</li>
<li>
February 23, 2021, by Antoine Gautier:<br/>
Refactored with base classes from the <code>DHC</code> package.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1769\">
issue 1769</a>.
</li>
<li>
January 12, 2020, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end SeriesConstantFlow;
