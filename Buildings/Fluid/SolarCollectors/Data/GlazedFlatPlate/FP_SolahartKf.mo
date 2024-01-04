within Buildings.Fluid.SolarCollectors.Data.GlazedFlatPlate;
record FP_SolahartKf =
    Buildings.Fluid.SolarCollectors.Data.GenericASHRAE93 (
    final A=2.003,
    final CTyp=Buildings.Fluid.SolarCollectors.Types.HeatCapacity.DryMass,
    final mDry=42,
    final V=3.8/1000,
    final dp_nominal=93.89,
    final mperA_flow_nominal=0.0194,
    final b0=-0.137,
    final b1=0.0166,
    final y_intercept=0.775,
    final slope=-5.103) "FP - Solahart Kf"
    annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datSolCol",
Documentation(info = "<html>
<h4>References</h4>
<p>
Ratings data taken from the <a href=\"http://www.solar-rating.org\">
Solar Rating and Certification Corporation website</a>. SRCC# = 2012021A.<br/>
</p>
</html>"));
