within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Examples;
model ChillerOnly
  "Example of the ETS model with heat recovery chiller"
  extends Validation.BaseClasses.PartialChillerBorefield(
    QCoo_flow_nominal=Experimental.DistrictHeatingCooling.SubStations.VaporCompression.BaseClasses.getPeakLoad(
      string="#Peak space cooling load",
      filNam=Modelica.Utilities.Files.loadResource(filNam)),
    QHea_flow_nominal=Experimental.DistrictHeatingCooling.SubStations.VaporCompression.BaseClasses.getPeakLoad(
    string="#Peak space heating load",
    filNam=Modelica.Utilities.Files.loadResource(filNam)),
    ets(kHot=0.1, Ti=600));

  parameter String filNam=
    "modelica://Buildings/Applications/DHC/Loads/Examples/Resources/MediumOffice-90.1-2010-5A.mos"
    "File name with thermal loads as time series";
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    tableName="tab1",
    fileName=Modelica.Utilities.Files.loadResource(filNam),
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    y(each unit="W"),
    offset={0,0,0},
    columns={2,3,4},
    smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1)
    "Reader for thermal loads (y[1] is cooling load, y[2] is heating load)"
    annotation (Placement(transformation(extent={{-330,150},{-310,170}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain loaNorHea(final k=1/ets.QHeaWat_flow_nominal)
    "Normalize by nominal" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-278,60})));
  Buildings.Controls.OBC.CDL.Continuous.Gain loaNorCoo(final k=1/ets.QChiWat_flow_nominal)
    "Normalize by nominal" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={298,60})));
equation
  connect(loa.y[2], loaNorHea.u) annotation (Line(points={{-309,160},{-300,160},
          {-300,60},{-290,60}},                         color={0,0,127}));
  connect(loa.y[1], loaNorCoo.u) annotation (Line(points={{-309,160},{320,160},{
          320,60},{310,60}},                          color={0,0,127}));
  connect(loaNorHea.y, heaLoaNor.u)
    annotation (Line(points={{-266,60},{-252,60}}, color={0,0,127}));
  connect(loaNorCoo.y, loaCooNor.u)
    annotation (Line(points={{286,60},{272,60}}, color={0,0,127}));
  annotation (
  __Dymola_Commands(file=
"modelica://Buildings/Resources/Scripts/Dymola/Applications/DHC/EnergyTransferStations/Combined/Generation5/Examples/ChillerOnly.mos"
"Simulate and plot"),
 Documentation(
revisions="<html>
<ul>
<li>
July xx, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This model validates 
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.ChillerBorefield</a>
in a system configuration with no geothermal borefield. 
</p>
<ul>
<li>
A load profile based on building energy simulation is used to represent realistic
operating conditions.
</li>
<li>
The district water supply temperature is constant.
</li>
<li>
The building distribution pumps are variable speed and the flow rate
is considered to vary linearly with the load (with no inferior limit).
</li>
<li>
The Boolean enable signals for heating and cooling typically provided 
by the building automation system are here computed
as false if the load if lower than 1% of the nominal load for more than 300s.
</li>
<li>
Simplified chiller performance data are used, which only represent a linear 
variation of the EIR with the evaporator outlet temperature and the
condenser inlet temperature (the capacity is fixed and
no variation of the performance at part load is considered).
</li>
</ul>
</html>"));
end ChillerOnly;
