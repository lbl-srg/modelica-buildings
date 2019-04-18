within Buildings.Experimental.EnergyPlus.Validation;
model RefBldgSmallOffice "Validation model for six zones small office building"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air "Medium model";

  parameter String idfName=Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/Data/Experimental/EnergyPlus/Validation/RefBldgSmallOfficeNew2004_Chicago.idf")
    "Name of the IDF file";
  parameter String weaName = Modelica.Utilities.Files.loadResource(
    "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw")
    "Name of the weather file";

  Modelica.Blocks.Sources.Constant qConGai_flow(k=0) "Convective heat gain"
    annotation (Placement(transformation(extent={{-74,-10},{-54,10}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(k=0) "Radiative heat gain"
    annotation (Placement(transformation(extent={{-74,30},{-54,50}})));
  Modelica.Blocks.Routing.Multiplex3 multiplex3_1
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(k=0) "Latent heat gain"
    annotation (Placement(transformation(extent={{-74,-50},{-54,-30}})));
  ThermalZone att(
    idfName=idfName,
    weaName=weaName,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Attic") "Thermal zone"
    annotation (Placement(transformation(extent={{40,74},{80,114}})));
  ThermalZone cor(
    idfName=idfName,
    weaName=weaName,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Core_ZN") "Thermal zone"
    annotation (Placement(transformation(extent={{40,28},{80,68}})));
  ThermalZone sou(
    idfName=idfName,
    weaName=weaName,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Perimeter_ZN_1") "Thermal zone"
    annotation (Placement(transformation(extent={{40,-18},{80,22}})));
  ThermalZone eas(
    idfName=idfName,
    weaName=weaName,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Perimeter_ZN_2") "Thermal zone"
    annotation (Placement(transformation(extent={{40,-64},{80,-24}})));
  ThermalZone nor(
    idfName=idfName,
    weaName=weaName,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Perimeter_ZN_3") "Thermal zone"
    annotation (Placement(transformation(extent={{40,-112},{80,-72}})));
  ThermalZone wes(
    idfName=idfName,
    weaName=weaName,
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    zoneName="Perimeter_ZN_4") "Thermal zone"
    annotation (Placement(transformation(extent={{40,-156},{80,-116}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/Data/Experimental/EnergyPlus/Validation/RefBldgSmallOffice.dat"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableName="EnergyPlus",
    columns=2:8,
    y(each unit="K", each displayUnit="degC"),
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    "Data reader with results from EnergyPlus"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));

equation
  connect(qRadGai_flow.y,multiplex3_1. u1[1])  annotation (Line(
      points={{-53,40},{-40,40},{-40,7},{-30,7}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(qConGai_flow.y,multiplex3_1. u2[1]) annotation (Line(
      points={{-53,0},{-30,0}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(multiplex3_1.u3[1],qLatGai_flow. y) annotation (Line(points={{-30,-7},
          {-40,-7},{-40,-40},{-53,-40}},color={0,0,127}));
  connect(att.qGai_flow, multiplex3_1.y)
    annotation (Line(points={{38,104},{0,104},{0,0},{-7,0}}, color={0,0,127}));
  connect(cor.qGai_flow, multiplex3_1.y)
    annotation (Line(points={{38,58},{0,58},{0,0},{-7,0}}, color={0,0,127}));
  connect(multiplex3_1.y, sou.qGai_flow)
    annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}}, color={0,0,127}));
  connect(eas.qGai_flow, multiplex3_1.y) annotation (Line(points={{38,-34},{20,-34},
          {20,0},{-7,0}}, color={0,0,127}));
  connect(nor.qGai_flow, multiplex3_1.y)
    annotation (Line(points={{38,-82},{0,-82},{0,0},{-7,0}}, color={0,0,127}));
  connect(multiplex3_1.y, wes.qGai_flow) annotation (Line(points={{-7,0},{0,0},{
          0,-126},{38,-126}}, color={0,0,127}));
  annotation (Documentation(info="<html>
<p>
Simple test case for one buildings with two thermal zones.
</p>
</html>", revisions="<html>
<ul><li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/EnergyPlus/Validation/RefBldgSmallOffice.mos"
        "Simulate and plot"),
experiment(
      StopTime=604800,
      Tolerance=1e-06),
    Diagram(coordinateSystem(extent={{-100,-160},{160,120}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end RefBldgSmallOffice;
