within Buildings.Fluid.HeatExchangers.BaseClasses.Examples;
model DryWetCalcs "Test the DryWetCalcs model"
  extends Modelica.Icons.Example;

  // PACKAGES
  package Medium_W = Buildings.Media.Water;
  package Medium_A = Buildings.Media.Air;

  // CONSTANTS
  constant Modelica.SIunits.AbsolutePressure pAtm = 101325;

  // PARAMETERS
  // -- water
  parameter Modelica.SIunits.ThermalConductance UAWat = 9495.5;
  parameter Modelica.SIunits.Temperature TWatIn=
    Modelica.SIunits.Conversions.from_degF(42)
    "Inlet water temperature";
  parameter Modelica.SIunits.MassFlowRate masFloWat = 3.78
    "Nominal mass flow rate medium 1 (water)";
  parameter Modelica.SIunits.SpecificHeatCapacity cpWat = 4199.3604;
  // -- air
  parameter Modelica.SIunits.ThermalConductance UAAir = 9495.5;
  parameter Modelica.SIunits.Temperature TAirIn=
    Modelica.SIunits.Conversions.from_degF(80)
    "Inlet air temperature";
  parameter Modelica.SIunits.MassFlowRate masFloAir = 2.646
    "Nominal mass flow rate medium 2 (air)";
  parameter Modelica.SIunits.SpecificHeatCapacity cpAir = 1021.5792;
  parameter Modelica.SIunits.SpecificEnthalpy hAirIn=
    Medium_A.specificEnthalpy_pTX(p=pAir,T=TAirIn,X={wAirIn, 1-wAirIn});
  parameter Modelica.SIunits.AbsolutePressure pAir = pAtm;
  parameter Real wAirIn(min=0,max=1,unit="1") = 0.0089757;

  // COMPONENTS
  Buildings.Fluid.HeatExchangers.BaseClasses.DryWetCalcs2 dryWetCalcs(
    redeclare package Medium1 = Medium_W,
    redeclare package Medium2 = Medium_A,
    TWatOutNominal = TWatIn,
    cfg=Buildings.Fluid.Types.HeatExchangerConfiguration.CrossFlowStream1MixedStream2Unmixed)
    annotation (Placement(transformation(extent={{-40,-60},{60,60}})));

  Modelica.Blocks.Sources.RealExpression UAAirExp(y=UAAir)
    annotation (Placement(transformation(extent={{-100,-120},{-80,-100}})));
  Modelica.Blocks.Sources.RealExpression UAWatExp(y=UAWat)
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.RealExpression masFloAirExp(y=masFloAir)
    annotation (Placement(transformation(extent={{-100,-100},{-80,-80}})));
  Modelica.Blocks.Sources.RealExpression masFloWatExp(y=masFloWat)
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));
  Modelica.Blocks.Sources.RealExpression cpWatExp(y=cpWat)
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Modelica.Blocks.Sources.RealExpression cpAirExp(y=cpAir)
    annotation (Placement(transformation(extent={{-100,-80},{-80,-60}})));
  Modelica.Blocks.Sources.RealExpression TWatInExp(y=TWatIn)
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.RealExpression TAirInExp(y=TAirIn)
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Modelica.Blocks.Sources.RealExpression hAirInExp(y=hAirIn)
    "enthaly of air at inlet"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  Modelica.Blocks.Sources.RealExpression pAirExp(y=pAir)
    "inlet air pressure"
    annotation (Placement(transformation(extent={{-100,-20},{-80,0}})));
  Modelica.Blocks.Sources.RealExpression wAirInExp(y=wAirIn)
    "inlet humidity ratio (kg of water/kg of moist air)"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));

equation
  connect(UAWatExp.y, dryWetCalcs.UAWat) annotation (Line(points={{-79,90},{-44,
          90},{-44,55},{-36.4286,55}}, color={0,0,127}));
  connect(masFloWatExp.y, dryWetCalcs.masFloWat) annotation (Line(points={{-79,70},
          {-48,70},{-48,45},{-36.4286,45}}, color={0,0,127}));
  connect(cpWatExp.y, dryWetCalcs.cpWat) annotation (Line(points={{-79,50},{-52,
          50},{-52,35},{-36.4286,35}}, color={0,0,127}));
  connect(TWatInExp.y, dryWetCalcs.TWatIn) annotation (Line(points={{-79,30},{
          -58,30},{-58,25},{-36.4286,25}},
                                       color={0,0,127}));
  connect(wAirInExp.y, dryWetCalcs.wAirIn) annotation (Line(points={{-79,10},{
          -76,10},{-76,5},{-36.4286,5}},
                                     color={0,0,127}));
  connect(pAirExp.y, dryWetCalcs.pAir) annotation (Line(points={{-79,-10},{-74,
          -10},{-74,-5},{-36.4286,-5}}, color={0,0,127}));
  connect(hAirInExp.y, dryWetCalcs.hAirIn) annotation (Line(points={{-79,-30},{
          -70,-30},{-70,-15},{-36.4286,-15}},
                                          color={0,0,127}));
  connect(TAirInExp.y, dryWetCalcs.TAirIn) annotation (Line(points={{-79,-50},{
          -66,-50},{-66,-25},{-36.4286,-25}},
                                          color={0,0,127}));
  connect(cpAirExp.y, dryWetCalcs.cpAir) annotation (Line(points={{-79,-70},{
          -60,-70},{-60,-35},{-36.4286,-35}},
                                          color={0,0,127}));
  connect(masFloAirExp.y, dryWetCalcs.masFloAir) annotation (Line(points={{-79,-90},
          {-56,-90},{-56,-45},{-36.4286,-45}}, color={0,0,127}));
  connect(UAAirExp.y, dryWetCalcs.UAAir) annotation (Line(points={{-79,-110},{
          -52,-110},{-52,-55},{-36.4286,-55}},
                                           color={0,0,127}));
  annotation (
    experiment(StopTime=1.0),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/BaseClasses/Examples/DryWetCalcs.mos"
      "Simulate and plot"),
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-120},{100,100}})),
    Diagram(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-120},{100,100}})));
end DryWetCalcs;
