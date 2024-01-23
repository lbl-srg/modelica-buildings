within Buildings.Experimental.DHC.Examples.Combined;
model SeriesVariableFlow
  "Example of series connection with variable district water mass flow rate"
  extends
    Buildings.Experimental.DHC.Examples.Combined.BaseClasses.PartialSeries(      redeclare
      Buildings.Experimental.DHC.Loads.Combined.BuildingTimeSeriesWithETS
      bui[nBui](final filNam=filNam), datDes(
      mPumDis_flow_nominal=97.3,
      mPipDis_flow_nominal=69.5,
      dp_length_nominal=69.3,
      epsPla=0.91),
    pumSto(dp_nominal=30000));
  parameter String filNam[nBui]={
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissOffice_20190916.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissResidential_20190916.mos",
    "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissHospital_20190916.mos"}
    "Library paths of the files with thermal loads as time series";
  Modelica.Blocks.Sources.Constant masFloDisPla(
    k=datDes.mPla_flow_nominal)
    "District water flow rate to plant"
    annotation (Placement(transformation(extent={{-250,10},{-230,30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THotWatSupSet[nBui](
    k=fill(63 + 273.15, nBui))
    "Hot water supply temperature set point"
    annotation (Placement(transformation(extent={{-352,170},{-332,190}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TColWat[nBui](
    k=fill(15 + 273.15, nBui))
    "Cold water temperature"
    annotation (Placement(transformation(extent={{-322,150},{-302,170}})));
  Buildings.Experimental.DHC.Networks.Controls.MainPump1Pipe conPum(
    nMix=nBui,
    nSou=2,
    nBui=nBui,
    TMin=279.15,
    TMax=290.15,
    use_temperatureShift=false) "Main pump controller"
    annotation (Placement(transformation(extent={{-280,-82},{-260,-50}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(k=datDes.mPumDis_flow_nominal)
    "Scale with nominal mass flow rate"
    annotation (Placement(transformation(extent={{-240,-70},{-220,-50}})));
  Networks.Distribution1PipeAutoSize dis(
    redeclare final package Medium = Medium,
    final nCon=nBui,
    show_TOut=true,
    final mDis_flow_nominal=datDes.mPipDis_flow_nominal,
    final mCon_flow_nominal=datDes.mCon_flow_nominal,
    final dp_length_nominal=datDes.dp_length_nominal,
    final lDis=datDes.lDis,
    final lEnd=datDes.lEnd,
    final allowFlowReversal=allowFlowReversalSer) "Distribution network"
    annotation (Placement(transformation(extent={{-22,110},{18,130}})));
  Modelica.Blocks.Sources.Constant TSewWat(k=273.15 + 17)
    "Sewage water temperature"
    annotation (Placement(transformation(extent={{-254,50},{-234,70}})));
equation
  connect(THotWatSupSet.y, bui.THotWatSupSet) annotation (Line(points={{-330,
          180},{-18,180},{-18,183},{-12,183}}, color={0,0,127}));
  connect(TColWat.y, bui.TColWat) annotation (Line(points={{-300,160},{-6,160},
          {-6,168},{-8,168}},   color={0,0,127}));
  connect(pumDis.m_flow_in, gai.y)
    annotation (Line(points={{68,-60},{-218,-60}},
                                                 color={0,0,127}));
  connect(conPum.y, gai.u)
    annotation (Line(points={{-258.462,-66},{-258.462,-60},{-242,-60}},
                                                 color={0,0,127}));
  connect(dis.TOut, conPum.TMix) annotation (Line(points={{20,114},{32,114},{32,
          100},{-300,100},{-300,-54.8},{-281.692,-54.8}},
                                         color={0,0,127}));
  connect(TDisWatRet.T, conPum.TSouIn[1]) annotation (Line(points={{69,
          7.21645e-16},{60,7.21645e-16},{60,-56},{-212,-56},{-212,-40},{-292,
          -40},{-292,-61.6},{-281.692,-61.6}},
                                            color={0,0,127}));
  connect(TDisWatBorLvg.T, conPum.TSouIn[2]) annotation (Line(points={{-91,-40},
          {-292,-40},{-292,-60.8},{-281.692,-60.8}},
                                                  color={0,0,127}));
  connect(TDisWatBorLvg.T, conPum.TSouOut[1]) annotation (Line(points={{-91,-40},
          {-292,-40},{-292,-69.6},{-281.692,-69.6}},      color={0,0,127}));
  connect(TDisWatSup.T, conPum.TSouOut[2]) annotation (Line(points={{-91,20},{
          -140,20},{-140,80},{-292,80},{-292,-68.8},{-281.692,-68.8}},
                                                   color={0,0,127}));
  connect(gai.y, pumSto.m_flow_in) annotation (Line(points={{-218,-60},{-180,-60},
          {-180,-68}}, color={0,0,127}));
  connect(masFloDisPla.y, pla.mPum_flow) annotation (Line(points={{-229,20},{
          -168,20},{-168,4.66667},{-161.333,4.66667}}, color={0,0,127}));
  connect(TSewWat.y, pla.TSewWat) annotation (Line(points={{-233,60},{-161.333,
          60},{-161.333,7.33333}},                     color={0,0,127}));
  connect(TDisWatSup.port_b, dis.port_aDisSup) annotation (Line(points={{-80,30},
          {-80,120},{-22,120}},          color={0,127,255}));
  connect(TDisWatRet.port_a, dis.port_bDisSup) annotation (Line(points={{80,10},
          {80,120},{18,120}},         color={0,127,255}));
  connect(bui.port_aSerAmb, dis.ports_bCon) annotation (Line(points={{-10,180},
          {-14,180},{-14,130}}, color={0,127,255}));
  connect(bui.port_bSerAmb, dis.ports_aCon) annotation (Line(points={{10,180},{
          20,180},{20,130},{10,130}}, color={0,127,255}));
  connect(bui.QCoo_flow, conPum.QCoo_flow) annotation (Line(points={{7,168},{7,
          140},{-318,140},{-318,-75.6},{-281.692,-75.6}}, color={0,0,127}));
  annotation (
  Diagram(
  coordinateSystem(preserveAspectRatio=false, extent={{-360,-260},{360,260}})),
    __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Examples/Combined/SeriesVariableFlow.mos"
  "Simulate and plot"),
  experiment(
      StopTime=604800,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
    Documentation(revisions="<html>
<ul>
<li>
December 12, 2023, by Ettore Zanetti:<br/>
Changed to preconfigured pump model,
This is for
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
</html>", info="<html>
<p>
This model is identical to
<a href=\"modelica://Buildings.Experimental.DHC.Examples.Combined.SeriesConstantFlow\">
Buildings.Experimental.DHC.Examples.Combined.SeriesConstantFlow</a>
except for the pipe diameter and the control of the main circulation pump.
Rather than having a constant mass flow rate, the mass flow rate is varied
based on the mixing temperatures after each agent.
If these mixing temperatures are sufficiently far away from the minimum or maximum
allowed loop temperature, then the mass flow rate is reduced to save pump energy.
</p>
</html>"));
end SeriesVariableFlow;
