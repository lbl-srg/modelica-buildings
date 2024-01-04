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
    final b0=-0.0693,
    final b1=-0.2372,
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
