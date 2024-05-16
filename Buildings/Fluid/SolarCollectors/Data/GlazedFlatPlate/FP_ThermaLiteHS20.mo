within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record FP_ThermaLiteHS20 =
    Buildings.Fluid.SolarCollectors.Data.GenericASHRAE93 (
    final A=1.97,
    final CTyp=Buildings.Fluid.SolarCollectors.Types.HeatCapacity.DryMass,
    final C=0,
    final mDry=26,
    final V=2.8/1000,
    final dp_nominal=242.65,
    final mperA_flow_nominal=0.1777,
    final incAngDat=Modelica.Units.Conversions.from_deg({0,10,20,30,40,50,60,70,80,90}),
    final incAngModDat={1.0,0.9989,0.9946,0.9836,0.9567,0.8882,0.6935,0.0,0.0,0.0},
    final y_intercept=0.762,
    final slope=-3.710) "FP - Therma-Lite, HS-20"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info = "<html>
<h4>References</h4>
<p>
Ratings data taken from the <a href=\"http://www.solar-rating.org\">
Solar Rating and Certification Corporation website</a>. SRCC# = 2012047A.
</p>
</html>"));
