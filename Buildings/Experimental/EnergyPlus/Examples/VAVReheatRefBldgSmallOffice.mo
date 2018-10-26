within Buildings.Experimental.EnergyPlus.Examples;
model VAVReheatRefBldgSmallOffice
  "Six zones small office building with VAV reheat"
  extends Buildings.Examples.VAVReheat.ASHRAE2006(
    AFloCor = 149.657 "Floor area, assigned to avoid non-literal value for nominal attribute of variables",
    AFloSou = 113.45,
    AFloNor = 113.45,
    AFloWes = 67.3,
    AFloEas = 67.3,
    redeclare Buildings.Experimental.EnergyPlus.Examples.BaseClasses.Floor flo);

  parameter String idfName=Modelica.Utilities.Files.loadResource(
  "modelica://Buildings/Resources/Data/Experimental/EnergyPlus/Validation/RefBldgSmallOfficeNew2004_Chicago.idf")
    "Name of the IDF file";
  parameter String weaName = Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")
    "Name of the weather file";

  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{1200,560},{1220,580}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{1200,600},{1220,620}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{1246,560},{1266,580}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{1200,520},{1220,540}})));
  ThermalZone att(
    idfName=idfName,
    weaName=weaName,
    redeclare package Medium = MediumA,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Attic") "Thermal zone"
    annotation (Placement(transformation(extent={{1296,540},{1336,580}})));

equation
  connect(qRadGai_flow.y,multiplex3_1. u1[1])  annotation (Line(
      points={{1221,610},{1234,610},{1234,577},{1244,577}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1. u2[1]) annotation (Line(
      points={{1221,570},{1244,570}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.u3[1],qLatGai_flow. y) annotation (Line(points={{1244,563},
          {1232,563},{1232,530},{1221,530}},
                                        color={0,0,127}));
  connect(att.qGai_flow, multiplex3_1.y)
    annotation (Line(points={{1294,570},{1267,570}},         color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Test case with VAV reheat model and small office reference buildings.
</p>
</html>", revisions="<html>
<ul><li>
April 11, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/EnergyPlus/Examples/VAVReheatRefBldgSmallOffice.mos"
        "Simulate and plot"),
experiment(
      StopTime=172800,
      Tolerance=1e-06),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-380,-380},{
            1400,640}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end VAVReheatRefBldgSmallOffice;
