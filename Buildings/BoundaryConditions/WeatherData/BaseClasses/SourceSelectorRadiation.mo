within Buildings.BoundaryConditions.WeatherData.BaseClasses;
block SourceSelectorRadiation
  "Block that selects the solar radiation source and outputs the solar radiation quantities"
  extends Modelica.Blocks.Icons.Block;
  parameter Buildings.BoundaryConditions.Types.RadiationDataSource datSou "Data source"
    annotation(Evaluate=true);

  Modelica.Blocks.Interfaces.RealInput HDirNorFil(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2")
   if datSou == Buildings.BoundaryConditions.Types.RadiationDataSource.File
    "Direct normal solar irradiation from weather data file" annotation (Placement(transformation(extent={{-140,
            -10},{-100,30}}), iconTransformation(extent={{-120,10},{-100,30}})));

  Modelica.Blocks.Interfaces.RealInput HDirNorIn(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2")
   if datSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor or
      datSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor
    "Direct normal solar irradiation from input connector" annotation (Placement(transformation(extent={{-140,
            -40},{-100,0}}),  iconTransformation(extent={{-120,-30},{-100,-10}})));

  Modelica.Blocks.Interfaces.RealInput HDifHorFil(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2")
  if datSou == Buildings.BoundaryConditions.Types.RadiationDataSource.File
    "Diffuse horizontal solar irradiation from weather data file" annotation (Placement(transformation(
          extent={{-140,60},{-100,100}}), iconTransformation(extent={{-120,80},{
            -100,100}})));

  Modelica.Blocks.Interfaces.RealInput HDifHorIn(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2")
  if datSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor or
     datSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor
    "Diffuse horizontal solar irradiation from input connector" annotation (Placement(transformation(
          extent={{-140,30},{-100,70}}),  iconTransformation(extent={{-120,50},{
            -100,70}})));

  Modelica.Blocks.Interfaces.RealInput HGloHorFil(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2")
   if datSou == Buildings.BoundaryConditions.Types.RadiationDataSource.File
    "Global horizontal solar irradiation from weather data file" annotation (Placement(transformation(extent={{-140,
            -70},{-100,-30}}),        iconTransformation(extent={{-120,-70},{-100,
            -50}})));

  Modelica.Blocks.Interfaces.RealInput HGloHorIn(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2")
   if datSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor or
      datSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor
    "Global horizontal solar irradiation from input connector" annotation (Placement(transformation(extent={{-140,
            -98},{-100,-58}}),        iconTransformation(extent={{-120,-100},{-100,
            -80}})));

  Modelica.Blocks.Interfaces.RealInput zen(
    final quantity="Angle",
    final unit="rad")
    "Zenith angle"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,-120}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-60,-110})));

  Modelica.Blocks.Interfaces.RealOutput HDirNor(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2")
    "Direct normal solar irradiation" annotation (Placement(
        transformation(extent={{100,-10},{120,10}}), iconTransformation(extent={{100,-10},
            {120,10}})));
  Modelica.Blocks.Interfaces.RealOutput HDifHor(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2")
    "Diffuse horizontal solar irradiation" annotation (Placement(
        transformation(extent={{100,60},{120,80}}),  iconTransformation(extent={{100,68},
            {120,88}})));
  Modelica.Blocks.Interfaces.RealOutput HGloHor(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2")
    "Global horizontal solar irradiation" annotation (Placement(
        transformation(extent={{100,-80},{120,-60}}),iconTransformation(extent={{100,-90},
            {120,-70}})));

protected
  constant Real epsCos = 1e-6 "Small value to avoid division by 0";
  constant Modelica.Units.SI.HeatFlux solCon=1367.7 "Solar constant";

  // Conditional connectors
  Modelica.Blocks.Interfaces.RealInput HGloHor_in_internal(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput HDifHor_in_internal(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "Needed to connect to conditional connector";
  Modelica.Blocks.Interfaces.RealInput HDirNor_in_internal(
    final quantity="RadiantEnergyFluenceRate",
    final unit="W/m2") "Needed to connect to conditional connector";

equation
  // Conditional connect statements
  connect(HGloHor_in_internal, HGloHorFil);
  connect(HDifHor_in_internal, HDifHorFil);
  connect(HDirNor_in_internal, HDirNorFil);
  connect(HGloHor_in_internal, HGloHorIn);
  connect(HDifHor_in_internal, HDifHorIn);
  connect(HDirNor_in_internal, HDirNorIn);

  //---------------------------------------------------------------------------
  // Select global horizontal radiation connector
  if datSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HDifHor then
    HGloHor = max(0, HDirNor_in_internal*cos(zen)+HDifHor_in_internal)
      "Calculate the HGloHor using HDirNor and HDifHor according to (A.4.14) and (A.4.15)";
    HGloHor_in_internal = 0;
  else
    HGloHor = max(0, HGloHor_in_internal)
      "Get HGloHor using weather data file or input connector of weather data reader";
  end if;

  //---------------------------------------------------------------------------
  // Select diffuse horizontal radiation connector
  if datSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HDirNor_HGloHor then
    HDifHor = max(0, HGloHor_in_internal - HDirNor_in_internal*cos(zen))
      "Calculate the HGloHor using HDirNor and HDifHor according to (A.4.14) and (A.4.15)";
    HDifHor_in_internal = 0;
  else
    HDifHor = max(0, HDifHor_in_internal)
      "Get HDifHor using weather data file or input connector of weather data reader";
  end if;

  //---------------------------------------------------------------------------
  // Select direct normal radiation connector
  if datSou == Buildings.BoundaryConditions.Types.RadiationDataSource.Input_HGloHor_HDifHor then
      HDirNor = max(0, min(
        solCon,
        (HGloHor_in_internal -HDifHor_in_internal)*
          Buildings.Utilities.Math.Functions.spliceFunction(
            x=cos(zen),
            pos=Buildings.Utilities.Math.Functions.inverseXRegularized(cos(zen), epsCos),
            neg=0,
            deltax=epsCos)))
      "Calculate the HDirNor using HGloHor and HDifHor according to (A.4.14) and (A.4.15)";
    HDirNor_in_internal = 0;
  else
    HDirNor = max(0, HDirNor_in_internal)
      "Get HDirNor using weather data file or input connector of weather data reader";
  end if;

  annotation (
  defaultComponentName="souSel",
Documentation(info="<html>
<p>
Block that outputs the direct normal, diffuse horizontal and diffuse global
solar irradiation.
This block computes these output quantities based on conditionally provided
input signals.
</p>
<p>
The computations are based on Wetter (2004).
</p>
<h4>References</h4>
<ul>
<li>
Michael Wetter.<br/>
<a href=\"http://simulationresearch.lbl.gov/wetter/download/mwdiss.pdf\">
Simulation-based Building Energy Optimization</a>.<br/>
Dissertation. University of California at Berkeley. 2004.
</li>
</ul>
</html>", revisions="<html>
<ul>
<li>
April 14, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={
      Rectangle(
          extent={{-100,100},{100,-100}},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid,
          borderPattern=BorderPattern.Raised),
        Line(points={{12,0},{100,0}},
          color={0,0,127}),
        Line(points={{40,-80},{100,-80},{100,-80}},
          color={0,0,127}),
        Line(points={{40,80},{100,78}},
          color={0,0,127}),
        Line(points={{6,0},{40,-82},{40,-80}},
          color={0,0,127}),
        Line(points={{40,80},{6,0},{6,0}},
          color={0,0,127}),
        Ellipse(lineColor={0,0,255},
          pattern=LinePattern.None,
          fillPattern=FillPattern.Solid,
          extent={{-2,-8},{14,8}})}));
end SourceSelectorRadiation;
