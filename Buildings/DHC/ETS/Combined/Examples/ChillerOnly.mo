within Buildings.DHC.ETS.Combined.Examples;
model ChillerOnly
  "Example of the ETS model with heat recovery chiller"
  extends Buildings.DHC.ETS.Combined.Validation.BaseClasses.PartialChillerBorefield(
    TDisWatSup(
      table=[
        0,11;
        1,12;
        2,13;
        3,14;
        4,15;
        5,16;
        6,17;
        7,18;
        8,20;
        9,18;
        10,16;
        11,13;
        12,11],
      timeScale=2592000),
    loa(
      tableOnFile=true,
      fileName=Modelica.Utilities.Files.loadResource(
        filNam),
      timeScale=1),
    QCoo_flow_nominal=Buildings.DHC.Loads.BaseClasses.getPeakLoad(
      string="#Peak space cooling load",
      filNam=Modelica.Utilities.Files.loadResource(filNam)),
    QHea_flow_nominal=Buildings.DHC.Loads.BaseClasses.getPeakLoad(
      string="#Peak space heating load",
      filNam=Modelica.Utilities.Files.loadResource(filNam)));
  parameter String filNam="modelica://Buildings/Resources/Data/DHC/Loads/Examples/MediumOffice-90.1-2010-5A.mos"
    "File name with thermal loads as time series";
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter loaNorHea(
    final k=1/ets.QHeaWat_flow_nominal)
    "Normalize by nominal" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-278,60})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter loaNorCoo(
    final k=1/ets.QChiWat_flow_nominal) "Normalize by nominal" annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={298,60})));
equation
  connect(loa.y[2],loaNorHea.u)
    annotation (Line(points={{-309,160},{-300,160},{-300,60},{-290,60}},color={0,0,127}));
  connect(loa.y[1],loaNorCoo.u)
    annotation (Line(points={{-309,160},{320,160},{320,60},{310,60}},color={0,0,127}));
  connect(loaNorHea.y,heaLoaNor.u)
    annotation (Line(points={{-266,60},{-252,60}},color={0,0,127}));
  connect(loaNorCoo.y,loaCooNor.u)
    annotation (Line(points={{286,60},{272,60}},color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/ETS/Combined/Examples/ChillerOnly.mos" "Simulate and plot"),
    experiment(
      StartTime=6.5E6,
      StopTime=7E6,
      Tolerance=1e-06),
    Documentation(
      revisions="<html>
<ul>
<li>
November 22, 2024, by Michael Wetter:<br/>
Removed duplicate connection.
</li>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.DHC.ETS.Combined.ChillerBorefield\">
Buildings.DHC.ETS.Combined.ChillerBorefield</a>
in a system configuration with no geothermal borefield.
</p>
<ul>
<li>
A load profile based on a whole building energy simulation is used to
represent realistic operating conditions.
</li>
<li>
The district water supply temperature varies on a monthly basis, with
a minimum in January and a maximum in August.
</li>
<li>
The other modeling assumptions are described in
<a href=\"modelica://Buildings.DHC.ETS.Combined.Validation.BaseClasses.PartialChillerBorefield\">
Buildings.DHC.ETS.Combined.Validation.BaseClasses.PartialChillerBorefield</a>.
</li>
</ul>
</html>"));
end ChillerOnly;
