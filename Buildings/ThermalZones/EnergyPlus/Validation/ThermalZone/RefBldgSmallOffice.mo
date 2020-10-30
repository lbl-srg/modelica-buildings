within Buildings.ThermalZones.EnergyPlus.Validation.ThermalZone;
model RefBldgSmallOffice
  "Validation model for six zones small office building"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Air
    "Medium model";
  inner Building building(
    idfName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Validation/RefBldgSmallOffice/RefBldgSmallOfficeNew2004_Chicago.idf"),
    weaName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Building model"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Sources.Constant qConGai_flow(
    k=0)
    "Convective heat gain"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Modelica.Blocks.Sources.Constant qRadGai_flow(
    k=0)
    "Radiative heat gain"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Routing.Multiplex3 mul
    "Multiplex for gains"
    annotation (Placement(transformation(extent={{-28,-10},{-8,10}})));
  Modelica.Blocks.Sources.Constant qLatGai_flow(
    k=0)
    "Latent heat gain"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone att(
    redeclare package Medium=Medium,
    zoneName="Attic")
    "Thermal zone"
    annotation (Placement(transformation(extent={{40,74},{80,114}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone cor(
    redeclare package Medium=Medium,
    zoneName="Core_ZN")
    "Thermal zone"
    annotation (Placement(transformation(extent={{40,28},{80,68}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone sou(
    redeclare package Medium=Medium,
    zoneName="Perimeter_ZN_1")
    "Thermal zone"
    annotation (Placement(transformation(extent={{40,-18},{80,22}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone eas(
    redeclare package Medium=Medium,
    zoneName="Perimeter_ZN_2")
    "Thermal zone"
    annotation (Placement(transformation(extent={{40,-64},{80,-24}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone nor(
    redeclare package Medium=Medium,
    zoneName="Perimeter_ZN_3")
    "Thermal zone"
    annotation (Placement(transformation(extent={{40,-112},{80,-72}})));
  Buildings.ThermalZones.EnergyPlus.ThermalZone wes(
    redeclare package Medium=Medium,
    zoneName="Perimeter_ZN_4")
    "Thermal zone"
    annotation (Placement(transformation(extent={{40,-156},{80,-116}})));
  Modelica.Blocks.Sources.CombiTimeTable datRea(
    tableOnFile=true,
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus/Validation/RefBldgSmallOffice/RefBldgSmallOfficeNew2004_Chicago.dat"),
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    tableName="EnergyPlus",
    columns=2:9,
    extrapolation=Modelica.Blocks.Types.Extrapolation.HoldLastPoint)
    "Data reader with results from EnergyPlus"
    annotation (Placement(transformation(extent={{-80,-120},{-60,-100}})));
  Modelica.SIunits.Temperature TOutEP=datRea.y[1]+273.15
    "Outside air temperature of EnergyPlus simulation";
  Real relHumEP(
    unit="1")=datRea.y[2]/100
    "Outside air relative humidity of EnergyPlus simulation";
  Modelica.SIunits.Temperature TAttEP=datRea.y[3]+273.15
    "Attic air temperature of EnergyPlus simulation";
  Modelica.SIunits.Temperature TCorEP=datRea.y[4]+273.15
    "Core zone air temperature of EnergyPlus simulation";
  Modelica.SIunits.Temperature TSouEP=datRea.y[5]+273.15
    "South zone air temperature of EnergyPlus simulation";
  Modelica.SIunits.Temperature TEasEP=datRea.y[6]+273.15
    "East zone air temperature of EnergyPlus simulation";
  Modelica.SIunits.Temperature TNorEP=datRea.y[7]+273.15
    "North zone air temperature of EnergyPlus simulation";
  Modelica.SIunits.Temperature TWesEP=datRea.y[8]+273.15
    "West zone air temperature of EnergyPlus simulation";
equation
  connect(qRadGai_flow.y,mul.u1[1])
    annotation (Line(points={{-59,40},{-40,40},{-40,7},{-30,7}},color={0,0,127},smooth=Smooth.None));
  connect(qConGai_flow.y,mul.u2[1])
    annotation (Line(points={{-59,0},{-30,0}},color={0,0,127},smooth=Smooth.None));
  connect(mul.u3[1],qLatGai_flow.y)
    annotation (Line(points={{-30,-7},{-40,-7},{-40,-40},{-59,-40}},color={0,0,127}));
  connect(att.qGai_flow,mul.y)
    annotation (Line(points={{38,104},{0,104},{0,0},{-7,0}},color={0,0,127}));
  connect(cor.qGai_flow,mul.y)
    annotation (Line(points={{38,58},{0,58},{0,0},{-7,0}},color={0,0,127}));
  connect(mul.y,sou.qGai_flow)
    annotation (Line(points={{-7,0},{20,0},{20,12},{38,12}},color={0,0,127}));
  connect(eas.qGai_flow,mul.y)
    annotation (Line(points={{38,-34},{20,-34},{20,0},{-7,0}},color={0,0,127}));
  connect(nor.qGai_flow,mul.y)
    annotation (Line(points={{38,-82},{0,-82},{0,0},{-7,0}},color={0,0,127}));
  connect(mul.y,wes.qGai_flow)
    annotation (Line(points={{-7,0},{0,0},{0,-126},{38,-126}},color={0,0,127}));
  annotation (
    Documentation(
      info="<html>
<p>
Validation of free floating temperatures.
The model uses the small office building of the DOE Reference Buildings.
The Modelica model is in free floating mode, and the data reader <code>datRea</code>
outputs, for comparison, the free floating room temperatures that were
obtained from an EnergyPlus simulation.
</p>
</html>",
      revisions="<html>
<ul><li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus/Validation/ThermalZone/RefBldgSmallOffice.mos" "Simulate and plot"),
    experiment(
      StopTime=604800,
      Tolerance=1e-06),
    Diagram(
      coordinateSystem(
        extent={{-100,-160},{160,120}})),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}})));
end RefBldgSmallOffice;
