within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record FP_TRNSYSValidation =
    Buildings.Fluid.SolarCollectors.Data.GenericASHRAE93 (
    A=5,
    CTyp=Buildings.Fluid.SolarCollectors.Types.HeatCapacity.DryMass,
    C=0,
    mDry=8.6,
    V=0.6/1000,
    dp_nominal=100,
    mperA_flow_nominal=0.0111,
    incAngDat=Modelica.Units.Conversions.from_deg({0,10,20,30,40,50,60,70,80,90}),
    incAngModDat={1.0,0.9969,0.9872,0.9691,0.9389,0.8889,0.8,0.6152,0.0482,0.0},
    y_intercept=0.8,
    slope=-3.6111)
  "Default values in the TRNSYS Simulation Studio SDHW example"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info="<html>
<p>
Default values in the TRNSYS Simualtion Studio SDHW example.
No value for <code>dp_nominal</code> was provided in TRNSYS, so 100
Pascal was used as a placeholder.<br/>
</p>
</html>"));
